Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3AMRp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:45:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34929 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900Ab3AMRpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:20 -0500
Message-Id: <20130113174256.920397097@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:00 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Verges <kg4ysn@gmail.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [ 05/49] hwmon: (lm73} Detect and report i2c bus errors
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Verges <kg4ysn@gmail.com>

commit 0602934f302e016e2ea5dc6951681bfac77455ef upstream.

If an LM73 device does not exist on an I2C bus, attempts to communicate
with the device result in an error code returned from the i2c read/write
functions.  The current lm73 driver casts that return value from a s32
type to a s16 type, then converts it to a temperature in celsius.
Because negative temperatures are valid, it is difficult to distinguish
between an error code printed to the response buffer and a negative
temperature recorded by the sensor.

The solution is to evaluate the return value from the i2c functions
before performing any temperature calculations.  If the i2c function did
not succeed, the error code should be passed back through the virtual
file system layer instead of being printed into the response buffer.

Before:

   $ cat /sys/class/hwmon/hwmon0/device/temp1_input
   -46

After:

   $ cat /sys/class/hwmon/hwmon0/device/temp1_input
   cat: read error: No such device or address

Signed-off-by: Chris Verges <kg4ysn@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/lm73.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/hwmon/lm73.c
+++ b/drivers/hwmon/lm73.c
@@ -49,6 +49,7 @@ static ssize_t set_temp(struct device *d
 	struct i2c_client *client = to_i2c_client(dev);
 	long temp;
 	short value;
+	s32 err;
 
 	int status = strict_strtol(buf, 10, &temp);
 	if (status < 0)
@@ -57,8 +58,8 @@ static ssize_t set_temp(struct device *d
 	/* Write value */
 	value = (short) SENSORS_LIMIT(temp/250, (LM73_TEMP_MIN*4),
 		(LM73_TEMP_MAX*4)) << 5;
-	i2c_smbus_write_word_swapped(client, attr->index, value);
-	return count;
+	err = i2c_smbus_write_word_swapped(client, attr->index, value);
+	return (err < 0) ? err : count;
 }
 
 static ssize_t show_temp(struct device *dev, struct device_attribute *da,
@@ -66,11 +67,16 @@ static ssize_t show_temp(struct device *
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 	struct i2c_client *client = to_i2c_client(dev);
+	int temp;
+
+	s32 err = i2c_smbus_read_word_swapped(client, attr->index);
+	if (err < 0)
+		return err;
+
 	/* use integer division instead of equivalent right shift to
 	   guarantee arithmetic shift and preserve the sign */
-	int temp = ((s16) (i2c_smbus_read_word_swapped(client,
-		    attr->index))*250) / 32;
-	return sprintf(buf, "%d\n", temp);
+	temp = (((s16) err) * 250) / 32;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", temp);
 }
 
 


