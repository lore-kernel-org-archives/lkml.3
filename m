Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3KWTEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 14:04:41 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52086 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3KWTD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 14:03:27 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/5] asus-wmi: Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 23 Nov 2013 11:03:17 -0800
Message-Id: <1385233401-21517-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
References: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code and avoid race conditions due to late sysfs attribute
registration. Also replace SENSOR_DEVICE_ATTR with DEVICE_ATTR;
the additional parameter is not used and thus unnecessary.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/platform/x86/asus-wmi.c |   48 +++++++++------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 19c313b..e9e22a5 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -184,7 +184,6 @@ struct asus_wmi {
 
 	struct input_dev *inputdev;
 	struct backlight_device *backlight_device;
-	struct device *hwmon_device;
 	struct platform_device *platform_device;
 
 	struct led_classdev wlan_led;
@@ -1071,20 +1070,12 @@ static ssize_t asus_hwmon_temp1(struct device *dev,
 	return sprintf(buf, "%d\n", value);
 }
 
-static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO, asus_hwmon_pwm1, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, asus_hwmon_temp1, NULL, 0);
-
-static ssize_t
-show_name(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "asus\n");
-}
-static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
+static DEVICE_ATTR(pwm1, S_IRUGO, asus_hwmon_pwm1, NULL);
+static DEVICE_ATTR(temp1_input, S_IRUGO, asus_hwmon_temp1, NULL);
 
 static struct attribute *hwmon_attributes[] = {
-	&sensor_dev_attr_pwm1.dev_attr.attr,
-	&sensor_dev_attr_temp1_input.dev_attr.attr,
-	&sensor_dev_attr_name.dev_attr.attr,
+	&dev_attr_pwm1.attr,
+	&dev_attr_temp1_input.attr,
 	NULL
 };
 
@@ -1098,9 +1089,9 @@ static umode_t asus_hwmon_sysfs_is_visible(struct kobject *kobj,
 	int dev_id = -1;
 	u32 value = ASUS_WMI_UNSUPPORTED_METHOD;
 
-	if (attr == &sensor_dev_attr_pwm1.dev_attr.attr)
+	if (attr == &dev_attr_pwm1.attr)
 		dev_id = ASUS_WMI_DEVID_FAN_CTRL;
-	else if (attr == &sensor_dev_attr_temp1_input.dev_attr.attr)
+	else if (attr == &dev_attr_temp1_input.attr)
 		dev_id = ASUS_WMI_DEVID_THERMAL_CTRL;
 
 	if (dev_id != -1) {
@@ -1135,35 +1126,20 @@ static struct attribute_group hwmon_attribute_group = {
 	.is_visible = asus_hwmon_sysfs_is_visible,
 	.attrs = hwmon_attributes
 };
-
-static void asus_wmi_hwmon_exit(struct asus_wmi *asus)
-{
-	struct device *hwmon;
-
-	hwmon = asus->hwmon_device;
-	if (!hwmon)
-		return;
-	sysfs_remove_group(&hwmon->kobj, &hwmon_attribute_group);
-	hwmon_device_unregister(hwmon);
-	asus->hwmon_device = NULL;
-}
+__ATTRIBUTE_GROUPS(hwmon_attribute);
 
 static int asus_wmi_hwmon_init(struct asus_wmi *asus)
 {
 	struct device *hwmon;
-	int result;
 
-	hwmon = hwmon_device_register(&asus->platform_device->dev);
+	hwmon = hwmon_device_register_with_groups(&asus->platform_device->dev,
+						  "asus", asus,
+						  hwmon_attribute_groups);
 	if (IS_ERR(hwmon)) {
 		pr_err("Could not register asus hwmon device\n");
 		return PTR_ERR(hwmon);
 	}
-	dev_set_drvdata(hwmon, asus);
-	asus->hwmon_device = hwmon;
-	result = sysfs_create_group(&hwmon->kobj, &hwmon_attribute_group);
-	if (result)
-		asus_wmi_hwmon_exit(asus);
-	return result;
+	return 0;
 }
 
 /*
@@ -1834,7 +1810,6 @@ fail_backlight:
 fail_rfkill:
 	asus_wmi_led_exit(asus);
 fail_leds:
-	asus_wmi_hwmon_exit(asus);
 fail_hwmon:
 	asus_wmi_input_exit(asus);
 fail_input:
@@ -1852,7 +1827,6 @@ static int asus_wmi_remove(struct platform_device *device)
 	wmi_remove_notify_handler(asus->driver->event_guid);
 	asus_wmi_backlight_exit(asus);
 	asus_wmi_input_exit(asus);
-	asus_wmi_hwmon_exit(asus);
 	asus_wmi_led_exit(asus);
 	asus_wmi_rfkill_exit(asus);
 	asus_wmi_debugfs_exit(asus);
-- 
1.7.9.7

