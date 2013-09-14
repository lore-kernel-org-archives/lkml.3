Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3INROX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:14:23 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56879 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab3INROU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:20 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 09/11] hwmon: (ina209) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:50 -0700
Message-Id: <1379178832-1489-10-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also use new macro ATTRIBUTE_GROUPS to declare attribute groups.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/ina209.c |   46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/hwmon/ina209.c b/drivers/hwmon/ina209.c
index c6fdd5b..5378fde 100644
--- a/drivers/hwmon/ina209.c
+++ b/drivers/hwmon/ina209.c
@@ -63,7 +63,7 @@
 #define INA209_SHUNT_DEFAULT		10000	/* uOhm */
 
 struct ina209_data {
-	struct device *hwmon_dev;
+	struct i2c_client *client;
 
 	struct mutex update_lock;
 	bool valid;
@@ -78,8 +78,8 @@ struct ina209_data {
 
 static struct ina209_data *ina209_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ina209_data *data = i2c_get_clientdata(client);
+	struct ina209_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	struct ina209_data *ret = data;
 	s32 val;
 	int i;
@@ -234,7 +234,6 @@ static ssize_t ina209_set_interval(struct device *dev,
 				   struct device_attribute *da,
 				   const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
 	struct ina209_data *data = ina209_update_device(dev);
 	long val;
 	u16 regval;
@@ -250,7 +249,8 @@ static ssize_t ina209_set_interval(struct device *dev,
 	mutex_lock(&data->update_lock);
 	regval = ina209_reg_from_interval(data->regs[INA209_CONFIGURATION],
 					  val);
-	i2c_smbus_write_word_swapped(client, INA209_CONFIGURATION, regval);
+	i2c_smbus_write_word_swapped(data->client, INA209_CONFIGURATION,
+				     regval);
 	data->regs[INA209_CONFIGURATION] = regval;
 	data->update_interval = ina209_interval_from_reg(regval);
 	mutex_unlock(&data->update_lock);
@@ -260,8 +260,7 @@ static ssize_t ina209_set_interval(struct device *dev,
 static ssize_t ina209_show_interval(struct device *dev,
 				    struct device_attribute *da, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ina209_data *data = i2c_get_clientdata(client);
+	struct ina209_data *data = dev_get_drvdata(dev);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", data->update_interval);
 }
@@ -285,9 +284,9 @@ static ssize_t ina209_reset_history(struct device *dev,
 				    const char *buf,
 				    size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ina209_data *data = i2c_get_clientdata(client);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
+	struct ina209_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	u32 mask = attr->index;
 	long val;
 	int i, ret;
@@ -312,7 +311,6 @@ static ssize_t ina209_set_value(struct device *dev,
 				const char *buf,
 				size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
 	struct ina209_data *data = ina209_update_device(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 	int reg = attr->index;
@@ -332,7 +330,7 @@ static ssize_t ina209_set_value(struct device *dev,
 		count = ret;
 		goto abort;
 	}
-	i2c_smbus_write_word_swapped(client, reg, ret);
+	i2c_smbus_write_word_swapped(data->client, reg, ret);
 	data->regs[reg] = ret;
 abort:
 	mutex_unlock(&data->update_lock);
@@ -457,7 +455,7 @@ static SENSOR_DEVICE_ATTR(update_interval, S_IRUGO | S_IWUSR,
  * Finally, construct an array of pointers to members of the above objects,
  * as required for sysfs_create_group()
  */
-static struct attribute *ina209_attributes[] = {
+static struct attribute *ina209_attrs[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
 	&sensor_dev_attr_in0_input_highest.dev_attr.attr,
 	&sensor_dev_attr_in0_input_lowest.dev_attr.attr,
@@ -498,10 +496,7 @@ static struct attribute *ina209_attributes[] = {
 
 	NULL,
 };
-
-static const struct attribute_group ina209_group = {
-	.attrs = ina209_attributes,
-};
+ATTRIBUTE_GROUPS(ina209);
 
 static void ina209_restore_conf(struct i2c_client *client,
 				struct ina209_data *data)
@@ -565,6 +560,7 @@ static int ina209_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct ina209_data *data;
+	struct device *hwmon_dev;
 	int ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
@@ -575,27 +571,23 @@ static int ina209_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	i2c_set_clientdata(client, data);
+	data->client = client;
 	mutex_init(&data->update_lock);
 
 	ret = ina209_init_client(client, data);
 	if (ret)
 		return ret;
 
-	/* Register sysfs hooks */
-	ret = sysfs_create_group(&client->dev.kobj, &ina209_group);
-	if (ret)
+	hwmon_dev = devm_hwmon_device_register_with_groups(&client->dev,
+							   client->name,
+							   data, ina209_groups);
+	if (IS_ERR(hwmon_dev)) {
+		ret = PTR_ERR(hwmon_dev);
 		goto out_restore_conf;
-
-	data->hwmon_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		ret = PTR_ERR(data->hwmon_dev);
-		goto out_hwmon_device_register;
 	}
 
 	return 0;
 
-out_hwmon_device_register:
-	sysfs_remove_group(&client->dev.kobj, &ina209_group);
 out_restore_conf:
 	ina209_restore_conf(client, data);
 	return ret;
@@ -605,8 +597,6 @@ static int ina209_remove(struct i2c_client *client)
 {
 	struct ina209_data *data = i2c_get_clientdata(client);
 
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &ina209_group);
 	ina209_restore_conf(client, data);
 
 	return 0;
-- 
1.7.9.7

