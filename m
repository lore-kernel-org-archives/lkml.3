Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaGJVNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:13:08 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45919 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaGJVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:13:05 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <2997c5e4-07c2-4850-9002-3c1b12ed4daf@email.android.com>
References: <1405012653.8161.26.camel@sanws1.rosetechnology.dk> <2997c5e4-07c2-4850-9002-3c1b12ed4daf@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] iio: adc: Add Support for more MCP ADCs
From: Jonathan Cameron <jic23@kernel.org>
Date: Thu, 10 Jul 2014 22:12:54 +0100
To: =?ISO-8859-1?Q?S=F8ren_Andersen?= <san@rosetechnology.dk>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <29dcda77-3ded-420a-b607-5e3f68d58a11@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On July 10, 2014 9:53:15 PM GMT+01:00, Jonathan Cameron <jic23@kernel.org> wrote:
>
>
>On July 10, 2014 6:17:33 PM GMT+01:00, "Søren Andersen"
><san@rosetechnology.dk> wrote:
>>Support for booth 10 and 12 Bits spi Microchip ADCs from 1 to 8
>>channels CHIPS
>>The original driver only have support for 4 and 8 channels
>>Add device tree support too. 
>> 
>>Signed-off-by: Soeren Andersen <san at rosetechnology.dk>
>Hi Soeren
>
>As a quick initial comment please do not rename an existing driver. The
>name does
> not need to reflect all the parts supported.
>Ideally it would not have had a wild card in the first place but its
>too late now.
>Note in particular that the config symbol rename will brake any
>existing users kernel builds.
>
>Renaming the files is also an unnecessary change.  
>
>Is this a complete rewrite or an adaption of the existing driver?
Ideally this probably wants to be split into a number of patches.
1. Redactor the code as necessary to be able to add additional devices
2. Add additional devices
3. Add device tree support.

Each step is then easier to review and any effects on existing device support will be much easier to identify. 

Thanks

