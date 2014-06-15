Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaFOVSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 17:18:12 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39358 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaFOVSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 17:18:08 -0400
From: Michael Welling <mwelling@ieee.org>
To: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michael Welling <mwelling@ieee.org>
Subject: [PATCH v5] iio: dac: mcp4902/mcp4912/mcp4922 dac driver
Date: Sun, 15 Jun 2014 16:17:58 -0500
Message-Id: <1402867078-32416-1-git-send-email-mwelling@ieee.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <5392ECF2.9020103@kernel.org>
References: <5392ECF2.9020103@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides an iio device driver for the Microchip
MCP49x2 series DACs.

v5:
- Removes wildcard naming in filename and variables.
- Switches to using iio_device_register/unregister to avoid race condition.
- Removes --- around help in the Kconfig entry.
- Removes unused variable.
- Adds checking for val2 in write_raw function.

v4:
- Removes use of old IIO_ST macro.
- Moves mosi variable to the state struct.
- Removes default vref of 2.5v.

v3:
- Removes MCP49X2_RES_MASK and uses GENMASK directly.
- Switch from using address to channel in functions.

v2:
- Switched to using GENMASK instead of creating a mask directly.
- Switched from using address to channel.
- Removed unnecessary feilds from channel macro.
- Made SPI buffer cachline aligned.
- Removed some uncessary bounds checking.
- Report -EINVAL when writing a value beyond the range to DAC.
- Switched to devm_iio_device_alloc.
- Created a constant for the number of channels.
- Switched to devm_ioo_device_register.

Signed-off-by: Michael Welling <mwelling@ieee.org>
---
 drivers/iio/dac/Kconfig   |   10 +++
 drivers/iio/dac/Makefile  |    1 +
 drivers/iio/dac/mcp4922.c |  216 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+)
 create mode 100644 drivers/iio/dac/mcp4922.c

diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
index f378ca8..f278eff 100644
--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -163,4 +163,14 @@ config MCP4725
 	  To compile this driver as a module, choose M here: the module
 	  will be called mcp4725.
 
+config MCP4922
+	tristate "MCP4902, MCP4912, MCP4922 DAC driver"
+	depends on SPI
+	help
+	  Say yes here to build the driver for the Microchip MCP4902
+	  MCP4912, and MCP4922 DAC devices.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called mcp4922.
+
 endmenu
diff --git a/drivers/iio/dac/Makefile b/drivers/iio/dac/Makefile
index bb84ad6..1010764 100644
--- a/drivers/iio/dac/Makefile
+++ b/drivers/iio/dac/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_AD5686) += ad5686.o
 obj-$(CONFIG_AD7303) += ad7303.o
 obj-$(CONFIG_MAX517) += max517.o
 obj-$(CONFIG_MCP4725) += mcp4725.o
