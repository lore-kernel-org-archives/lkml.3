Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaK3U1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:27:13 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61197 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaK3U1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:27:12 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: Steven Honeyman <stevenhoneyman@gmail.com>, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/3] i8k: Add support for temperature sensor labels
Date: Sun, 30 Nov 2014 21:26:16 +0100
Message-Id: <1417379178-5236-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds labels for temperature sensors if SMM function with EAX register
0x11a3 reports it. This information was taken from DOS binary NBSVC.MDM.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |   74 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 13 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index e34a019..4be72a4 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -42,6 +42,7 @@
 #define I8K_SMM_GET_FAN		0x00a3
 #define I8K_SMM_GET_SPEED	0x02a3
 #define I8K_SMM_GET_TEMP	0x10a3
+#define I8K_SMM_GET_TEMP_TYPE	0x11a3
 #define I8K_SMM_GET_DELL_SIG1	0xfea3
 #define I8K_SMM_GET_DELL_SIG2	0xffa3
 
@@ -288,6 +289,14 @@ static int i8k_set_fan(int fan, int speed)
 	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
 }
 
+static int i8k_get_temp_type(int sensor)
+{
+	struct smm_regs regs = { .eax = I8K_SMM_GET_TEMP_TYPE, };
+
+	regs.ebx = sensor & 0xff;
+	return i8k_smm(&regs) ? : regs.eax & 0xff;
+}
+
 /*
  * Read the cpu temperature.
  */
@@ -493,6 +502,29 @@ static int i8k_open_fs(struct inode *inode, struct file *file)
  * Hwmon interface
  */
 
+static ssize_t i8k_hwmon_show_temp_label(struct device *dev,
+				   struct device_attribute *devattr,
+				   char *buf)
+{
+	static const char * const labels[] = {
+		"CPU",
+		"GPU",
+		"SODIMM",
+		"Other",
+		"Ambient",
+		"Other",
+	};
+	int index = to_sensor_dev_attr(devattr)->index;
+	int type;
+
+	type = i8k_get_temp_type(index);
+	if (type < 0)
+		return type;
+	if (type >= ARRAY_SIZE(labels))
+		type = ARRAY_SIZE(labels) - 1;
+	return sprintf(buf, "%s\n", labels[type]);
+}
+
 static ssize_t i8k_hwmon_show_temp(struct device *dev,
 				   struct device_attribute *devattr,
 				   char *buf)
@@ -555,9 +587,17 @@ static ssize_t i8k_hwmon_set_pwm(struct device *dev,
 }
 
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL,
+			  0);
 static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL,
+			  1);
 static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL,
+			  2);
 static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL,
+			  3);
 static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
 			  I8K_FAN_LEFT);
 static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
@@ -569,31 +609,39 @@ static SENSOR_DEVICE_ATTR(pwm2, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
 
 static struct attribute *i8k_attrs[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,	/* 0 */
-	&sensor_dev_attr_temp2_input.dev_attr.attr,	/* 1 */
-	&sensor_dev_attr_temp3_input.dev_attr.attr,	/* 2 */
-	&sensor_dev_attr_temp4_input.dev_attr.attr,	/* 3 */
-	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 4 */
-	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 5 */
-	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 6 */
-	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 7 */
+	&sensor_dev_attr_temp1_label.dev_attr.attr,	/* 1 */
+	&sensor_dev_attr_temp2_input.dev_attr.attr,	/* 2 */
+	&sensor_dev_attr_temp2_label.dev_attr.attr,	/* 3 */
+	&sensor_dev_attr_temp3_input.dev_attr.attr,	/* 4 */
+	&sensor_dev_attr_temp3_label.dev_attr.attr,	/* 5 */
+	&sensor_dev_attr_temp4_input.dev_attr.attr,	/* 6 */
+	&sensor_dev_attr_temp4_label.dev_attr.attr,	/* 7 */
+	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 8 */
+	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 9 */
+	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 10 */
+	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 11 */
 	NULL
 };
 
 static umode_t i8k_is_visible(struct kobject *kobj, struct attribute *attr,
 			      int index)
 {
-	if (index == 0 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP1))
+	if (index >= 0 && index <= 1 &&
+	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP1))
 		return 0;
-	if (index == 1 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP2))
+	if (index >= 2 && index <= 3 &&
+	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP2))
 		return 0;
-	if (index == 2 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP3))
+	if (index >= 4 && index <= 5 &&
+	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP3))
 		return 0;
-	if (index == 3 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP4))
+	if (index >= 6 && index <= 7 &&
+	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP4))
 		return 0;
-	if (index >= 4 && index <= 5 &&
+	if (index >= 8 && index <= 9 &&
 	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN1))
 		return 0;
-	if (index >= 6 && index <= 7 &&
+	if (index >= 10 && index <= 11 &&
 	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN2))
 		return 0;
 
-- 
1.7.9.5

