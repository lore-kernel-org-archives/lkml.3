Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3CRBqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:46:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58811 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3CRBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:46:08 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 17 Mar 2013 20:46:04 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 2/8] hwmon: (ina209) Convert to devm_hwmon_device_register API
Date: Sun, 17 Mar 2013 18:45:51 -0700
Message-Id: <1363571157-16273-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
References: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/ina209.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/ina209.c b/drivers/hwmon/ina209.c
index c6fdd5b..547935f 100644
--- a/drivers/hwmon/ina209.c
+++ b/drivers/hwmon/ina209.c
@@ -78,7 +78,7 @@ struct ina209_data {
 
 static struct ina209_data *ina209_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct ina209_data *data = i2c_get_clientdata(client);
 	struct ina209_data *ret = data;
 	s32 val;
@@ -234,7 +234,7 @@ static ssize_t ina209_set_interval(struct device *dev,
 				   struct device_attribute *da,
 				   const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct ina209_data *data = ina209_update_device(dev);
 	long val;
 	u16 regval;
@@ -260,7 +260,7 @@ static ssize_t ina209_set_interval(struct device *dev,
 static ssize_t ina209_show_interval(struct device *dev,
 				    struct device_attribute *da, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct ina209_data *data = i2c_get_clientdata(client);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", data->update_interval);
@@ -285,7 +285,7 @@ static ssize_t ina209_reset_history(struct device *dev,
 				    const char *buf,
 				    size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct ina209_data *data = i2c_get_clientdata(client);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 	u32 mask = attr->index;
@@ -312,7 +312,7 @@ static ssize_t ina209_set_value(struct device *dev,
 				const char *buf,
 				size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct ina209_data *data = ina209_update_device(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 	int reg = attr->index;
@@ -503,6 +503,11 @@ static const struct attribute_group ina209_group = {
 	.attrs = ina209_attributes,
 };
 
+static const struct attribute_group *ina209_groups[] = {
+	&ina209_group,
+	NULL
+};
+
 static void ina209_restore_conf(struct i2c_client *client,
 				struct ina209_data *data)
 {
@@ -581,21 +586,15 @@ static int ina209_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
-	/* Register sysfs hooks */
-	ret = sysfs_create_group(&client->dev.kobj, &ina209_group);
-	if (ret)
-		goto out_restore_conf;
-
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = devm_hwmon_device_register(&client->dev,
+						     ina209_groups, id->name);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
-		goto out_hwmon_device_register;
+		goto out_restore_conf;
 	}
 
 	return 0;
 
-out_hwmon_device_register:
-	sysfs_remove_group(&client->dev.kobj, &ina209_group);
 out_restore_conf:
 	ina209_restore_conf(client, data);
 	return ret;
@@ -605,8 +604,6 @@ static int ina209_remove(struct i2c_client *client)
 {
 	struct ina209_data *data = i2c_get_clientdata(client);
 
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &ina209_group);
 	ina209_restore_conf(client, data);
 
 	return 0;
-- 
1.7.9.7

