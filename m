Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab3D3WVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:21:55 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:56790 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab3D3WVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:21:53 -0400
From: Oskar Andero <oskar.andero@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        Oskar Andero <oskar.andero@gmail.com>
Subject: [PATCH] iio: adc: add driver for MCP3204/08 12-bit ADC
Date: Wed,  1 May 2013 00:21:37 +0200
Message-Id: <1367360497-16820-1-git-send-email-oskar.andero@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for Microchip's 12 bit AD converters MCP3204 and
MCP3208. These chips communicates over SPI and supports single-ended
and pseudo-differential configurations.

Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Oskar Andero <oskar.andero@gmail.com>
---
 drivers/iio/adc/Kconfig               |  10 ++
 drivers/iio/adc/Makefile              |   1 +
 drivers/iio/adc/mcp320x.c             | 261 ++++++++++++++++++++++++++++++++++
 include/linux/platform_data/mcp320x.h |  23 +++
 4 files changed, 295 insertions(+)
 create mode 100644 drivers/iio/adc/mcp320x.c
 create mode 100644 include/linux/platform_data/mcp320x.h

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index ab0767e6..93129ec 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -133,6 +133,16 @@ config MAX1363
 	  max11646, max11647) Provides direct access via sysfs and buffered
 	  data via the iio dev interface.
 
+config MCP320X
+	tristate "Microchip Technology MCP3204/08"
+	depends on SPI
+	help
+	  Say yes here to build support for Microchip Technology's MCP3204 or
+	  MCP3208 analog to digital converter.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called mcp320x.
+
 config TI_ADC081C
 	tristate "Texas Instruments ADC081C021/027"
 	depends on I2C
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 0a825be..8f475d3 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_AT91_ADC) += at91_adc.o
 obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
 obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
 obj-$(CONFIG_MAX1363) += max1363.o
+obj-$(CONFIG_MCP320X) += mcp320x.o
 obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
 obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
 obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
