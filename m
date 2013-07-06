Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3GFRZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 13:25:35 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37508 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3GFRZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 13:25:31 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 5/5] hwmon: (ltc4245) Convert to use hwmon_device_register_groups
Date: Sat,  6 Jul 2013 10:24:55 -0700
Message-Id: <1373131495-13465-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
References: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/ltc4245.c |   58 +++++++++++------------------------------------
 1 file changed, 13 insertions(+), 45 deletions(-)

diff --git a/drivers/hwmon/ltc4245.c b/drivers/hwmon/ltc4245.c
index cdc1ecc..53b01abe 100644
--- a/drivers/hwmon/ltc4245.c
+++ b/drivers/hwmon/ltc4245.c
@@ -53,6 +53,8 @@ enum ltc4245_cmd {
 struct ltc4245_data {
 	struct device *hwmon_dev;
 
+	const struct attribute_group *groups[3];
+
 	struct mutex update_lock;
 	bool valid;
 	unsigned long last_updated; /* in jiffies */
@@ -455,41 +457,16 @@ static const struct attribute_group ltc4245_gpio_group = {
 	.attrs = ltc4245_gpio_attributes,
 };
 
-static int ltc4245_sysfs_create_groups(struct i2c_client *client)
+static void ltc4245_sysfs_add_groups(struct i2c_client *client)
 {
 	struct ltc4245_data *data = i2c_get_clientdata(client);
-	struct device *dev = &client->dev;
-	int ret;
-
-	/* register the standard sysfs attributes */
-	ret = sysfs_create_group(&dev->kobj, &ltc4245_std_group);
-	if (ret) {
-		dev_err(dev, "unable to register standard attributes\n");
-		return ret;
-	}
-
-	/* if we're using the extra gpio support, register it's attributes */
-	if (data->use_extra_gpios) {
-		ret = sysfs_create_group(&dev->kobj, &ltc4245_gpio_group);
-		if (ret) {
-			dev_err(dev, "unable to register gpio attributes\n");
-			sysfs_remove_group(&dev->kobj, &ltc4245_std_group);
-			return ret;
-		}
-	}
 
-	return 0;
-}
-
-static void ltc4245_sysfs_remove_groups(struct i2c_client *client)
-{
-	struct ltc4245_data *data = i2c_get_clientdata(client);
-	struct device *dev = &client->dev;
+	/* standard sysfs attributes */
+	data->groups[0] = &ltc4245_std_group;
 
+	/* if we're using the extra gpio support, register it's attributes */
 	if (data->use_extra_gpios)
-		sysfs_remove_group(&dev->kobj, &ltc4245_gpio_group);
-
-	sysfs_remove_group(&dev->kobj, &ltc4245_std_group);
+		data->groups[1] = &ltc4245_gpio_group;
 }
 
 static bool ltc4245_use_extra_gpios(struct i2c_client *client)
@@ -517,7 +494,6 @@ static int ltc4245_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct ltc4245_data *data;
-	int ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
@@ -534,22 +510,15 @@ static int ltc4245_probe(struct i2c_client *client,
 	i2c_smbus_write_byte_data(client, LTC4245_FAULT1, 0x00);
 	i2c_smbus_write_byte_data(client, LTC4245_FAULT2, 0x00);
 
-	/* Register sysfs hooks */
-	ret = ltc4245_sysfs_create_groups(client);
-	if (ret)
-		return ret;
+	/* Add sysfs hooks */
+	ltc4245_sysfs_add_groups(client);
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		ret = PTR_ERR(data->hwmon_dev);
-		goto out_hwmon_device_register;
-	}
+	data->hwmon_dev = hwmon_device_register_groups(&client->dev, data,
+						       data->groups);
+	if (IS_ERR(data->hwmon_dev))
+		return PTR_ERR(data->hwmon_dev);
 
 	return 0;
-
-out_hwmon_device_register:
-	ltc4245_sysfs_remove_groups(client);
-	return ret;
 }
 
 static int ltc4245_remove(struct i2c_client *client)
@@ -557,7 +526,6 @@ static int ltc4245_remove(struct i2c_client *client)
 	struct ltc4245_data *data = i2c_get_clientdata(client);
 
 	hwmon_device_unregister(data->hwmon_dev);
-	ltc4245_sysfs_remove_groups(client);
 
 	return 0;
 }
-- 
1.7.9.7

