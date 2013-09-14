Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3INROR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:14:17 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36705 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab3INRON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:13 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 06/11] hwmon: (ina2xx) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:47 -0700
Message-Id: <1379178832-1489-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also introduce dev variable in probe function to simplify access
to client->dev, and use new macro ATTRIBUTE_GROUPS to declare
attribute groups.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/ina2xx.c |   64 ++++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 43 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 70a39a8..93d26e8 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -78,7 +78,7 @@ struct ina2xx_config {
 };
 
 struct ina2xx_data {
-	struct device *hwmon_dev;
+	struct i2c_client *client;
 	const struct ina2xx_config *config;
 
 	struct mutex update_lock;
@@ -112,8 +112,8 @@ static const struct ina2xx_config ina2xx_config[] = {
 
 static struct ina2xx_data *ina2xx_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ina2xx_data *data = i2c_get_clientdata(client);
+	struct ina2xx_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	struct ina2xx_data *ret = data;
 
 	mutex_lock(&data->update_lock);
@@ -203,41 +203,39 @@ static SENSOR_DEVICE_ATTR(power1_input, S_IRUGO, ina2xx_show_value, NULL,
 			  INA2XX_POWER);
 
 /* pointers to created device attributes */
-static struct attribute *ina2xx_attributes[] = {
+static struct attribute *ina2xx_attrs[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
 	&sensor_dev_attr_in1_input.dev_attr.attr,
 	&sensor_dev_attr_curr1_input.dev_attr.attr,
 	&sensor_dev_attr_power1_input.dev_attr.attr,
 	NULL,
 };
-
-static const struct attribute_group ina2xx_group = {
-	.attrs = ina2xx_attributes,
-};
+ATTRIBUTE_GROUPS(ina2xx);
 
 static int ina2xx_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
-	struct ina2xx_data *data;
 	struct ina2xx_platform_data *pdata;
-	int ret;
-	u32 val;
+	struct device *dev = &client->dev;
+	struct ina2xx_data *data;
+	struct device *hwmon_dev;
 	long shunt = 10000; /* default shunt value 10mOhms */
+	u32 val;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
 
-	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	if (dev_get_platdata(&client->dev)) {
-		pdata = dev_get_platdata(&client->dev);
+	if (dev_get_platdata(dev)) {
+		pdata = dev_get_platdata(dev);
 		shunt = pdata->shunt_uohms;
-	} else if (!of_property_read_u32(client->dev.of_node,
-				"shunt-resistor", &val)) {
-			shunt = val;
+	} else if (!of_property_read_u32(dev->of_node,
+					 "shunt-resistor", &val)) {
+		shunt = val;
 	}
 
 	if (shunt <= 0)
@@ -255,37 +253,18 @@ static int ina2xx_probe(struct i2c_client *client,
 	i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
 				     data->config->calibration_factor / shunt);
 
-	i2c_set_clientdata(client, data);
+	data->client = client;
 	mutex_init(&data->update_lock);
 
-	ret = sysfs_create_group(&client->dev.kobj, &ina2xx_group);
-	if (ret)
-		return ret;
-
-	data->hwmon_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		ret = PTR_ERR(data->hwmon_dev);
-		goto out_err_hwmon;
-	}
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
+							   data, ina2xx_groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
 
-	dev_info(&client->dev, "power monitor %s (Rshunt = %li uOhm)\n",
+	dev_info(dev, "power monitor %s (Rshunt = %li uOhm)\n",
 		 id->name, shunt);
 
 	return 0;
-
-out_err_hwmon:
-	sysfs_remove_group(&client->dev.kobj, &ina2xx_group);
-	return ret;
-}
-
-static int ina2xx_remove(struct i2c_client *client)
-{
-	struct ina2xx_data *data = i2c_get_clientdata(client);
-
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &ina2xx_group);
-
-	return 0;
 }
 
 static const struct i2c_device_id ina2xx_id[] = {
@@ -302,7 +281,6 @@ static struct i2c_driver ina2xx_driver = {
 		.name	= "ina2xx",
 	},
 	.probe		= ina2xx_probe,
-	.remove		= ina2xx_remove,
 	.id_table	= ina2xx_id,
 };
 
-- 
1.7.9.7

