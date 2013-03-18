Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3CRBqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:46:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64373 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3CRBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:46:08 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 17 Mar 2013 20:46:06 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 5/8] hwmon: (max6697) Convert to devm_hwmon_device_register API
Date: Sun, 17 Mar 2013 18:45:54 -0700
Message-Id: <1363571157-16273-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
References: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/max6697.c |  157 ++++++++++++++++++++++++++---------------------
 1 file changed, 86 insertions(+), 71 deletions(-)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index bf4aa37..068425b 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -181,7 +181,7 @@ static const struct max6697_chip_data max6697_chip_data[] = {
 
 static struct max6697_data *max6697_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct max6697_data *data = i2c_get_clientdata(client);
 	struct max6697_data *ret = data;
 	int val;
@@ -303,7 +303,7 @@ static ssize_t set_temp(struct device *dev,
 {
 	int nr = to_sensor_dev_attr_2(devattr)->nr;
 	int index = to_sensor_dev_attr_2(devattr)->index;
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct max6697_data *data = i2c_get_clientdata(client);
 	long temp;
 	int ret;
@@ -466,15 +466,86 @@ static struct attribute *max6697_attributes[8][7] = {
 	}
 };
 
+static umode_t max6697_is_visible(struct kobject *kobj, struct attribute *attr,
+				  int index, int channel)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct max6697_data *data = i2c_get_clientdata(client);
+	const struct max6697_chip_data *chip = data->chip;
+
+	if (channel >= chip->channels)
+		return 0;
+
+	if ((index == 3 || index == 4) && !(chip->have_crit & (1 << channel)))
+		return 0;
+	if (index == 5 && !(chip->have_fault & (1 << channel)))
+		return 0;
+
+	return attr->mode;
+}
+
+static umode_t max6697_visible_0(struct kobject *k, struct attribute *a, int i)
+{
+	return max6697_is_visible(k, a, i, 0);
+}
+
+static umode_t max6697_visible_1(struct kobject *k, struct attribute *a, int i)
+{
+	return max6697_is_visible(k, a, i, 1);
+}
+
+static umode_t max6697_visible_2(struct kobject *k, struct attribute *a, int i)
+{
+	return max6697_is_visible(k, a, i, 2);
+}
+
+static umode_t max6697_visible_3(struct kobject *k, struct attribute *a, int i)
+{
+	return max6697_is_visible(k, a, i, 3);
+}
+
+static umode_t max6697_visible_4(struct kobject *k, struct attribute *a, int i)
+{
+	return max6697_is_visible(k, a, i, 4);
+}
+
+static umode_t max6697_visible_5(struct kobject *k, struct attribute *a, int i)
+{
+	return max6697_is_visible(k, a, i, 5);
+}
+
+static umode_t max6697_visible_6(struct kobject *k, struct attribute *a, int i)
+{
+	return max6697_is_visible(k, a, i, 6);
+}
+
+static umode_t max6697_visible_7(struct kobject *k, struct attribute *a, int i)
+{
+	return max6697_is_visible(k, a, i, 7);
+}
+
 static const struct attribute_group max6697_group[8] = {
-	{ .attrs = max6697_attributes[0] },
-	{ .attrs = max6697_attributes[1] },
-	{ .attrs = max6697_attributes[2] },
-	{ .attrs = max6697_attributes[3] },
-	{ .attrs = max6697_attributes[4] },
-	{ .attrs = max6697_attributes[5] },
-	{ .attrs = max6697_attributes[6] },
-	{ .attrs = max6697_attributes[7] },
+	{ .attrs = max6697_attributes[0], .is_visible = max6697_visible_0 },
+	{ .attrs = max6697_attributes[1], .is_visible = max6697_visible_1 },
+	{ .attrs = max6697_attributes[2], .is_visible = max6697_visible_2 },
+	{ .attrs = max6697_attributes[3], .is_visible = max6697_visible_3 },
+	{ .attrs = max6697_attributes[4], .is_visible = max6697_visible_4 },
+	{ .attrs = max6697_attributes[5], .is_visible = max6697_visible_5 },
+	{ .attrs = max6697_attributes[6], .is_visible = max6697_visible_6 },
+	{ .attrs = max6697_attributes[7], .is_visible = max6697_visible_7 },
+};
+
+static const struct attribute_group *max6697_groups[] = {
+	&max6697_group[0],
+	&max6697_group[1],
+	&max6697_group[2],
+	&max6697_group[3],
+	&max6697_group[4],
+	&max6697_group[5],
+	&max6697_group[6],
+	&max6697_group[7],
+	NULL
 };
 
 static void max6697_get_config_of(struct device_node *node,
@@ -606,21 +677,13 @@ done:
 	return 0;
 }
 
-static void max6697_remove_files(struct i2c_client *client)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(max6697_group); i++)
-		sysfs_remove_group(&client->dev.kobj, &max6697_group[i]);
-}
-
 static int max6697_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct device *dev = &client->dev;
 	struct max6697_data *data;
-	int i, err;
+	int err;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
@@ -639,57 +702,10 @@ static int max6697_probe(struct i2c_client *client,
 	if (err)
 		return err;
 
-	for (i = 0; i < data->chip->channels; i++) {
-		err = sysfs_create_file(&dev->kobj,
-					max6697_attributes[i][0]);
-		if (err)
-			goto error;
-		err = sysfs_create_file(&dev->kobj,
-					max6697_attributes[i][1]);
-		if (err)
-			goto error;
-		err = sysfs_create_file(&dev->kobj,
-					max6697_attributes[i][2]);
-		if (err)
-			goto error;
-
-		if (data->chip->have_crit & (1 << i)) {
-			err = sysfs_create_file(&dev->kobj,
-						max6697_attributes[i][3]);
-			if (err)
-				goto error;
-			err = sysfs_create_file(&dev->kobj,
-						max6697_attributes[i][4]);
-			if (err)
-				goto error;
-		}
-		if (data->chip->have_fault & (1 << i)) {
-			err = sysfs_create_file(&dev->kobj,
-						max6697_attributes[i][5]);
-			if (err)
-				goto error;
-		}
-	}
-
-	data->hwmon_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto error;
-	}
-
-	return 0;
-
-error:
-	max6697_remove_files(client);
-	return err;
-}
-
-static int max6697_remove(struct i2c_client *client)
-{
-	struct max6697_data *data = i2c_get_clientdata(client);
-
-	hwmon_device_unregister(data->hwmon_dev);
-	max6697_remove_files(client);
+	data->hwmon_dev = devm_hwmon_device_register(dev, max6697_groups,
+						     id->name);
+	if (IS_ERR(data->hwmon_dev))
+		return PTR_ERR(data->hwmon_dev);
 
 	return 0;
 }
@@ -715,7 +731,6 @@ static struct i2c_driver max6697_driver = {
 		.name	= "max6697",
 	},
 	.probe = max6697_probe,
-	.remove	= max6697_remove,
 	.id_table = max6697_id,
 };
 
-- 
1.7.9.7

