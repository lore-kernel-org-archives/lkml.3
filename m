Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3KWTES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 14:04:18 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51423 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab3KWTDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 14:03:32 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4/5] compal-laptop: Use devm_hwmon_device_register_with_groups
Date: Sat, 23 Nov 2013 11:03:20 -0800
Message-Id: <1385233401-21517-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
References: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code and create hwmon attributes as well as hwmon device in one go.

With the new hwmon API, hwmon attributes are now attached to the hwmon device.
Therefore, split hwmon and device attributes into two separate groups.
Platform attributes are still attached to the platform device.

Also use devm_kzalloc to allocate local data structures for further
simplification.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/platform/x86/compal-laptop.c |   52 +++++++++++++++-------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 9deb035..7297df2 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -173,8 +173,7 @@
 /* ======= */
 struct compal_data{
 	/* Fan control */
-	struct device *hwmon_dev;
-	int pwm_enable; /* 0:full on, 1:set by pwm1, 2:control by moterboard */
+	int pwm_enable; /* 0:full on, 1:set by pwm1, 2:control by motherboard */
 	unsigned char curr_pwm;
 
 	/* Power supply */
@@ -402,15 +401,6 @@ SIMPLE_MASKED_STORE_SHOW(wake_up_wlan,	WAKE_UP_ADDR, WAKE_UP_WLAN)
 SIMPLE_MASKED_STORE_SHOW(wake_up_key,	WAKE_UP_ADDR, WAKE_UP_KEY)
 SIMPLE_MASKED_STORE_SHOW(wake_up_mouse,	WAKE_UP_ADDR, WAKE_UP_MOUSE)
 
-
-/* General hwmon interface */
-static ssize_t hwmon_name_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", DRIVER_NAME);
-}
-
-
 /* Fan control interface */
 static ssize_t pwm_enable_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -665,7 +655,6 @@ static DEVICE_ATTR(wake_up_key,
 static DEVICE_ATTR(wake_up_mouse,
 		0644, wake_up_mouse_show,	wake_up_mouse_store);
 
-static DEVICE_ATTR(name,        S_IRUGO, hwmon_name_show,   NULL);
 static DEVICE_ATTR(fan1_input,  S_IRUGO, fan_show,          NULL);
 static DEVICE_ATTR(temp1_input, S_IRUGO, temp_cpu,          NULL);
 static DEVICE_ATTR(temp2_input, S_IRUGO, temp_cpu_local,    NULL);
@@ -683,16 +672,20 @@ static DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, pwm_show, pwm_store);
 static DEVICE_ATTR(pwm1_enable,
 		   S_IRUGO | S_IWUSR, pwm_enable_show, pwm_enable_store);
 
-static struct attribute *compal_attributes[] = {
+static struct attribute *compal_platform_attrs[] = {
 	&dev_attr_wake_up_pme.attr,
 	&dev_attr_wake_up_modem.attr,
 	&dev_attr_wake_up_lan.attr,
 	&dev_attr_wake_up_wlan.attr,
 	&dev_attr_wake_up_key.attr,
 	&dev_attr_wake_up_mouse.attr,
-	/* Maybe put the sensor-stuff in a separate hwmon-driver? That way,
-	 * the hwmon sysfs won't be cluttered with the above files. */
-	&dev_attr_name.attr,
+	NULL
+};
+static struct attribute_group compal_platform_attr_group = {
+	.attrs = compal_platform_attrs
+};
+
+static struct attribute *compal_hwmon_attrs[] = {
 	&dev_attr_pwm1_enable.attr,
 	&dev_attr_pwm1.attr,
 	&dev_attr_fan1_input.attr,
@@ -710,10 +703,7 @@ static struct attribute *compal_attributes[] = {
 	&dev_attr_temp6_label.attr,
 	NULL
 };
-
-static struct attribute_group compal_attribute_group = {
-	.attrs = compal_attributes
-};
+ATTRIBUTE_GROUPS(compal_hwmon);
 
 static int compal_probe(struct platform_device *);
 static int compal_remove(struct platform_device *);
@@ -1021,6 +1011,7 @@ static int compal_probe(struct platform_device *pdev)
 {
 	int err;
 	struct compal_data *data;
+	struct device *hwmon_dev;
 
 	if (!extra_features)
 		return 0;
@@ -1032,16 +1023,16 @@ static int compal_probe(struct platform_device *pdev)
 
 	initialize_fan_control_data(data);
 
-	err = sysfs_create_group(&pdev->dev.kobj, &compal_attribute_group);
+	err = sysfs_create_group(&pdev->dev.kobj, &compal_platform_attr_group);
 	if (err)
 		return err;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		sysfs_remove_group(&pdev->dev.kobj,
-				&compal_attribute_group);
-		return err;
+	hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
+						      DRIVER_NAME, data,
+						      compal_hwmon_groups);
+	if (IS_ERR(hwmon_dev)) {
+		err = PTR_ERR(hwmon_dev);
+		goto remove;
 	}
 
 	/* Power supply */
@@ -1051,6 +1042,10 @@ static int compal_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, data);
 
 	return 0;
+
+remove:
+	sysfs_remove_group(&pdev->dev.kobj, &compal_platform_attr_group);
+	return err;
 }
 
 static void __exit compal_cleanup(void)
@@ -1077,10 +1072,9 @@ static int compal_remove(struct platform_device *pdev)
 	pwm_disable_control();
 
 	data = platform_get_drvdata(pdev);
-	hwmon_device_unregister(data->hwmon_dev);
 	power_supply_unregister(&data->psy);
 
-	sysfs_remove_group(&pdev->dev.kobj, &compal_attribute_group);
+	sysfs_remove_group(&pdev->dev.kobj, &compal_platform_attr_group);
 
 	return 0;
 }
-- 
1.7.9.7

