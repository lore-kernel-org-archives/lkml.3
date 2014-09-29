Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaI2S3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:29:10 -0400
Received: from relay05.mycloudmailbox.com ([199.244.76.203]:50071 "EHLO
	relay05.mycloudmailbox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbaI2S3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:29:07 -0400
From: David Barksdale <dbarksdale@uplogix.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: David Barksdale <dbarksdale@uplogix.com>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
Subject: [PATCH v4] IIO: add si7020 driver
Date: Mon, 29 Sep 2014 13:28:55 -0500
Message-ID: <1412015335-19648-1-git-send-email-dbarksdale@uplogix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: S05-CAS003.S05.local (10.30.32.24) To
 S05-MLT01-07.S05.local (10.30.32.218)
X-RoutingAgent: Treated
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to the Industrial IO subsystem
for the Silicon Labs Si7013/20/21 Relative Humidity and
Temperature Sensors.

Website: http://www.silabs.com/products/sensors/humidity-sensors/Pages/si7013-20-21.aspx

These are i2c devices which measure relative humidity
and temperature and all use the same protocol. The
Si7013 has an additional input with programmable
linearization which is not supported because that's
complicated and I didn't need it.

Signed-off-by: David Barksdale <dbarksdale@uplogix.com>

--
Changes since v1:
* Renamed to si7020 and replaced Si701x/2x with Si7013/20/21.
* Removed unneeded mutex.
* Pre-computed floating-point constant expressions.
* Removed address_list and I2C_CLASS_HWMON.

Changes since v2:
* Return correct raw sensor values.
* Rename dev variable to indio_dev.
* Issue a software reset command during probe.
* Un-broke string literal.

Changes since v3:
* enum changed to #define

---
 drivers/iio/humidity/Kconfig  |  10 +++
 drivers/iio/humidity/Makefile |   1 +
 drivers/iio/humidity/si7020.c | 163 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+)

diff --git a/drivers/iio/humidity/Kconfig b/drivers/iio/humidity/Kconfig
index e116bd8..4813b79 100644
--- a/drivers/iio/humidity/Kconfig
+++ b/drivers/iio/humidity/Kconfig
@@ -22,4 +22,14 @@ config SI7005
 	  To compile this driver as a module, choose M here: the module
 	  will be called si7005.
 
+config SI7020
+	tristate "Si7013/20/21 Relative Humidity and Temperature Sensors"
+	depends on I2C
+	help
+	  Say yes here to build support for the Silicon Labs Si7013/20/21
+	  Relative Humidity and Temperature Sensors.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called si7020.
+
 endmenu
diff --git a/drivers/iio/humidity/Makefile b/drivers/iio/humidity/Makefile
index e3f3d94..86e2d26 100644
--- a/drivers/iio/humidity/Makefile
+++ b/drivers/iio/humidity/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_DHT11) += dht11.o
 obj-$(CONFIG_SI7005) += si7005.o
