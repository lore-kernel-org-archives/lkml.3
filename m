Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab3IACtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 22:49:41 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38842 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3IACtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 22:49:16 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 2/9] hwmon: (ds1621) Convert to use hwmon_device_register_with_groups
Date: Sat, 31 Aug 2013 19:48:55 -0700
Message-Id: <1378003742-18685-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/ds1621.c |   60 ++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/hwmon/ds1621.c b/drivers/hwmon/ds1621.c
index a26ba7a..595f4ef 100644
--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -120,7 +120,7 @@ static const u8 DS1621_REG_TEMP[3] = {
 
 /* Each client has this additional data */
 struct ds1621_data {
-	struct device *hwmon_dev;
+	struct i2c_client *client;
 	struct mutex update_lock;
 	char valid;			/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -151,10 +151,10 @@ static inline u16 DS1621_TEMP_TO_REG(long temp, u8 zbits)
 	return temp;
 }
 
-static void ds1621_init_client(struct i2c_client *client)
+static void ds1621_init_client(struct ds1621_data *data,
+			       struct i2c_client *client)
 {
 	u8 conf, new_conf, sreg, resol;
-	struct ds1621_data *data = i2c_get_clientdata(client);
 
 	new_conf = conf = i2c_smbus_read_byte_data(client, DS1621_REG_CONF);
 	/* switch to continuous conversion mode */
@@ -197,8 +197,8 @@ static void ds1621_init_client(struct i2c_client *client)
 
 static struct ds1621_data *ds1621_update_client(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ds1621_data *data = i2c_get_clientdata(client);
+	struct ds1621_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	u8 new_conf;
 
 	mutex_lock(&data->update_lock);
@@ -247,8 +247,7 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 			const char *buf, size_t count)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ds1621_data *data = i2c_get_clientdata(client);
+	struct ds1621_data *data = dev_get_drvdata(dev);
 	long val;
 	int err;
 
@@ -258,7 +257,7 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *da,
 
 	mutex_lock(&data->update_lock);
 	data->temp[attr->index] = DS1621_TEMP_TO_REG(val, data->zbits);
-	i2c_smbus_write_word_swapped(client, DS1621_REG_TEMP[attr->index],
+	i2c_smbus_write_word_swapped(data->client, DS1621_REG_TEMP[attr->index],
 				     data->temp[attr->index]);
 	mutex_unlock(&data->update_lock);
 	return count;
@@ -282,16 +281,15 @@ static ssize_t show_alarm(struct device *dev, struct device_attribute *da,
 static ssize_t show_convrate(struct device *dev, struct device_attribute *da,
 			  char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ds1621_data *data = i2c_get_clientdata(client);
+	struct ds1621_data *data = dev_get_drvdata(dev);
 	return scnprintf(buf, PAGE_SIZE, "%hu\n", data->update_interval);
 }
 
 static ssize_t set_convrate(struct device *dev, struct device_attribute *da,
 			    const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ds1621_data *data = i2c_get_clientdata(client);
+	struct ds1621_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
 	unsigned long convrate;
 	s32 err;
 	int resol = 0;
@@ -343,8 +341,7 @@ static umode_t ds1621_attribute_visible(struct kobject *kobj,
 					struct attribute *attr, int index)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ds1621_data *data = i2c_get_clientdata(client);
+	struct ds1621_data *data = dev_get_drvdata(dev);
 
 	if (attr == &dev_attr_update_interval.attr)
 		if (data->kind == ds1621 || data->kind == ds1625)
@@ -358,49 +355,46 @@ static const struct attribute_group ds1621_group = {
 	.is_visible = ds1621_attribute_visible
 };
 
+static const struct attribute_group *ds1621_groups[] = {
+	&ds1621_group,
+	NULL
+};
+
 static int ds1621_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct ds1621_data *data;
-	int err;
+	struct device *hwmon_dev;
 
 	data = devm_kzalloc(&client->dev, sizeof(struct ds1621_data),
 			    GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
 
 	data->kind = id->driver_data;
+	data->client = client;
 
 	/* Initialize the DS1621 chip */
-	ds1621_init_client(client);
+	ds1621_init_client(data, client);
 
-	/* Register sysfs hooks */
-	err = sysfs_create_group(&client->dev.kobj, &ds1621_group);
-	if (err)
-		return err;
+	hwmon_dev = hwmon_device_register_with_groups(&client->dev,
+						      client->name, data,
+						      ds1621_groups);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto exit_remove_files;
-	}
+	i2c_set_clientdata(client, hwmon_dev);
 
 	return 0;
-
- exit_remove_files:
-	sysfs_remove_group(&client->dev.kobj, &ds1621_group);
-	return err;
 }
 
 static int ds1621_remove(struct i2c_client *client)
 {
-	struct ds1621_data *data = i2c_get_clientdata(client);
+	struct device *hwmon_dev = i2c_get_clientdata(client);
 
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &ds1621_group);
+	hwmon_device_unregister(hwmon_dev);
 
 	return 0;
 }
-- 
1.7.9.7

