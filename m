Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab3INRO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:14:27 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62011 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab3INROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:24 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 11/11] hwmon: (jc42) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:52 -0700
Message-Id: <1379178832-1489-12-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/jc42.c |   61 +++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 4a58f13..f362cea 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -163,7 +163,7 @@ static struct jc42_chips jc42_chips[] = {
 
 /* Each client has this additional data */
 struct jc42_data {
-	struct device	*hwmon_dev;
+	struct i2c_client *client;
 	struct mutex	update_lock;	/* protect register access */
 	bool		extended;	/* true if extended range supported */
 	bool		valid;
@@ -193,21 +193,21 @@ MODULE_DEVICE_TABLE(i2c, jc42_id);
 
 static int jc42_suspend(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct jc42_data *data = i2c_get_clientdata(client);
+	struct jc42_data *data = dev_get_drvdata(dev);
 
 	data->config |= JC42_CFG_SHUTDOWN;
-	i2c_smbus_write_word_swapped(client, JC42_REG_CONFIG, data->config);
+	i2c_smbus_write_word_swapped(data->client, JC42_REG_CONFIG,
+				     data->config);
 	return 0;
 }
 
 static int jc42_resume(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct jc42_data *data = i2c_get_clientdata(client);
+	struct jc42_data *data = dev_get_drvdata(dev);
 
 	data->config &= ~JC42_CFG_SHUTDOWN;
-	i2c_smbus_write_word_swapped(client, JC42_REG_CONFIG, data->config);
+	i2c_smbus_write_word_swapped(data->client, JC42_REG_CONFIG,
+				     data->config);
 	return 0;
 }
 
@@ -317,15 +317,14 @@ static ssize_t set_##value(struct device *dev,				\
 			   struct device_attribute *attr,		\
 			   const char *buf, size_t count)		\
 {									\
-	struct i2c_client *client = to_i2c_client(dev);			\
-	struct jc42_data *data = i2c_get_clientdata(client);		\
+	struct jc42_data *data = dev_get_drvdata(dev);			\
 	int err, ret = count;						\
 	long val;							\
-	if (kstrtol(buf, 10, &val) < 0)				\
+	if (kstrtol(buf, 10, &val) < 0)					\
 		return -EINVAL;						\
 	mutex_lock(&data->update_lock);					\
 	data->value = jc42_temp_to_reg(val, data->extended);		\
-	err = i2c_smbus_write_word_swapped(client, reg, data->value);	\
+	err = i2c_smbus_write_word_swapped(data->client, reg, data->value); \
 	if (err < 0)							\
 		ret = err;						\
 	mutex_unlock(&data->update_lock);				\
@@ -344,8 +343,7 @@ static ssize_t set_temp_crit_hyst(struct device *dev,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct jc42_data *data = i2c_get_clientdata(client);
+	struct jc42_data *data = dev_get_drvdata(dev);
 	unsigned long val;
 	int diff, hyst;
 	int err;
@@ -368,7 +366,7 @@ static ssize_t set_temp_crit_hyst(struct device *dev,
 	mutex_lock(&data->update_lock);
 	data->config = (data->config & ~JC42_CFG_HYST_MASK)
 	  | (hyst << JC42_CFG_HYST_SHIFT);
-	err = i2c_smbus_write_word_swapped(client, JC42_REG_CONFIG,
+	err = i2c_smbus_write_word_swapped(data->client, JC42_REG_CONFIG,
 					   data->config);
 	if (err < 0)
 		ret = err;
@@ -430,8 +428,7 @@ static umode_t jc42_attribute_mode(struct kobject *kobj,
 				  struct attribute *attr, int index)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct i2c_client *client = to_i2c_client(dev);
-	struct jc42_data *data = i2c_get_clientdata(client);
+	struct jc42_data *data = dev_get_drvdata(dev);
 	unsigned int config = data->config;
 	bool readonly;
 
@@ -452,6 +449,7 @@ static const struct attribute_group jc42_group = {
 	.attrs = jc42_attributes,
 	.is_visible = jc42_attribute_mode,
 };
+__ATTRIBUTE_GROUPS(jc42);
 
 /* Return 0 if detection is successful, -ENODEV otherwise */
 static int jc42_detect(struct i2c_client *client, struct i2c_board_info *info)
@@ -487,14 +485,16 @@ static int jc42_detect(struct i2c_client *client, struct i2c_board_info *info)
 
 static int jc42_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct jc42_data *data;
-	int config, cap, err;
 	struct device *dev = &client->dev;
+	struct device *hwmon_dev;
+	struct jc42_data *data;
+	int config, cap;
 
 	data = devm_kzalloc(dev, sizeof(struct jc42_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
+	data->client = client;
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
 
@@ -515,29 +515,18 @@ static int jc42_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 	data->config = config;
 
-	/* Register sysfs hooks */
-	err = sysfs_create_group(&dev->kobj, &jc42_group);
-	if (err)
-		return err;
-
-	data->hwmon_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto exit_remove;
-	}
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
+							   data,
+							   jc42_groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
 
 	return 0;
-
-exit_remove:
-	sysfs_remove_group(&dev->kobj, &jc42_group);
-	return err;
 }
 
 static int jc42_remove(struct i2c_client *client)
 {
 	struct jc42_data *data = i2c_get_clientdata(client);
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &jc42_group);
 
 	/* Restore original configuration except hysteresis */
 	if ((data->config & ~JC42_CFG_HYST_MASK) !=
@@ -553,8 +542,8 @@ static int jc42_remove(struct i2c_client *client)
 
 static struct jc42_data *jc42_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct jc42_data *data = i2c_get_clientdata(client);
+	struct jc42_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	struct jc42_data *ret = data;
 	int val;
 
-- 
1.7.9.7

