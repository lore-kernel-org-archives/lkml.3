Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaFDHVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:21:46 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54090 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaFDHVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:21:44 -0400
From: Michael Welling <mwelling@ieee.org>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michael Welling <mwelling@ieee.org>
Subject: [PATCH] iio: dac: mcp4902/mcp4912/mcp4922 dac driver
Date: Wed,  4 Jun 2014 02:21:19 -0500
Message-Id: <1401866479-8085-1-git-send-email-mwelling@ieee.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides an iio device driver for the Microchip
MCP49x2 series DACs.

Signed-off-by: Michael Welling <mwelling@ieee.org>
---
 drivers/iio/dac/Kconfig   |   10 +++
 drivers/iio/dac/Makefile  |    1 +
 drivers/iio/dac/mcp49x2.c |  215 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 226 insertions(+)
 create mode 100644 drivers/iio/dac/mcp49x2.c

diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
index f378ca8..032d678 100644
--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -163,4 +163,14 @@ config MCP4725
 	  To compile this driver as a module, choose M here: the module
 	  will be called mcp4725.
 
+config MCP49X2
+	tristate "MCP4902, MCP4912, MCP4922 DAC driver"
+	depends on SPI
+	---help---
+	  Say yes here to build the driver for the Microchip MCP49x2
+	  series DAC devices.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called mcp49x2.
+
 endmenu
diff --git a/drivers/iio/dac/Makefile b/drivers/iio/dac/Makefile
index bb84ad6..2fdfc2e 100644
--- a/drivers/iio/dac/Makefile
+++ b/drivers/iio/dac/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_AD5686) += ad5686.o
 obj-$(CONFIG_AD7303) += ad7303.o
 obj-$(CONFIG_MAX517) += max517.o
 obj-$(CONFIG_MCP4725) += mcp4725.o
