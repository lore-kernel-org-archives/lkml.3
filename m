Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaEAXFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:05:39 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49298 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaEAXFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:05:38 -0400
Message-ID: <1398985530.17142.15.camel@ltli10.sensirion.lokal>
Subject: [RFC][PATCH v2] hwmon: add support for Sensirion SHTC1 sensor
From: Tomas Pop <tomas.pop.mff@gmail.com>
To: "jdelvare@suse.de" <jdelvare@suse.de>
Cc: "linux@roeck-us.net" <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 01 May 2014 16:05:30 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more time this patch sent with correct settings of my email client 
- I'm sorry for this.

This is a second version of the driver for Sensirion SHTC1 humidity and
temperature sensor. Initial version was submitted in July 2012.
http://www.gossamer-threads.com/lists/linux/kernel/1569130#1569130

We included suggested corrections formerly discussed in this list after
initial submission, but since it is quite a while, we are re-submitting
it again as a request for comments. Here is a list of important changes
to the initial version:

* returning real error codes instead of -1 or -ENODEV
* using boolean variables instead of bitmaps where possible
* macros be16_to_cpup used for conversion of indianneess
* corrected formula for decoding of humidity and temperature values
* documentation update

Patch was generated against kernel v3.15-rc3

Signed-off-by: Tomas Pop <tomas.pop@sensirion.com>
---
 Documentation/hwmon/shtc1           |  38 +++++
 drivers/hwmon/Kconfig               |  10 ++
 drivers/hwmon/Makefile              |   1 +
 drivers/hwmon/shtc1.c               | 323 ++++++++++++++++++++++++++++++++++++
 include/linux/platform_data/shtc1.h |  24 +++
 5 files changed, 396 insertions(+)
 create mode 100644 Documentation/hwmon/shtc1
 create mode 100644 drivers/hwmon/shtc1.c
 create mode 100644 include/linux/platform_data/shtc1.h

diff --git a/Documentation/hwmon/shtc1 b/Documentation/hwmon/shtc1
new file mode 100644
index 0000000..6a72ae2d
--- /dev/null
+++ b/Documentation/hwmon/shtc1
@@ -0,0 +1,38 @@
+Kernel driver shtc1
+===================
+
+Supported chips:
+  * Sensirion SHTC1
+    Prefix: 'shtc1'
+    Addresses scanned: none
+    Datasheet: Publicly available at the Sensirion website
+    http://www.sensirion.com/fileadmin/user_upload/customers/sensirion/Dokumente/Humidity/Sensirion_Humidity_SHTC1_Datasheet.pdf
+
+Author:
+  Johannes Winkelmann <johannes.winkelmann@sensirion.com>
+
+Description
+-----------
+
+This driver implements support for the Sensirion  SHTC1 chip, a humidity and
+temperature sensor. Temperature is measured in degrees celsius, relative
+humidity is expressed as a percentage. Driver can be used as well for SHTW1
+chip, that has the same electrical interface, but datasheet has not been
+yet published.
+
+The device communicates with the I2C protocol. All sensors are set to the same
+I2C address 0x70, so an entry with I2C_BOARD_INFO("shtc1", 0x70) can be used
+in the board setup code. See Documentation/i2c/instantiating-devices for
+other methods to instantiate the device.
+
+Furthermore, there are two configuration options by means of platform_data:
+1. blocking (pull the I2C clock line down while performing the measurement) or
+   non-blocking, mode. Blocking mode will guarantee the fastest result, but
+   the I2C bus will be busy during that time
+2. high or low accuracy. Using high accuracy is always recommended.
+
+sysfs-Interface
+---------------
+
+temp1_input - temperature input
+humidity1_input - humidity input
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index bc196f4..4d58149 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1114,6 +1114,16 @@ config SENSORS_SHT21
 	  This driver can also be built as a module.  If so, the module
 	  will be called sht21.
 
