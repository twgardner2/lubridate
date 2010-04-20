
#' Get Daylight Savings Time indicator of a date-time.
#'
#' Date-time must be a POSIXct, POSIXlt, Date, chron, yearmon, yearqtr, zoo, 
#' zooreg, timeDate, xts, its, ti, jul, timeSeries, and fts objects. 
#'
#' A date-time's daylight savings flag can not be set because it depends on the 
#' date-time's year, month, day, and hour values.
#'
#' @aliases dst dst.default dst.zoo dst.its dst.ti dst.timeseries dst.fts dst.irts
#' @param x a date-time object   
#' @return Daylight savings time flag. Positive if in force, zero if not, negative if unknown.
#' @seealso \code{\link{DaylightSavingsTime}}
#' @keywords utilities chron methods
#' @examples
#' x <- now()
#' dst(x) 
dst <- function(x)
  UseMethod("dst")
  
dst.default <- function(x)
  as.POSIXlt(x)$isdst




#' Changes the components of a date object
#'
#' update.Date and update.POSIXt return a date with the specified elements updated. 
#' Elements not specified will be left unaltered. update.Date and update.POSIXt do not 
#' add the specified values to the existing date, they substitute them for the 
#' appropriate parts of the existing date. 
#'
#' 
#' @method update Date
#' @method update POSIXt
#' @method update POSIXct
#' @method update POSIXlt
#' @param object a date-time object  
#' @param year a value to substitute for the date's year component
#' @param month a value to substitute for the date's month component
#' @param week a value to substitute for the date's week component
#' @param yday a value to substitute for the date's yday component
#' @param wday a value to substitute for the date's wday component
#' @param mday a value to substitute for the date's mday component
#' @param hour a value to substitute for the date's hour component
#' @param minute a value to substitute for the date's minute component
#' @param second a value to substitute for the date's second component
#' @param tz a value to substitute for the date's tz component
#' @return a date object with the requested elements updated. The object will retain its original class unless an element is updated which the original class does not support. In this case, the date returned will be a POSIXlt date object.
#' @keywords manip chron 
#' @examples
#' date <- as.POSIXlt("2009-02-10") 
#' update(date, year = 2010, month = 1, mday = 1)
#' # "2010-01-01 CST"
#'
#' update(date, year =2010, month = 13, mday = 1)
#' # "2011-01-01 CST"
#'
#' update(date, yday = 35, wday = 4, mday = 3) 
#' # "2009-02-03 CST"
#'
#' update(date, minute = 10, second = 3)
#' # "2009-02-10 00:10:03 CST"
update.Date <- update.POSIXt <- function(x, years = year(x), 
	months = month(x), days = mday(x), hours = hour(x), minutes = 
	minute(x), seconds = second(x), tzs = attr(as.POSIXlt(x), 	"tzone")[1]){
		
	parts <- data.frame(years, months, days, hours, minutes, seconds)
	

	utc <- as.POSIXlt(force_tz(x, tz = "UTC"))
	
	utc$year <- parts$years - 1900
	utc$mon <- parts$months - 1
	utc$mday <- parts$days
	utc$hour <- parts$hours
	utc$min <- parts$minutes
	utc$sec <- parts$seconds

	utc <- as.POSIXct(utc)
	force_tz(utc, tz = tzs)
}


#' Internal function
#'
#' @keywords internal
standardise_date_names <- function(x) {
  dates <- c("second", "minute", "hour", "mday", "wday", "yday", "day", "week", "month", "year", "tz")
  y <- gsub("(.)s$", "\\1", x)
  res <- dates[pmatch(y, dates)]
  if (any(is.na(res))) {
    stop("Invalid unit name: ", paste(x[is.na(res)], collapse = ", "), 
      call. = FALSE)
  }
  res
}

