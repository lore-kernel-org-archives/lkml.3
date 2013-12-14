Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3LNRbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:13 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52969 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3LNRai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:38 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 03/14] i8k: Convert to use to hwmon_device_register_with_groups hwmon API
Date: Sat, 14 Dec 2013 09:30:10 -0800
Message-Id: <1387042221-3671-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify code and fix race condition caused by registering
hwmon device prior to creating sysfs attributes.

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |  132 +++++++++++++++++++++-------------------------------
 1 file changed, 54 insertions(+), 78 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 71da6b7..d2acbb8 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -66,6 +66,11 @@
 static DEFINE_MUTEX(i8k_mutex);
 static char bios_version[4];
 static struct device *i8k_hwmon_dev;
+static u32 i8k_hwmon_flags;
+
+#define I8K_HWMON_HAVE_TEMP1	(1 << 0)
+#define I8K_HWMON_HAVE_FAN1	(1 << 1)
+#define I8K_HWMON_HAVE_FAN2	(1 << 2)
 
 MODULE_AUTHOR("Massimo Dal Zotto (dz@debian.org)");
 MODULE_DESCRIPTION("Driver for accessing SMM BIOS on Dell laptops");
@@ -502,8 +507,7 @@ static ssize_t i8k_hwmon_show_label(struct device *dev,
 				    struct device_attribute *devattr,
 				    char *buf)
 {
-	static const char *labels[4] = {
-		"i8k",
+	static const char *labels[3] = {
 		"CPU",
 		"Left Fan",
 		"Right Fan",
@@ -518,100 +522,72 @@ static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
 			  I8K_FAN_LEFT);
 static SENSOR_DEVICE_ATTR(fan2_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
 			  I8K_FAN_RIGHT);
-static SENSOR_DEVICE_ATTR(name, S_IRUGO, i8k_hwmon_show_label, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, i8k_hwmon_show_label, NULL, 1);
-static SENSOR_DEVICE_ATTR(fan1_label, S_IRUGO, i8k_hwmon_show_label, NULL, 2);
-static SENSOR_DEVICE_ATTR(fan2_label, S_IRUGO, i8k_hwmon_show_label, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, i8k_hwmon_show_label, NULL, 0);
+static SENSOR_DEVICE_ATTR(fan1_label, S_IRUGO, i8k_hwmon_show_label, NULL, 1);
+static SENSOR_DEVICE_ATTR(fan2_label, S_IRUGO, i8k_hwmon_show_label, NULL, 2);
+
+static struct attribute *i8k_attrs[] = {
+	&dev_attr_temp1_input.attr,			/* 0 */
+	&sensor_dev_attr_temp1_label.dev_attr.attr,	/* 1 */
+	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 2 */
+	&sensor_dev_attr_fan1_label.dev_attr.attr,	/* 3 */
+	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 4 */
+	&sensor_dev_attr_fan2_label.dev_attr.attr,	/* 5 */
+	NULL
+};
 
-static void i8k_hwmon_remove_files(struct device *dev)
+static umode_t i8k_is_visible(struct kobject *kobj, struct attribute *attr,
+			      int index)
 {
-	device_remove_file(dev, &dev_attr_temp1_input);
-	device_remove_file(dev, &sensor_dev_attr_fan1_input.dev_attr);
-	device_remove_file(dev, &sensor_dev_attr_fan2_input.dev_attr);
-	device_remove_file(dev, &sensor_dev_attr_temp1_label.dev_attr);
-	device_remove_file(dev, &sensor_dev_attr_fan1_label.dev_attr);
-	device_remove_file(dev, &sensor_dev_attr_fan2_label.dev_attr);
-	device_remove_file(dev, &sensor_dev_attr_name.dev_attr);
+	if ((index == 0 || index == 1) &&
+	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP1))
+		return 0;
+	if ((index == 2 || index == 3) &&
+	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN1))
+		return 0;
+	if ((index == 4 || index == 5) &&
+	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN2))
+		return 0;
+
+	return attr->mode;
 }
 