diff --git a/drivers/iio/adc/mcp320x.c b/drivers/iio/adc/mcp320x.c
new file mode 100644
index 0000000..cb308e8
--- /dev/null
+++ b/drivers/iio/adc/mcp320x.c
@@ -0,0 +1,261 @@
+/*
+ * Copyright (C) 2013 Oskar Andero <oskar.andero@gmail.com>
+ *
+ * Driver for Microchip Technology's MCP3204 and MCP3208 ADC chips.
+ * Datasheet can be found here:
+ * http://ww1.microchip.com/downloads/en/devicedoc/21298c.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/spi/spi.h>
+#include <linux/module.h>
+#include <linux/iio/iio.h>
+#include <linux/regulator/consumer.h>
+#include <linux/platform_data/mcp320x.h>
+
+#define MCP_SINGLE_ENDED	(1 << 3)
+#define MCP_START_BIT		(1 << 4)
+
+enum {
+	mcp3204,
+	mcp3208,
+};
+
+struct mcp320x {
+	struct spi_device *spi;
+	struct spi_message msg;
+	struct spi_transfer transfer[2];
+
+	u8 tx_buf;
+	u8 rx_buf[2];
+
+	struct regulator *reg;
+	unsigned int ref_mv;
+
+	struct mutex lock;
+};
+
+static int mcp320x_adc_conversion(struct mcp320x *adc, u8 msg)
+{
+	int ret;
+
+	adc->tx_buf = msg;
+	ret = spi_sync(adc->spi, &adc->msg);
+	if (ret < 0)
+		return ret;
+
+	return ((adc->rx_buf[0] & 0x3f) << 6)  |
+		(adc->rx_buf[1] >> 2);
+}
+
+static int mcp320x_read_raw(struct iio_dev *iio,
+			    struct iio_chan_spec const *channel, int *val,
+			    int *val2, long mask)
+{
+	struct mcp320x *adc = iio_priv(iio);
+	int ret = -EINVAL;
+
+	mutex_lock(&adc->lock);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		if (channel->differential)
+			ret = mcp320x_adc_conversion(adc,
+				MCP_START_BIT | channel->address);
+		else
+			ret = mcp320x_adc_conversion(adc,
+				MCP_START_BIT | MCP_SINGLE_ENDED |
+				channel->address);
+		if (ret < 0)
+			goto out;
+
+		*val = ret;
+		ret = IIO_VAL_INT;
+		break;
+
+	case IIO_CHAN_INFO_SCALE:
+		/* Digital output code = (4096 * Vin) / Vref */
+		if (!IS_ERR_OR_NULL(adc->reg)) {
+			ret = regulator_get_voltage(adc->reg);
+			if (ret < 0)
+				goto out;
+			*val = ret / 1000;
+		} else {
+			*val = adc->ref_mv;
+		}
+		*val2 = 4096 * 1000;
+		ret = IIO_VAL_FRACTIONAL;
+		break;
+
+	default:
+		break;
+	}
+
+out:
+	mutex_unlock(&adc->lock);
+
+	return ret;
+}
+
+#define MCP320X_VOLTAGE_CHANNEL(num)				\
+	{							\
+		.type = IIO_VOLTAGE,				\
+		.indexed = 1,					\
+		.channel = (num),				\
+		.address = (num),				\
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) \
+	}
+
+#define MCP320X_VOLTAGE_CHANNEL_DIFF(num)			\
+	{							\
+		.type = IIO_VOLTAGE,				\
+		.indexed = 1,					\
+		.channel = (num * 2),				\
+		.channel2 = (num * 2 + 1),			\
+		.address = (num * 2),				\
+		.differential = 1,				\
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) \
+	}
+
+static const struct iio_chan_spec mcp3204_channels[] = {
+	MCP320X_VOLTAGE_CHANNEL(0),
+	MCP320X_VOLTAGE_CHANNEL(1),
+	MCP320X_VOLTAGE_CHANNEL(2),
+	MCP320X_VOLTAGE_CHANNEL(3),
+	MCP320X_VOLTAGE_CHANNEL_DIFF(0),
+	MCP320X_VOLTAGE_CHANNEL_DIFF(1),
+};
+
+static const struct iio_chan_spec mcp3208_channels[] = {
+	MCP320X_VOLTAGE_CHANNEL(0),
+	MCP320X_VOLTAGE_CHANNEL(1),
+	MCP320X_VOLTAGE_CHANNEL(2),
+	MCP320X_VOLTAGE_CHANNEL(3),
+	MCP320X_VOLTAGE_CHANNEL(4),
+	MCP320X_VOLTAGE_CHANNEL(5),
+	MCP320X_VOLTAGE_CHANNEL(6),
+	MCP320X_VOLTAGE_CHANNEL(7),
+	MCP320X_VOLTAGE_CHANNEL_DIFF(0),
+	MCP320X_VOLTAGE_CHANNEL_DIFF(1),
+	MCP320X_VOLTAGE_CHANNEL_DIFF(2),
+	MCP320X_VOLTAGE_CHANNEL_DIFF(3),
+};
+
+static const struct iio_info mcp320x_info = {
+	.read_raw = mcp320x_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int mcp320x_probe(struct spi_device *spi)
+{
+	struct mcp320x_platform_data *pdata = spi->dev.platform_data;
+	struct iio_dev *iio;
+	struct mcp320x *adc;
+	int ret;
+
+	if (!pdata) {
+		dev_err(&spi->dev, "No platform data!");
+		return -EINVAL;
+	}
+
+	iio = iio_device_alloc(sizeof(*adc));
+	if (!iio)
+		return -ENOMEM;
+
+	adc = iio_priv(iio);
+	adc->spi = spi;
+
+	iio->dev.parent = &spi->dev;
+	iio->name = spi_get_device_id(spi)->name;
+	iio->modes = INDIO_DIRECT_MODE;
+	iio->info = &mcp320x_info;
+
+	if (spi_get_device_id(spi)->driver_data == mcp3204) {
+		iio->channels = mcp3204_channels;
+		iio->num_channels = ARRAY_SIZE(mcp3204_channels);
+	} else {
+		iio->channels = mcp3208_channels;
+		iio->num_channels = ARRAY_SIZE(mcp3208_channels);
+	}
+
+	adc->transfer[0].tx_buf = &adc->tx_buf;
+	adc->transfer[0].len = sizeof(adc->tx_buf);
+	adc->transfer[1].rx_buf = adc->rx_buf;
+	adc->transfer[1].len = sizeof(adc->rx_buf);
+
+	spi_message_init(&adc->msg);
+	spi_message_add_tail(&adc->transfer[0], &adc->msg);
+	spi_message_add_tail(&adc->transfer[1], &adc->msg);
+
+	if (pdata->reg) {
+		adc->reg = regulator_get(&spi->dev, pdata->reg);
+		if (IS_ERR_OR_NULL(adc->reg))
+			return PTR_ERR(adc->reg);
+
+		ret = regulator_enable(adc->reg);
+		if (ret < 0)
+			goto reg_free;
+	} else {
+		adc->ref_mv = pdata->ref_mv;
+	}
+
+	mutex_init(&adc->lock);
+
+	ret = iio_device_register(iio);
+	if (ret < 0)
+		goto iio_free;
+
+	return 0;
+
+iio_free:
+	iio_device_free(iio);
+reg_free:
+	if (!IS_ERR_OR_NULL(adc->reg))
+		regulator_put(adc->reg);
+
+	return ret;
+}
+
+static int mcp320x_remove(struct spi_device *spi)
+{
+	struct iio_dev *iio = spi_get_drvdata(spi);
+	struct mcp320x *adc = iio_priv(iio);
+
+	if (!IS_ERR_OR_NULL(adc->reg)) {
+		regulator_disable(adc->reg);
+		regulator_put(adc->reg);
+	}
+
+	iio_device_unregister(iio);
+	iio_device_free(iio);
+
+	return 0;
+}
+
+static const struct spi_device_id mcp320x_id[] = {
+	{ "mcp3204", mcp3204 },
+	{ "mcp3208", mcp3208 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, mcp320x_id);
+
+static struct spi_driver mcp320x_driver = {
+	.driver = {
+		.name = "mcp320x",
+		.owner = THIS_MODULE,
+	},
+	.probe = mcp320x_probe,
+	.remove = mcp320x_remove,
+	.id_table = mcp320x_id,
+};
+module_spi_driver(mcp320x_driver);
+
+MODULE_AUTHOR("Oskar Andero <oskar.andero@gmail.com>");
+MODULE_DESCRIPTION("Microchip Technology MCP3204/08");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/mcp320x.h b/include/linux/platform_data/mcp320x.h
new file mode 100644
index 0000000..02f341b
--- /dev/null
+++ b/include/linux/platform_data/mcp320x.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2013 Oskar Andero <oskar.andero@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef MCP320X_H__
+#define MCP320X_H__
+
+/**
+ * struct mcp320x_platform_data - Platform data for the MCP320X driver
+ * @reg: The name of the regulator used for the reference voltage.
+ * @ref_mv: Reference voltage to use if no regulator has been given.
+ */
+struct mcp320x_platform_data {
+	const char const *reg;
+	unsigned int ref_mv;
+};
+
+#endif
+
-- 
1.8.1.5

