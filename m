Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaFBWL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:11:57 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44588 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaFBWL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:11:56 -0400
Message-ID: <1401747220.28117.15.camel@ltli10.sensirion.lokal>
Subject: [PATCH v3] hwmon: add support for Sensirion SHTC1 sensor
From: Tomas Pop <tomas.pop.mff@gmail.com>
To: "linux@roeck-us.net" <linux@roeck-us.net>
Cc: jdelvare@suse.de, linux-kernel@vger.kernel.org,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "johannes.winkelmann@sensirion.com" 
	<johannes.winkelmann@sensirion.com>
Date: Mon, 02 Jun 2014 15:13:40 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

here is a third version of the driver for Sensirion SHTC1 humidity and
temperature sensor. We included suggested corrections, the most important
changes to the previous version are:

* default mode of I2C communication is changed to non-blocking
* default values of configuration added to documentation
* driver uses new ABI to obtain shtc1_data* and i2c_client*

The patch was generated against kernel v3.14.4 (the version used for testing),
but the patch can be applied smoothly also to v3.15-rc8.

Signed-off-by: Tomas Pop <tomas.pop@sensirion.com>

---
 Documentation/hwmon/shtc1           |  44 +++++++
 drivers/hwmon/Kconfig               |  10 ++
 drivers/hwmon/shtc1.c               | 252 ++++++++++++++++++++++++++++++++++++
 include/linux/platform_data/shtc1.h |  23 ++++
 4 files changed, 329 insertions(+)
 create mode 100644 Documentation/hwmon/shtc1
 create mode 100644 drivers/hwmon/shtc1.c
 create mode 100644 include/linux/platform_data/shtc1.h

diff --git a/Documentation/hwmon/shtc1 b/Documentation/hwmon/shtc1
new file mode 100644
index 0000000..6bf00a4
--- /dev/null
+++ b/Documentation/hwmon/shtc1
@@ -0,0 +1,44 @@
+Kernel driver shtc1
+===================
+
+Supported chips:
+  * Sensirion SHTC1
+    Prefix: 'shtc1'
+    Addresses scanned: none
+    Datasheet: Publicly available at the Sensirion website
+    http://www.sensirion.com/file/datasheet_shtc1
+
+  * Sensirion SHTW1
+    Prefix: 'shtc1'
+    Addresses scanned: none
+    Datasheet: Not publicly available
+
+Author:
+  Johannes Winkelmann <johannes.winkelmann@sensirion.com>
+
+Description
+-----------
+
+This driver implements support for the Sensirion SHTC1 chip, a humidity and
+temperature sensor. Temperature is measured in degrees celsius, relative
+humidity is expressed as a percentage. Driver can be used as well for SHTW1
+chip, which has the same electrical interface.
+
+The device communicates with the I2C protocol. All sensors are set to I2C
+address 0x70. See Documentation/i2c/instantiating-devices for methods to
+instantiate the device.
+
+There are two options configurable by means of shtc1_platform_data:
+1. blocking (pull the I2C clock line down while performing the measurement) or
+   non-blocking mode. Blocking mode will guarantee the fastest result but
+   the I2C bus will be busy during that time. By default, non-blocking mode
+   is used. Make sure clock-stretching works properly on your device if you
+   want to use blocking mode.
+2. high or low accuracy. High accuracy is used by default and using it is
+   strongly recommended.
+
+sysfs-Interface
+---------------
+
+temp1_input - temperature input
+humidity1_input - humidity input
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 193c496..bf06213 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1047,6 +1047,16 @@ config SENSORS_SHT21
 	  This driver can also be built as a module.  If so, the module
 	  will be called sht21.
 
+config SENSORS_SHTC1
+	tristate "Sensiron humidity and temperature sensors. SHTC1 and compat."
+	depends on I2C
+	help
+	  If you say yes here you get support for the Sensiron SHTC1 and SHTW1
+	  humidity and temperature sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called shtc1.
+
 config SENSORS_S3C
 	tristate "Samsung built-in ADC"
 	depends on S3C_ADC
diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
new file mode 100644
index 0000000..b3278ab
--- /dev/null
+++ b/drivers/hwmon/shtc1.c
@@ -0,0 +1,252 @@
+/* Sensirion SHTC1 humidity and temperature sensor driver
+ *
+ * Copyright (C) 2014 Sensirion AG, Switzerland
+ * Author: Johannes Winkelmann <johannes.winkelmann@sensirion.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/platform_data/shtc1.h>
+
+/* commands (high precision mode) */
+static const unsigned char shtc1_cmd_measure_blocking_hpm[]    = { 0x7C, 0xA2 };
+static const unsigned char shtc1_cmd_measure_nonblocking_hpm[] = { 0x78, 0x66 };
+
+/* commands (low precision mode) */
+static const unsigned char shtc1_cmd_measure_blocking_lpm[]    = { 0x64, 0x58 };
+static const unsigned char shtc1_cmd_measure_nonblocking_lpm[] = { 0x60, 0x9c };
+
+/* command for reading the ID register */
+static const unsigned char shtc1_cmd_read_id_reg[]	       = { 0xef, 0xc8 };
+
+/* constants for reading the ID register */
+#define SHTC1_ID_REG_CONTENT 0x07
+#define SHTC1_ID_REG_MASK    0x1f
+
+/* delays for non-blocking i2c commands, both in us */
+#define SHTC1_NONBLOCKING_WAIT_TIME_HPM  14400
+#define SHTC1_NONBLOCKING_WAIT_TIME_LPM   1000
+
+#define SHTC1_CMD_LENGTH      2
+#define SHTC1_RESPONSE_LENGTH 6
+
+struct shtc1_data {
+	struct device *hwmon_dev;
+	struct i2c_client *client;
+	struct mutex update_lock;
+	bool valid;
+	unsigned long last_updated; /* in jiffies */
+
+	const unsigned char *command;
+	unsigned int nonblocking_wait_time; /* in us */
+
+	struct shtc1_platform_data setup;
+
+	int temperature; /* 1000 * temperature in dgr C */
+	int humidity; /* 1000 * relative humidity in %RH */
+};
+
+static int shtc1_update_values(struct i2c_client *client,
+			       struct shtc1_data *data,
+			       char *buf, int bufsize)
+{
+	int ret = i2c_master_send(client, data->command, SHTC1_CMD_LENGTH);
+	if (ret != SHTC1_CMD_LENGTH) {
+		dev_err(&client->dev, "failed to send command: %d\n", ret);
+		return ret < 0 ? ret : -EIO;
+	}
+
+	/*
+	* In blocking mode (clock stretching mode) the I2C bus
+	* is blocked for other traffic, thus the call to i2c_master_recv()
+	* will wait until the data is ready. For non blocking mode, we
+	* have to wait ourselves.
+	*/
+	if (!data->setup.blocking_io)
+		usleep_range(data->nonblocking_wait_time,
+			     data->nonblocking_wait_time + 1000);
+
+	ret = i2c_master_recv(client, buf, bufsize);
+	if (ret != bufsize) {
+		dev_err(&client->dev, "failed to read values: %d\n", ret);
+		return ret < 0 ? ret : -EIO;
+	}
+
+	return 0;
+}
+
+/* sysfs attributes */
+static struct shtc1_data *shtc1_update_client(struct device *dev)
+{
+	struct shtc1_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
+
+	unsigned char buf[SHTC1_RESPONSE_LENGTH];
+	int val;
+	int ret = 0;
+
+	mutex_lock(&data->update_lock);
+
+	if (time_after(jiffies, data->last_updated + HZ / 10) || !data->valid) {
+		ret = shtc1_update_values(client, data, buf, sizeof(buf));
+		if (ret)
+			goto out;
+
+		/*
+		* From datasheet:
+		* T = -45 + 175 * ST / 2^16
+		* RH = 100 * SRH / 2^16
+		*
+		* Adapted for integer fixed point (3 digit) arithmetic.
+		*/
+		val = be16_to_cpup((__be16 *)buf);
+		data->temperature = ((21875 * val) >> 13) - 45000;
+		val = be16_to_cpup((__be16 *)(buf + 3));
+		data->humidity = ((12500 * val) >> 13);
+
+		data->last_updated = jiffies;
+		data->valid = 1;
+	}
+
+out:
+	mutex_unlock(&data->update_lock);
+
+	return ret == 0 ? data : ERR_PTR(ret);
+}
+
+static ssize_t shtc1_show_temperature(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	struct shtc1_data *data = shtc1_update_client(dev);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	return sprintf(buf, "%d\n", data->temperature);
+}
+
+static ssize_t shtc1_show_humidity(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct shtc1_data *data = shtc1_update_client(dev);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	return sprintf(buf, "%d\n", data->humidity);
+}
+
+static DEVICE_ATTR(temp1_input, S_IRUGO, shtc1_show_temperature, NULL);
+static DEVICE_ATTR(humidity1_input, S_IRUGO, shtc1_show_humidity, NULL);
+
+static struct attribute *shtc1_attrs[] = {
+	&dev_attr_temp1_input.attr,
+	&dev_attr_humidity1_input.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(shtc1);
+
+static void shtc1_select_command(struct shtc1_data *data)
+{
+	if (data->setup.high_precision) {
+		data->command = data->setup.blocking_io ?
+				shtc1_cmd_measure_blocking_hpm :
+				shtc1_cmd_measure_nonblocking_hpm;
+		data->nonblocking_wait_time = SHTC1_NONBLOCKING_WAIT_TIME_HPM;
+
+	} else {
+		data->command = data->setup.blocking_io ?
+				shtc1_cmd_measure_blocking_lpm :
+				shtc1_cmd_measure_nonblocking_lpm;
+		data->nonblocking_wait_time = SHTC1_NONBLOCKING_WAIT_TIME_LPM;
+	}
+}
+
+static int shtc1_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
+{
+	int ret;
+	char id_reg[2];
+	struct shtc1_data *data;
+	struct device *hwmon_dev;
+	struct i2c_adapter *adap = client->adapter;
+	struct device *dev = &client->dev;
+
+	if (!i2c_check_functionality(adap, I2C_FUNC_I2C)) {
+		dev_err(dev, "plain i2c transactions not supported\n");
+		return -ENODEV;
+	}
+
+	ret = i2c_master_send(client, shtc1_cmd_read_id_reg, SHTC1_CMD_LENGTH);
+	if (ret != SHTC1_CMD_LENGTH) {
+		dev_err(dev, "could not send read_id_reg command: %d\n", ret);
+		return ret < 0 ? ret : -ENODEV;
+	}
+	ret = i2c_master_recv(client, id_reg, sizeof(id_reg));
+	if (ret != sizeof(id_reg)) {
+		dev_err(dev, "could not read ID register: %d\n", ret);
+		return -ENODEV;
+	}
+	if ((id_reg[1] & SHTC1_ID_REG_MASK) != SHTC1_ID_REG_CONTENT) {
+		dev_err(dev, "ID register doesn't match\n");
+		return -ENODEV;
+	}
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->setup.blocking_io = false;
+	data->setup.high_precision = true;
+	data->client = client;
+
+	if (client->dev.platform_data)
+		data->setup = *(struct shtc1_platform_data *)dev->platform_data;
+	shtc1_select_command(data);
+	mutex_init(&data->update_lock);
+
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev,
+							   client->name,
+							   data,
+							   shtc1_groups);
+	if (IS_ERR(hwmon_dev))
+		dev_dbg(dev, "unable to register hwmon device\n");
+
+	return PTR_ERR_OR_ZERO(data->hwmon_dev);
+}
+
+/* device ID table */
+static const struct i2c_device_id shtc1_id[] = {
+	{ "shtc1", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, shtc1_id);
+
+static struct i2c_driver shtc1_i2c_driver = {
+	.driver.name  = "shtc1",
+	.probe        = shtc1_probe,
+	.id_table     = shtc1_id,
+};
+
+module_i2c_driver(shtc1_i2c_driver);
+
+MODULE_AUTHOR("Johannes Winkelmann <johannes.winkelmann@sensirion.com>");
+MODULE_DESCRIPTION("Sensirion SHTC1 humidity and temperature sensor driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/shtc1.h b/include/linux/platform_data/shtc1.h
new file mode 100644
index 0000000..7b8c353
--- /dev/null
+++ b/include/linux/platform_data/shtc1.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2014 Sensirion AG, Switzerland
+ * Author: Johannes Winkelmann <johannes.winkelmann@sensirion.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __SHTC1_H_
+#define __SHTC1_H_
+
+struct shtc1_platform_data {
+	bool blocking_io;
+	bool high_precision;
+};
+#endif /* __SHTC1_H_ */
-- 
1.8.3.2



