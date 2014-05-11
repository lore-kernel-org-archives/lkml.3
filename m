Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbaEKKcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 06:32:08 -0400
Received: from we2-f167.wedos.net ([46.28.105.74]:42699 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaEKKcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 06:32:03 -0400
Date: Sun, 11 May 2014 12:31:52 +0200
From: Josef Gajdusek <atx@atx.name>
To: jdelvare@suse.de
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/hwmon: bugfix and support for emc1412 in emc1403.c
Message-ID: <20140511103152.GA5631@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for emc1412 to emc1403.c + minor bugfix

* Renamed generic thermal_* prefixed names to emc1403_*
* Fixed set_hyst being broken (i. e. writing 86000 set hysteresis to 84000)
* Added support for emc1412

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 90ec117..05e9f1f 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -34,13 +34,14 @@
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
 
-#define THERMAL_PID_REG		0xfd
-#define THERMAL_SMSC_ID_REG	0xfe
-#define THERMAL_REVISION_REG	0xff
+#define EMC1403_HYST_REG		0x21
+#define EMC1403_PID_REG			0xfd
+#define EMC1403_SMSC_ID_REG		0xfe
+#define EMC1403_REVISION_REG	0xff
 
-struct thermal_data {
+struct emc1403_data {
 	struct i2c_client *client;
-	const struct attribute_group *groups[3];
+	const struct attribute_group *groups[2];
 	struct mutex mutex;
 	/*
 	 * Cache the hyst value so we don't keep re-reading it. In theory
@@ -54,7 +55,7 @@ static ssize_t show_temp(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
 	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
-	struct thermal_data *data = dev_get_drvdata(dev);
+	struct emc1403_data *data = dev_get_drvdata(dev);
 	int retval;
 
 	retval = i2c_smbus_read_byte_data(data->client, sda->index);
@@ -67,7 +68,7 @@ static ssize_t show_bit(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
 	struct sensor_device_attribute_2 *sda = to_sensor_dev_attr_2(attr);
-	struct thermal_data *data = dev_get_drvdata(dev);
+	struct emc1403_data *data = dev_get_drvdata(dev);
 	int retval;
 
 	retval = i2c_smbus_read_byte_data(data->client, sda->nr);
@@ -80,7 +81,7 @@ static ssize_t store_temp(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
-	struct thermal_data *data = dev_get_drvdata(dev);
+	struct emc1403_data *data = dev_get_drvdata(dev);
 	unsigned long val;
 	int retval;
 
@@ -97,7 +98,7 @@ static ssize_t store_bit(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct sensor_device_attribute_2 *sda = to_sensor_dev_attr_2(attr);
-	struct thermal_data *data = dev_get_drvdata(dev);
+	struct emc1403_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
 	unsigned long val;
 	int retval;
@@ -126,7 +127,7 @@ static ssize_t show_hyst(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
 	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
-	struct thermal_data *data = dev_get_drvdata(dev);
+	struct emc1403_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
 	int retval;
 	int hyst;
@@ -136,7 +137,7 @@ static ssize_t show_hyst(struct device *dev,
 		return retval;
 
 	if (time_after(jiffies, data->hyst_valid)) {
-		hyst = i2c_smbus_read_byte_data(client, 0x21);
+		hyst = i2c_smbus_read_byte_data(client, EMC1403_HYST_REG);
 		if (hyst < 0)
 			return retval;
 		data->cached_hyst = hyst;
@@ -149,7 +150,7 @@ static ssize_t store_hyst(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
-	struct thermal_data *data = dev_get_drvdata(dev);
+	struct emc1403_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
 	int retval;
 	int hyst;
@@ -163,14 +164,14 @@ static ssize_t store_hyst(struct device *dev,
 	if (retval < 0)
 		goto fail;
 
-	hyst = val - retval * 1000;
+	hyst = retval * 1000 - val;
 	hyst = DIV_ROUND_CLOSEST(hyst, 1000);
 	if (hyst < 0 || hyst > 255) {
 		retval = -ERANGE;
 		goto fail;
 	}
 
-	retval = i2c_smbus_write_byte_data(client, 0x21, hyst);
+	retval = i2c_smbus_write_byte_data(client, EMC1403_HYST_REG, hyst);
 	if (retval == 0) {
 		retval = count;
 		data->cached_hyst = hyst;
@@ -252,6 +253,28 @@ static SENSOR_DEVICE_ATTR(temp4_crit_hyst, S_IRUGO | S_IWUSR,
 static SENSOR_DEVICE_ATTR_2(power_state, S_IRUGO | S_IWUSR,
 	show_bit, store_bit, 0x03, 0x40);
 
+
+static struct attribute *emc1412_attrs[] = {
+	&sensor_dev_attr_temp1_min.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_temp2_min.dev_attr.attr,
+	&sensor_dev_attr_temp2_max.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_power_state.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group emc1412_group = {
+		.attrs = emc1412_attrs,
+};
+
 static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp1_min.dev_attr.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
@@ -261,6 +284,7 @@ static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_temp2_min.dev_attr.attr,
 	&sensor_dev_attr_temp2_max.dev_attr.attr,
 	&sensor_dev_attr_temp2_crit.dev_attr.attr,
@@ -269,6 +293,7 @@ static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_temp3_min.dev_attr.attr,
 	&sensor_dev_attr_temp3_max.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit.dev_attr.attr,
@@ -277,6 +302,7 @@ static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_power_state.dev_attr.attr,
 	NULL
 };
@@ -286,6 +312,33 @@ static const struct attribute_group emc1403_group = {
 };
 
 static struct attribute *emc1404_attrs[] = {
+	&sensor_dev_attr_temp1_min.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_temp2_min.dev_attr.attr,
+	&sensor_dev_attr_temp2_max.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_temp3_min.dev_attr.attr,
+	&sensor_dev_attr_temp3_max.dev_attr.attr,
+	&sensor_dev_attr_temp3_crit.dev_attr.attr,
+	&sensor_dev_attr_temp3_input.dev_attr.attr,
+	&sensor_dev_attr_temp3_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_temp4_min.dev_attr.attr,
 	&sensor_dev_attr_temp4_max.dev_attr.attr,
 	&sensor_dev_attr_temp4_crit.dev_attr.attr,
@@ -294,6 +347,8 @@ static struct attribute *emc1404_attrs[] = {
 	&sensor_dev_attr_temp4_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp4_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp4_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_power_state.dev_attr.attr,
 	NULL
 };
 
@@ -301,18 +356,23 @@ static const struct attribute_group emc1404_group = {
 	.attrs = emc1404_attrs,
 };
 
+
+
 static int emc1403_detect(struct i2c_client *client,
 			struct i2c_board_info *info)
 {
 	int id;
-	/* Check if thermal chip is SMSC and EMC1403 or EMC1423 */
+	/* Check whether the chip is SMSC and get its type */
 
-	id = i2c_smbus_read_byte_data(client, THERMAL_SMSC_ID_REG);
+	id = i2c_smbus_read_byte_data(client, EMC1403_SMSC_ID_REG);
 	if (id != 0x5d)
 		return -ENODEV;
 
-	id = i2c_smbus_read_byte_data(client, THERMAL_PID_REG);
+	id = i2c_smbus_read_byte_data(client, EMC1403_PID_REG);
 	switch (id) {
+	case 0x20:
+		strlcpy(info->type, "emc1412", I2C_NAME_SIZE);
+		break;
 	case 0x21:
 		strlcpy(info->type, "emc1403", I2C_NAME_SIZE);
 		break;
@@ -329,20 +389,20 @@ static int emc1403_detect(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
-	if (id != 0x01)
+	id = i2c_smbus_read_byte_data(client, EMC1403_REVISION_REG);
+	if (id != 0x01 && id != 0x04) {
 		return -ENODEV;
-
+	}
 	return 0;
 }
 
 static int emc1403_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct thermal_data *data;
+	struct emc1403_data *data;
 	struct device *hwmon_dev;
 
-	data = devm_kzalloc(&client->dev, sizeof(struct thermal_data),
+	data = devm_kzalloc(&client->dev, sizeof(struct emc1403_data),
 			    GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
@@ -351,9 +411,17 @@ static int emc1403_probe(struct i2c_client *client,
 	mutex_init(&data->mutex);
 	data->hyst_valid = jiffies - 1;		/* Expired */
 
-	data->groups[0] = &emc1403_group;
-	if (id->driver_data)
-		data->groups[1] = &emc1404_group;
+	switch (id->driver_data) {
+	case 0:
+		data->groups[0] = &emc1412_group;
+		break;
+	case 1:
+		data->groups[0] = &emc1403_group;
+		break;
+	case 2:
+		data->groups[0] = &emc1404_group;
+		break;
+	}
 
 	hwmon_dev = hwmon_device_register_with_groups(&client->dev,
 						      client->name, data,
@@ -361,24 +429,29 @@ static int emc1403_probe(struct i2c_client *client,
 	if (IS_ERR(hwmon_dev))
 		return PTR_ERR(hwmon_dev);
 
-	dev_info(&client->dev, "%s Thermal chip found\n", id->name);
+	dev_info(&client->dev, "%s thermal chip found.\n", id->name);
 	return 0;
 }
 
 static const unsigned short emc1403_address_list[] = {
-	0x18, 0x29, 0x4c, 0x4d, I2C_CLIENT_END
+	/* emc1403/emc1404/emc1423/emc1424 */
+	0x4c, 0x4d, 0x18, 0x29,
+	/* emc1412 */
+	0x5c, 0x4c, 0x6c, 0x1c, 0x3c, I2C_CLIENT_END
 };
 
+/* Last number in name indicates the amount of channels */
 static const struct i2c_device_id emc1403_idtable[] = {
-	{ "emc1403", 0 },
-	{ "emc1404", 1 },
-	{ "emc1423", 0 },
-	{ "emc1424", 1 },
+	{ "emc1412", 0 },
+	{ "emc1403", 1 },
+	{ "emc1423", 1 },
+	{ "emc1404", 2 },
+	{ "emc1424", 2 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, emc1403_idtable);
 
-static struct i2c_driver sensor_emc1403 = {
+static struct i2c_driver emc1403_driver = {
 	.class = I2C_CLASS_HWMON,
 	.driver = {
 		.name = "emc1403",
@@ -389,8 +462,9 @@ static struct i2c_driver sensor_emc1403 = {
 	.address_list = emc1403_address_list,
 };
 
-module_i2c_driver(sensor_emc1403);
+module_i2c_driver(emc1403_driver);
 
 MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
 MODULE_DESCRIPTION("emc1403 Thermal Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("i2c:emc1403");
