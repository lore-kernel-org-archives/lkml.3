Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbaELMeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:34:12 -0400
Received: from we2-f167.wedos.net ([46.28.105.74]:48737 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbaELMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:34:07 -0400
Date: Mon, 12 May 2014 14:34:09 +0200
From: Josef Gajdusek <atx@atx.name>
To: jdelvare@suse.de
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/hwmon/emc1403.c: add support for emc14x2
Message-ID: <20140512123409.GB16252@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for emc1402/emc1412/emc1422 temperature monitoring chips.
This line of sensors does only have 2 channels (internal and external) in comparison to the emc14x3 (3 channels) and emc14x4 (4 channels) lines.

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
Hello,
I modified the patches according to the feedback I received. I also added 1422 and changed the 1412 part to 1402 (They are practically identical and the rest of the driver uses 140x and 142x 
pairs).
---
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index b2b6a52..8b3df53 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -38,9 +38,11 @@
 #define THERMAL_SMSC_ID_REG	0xfe
 #define THERMAL_REVISION_REG	0xff
 
+enum emc1403_chip { emc1402, emc1403, emc1404 };
+
 struct thermal_data {
 	struct i2c_client *client;
-	const struct attribute_group *groups[3];
+	const struct attribute_group *groups[4];
 	struct mutex mutex;
 	/*
 	 * Cache the hyst value so we don't keep re-reading it. In theory
@@ -252,23 +254,36 @@ static SENSOR_DEVICE_ATTR(temp4_crit_hyst, S_IRUGO | S_IWUSR,
 static SENSOR_DEVICE_ATTR_2(power_state, S_IRUGO | S_IWUSR,
 	show_bit, store_bit, 0x03, 0x40);
 
-static struct attribute *emc1403_attrs[] = {
+static struct attribute *emc1402_attrs[] = {
 	&sensor_dev_attr_temp1_min.dev_attr.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
 	&sensor_dev_attr_temp1_crit.dev_attr.attr,
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
-	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_temp2_min.dev_attr.attr,
 	&sensor_dev_attr_temp2_max.dev_attr.attr,
 	&sensor_dev_attr_temp2_crit.dev_attr.attr,
 	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+
+	&sensor_dev_attr_power_state.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group emc1402_group = {
+		.attrs = emc1402_attrs,
+};
+
+static struct attribute *emc1403_attrs[] = {
+	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
+
 	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
+
 	&sensor_dev_attr_temp3_min.dev_attr.attr,
 	&sensor_dev_attr_temp3_max.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit.dev_attr.attr,
@@ -277,7 +292,6 @@ static struct attribute *emc1403_attrs[] = {
 	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
-	&sensor_dev_attr_power_state.dev_attr.attr,
 	NULL
 };
 
@@ -313,9 +327,15 @@ static int emc1403_detect(struct i2c_client *client,
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_PID_REG);
 	switch (id) {
+	case 0x20:
+		strlcpy(info->type, "emc1402", I2C_NAME_SIZE);
+		break;
 	case 0x21:
 		strlcpy(info->type, "emc1403", I2C_NAME_SIZE);
 		break;
+	case 0x22:
+		strlcpy(info->type, "emc1422", I2C_NAME_SIZE);
+		break;
 	case 0x23:
 		strlcpy(info->type, "emc1423", I2C_NAME_SIZE);
 		break;
@@ -351,9 +371,14 @@ static int emc1403_probe(struct i2c_client *client,
 	mutex_init(&data->mutex);
 	data->hyst_valid = jiffies - 1;		/* Expired */
 
-	data->groups[0] = &emc1403_group;
-	if (id->driver_data)
-		data->groups[1] = &emc1404_group;
+	switch (id->driver_data) {
+	case emc1404:
+		data->groups[2] = &emc1404_group;
+	case emc1403:
+		data->groups[1] = &emc1403_group;
+	case emc1402:
+		data->groups[0] = &emc1402_group;
+	}
 
 	hwmon_dev = hwmon_device_register_with_groups(&client->dev,
 						      client->name, data,
@@ -366,14 +391,17 @@ static int emc1403_probe(struct i2c_client *client,
 }
 
 static const unsigned short emc1403_address_list[] = {
-	0x18, 0x29, 0x4c, 0x4d, I2C_CLIENT_END
+	0x18, 0x29, 0x1c, 0x4c, 0x4d, 0x5c, I2C_CLIENT_END
 };
 
+/* Last number in name indicates the amount of channels */
 static const struct i2c_device_id emc1403_idtable[] = {
-	{ "emc1403", 0 },
-	{ "emc1404", 1 },
-	{ "emc1423", 0 },
-	{ "emc1424", 1 },
+	{ "emc1402", emc1402 },
+	{ "emc1403", emc1403 },
+	{ "emc1404", emc1404 },
+	{ "emc1422", emc1402 },
+	{ "emc1423", emc1403 },
+	{ "emc1424", emc1404 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, emc1403_idtable);

