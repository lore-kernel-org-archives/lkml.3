Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaBMIvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:51:02 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:45326 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaBMIu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:50:59 -0500
From: Laszlo Papp <lpapp@kde.org>
To: jdelvare@suse.de, linux@roeck-us.net
Cc: lm-sensors@lm-sensors.org, lee.jones@linaro.org, lpapp@kde.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] hwmon: (max6650) Convert to be a platform driver
Date: Thu, 13 Feb 2014 08:50:38 +0000
Message-Id: <1392281438-31836-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MFD driver has now been added, so this driver is now being adopted to be a
subdevice driver on top of it. This means, the i2c driver usage is being
converted to platform driver usage all around.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
This patch has been compile tested only and will be tested with real hardware,
but early reviews to catch any trivial issues would be welcome.
 drivers/hwmon/Kconfig   |   2 +-
 drivers/hwmon/max6650.c | 155 ++++++++++++++++++++++++------------------------
 2 files changed, 79 insertions(+), 78 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 5ce43d8..48be395 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -926,7 +926,7 @@ config SENSORS_MAX6642
 
 config SENSORS_MAX6650
 	tristate "Maxim MAX6650 sensor chip"
-	depends on I2C
+	depends on MFD_MAX665X
 	help
 	  If you say yes here you get support for the MAX6650 / MAX6651
 	  sensor chips.
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 0cafc39..7dbd60d 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -39,6 +39,9 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/max665x-private.h>
 
 /*
  * Insmod parameters
@@ -105,24 +108,23 @@ module_param(clock, int, S_IRUGO);
 
 #define DIV_FROM_REG(reg) (1 << (reg & 7))
 
-static int max6650_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id);
-static int max6650_init_client(struct i2c_client *client);
-static int max6650_remove(struct i2c_client *client);
+static int max6650_probe(struct platform_device *pdev);
+static int max6650_init_client(struct platform_device *pdev);
+static int max6650_remove(struct platform_device *pdev);
 static struct max6650_data *max6650_update_device(struct device *dev);
 
 /*
  * Driver data (common to all clients)
  */
 