+obj-$(CONFIG_MCP4922) += mcp4922.o
diff --git a/drivers/iio/dac/mcp4922.c b/drivers/iio/dac/mcp4922.c
new file mode 100644
index 0000000..92cf4ca
--- /dev/null
+++ b/drivers/iio/dac/mcp4922.c
@@ -0,0 +1,216 @@
+/*
+ * mcp4922.c
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
+#include <linux/bitops.h>
+
+#define MCP4922_NUM_CHANNELS	2
+
+enum mcp4922_supported_device_ids {
+	ID_MCP4902,
+	ID_MCP4912,
+	ID_MCP4922,
+};
+
+struct mcp4922_state {
+	struct spi_device *spi;
+	unsigned int value[MCP4922_NUM_CHANNELS];
+	unsigned int vref_mv;
+	struct regulator *vref_reg;
+	u8 mosi[2] ____cacheline_aligned;
+};
+
+#define MCP4922_CHAN(chan, bits) {			\
+	.type = IIO_VOLTAGE,				\
+	.output = 1,					\
+	.indexed = 1,					\
+	.channel = chan,				\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
+	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
+	.scan_type = {					\
+		.sign = 'u',				\
+		.realbits = (bits),			\
+		.storagebits = 16,			\
+		.shift = 12 - (bits),			\
+	},						\
+}
+
+static int mcp4922_spi_write(struct mcp4922_state *state, u8 addr, u32 val)
+{
+	state->mosi[1] = val & 0xff;
+	state->mosi[0] = (addr == 0) ? 0x00 : 0x80;
+	state->mosi[0] |= 0x30 | ((val >> 8) & 0x0f);
+
+	return spi_write(state->spi, state->mosi, 2);
+}
+
+static int mcp4922_read_raw(struct iio_dev *indio_dev,
+		struct iio_chan_spec const *chan,
+		int *val,
+		int *val2,
+		long mask)
+{
+	struct mcp4922_state *state = iio_priv(indio_dev);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		*val = state->value[chan->channel];
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
+static int mcp4922_write_raw(struct iio_dev *indio_dev,
+		struct iio_chan_spec const *chan,
+		int val,
+		int val2,
+		long mask)
+{
+	struct mcp4922_state *state = iio_priv(indio_dev);
+
+	if (val2 != 0)
+		return -EINVAL;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		if (val > GENMASK(chan->scan_type.realbits-1, 0))
+			return -EINVAL;
+		val <<= chan->scan_type.shift;
+		state->value[chan->channel] = val;
+		return mcp4922_spi_write(state, chan->channel, val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct iio_chan_spec mcp4922_channels[3][MCP4922_NUM_CHANNELS] = {
+	[ID_MCP4902] = { MCP4922_CHAN(0, 8),	MCP4922_CHAN(1, 8) },
+	[ID_MCP4912] = { MCP4922_CHAN(0, 10),	MCP4922_CHAN(1, 10) },
+	[ID_MCP4922] = { MCP4922_CHAN(0, 12),	MCP4922_CHAN(1, 12) },
+};
+
+static const struct iio_info mcp4922_info = {
+	.read_raw = &mcp4922_read_raw,
+	.write_raw = &mcp4922_write_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int mcp4922_probe(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev;
+	struct mcp4922_state *state;
+	const struct spi_device_id *id;
+	int ret;
+
+	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*state));
+	if (indio_dev == NULL)
+		return -ENOMEM;
+
+	state = iio_priv(indio_dev);
+	state->spi = spi;
+	state->vref_reg = devm_regulator_get(&spi->dev, "vref");
+	if (IS_ERR(state->vref_reg)) {
+		dev_err(&spi->dev, "Vref regulator not specified\n");
+		return PTR_ERR(state->vref_reg);
+	}
+
+	ret = regulator_enable(state->vref_reg);
+	if (ret) {
+		dev_err(&spi->dev, "Failed to enable vref regulator: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = regulator_get_voltage(state->vref_reg);
+	if (ret < 0) {
+		dev_err(&spi->dev, "Failed to read vref regulator: %d\n",
+				ret);
+		goto error_disable_reg;
+	}
+	state->vref_mv = ret / 1000;
+
+	spi_set_drvdata(spi, indio_dev);
+	id = spi_get_device_id(spi);
+	indio_dev->dev.parent = &spi->dev;
+	indio_dev->info = &mcp4922_info;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->channels = mcp4922_channels[id->driver_data];
+	indio_dev->num_channels = MCP4922_NUM_CHANNELS;
+	indio_dev->name = id->name;
+
+	ret = iio_device_register(indio_dev);
+	if (ret) {
+		dev_err(&spi->dev, "Failed to register iio device: %d\n",
+				ret);
+		goto error_disable_reg;
+	}
+
+	return 0;
+
+error_disable_reg:
+	regulator_disable(state->vref_reg);
+
+	return ret;
+}
+
+static int mcp4922_remove(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+	struct mcp4922_state *state;
+
+	iio_device_unregister(indio_dev);
+	state = iio_priv(indio_dev);
+	regulator_disable(state->vref_reg);
+
+	return 0;
+}
+
+static const struct spi_device_id mcp4922_id[] = {
+	{"mcp4902", ID_MCP4902},
+	{"mcp4912", ID_MCP4912},
+	{"mcp4922", ID_MCP4922},
+	{}
+};
+MODULE_DEVICE_TABLE(spi, mcp4922_id);
+
+static struct spi_driver mcp4922_driver = {
+	.driver = {
+		   .name = "mcp4922",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = mcp4922_probe,
+	.remove = mcp4922_remove,
+	.id_table = mcp4922_id,
+};
+module_spi_driver(mcp4922_driver);
+
+MODULE_AUTHOR("Michael Welling <mwelling@ieee.org>");
+MODULE_DESCRIPTION("Microchip MCP4902, MCP4912, MCP4922 DAC");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