J
>
>Jonathan
>>---
>> Documentation/devicetree/bindings/iio/adc/mcp3x0x.txt |  29
>++++++++++
>> drivers/iio/adc/Kconfig                               |   9 ++--
>> drivers/iio/adc/Makefile                              |   2 +-
>>drivers/iio/adc/mcp320x.c                             | 249
>>--------------------------------------------------------------------------------------
>>drivers/iio/adc/mcp3x0x.c                             | 431
>>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>> 5 files changed, 466 insertions(+), 254 deletions(-)
>>
>>diff --git a/Documentation/devicetree/bindings/iio/adc/mcp3x0x.txt
>>b/Documentation/devicetree/bindings/iio/adc/mcp3x0x.txt
>>new file mode 100644
>>index 0000000..56f06d0
>>--- /dev/null
>>+++ b/Documentation/devicetree/bindings/iio/adc/mcp3x0x.txt
>>@@ -0,0 +1,29 @@
>>+* Microchip Analog to Digital Converter (ADC)
>>+
>>+The node for this driver must be a child node of a SPI controller,
>>hence
>>+all mandatory properties described in
>>+
>>+        Documentation/devicetree/bindings/spi/spi-bus.txt
>>+
>>+must be specified.
>>+
>>+Required properties:
>>+		- compatible:  	Must be one of the following, depending on the
>>+			model:
>>+				"mcp3001"
>>+				"mcp3002"
>>+				"mcp3004"
>>+				"mcp3008"
>>+				"mcp3201"
>>+				"mcp3202"
>>+				"mcp3204"
>>+				"mcp3208"
>>+
>>+
>>+Examples:
>>+spi_controller {
>>+	mcp3x0x@0 {
>>+		compatible = "mcp3002";
>>+		reg = <0>;
>>+		spi-max-frequency = <1000000>;
>>+	};
>>diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>>index a80d236..8b3d3c7 100644
>>--- a/drivers/iio/adc/Kconfig
>>+++ b/drivers/iio/adc/Kconfig
>>@@ -147,15 +147,16 @@ config MAX1363
>> 	  max11646, max11647) Provides direct access via sysfs and buffered
>> 	  data via the iio dev interface.
>> 
>>-config MCP320X
>>-	tristate "Microchip Technology MCP3204/08"
>>+config MCP3X0X
>>+	tristate "Microchip Technology MCP3x01/02/04/08"
>> 	depends on SPI
>> 	help
>>-	  Say yes here to build support for Microchip Technology's MCP3204
>or
>>+	  Say yes here to build support for Microchip Technology's
>>+	  MCP3001, MCP3002, MCP3004, MCP3008, MCP3201, MCP3202, MCP3204 or
>> 	  MCP3208 analog to digital converter.
>> 
>>	  This driver can also be built as a module. If so, the module will
>be
>>-	  called mcp320x.
>>+	  called mcp3x0x.
>> 
>> config MCP3422
>> 	tristate "Microchip Technology MCP3422/3/4/6/7/8 driver"
>>diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
>>index 9d60f2d..f25bd54 100644
>>--- a/drivers/iio/adc/Makefile
>>+++ b/drivers/iio/adc/Makefile
>>@@ -16,7 +16,7 @@ obj-$(CONFIG_AT91_ADC) += at91_adc.o
>> obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
>> obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>> obj-$(CONFIG_MAX1363) += max1363.o
>>-obj-$(CONFIG_MCP320X) += mcp320x.o
>>+obj-$(CONFIG_MCP3X0X) += mcp3x0x.o
>> obj-$(CONFIG_MCP3422) += mcp3422.o
>> obj-$(CONFIG_MEN_Z188_ADC) += men_z188_adc.o
>> obj-$(CONFIG_NAU7802) += nau7802.o
>>diff --git a/drivers/iio/adc/mcp320x.c b/drivers/iio/adc/mcp320x.c
>>deleted file mode 100644
>>index 28a086e..0000000
>>--- a/drivers/iio/adc/mcp320x.c
>>+++ /dev/null
>>@@ -1,249 +0,0 @@
>>-/*
>>- * Copyright (C) 2013 Oskar Andero <oskar.andero@gmail.com>
>>- *
>>- * Driver for Microchip Technology's MCP3204 and MCP3208 ADC chips.
>>- * Datasheet can be found here:
>>- * http://ww1.microchip.com/downloads/en/devicedoc/21298c.pdf
>>- *
>>- * This program is free software; you can redistribute it and/or
>>modify
>>- * it under the terms of the GNU General Public License version 2 as
>>- * published by the Free Software Foundation.
>>- */
>>-
>>-#include <linux/err.h>
>>-#include <linux/spi/spi.h>
>>-#include <linux/module.h>
>>-#include <linux/iio/iio.h>
>>-#include <linux/regulator/consumer.h>
>>-
>>-#define MCP_SINGLE_ENDED	(1 << 3)
>>-#define MCP_START_BIT		(1 << 4)
>>-
>>-enum {
>>-	mcp3204,
>>-	mcp3208,
>>-};
>>-
>>-struct mcp320x {
>>-	struct spi_device *spi;
>>-	struct spi_message msg;
>>-	struct spi_transfer transfer[2];
>>-
>>-	u8 tx_buf;
>>-	u8 rx_buf[2];
>>-
>>-	struct regulator *reg;
>>-	struct mutex lock;
>>-};
>>-
>>-static int mcp320x_adc_conversion(struct mcp320x *adc, u8 msg)
>>-{
>>-	int ret;
>>-
>>-	adc->tx_buf = msg;
>>-	ret = spi_sync(adc->spi, &adc->msg);
>>-	if (ret < 0)
>>-		return ret;
>>-
>>-	return ((adc->rx_buf[0] & 0x3f) << 6)  |
>>-		(adc->rx_buf[1] >> 2);
>>-}
>>-
>>-static int mcp320x_read_raw(struct iio_dev *indio_dev,
>>-			    struct iio_chan_spec const *channel, int *val,
>>-			    int *val2, long mask)
>>-{
>>-	struct mcp320x *adc = iio_priv(indio_dev);
>>-	int ret = -EINVAL;
>>-
>>-	mutex_lock(&adc->lock);
>>-
>>-	switch (mask) {
>>-	case IIO_CHAN_INFO_RAW:
>>-		if (channel->differential)
>>-			ret = mcp320x_adc_conversion(adc,
>>-				MCP_START_BIT | channel->address);
>>-		else
>>-			ret = mcp320x_adc_conversion(adc,
>>-				MCP_START_BIT | MCP_SINGLE_ENDED |
>>-				channel->address);
>>-		if (ret < 0)
>>-			goto out;
>>-
>>-		*val = ret;
>>-		ret = IIO_VAL_INT;
>>-		break;
>>-
>>-	case IIO_CHAN_INFO_SCALE:
>>-		/* Digital output code = (4096 * Vin) / Vref */
>>-		ret = regulator_get_voltage(adc->reg);
>>-		if (ret < 0)
>>-			goto out;
>>-
>>-		*val = ret / 1000;
>>-		*val2 = 12;
>>-		ret = IIO_VAL_FRACTIONAL_LOG2;
>>-		break;
>>-
>>-	default:
>>-		break;
>>-	}
>>-
>>-out:
>>-	mutex_unlock(&adc->lock);
>>-
>>-	return ret;
>>-}
>>-
>>-#define MCP320X_VOLTAGE_CHANNEL(num)				\
>>-	{							\
>>-		.type = IIO_VOLTAGE,				\
>>-		.indexed = 1,					\
>>-		.channel = (num),				\
>>-		.address = (num),				\
>>-		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
>>-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) \
>>-	}
>>-
>>-#define MCP320X_VOLTAGE_CHANNEL_DIFF(num)			\
>>-	{							\
>>-		.type = IIO_VOLTAGE,				\
>>-		.indexed = 1,					\
>>-		.channel = (num * 2),				\
>>-		.channel2 = (num * 2 + 1),			\
>>-		.address = (num * 2),				\
>>-		.differential = 1,				\
>>-		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
>>-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) \
>>-	}
>>-
>>-static const struct iio_chan_spec mcp3204_channels[] = {
>>-	MCP320X_VOLTAGE_CHANNEL(0),
>>-	MCP320X_VOLTAGE_CHANNEL(1),
>>-	MCP320X_VOLTAGE_CHANNEL(2),
>>-	MCP320X_VOLTAGE_CHANNEL(3),
>>-	MCP320X_VOLTAGE_CHANNEL_DIFF(0),
>>-	MCP320X_VOLTAGE_CHANNEL_DIFF(1),
>>-};
>>-
>>-static const struct iio_chan_spec mcp3208_channels[] = {
>>-	MCP320X_VOLTAGE_CHANNEL(0),
>>-	MCP320X_VOLTAGE_CHANNEL(1),
>>-	MCP320X_VOLTAGE_CHANNEL(2),
>>-	MCP320X_VOLTAGE_CHANNEL(3),
>>-	MCP320X_VOLTAGE_CHANNEL(4),
>>-	MCP320X_VOLTAGE_CHANNEL(5),
>>-	MCP320X_VOLTAGE_CHANNEL(6),
>>-	MCP320X_VOLTAGE_CHANNEL(7),
>>-	MCP320X_VOLTAGE_CHANNEL_DIFF(0),
>>-	MCP320X_VOLTAGE_CHANNEL_DIFF(1),
>>-	MCP320X_VOLTAGE_CHANNEL_DIFF(2),
>>-	MCP320X_VOLTAGE_CHANNEL_DIFF(3),
>>-};
>>-
>>-static const struct iio_info mcp320x_info = {
>>-	.read_raw = mcp320x_read_raw,
>>-	.driver_module = THIS_MODULE,
>>-};
>>-
>>-struct mcp3208_chip_info {
>>-	const struct iio_chan_spec *channels;
>>-	unsigned int num_channels;
>>-};
>>-
>>-static const struct mcp3208_chip_info mcp3208_chip_infos[] = {
>>-	[mcp3204] = {
>>-		.channels = mcp3204_channels,
>>-		.num_channels = ARRAY_SIZE(mcp3204_channels)
>>-	},
>>-	[mcp3208] = {
>>-		.channels = mcp3208_channels,
>>-		.num_channels = ARRAY_SIZE(mcp3208_channels)
>>-	},
>>-};
>>-
>>-static int mcp320x_probe(struct spi_device *spi)
>>-{
>>-	struct iio_dev *indio_dev;
>>-	struct mcp320x *adc;
>>-	const struct mcp3208_chip_info *chip_info;
>>-	int ret;
>>-
>>-	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*adc));
>>-	if (!indio_dev)
>>-		return -ENOMEM;
>>-
>>-	adc = iio_priv(indio_dev);
>>-	adc->spi = spi;
>>-
>>-	indio_dev->dev.parent = &spi->dev;
>>-	indio_dev->name = spi_get_device_id(spi)->name;
>>-	indio_dev->modes = INDIO_DIRECT_MODE;
>>-	indio_dev->info = &mcp320x_info;
>>-
>>-	chip_info =
>&mcp3208_chip_infos[spi_get_device_id(spi)->driver_data];
>>-	indio_dev->channels = chip_info->channels;
>>-	indio_dev->num_channels = chip_info->num_channels;
>>-
>>-	adc->transfer[0].tx_buf = &adc->tx_buf;
>>-	adc->transfer[0].len = sizeof(adc->tx_buf);
>>-	adc->transfer[1].rx_buf = adc->rx_buf;
>>-	adc->transfer[1].len = sizeof(adc->rx_buf);
>>-
>>-	spi_message_init_with_transfers(&adc->msg, adc->transfer,
>>-					ARRAY_SIZE(adc->transfer));
>>-
>>-	adc->reg = devm_regulator_get(&spi->dev, "vref");
>>-	if (IS_ERR(adc->reg))
>>-		return PTR_ERR(adc->reg);
>>-
>>-	ret = regulator_enable(adc->reg);
>>-	if (ret < 0)
>>-		return ret;
>>-
>>-	mutex_init(&adc->lock);
>>-
>>-	ret = iio_device_register(indio_dev);
>>-	if (ret < 0)
>>-		goto reg_disable;
>>-
>>-	return 0;
>>-
>>-reg_disable:
>>-	regulator_disable(adc->reg);
>>-
>>-	return ret;
>>-}
>>-
>>-static int mcp320x_remove(struct spi_device *spi)
>>-{
>>-	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>>-	struct mcp320x *adc = iio_priv(indio_dev);
>>-
>>-	iio_device_unregister(indio_dev);
>>-	regulator_disable(adc->reg);
>>-
>>-	return 0;
>>-}
>>-
>>-static const struct spi_device_id mcp320x_id[] = {
>>-	{ "mcp3204", mcp3204 },
>>-	{ "mcp3208", mcp3208 },
>>-	{ }
>>-};
>>-MODULE_DEVICE_TABLE(spi, mcp320x_id);
>>-
>>-static struct spi_driver mcp320x_driver = {
>>-	.driver = {
>>-		.name = "mcp320x",
>>-		.owner = THIS_MODULE,
>>-	},
>>-	.probe = mcp320x_probe,
>>-	.remove = mcp320x_remove,
>>-	.id_table = mcp320x_id,
>>-};
>>-module_spi_driver(mcp320x_driver);
>>-
>>-MODULE_AUTHOR("Oskar Andero <oskar.andero@gmail.com>");
>>-MODULE_DESCRIPTION("Microchip Technology MCP3204/08");
>>-MODULE_LICENSE("GPL v2");
>>diff --git a/drivers/iio/adc/mcp3x0x.c b/drivers/iio/adc/mcp3x0x.c
>>new file mode 100644
>>index 0000000..f431e5c
>>--- /dev/null
>>+++ b/drivers/iio/adc/mcp3x0x.c
>>@@ -0,0 +1,431 @@
>>+/*
>>+ * Copyright (C) 2013 Oskar Andero <oskar.andero@gmail.com>
>>+ * Copyright (C) 2014 Allan Bendorff Jensen <abj@rosetechnology.dk>
>>+ *
>>+ * Driver for following ADC chips from Microchip Technology's:
>>+ * 10 Bit converter
>>+ * MCP3001
>>+ * MCP3002
>>+ * MCP3004
>>+ * MCP3008
>>+ * ------------
>>+ * 12 bit converter
>>+ * MCP3201
>>+ * MCP3202
>>+ * MCP3204
>>+ * MCP3208
>>+ * ------------
>>+ * Datasheet can be found here:
>>+ * http://www.microchip.com/
>>+ *
>>+ * This program is free software; you can redistribute it and/or
>>modify
>>+ * it under the terms of the GNU General Public License version 2 as
>>+ * published by the Free Software Foundation.
>>+ */
>>+
>>+#include <linux/err.h>
>>+#include <linux/spi/spi.h>
>>+#include <linux/module.h>
>>+#include <linux/iio/iio.h>
>>+#include <linux/regulator/consumer.h>
>>+
>>+static int mcp3x0x_read_raw(struct iio_dev *indio_dev,
>>+			struct iio_chan_spec const *channel, int *val,
>>+			int *val2, long mask);
>>+
>>+enum {
>>+	mcp3001,
>>+	mcp3002,
>>+	mcp3004,
>>+	mcp3008,
>>+	mcp3201,
>>+	mcp3202,
>>+	mcp3204,
>>+	mcp3208,
>>+};
>>+
>>+struct mcp3x0x {
>>+	struct spi_device *spi;
>>+	struct spi_message msg;
>>+	struct spi_transfer transfer[2];
>>+
>>+	u8 tx_buf;
>>+	u8 rx_buf[2];
>>+
>>+	struct regulator *reg;
>>+	struct mutex lock;
>>+};
>>+
>>+#define MCP3X0X_VOLTAGE_CHANNEL(num)					\
>>+	{								\
>>+		.type = IIO_VOLTAGE,					\
>>+		.indexed = 1,						\
>>+		.channel = (num),					\
>>+		.address = (num),					\
>>+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
>>+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE)	\
>>+	}
>>+
>>+#define MCP3X0X_VOLTAGE_CHANNEL_DIFF(num)				\
>>+	{								\
>>+		.type = IIO_VOLTAGE,					\
>>+		.indexed = 1,						\
>>+		.channel = (num * 2),					\
>>+		.channel2 = (num * 2 + 1),				\
>>+		.address = (num * 2),					\
>>+		.differential = 1,					\
>>+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
>>+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE)	\
>>+	}
>>+
>>+static const struct iio_chan_spec mcp3x01_channels[] = {
>>+	MCP3X0X_VOLTAGE_CHANNEL_DIFF(0),
>>+};
>>+
>>+static const struct iio_chan_spec mcp3x02_channels[] = {
>>+	MCP3X0X_VOLTAGE_CHANNEL(0),
>>+	MCP3X0X_VOLTAGE_CHANNEL(1),
>>+	MCP3X0X_VOLTAGE_CHANNEL_DIFF(0),
>>+};
>>+
>>+static const struct iio_chan_spec mcp3x04_channels[] = {
>>+	MCP3X0X_VOLTAGE_CHANNEL(0),
>>+	MCP3X0X_VOLTAGE_CHANNEL(1),
>>+	MCP3X0X_VOLTAGE_CHANNEL(2),
>>+	MCP3X0X_VOLTAGE_CHANNEL(3),
>>+	MCP3X0X_VOLTAGE_CHANNEL_DIFF(0),
>>+	MCP3X0X_VOLTAGE_CHANNEL_DIFF(1),
>>+};
>>+
>>+static const struct iio_chan_spec mcp3x08_channels[] = {
>>+	MCP3X0X_VOLTAGE_CHANNEL(0),
>>+	MCP3X0X_VOLTAGE_CHANNEL(1),
>>+	MCP3X0X_VOLTAGE_CHANNEL(2),
>>+	MCP3X0X_VOLTAGE_CHANNEL(3),
>>+	MCP3X0X_VOLTAGE_CHANNEL(4),
>>+	MCP3X0X_VOLTAGE_CHANNEL(5),
>>+	MCP3X0X_VOLTAGE_CHANNEL(6),
>>+	MCP3X0X_VOLTAGE_CHANNEL(7),
>>+	MCP3X0X_VOLTAGE_CHANNEL_DIFF(0),
>>+	MCP3X0X_VOLTAGE_CHANNEL_DIFF(1),
>>+	MCP3X0X_VOLTAGE_CHANNEL_DIFF(2),
>>+	MCP3X0X_VOLTAGE_CHANNEL_DIFF(3),
>>+};
>>+
>>+static const struct iio_info mcp3x0x_info = {
>>+	.read_raw = mcp3x0x_read_raw,
>>+	.driver_module = THIS_MODULE,
>>+};
>>+
>>+struct mcp3X0X_chip_info {
>>+	const struct iio_chan_spec *channels;
>>+	unsigned int num_channels;
>>+	unsigned int resolution;
>>+};
>>+
>>+static const struct mcp3X0X_chip_info mcp3X0X_chip_infos[] = {
>>+	[mcp3001] = {
>>+		.channels = mcp3x01_channels,
>>+		.num_channels = ARRAY_SIZE(mcp3x01_channels)
>>+	},
>>+	[mcp3002] = {
>>+		.channels = mcp3x02_channels,
>>+		.num_channels = ARRAY_SIZE(mcp3x02_channels)
>>+	},
>>+	[mcp3004] = {
>>+		.channels = mcp3x04_channels,
>>+		.num_channels = ARRAY_SIZE(mcp3x04_channels)
>>+	},
>>+	[mcp3008] = {
>>+		.channels = mcp3x08_channels,
>>+		.num_channels = ARRAY_SIZE(mcp3x08_channels)
>>+	},
>>+	[mcp3201] = {
>>+		.channels = mcp3x01_channels,
>>+		.num_channels = ARRAY_SIZE(mcp3x01_channels)
>>+	},
>>+	[mcp3202] = {
>>+		.channels = mcp3x02_channels,
>>+		.num_channels = ARRAY_SIZE(mcp3x02_channels)
>>+	},
>>+	[mcp3204] = {
>>+		.channels = mcp3x04_channels,
>>+		.num_channels = ARRAY_SIZE(mcp3x04_channels)
>>+	},
>>+	[mcp3208] = {
>>+		.channels = mcp3x08_channels,
>>+		.num_channels = ARRAY_SIZE(mcp3x08_channels)
>>+	},
>>+};
>>+
>>+static int channel_to_tx_data(const struct mcp3X0X_chip_info
>>*chip_info,
>>+			const unsigned int channel, bool differential)
>>+{
>>+	unsigned int tx_data = 0;
>>+
>>+	if (chip_info->num_channels - 1 == 2) {
>>+		tx_data = 0x12 | (differential ? 0 << 3 : 1 << 3) |
>>+				((channel & 0x01) << 2);
>>+	} else if (chip_info->num_channels - 2 == 4) {
>>+		tx_data = 0x20 | (differential ? 0 << 4 : 1 << 4) |
>>+				((channel & 0x03) << 1);
>>+	} else if (chip_info->num_channels - 4 == 8) {
>>+		tx_data = 0x20 | (differential ? 0 << 4 : 1 << 4) |
>>+				((channel & 0x07) << 1);
>>+	}
>>+
>>+	return tx_data;
>>+}
>>+
>>+static int mcp3x0x_adc_conversion(struct mcp3x0x *adc, u8 channel,
>>+			bool differential, int device_index)
>>+{
>>+	int ret;
>>+	u16 adc_value;
>>+	__be16 buf;
>>+
>>+	const struct mcp3X0X_chip_info *chip_info = NULL;
>>+
>>+	if (device_index == -1)
>>+		return -1;
>>+
>>+	chip_info = &mcp3X0X_chip_infos[device_index];
>>+	if (chip_info == NULL)
>>+		return -1;
>>+
>>+	adc->rx_buf[0] = 0;
>>+	adc->rx_buf[1] = 0;
>>+	adc->tx_buf = channel_to_tx_data(chip_info, channel, differential);
>>+
>>+	if (device_index != mcp3001 && device_index != mcp3201) {
>>+		ret = spi_sync(adc->spi, &adc->msg);
>>+		if (ret < 0)
>>+			return ret;
>>+	} else {
>>+		ret = spi_read(adc->spi, (u8 *)&buf, 2);
>>+		if (ret < 0)
>>+			return ret;
>>+	}
>>+
>>+	switch (device_index) {
>>+	case mcp3001:
>>+		adc_value = (be16_to_cpu(buf) >> 3);
>>+		break;
>>+	case mcp3002:
>>+		spi_sync(adc->spi, &adc->msg);
>>+		adc_value = adc->rx_buf[0];
>>+		adc_value = ((adc_value << 2) |
>>+			((adc->rx_buf[1] & 0xC0) >> 6)) & 0x03ff;
>>+		break;
>>+	case mcp3004:
>>+	case mcp3008:
>>+		adc_value = adc->rx_buf[0] & 0x7f;
>>+		adc_value = ((adc_value << 3) |
>>+			((adc->rx_buf[1] & 0xe0) >> 5)) & 0x03ff;
>>+		break;
>>+	case mcp3201:
>>+		adc_value = (be16_to_cpu(buf) >> 1);
>>+		break;
>>+	case mcp3202:
>>+		adc_value = adc->rx_buf[0];
>>+		adc_value = ((adc_value << 4) |
>>+			((adc->rx_buf[1] & 0xf0) >> 4)) & 0x0fff;
>>+		break;
>>+	case mcp3204:
>>+	case mcp3208:
>>+		adc_value = adc->rx_buf[0] & 0x7f;
>>+		adc_value = ((adc_value << 5) |
>>+			((adc->rx_buf[1] & 0xf8) >> 3)) & 0x0fff;
>>+		break;
>>+	default:
>>+		adc_value = 0;
>>+		break;
>>+	}
>>+
>>+	return adc_value;
>>+}
>>+
>>+static int mcp3x0x_read_raw(struct iio_dev *indio_dev,
>>+			struct iio_chan_spec const *channel, int *val,
>>+			int *val2, long mask)
>>+{
>>+	struct mcp3x0x *adc = iio_priv(indio_dev);
>>+	int ret = -EINVAL;
>>+	int device_index = 0;
>>+
>>+	mutex_lock(&adc->lock);
>>+
>>+	device_index = spi_get_device_id(adc->spi)->driver_data;
>>+
>>+	if (device_index == -1)
>>+		goto out;
>>+
>>+	switch (mask) {
>>+	case IIO_CHAN_INFO_RAW:
>>+		ret = mcp3x0x_adc_conversion(adc, channel->address,
>>+			channel->differential, device_index);
>>+
>>+		if (ret < 0)
>>+			goto out;
>>+
>>+		*val = ret;
>>+		ret = IIO_VAL_INT;
>>+		break;
>>+
>>+	case IIO_CHAN_INFO_SCALE:
>>+		/*
>>+		 * Digital output code = (resolution * Vin) / Vref
>>+		 * Get regulator output voltage in uV.
>>+		 */
>>+		ret = regulator_get_voltage(adc->reg);
>>+		if (ret < 0)
>>+			goto out;
>>+
>>+		/* convert regulator output voltage to mV */
>>+		*val  = ret / 1000;
>>+		*val2 = -1;
>>+		if (device_index == mcp3001 || device_index == mcp3002 ||
>>+			device_index == mcp3004 || device_index == mcp3008)
>>+			*val2 = 10;
>>+		else if (device_index == mcp3201 || device_index == mcp3202 ||
>>+			device_index == mcp3204 || device_index == mcp3208)
>>+			*val2 = 12;
>>+		else
>>+			goto out;
>>+
>>+		ret = IIO_VAL_FRACTIONAL_LOG2;
>>+		break;
>>+
>>+	default:
>>+		break;
>>+	}
>>+
>>+out:
>>+	mutex_unlock(&adc->lock);
>>+
>>+	return ret;
>>+}
>>+
>>+static int mcp3x0x_probe(struct spi_device *spi)
>>+{
>>+	struct iio_dev *indio_dev;
>>+	struct mcp3x0x *adc;
>>+	const struct mcp3X0X_chip_info *chip_info;
>>+	int ret;
>>+
>>+	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*adc));
>>+	if (!indio_dev)
>>+		return -ENOMEM;
>>+
>>+	adc = iio_priv(indio_dev);
>>+	adc->spi = spi;
>>+
>>+	indio_dev->dev.parent = &spi->dev;
>>+	indio_dev->name = spi_get_device_id(spi)->name;
>>+	indio_dev->modes = INDIO_DIRECT_MODE;
>>+	indio_dev->info = &mcp3x0x_info;
>>+
>>+	chip_info =
>&mcp3X0X_chip_infos[spi_get_device_id(spi)->driver_data];
>>+	indio_dev->channels = chip_info->channels;
>>+	indio_dev->num_channels = chip_info->num_channels;
>>+
>>+	adc->transfer[0].tx_buf = &adc->tx_buf;
>>+	adc->transfer[0].len = sizeof(adc->tx_buf);
>>+	adc->transfer[1].rx_buf = adc->rx_buf;
>>+	adc->transfer[1].len = sizeof(adc->rx_buf);
>>+
>>+	spi_message_init_with_transfers(&adc->msg, adc->transfer,
>>+					ARRAY_SIZE(adc->transfer));
>>+
>>+	adc->reg = devm_regulator_get(&spi->dev, "vref");
>>+	if (IS_ERR(adc->reg))
>>+		return PTR_ERR(adc->reg);
>>+
>>+	ret = regulator_enable(adc->reg);
>>+	if (ret < 0)
>>+		return ret;
>>+
>>+	mutex_init(&adc->lock);
>>+
>>+	ret = iio_device_register(indio_dev);
>>+	if (ret < 0)
>>+		goto reg_disable;
>>+
>>+	return 0;
>>+
>>+reg_disable:
>>+	regulator_disable(adc->reg);
>>+
>>+	return ret;
>>+}
>>+
>>+static int mcp3x0x_remove(struct spi_device *spi)
>>+{
>>+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>>+	struct mcp3x0x *adc = iio_priv(indio_dev);
>>+
>>+	iio_device_unregister(indio_dev);
>>+	regulator_disable(adc->reg);
>>+
>>+	return 0;
>>+}
>>+
>>+#if defined(CONFIG_OF)
>>+static const struct of_device_id mcp3x0x_dt_ids[] = {
>>+	{
>>+		.compatible = "mcp3001",
>>+		.data = &mcp3X0X_chip_infos[mcp3001],
>>+	}, {
>>+		.compatible = "mcp3002",
>>+		.data = &mcp3X0X_chip_infos[mcp3002],
>>+	}, {
>>+		.compatible = "mcp3004",
>>+		.data = &mcp3X0X_chip_infos[mcp3004],
>>+	}, {
>>+		.compatible = "mcp3008",
>>+		.data = &mcp3X0X_chip_infos[mcp3004],
>>+	}, {
>>+		.compatible = "mcp3201",
>>+		.data = &mcp3X0X_chip_infos[mcp3201],
>>+	}, {
>>+		.compatible = "mcp3202",
>>+		.data = &mcp3X0X_chip_infos[mcp3202],
>>+	}, {
>>+		.compatible = "mcp3204",
>>+		.data = &mcp3X0X_chip_infos[mcp3204],
>>+	}, {
>>+		.compatible = "mcp3008",
>>+		.data = &mcp3X0X_chip_infos[mcp3208],
>>+	}, {
>>+	}
>>+};
>>+MODULE_DEVICE_TABLE(of, mcp3x0x_dt_ids);
>>+#endif
>>+
>>+static const struct spi_device_id mcp3x0x_id[] = {
>>+	{ "mcp3001", mcp3001 },
>>+	{ "mcp3002", mcp3002 },
>>+	{ "mcp3004", mcp3004 },
>>+	{ "mcp3008", mcp3008 },
>>+	{ "mcp3201", mcp3201 },
>>+	{ "mcp3202", mcp3202 },
>>+	{ "mcp3204", mcp3204 },
>>+	{ "mcp3208", mcp3208 },
>>+	{ }
>>+};
>>+MODULE_DEVICE_TABLE(spi, mcp3x0x_id);
>>+
>>+static struct spi_driver mcp3x0x_driver = {
>>+	.driver = {
>>+		.name = "mcp3x0x",
>>+		.owner = THIS_MODULE,
>>+	},
>>+	.probe = mcp3x0x_probe,
>>+	.remove = mcp3x0x_remove,
>>+	.id_table = mcp3x0x_id,
>>+};
>>+module_spi_driver(mcp3x0x_driver);
>>+
>>+MODULE_AUTHOR("Allan Bendorff Jensen <abj@rosetechnology.dk>");
>>+MODULE_DESCRIPTION("Microchip Technology MCP3x01/02/04/08");
>>+MODULE_LICENSE("GPL v2");
>>
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-iio"
>in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
