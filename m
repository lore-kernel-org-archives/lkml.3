Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3CRBqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:46:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58695 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3CRBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:46:08 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 17 Mar 2013 20:46:05 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 3/8] hwmon: (ltc4215) Convert to devm_hwmon_device_register API
Date: Sun, 17 Mar 2013 18:45:52 -0700
Message-Id: <1363571157-16273-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
References: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/ltc4215.c |   32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/hwmon/ltc4215.c b/drivers/hwmon/ltc4215.c
index e887610..83bc0ba 100644
--- a/drivers/hwmon/ltc4215.c
+++ b/drivers/hwmon/ltc4215.c
@@ -45,7 +45,7 @@ struct ltc4215_data {
 
 static struct ltc4215_data *ltc4215_update_device(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct ltc4215_data *data = i2c_get_clientdata(client);
 	s32 val;
 	int i;
@@ -244,12 +244,16 @@ static const struct attribute_group ltc4215_group = {
 	.attrs = ltc4215_attributes,
 };
 
+static const struct attribute_group *ltc4215_groups[] = {
+	&ltc4215_group,
+	NULL
+};
+
 static int ltc4215_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct ltc4215_data *data;
-	int ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
@@ -264,31 +268,17 @@ static int ltc4215_probe(struct i2c_client *client,
 	/* Initialize the LTC4215 chip */
 	i2c_smbus_write_byte_data(client, LTC4215_FAULT, 0x00);
 
-	/* Register sysfs hooks */
-	ret = sysfs_create_group(&client->dev.kobj, &ltc4215_group);
-	if (ret)
-		return ret;
-
-	data->hwmon_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		ret = PTR_ERR(data->hwmon_dev);
-		goto out_hwmon_device_register;
-	}
+	data->hwmon_dev = devm_hwmon_device_register(&client->dev,
+						     ltc4215_groups,
+						     id->name);
+	if (IS_ERR(data->hwmon_dev))
+		return PTR_ERR(data->hwmon_dev);
 
 	return 0;
-
-out_hwmon_device_register:
-	sysfs_remove_group(&client->dev.kobj, &ltc4215_group);
-	return ret;
 }
 
 static int ltc4215_remove(struct i2c_client *client)
 {
-	struct ltc4215_data *data = i2c_get_clientdata(client);
-
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &ltc4215_group);
-
 	return 0;
 }
 
-- 
1.7.9.7

