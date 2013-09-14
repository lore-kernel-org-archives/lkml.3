Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab3INROK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:14:10 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60204 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab3INROH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:07 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 03/11] hwmon: (lm73) Convert to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:44 -0700
Message-Id: <1379178832-1489-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
References: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also introduce new variable dev pointing to client->dev in the probe
function, and use new macro ATTRIBUTE_GROUPS to declare attribute groups.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/lm73.c |   70 ++++++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 48 deletions(-)

diff --git a/drivers/hwmon/lm73.c b/drivers/hwmon/lm73.c
index 9bde964..9653bb8 100644
--- a/drivers/hwmon/lm73.c
+++ b/drivers/hwmon/lm73.c
@@ -55,7 +55,7 @@ static const unsigned short lm73_convrates[] = {
 };
 
 struct lm73_data {
-	struct device *hwmon_dev;
+	struct i2c_client *client;
 	struct mutex lock;
 	u8 ctrl;			/* control register value */
 };
@@ -66,7 +66,7 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 			const char *buf, size_t count)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
-	struct i2c_client *client = to_i2c_client(dev);
+	struct lm73_data *data = dev_get_drvdata(dev);
 	long temp;
 	short value;
 	s32 err;
@@ -77,7 +77,7 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 
 	/* Write value */
 	value = clamp_val(temp / 250, LM73_TEMP_MIN, LM73_TEMP_MAX) << 5;
-	err = i2c_smbus_write_word_swapped(client, attr->index, value);
+	err = i2c_smbus_write_word_swapped(data->client, attr->index, value);
 	return (err < 0) ? err : count;
 }
 
@@ -85,10 +85,10 @@ static ssize_t show_temp(struct device *dev, struct device_attribute *da,
 			 char *buf)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
-	struct i2c_client *client = to_i2c_client(dev);
+	struct lm73_data *data = dev_get_drvdata(dev);
 	int temp;
 
-	s32 err = i2c_smbus_read_word_swapped(client, attr->index);
+	s32 err = i2c_smbus_read_word_swapped(data->client, attr->index);
 	if (err < 0)
 		return err;
 
@@ -101,8 +101,7 @@ static ssize_t show_temp(struct device *dev, struct device_attribute *da,
 static ssize_t set_convrate(struct device *dev, struct device_attribute *da,
 			    const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm73_data *data = i2c_get_clientdata(client);
+	struct lm73_data *data = dev_get_drvdata(dev);
 	unsigned long convrate;
 	s32 err;
 	int res = 0;
@@ -124,7 +123,8 @@ static ssize_t set_convrate(struct device *dev, struct device_attribute *da,
 	mutex_lock(&data->lock);
 	data->ctrl &= LM73_CTRL_TO_MASK;
 	data->ctrl |= res << LM73_CTRL_RES_SHIFT;
-	err = i2c_smbus_write_byte_data(client, LM73_REG_CTRL, data->ctrl);
+	err = i2c_smbus_write_byte_data(data->client, LM73_REG_CTRL,
+					data->ctrl);
 	mutex_unlock(&data->lock);
 
 	if (err < 0)
@@ -136,8 +136,7 @@ static ssize_t set_convrate(struct device *dev, struct device_attribute *da,
 static ssize_t show_convrate(struct device *dev, struct device_attribute *da,
 			     char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lm73_data *data = i2c_get_clientdata(client);
+	struct lm73_data *data = dev_get_drvdata(dev);
 	int res;
 
 	res = (data->ctrl & LM73_CTRL_RES_MASK) >> LM73_CTRL_RES_SHIFT;
@@ -147,13 +146,12 @@ static ssize_t show_convrate(struct device *dev, struct device_attribute *da,
 static ssize_t show_maxmin_alarm(struct device *dev,
 				 struct device_attribute *da, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
-	struct lm73_data *data = i2c_get_clientdata(client);
+	struct lm73_data *data = dev_get_drvdata(dev);
 	s32 ctrl;
 
 	mutex_lock(&data->lock);
-	ctrl = i2c_smbus_read_byte_data(client, LM73_REG_CTRL);
+	ctrl = i2c_smbus_read_byte_data(data->client, LM73_REG_CTRL);
 	if (ctrl < 0)
 		goto abort;
 	data->ctrl = ctrl;
@@ -183,7 +181,7 @@ static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO,
 static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO,
 			show_maxmin_alarm, NULL, LM73_CTRL_LO_SHIFT);
 
-static struct attribute *lm73_attributes[] = {
+static struct attribute *lm73_attrs[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
 	&sensor_dev_attr_temp1_min.dev_attr.attr,
@@ -192,10 +190,7 @@ static struct attribute *lm73_attributes[] = {
 	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
 	NULL
 };
-
-static const struct attribute_group lm73_group = {
-	.attrs = lm73_attributes,
-};
+ATTRIBUTE_GROUPS(lm73);
 
 /*-----------------------------------------------------------------------*/
 
@@ -204,16 +199,16 @@ static const struct attribute_group lm73_group = {
 static int
 lm73_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	int status;
+	struct device *dev = &client->dev;
+	struct device *hwmon_dev;
 	struct lm73_data *data;
 	int ctrl;
 
-	data = devm_kzalloc(&client->dev, sizeof(struct lm73_data),
-			    GFP_KERNEL);
+	data = devm_kzalloc(dev, sizeof(struct lm73_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, data);
+	data->client = client;
 	mutex_init(&data->lock);
 
 	ctrl = i2c_smbus_read_byte_data(client, LM73_REG_CTRL);
@@ -221,33 +216,13 @@ lm73_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return ctrl;
 	data->ctrl = ctrl;
 
-	/* Register sysfs hooks */
-	status = sysfs_create_group(&client->dev.kobj, &lm73_group);
-	if (status)
-		return status;
-
-	data->hwmon_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		status = PTR_ERR(data->hwmon_dev);
-		goto exit_remove;
-	}
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
+							   data, lm73_groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
 
-	dev_info(&client->dev, "%s: sensor '%s'\n",
-		 dev_name(data->hwmon_dev), client->name);
-
-	return 0;
-
-exit_remove:
-	sysfs_remove_group(&client->dev.kobj, &lm73_group);
-	return status;
-}
-
-static int lm73_remove(struct i2c_client *client)
-{
-	struct lm73_data *data = i2c_get_clientdata(client);
+	dev_info(dev, "sensor '%s'\n", client->name);
 
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &lm73_group);
 	return 0;
 }
 
@@ -300,7 +275,6 @@ static struct i2c_driver lm73_driver = {
 		.name	= "lm73",
 	},
 	.probe		= lm73_probe,
-	.remove		= lm73_remove,
 	.id_table	= lm73_ids,
 	.detect		= lm73_detect,
 	.address_list	= normal_i2c,
-- 
1.7.9.7