+config SENSORS_SHTC1
+	tristate "Sensiron humidity and temperature sensors. SHTC1 and compat."
+	depends on I2C
+	help
+	  If you say yes here you get support for the Sensiron SHTC1 humidity
+	  and temperature sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called shtc1.
+
 config SENSORS_S3C
 	tristate "Samsung built-in ADC"
 	depends on S3C_ADC
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index c48f987..1cc5273 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -125,6 +125,7 @@ obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
 obj-$(CONFIG_SENSORS_SCH5636)	+= sch5636.o
 obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
 obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
+obj-$(CONFIG_SENSORS_SHTC1)	+= shtc1.o
 obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
 obj-$(CONFIG_SENSORS_SMM665)	+= smm665.o
 obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
new file mode 100644
index 0000000..96d398b
--- /dev/null
+++ b/drivers/hwmon/shtc1.c
@@ -0,0 +1,323 @@
+/* Sensirion SHTC1 humidity and temperature sensor driver
+ *
+ * Copyright (C) 2012 Sensirion AG, Switzerland
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
+ * Data sheet available soon
+ *  TODO: add link
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
+/* command and constants for reading the ID register */
+static const unsigned char shtc1_cmd_read_id_reg[]	     = { 0xef, 0xc8 };
+static const unsigned char shtc1_id_reg_content = 0x07;
+static const unsigned char shtc1_id_reg_mask    = 0x1f;
+
+/* delays for non-blocking i2c commands */
+/* TODO: use max timings */
+#define SHTC1_NONBLOCKING_WAIT_TIME_HPM  10
+#define SHTC1_NONBLOCKING_WAIT_TIME_LPM   1
+
+#define SHTC1_CMD_LENGTH      2
+#define SHTC1_RESPONSE_LENGTH 6
+
+struct shtc1_data {
+	struct device *hwmon_dev;
+	struct mutex update_lock;
+	bool valid;
+	unsigned long last_updated; /* In jiffies */
+
+	const unsigned char *command;
+	unsigned int nonblocking_wait_time;
+
+	struct shtc1_platform_data setup;
+
+	int temperature;
+	int humidity;
+};
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
+static int shtc1_update_values(struct i2c_client *client,
+				struct shtc1_data *data,
+				char *buf,
+				int bufsize)
+{
+	int ret = i2c_master_send(client, data->command, SHTC1_CMD_LENGTH);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to send command: %d", ret);
+		return ret;
+	}
+
+	/*
+	* In blocking mode (clock stretching mode) the I2C bus
+	* is blocked for other traffic, thus the call to i2c_master_recv()
+	* will wait until the data is ready. for non blocking mode, we
+	* have to wait ourselves, thus the msleep().
+	*
+	* TODO: consider usleep_range
+	*/
+	if (!data->setup.blocking_io)
+		msleep(data->nonblocking_wait_time);
+
+	ret = i2c_master_recv(client, buf, bufsize);
+	if (ret != bufsize) {
+		dev_err(&client->dev, "failed to read values: %d", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/* sysfs attributes */
+static struct shtc1_data *shtc1_update_client(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct shtc1_data *data = i2c_get_clientdata(client);
+
+	unsigned char buf[SHTC1_RESPONSE_LENGTH];
+	int val;
+	int ret;
+
+	mutex_lock(&data->update_lock);
+
+	/*
+	* Initialize 'ret' in case we had a valid result before, but
+	* read too quickly in which case we return the last values.
+	*/
+	ret = !data->valid;
+
+	if (time_after(jiffies, data->last_updated + HZ / 10) || !data->valid) {
+		ret = shtc1_update_values(client, data, buf, sizeof(buf));
+
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
+		val = be16_to_cpup((__be16 *)(buf+3));
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
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct shtc1_data *data = shtc1_update_client(dev);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	return sprintf(buf, "%d\n", data->temperature);
+}
+
+static ssize_t shtc1_show_humidity(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct shtc1_data *data = shtc1_update_client(dev);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	return sprintf(buf, "%d\n", data->humidity);
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
+			shtc1_show_temperature, NULL, 0);
+static SENSOR_DEVICE_ATTR(humidity1_input, S_IRUGO,
+			shtc1_show_humidity, NULL, 0);
+
+static struct attribute *shtc1_attributes[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_humidity1_input.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group shtc1_attr_group = {
+	.attrs = shtc1_attributes,
+};
+
+static int shtc1_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct shtc1_data *data;
+	int err;
+	struct i2c_adapter *adap = client->adapter;
+	char id_reg[2];
+
+	if (!i2c_check_functionality(adap, I2C_FUNC_I2C)) {
+		dev_err(&client->dev,
+			"adapter does not support plain i2c transactions\n");
+		return -ENODEV;
+	}
+
+	err = i2c_master_send(client, shtc1_cmd_read_id_reg, SHTC1_CMD_LENGTH);
+
+	if (err < 0) {
+		dev_err(&client->dev, "could not send read command: %d\n", err);
+		return -ENODEV;
+	}
+	err = i2c_master_recv(client, id_reg, sizeof(id_reg));
+	if (err != sizeof(id_reg)) {
+		dev_err(&client->dev, "could not read ID register: %d\n", err);
+		return -ENODEV;
+	}
+	if ((id_reg[1] & shtc1_id_reg_mask) != shtc1_id_reg_content) {
+		dev_err(&client->dev, "ID register doesn't match\n");
+		return -ENODEV;
+	}
+
+	data = devm_kzalloc(&client->dev, sizeof(struct shtc1_data),
+				GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* defaults: blocking, high precision mode */
+	data->setup.blocking_io = 1;
+	data->setup.high_precision = 1;
+
+	if (client->dev.platform_data)
+		data->setup = *(struct shtc1_platform_data *)client->dev.platform_data;
+	shtc1_select_command(data);
+
+	i2c_set_clientdata(client, data);
+	mutex_init(&data->update_lock);
+
+	err = sysfs_create_group(&client->dev.kobj, &shtc1_attr_group);
+	if (err) {
+		dev_dbg(&client->dev, "could not create sysfs files\n");
+		goto fail_free;
+		return err;
+	}
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		dev_dbg(&client->dev, "unable to register hwmon device\n");
+		err = PTR_ERR(data->hwmon_dev);
+		goto fail_remove_sysfs;
+	}
+
+
+	dev_info(&client->dev, "initialized\n");
+
+	return 0;
+
+fail_remove_sysfs:
+	sysfs_remove_group(&client->dev.kobj, &shtc1_attr_group);
+fail_free:
+	kfree(data);
+
+	return err;
+}
+
+/**
+ * shtc1_remove() - remove device
+ * @client: I2C client device
+ */
+static int shtc1_remove(struct i2c_client *client)
+{
+	struct shtc1_data *data = i2c_get_clientdata(client);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &shtc1_attr_group);
+
+	return 0;
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
+	.driver.name = "shtc1",
+	.probe	= shtc1_probe,
+	.remove      = shtc1_remove,
+	.id_table    = shtc1_id,
+};
+
+/**
+ * shtc1_init() - initialize driver
+ *
+ * Called when kernel is booted or module is inserted.
+ * Returns 0 on success.
+ */
+static int __init shtc1_init(void)
+{
+	return i2c_add_driver(&shtc1_i2c_driver);
+}
+module_init(shtc1_init);
+
+/*
+ * shtc1_exit() - clean up driver
+ *
+ * Called when module is removed.
+ */
+static void __exit shtc1_exit(void)
+{
+	i2c_del_driver(&shtc1_i2c_driver);
+}
+
+module_exit(shtc1_exit);
+
+
+MODULE_AUTHOR("Johannes Winkelmann <johannes.winkelmann@sensirion.com>");
+MODULE_DESCRIPTION("Sensirion SHTC1 humidity and temperature sensor driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/shtc1.h b/include/linux/platform_data/shtc1.h
new file mode 100644
index 0000000..4629364
--- /dev/null
+++ b/include/linux/platform_data/shtc1.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2012 Sensirion AG, Switzerland
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
+
+#endif
-- 
1.8.3.2



