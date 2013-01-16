Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab3APQI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36687 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab3APQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Verges <kg4ysn@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 170/222] hwmon: (lm73} Detect and report i2c bus errors
Date: Wed, 16 Jan 2013 13:56:10 -0200
Message-Id: <1358351822-7675-171-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/hwmon/lm73.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/lm73.c b/drivers/hwmon/lm73.c
index 8fa2632..7272176 100644
--- a/drivers/hwmon/lm73.c
+++ b/drivers/hwmon/lm73.c
@@ -49,6 +49,7 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 	struct i2c_client *client = to_i2c_client(dev);
 	long temp;
 	short value;
+	s32 err;
 
 	int status = kstrtol(buf, 10, &temp);
 	if (status < 0)
@@ -57,8 +58,8 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 	/* Write value */
 	value = (short) SENSORS_LIMIT(temp/250, (LM73_TEMP_MIN*4),
 		(LM73_TEMP_MAX*4)) << 5;
-	i2c_smbus_write_word_swapped(client, attr->index, value);
-	return count;
+	err = i2c_smbus_write_word_swapped(client, attr->index, value);
+	return (err < 0) ? err : count;
 }
 
 static ssize_t show_temp(struct device *dev, struct device_attribute *da,
@@ -66,11 +67,16 @@ static ssize_t show_temp(struct device *dev, struct device_attribute *da,
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
 
 
-- 
1.7.9.5