+obj-$(CONFIG_MCP49X2) += mcp49x2.o
diff --git a/drivers/iio/dac/mcp49x2.c b/drivers/iio/dac/mcp49x2.c
new file mode 100644
index 0000000..0375046
--- /dev/null
+++ b/drivers/iio/dac/mcp49x2.c
@@ -0,0 +1,215 @@
+/*
+ * mcp49x2.c
+ *
+ * Driver for Microchip Digital to Analog Converters.
+ * Supports MCP4902, MCP4912, and MCP4922.
+ *
+ * Copyright (c) 2014 EMAC Inc.
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
+#include <linux/spi/spi.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#include <linux/regulator/consumer.h>
+
+#define	MCP49X2_RES_MASK(x)		((1 << (x)) - 1)
+
+enum mcp49x2_supported_device_ids {
+	ID_MCP4902,
+	ID_MCP4912,
+	ID_MCP4922,
+};
+
+struct mcp49x2_state {
+	struct spi_device *spi;
+	unsigned int value[2];
+	unsigned int power_mode[2];
+	unsigned int vref_mv;
+	struct regulator *vref_reg;
+};
+
+#define MCP49X2_CHAN(chan, bits) {			\
+	.type = IIO_VOLTAGE,				\
+	.output = 1,					\
+	.indexed = 1,					\
+	.channel = chan,				\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
+	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
+	.address = chan,				\
+	.scan_type = IIO_ST('u', bits, 16, 12-(bits)),	\
+	.ext_info = NULL,				\
+}
+
+static int mcp49x2_spi_write(struct spi_device *spi, u8 addr, u32 val)
+{
+	u8 mosi[2];
+
+	mosi[1] = val & 0xff;
+	mosi[0] = (addr == 0) ? 0x00 : 0x80;
+	mosi[0] |= 0x30 | ((val >> 8) & 0x0f);
+
+	return spi_write(spi, mosi, 2);
+}
+
+static int mcp49x2_read_raw(struct iio_dev *indio_dev,
+		struct iio_chan_spec const *chan,
+		int *val,
+		int *val2,
+		long mask)
+{
+	struct mcp49x2_state *state = iio_priv(indio_dev);
+
+	if (chan->address >= 2)
+		return -EINVAL;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		*val = state->value[chan->address];
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		*val = state->vref_mv;
+		*val2 = chan->scan_type.realbits;
+		return IIO_VAL_FRACTIONAL_LOG2;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int mcp49x2_write_raw(struct iio_dev *indio_dev,
+		struct iio_chan_spec const *chan,
+		int val,
+		int val2,
+		long mask)
+{
+	struct mcp49x2_state *state = iio_priv(indio_dev);
+
+	if (chan->address >= 2)
+		return -EINVAL;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		val &= MCP49X2_RES_MASK(chan->scan_type.realbits);
+		val <<= chan->scan_type.shift;
+		state->value[chan->address] = val;
+		return mcp49x2_spi_write(state->spi, chan->address, val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct iio_chan_spec mcp49x2_channels[3][2] = {
+	[ID_MCP4902] = { MCP49X2_CHAN(0, 8),	MCP49X2_CHAN(1, 8) },
+	[ID_MCP4912] = { MCP49X2_CHAN(0, 10),	MCP49X2_CHAN(1, 10) },
+	[ID_MCP4922] = { MCP49X2_CHAN(0, 12),	MCP49X2_CHAN(1, 12) },
+};
+
+static const struct iio_info mcp49x2_info = {
+	.read_raw = &mcp49x2_read_raw,
+	.write_raw = &mcp49x2_write_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int mcp49x2_probe(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev;
+	struct mcp49x2_state *state;
+	const struct spi_device_id *id;
+	int ret;
+
+	indio_dev = iio_device_alloc(sizeof(*state));
+	if (indio_dev == NULL)
+		return -ENOMEM;
+
+	state = iio_priv(indio_dev);
+	state->spi = spi;
+
+	state->vref_reg = devm_regulator_get(spi->dev, "vref");
+	if (!IS_ERR(state->vref_reg)) {
+		ret = regulator_enable(state->vref_reg);
+		if (ret) {
+			dev_err(dev, "Failed to enable vref regulator: %d\n",
+				ret);
+			goto error_free;
+		}
+
+		ret = regulator_get_voltage(state->vref_reg);
+		if (ret < 0)
+			goto error_disable_reg;
+
+		state->vref_mv = ret / 1000;
+	} else {
+		dev_info(dev, "Vref regulator not specified assuming 2.5V\n");
+		state->vref_mv = 2500;
+	}
+
+	spi_set_drvdata(spi, indio_dev);
+	id = spi_get_device_id(spi);
+	indio_dev->dev.parent = &spi->dev;
+	indio_dev->info = &mcp49x2_info;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->channels = mcp49x2_channels[id->driver_data];
+	indio_dev->num_channels = 2;
+	indio_dev->name = id->name;
+
+	ret = iio_device_register(indio_dev);
+
+	if (ret) {
+		dev_err(dev, "Failed to register iio device: %d\n",
+			ret);
+		goto error_disable_reg;
+	}
+
+	return 0;
+
+error_disable_reg:
+	if (!IS_ERR(state->vref_reg))
+		regulator_disable(state->vref_reg);
+error_free:
+	iio_device_free(indio_dev);
+
+	return ret;
+}
+
+static int mcp49x2_remove(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+
+	iio_device_free(indio_dev);
+	return 0;
+}
+
+static const struct spi_device_id mcp49x2_id[] = {
+	{"mcp4902", ID_MCP4902},
+	{"mcp4912", ID_MCP4912},
+	{"mcp4922", ID_MCP4922},
+	{}
+};
+MODULE_DEVICE_TABLE(spi, mcp49x2_id);
+
+static struct spi_driver mcp49x2_driver = {
+	.driver = {
+		   .name = "mcp49x2",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = mcp49x2_probe,
+	.remove = mcp49x2_remove,
+	.id_table = mcp49x2_id,
+};
+module_spi_driver(mcp49x2_driver);
+
+MODULE_AUTHOR("Michael Welling <mwelling@ieee.org>");
+MODULE_DESCRIPTION("Microchip MCP4902, MCP4912, MCP4922 DAC");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

