Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaBRPv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:51:28 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:42350 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837AbaBRPv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:51:27 -0500
Date: Tue, 18 Feb 2014 16:51:25 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] iio: adc: Add MEN 16z188 ADC driver
In-Reply-To: <1392737654-22682-4-git-send-email-johannes.thumshirn@men.de>
Message-ID: <alpine.DEB.2.01.1402181644420.22831@pmeerw.net>
References: <1392737654-22682-1-git-send-email-johannes.thumshirn@men.de> <1392737654-22682-4-git-send-email-johannes.thumshirn@men.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some quick comments below...

> Add support for MEN 16z188 ADC IP Core on MCB FPGAs.
 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  drivers/iio/adc/Kconfig        |  10 +++
>  drivers/iio/adc/Makefile       |   1 +
>  drivers/iio/adc/men_z188_adc.c | 172 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 183 insertions(+)
>  create mode 100644 drivers/iio/adc/men_z188_adc.c
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 2209f28..5209437 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -204,4 +204,14 @@ config VIPERBOARD_ADC
>  	  Say yes here to access the ADC part of the Nano River
>  	  Technologies Viperboard.
>  
> +config MEN_Z188_ADC
> +	tristate "MEN 16z188 ADC IP Core support"
> +	depends on MCB
> +	help
> +	  Say yes here to access support the MEN 16z188 ADC IP-Core on a MCB
> +	  carrier.

support _for_ the 

> +
> +	  This driver can also be built as a module. If so, the module will be
> +	  called men_z188_adc.
> +
>  endmenu
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index ba9a10a..1584391 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
>  obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
>  obj-$(CONFIG_TWL6030_GPADC) += twl6030-gpadc.o
>  obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
> +obj-$(CONFIG_MEN_Z188_ADC) += men_z188_adc.o
> diff --git a/drivers/iio/adc/men_z188_adc.c b/drivers/iio/adc/men_z188_adc.c
> new file mode 100644
> index 0000000..8bc66cf
> --- /dev/null
> +++ b/drivers/iio/adc/men_z188_adc.c
> @@ -0,0 +1,172 @@
> +/*
> + * MEN 16z188 Analoge to Digial Converter

Analog

> + *
> + * Copyright (C) 2014 MEN Mikroelektronik GmbH (www.men.de)
> + * Author: Johannes Thumshirn <johannes.thumshirn@men.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; version 2 of the License.
> + */

newline

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
> +static struct iio_chan_spec z188_adc_iio_channels[] = {
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
> +	int ret = 0;
> +	u16 tmp = 0;
> +

no need to init ret, tmp
delete extra newline

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

extra space 

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
> +	mcb_release_mem(adc->mem);
> +
> +	mcb_set_drvdata(dev, NULL);
> +}
> +
> +static struct mcb_device_id men_z188_ids[] = {
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
> 

-- 

Peter Meerwald
+43-664-2444418 (mobile)
