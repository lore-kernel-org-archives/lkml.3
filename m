Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaBNJRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:17:34 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33783 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaBNJQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:16:21 -0500
From: Laszlo Papp <lpapp@kde.org>
To: jdelvare@suse.de, linux@roeck-us.net
Cc: lm-sensors@lm-sensors.org, lee.jones@linaro.org, lpapp@kde.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwmon: (max6650) Convert to be a platform driver
Date: Fri, 14 Feb 2014 09:15:42 +0000
Message-Id: <1392369342-11472-3-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392369342-11472-1-git-send-email-lpapp@kde.org>
References: <1392369342-11472-1-git-send-email-lpapp@kde.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MFD driver has now been added, so this driver is now being adopted to be a
subdevice driver on top of it. This means, the i2c driver usage is being
converted to platform driver usage all around.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/hwmon/Kconfig   |   2 +-
 drivers/hwmon/max6650.c | 125 ++++++++++++++++++++++++------------------------
 2 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 7ed3aa6..fcfe484 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -962,7 +962,7 @@ config SENSORS_MAX6642
 
 config SENSORS_MAX6650
 	tristate "Maxim MAX6650 sensor chip"
-	depends on I2C
+	depends on MFD_MAX665X
 	help
 	  If you say yes here you get support for the MAX6650 / MAX6651
 	  sensor chips.
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 162a520..4d79413 100644
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
@@ -112,18 +115,19 @@ module_param(clock, int, S_IRUGO);
 struct max6650_data {
 	struct i2c_client *client;
 	const struct attribute_group *groups[3];
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
 
 static const u8 tach_reg[] = {
@@ -136,31 +140,29 @@ static const u8 tach_reg[] = {
 static struct max6650_data *max6650_update_device(struct device *dev)
 {
 	struct max6650_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
+	struct regmap *map = data->iodev->map;
 	int i;
+	int alarm;
 
 	mutex_lock(&data->update_lock);
 
 	if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
-		data->speed = i2c_smbus_read_byte_data(client,
-						       MAX6650_REG_SPEED);
-		data->config = i2c_smbus_read_byte_data(client,
-							MAX6650_REG_CONFIG);
+		regmap_read(map, MAX6650_REG_SPEED, &data->speed);
+		regmap_read(map, MAX6650_REG_CONFIG, &data->config);
 		for (i = 0; i < data->nr_fans; i++) {
-			data->tach[i] = i2c_smbus_read_byte_data(client,
-								 tach_reg[i]);
+			data->tach[i] = regmap_read(map, tach_reg[i],
+							&data->tach[i]);
 		}
-		data->count = i2c_smbus_read_byte_data(client,
-							MAX6650_REG_COUNT);
-		data->dac = i2c_smbus_read_byte_data(client, MAX6650_REG_DAC);
+		regmap_read(map, MAX6650_REG_COUNT, &data->count);
+		regmap_read(map, MAX6650_REG_DAC, &data->dac);
 
 		/*
 		 * Alarms are cleared on read in case the condition that
 		 * caused the alarm is removed. Keep the value latched here
 		 * for providing the register through different alarm files.
 		 */
-		data->alarm |= i2c_smbus_read_byte_data(client,
-							MAX6650_REG_ALARM);
+		regmap_read(map, MAX6650_REG_ALARM, &alarm);
+		data->alarm |= alarm;
 
 		data->last_updated = jiffies;
 		data->valid = 1;
@@ -256,7 +258,6 @@ static ssize_t set_target(struct device *dev, struct device_attribute *devattr,
 			 const char *buf, size_t count)
 {
 	struct max6650_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
 	int kscale, ktach;
 	unsigned long rpm;
 	int err;
@@ -284,7 +285,7 @@ static ssize_t set_target(struct device *dev, struct device_attribute *devattr,
 		ktach = 255;
 	data->speed = ktach;
 
-	i2c_smbus_write_byte_data(client, MAX6650_REG_SPEED, data->speed);
+	regmap_write(data->iodev->map, MAX6650_REG_SPEED, data->speed);
 
 	mutex_unlock(&data->update_lock);
 
@@ -325,7 +326,6 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 			const char *buf, size_t count)
 {
 	struct max6650_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
 	unsigned long pwm;
 	int err;
 
@@ -342,7 +342,7 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 	else
 		data->dac = 76 - (76 * pwm)/255;
 
-	i2c_smbus_write_byte_data(client, MAX6650_REG_DAC, data->dac);
+	regmap_write(data->iodev->map, MAX6650_REG_DAC, data->dac);
 
 	mutex_unlock(&data->update_lock);
 
@@ -371,7 +371,7 @@ static ssize_t set_enable(struct device *dev, struct device_attribute *devattr,
 			  const char *buf, size_t count)
 {
 	struct max6650_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
+	struct regmap *map = data->iodev->map;
 	int max6650_modes[3] = {0, 3, 2};
 	unsigned long mode;
 	int err;
@@ -385,11 +385,11 @@ static ssize_t set_enable(struct device *dev, struct device_attribute *devattr,
 
 	mutex_lock(&data->update_lock);
 
-	data->config = i2c_smbus_read_byte_data(client, MAX6650_REG_CONFIG);
+	regmap_read(map, MAX6650_REG_CONFIG, &data->config);
 	data->config = (data->config & ~MAX6650_CFG_MODE_MASK)
 		       | (max6650_modes[mode] << 4);
 
-	i2c_smbus_write_byte_data(client, MAX6650_REG_CONFIG, data->config);
+	regmap_write(map, MAX6650_REG_CONFIG, data->config);
 
 	mutex_unlock(&data->update_lock);
 
@@ -421,7 +421,6 @@ static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
 		       const char *buf, size_t count)
 {
 	struct max6650_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
 	unsigned long div;
 	int err;
 
@@ -448,7 +447,7 @@ static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
 		return -EINVAL;
 	}
 
-	i2c_smbus_write_byte_data(client, MAX6650_REG_COUNT, data->count);
+	regmap_write(data->iodev->map, MAX6650_REG_COUNT, data->count);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -465,16 +464,15 @@ static ssize_t get_alarm(struct device *dev, struct device_attribute *devattr,
 			 char *buf)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct max6650_data *data = max6650_update_device(dev);
-	struct i2c_client *client = data->client;
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
 
@@ -505,10 +503,11 @@ static umode_t max6650_attrs_visible(struct kobject *kobj, struct attribute *a,
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct max6650_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
-	u8 alarm_en = i2c_smbus_read_byte_data(client, MAX6650_REG_ALARM_EN);
+	int alarm_en;
 	struct device_attribute *devattr;
 
+	regmap_read(data->iodev->map, MAX6650_REG_ALARM_EN, &alarm_en);
+
 	/*
 	 * Hide the alarms that have not been enabled by the firmware
 	 */
@@ -560,17 +559,17 @@ static const struct attribute_group max6651_group = {
  * Real code
  */
 
-static int max6650_init_client(struct max6650_data *data,
-			       struct i2c_client *client)
+static int max6650_init_client(struct platform_device *pdev)
 {
-	struct device *dev = &client->dev;
+	struct max6650_data *data = platform_get_drvdata(pdev);
+	struct regmap *map = data->iodev->map;
 	int config;
 	int err = -EIO;
 
-	config = i2c_smbus_read_byte_data(client, MAX6650_REG_CONFIG);
+	regmap_read(map, MAX6650_REG_CONFIG, &config);
 
 	if (config < 0) {
-		dev_err(dev, "Error reading config, aborting.\n");
+		dev_err(&pdev->dev, "Error reading config, aborting.\n");
 		return err;
 	}
 
@@ -584,11 +583,11 @@ static int max6650_init_client(struct max6650_data *data,
 		config |= MAX6650_CFG_V12;
 		break;
 	default:
-		dev_err(dev, "illegal value for fan_voltage (%d)\n",
+		dev_err(&pdev->dev, "illegal value for fan_voltage (%d)\n",
 			fan_voltage);
 	}
 
-	dev_info(dev, "Fan voltage is set to %dV.\n",
+	dev_info(&pdev->dev, "Fan voltage is set to %dV.\n",
 		 (config & MAX6650_CFG_V12) ? 12 : 5);
 
 	switch (prescaler) {
@@ -614,10 +613,11 @@ static int max6650_init_client(struct max6650_data *data,
 			 | MAX6650_CFG_PRESCALER_16;
 		break;
 	default:
-		dev_err(dev, "illegal value for prescaler (%d)\n", prescaler);
+		dev_err(&pdev->dev, "illegal value for prescaler (%d)\n",
+			prescaler);
 	}
 
-	dev_info(dev, "Prescaler is set to %d.\n",
+	dev_info(&pdev->dev, "Prescaler is set to %d.\n",
 		 1 << (config & MAX6650_CFG_PRESCALER_MASK));
 
 	/*
@@ -627,46 +627,45 @@ static int max6650_init_client(struct max6650_data *data,
 	 */
 
 	if ((config & MAX6650_CFG_MODE_MASK) == MAX6650_CFG_MODE_OFF) {
-		dev_dbg(dev, "Change mode to open loop, full off.\n");
+		dev_dbg(&pdev->dev, "Change mode to open loop, full off.\n");
 		config = (config & ~MAX6650_CFG_MODE_MASK)
 			 | MAX6650_CFG_MODE_OPEN_LOOP;
-		if (i2c_smbus_write_byte_data(client, MAX6650_REG_DAC, 255)) {
-			dev_err(dev, "DAC write error, aborting.\n");
+		if (regmap_write(data->iodev->map, MAX6650_REG_DAC, 255) < 0) {
+			dev_err(&pdev->dev, "DAC write error, aborting.\n");
 			return err;
 		}
 	}
 
-	if (i2c_smbus_write_byte_data(client, MAX6650_REG_CONFIG, config)) {
-		dev_err(dev, "Config write error, aborting.\n");
+	if (regmap_write(map, MAX6650_REG_CONFIG, config) < 0) {
+		dev_err(&pdev->dev, "Config write error, aborting.\n");
 		return err;
 	}
 
 	data->config = config;
-	data->count = i2c_smbus_read_byte_data(client, MAX6650_REG_COUNT);
+	regmap_read(map, MAX6650_REG_COUNT, &data->count);
 
 	return 0;
 }
 
-static int max6650_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+static int max6650_probe(struct platform_device *pdev)
 {
-	struct device *dev = &client->dev;
-	struct max6650_data *data;
+	struct max6650_data *data = platform_get_drvdata(pdev);
+	const struct platform_device_id *id = platform_get_device_id(pdev);
 	struct device *hwmon_dev;
 	int err;
 
-	data = devm_kzalloc(dev, sizeof(struct max6650_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct max6650_data),
+							GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->client = client;
 	mutex_init(&data->update_lock);
 	data->nr_fans = id->driver_data;
 
 	/*
 	 * Initialize the max6650 chip
 	 */
-	err = max6650_init_client(data, client);
+	err = max6650_init_client(pdev);
 	if (err)
 		return err;
 
@@ -675,20 +674,20 @@ static int max6650_probe(struct i2c_client *client,
 	if (data->nr_fans == 4)
 		data->groups[1] = &max6651_group;
 
-	hwmon_dev = devm_hwmon_device_register_with_groups(dev,
-							   client->name, data,
-							   data->groups);
+	hwmon_dev = devm_hwmon_device_register_with_groups(&pdev->dev,
+							   data->client->name,
+							   data, data->groups);
 	return PTR_ERR_OR_ZERO(hwmon_dev);
 }
 
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
@@ -696,7 +695,7 @@ static struct i2c_driver max6650_driver = {
 	.id_table	= max6650_id,
 };
 
-module_i2c_driver(max6650_driver);
+module_platform_driver(max6650_driver);
 
 MODULE_AUTHOR("Hans J. Koch");
 MODULE_DESCRIPTION("MAX6650 sensor driver");
-- 
1.8.5.4

