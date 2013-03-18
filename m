Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab3CRBrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:47:49 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58421 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3CRBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:46:08 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 17 Mar 2013 20:46:07 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 6/8] hwmon: (lm90) Convert to devm_hwmon_device_register API
Date: Sun, 17 Mar 2013 18:45:55 -0700
Message-Id: <1363571157-16273-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
References: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/lm90.c |  106 ++++++++++++++++++++++----------------------------
 1 file changed, 46 insertions(+), 60 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 8eeb141..a35fa47 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -306,6 +306,7 @@ struct lm90_data {
 	unsigned long last_updated; /* in jiffies */
 	int kind;
 	u32 flags;
+	const struct attribute_group *groups[7];
 
 	int update_interval;	/* in milliseconds */
 
@@ -464,7 +465,7 @@ static void lm90_set_convrate(struct i2c_client *client, struct lm90_data *data,
 
 static struct lm90_data *lm90_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct lm90_data *data = i2c_get_clientdata(client);
 	unsigned long next_update;
 
@@ -738,7 +739,7 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
 	};
 
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct lm90_data *data = i2c_get_clientdata(client);
 	int nr = attr->index;
 	long val;
@@ -805,7 +806,7 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
 	};
 
 	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct lm90_data *data = i2c_get_clientdata(client);
 	int nr = attr->nr;
 	int index = attr->index;
@@ -867,7 +868,7 @@ static ssize_t show_temphyst(struct device *dev,
 static ssize_t set_temphyst(struct device *dev, struct device_attribute *dummy,
 			    const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct lm90_data *data = i2c_get_clientdata(client);
 	long val;
 	int err;
@@ -921,7 +922,7 @@ static ssize_t set_update_interval(struct device *dev,
 				   struct device_attribute *attr,
 				   const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct lm90_data *data = i2c_get_clientdata(client);
 	unsigned long val;
 	int err;
@@ -971,6 +972,15 @@ static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
 static DEVICE_ATTR(update_interval, S_IRUGO | S_IWUSR, show_update_interval,
 		   set_update_interval);
 
+static struct attribute *temp2_attributes[] = {
+	&sensor_dev_attr_temp2_offset.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group temp2_group = {
+	.attrs = temp2_attributes,
+};
+
 static struct attribute *lm90_attributes[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	&sensor_dev_attr_temp2_input.dev_attr.attr,
@@ -1083,14 +1093,14 @@ static const struct attribute_group lm90_temp3_group = {
 static ssize_t show_pec(struct device *dev, struct device_attribute *dummy,
 			char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	return sprintf(buf, "%d\n", !!(client->flags & I2C_CLIENT_PEC));
 }
 
 static ssize_t set_pec(struct device *dev, struct device_attribute *dummy,
 		       const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	long val;
 	int err;
 
@@ -1114,6 +1124,15 @@ static ssize_t set_pec(struct device *dev, struct device_attribute *dummy,
 
 static DEVICE_ATTR(pec, S_IWUSR | S_IRUGO, show_pec, set_pec);
 
+static struct attribute *pec_attributes[] = {
+	&dev_attr_pec.attr,
+	NULL
+};
+
+static const struct attribute_group pec_group = {
+	.attrs = pec_attributes,
+};
+
 /*
  * Real code
  */
@@ -1320,22 +1339,6 @@ static int lm90_detect(struct i2c_client *client,
 	return 0;
 }
 
-static void lm90_remove_files(struct i2c_client *client, struct lm90_data *data)
-{
-	struct device *dev = &client->dev;
-
-	if (data->flags & LM90_HAVE_TEMP3)
-		sysfs_remove_group(&dev->kobj, &lm90_temp3_group);
-	if (data->flags & LM90_HAVE_EMERGENCY_ALARM)
-		sysfs_remove_group(&dev->kobj, &lm90_emergency_alarm_group);
-	if (data->flags & LM90_HAVE_EMERGENCY)
-		sysfs_remove_group(&dev->kobj, &lm90_emergency_group);
-	if (data->flags & LM90_HAVE_OFFSET)
-		device_remove_file(dev, &sensor_dev_attr_temp2_offset.dev_attr);
-	device_remove_file(dev, &dev_attr_pec);
-	sysfs_remove_group(&dev->kobj, &lm90_group);
-}
-
 static void lm90_restore_conf(struct i2c_client *client, struct lm90_data *data)
 {
 	/* Restore initial configuration */
@@ -1397,7 +1400,7 @@ static int lm90_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct i2c_adapter *adapter = to_i2c_adapter(dev->parent);
 	struct lm90_data *data;
-	int err;
+	int err, group = 0;
 
 	data = devm_kzalloc(&client->dev, sizeof(struct lm90_data), GFP_KERNEL);
 	if (!data)
@@ -1430,47 +1433,32 @@ static int lm90_probe(struct i2c_client *client,
 	lm90_init_client(client);
 
 	/* Register sysfs hooks */
-	err = sysfs_create_group(&dev->kobj, &lm90_group);
-	if (err)
-		goto exit_restore;
-	if (client->flags & I2C_CLIENT_PEC) {
-		err = device_create_file(dev, &dev_attr_pec);
-		if (err)
-			goto exit_remove_files;
-	}
-	if (data->flags & LM90_HAVE_OFFSET) {
-		err = device_create_file(dev,
-					&sensor_dev_attr_temp2_offset.dev_attr);
-		if (err)
-			goto exit_remove_files;
-	}
-	if (data->flags & LM90_HAVE_EMERGENCY) {
-		err = sysfs_create_group(&dev->kobj, &lm90_emergency_group);
-		if (err)
-			goto exit_remove_files;
-	}
-	if (data->flags & LM90_HAVE_EMERGENCY_ALARM) {
-		err = sysfs_create_group(&dev->kobj,
-					 &lm90_emergency_alarm_group);
-		if (err)
-			goto exit_remove_files;
-	}
-	if (data->flags & LM90_HAVE_TEMP3) {
-		err = sysfs_create_group(&dev->kobj, &lm90_temp3_group);
-		if (err)
-			goto exit_remove_files;
-	}
+	data->groups[group++] = &lm90_group;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	if (client->flags & I2C_CLIENT_PEC)
+		data->groups[group++] = &pec_group;
+
+	if (data->flags & LM90_HAVE_OFFSET)
+		data->groups[group++] = &temp2_group;
+
+	if (data->flags & LM90_HAVE_EMERGENCY)
+		data->groups[group++] = &lm90_emergency_group;
+
+	if (data->flags & LM90_HAVE_EMERGENCY_ALARM)
+		data->groups[group++] = &lm90_emergency_alarm_group;
+
+	if (data->flags & LM90_HAVE_TEMP3)
+		data->groups[group++] = &lm90_temp3_group;
+
+	data->hwmon_dev = devm_hwmon_device_register(dev, data->groups,
+						     id->name);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
-		goto exit_remove_files;
+		goto exit_restore;
 	}
 
 	return 0;
 
-exit_remove_files:
-	lm90_remove_files(client, data);
 exit_restore:
 	lm90_restore_conf(client, data);
 	return err;
@@ -1480,8 +1468,6 @@ static int lm90_remove(struct i2c_client *client)
 {
 	struct lm90_data *data = i2c_get_clientdata(client);
 
-	hwmon_device_unregister(data->hwmon_dev);
-	lm90_remove_files(client, data);
 	lm90_restore_conf(client, data);
 
 	return 0;
-- 
1.7.9.7

