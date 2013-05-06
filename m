Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3EFQE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:04:59 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42351 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3EFQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:04:57 -0400
Message-ID: <5187D4A6.1050307@kernel.org>
Date: Mon, 06 May 2013 17:04:54 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130403 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Oskar Andero <oskar.andero@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCHv4] iio: adc: add driver for MCP3204/08 12-bit ADC
References: <1367575129-11983-1-git-send-email-oskar.andero@gmail.com> <51838AA1.5080508@metafoo.de>
In-Reply-To: <51838AA1.5080508@metafoo.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 11:00 AM, Lars-Peter Clausen wrote:
> On 05/03/2013 11:58 AM, Oskar Andero wrote:
>> This adds support for Microchip's 12 bit AD converters MCP3204 and
>> MCP3208. These chips communicates over SPI and supports single-ended
>> and pseudo-differential configurations.
>>
>> Cc: Jonathan Cameron <jic23@cam.ac.uk>
>> Cc: Lars-Peter Clausen <lars@metafoo.de>
>> Signed-off-by: Oskar Andero <oskar.andero@gmail.com>
> 
> Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Nice driver.   Thanks Oskar and thanks Lars-Peter
for your review work on this.  Applied to the togreg
branch of iio.git.  Note this branch will be rebased
before I send Greg a pull request (nature of where we
are in the cycle!).

