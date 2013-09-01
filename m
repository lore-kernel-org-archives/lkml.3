Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3IACtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 22:49:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61125 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab3IACtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 22:49:18 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 3/9] hwmon: (gpio-fan) Convert to use hwmon_device_register_with_groups
Date: Sat, 31 Aug 2013 19:48:56 -0700
Message-Id: <1378003742-18685-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/gpio-fan.c |   41 ++++++++++++++---------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index b7d6a57..05c2220 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -309,12 +309,6 @@ exit_unlock:
 	return ret;
 }
 
-static ssize_t show_name(struct device *dev,
-			 struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "gpio-fan\n");
-}
-
 static DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, show_pwm, set_pwm);
 static DEVICE_ATTR(pwm1_enable, S_IRUGO | S_IWUSR,
 		   show_pwm_enable, set_pwm_enable);
@@ -324,26 +318,23 @@ static DEVICE_ATTR(fan1_max, S_IRUGO, show_rpm_max, NULL);
 static DEVICE_ATTR(fan1_input, S_IRUGO, show_rpm, NULL);
 static DEVICE_ATTR(fan1_target, S_IRUGO | S_IWUSR, show_rpm, set_rpm);
 
-static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
-
 static umode_t gpio_fan_is_visible(struct kobject *kobj,
 				   struct attribute *attr, int index)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct gpio_fan_data *data = dev_get_drvdata(dev);
 
-	if (index == 1 && !data->alarm)
+	if (index == 0 && !data->alarm)
 		return 0;
-	if (index > 1 && !data->ctrl)
+	if (index > 0 && !data->ctrl)
 		return 0;
 
 	return attr->mode;
 }
 
 static struct attribute *gpio_fan_attributes[] = {
-	&dev_attr_name.attr,
-	&dev_attr_fan1_alarm.attr,		/* 1 */
-	&dev_attr_pwm1.attr,			/* 2 */
+	&dev_attr_fan1_alarm.attr,		/* 0 */
+	&dev_attr_pwm1.attr,			/* 1 */
 	&dev_attr_pwm1_enable.attr,
 	&dev_attr_pwm1_mode.attr,
 	&dev_attr_fan1_input.attr,
@@ -358,6 +349,11 @@ static const struct attribute_group gpio_fan_group = {
 	.is_visible = gpio_fan_is_visible,
 };
 
+static const struct attribute_group *gpio_fan_groups[] = {
+	&gpio_fan_group,
+	NULL
+};
+
 static int fan_ctrl_init(struct gpio_fan_data *fan_data,
 			 struct gpio_fan_platform_data *pdata)
 {
@@ -539,24 +535,16 @@ static int gpio_fan_probe(struct platform_device *pdev)
 			return err;
 	}
 
-	err = sysfs_create_group(&pdev->dev.kobj, &gpio_fan_group);
-	if (err)
-		return err;
-
 	/* Make this driver part of hwmon class. */
-	fan_data->hwmon_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(fan_data->hwmon_dev)) {
-		err = PTR_ERR(fan_data->hwmon_dev);
-		goto err_remove;
-	}
+	fan_data->hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
+						"gpio-fan", fan_data,
+						gpio_fan_groups);
+	if (IS_ERR(fan_data->hwmon_dev))
+		return PTR_ERR(fan_data->hwmon_dev);
 
 	dev_info(&pdev->dev, "GPIO fan initialized\n");
 
 	return 0;
-
-err_remove:
-	sysfs_remove_group(&pdev->dev.kobj, &gpio_fan_group);
-	return err;
 }
 
 static int gpio_fan_remove(struct platform_device *pdev)
@@ -564,7 +552,6 @@ static int gpio_fan_remove(struct platform_device *pdev)
 	struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
 
 	hwmon_device_unregister(fan_data->hwmon_dev);
-	sysfs_remove_group(&pdev->dev.kobj, &gpio_fan_group);
 
 	return 0;
 }
-- 
1.7.9.7

