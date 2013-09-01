Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab3IACtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 22:49:45 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58274 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3IACtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 22:49:23 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 5/9] hwmon: (pmbus) Convert to use hwmon_device_register_with_groups
Date: Sat, 31 Aug 2013 19:48:58 -0700
Message-Id: <1378003742-18685-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/pmbus/pmbus_core.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 9319fcf..e2c34a5 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -97,6 +97,7 @@ struct pmbus_data {
 	int max_attributes;
 	int num_attributes;
 	struct attribute_group group;
+	const struct attribute_group *groups[2];
 
 	struct pmbus_sensor *sensors;
 
@@ -348,7 +349,7 @@ static struct _pmbus_status {
 
 static struct pmbus_data *pmbus_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct pmbus_data *data = i2c_get_clientdata(client);
 	const struct pmbus_driver_info *info = data->info;
 	struct pmbus_sensor *sensor;
@@ -733,7 +734,7 @@ static ssize_t pmbus_set_sensor(struct device *dev,
 				struct device_attribute *devattr,
 				const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct pmbus_data *data = i2c_get_clientdata(client);
 	struct pmbus_sensor *sensor = to_pmbus_sensor(devattr);
 	ssize_t rv = count;
@@ -1768,22 +1769,16 @@ int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
 		goto out_kfree;
 	}
 
-	/* Register sysfs hooks */
-	ret = sysfs_create_group(&dev->kobj, &data->group);
-	if (ret) {
-		dev_err(dev, "Failed to create sysfs entries\n");
-		goto out_kfree;
-	}
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->groups[0] = &data->group;
+	data->hwmon_dev = hwmon_device_register_with_groups(dev, client->name,
+							    data, data->groups);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		dev_err(dev, "Failed to register hwmon device\n");
-		goto out_hwmon_device_register;
+		goto out_kfree;
 	}
 	return 0;
 
-out_hwmon_device_register:
-	sysfs_remove_group(&dev->kobj, &data->group);
 out_kfree:
 	kfree(data->group.attrs);
 	return ret;
@@ -1794,7 +1789,6 @@ int pmbus_do_remove(struct i2c_client *client)
 {
 	struct pmbus_data *data = i2c_get_clientdata(client);
 	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &data->group);
 	kfree(data->group.attrs);
 	return 0;
 }
-- 
1.7.9.7

