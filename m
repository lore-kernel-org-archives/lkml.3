Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3INROP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:14:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52761 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3INROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:11 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 05/11] hwmon: (max16065) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:46 -0700
Message-Id: <1379178832-1489-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify code to use is_visible to determine if an attribute should be created
or not, then use devm_hwmon_device_register_with_groups to create the hwmon
device and all attributes in one operation.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/max16065.c |  124 +++++++++++++++++++---------------------------
 1 file changed, 52 insertions(+), 72 deletions(-)

diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index 2fa2c02..d4efc79 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -83,7 +83,8 @@ static const bool max16065_have_current[] = {
 
 struct max16065_data {
 	enum chips type;
-	struct device *hwmon_dev;
+	struct i2c_client *client;
+	const struct attribute_group *groups[4];
 	struct mutex update_lock;
 	bool valid;
 	unsigned long last_updated; /* in jiffies */
@@ -144,8 +145,8 @@ static int max16065_read_adc(struct i2c_client *client, int reg)
 
 static struct max16065_data *max16065_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max16065_data *data = i2c_get_clientdata(client);
+	struct max16065_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 
 	mutex_lock(&data->update_lock);
 	if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
@@ -186,7 +187,7 @@ static ssize_t max16065_show_alarm(struct device *dev,
 
 	val &= (1 << attr2->index);
 	if (val)
-		i2c_smbus_write_byte_data(to_i2c_client(dev),
+		i2c_smbus_write_byte_data(data->client,
 					  MAX16065_FAULT(attr2->nr), val);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", !!val);
@@ -223,8 +224,7 @@ static ssize_t max16065_set_limit(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct sensor_device_attribute_2 *attr2 = to_sensor_dev_attr_2(da);
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max16065_data *data = i2c_get_clientdata(client);
+	struct max16065_data *data = dev_get_drvdata(dev);
 	unsigned long val;
 	int err;
 	int limit;
@@ -238,7 +238,7 @@ static ssize_t max16065_set_limit(struct device *dev,
 	mutex_lock(&data->update_lock);
 	data->limit[attr2->nr][attr2->index]
 	  = LIMIT_TO_MV(limit, data->range[attr2->index]);
-	i2c_smbus_write_byte_data(client,
+	i2c_smbus_write_byte_data(data->client,
 				  MAX16065_LIMIT(attr2->nr, attr2->index),
 				  limit);
 	mutex_unlock(&data->update_lock);
@@ -250,8 +250,7 @@ static ssize_t max16065_show_limit(struct device *dev,
 				   struct device_attribute *da, char *buf)
 {
 	struct sensor_device_attribute_2 *attr2 = to_sensor_dev_attr_2(da);
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max16065_data *data = i2c_get_clientdata(client);
+	struct max16065_data *data = dev_get_drvdata(dev);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->limit[attr2->nr][attr2->index]);
@@ -516,8 +515,32 @@ static struct attribute *max16065_max_attributes[] = {
 	NULL
 };
 
+static umode_t max16065_basic_is_visible(struct kobject *kobj,
+					 struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct max16065_data *data = dev_get_drvdata(dev);
+	int index = n / 4;
+
+	if (index >= data->num_adc || !data->range[index])
+		return 0;
+	return a->mode;
+}
+
+static umode_t max16065_secondary_is_visible(struct kobject *kobj,
+					     struct attribute *a, int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct max16065_data *data = dev_get_drvdata(dev);
+
+	if (index >= data->num_adc)
+		return 0;
+	return a->mode;
+}
+
 static const struct attribute_group max16065_basic_group = {
 	.attrs = max16065_basic_attributes,
+	.is_visible = max16065_basic_is_visible,
 };
 
 static const struct attribute_group max16065_current_group = {
@@ -526,38 +549,35 @@ static const struct attribute_group max16065_current_group = {
 
 static const struct attribute_group max16065_min_group = {
 	.attrs = max16065_min_attributes,
+	.is_visible = max16065_secondary_is_visible,
 };
 
 static const struct attribute_group max16065_max_group = {
 	.attrs = max16065_max_attributes,
+	.is_visible = max16065_secondary_is_visible,
 };
 
-static void max16065_cleanup(struct i2c_client *client)
-{
-	sysfs_remove_group(&client->dev.kobj, &max16065_max_group);
-	sysfs_remove_group(&client->dev.kobj, &max16065_min_group);
-	sysfs_remove_group(&client->dev.kobj, &max16065_current_group);
-	sysfs_remove_group(&client->dev.kobj, &max16065_basic_group);
-}
-
 static int max16065_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct max16065_data *data;
-	int i, j, val, ret;
+	struct device *dev = &client->dev;
+	struct device *hwmon_dev;
+	int i, j, val;
 	bool have_secondary;		/* true if chip has secondary limits */
 	bool secondary_is_max = false;	/* secondary limits reflect max */
+	int groups = 0;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA
 				     | I2C_FUNC_SMBUS_READ_WORD_DATA))
 		return -ENODEV;
 
-	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (unlikely(!data))
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, data);
+	data->client = client;
 	mutex_init(&data->update_lock);
 
 	data->num_adc = max16065_num_adc[id->driver_data];
@@ -596,38 +616,16 @@ static int max16065_probe(struct i2c_client *client,
 		}
 	}
 
-	/* Register sysfs hooks */
-	for (i = 0; i < data->num_adc * 4; i++) {
-		/* Do not create sysfs entry if channel is disabled */
-		if (!data->range[i / 4])
-			continue;
-
-		ret = sysfs_create_file(&client->dev.kobj,
-					max16065_basic_attributes[i]);
-		if (unlikely(ret))
-			goto out;
-	}
-
-	if (have_secondary) {
-		struct attribute **attr = secondary_is_max ?
-		  max16065_max_attributes : max16065_min_attributes;
-
-		for (i = 0; i < data->num_adc; i++) {
-			if (!data->range[i])
-				continue;
-
-			ret = sysfs_create_file(&client->dev.kobj, attr[i]);
-			if (unlikely(ret))
-				goto out;
-		}
-	}
+	/* sysfs hooks */
+	data->groups[groups++] = &max16065_basic_group;
+	if (have_secondary)
+		data->groups[groups++] = secondary_is_max ?
+			&max16065_max_group : &max16065_min_group;
 
 	if (data->have_current) {
 		val = i2c_smbus_read_byte_data(client, MAX16065_CURR_CONTROL);
-		if (unlikely(val < 0)) {
-			ret = val;
-			goto out;
-		}
+		if (unlikely(val < 0))
+			return val;
 		if (val & MAX16065_CURR_ENABLE) {
 			/*
 			 * Current gain is 6, 12, 24, 48 based on values in
@@ -636,33 +634,16 @@ static int max16065_probe(struct i2c_client *client,
 			data->curr_gain = 6 << ((val >> 2) & 0x03);
 			data->range[MAX16065_NUM_ADC]
 			  = max16065_csp_adc_range[(val >> 1) & 0x01];
-			ret = sysfs_create_group(&client->dev.kobj,
-						 &max16065_current_group);
-			if (unlikely(ret))
-				goto out;
+			data->groups[groups++] = &max16065_current_group;
 		} else {
 			data->have_current = false;
 		}
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
-	if (unlikely(IS_ERR(data->hwmon_dev))) {
-		ret = PTR_ERR(data->hwmon_dev);
-		goto out;
-	}
-	return 0;
-
-out:
-	max16065_cleanup(client);
-	return ret;
-}
-
-static int max16065_remove(struct i2c_client *client)
-{
-	struct max16065_data *data = i2c_get_clientdata(client);
-
-	hwmon_device_unregister(data->hwmon_dev);
-	max16065_cleanup(client);
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
+							   data, data->groups);
+	if (unlikely(IS_ERR(hwmon_dev)))
+		return PTR_ERR(hwmon_dev);
 
 	return 0;
 }
@@ -685,7 +666,6 @@ static struct i2c_driver max16065_driver = {
 		.name = "max16065",
 	},
 	.probe = max16065_probe,
-	.remove = max16065_remove,
 	.id_table = max16065_id,
 };
 
-- 
1.7.9.7