+static const struct attribute_group i8k_group = {
+	.attrs = i8k_attrs,
+	.is_visible = i8k_is_visible,
+};
+__ATTRIBUTE_GROUPS(i8k);
+
 static int __init i8k_init_hwmon(void)
 {
 	int err;
 
-	i8k_hwmon_dev = hwmon_device_register(NULL);
-	if (IS_ERR(i8k_hwmon_dev)) {
-		err = PTR_ERR(i8k_hwmon_dev);
-		i8k_hwmon_dev = NULL;
-		pr_err("hwmon registration failed (%d)\n", err);
-		return err;
-	}
-
-	/* Required name attribute */
-	err = device_create_file(i8k_hwmon_dev,
-				 &sensor_dev_attr_name.dev_attr);
-	if (err)
-		goto exit_unregister;
+	i8k_hwmon_flags = 0;
 
 	/* CPU temperature attributes, if temperature reading is OK */
 	err = i8k_get_temp(0);
-	if (err < 0) {
-		dev_dbg(i8k_hwmon_dev,
-			"Not creating temperature attributes (%d)\n", err);
-	} else {
-		err = device_create_file(i8k_hwmon_dev, &dev_attr_temp1_input);
-		if (err)
-			goto exit_remove_files;
-		err = device_create_file(i8k_hwmon_dev,
-					 &sensor_dev_attr_temp1_label.dev_attr);
-		if (err)
-			goto exit_remove_files;
-	}
+	if (err >= 0)
+		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP1;
 
 	/* Left fan attributes, if left fan is present */
 	err = i8k_get_fan_status(I8K_FAN_LEFT);
-	if (err < 0) {
-		dev_dbg(i8k_hwmon_dev,
-			"Not creating %s fan attributes (%d)\n", "left", err);
-	} else {
-		err = device_create_file(i8k_hwmon_dev,
-					 &sensor_dev_attr_fan1_input.dev_attr);
-		if (err)
-			goto exit_remove_files;
-		err = device_create_file(i8k_hwmon_dev,
-					 &sensor_dev_attr_fan1_label.dev_attr);
-		if (err)
-			goto exit_remove_files;
-	}
+	if (err >= 0)
+		i8k_hwmon_flags |= I8K_HWMON_HAVE_FAN1;
 
 	/* Right fan attributes, if right fan is present */
 	err = i8k_get_fan_status(I8K_FAN_RIGHT);
-	if (err < 0) {
-		dev_dbg(i8k_hwmon_dev,
-			"Not creating %s fan attributes (%d)\n", "right", err);
-	} else {
-		err = device_create_file(i8k_hwmon_dev,
-					 &sensor_dev_attr_fan2_input.dev_attr);
-		if (err)
-			goto exit_remove_files;
-		err = device_create_file(i8k_hwmon_dev,
-					 &sensor_dev_attr_fan2_label.dev_attr);
-		if (err)
-			goto exit_remove_files;
-	}
+	if (err >= 0)
+		i8k_hwmon_flags |= I8K_HWMON_HAVE_FAN2;
 
+	i8k_hwmon_dev = hwmon_device_register_with_groups(NULL, "i8k", NULL,
+							  i8k_groups);
+	if (IS_ERR(i8k_hwmon_dev)) {
+		err = PTR_ERR(i8k_hwmon_dev);
+		i8k_hwmon_dev = NULL;
+		pr_err("hwmon registration failed (%d)\n", err);
+		return err;
+	}
 	return 0;
-
- exit_remove_files:
-	i8k_hwmon_remove_files(i8k_hwmon_dev);
- exit_unregister:
-	hwmon_device_unregister(i8k_hwmon_dev);
-	return err;
-}
-
-static void __exit i8k_exit_hwmon(void)
-{
-	i8k_hwmon_remove_files(i8k_hwmon_dev);
-	hwmon_device_unregister(i8k_hwmon_dev);
 }
 
 static struct dmi_system_id i8k_dmi_table[] __initdata = {
@@ -767,7 +743,7 @@ static int __init i8k_init(void)
 
 static void __exit i8k_exit(void)
 {
-	i8k_exit_hwmon();
+	hwmon_device_unregister(i8k_hwmon_dev);
 	remove_proc_entry("i8k", NULL);
 }
 
-- 
1.7.9.7

