Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab3INROU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:14:20 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35655 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3INROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:15 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 07/11] hwmon: (tmp401) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:48 -0700
Message-Id: <1379178832-1489-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/tmp401.c |   89 +++++++++++++++---------------------------------
 1 file changed, 28 insertions(+), 61 deletions(-)

diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index dfe6d95..49bd122 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -155,7 +155,8 @@ MODULE_DEVICE_TABLE(i2c, tmp401_id);
  */
 
 struct tmp401_data {
-	struct device *hwmon_dev;
+	struct i2c_client *client;
+	const struct attribute_group *groups[3];
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -231,8 +232,8 @@ static int tmp401_update_device_reg16(struct i2c_client *client,
 
 static struct tmp401_data *tmp401_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct tmp401_data *data = i2c_get_clientdata(client);
+	struct tmp401_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	struct tmp401_data *ret = data;
 	int i, val;
 	unsigned long next_update;
@@ -350,8 +351,8 @@ static ssize_t store_temp(struct device *dev, struct device_attribute *devattr,
 {
 	int nr = to_sensor_dev_attr_2(devattr)->nr;
 	int index = to_sensor_dev_attr_2(devattr)->index;
-	struct i2c_client *client = to_i2c_client(dev);
-	struct tmp401_data *data = tmp401_update_device(dev);
+	struct tmp401_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	long val;
 	u16 reg;
 	u8 regaddr;
@@ -405,7 +406,7 @@ static ssize_t store_temp_crit_hyst(struct device *dev, struct device_attribute
 	val = clamp_val(val, temp - 255000, temp);
 	reg = ((temp - val) + 500) / 1000;
 
-	i2c_smbus_write_byte_data(to_i2c_client(dev), TMP401_TEMP_CRIT_HYST,
+	i2c_smbus_write_byte_data(data->client, TMP401_TEMP_CRIT_HYST,
 				  reg);
 
 	data->temp_crit_hyst = reg;
@@ -423,8 +424,8 @@ static ssize_t store_temp_crit_hyst(struct device *dev, struct device_attribute
 static ssize_t reset_temp_history(struct device *dev,
 	struct device_attribute	*devattr, const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct tmp401_data *data = i2c_get_clientdata(client);
+	struct tmp401_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	long val;
 
 	if (kstrtol(buf, 10, &val))
@@ -447,8 +448,7 @@ static ssize_t reset_temp_history(struct device *dev,
 static ssize_t show_update_interval(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct tmp401_data *data = i2c_get_clientdata(client);
+	struct tmp401_data *data = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%u\n", data->update_interval);
 }
@@ -457,8 +457,8 @@ static ssize_t set_update_interval(struct device *dev,
 				   struct device_attribute *attr,
 				   const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct tmp401_data *data = i2c_get_clientdata(client);
+	struct tmp401_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	unsigned long val;
 	int err, rate;
 
@@ -616,10 +616,10 @@ static const struct attribute_group tmp432_group = {
  * Begin non sysfs callback code (aka Real code)
  */
 
-static void tmp401_init_client(struct i2c_client *client)
+static void tmp401_init_client(struct tmp401_data *data,
+			       struct i2c_client *client)
 {
 	int config, config_orig;
-	struct tmp401_data *data = i2c_get_clientdata(client);
 
 	/* Set the conversion rate to 2 Hz */
 	i2c_smbus_write_byte_data(client, TMP401_CONVERSION_RATE_WRITE, 5);
@@ -705,77 +705,45 @@ static int tmp401_detect(struct i2c_client *client,
 	return 0;
 }
 
-static int tmp401_remove(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-	struct tmp401_data *data = i2c_get_clientdata(client);
-
-	if (data->hwmon_dev)
-		hwmon_device_unregister(data->hwmon_dev);
-
-	sysfs_remove_group(&dev->kobj, &tmp401_group);
-
-	if (data->kind == tmp411)
-		sysfs_remove_group(&dev->kobj, &tmp411_group);
-
-	if (data->kind == tmp432)
-		sysfs_remove_group(&dev->kobj, &tmp432_group);
-
-	return 0;
-}
-
 static int tmp401_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
+	const char *names[] = { "TMP401", "TMP411", "TMP431", "TMP432" };
 	struct device *dev = &client->dev;
-	int err;
+	struct device *hwmon_dev;
 	struct tmp401_data *data;
-	const char *names[] = { "TMP401", "TMP411", "TMP431", "TMP432" };
+	int groups = 0;
 
 	data = devm_kzalloc(dev, sizeof(struct tmp401_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, data);
+	data->client = client;
 	mutex_init(&data->update_lock);
 	data->kind = id->driver_data;
 
 	/* Initialize the TMP401 chip */
-	tmp401_init_client(client);
+	tmp401_init_client(data, client);
 
 	/* Register sysfs hooks */
-	err = sysfs_create_group(&dev->kobj, &tmp401_group);
-	if (err)
-		return err;
+	data->groups[groups++] = &tmp401_group;
 
 	/* Register additional tmp411 sysfs hooks */
-	if (data->kind == tmp411) {
-		err = sysfs_create_group(&dev->kobj, &tmp411_group);
-		if (err)
-			goto exit_remove;
-	}
+	if (data->kind == tmp411)
+		data->groups[groups++] = &tmp411_group;
 
 	/* Register additional tmp432 sysfs hooks */
-	if (data->kind == tmp432) {
-		err = sysfs_create_group(&dev->kobj, &tmp432_group);
-		if (err)
-			goto exit_remove;
-	}
+	if (data->kind == tmp432)
+		data->groups[groups++] = &tmp432_group;
 
-	data->hwmon_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		data->hwmon_dev = NULL;
-		goto exit_remove;
-	}
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
+							   data, data->groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
 
 	dev_info(dev, "Detected TI %s chip\n", names[data->kind]);
 
 	return 0;
-
-exit_remove:
-	tmp401_remove(client);
-	return err;
 }
 
 static struct i2c_driver tmp401_driver = {
@@ -784,7 +752,6 @@ static struct i2c_driver tmp401_driver = {
 		.name	= "tmp401",
 	},
 	.probe		= tmp401_probe,
-	.remove		= tmp401_remove,
 	.id_table	= tmp401_id,
 	.detect		= tmp401_detect,
 	.address_list	= normal_i2c,
-- 
1.7.9.7

