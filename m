Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3LNRbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:35 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59127 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab3LNRay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:54 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 14/14] i8k: Implement hwmon based fan speed control
Date: Sat, 14 Dec 2013 09:30:21 -0800
Message-Id: <1387042221-3671-15-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fan speed can be set to off, slow, and fast, which can be exported
to userspace through the hwmon ABI as pwm1 / pwm2.

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index ce826d9..70c8df2 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -509,6 +509,39 @@ static ssize_t i8k_hwmon_show_fan(struct device *dev,
 	return sprintf(buf, "%d\n", fan_speed);
 }
 
+static ssize_t i8k_hwmon_show_pwm(struct device *dev,
+				  struct device_attribute *devattr,
+				  char *buf)
+{
+	int index = to_sensor_dev_attr(devattr)->index;
+	int status;
+
+	status = i8k_get_fan_status(index);
+	if (status < 0)
+		return -EIO;
+	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 255));
+}
+
+static ssize_t i8k_hwmon_set_pwm(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int index = to_sensor_dev_attr(attr)->index;
+	unsigned long val;
+	int err;
+
+	err = kstrtoul(buf, 10, &val);
+	if (err)
+		return err;
+	val = clamp_val(DIV_ROUND_CLOSEST(val, 128), 0, 2);
+
+	mutex_lock(&i8k_mutex);
+	err = i8k_set_fan(index, val);
+	mutex_unlock(&i8k_mutex);
+
+	return err < 0 ? -EIO : count;
+}
+
 static ssize_t i8k_hwmon_show_label(struct device *dev,
 				    struct device_attribute *devattr,
 				    char *buf)
@@ -529,8 +562,12 @@ static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 2);
 static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 3);
 static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
 			  I8K_FAN_LEFT);
+static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
+			  i8k_hwmon_set_pwm, I8K_FAN_LEFT);
 static SENSOR_DEVICE_ATTR(fan2_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
 			  I8K_FAN_RIGHT);
+static SENSOR_DEVICE_ATTR(pwm2, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
+			  i8k_hwmon_set_pwm, I8K_FAN_RIGHT);
 static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, i8k_hwmon_show_label, NULL, 0);
 static SENSOR_DEVICE_ATTR(fan1_label, S_IRUGO, i8k_hwmon_show_label, NULL, 1);
 static SENSOR_DEVICE_ATTR(fan2_label, S_IRUGO, i8k_hwmon_show_label, NULL, 2);
@@ -542,9 +579,11 @@ static struct attribute *i8k_attrs[] = {
 	&sensor_dev_attr_temp3_input.dev_attr.attr,	/* 3 */
 	&sensor_dev_attr_temp4_input.dev_attr.attr,	/* 4 */
 	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 5 */
-	&sensor_dev_attr_fan1_label.dev_attr.attr,	/* 6 */
-	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 7 */
-	&sensor_dev_attr_fan2_label.dev_attr.attr,	/* 8 */
+	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 6 */
+	&sensor_dev_attr_fan1_label.dev_attr.attr,	/* 7 */
+	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 8 */
+	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 9 */
+	&sensor_dev_attr_fan2_label.dev_attr.attr,	/* 10 */
 	NULL
 };
 
@@ -560,10 +599,10 @@ static umode_t i8k_is_visible(struct kobject *kobj, struct attribute *attr,
 		return 0;
 	if (index == 4 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP4))
 		return 0;
-	if ((index == 5 || index == 6) &&
+	if (index >= 5 && index <= 7 &&
 	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN1))
 		return 0;
-	if ((index == 7 || index == 8) &&
+	if (index >= 8 && index <= 10 &&
 	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN2))
 		return 0;
 
-- 
1.7.9.7

