Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaBYUlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:41:39 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48500 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBYUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:41:38 -0500
Message-ID: <530D002C.6050909@kernel.org>
Date: Tue, 25 Feb 2014 20:42:20 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] iio: adc: Add MEN 16z188 ADC driver
References: <1392737654-22682-4-git-send-email-johannes.thumshirn@men.de> <1393262177-19773-1-git-send-email-johannes.thumshirn@men.de>
In-Reply-To: <1393262177-19773-1-git-send-email-johannes.thumshirn@men.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/14 17:16, Johannes Thumshirn wrote:
> Add support for MEN 16z188 ADC IP Core on MCB FPGAs.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
Looks good.  One possible issue with devm usage. It looks like
userspace interfaces will get removed after some other bits that
they will rely on. I missed this the first time around.
> ---
>   drivers/iio/adc/Kconfig        |  10 +++
>   drivers/iio/adc/Makefile       |   1 +
>   drivers/iio/adc/men_z188_adc.c | 170 +++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 181 insertions(+)
>   create mode 100644 drivers/iio/adc/men_z188_adc.c
>
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 2209f28..5c63f091 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -155,6 +155,16 @@ config MCP3422
>   	  This driver can also be built as a module. If so, the module will be
>   	  called mcp3422.
>
> +config MEN_Z188_ADC
> +	tristate "MEN 16z188 ADC IP Core support"
> +	depends on MCB
> +	help
> +	  Say yes here to enable support for the MEN 16z188 ADC IP-Core on a MCB
> +	  carrier.
> +
> +	  This driver can also be built as a module. If so, the module will be
> +	  called men_z188_adc.
> +
>   config NAU7802
>   	tristate "Nuvoton NAU7802 ADC driver"
>   	depends on I2C
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index ba9a10a..85a4a04 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>   obj-$(CONFIG_MAX1363) += max1363.o
>   obj-$(CONFIG_MCP320X) += mcp320x.o
>   obj-$(CONFIG_MCP3422) += mcp3422.o
> +obj-$(CONFIG_MEN_Z188_ADC) += men_z188_adc.o
>   obj-$(CONFIG_NAU7802) += nau7802.o
>   obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
>   obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
> diff --git a/drivers/iio/adc/men_z188_adc.c b/drivers/iio/adc/men_z188_adc.c
> new file mode 100644
> index 0000000..da7f3d0
> --- /dev/null
> +++ b/drivers/iio/adc/men_z188_adc.c
> @@ -0,0 +1,170 @@
> +/*
> + * MEN 16z188 Analog to Digial Converter
> + *
> + * Copyright (C) 2014 MEN Mikroelektronik GmbH (www.men.de)
> + * Author: Johannes Thumshirn <johannes.thumshirn@men.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; version 2 of the License.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mcb.h>
> +#include <linux/iio/iio.h>
> +
> +#define Z188_ADC_MAX_CHAN	8
> +#define Z188_ADC_GAIN		0x0700000
> +#define Z188_MODE_VOLTAGE	BIT(27)
> +#define Z188_CFG_AUTO		0x1
> +#define Z188_CTRL_REG		0x40
> +
> +#define ADC_DATA(x) (((x) >> 2) & 0x7ffffc)
> +#define ADC_OVR(x) ((x) & 0x1)
> +
> +struct z188_adc {
> +	struct resource *mem;
> +	void __iomem *base;
> +};
> +
> +#define Z188_ADC_CHANNEL(idx) {					\
> +		.type = IIO_VOLTAGE,				\
> +		.indexed = 1,					\
> +		.channel = (idx),				\
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),   \
> +}
> +
> +static const struct iio_chan_spec z188_adc_iio_channels[] = {
> +	Z188_ADC_CHANNEL(0),
> +	Z188_ADC_CHANNEL(1),
> +	Z188_ADC_CHANNEL(2),
> +	Z188_ADC_CHANNEL(3),
> +	Z188_ADC_CHANNEL(4),
> +	Z188_ADC_CHANNEL(5),
> +	Z188_ADC_CHANNEL(6),
> +	Z188_ADC_CHANNEL(7),
> +};
> +
> +static int z188_iio_read_raw(struct iio_dev *iio_dev,
> +			struct iio_chan_spec const *chan,
> +			int *val,
> +			int *val2,
> +			long info)
> +{
> +	struct z188_adc *adc = iio_priv(iio_dev);
> +	int ret;
> +	u16 tmp;
> +
> +	switch (info) {
> +	case IIO_CHAN_INFO_RAW:
> +		tmp = readw(adc->base + chan->channel * 4);
> +
> +		if (ADC_OVR(tmp)) {
> +			dev_info(&iio_dev->dev,
> +				"Oversampling error on ADC channel %d\n",
> +				chan->channel);
> +			return -EIO;
> +		}
> +		*val = ADC_DATA(tmp);
> +		ret = IIO_VAL_INT;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static struct iio_info z188_adc_info = {
> +	.read_raw = &z188_iio_read_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +static void men_z188_config_channels(void __iomem *addr)
> +{
> +	int i;
> +	u32 cfg;
> +	u32 ctl;
> +
> +	ctl = readl(addr + Z188_CTRL_REG);
> +	ctl |= Z188_CFG_AUTO;
> +	writel(ctl, addr + Z188_CTRL_REG);
> +
> +	for (i = 0; i < Z188_ADC_MAX_CHAN; i++) {
> +		cfg = readl(addr + i);
> +		cfg &= ~Z188_ADC_GAIN;
> +		cfg |= Z188_MODE_VOLTAGE;
> +		writel(cfg, addr + i);
> +	}
> +}
> +
> +static int men_z188_probe(struct mcb_device *dev,
> +			const struct mcb_device_id *id)
> +{
> +	struct z188_adc *adc;
> +	struct iio_dev *indio_dev;
> +	struct resource *mem;
> +
> +	indio_dev = devm_iio_device_alloc(&dev->dev, sizeof(struct z188_adc));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	adc = iio_priv(indio_dev);
> +	indio_dev->name = "z188-adc";
> +	indio_dev->dev.parent = &dev->dev;
> +	indio_dev->info = &z188_adc_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = z188_adc_iio_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(z188_adc_iio_channels);
> +
> +	mem = mcb_request_mem(dev, "z188-adc");
> +	if (!mem)
> +		return -ENOMEM;
> +
> +	adc->base = ioremap(mem->start, resource_size(mem));
> +	if (adc->base == NULL)
> +		goto err;
> +
> +	men_z188_config_channels(adc->base);
> +
> +	adc->mem = mem;
> +	mcb_set_drvdata(dev, indio_dev);
> +
> +	return  devm_iio_device_register(&dev->dev, indio_dev);
Using devm_iio_device_register means that the userspace interface
will only be removed after your remove function below had run.
That leaves room for some nasty race conditions.

The rule of thumb is don't use that particular devm function unless
absolutely everything is using devm interfaces.  E.g. you don't have
any remove function at all.

Sorry, I missed this in the previous version.

> +
> +err:
> +	mcb_release_mem(mem);
> +	return -ENXIO;
> +}
> +
> +static void men_z188_remove(struct mcb_device *dev)
> +{
> +	struct iio_dev *indio_dev  = mcb_get_drvdata(dev);
> +	struct z188_adc *adc = iio_priv(indio_dev);
> +
> +	iounmap(adc->base);
Currently the userspace interface is still active after you've unmapped
this?  Definitely a bad idea.
> +	mcb_release_mem(adc->mem);
> +}
> +
> +static const struct mcb_device_id men_z188_ids[] = {
> +	{ .device = 0xbc },
> +};
> +MODULE_DEVICE_TABLE(mcb, men_z188_ids);
> +
> +static struct mcb_driver men_z188_driver = {
> +	.driver = {
> +		.name = "z188-adc",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = men_z188_probe,
> +	.remove = men_z188_remove,
> +	.id_table = men_z188_ids,
> +};
> +module_mcb_driver(men_z188_driver);
> +
> +MODULE_AUTHOR("Johannes Thumshirn <johannes.thumshirn@men.de>");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("IIO ADC driver for MEN 16z188 ADC Core");
> +MODULE_ALIAS("mcb:16z188");
> --
> 1.8.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

