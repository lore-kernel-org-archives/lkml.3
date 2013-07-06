Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3GFRZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 13:25:53 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52780 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3GFRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 13:25:28 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 4/5] hwmon: (gpio-fan) Convert to use hwmon_device_register_groups
Date: Sat,  6 Jul 2013 10:24:54 -0700
Message-Id: <1373131495-13465-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
References: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/gpio-fan.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 3104149..7953d99 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -358,6 +358,11 @@ static const struct attribute_group gpio_fan_group = {
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
@@ -539,24 +544,15 @@ static int gpio_fan_probe(struct platform_device *pdev)
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
+	fan_data->hwmon_dev = hwmon_device_register_groups(&pdev->dev, fan_data,
+							   gpio_fan_groups);
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
@@ -564,7 +560,6 @@ static int gpio_fan_remove(struct platform_device *pdev)
 	struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
 
 	hwmon_device_unregister(fan_data->hwmon_dev);
-	sysfs_remove_group(&pdev->dev.kobj, &gpio_fan_group);
 
 	return 0;
 }
-- 
1.7.9.7

