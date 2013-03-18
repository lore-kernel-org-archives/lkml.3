Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3CRBq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:46:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49856 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3CRBqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:46:13 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 17 Mar 2013 20:46:08 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 7/8] hwmon: (max16065) Convert to devm_hwmon_device_register API
Date: Sun, 17 Mar 2013 18:45:56 -0700
Message-Id: <1363571157-16273-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
References: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/max16065.c |  103 +++++++++++++++++++++-------------------------
 1 file changed, 47 insertions(+), 56 deletions(-)

diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index 2fa2c02..cb05219 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -84,6 +84,7 @@ static const bool max16065_have_current[] = {
 struct max16065_data {
 	enum chips type;
 	struct device *hwmon_dev;
+	const struct attribute_group *groups[4];
 	struct mutex update_lock;
 	bool valid;
 	unsigned long last_updated; /* in jiffies */
@@ -144,7 +145,7 @@ static int max16065_read_adc(struct i2c_client *client, int reg)
 
 static struct max16065_data *max16065_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct max16065_data *data = i2c_get_clientdata(client);
 
 	mutex_lock(&data->update_lock);
@@ -186,7 +187,7 @@ static ssize_t max16065_show_alarm(struct device *dev,
 
 	val &= (1 << attr2->index);
 	if (val)
-		i2c_smbus_write_byte_data(to_i2c_client(dev),
+		i2c_smbus_write_byte_data(to_i2c_client(dev->parent),
 					  MAX16065_FAULT(attr2->nr), val);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", !!val);
@@ -223,7 +224,7 @@ static ssize_t max16065_set_limit(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct sensor_device_attribute_2 *attr2 = to_sensor_dev_attr_2(da);
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct max16065_data *data = i2c_get_clientdata(client);
 	unsigned long val;
 	int err;
@@ -250,7 +251,7 @@ static ssize_t max16065_show_limit(struct device *dev,
 				   struct device_attribute *da, char *buf)
 {
 	struct sensor_device_attribute_2 *attr2 = to_sensor_dev_attr_2(da);
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct max16065_data *data = i2c_get_clientdata(client);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
@@ -516,36 +517,58 @@ static struct attribute *max16065_max_attributes[] = {
 	NULL
 };
 
+static umode_t max16065_basic_is_visible(struct kobject *kobj,
+					 struct attribute *attr, int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct max16065_data *data = i2c_get_clientdata(client);
+	int channel = index / 4;
+
+	if (channel >= data->num_adc || !data->range[channel])
+		return 0;
+
+	return attr->mode;
+}
+
 static const struct attribute_group max16065_basic_group = {
 	.attrs = max16065_basic_attributes,
+	.is_visible = max16065_basic_is_visible,
 };
 
 static const struct attribute_group max16065_current_group = {
 	.attrs = max16065_current_attributes,
 };
 
+static umode_t max16065_limit_is_visible(struct kobject *kobj,
+					 struct attribute *attr, int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct max16065_data *data = i2c_get_clientdata(client);
+
+	if (index >= data->num_adc || !data->range[index])
+		return 0;
+
+	return attr->mode;
+}
+
 static const struct attribute_group max16065_min_group = {
 	.attrs = max16065_min_attributes,
+	.is_visible = max16065_limit_is_visible,
 };
 
 static const struct attribute_group max16065_max_group = {
 	.attrs = max16065_max_attributes,
+	.is_visible = max16065_limit_is_visible,
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
+	int i, j, val, group = 0;
 	bool have_secondary;		/* true if chip has secondary limits */
 	bool secondary_is_max = false;	/* secondary limits reflect max */
 
@@ -597,37 +620,17 @@ static int max16065_probe(struct i2c_client *client,
 	}
 
 	/* Register sysfs hooks */
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
+	data->groups[group++] = &max16065_basic_group;
 
 	if (have_secondary) {
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
+		data->groups[group++] =
+		  secondary_is_max ? &max16065_max_group : &max16065_min_group;
 	}
 
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
@@ -636,34 +639,22 @@ static int max16065_probe(struct i2c_client *client,
 			data->curr_gain = 6 << ((val >> 2) & 0x03);
 			data->range[MAX16065_NUM_ADC]
 			  = max16065_csp_adc_range[(val >> 1) & 0x01];
-			ret = sysfs_create_group(&client->dev.kobj,
-						 &max16065_current_group);
-			if (unlikely(ret))
-				goto out;
+			data->groups[group++] = &max16065_current_group;
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
+	data->hwmon_dev = devm_hwmon_device_register(&client->dev,
+						     data->groups, id->name);
+	if (unlikely(IS_ERR(data->hwmon_dev)))
+		return PTR_ERR(data->hwmon_dev);
 
-out:
-	max16065_cleanup(client);
-	return ret;
+	return 0;
 }
 
 static int max16065_remove(struct i2c_client *client)
 {
-	struct max16065_data *data = i2c_get_clientdata(client);
-
-	hwmon_device_unregister(data->hwmon_dev);
-	max16065_cleanup(client);
-
 	return 0;
 }
 
-- 
1.7.9.7

