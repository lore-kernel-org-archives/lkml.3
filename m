Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3INRQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:16:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36004 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3INROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:05 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 02/11] hwmon: (max6642) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:43 -0700
Message-Id: <1379178832-1489-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also rename new_client variable to client and introduce
new variable dev pointing to client->dev in the probe function,
and use new macro ATTRIBUTE_GROUPS to declare attribute groups.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/max6642.c |   72 ++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/drivers/hwmon/max6642.c b/drivers/hwmon/max6642.c
index 57d58cd..3d61f8d 100644
--- a/drivers/hwmon/max6642.c
+++ b/drivers/hwmon/max6642.c
@@ -87,7 +87,7 @@ static int temp_to_reg(int val)
  */
 
 struct max6642_data {
-	struct device *hwmon_dev;
+	struct i2c_client *client;
 	struct mutex update_lock;
 	bool valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -102,10 +102,10 @@ struct max6642_data {
  * Real code
  */
 
-static void max6642_init_client(struct i2c_client *client)
+static void max6642_init_client(struct max6642_data *data,
+				struct i2c_client *client)
 {
 	u8 config;
-	struct max6642_data *data = i2c_get_clientdata(client);
 
 	/*
 	 * Start the conversions.
@@ -168,14 +168,14 @@ static int max6642_detect(struct i2c_client *client,
 
 static struct max6642_data *max6642_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6642_data *data = i2c_get_clientdata(client);
+	struct max6642_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	u16 val, tmp;
 
 	mutex_lock(&data->update_lock);
 
 	if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
-		dev_dbg(&client->dev, "Updating max6642 data.\n");
+		dev_dbg(dev, "Updating max6642 data.\n");
 		val = i2c_smbus_read_byte_data(client,
 					MAX6642_REG_R_LOCAL_TEMPL);
 		tmp = (val >> 6) & 3;
@@ -209,8 +209,8 @@ static struct max6642_data *max6642_update_device(struct device *dev)
 static ssize_t show_temp_max10(struct device *dev,
 			       struct device_attribute *dev_attr, char *buf)
 {
-	struct max6642_data *data = max6642_update_device(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(dev_attr);
+	struct max6642_data *data = max6642_update_device(dev);
 
 	return sprintf(buf, "%d\n",
 		       temp_from_reg10(data->temp_input[attr->index]));
@@ -219,8 +219,8 @@ static ssize_t show_temp_max10(struct device *dev,
 static ssize_t show_temp_max(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	struct max6642_data *data = max6642_update_device(dev);
 	struct sensor_device_attribute_2 *attr2 = to_sensor_dev_attr_2(attr);
+	struct max6642_data *data = max6642_update_device(dev);
 
 	return sprintf(buf, "%d\n", temp_from_reg(data->temp_high[attr2->nr]));
 }
@@ -228,11 +228,10 @@ static ssize_t show_temp_max(struct device *dev, struct device_attribute *attr,
 static ssize_t set_temp_max(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
+	struct sensor_device_attribute_2 *attr2 = to_sensor_dev_attr_2(attr);
+	struct max6642_data *data = dev_get_drvdata(dev);
 	unsigned long val;
 	int err;
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6642_data *data = i2c_get_clientdata(client);
-	struct sensor_device_attribute_2 *attr2 = to_sensor_dev_attr_2(attr);
 
 	err = kstrtoul(buf, 10, &val);
 	if (err < 0)
@@ -240,7 +239,7 @@ static ssize_t set_temp_max(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	data->temp_high[attr2->nr] = clamp_val(temp_to_reg(val), 0, 255);
-	i2c_smbus_write_byte_data(client, attr2->index,
+	i2c_smbus_write_byte_data(data->client, attr2->index,
 				  data->temp_high[attr2->nr]);
 	mutex_unlock(&data->update_lock);
 	return count;
@@ -264,7 +263,7 @@ static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 2);
 static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_alarm, NULL, 6);
 static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO, show_alarm, NULL, 4);
 
-static struct attribute *max6642_attributes[] = {
+static struct attribute *max6642_attrs[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	&sensor_dev_attr_temp2_input.dev_attr.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
@@ -275,52 +274,30 @@ static struct attribute *max6642_attributes[] = {
 	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
 	NULL
 };
+ATTRIBUTE_GROUPS(max6642);
 
-static const struct attribute_group max6642_group = {
-	.attrs = max6642_attributes,
-};
-
-static int max6642_probe(struct i2c_client *new_client,
+static int max6642_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
+	struct device *dev = &client->dev;
 	struct max6642_data *data;
-	int err;
+	struct device *hwmon_dev;
 
-	data = devm_kzalloc(&new_client->dev, sizeof(struct max6642_data),
-			    GFP_KERNEL);
+	data = devm_kzalloc(dev, sizeof(struct max6642_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	i2c_set_clientdata(new_client, data);
+	data->client = client;
 	mutex_init(&data->update_lock);
 
 	/* Initialize the MAX6642 chip */
-	max6642_init_client(new_client);
-
-	/* Register sysfs hooks */
-	err = sysfs_create_group(&new_client->dev.kobj, &max6642_group);
-	if (err)
-		return err;
-
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto exit_remove_files;
-	}
-
-	return 0;
-
-exit_remove_files:
-	sysfs_remove_group(&new_client->dev.kobj, &max6642_group);
-	return err;
-}
-
-static int max6642_remove(struct i2c_client *client)
-{
-	struct max6642_data *data = i2c_get_clientdata(client);
+	max6642_init_client(data, client);
 
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &max6642_group);
+	hwmon_dev = devm_hwmon_device_register_with_groups(&client->dev,
+							   client->name, data,
+							   max6642_groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
 
 	return 0;
 }
@@ -341,7 +318,6 @@ static struct i2c_driver max6642_driver = {
 		.name	= "max6642",
 	},
 	.probe		= max6642_probe,
-	.remove		= max6642_remove,
 	.id_table	= max6642_id,
 	.detect		= max6642_detect,
 	.address_list	= normal_i2c,
-- 
1.7.9.7

