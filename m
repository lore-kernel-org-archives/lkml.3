Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab3INRON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:14:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61892 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3INROJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:09 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 04/11] hwmon: (max6697) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:45 -0700
Message-Id: <1379178832-1489-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/max6697.c |   54 +++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index a41b5f3..0af910a 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -77,7 +77,7 @@ struct max6697_chip_data {
 };
 
 struct max6697_data {
-	struct device *hwmon_dev;
+	struct i2c_client *client;
 
 	enum chips type;
 	const struct max6697_chip_data *chip;
@@ -181,8 +181,8 @@ static const struct max6697_chip_data max6697_chip_data[] = {
 
 static struct max6697_data *max6697_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6697_data *data = i2c_get_clientdata(client);
+	struct max6697_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	struct max6697_data *ret = data;
 	int val;
 	int i;
@@ -303,8 +303,7 @@ static ssize_t set_temp(struct device *dev,
 {
 	int nr = to_sensor_dev_attr_2(devattr)->nr;
 	int index = to_sensor_dev_attr_2(devattr)->index;
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6697_data *data = i2c_get_clientdata(client);
+	struct max6697_data *data = dev_get_drvdata(dev);
 	long temp;
 	int ret;
 
@@ -316,7 +315,7 @@ static ssize_t set_temp(struct device *dev,
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + data->temp_offset;
 	temp = clamp_val(temp, 0, data->type == max6581 ? 255 : 127);
 	data->temp[nr][index] = temp;
-	ret = i2c_smbus_write_byte_data(client,
+	ret = i2c_smbus_write_byte_data(data->client,
 					index == 2 ? MAX6697_REG_MAX[nr]
 						   : MAX6697_REG_CRIT[nr],
 					temp);
@@ -405,8 +404,7 @@ static umode_t max6697_is_visible(struct kobject *kobj, struct attribute *attr,
 				  int index)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6697_data *data = i2c_get_clientdata(client);
+	struct max6697_data *data = dev_get_drvdata(dev);
 	const struct max6697_chip_data *chip = data->chip;
 	int channel = index / 6;	/* channel number */
 	int nr = index % 6;		/* attribute index within channel */
@@ -489,6 +487,7 @@ static struct attribute *max6697_attributes[] = {
 static const struct attribute_group max6697_group = {
 	.attrs = max6697_attributes, .is_visible = max6697_is_visible,
 };
+__ATTRIBUTE_GROUPS(max6697);
 
 static void max6697_get_config_of(struct device_node *node,
 				  struct max6697_platform_data *pdata)
@@ -525,9 +524,9 @@ static void max6697_get_config_of(struct device_node *node,
 	}
 }
 
-static int max6697_init_chip(struct i2c_client *client)
+static int max6697_init_chip(struct max6697_data *data,
+			     struct i2c_client *client)
 {
-	struct max6697_data *data = i2c_get_clientdata(client);
 	struct max6697_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct max6697_platform_data p;
 	const struct max6697_chip_data *chip = data->chip;
@@ -625,6 +624,7 @@ static int max6697_probe(struct i2c_client *client,
 	struct i2c_adapter *adapter = client->adapter;
 	struct device *dev = &client->dev;
 	struct max6697_data *data;
+	struct device *hwmon_dev;
 	int err;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -636,37 +636,18 @@ static int max6697_probe(struct i2c_client *client,
 
 	data->type = id->driver_data;
 	data->chip = &max6697_chip_data[data->type];
-
-	i2c_set_clientdata(client, data);
+	data->client = client;
 	mutex_init(&data->update_lock);
 
-	err = max6697_init_chip(client);
+	err = max6697_init_chip(data, client);
 	if (err)
 		return err;
 
-	err = sysfs_create_group(&client->dev.kobj, &max6697_group);
-	if (err)
-		return err;
-
-	data->hwmon_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto error;
-	}
-
-	return 0;
-
-error:
-	sysfs_remove_group(&client->dev.kobj, &max6697_group);
-	return err;
-}
-
-static int max6697_remove(struct i2c_client *client)
-{
-	struct max6697_data *data = i2c_get_clientdata(client);
-
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &max6697_group);
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
+							   data,
+							   max6697_groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
 
 	return 0;
 }
@@ -692,7 +673,6 @@ static struct i2c_driver max6697_driver = {
 		.name	= "max6697",
 	},
 	.probe = max6697_probe,
-	.remove	= max6697_remove,
 	.id_table = max6697_id,
 };
 
-- 
1.7.9.7

