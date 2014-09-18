Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbaIRQQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:16:15 -0400
Received: from relay05.mycloudmailbox.com ([199.244.76.202]:49275 "EHLO
	relay05.mycloudmailbox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbaIRQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:16:13 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 12:16:13 EDT
From: David Barksdale <dbarksdale@uplogix.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: David Barksdale <dbarksdale@uplogix.com>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
Subject: [PATCH] IIO: add si701x driver
Date: Thu, 18 Sep 2014 11:07:55 -0500
Message-ID: <1411056475-22283-1-git-send-email-dbarksdale@uplogix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: S05-CAS001.S05.local (10.30.32.22) To
 S05-MLT01-07.S05.local (10.30.32.218)
X-RoutingAgent: Treated
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to the Industrial IO subsystem
for the Silicon Labs Si701x/2x Relative Humidity and
Temperature Sensors.

Website: http://www.silabs.com/products/sensors/humidity-sensors/Pages/si7013-20-21.aspx

These are i2c devices which measure relative humidity
and temperature and all use the same protocol. The
Si7013 has an additional input with programmable
linearization which is not supported because that's
complicated and I didn't need it.

Signed-off-by: David Barksdale <dbarksdale@uplogix.com>

---
 drivers/iio/humidity/Kconfig  |  10 +++
 drivers/iio/humidity/Makefile |   1 +
 drivers/iio/humidity/si701x.c | 159 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+)

diff --git a/drivers/iio/humidity/Kconfig b/drivers/iio/humidity/Kconfig
index e116bd8..ba0ef61 100644
--- a/drivers/iio/humidity/Kconfig
+++ b/drivers/iio/humidity/Kconfig
@@ -22,4 +22,14 @@ config SI7005
 	  To compile this driver as a module, choose M here: the module
 	  will be called si7005.
 
+config SI701X
+	tristate "Si701x/2x Relative Humidity and Temperature Sensors"
+	depends on I2C
+	help
+	  Say yes here to build support for the Silicon Labs Si701x/2x Relative
+	  Humidity and Temperature Sensors.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called si701x.
+
 endmenu
diff --git a/drivers/iio/humidity/Makefile b/drivers/iio/humidity/Makefile
index e3f3d94..d2e9645 100644
--- a/drivers/iio/humidity/Makefile
+++ b/drivers/iio/humidity/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_DHT11) += dht11.o
 obj-$(CONFIG_SI7005) += si7005.o
+obj-$(CONFIG_SI701X) += si701x.o
diff --git a/drivers/iio/humidity/si701x.c b/drivers/iio/humidity/si701x.c
new file mode 100644
index 0000000..1a2ee22
--- /dev/null
+++ b/drivers/iio/humidity/si701x.c
@@ -0,0 +1,159 @@
+/*
+ * si701x.c - Silicon Labs Si701x/2x Relative Humidity and Temperature Sensors
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
+ * The Silicon Labs Si701x/2x Relative Humidity and Temperature Sensors
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
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+
+enum {
+	/* Measure Relative Humidity, Hold Master Mode */
+	SI701XCMD_RH_HOLD	= 0xE5,
+	/* Measure Temperature, Hold Master Mode */
+	SI701XCMD_TEMP_HOLD	= 0xE3,
+};
+
+struct si701x_data {
+	struct i2c_client *client;
+	struct mutex lock;
+};
+
+static int si701x_read_raw(struct iio_dev *indio_dev,
+			   struct iio_chan_spec const *chan, int *val,
+			   int *val2, long mask)
+{
+	struct si701x_data *data = iio_priv(indio_dev);
+	int ret;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		mutex_lock(&data->lock);
+		ret = i2c_smbus_read_word_data(data->client,
+					       chan->type == IIO_TEMP ?
+					       SI701XCMD_TEMP_HOLD :
+					       SI701XCMD_RH_HOLD);
+		mutex_unlock(&data->lock);
+		if (ret < 0)
+			return ret;
+		*val = ret;
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		if (chan->type == IIO_TEMP) {
+			*val = 175.72 * 1000;
+			*val2 = 65536;
+		} else {
+			*val = 125 * 1000;
+			*val2 = 65536;
+		}
+		return IIO_VAL_FRACTIONAL;
+	case IIO_CHAN_INFO_OFFSET:
+		if (chan->type == IIO_TEMP)
+			*val = -46.85 * 65536 / 175.72;
+		else
+			*val = -6 * 65536 / 125;
+		return IIO_VAL_INT;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static const struct iio_chan_spec si701x_channels[] = {
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
+static const struct iio_info si701x_info = {
+	.read_raw = si701x_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int si701x_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct iio_dev *dev;
+	struct si701x_data *data;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
+		return -ENODEV;
+
+	dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
+	if (!dev)
+		return -ENOMEM;
+
+	data = iio_priv(dev);
+	i2c_set_clientdata(client, dev);
+	data->client = client;
+	mutex_init(&data->lock);
+
+	dev->dev.parent = &client->dev;
+	dev->name = dev_name(&client->dev);
+	dev->modes = INDIO_DIRECT_MODE;
+	dev->info = &si701x_info;
+	dev->channels = si701x_channels;
+	dev->num_channels = ARRAY_SIZE(si701x_channels);
+
+	return devm_iio_device_register(&client->dev, dev);
+}
+
+static const unsigned short si701x_address_list[] = {
+	0x40,
+	I2C_CLIENT_END
+};
+
+static const struct i2c_device_id si701x_id[] = {
+	{ "si701x", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, si701x_id);
+
+static struct i2c_driver si701x_driver = {
+	.class		= I2C_CLASS_HWMON,
+	.driver.name	= "si701x",
+	.probe		= si701x_probe,
+	.address_list	= si701x_address_list,
+	.id_table	= si701x_id,
+};
+
+module_i2c_driver(si701x_driver);
+MODULE_DESCRIPTION("Silicon Labs Si701x/2x "
+		   "Relative Humidity and Temperature Sensors");
+MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
+MODULE_LICENSE("GPL");
+
-- 
tg: (59753a8..) upstream/si7020 (depends on: upstream/master)
