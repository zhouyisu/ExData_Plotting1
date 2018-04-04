library(here)
library(tidyverse)

# Read data
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

destfile <- here("jhu-exploratory_data_analysis", "data", "pwr_consump.zip")
if(!file.exists(destfile)){
    res <- tryCatch(download.file(fileURL,
                                  destfile=destfile,
                                  method="auto"),
                    error=function(e) 1)
}

unzip(destfile, exdir=data, overwrite = TRUE)

pwr <- read.table(here::here("jhu-exploratory_data_analysis", "data",
                             "household_power_consumption.txt"), 
                  header = TRUE, sep = ";", na.strings="?", stringsAsFactors=F)

pwr$datetime <- as.POSIXct(paste(pwr$Date, pwr$Time), format = "%d/%m/%Y %H:%M:%S")
pwr2 <- subset(pwr, datetime >= as.POSIXct('2007-02-01 00:00:00') &
                   datetime < as.POSIXct('2007-02-03 00:00:00'))

# Plot 4
par(mfrow = c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
# 4.1
with(pwr2, plot(datetime, Global_active_power, type  = "l", 
                xlab = "", ylab = "Global Active Power (kilowatts)"))
#4.2
with(pwr2, plot(datetime, Voltage, type  = "l", 
                xlab = "datetime", ylab = "Voltage"))
#4.3
with(pwr2, {
    plot(datetime, Sub_metering_1, type = "l", 
         xlab = "", ylab = "Energy sub mertering")
    lines(datetime, Sub_metering_2, col = "red")
    lines(datetime, Sub_metering_3, col = "blue")
})
legend("topright", lty = 1, col = c("black", "red", "blue"), cex = 0.75,
       legend =c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
#4.4
with(pwr2, plot(datetime, Global_reactive_power, type  = "l", 
                xlab = "datetime"))

dev.copy(png, file = here("jhu-exploratory_data_analysis","plot4.png"),
         width = 480, height = 480);
dev.off()