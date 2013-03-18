Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3CRBq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:46:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49851 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3CRBqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:46:13 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 17 Mar 2013 20:46:09 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 8/8] hwmon: (tmp401) Convert to devm_hwmon_device_register API
Date: Sun, 17 Mar 2013 18:45:57 -0700
Message-Id: <1363571157-16273-9-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
References: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/tmp401.c |  184 ++++++++++++++++++++++++------------------------
 1 file changed, 92 insertions(+), 92 deletions(-)

diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index c85f696..69b5293 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -108,6 +108,7 @@ MODULE_DEVICE_TABLE(i2c, tmp401_id);
 
 struct tmp401_data {
 	struct device *hwmon_dev;
+	const struct attribute_group *groups[3];
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -213,7 +214,7 @@ static struct tmp401_data *tmp401_update_device_reg16(
 
 static struct tmp401_data *tmp401_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct tmp401_data *data = i2c_get_clientdata(client);
 
 	mutex_lock(&data->update_lock);
@@ -329,6 +330,7 @@ static ssize_t show_status(struct device *dev,
 static ssize_t store_temp_min(struct device *dev, struct device_attribute
 	*devattr, const char *buf, size_t count)
 {
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct tmp401_data *data = tmp401_update_device(dev);
 	long val;
@@ -341,9 +343,9 @@ static ssize_t store_temp_min(struct device *dev, struct device_attribute
 
 	mutex_lock(&data->update_lock);
 
-	i2c_smbus_write_byte_data(to_i2c_client(dev),
+	i2c_smbus_write_byte_data(client,
 		TMP401_TEMP_LOW_LIMIT_MSB_WRITE[index], reg >> 8);
-	i2c_smbus_write_byte_data(to_i2c_client(dev),
+	i2c_smbus_write_byte_data(client,
 		TMP401_TEMP_LOW_LIMIT_LSB[index], reg & 0xFF);
 
 	data->temp_low[index] = reg;
@@ -356,6 +358,7 @@ static ssize_t store_temp_min(struct device *dev, struct device_attribute
 static ssize_t store_temp_max(struct device *dev, struct device_attribute
 	*devattr, const char *buf, size_t count)
 {
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct tmp401_data *data = tmp401_update_device(dev);
 	long val;
@@ -368,9 +371,9 @@ static ssize_t store_temp_max(struct device *dev, struct device_attribute
 
 	mutex_lock(&data->update_lock);
 
-	i2c_smbus_write_byte_data(to_i2c_client(dev),
+	i2c_smbus_write_byte_data(client,
 		TMP401_TEMP_HIGH_LIMIT_MSB_WRITE[index], reg >> 8);
-	i2c_smbus_write_byte_data(to_i2c_client(dev),
+	i2c_smbus_write_byte_data(client,
 		TMP401_TEMP_HIGH_LIMIT_LSB[index], reg & 0xFF);
 
 	data->temp_high[index] = reg;
@@ -395,7 +398,7 @@ static ssize_t store_temp_crit(struct device *dev, struct device_attribute
 
 	mutex_lock(&data->update_lock);
 
-	i2c_smbus_write_byte_data(to_i2c_client(dev),
+	i2c_smbus_write_byte_data(to_i2c_client(dev->parent),
 		TMP401_TEMP_CRIT_LIMIT[index], reg);
 
 	data->temp_crit[index] = reg;
@@ -427,7 +430,7 @@ static ssize_t store_temp_crit_hyst(struct device *dev, struct device_attribute
 	val = clamp_val(val, temp - 255000, temp);
 	reg = ((temp - val) + 500) / 1000;
 
-	i2c_smbus_write_byte_data(to_i2c_client(dev),
+	i2c_smbus_write_byte_data(to_i2c_client(dev->parent),
 		TMP401_TEMP_CRIT_HYST, reg);
 
 	data->temp_crit_hyst = reg;
@@ -455,44 +458,68 @@ static ssize_t reset_temp_history(struct device *dev,
 			" supported. Use 1 to reset the history!\n", val);
 		return -EINVAL;
 	}
-	i2c_smbus_write_byte_data(to_i2c_client(dev),
+	i2c_smbus_write_byte_data(to_i2c_client(dev->parent),
 		TMP411_TEMP_LOWEST_MSB[0], val);
 
 	return count;
 }
 
-static struct sensor_device_attribute tmp401_attr[] = {
-	SENSOR_ATTR(temp1_input, S_IRUGO, show_temp_value, NULL, 0),
-	SENSOR_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_temp_min,
-		    store_temp_min, 0),
-	SENSOR_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
-		    store_temp_max, 0),
-	SENSOR_ATTR(temp1_crit, S_IWUSR | S_IRUGO, show_temp_crit,
-		    store_temp_crit, 0),
-	SENSOR_ATTR(temp1_crit_hyst, S_IWUSR | S_IRUGO, show_temp_crit_hyst,
-		    store_temp_crit_hyst, 0),
-	SENSOR_ATTR(temp1_min_alarm, S_IRUGO, show_status, NULL,
-		    TMP401_STATUS_LOCAL_LOW),
-	SENSOR_ATTR(temp1_max_alarm, S_IRUGO, show_status, NULL,
-		    TMP401_STATUS_LOCAL_HIGH),
-	SENSOR_ATTR(temp1_crit_alarm, S_IRUGO, show_status, NULL,
-		    TMP401_STATUS_LOCAL_CRIT),
-	SENSOR_ATTR(temp2_input, S_IRUGO, show_temp_value, NULL, 1),
-	SENSOR_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_temp_min,
-		    store_temp_min, 1),
-	SENSOR_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_temp_max,
-		    store_temp_max, 1),
-	SENSOR_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_temp_crit,
-		    store_temp_crit, 1),
-	SENSOR_ATTR(temp2_crit_hyst, S_IRUGO, show_temp_crit_hyst, NULL, 1),
-	SENSOR_ATTR(temp2_fault, S_IRUGO, show_status, NULL,
-		    TMP401_STATUS_REMOTE_OPEN),
-	SENSOR_ATTR(temp2_min_alarm, S_IRUGO, show_status, NULL,
-		    TMP401_STATUS_REMOTE_LOW),
-	SENSOR_ATTR(temp2_max_alarm, S_IRUGO, show_status, NULL,
-		    TMP401_STATUS_REMOTE_HIGH),
-	SENSOR_ATTR(temp2_crit_alarm, S_IRUGO, show_status, NULL,
-		    TMP401_STATUS_REMOTE_CRIT),
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp_value, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_temp_min,
+			  store_temp_min, 0);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
+			  store_temp_max, 0);
+static SENSOR_DEVICE_ATTR(temp1_crit, S_IWUSR | S_IRUGO, show_temp_crit,
+			  store_temp_crit, 0);
+static SENSOR_DEVICE_ATTR(temp1_crit_hyst, S_IWUSR | S_IRUGO,
+			  show_temp_crit_hyst, store_temp_crit_hyst, 0);
+static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO, show_status, NULL,
+			  TMP401_STATUS_LOCAL_LOW);
+static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_status, NULL,
+			  TMP401_STATUS_LOCAL_HIGH);
+static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_status, NULL,
+			  TMP401_STATUS_LOCAL_CRIT);
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_temp_value, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_temp_min,
+			  store_temp_min, 1);
+static SENSOR_DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_temp_max,
+			  store_temp_max, 1);
+static SENSOR_DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_temp_crit,
+			  store_temp_crit, 1);
+static SENSOR_DEVICE_ATTR(temp2_crit_hyst, S_IRUGO, show_temp_crit_hyst,
+			  NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_status, NULL,
+			  TMP401_STATUS_REMOTE_OPEN);
+static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, show_status, NULL,
+			  TMP401_STATUS_REMOTE_LOW);
+static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO, show_status, NULL,
+			  TMP401_STATUS_REMOTE_HIGH);
+static SENSOR_DEVICE_ATTR(temp2_crit_alarm, S_IRUGO, show_status, NULL,
+			  TMP401_STATUS_REMOTE_CRIT);
+
+static struct attribute *tmp401_attributes[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_min.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_min.dev_attr.attr,
+	&sensor_dev_attr_temp2_max.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp2_fault.dev_attr.attr,
+	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group tmp401_group = {
+	.attrs = tmp401_attributes,
 };
 
 /*
@@ -502,12 +529,24 @@ static struct sensor_device_attribute tmp401_attr[] = {
  * minimum and maximum register reset for both the local
  * and remote channels.
  */
-static struct sensor_device_attribute tmp411_attr[] = {
-	SENSOR_ATTR(temp1_highest, S_IRUGO, show_temp_highest, NULL, 0),
-	SENSOR_ATTR(temp1_lowest, S_IRUGO, show_temp_lowest, NULL, 0),
-	SENSOR_ATTR(temp2_highest, S_IRUGO, show_temp_highest, NULL, 1),
-	SENSOR_ATTR(temp2_lowest, S_IRUGO, show_temp_lowest, NULL, 1),
-	SENSOR_ATTR(temp_reset_history, S_IWUSR, NULL, reset_temp_history, 0),
+static SENSOR_DEVICE_ATTR(temp1_highest, S_IRUGO, show_temp_highest, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_lowest, S_IRUGO, show_temp_lowest, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_highest, S_IRUGO, show_temp_highest, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_lowest, S_IRUGO, show_temp_lowest, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp_reset_history, S_IWUSR, NULL, reset_temp_history,
+			  0);
+
+static struct attribute *tmp411_attributes[] = {
+	&sensor_dev_attr_temp1_highest.dev_attr.attr,
+	&sensor_dev_attr_temp1_lowest.dev_attr.attr,
+	&sensor_dev_attr_temp2_highest.dev_attr.attr,
+	&sensor_dev_attr_temp2_lowest.dev_attr.attr,
+	&sensor_dev_attr_temp_reset_history.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group tmp411_group = {
+	.attrs = tmp411_attributes,
 };
 
 /*
@@ -577,30 +616,9 @@ static int tmp401_detect(struct i2c_client *client,
 	return 0;
 }
 
-static int tmp401_remove(struct i2c_client *client)
-{
-	struct tmp401_data *data = i2c_get_clientdata(client);
-	int i;
-
-	if (data->hwmon_dev)
-		hwmon_device_unregister(data->hwmon_dev);
-
-	for (i = 0; i < ARRAY_SIZE(tmp401_attr); i++)
-		device_remove_file(&client->dev, &tmp401_attr[i].dev_attr);
-
-	if (data->kind == tmp411) {
-		for (i = 0; i < ARRAY_SIZE(tmp411_attr); i++)
-			device_remove_file(&client->dev,
-					   &tmp411_attr[i].dev_attr);
-	}
-
-	return 0;
-}
-
 static int tmp401_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	int i, err = 0;
 	struct tmp401_data *data;
 	const char *names[] = { "TMP401", "TMP411" };
 
@@ -617,37 +635,20 @@ static int tmp401_probe(struct i2c_client *client,
 	tmp401_init_client(client);
 
 	/* Register sysfs hooks */
-	for (i = 0; i < ARRAY_SIZE(tmp401_attr); i++) {
-		err = device_create_file(&client->dev,
-					 &tmp401_attr[i].dev_attr);
-		if (err)
-			goto exit_remove;
-	}
+	data->groups[0] = &tmp401_group;
 
 	/* Register additional tmp411 sysfs hooks */
-	if (data->kind == tmp411) {
-		for (i = 0; i < ARRAY_SIZE(tmp411_attr); i++) {
-			err = device_create_file(&client->dev,
-						 &tmp411_attr[i].dev_attr);
-			if (err)
-				goto exit_remove;
-		}
-	}
+	if (data->kind == tmp411)
+		data->groups[1] = &tmp411_group;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		data->hwmon_dev = NULL;
-		goto exit_remove;
-	}
+	data->hwmon_dev = devm_hwmon_device_register(&client->dev,
+						     data->groups, id->name);
+	if (IS_ERR(data->hwmon_dev))
+		return PTR_ERR(data->hwmon_dev);
 
 	dev_info(&client->dev, "Detected TI %s chip\n", names[data->kind]);
 
 	return 0;
-
-exit_remove:
-	tmp401_remove(client);
-	return err;
 }
 
 static struct i2c_driver tmp401_driver = {
@@ -656,7 +657,6 @@ static struct i2c_driver tmp401_driver = {
 		.name	= "tmp401",
 	},
 	.probe		= tmp401_probe,
-	.remove		= tmp401_remove,
 	.id_table	= tmp401_id,
 	.detect		= tmp401_detect,
 	.address_list	= normal_i2c,
-- 
1.7.9.7

