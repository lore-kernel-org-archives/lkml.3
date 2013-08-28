Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3H1G71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:59:27 -0400
Received: from par-mx.meas-spec.com ([198.190.228.177]:44410 "EHLO
	par-mx.meas-spec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab3H1G7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:59:25 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 02:59:25 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] hwmon: (htu21) Add Measurement Specialties HTU21D support
Date: Wed, 28 Aug 2013 08:49:36 +0200
Message-ID: <E7458771276B644AB8F21A92079F7D6C53C593@tlse-mail1.europe.msiusa.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] hwmon: (htu21) Add Measurement Specialties HTU21D support
Thread-Index: Ac6juoJf5rtiZjoTSsyMKjfozxe+qQ==
From: "Markezana, William" <William.Markezana@meas-spec.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Aug 2013 06:49:36.0405 (UTC) FILETIME=[C2940C50:01CEA3BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 55fc390d0079841405d5345b55a6e158ca5f3749 Mon Sep 17 00:00:00 2001
From: William Markezana <william.markezana@meas-spec.com>
Date: Wed, 28 Aug 2013 08:33:49 +0200
Subject: [PATCH] hwmon: (htu21) Add Measurement Specialties HTU21D support

---
 Documentation/hwmon/htu21 |   43 ++++++++++
 drivers/hwmon/Kconfig     |   10 +++
 drivers/hwmon/Makefile    |    1 +
 drivers/hwmon/htu21.c     |  201 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 255 insertions(+)
 create mode 100644 Documentation/hwmon/htu21
 create mode 100644 drivers/hwmon/htu21.c

diff --git a/Documentation/hwmon/htu21 b/Documentation/hwmon/htu21
new file mode 100644
index 0000000..ab756bc
--- /dev/null
+++ b/Documentation/hwmon/htu21
@@ -0,0 +1,43 @@
+Kernel driver htu21
+===================
+
+Supported chips:
+  * Measurement Specialties HTU21D
+    Prefix: 'htu21'
+    Addresses scanned: none
+    Datasheet: Publicly available at the Measurement Specialties website
+    http://www.meas-spec.com/downloads/HTU21D.pdf
+
+
+Author:
+  William Markezana <william.markezana@meas-spec.com>
+
+Description
+-----------
+
+HTU21D(F), the new digital humidity sensor with temperature output of MEAS is about 
+to set new standards in terms of size and intelligence: Embedded in a reflow 
+solderable Dual Flat No leads (DFN) package of 3 x 3 mm foot print and 0.9 mm height 
+it provides calibrated, linearized signals in digital, I²C format.
+
+The devices communicate with the I2C protocol. All sensors are set to the same
+I2C address 0x40, so an entry with I2C_BOARD_INFO("htu21", 0x40) can be used
+in the board setup code.
+
+sysfs-Interface
+---------------
+
+temp1_input - temperature input
+humidity1_input - humidity input
+
+Notes
+-----
+
+The driver uses the default resolution settings of 12 bit for humidity and 14
+bit for temperature, which results in typical measurement times of 11 ms for
+humidity and 44 ms for temperature. To keep self heating below 0.1 degree
+Celsius, the device should not be active for more than 10% of the time,
+e.g. maximum two measurements per second at the given resolution.
+
+Different resolutions, the on-chip heater, using the CRC checksum and reading
+the serial number are not supported yet.
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index e989f7f..eb46eb8 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -511,6 +511,16 @@ config SENSORS_HIH6130
 	  This driver can also be built as a module.  If so, the module
 	  will be called hih6130.
 
+config SENSORS_HTU21
+	tristate "Measurement Specialties HTU21D humidity and temperature sensors"
+	depends on I2C
+	help
+	  If you say yes here you get support for the Measurement Specialties
+	  HTU21D humidity and temperature sensors.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called htu21.
+
 config SENSORS_CORETEMP
 	tristate "Intel Core/Core2/Atom temperature sensor"
 	depends on X86
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 4f0fb52..ec7cde0 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm.o
 obj-$(CONFIG_SENSORS_GL520SM)	+= gl520sm.o
 obj-$(CONFIG_SENSORS_GPIO_FAN)	+= gpio-fan.o
 obj-$(CONFIG_SENSORS_HIH6130)	+= hih6130.o
+obj-$(CONFIG_SENSORS_HTU21)	+= htu21.o
 obj-$(CONFIG_SENSORS_ULTRA45)	+= ultra45_env.o
 obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
 obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
diff --git a/drivers/hwmon/htu21.c b/drivers/hwmon/htu21.c
new file mode 100644
index 0000000..8b8d132
--- /dev/null
+++ b/drivers/hwmon/htu21.c
@@ -0,0 +1,201 @@
+/* Measurement Specialties HTU21D humidity and temperature sensor driver
+ *
+ * Copyright (C) 2013 William Markezana <william.markezana@meas-spec.com>
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Data sheet available (7/2013) at
+ * http://www.meas-spec.com/downloads/HTU21D.pdf
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+
+/* HTU21 Commands */
+#define HTU21_T_MEASUREMENT_HM  0xE3
+#define HTU21_RH_MEASUREMENT_HM 0xE5
+
+struct htu21 {
+	struct device *hwmon_dev;
+	struct mutex lock;
+	char valid;
+	unsigned long last_update;
+	int temperature;
+	int humidity;
+};
+
+static inline int htu21_temp_ticks_to_millicelsius(int ticks)
+{
+	ticks &= ~0x0003; /* clear status bits */
+	/*
+	 * Formula T = -46.85 + 175.72 * ST / 2^16 from datasheet p14,
+	 * optimized for integer fixed point (3 digits) arithmetic
+	 */
+	return ((21965 * ticks) >> 13) - 46850;
+}
+
+static inline int htu21_rh_ticks_to_per_cent_mille(int ticks)
+{
+	ticks &= ~0x0003; /* clear status bits */
+	/*
+	 * Formula RH = -6 + 125 * SRH / 2^16 from datasheet p14,
+	 * optimized for integer fixed point (3 digits) arithmetic
+	 */
+	return ((15625 * ticks) >> 13) - 6000;
+}
+
+static int htu21_update_measurements(struct i2c_client *client)
+{
+	int ret = 0;
+	struct htu21 *htu21 = i2c_get_clientdata(client);
+
+	mutex_lock(&htu21->lock);
+
+	if (time_after(jiffies, htu21->last_update + HZ / 2) || !htu21->valid) {
+		ret = i2c_smbus_read_word_swapped(client, HTU21_T_MEASUREMENT_HM);
+		if (ret < 0)
+			goto out;
+		htu21->temperature = htu21_temp_ticks_to_millicelsius(ret);
+		ret = i2c_smbus_read_word_swapped(client, HTU21_RH_MEASUREMENT_HM);
+		if (ret < 0)
+			goto out;
+		htu21->humidity = htu21_rh_ticks_to_per_cent_mille(ret);
+		htu21->last_update = jiffies;
+		htu21->valid = 1;
+	}
+out:
+	mutex_unlock(&htu21->lock);
+
+	return ret >= 0 ? 0 : ret;
+}
+
+static ssize_t htu21_show_temperature(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct htu21 *htu21 = i2c_get_clientdata(client);
+	int ret = htu21_update_measurements(client);
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%d\n", htu21->temperature);
+}
+
+static ssize_t htu21_show_humidity(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct htu21 *htu21 = i2c_get_clientdata(client);
+	int ret = htu21_update_measurements(client);
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%d\n", htu21->humidity);
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, htu21_show_temperature,	NULL, 0);
+static SENSOR_DEVICE_ATTR(humidity1_input, S_IRUGO, htu21_show_humidity, NULL, 0);
+
+static struct attribute *htu21_attributes[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_humidity1_input.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group htu21_group = {
+	.attrs = htu21_attributes,
+};
+
+static int htu21_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	struct htu21 *htu21;
+	int err;
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_WORD_DATA)) {
+		dev_err(&client->dev,
+			"adapter does not support SMBus word transactions\n");
+		return -ENODEV;
+	}
+
+	htu21 = devm_kzalloc(&client->dev, sizeof(*htu21), GFP_KERNEL);
+	if (!htu21)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, htu21);
+
+	mutex_init(&htu21->lock);
+
+	err = sysfs_create_group(&client->dev.kobj, &htu21_group);
+	if (err) {
+		dev_dbg(&client->dev, "could not create sysfs files\n");
+		return err;
+	}
+	htu21->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(htu21->hwmon_dev)) {
+		dev_dbg(&client->dev, "unable to register hwmon device\n");
+		err = PTR_ERR(htu21->hwmon_dev);
+		goto error;
+	}
+
+	dev_info(&client->dev, "initialized\n");
+
+	return 0;
+
+error:
+	sysfs_remove_group(&client->dev.kobj, &htu21_group);
+	return err;
+}
+
+static int htu21_remove(struct i2c_client *client)
+{
+	struct htu21 *htu21 = i2c_get_clientdata(client);
+
+	hwmon_device_unregister(htu21->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &htu21_group);
+
+	return 0;
+}
+
+static const struct i2c_device_id htu21_id[] = {
+	{ "htu21", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, htu21_id);
+
+static struct i2c_driver htu21_driver = {
+	.class = I2C_CLASS_HWMON,
+	.driver = {
+		.name	= "htu21",
+	},
+	.probe       = htu21_probe,
+	.remove      = htu21_remove,
+	.id_table    = htu21_id,
+};
+
+module_i2c_driver(htu21_driver);
+
+MODULE_AUTHOR("William Markezana <william.markezana@meas-spec.com>");
+MODULE_DESCRIPTION("Measurement Specialties HTU21D humidity and temperature sensor driver");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

