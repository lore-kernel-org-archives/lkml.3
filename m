Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab3INRPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:15:25 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45583 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab3INROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:17 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 08/11] hwmon: (lm95234) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:49 -0700
Message-Id: <1379178832-1489-9-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also use new macro ATTRIBUTE_GROUPS to declare attribute groups.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/lm95234.c |  137 +++++++++++++++++------------------------------
 1 file changed, 50 insertions(+), 87 deletions(-)

diff --git a/drivers/hwmon/lm95234.c b/drivers/hwmon/lm95234.c
index 307c9ea..cf87507 100644
--- a/drivers/hwmon/lm95234.c
+++ b/drivers/hwmon/lm95234.c
@@ -57,7 +57,7 @@ static const unsigned short normal_i2c[] = { 0x18, 0x4d, 0x4e, I2C_CLIENT_END };
 
 /* Client data (each client gets its own) */
 struct lm95234_data {
-	struct device *hwmon_dev;
+	struct i2c_client *client;
 	struct mutex update_lock;
 	unsigned long last_updated, interval;	/* in jiffies */
 	bool valid;		/* false until following fields are valid */
@@ -114,9 +114,9 @@ static u16 update_intervals[] = { 143, 364, 1000, 2500 };
 
 /* Fill value cache. Must be called with update lock held. */
 
-static int lm95234_fill_cache(struct i2c_client *client)
+static int lm95234_fill_cache(struct lm95234_data *data,
+			      struct i2c_client *client)
 {
-	struct lm95234_data *data = i2c_get_clientdata(client);
 	int i, ret;
 
 	ret = i2c_smbus_read_byte_data(client, LM95234_REG_CONVRATE);
@@ -157,9 +157,9 @@ static int lm95234_fill_cache(struct i2c_client *client)
 	return 0;
 }
 
-static int lm95234_update_device(struct i2c_client *client,
-				 struct lm95234_data *data)
+static int lm95234_update_device(struct lm95234_data *data)
 {
+	struct i2c_client *client = data->client;
 	int ret;
 
 	mutex_lock(&data->update_lock);
@@ -169,7 +169,7 @@ static int lm95234_update_device(struct i2c_client *client,
 		int i;
 
 		if (!data->valid) {
-			ret = lm95234_fill_cache(client);
+			ret = lm95234_fill_cache(data, client);
 			if (ret < 0)
 				goto abort;
 		}
@@ -209,10 +209,9 @@ abort:
 static ssize_t show_temp(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -224,10 +223,9 @@ static ssize_t show_temp(struct device *dev, struct device_attribute *attr,
 static ssize_t show_alarm(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	u32 mask = to_sensor_dev_attr(attr)->index;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -238,10 +236,9 @@ static ssize_t show_alarm(struct device *dev,
 static ssize_t show_type(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	u8 mask = to_sensor_dev_attr(attr)->index;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -252,11 +249,10 @@ static ssize_t show_type(struct device *dev, struct device_attribute *attr,
 static ssize_t set_type(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	unsigned long val;
 	u8 mask = to_sensor_dev_attr(attr)->index;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -274,7 +270,7 @@ static ssize_t set_type(struct device *dev, struct device_attribute *attr,
 	else
 		data->sensor_type &= ~mask;
 	data->valid = false;
-	i2c_smbus_write_byte_data(client, LM95234_REG_REM_MODEL,
+	i2c_smbus_write_byte_data(data->client, LM95234_REG_REM_MODEL,
 				  data->sensor_type);
 	mutex_unlock(&data->update_lock);
 
@@ -284,10 +280,9 @@ static ssize_t set_type(struct device *dev, struct device_attribute *attr,
 static ssize_t show_tcrit2(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -298,11 +293,10 @@ static ssize_t show_tcrit2(struct device *dev, struct device_attribute *attr,
 static ssize_t set_tcrit2(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
 	long val;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -315,7 +309,7 @@ static ssize_t set_tcrit2(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	data->tcrit2[index] = val;
-	i2c_smbus_write_byte_data(client, LM95234_REG_TCRIT2(index), val);
+	i2c_smbus_write_byte_data(data->client, LM95234_REG_TCRIT2(index), val);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -324,10 +318,9 @@ static ssize_t set_tcrit2(struct device *dev, struct device_attribute *attr,
 static ssize_t show_tcrit2_hyst(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -340,8 +333,7 @@ static ssize_t show_tcrit2_hyst(struct device *dev,
 static ssize_t show_tcrit1(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
 
 	return sprintf(buf, "%u", data->tcrit1[index] * 1000);
@@ -350,11 +342,10 @@ static ssize_t show_tcrit1(struct device *dev, struct device_attribute *attr,
 static ssize_t set_tcrit1(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
+	int ret = lm95234_update_device(data);
 	long val;
-	int ret = lm95234_update_device(client, data);
 
 	if (ret)
 		return ret;
@@ -367,7 +358,7 @@ static ssize_t set_tcrit1(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	data->tcrit1[index] = val;
-	i2c_smbus_write_byte_data(client, LM95234_REG_TCRIT1(index), val);
+	i2c_smbus_write_byte_data(data->client, LM95234_REG_TCRIT1(index), val);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -376,10 +367,9 @@ static ssize_t set_tcrit1(struct device *dev, struct device_attribute *attr,
 static ssize_t show_tcrit1_hyst(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -393,11 +383,10 @@ static ssize_t set_tcrit1_hyst(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
+	int ret = lm95234_update_device(data);
 	long val;
-	int ret = lm95234_update_device(client, data);
 
 	if (ret)
 		return ret;
@@ -411,7 +400,7 @@ static ssize_t set_tcrit1_hyst(struct device *dev,
 
 	mutex_lock(&data->update_lock);
 	data->thyst = val;
-	i2c_smbus_write_byte_data(client, LM95234_REG_TCRIT_HYST, val);
+	i2c_smbus_write_byte_data(data->client, LM95234_REG_TCRIT_HYST, val);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -420,10 +409,9 @@ static ssize_t set_tcrit1_hyst(struct device *dev,
 static ssize_t show_offset(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
-	int ret = lm95234_update_device(client, data);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -434,11 +422,10 @@ static ssize_t show_offset(struct device *dev, struct device_attribute *attr,
 static ssize_t set_offset(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(attr)->index;
+	int ret = lm95234_update_device(data);
 	long val;
-	int ret = lm95234_update_device(client, data);
 
 	if (ret)
 		return ret;
@@ -452,7 +439,7 @@ static ssize_t set_offset(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	data->toffset[index] = val;
-	i2c_smbus_write_byte_data(client, LM95234_REG_OFFSET(index), val);
+	i2c_smbus_write_byte_data(data->client, LM95234_REG_OFFSET(index), val);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -461,9 +448,8 @@ static ssize_t set_offset(struct device *dev, struct device_attribute *attr,
 static ssize_t show_interval(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
-	int ret = lm95234_update_device(client, data);
+	struct lm95234_data *data = dev_get_drvdata(dev);
+	int ret = lm95234_update_device(data);
 
 	if (ret)
 		return ret;
@@ -475,11 +461,10 @@ static ssize_t show_interval(struct device *dev, struct device_attribute *attr,
 static ssize_t set_interval(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm95234_data *data = i2c_get_clientdata(client);
+	struct lm95234_data *data = dev_get_drvdata(dev);
+	int ret = lm95234_update_device(data);
 	unsigned long val;
 	u8 regval;
-	int ret = lm95234_update_device(client, data);
 
 	if (ret)
 		return ret;
@@ -495,7 +480,7 @@ static ssize_t set_interval(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	data->interval = msecs_to_jiffies(update_intervals[regval]);
-	i2c_smbus_write_byte_data(client, LM95234_REG_CONVRATE, regval);
+	i2c_smbus_write_byte_data(data->client, LM95234_REG_CONVRATE, regval);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -579,7 +564,7 @@ static SENSOR_DEVICE_ATTR(temp5_offset, S_IWUSR | S_IRUGO, show_offset,
 static DEVICE_ATTR(update_interval, S_IWUSR | S_IRUGO, show_interval,
 		   set_interval);
 
-static struct attribute *lm95234_attributes[] = {
+static struct attribute *lm95234_attrs[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	&sensor_dev_attr_temp2_input.dev_attr.attr,
 	&sensor_dev_attr_temp3_input.dev_attr.attr,
@@ -621,10 +606,7 @@ static struct attribute *lm95234_attributes[] = {
 	&dev_attr_update_interval.attr,
 	NULL
 };
-
-static const struct attribute_group lm95234_group = {
-	.attrs = lm95234_attributes,
-};
+ATTRIBUTE_GROUPS(lm95234);
 
 static int lm95234_detect(struct i2c_client *client,
 			  struct i2c_board_info *info)
@@ -701,13 +683,14 @@ static int lm95234_probe(struct i2c_client *client,
 {
 	struct device *dev = &client->dev;
 	struct lm95234_data *data;
+	struct device *hwmon_dev;
 	int err;
 
 	data = devm_kzalloc(dev, sizeof(struct lm95234_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, data);
+	data->client = client;
 	mutex_init(&data->update_lock);
 
 	/* Initialize the LM95234 chip */
@@ -715,30 +698,11 @@ static int lm95234_probe(struct i2c_client *client,
 	if (err < 0)
 		return err;
 
-	/* Register sysfs hooks */
-	err = sysfs_create_group(&dev->kobj, &lm95234_group);
-	if (err)
-		return err;
-
-	data->hwmon_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto exit_remove_files;
-	}
-
-	return 0;
-
-exit_remove_files:
-	sysfs_remove_group(&dev->kobj, &lm95234_group);
-	return err;
-}
-
-static int lm95234_remove(struct i2c_client *client)
-{
-	struct lm95234_data *data = i2c_get_clientdata(client);
-
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &lm95234_group);
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
+							   data,
+							   lm95234_groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
 
 	return 0;
 }
@@ -756,7 +720,6 @@ static struct i2c_driver lm95234_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= lm95234_probe,
-	.remove		= lm95234_remove,
 	.id_table	= lm95234_id,
 	.detect		= lm95234_detect,
 	.address_list	= normal_i2c,
-- 
1.7.9.7