-static const struct i2c_device_id max6650_id[] = {
+static const struct platform_device_id max6650_id[] = {
 	{ "max6650", 1 },
 	{ "max6651", 4 },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, max6650_id);
+MODULE_DEVICE_TABLE(platform, max6650_id);
 
-static struct i2c_driver max6650_driver = {
+static struct platform_driver max6650_driver = {
 	.driver = {
 		.name	= "max6650",
 	},
@@ -137,18 +139,19 @@ static struct i2c_driver max6650_driver = {
 
 struct max6650_data {
 	struct device *hwmon_dev;
+	struct max665x_dev *iodev;
 	struct mutex update_lock;
 	int nr_fans;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
 
 	/* register values */
-	u8 speed;
-	u8 config;
-	u8 tach[4];
-	u8 count;
-	u8 dac;
-	u8 alarm;
+	int speed;
+	int config;
+	int tach[4];
+	int count;
+	int dac;
+	int alarm;
 };
 
 static ssize_t get_fan(struct device *dev, struct device_attribute *devattr,
@@ -235,8 +238,7 @@ static ssize_t get_target(struct device *dev, struct device_attribute *devattr,
 static ssize_t set_target(struct device *dev, struct device_attribute *devattr,
 			 const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6650_data *data = i2c_get_clientdata(client);
+	struct max6650_data *data = dev_get_drvdata(dev);
 	int kscale, ktach;
 	unsigned long rpm;
 	int err;
@@ -264,7 +266,7 @@ static ssize_t set_target(struct device *dev, struct device_attribute *devattr,
 		ktach = 255;
 	data->speed = ktach;
 
-	i2c_smbus_write_byte_data(client, MAX6650_REG_SPEED, data->speed);
+	regmap_write(data->iodev->map, MAX6650_REG_SPEED, data->speed);
 
 	mutex_unlock(&data->update_lock);
 
@@ -304,8 +306,7 @@ static ssize_t get_pwm(struct device *dev, struct device_attribute *devattr,
 static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 			const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6650_data *data = i2c_get_clientdata(client);
+	struct max6650_data *data = dev_get_drvdata(dev);
 	unsigned long pwm;
 	int err;
 
@@ -322,7 +323,7 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 	else
 		data->dac = 76 - (76 * pwm)/255;
 
-	i2c_smbus_write_byte_data(client, MAX6650_REG_DAC, data->dac);
+	regmap_write(data->iodev->map, MAX6650_REG_DAC, data->dac);
 
 	mutex_unlock(&data->update_lock);
 
@@ -350,8 +351,7 @@ static ssize_t get_enable(struct device *dev, struct device_attribute *devattr,
 static ssize_t set_enable(struct device *dev, struct device_attribute *devattr,
 			  const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6650_data *data = i2c_get_clientdata(client);
+	struct max6650_data *data = dev_get_drvdata(dev);
 	int max6650_modes[3] = {0, 3, 2};
 	unsigned long mode;
 	int err;
@@ -365,11 +365,11 @@ static ssize_t set_enable(struct device *dev, struct device_attribute *devattr,
 
 	mutex_lock(&data->update_lock);
 
-	data->config = i2c_smbus_read_byte_data(client, MAX6650_REG_CONFIG);
+	regmap_read(data->iodev->map, MAX6650_REG_CONFIG, &data->config);
 	data->config = (data->config & ~MAX6650_CFG_MODE_MASK)
 		       | (max6650_modes[mode] << 4);
 
-	i2c_smbus_write_byte_data(client, MAX6650_REG_CONFIG, data->config);
+	regmap_write(data->iodev->map, MAX6650_REG_CONFIG, data->config);
 
 	mutex_unlock(&data->update_lock);
 
@@ -400,8 +400,7 @@ static ssize_t get_div(struct device *dev, struct device_attribute *devattr,
 static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
 		       const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6650_data *data = i2c_get_clientdata(client);
+	struct max6650_data *data = dev_get_drvdata(dev);
 	unsigned long div;
 	int err;
 
@@ -428,7 +427,7 @@ static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
 		return -EINVAL;
 	}
 
-	i2c_smbus_write_byte_data(client, MAX6650_REG_COUNT, data->count);
+	regmap_write(data->iodev->map, MAX6650_REG_COUNT, data->count);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -445,16 +444,15 @@ static ssize_t get_alarm(struct device *dev, struct device_attribute *devattr,
 			 char *buf)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct max6650_data *data = max6650_update_device(dev);
-	struct i2c_client *client = to_i2c_client(dev);
+	struct max6650_data *data = dev_get_drvdata(dev);
 	int alarm = 0;
 
 	if (data->alarm & attr->index) {
 		mutex_lock(&data->update_lock);
-		alarm = 1;
 		data->alarm &= ~attr->index;
-		data->alarm |= i2c_smbus_read_byte_data(client,
-							MAX6650_REG_ALARM);
+		regmap_read(data->iodev->map, MAX6650_REG_ALARM, &alarm);
+		data->alarm |= alarm;
+		alarm = 1;
 		mutex_unlock(&data->update_lock);
 	}
 
@@ -484,10 +482,12 @@ static umode_t max6650_attrs_visible(struct kobject *kobj, struct attribute *a,
 				    int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct i2c_client *client = to_i2c_client(dev);
-	u8 alarm_en = i2c_smbus_read_byte_data(client, MAX6650_REG_ALARM_EN);
+	struct max6650_data *data = dev_get_drvdata(dev);
+	int alarm_en;
 	struct device_attribute *devattr;
 
+	regmap_read(data->iodev->map, MAX6650_REG_ALARM_EN, &alarm_en);
+
 	/*
 	 * Hide the alarms that have not been enabled by the firmware
 	 */
@@ -539,74 +539,76 @@ static const struct attribute_group max6651_attr_grp = {
  * Real code
  */
 
-static int max6650_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+static int max6650_probe(struct platform_device *pdev)
 {
+	struct max665x_dev *max665x = dev_get_drvdata(pdev->dev.parent);
 	struct max6650_data *data;
+	const struct platform_device_id *id = platform_get_device_id(pdev);
 	int err;
 
-	data = devm_kzalloc(&client->dev, sizeof(struct max6650_data),
+	data = devm_kzalloc(&pdev->dev, sizeof(struct max6650_data),
 			    GFP_KERNEL);
 	if (!data) {
-		dev_err(&client->dev, "out of memory.\n");
+		dev_err(&pdev->dev, "out of memory.\n");
 		return -ENOMEM;
 	}
 
-	i2c_set_clientdata(client, data);
+	data->iodev = max665x;
+	platform_set_drvdata(pdev, data);
 	mutex_init(&data->update_lock);
 	data->nr_fans = id->driver_data;
 
 	/*
 	 * Initialize the max6650 chip
 	 */
-	err = max6650_init_client(client);
+	err = max6650_init_client(pdev);
 	if (err)
 		return err;
 
-	err = sysfs_create_group(&client->dev.kobj, &max6650_attr_grp);
+	err = sysfs_create_group(&pdev->dev.kobj, &max6650_attr_grp);
 	if (err)
 		return err;
 	/* 3 additional fan inputs for the MAX6651 */
 	if (data->nr_fans == 4) {
-		err = sysfs_create_group(&client->dev.kobj, &max6651_attr_grp);
+		err = sysfs_create_group(&pdev->dev.kobj, &max6651_attr_grp);
 		if (err)
 			goto err_remove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (!IS_ERR(data->hwmon_dev))
 		return 0;
 
 	err = PTR_ERR(data->hwmon_dev);
-	dev_err(&client->dev, "error registering hwmon device.\n");
+	dev_err(&pdev->dev, "error registering hwmon device.\n");
 	if (data->nr_fans == 4)
-		sysfs_remove_group(&client->dev.kobj, &max6651_attr_grp);
+		sysfs_remove_group(&pdev->dev.kobj, &max6651_attr_grp);
 err_remove:
-	sysfs_remove_group(&client->dev.kobj, &max6650_attr_grp);
+	sysfs_remove_group(&pdev->dev.kobj, &max6650_attr_grp);
 	return err;
 }
 
-static int max6650_remove(struct i2c_client *client)
+static int max6650_remove(struct platform_device *pdev)
 {
-	struct max6650_data *data = i2c_get_clientdata(client);
+	struct max6650_data *data = platform_get_drvdata(pdev);
 
 	hwmon_device_unregister(data->hwmon_dev);
 	if (data->nr_fans == 4)
-		sysfs_remove_group(&client->dev.kobj, &max6651_attr_grp);
-	sysfs_remove_group(&client->dev.kobj, &max6650_attr_grp);
+		sysfs_remove_group(&pdev->dev.kobj, &max6651_attr_grp);
+	sysfs_remove_group(&pdev->dev.kobj, &max6650_attr_grp);
 	return 0;
 }
 
-static int max6650_init_client(struct i2c_client *client)
+static int max6650_init_client(struct platform_device *pdev)
 {
-	struct max6650_data *data = i2c_get_clientdata(client);
+	struct max6650_data *data = platform_get_drvdata(pdev);
 	int config;
 	int err = -EIO;
 
-	config = i2c_smbus_read_byte_data(client, MAX6650_REG_CONFIG);
+	regmap_read(data->iodev->map, MAX6650_REG_CONFIG, &config);
 
 	if (config < 0) {
-		dev_err(&client->dev, "Error reading config, aborting.\n");
+		dev_err(&pdev->dev, "Error reading config, aborting.\n");
 		return err;
 	}
 
@@ -620,11 +622,11 @@ static int max6650_init_client(struct i2c_client *client)
 		config |= MAX6650_CFG_V12;
 		break;
 	default:
-		dev_err(&client->dev, "illegal value for fan_voltage (%d)\n",
+		dev_err(&pdev->dev, "illegal value for fan_voltage (%d)\n",
 			fan_voltage);
 	}
 
-	dev_info(&client->dev, "Fan voltage is set to %dV.\n",
+	dev_info(&pdev->dev, "Fan voltage is set to %dV.\n",
 		 (config & MAX6650_CFG_V12) ? 12 : 5);
 
 	switch (prescaler) {
@@ -650,11 +652,11 @@ static int max6650_init_client(struct i2c_client *client)
 			 | MAX6650_CFG_PRESCALER_16;
 		break;
 	default:
-		dev_err(&client->dev, "illegal value for prescaler (%d)\n",
+		dev_err(&pdev->dev, "illegal value for prescaler (%d)\n",
 			prescaler);
 	}
 
-	dev_info(&client->dev, "Prescaler is set to %d.\n",
+	dev_info(&pdev->dev, "Prescaler is set to %d.\n",
 		 1 << (config & MAX6650_CFG_PRESCALER_MASK));
 
 	/*
@@ -664,22 +666,22 @@ static int max6650_init_client(struct i2c_client *client)
 	 */
 
 	if ((config & MAX6650_CFG_MODE_MASK) == MAX6650_CFG_MODE_OFF) {
-		dev_dbg(&client->dev, "Change mode to open loop, full off.\n");
+		dev_dbg(&pdev->dev, "Change mode to open loop, full off.\n");
 		config = (config & ~MAX6650_CFG_MODE_MASK)
 			 | MAX6650_CFG_MODE_OPEN_LOOP;
-		if (i2c_smbus_write_byte_data(client, MAX6650_REG_DAC, 255)) {
-			dev_err(&client->dev, "DAC write error, aborting.\n");
+		if (regmap_write(data->iodev->map, MAX6650_REG_DAC, 255) < 0) {
+			dev_err(&pdev->dev, "DAC write error, aborting.\n");
 			return err;
 		}
 	}
 
-	if (i2c_smbus_write_byte_data(client, MAX6650_REG_CONFIG, config)) {
-		dev_err(&client->dev, "Config write error, aborting.\n");
+	if (regmap_write(data->iodev->map, MAX6650_REG_CONFIG, config) < 0) {
+		dev_err(&pdev->dev, "Config write error, aborting.\n");
 		return err;
 	}
 
 	data->config = config;
-	data->count = i2c_smbus_read_byte_data(client, MAX6650_REG_COUNT);
+	regmap_read(data->iodev->map, MAX6650_REG_COUNT, &data->count);
 
 	return 0;
 }
@@ -694,31 +696,30 @@ static const u8 tach_reg[] = {
 static struct max6650_data *max6650_update_device(struct device *dev)
 {
 	int i;
-	struct i2c_client *client = to_i2c_client(dev);
-	struct max6650_data *data = i2c_get_clientdata(client);
+	struct max6650_data *data = dev_get_drvdata(dev);
+	int alarm;
 
 	mutex_lock(&data->update_lock);
 
 	if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
-		data->speed = i2c_smbus_read_byte_data(client,
-						       MAX6650_REG_SPEED);
-		data->config = i2c_smbus_read_byte_data(client,
-							MAX6650_REG_CONFIG);
+		regmap_read(data->iodev->map, MAX6650_REG_SPEED, &data->speed);
+		regmap_read(data->iodev->map, MAX6650_REG_CONFIG,
+			&data->config);
 		for (i = 0; i < data->nr_fans; i++) {
-			data->tach[i] = i2c_smbus_read_byte_data(client,
-								 tach_reg[i]);
+			regmap_read(data->iodev->map, tach_reg[i],
+				&data->tach[i]);
 		}
-		data->count = i2c_smbus_read_byte_data(client,
-							MAX6650_REG_COUNT);
-		data->dac = i2c_smbus_read_byte_data(client, MAX6650_REG_DAC);
+		regmap_read(data->iodev->map, MAX6650_REG_COUNT,
+			&data->count);
+		regmap_read(data->iodev->map, MAX6650_REG_DAC, &data->dac);
 
 		/*
 		 * Alarms are cleared on read in case the condition that
 		 * caused the alarm is removed. Keep the value latched here
 		 * for providing the register through different alarm files.
 		 */
-		data->alarm |= i2c_smbus_read_byte_data(client,
-							MAX6650_REG_ALARM);
+		regmap_read(data->iodev->map, MAX6650_REG_ALARM, &alarm);
+		data->alarm |= alarm;
 
 		data->last_updated = jiffies;
 		data->valid = 1;
@@ -729,7 +730,7 @@ static struct max6650_data *max6650_update_device(struct device *dev)
 	return data;
 }
 
-module_i2c_driver(max6650_driver);
+module_platform_driver(max6650_driver);
 
 MODULE_AUTHOR("Hans J. Koch");
 MODULE_DESCRIPTION("MAX6650 sensor driver");
-- 
1.8.5.4