Jonathan
> 
>> ---
>>  drivers/iio/adc/Kconfig   |  10 ++
>>  drivers/iio/adc/Makefile  |   1 +
>>  drivers/iio/adc/mcp320x.c | 257 ++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 268 insertions(+)
>>  create mode 100644 drivers/iio/adc/mcp320x.c
>>
>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>> index ab0767e6..93129ec 100644
>> --- a/drivers/iio/adc/Kconfig
>> +++ b/drivers/iio/adc/Kconfig
>> @@ -133,6 +133,16 @@ config MAX1363
>>  	  max11646, max11647) Provides direct access via sysfs and buffered
>>  	  data via the iio dev interface.
>>  
>> +config MCP320X
>> +	tristate "Microchip Technology MCP3204/08"
>> +	depends on SPI
>> +	help
>> +	  Say yes here to build support for Microchip Technology's MCP3204 or
>> +	  MCP3208 analog to digital converter.
>> +
>> +	  This driver can also be built as a module. If so, the module will be
>> +	  called mcp320x.
>> +
>>  config TI_ADC081C
>>  	tristate "Texas Instruments ADC081C021/027"
>>  	depends on I2C
>> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
>> index 0a825be..8f475d3 100644
>> --- a/drivers/iio/adc/Makefile
>> +++ b/drivers/iio/adc/Makefile
>> @@ -14,6 +14,7 @@ obj-$(CONFIG_AT91_ADC) += at91_adc.o
>>  obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
>>  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>>  obj-$(CONFIG_MAX1363) += max1363.o
>> +obj-$(CONFIG_MCP320X) += mcp320x.o
>>  obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
>>  obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
>>  obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
>> diff --git a/drivers/iio/adc/mcp320x.c b/drivers/iio/adc/mcp320x.c
>> new file mode 100644
>> index 0000000..ebc0159
>> --- /dev/null
>> +++ b/drivers/iio/adc/mcp320x.c
>> @@ -0,0 +1,257 @@
>> +/*
>> + * Copyright (C) 2013 Oskar Andero <oskar.andero@gmail.com>
>> + *
>> + * Driver for Microchip Technology's MCP3204 and MCP3208 ADC chips.
>> + * Datasheet can be found here:
>> + * http://ww1.microchip.com/downloads/en/devicedoc/21298c.pdf
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/spi/spi.h>
>> +#include <linux/module.h>
>> +#include <linux/iio/iio.h>
>> +#include <linux/regulator/consumer.h>
>> +
>> +#define MCP_SINGLE_ENDED	(1 << 3)
>> +#define MCP_START_BIT		(1 << 4)
>> +
>> +enum {
>> +	mcp3204,
>> +	mcp3208,
>> +};
>> +
>> +struct mcp320x {
>> +	struct spi_device *spi;
>> +	struct spi_message msg;
>> +	struct spi_transfer transfer[2];
>> +
>> +	u8 tx_buf;
>> +	u8 rx_buf[2];
>> +
>> +	struct regulator *reg;
>> +	struct mutex lock;
>> +};
>> +
>> +static int mcp320x_adc_conversion(struct mcp320x *adc, u8 msg)
>> +{
>> +	int ret;
>> +
>> +	adc->tx_buf = msg;
>> +	ret = spi_sync(adc->spi, &adc->msg);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return ((adc->rx_buf[0] & 0x3f) << 6)  |
>> +		(adc->rx_buf[1] >> 2);
>> +}
>> +
>> +static int mcp320x_read_raw(struct iio_dev *indio_dev,
>> +			    struct iio_chan_spec const *channel, int *val,
>> +			    int *val2, long mask)
>> +{
>> +	struct mcp320x *adc = iio_priv(indio_dev);
>> +	int ret = -EINVAL;
>> +
>> +	mutex_lock(&adc->lock);
>> +
>> +	switch (mask) {
>> +	case IIO_CHAN_INFO_RAW:
>> +		if (channel->differential)
>> +			ret = mcp320x_adc_conversion(adc,
>> +				MCP_START_BIT | channel->address);
>> +		else
>> +			ret = mcp320x_adc_conversion(adc,
>> +				MCP_START_BIT | MCP_SINGLE_ENDED |
>> +				channel->address);
>> +		if (ret < 0)
>> +			goto out;
>> +
>> +		*val = ret;
>> +		ret = IIO_VAL_INT;
>> +		break;
>> +
>> +	case IIO_CHAN_INFO_SCALE:
>> +		/* Digital output code = (4096 * Vin) / Vref */
>> +		ret = regulator_get_voltage(adc->reg);
>> +		if (ret < 0)
>> +			goto out;
>> +
>> +		*val = ret / 1000;
>> +		*val2 = 12;
>> +		ret = IIO_VAL_FRACTIONAL_LOG2;
>> +		break;
>> +
>> +	default:
>> +		break;
>> +	}
>> +
>> +out:
>> +	mutex_unlock(&adc->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +#define MCP320X_VOLTAGE_CHANNEL(num)				\
>> +	{							\
>> +		.type = IIO_VOLTAGE,				\
>> +		.indexed = 1,					\
>> +		.channel = (num),				\
>> +		.address = (num),				\
>> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
>> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) \
>> +	}
>> +
>> +#define MCP320X_VOLTAGE_CHANNEL_DIFF(num)			\
>> +	{							\
>> +		.type = IIO_VOLTAGE,				\
>> +		.indexed = 1,					\
>> +		.channel = (num * 2),				\
>> +		.channel2 = (num * 2 + 1),			\
>> +		.address = (num * 2),				\
>> +		.differential = 1,				\
>> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
>> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) \
>> +	}
>> +
>> +static const struct iio_chan_spec mcp3204_channels[] = {
>> +	MCP320X_VOLTAGE_CHANNEL(0),
>> +	MCP320X_VOLTAGE_CHANNEL(1),
>> +	MCP320X_VOLTAGE_CHANNEL(2),
>> +	MCP320X_VOLTAGE_CHANNEL(3),
>> +	MCP320X_VOLTAGE_CHANNEL_DIFF(0),
>> +	MCP320X_VOLTAGE_CHANNEL_DIFF(1),
>> +};
>> +
>> +static const struct iio_chan_spec mcp3208_channels[] = {
>> +	MCP320X_VOLTAGE_CHANNEL(0),
>> +	MCP320X_VOLTAGE_CHANNEL(1),
>> +	MCP320X_VOLTAGE_CHANNEL(2),
>> +	MCP320X_VOLTAGE_CHANNEL(3),
>> +	MCP320X_VOLTAGE_CHANNEL(4),
>> +	MCP320X_VOLTAGE_CHANNEL(5),
>> +	MCP320X_VOLTAGE_CHANNEL(6),
>> +	MCP320X_VOLTAGE_CHANNEL(7),
>> +	MCP320X_VOLTAGE_CHANNEL_DIFF(0),
>> +	MCP320X_VOLTAGE_CHANNEL_DIFF(1),
>> +	MCP320X_VOLTAGE_CHANNEL_DIFF(2),
>> +	MCP320X_VOLTAGE_CHANNEL_DIFF(3),
>> +};
>> +
>> +static const struct iio_info mcp320x_info = {
>> +	.read_raw = mcp320x_read_raw,
>> +	.driver_module = THIS_MODULE,
>> +};
>> +
>> +struct mcp3208_chip_info {
>> +	const struct iio_chan_spec *channels;
>> +	unsigned int num_channels;
>> +};
>> +
>> +static const struct mcp3208_chip_info mcp3208_chip_infos[] = {
>> +	[mcp3204] = {
>> +		.channels = mcp3204_channels,
>> +		.num_channels = ARRAY_SIZE(mcp3204_channels)
>> +	},
>> +	[mcp3208] = {
>> +		.channels = mcp3208_channels,
>> +		.num_channels = ARRAY_SIZE(mcp3208_channels)
>> +	},
>> +};
>> +
>> +static int mcp320x_probe(struct spi_device *spi)
>> +{
>> +	struct iio_dev *indio_dev;
>> +	struct mcp320x *adc;
>> +	const struct mcp3208_chip_info *chip_info;
>> +	int ret;
>> +
>> +	indio_dev = iio_device_alloc(sizeof(*adc));
>> +	if (!indio_dev)
>> +		return -ENOMEM;
>> +
>> +	adc = iio_priv(indio_dev);
>> +	adc->spi = spi;
>> +
>> +	indio_dev->dev.parent = &spi->dev;
>> +	indio_dev->name = spi_get_device_id(spi)->name;
>> +	indio_dev->modes = INDIO_DIRECT_MODE;
>> +	indio_dev->info = &mcp320x_info;
>> +
>> +	chip_info = &mcp3208_chip_infos[spi_get_device_id(spi)->driver_data];
>> +	indio_dev->channels = chip_info->channels;
>> +	indio_dev->num_channels = chip_info->num_channels;
>> +
>> +	adc->transfer[0].tx_buf = &adc->tx_buf;
>> +	adc->transfer[0].len = sizeof(adc->tx_buf);
>> +	adc->transfer[1].rx_buf = adc->rx_buf;
>> +	adc->transfer[1].len = sizeof(adc->rx_buf);
>> +
>> +	spi_message_init_with_transfers(&adc->msg, adc->transfer,
>> +					ARRAY_SIZE(adc->transfer));
>> +
>> +	adc->reg = regulator_get(&spi->dev, "vref");
>> +	if (IS_ERR(adc->reg)) {
>> +		ret = PTR_ERR(adc->reg);
>> +		goto iio_free;
>> +	}
>> +
>> +	ret = regulator_enable(adc->reg);
>> +	if (ret < 0)
>> +		goto reg_free;
>> +
>> +	mutex_init(&adc->lock);
>> +
>> +	ret = iio_device_register(indio_dev);
>> +	if (ret < 0)
>> +		goto reg_disable;
>> +
>> +	return 0;
>> +
>> +reg_disable:
>> +	regulator_disable(adc->reg);
>> +reg_free:
>> +	regulator_put(adc->reg);
>> +iio_free:
>> +	iio_device_free(indio_dev);
>> +
>> +	return ret;
>> +}
>> +
>> +static int mcp320x_remove(struct spi_device *spi)
>> +{
>> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>> +	struct mcp320x *adc = iio_priv(indio_dev);
>> +
>> +	iio_device_unregister(indio_dev);
>> +	regulator_disable(adc->reg);
>> +	regulator_put(adc->reg);
>> +	iio_device_free(indio_dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct spi_device_id mcp320x_id[] = {
>> +	{ "mcp3204", mcp3204 },
>> +	{ "mcp3208", mcp3208 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(spi, mcp320x_id);
>> +
>> +static struct spi_driver mcp320x_driver = {
>> +	.driver = {
>> +		.name = "mcp320x",
>> +		.owner = THIS_MODULE,
>> +	},
>> +	.probe = mcp320x_probe,
>> +	.remove = mcp320x_remove,
>> +	.id_table = mcp320x_id,
>> +};
>> +module_spi_driver(mcp320x_driver);
>> +
>> +MODULE_AUTHOR("Oskar Andero <oskar.andero@gmail.com>");
>> +MODULE_DESCRIPTION("Microchip Technology MCP3204/08");
>> +MODULE_LICENSE("GPL v2");
> 