+obj-$(CONFIG_SI7020) += si7020.o
diff --git a/drivers/iio/humidity/si7020.c b/drivers/iio/humidity/si7020.c
new file mode 100644
index 0000000..db60ab7
--- /dev/null
+++ b/drivers/iio/humidity/si7020.c
@@ -0,0 +1,163 @@
+/*
+ * si7020.c - Silicon Labs Si7013/20/21 Relative Humidity and Temp Sensors
+ * Copyright (c) 2013,2014  Uplogix, Inc.
+ * David Barksdale <dbarksdale@uplogix.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * The Silicon Labs Si7013/20/21 Relative Humidity and Temperature Sensors
+ * are i2c devices which have an identical programming interface for
+ * measuring relative humidity and temperature. The Si7013 has an additional
+ * temperature input which this driver does not support.
+ *
+ * Data Sheets:
+ *   Si7013: http://www.silabs.com/Support%20Documents/TechnicalDocs/Si7013.pdf
+ *   Si7020: http://www.silabs.com/Support%20Documents/TechnicalDocs/Si7020.pdf
+ *   Si7021: http://www.silabs.com/Support%20Documents/TechnicalDocs/Si7021.pdf
+ */
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+
+/* Measure Relative Humidity, Hold Master Mode */
+#define SI7020CMD_RH_HOLD	0xE5
+/* Measure Temperature, Hold Master Mode */
+#define SI7020CMD_TEMP_HOLD	0xE3
+/* Software Reset */
+#define SI7020CMD_RESET		0xFE
+
+static int si7020_read_raw(struct iio_dev *indio_dev,
+			   struct iio_chan_spec const *chan, int *val,
+			   int *val2, long mask)
+{
+	struct i2c_client **client = iio_priv(indio_dev);
+	int ret;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		ret = i2c_smbus_read_word_data(*client,
+					       chan->type == IIO_TEMP ?
+					       SI7020CMD_TEMP_HOLD :
+					       SI7020CMD_RH_HOLD);
+		if (ret < 0)
+			return ret;
+		if (chan->type == IIO_TEMP)
+			*val = ret >> 2;
+		else
+			*val = (ret & 0x3FFF) >> 2;
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		if (chan->type == IIO_TEMP)
+			*val = 175720; /* = 175.72 * 1000 */
+		else
+			*val = 125 * 1000;
+		*val2 = 65536 >> 2;
+		return IIO_VAL_FRACTIONAL;
+	case IIO_CHAN_INFO_OFFSET:
+		/* Since iio_convert_raw_to_processed_unlocked assumes offset
+		 * is an integer we have to round these values and lose
+		 * accuracy.
+		 * Relative humidity will be 0.0032959% too high and
+		 * temperature will be 0.00277344 degrees too high.
+		 * This is no big deal because it's within the accuracy of the
+		 * sensor.
+		 */
+		if (chan->type == IIO_TEMP)
+			*val = -4368; /* = -46.85 * (65536 >> 2) / 175.72 */
+		else
+			*val = -786; /* = -6 * (65536 >> 2) / 125 */
+		return IIO_VAL_INT;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static const struct iio_chan_spec si7020_channels[] = {
+	{
+		.type = IIO_HUMIDITYRELATIVE,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
+			BIT(IIO_CHAN_INFO_SCALE) | BIT(IIO_CHAN_INFO_OFFSET),
+	},
+	{
+		.type = IIO_TEMP,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
+			BIT(IIO_CHAN_INFO_SCALE) | BIT(IIO_CHAN_INFO_OFFSET),
+	}
+};
+
+static const struct iio_info si7020_info = {
+	.read_raw = si7020_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int si7020_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct iio_dev *indio_dev;
+	struct i2c_client **data;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_WRITE_BYTE |
+				     I2C_FUNC_SMBUS_READ_WORD_DATA))
+		return -ENODEV;
+
+	/* Reset device, loads default settings. */
+	ret = i2c_smbus_write_byte(client, SI7020CMD_RESET);
+	if (ret < 0)
+		return ret;
+	/* Wait the maximum power-up time after software reset. */
+	msleep(15);
+
+	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*client));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	data = iio_priv(indio_dev);
+	*data = client;
+	i2c_set_clientdata(client, indio_dev);
+
+	indio_dev->dev.parent = &client->dev;
+	indio_dev->name = dev_name(&client->dev);
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->info = &si7020_info;
+	indio_dev->channels = si7020_channels;
+	indio_dev->num_channels = ARRAY_SIZE(si7020_channels);
+
+	return devm_iio_device_register(&client->dev, indio_dev);
+}
+
+static const struct i2c_device_id si7020_id[] = {
+	{ "si7020", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, si7020_id);
+
+static struct i2c_driver si7020_driver = {
+	.driver.name	= "si7020",
+	.probe		= si7020_probe,
+	.id_table	= si7020_id,
+};
+
+module_i2c_driver(si7020_driver);
+MODULE_DESCRIPTION("Silicon Labs Si7013/20/21 Relative Humidity and Temperature Sensors");
+MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
+MODULE_LICENSE("GPL");
+
-- 
tg: (0f33be0..) upstream/si7020 (depends on: upstream/master)
