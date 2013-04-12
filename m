Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3DLQKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:10:43 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:47028 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409Ab3DLQKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:10:42 -0400
Message-ID: <51683294.40908@metafoo.de>
Date: Fri, 12 Apr 2013 18:13:08 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V4 2/7] DA9058 ADC driver
References: <201304121320.r3CDKLNL013219@latitude>
In-Reply-To: <201304121320.r3CDKLNL013219@latitude>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 03:05 PM, Anthony Olech wrote:
> This is the ADC component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC
> driver. It depends on the DA9058 CORE component driver.
> The HWMON component driver depends on this ADC component driver.
> 
> This component driver recieves the actual platform data from
> the DA9058 CORE driver, whose settings may be overridden from
> the platform data supplied from the machine driver.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> ---
>  drivers/iio/adc/Kconfig      |   14 ++
>  drivers/iio/adc/Makefile     |    1 +
>  drivers/iio/adc/da9058-adc.c |  397 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 412 insertions(+)
>  create mode 100644 drivers/iio/adc/da9058-adc.c
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index e372257..da286ec 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -91,6 +91,20 @@ config AT91_ADC
>  	help
>  	  Say yes here to build support for Atmel AT91 ADC.
>  
> +config DA9058_ADC
> +	tristate "Dialog DA9058 PMIC ADC"
> +	select IIO_BUFFER
> +	select IIO_KFIFO_BUF
> +	select IIO_TRIGGER

You don't use buffers and triggers in your driver.

> +	select SYSFS
> +	help
> +	  Say yes here to build support for the ADC component of
> +	  the DAILOG DA9058 PMIC.
> +	  If unsure, say N (but it's safe to say "Y").
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called da9058-adc.
> +
>  config LP8788_ADC
>  	bool "LP8788 ADC driver"
>  	depends on MFD_LP8788
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index 2d5f100..5c79583 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_AD7791) += ad7791.o
>  obj-$(CONFIG_AD7793) += ad7793.o
>  obj-$(CONFIG_AD7887) += ad7887.o
>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
> +obj-$(CONFIG_DA9058_ADC) += da9058-adc.o
>  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>  obj-$(CONFIG_MAX1363) += max1363.o
>  obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
> diff --git a/drivers/iio/adc/da9058-adc.c b/drivers/iio/adc/da9058-adc.c
> new file mode 100644
> index 0000000..8894a25
> --- /dev/null
> +++ b/drivers/iio/adc/da9058-adc.c
> @@ -0,0 +1,397 @@
> +/*
> + *  Copyright (C) 2012 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/iio/iio.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/core.h>
> +
> +#include <linux/mfd/da9058/version.h>
> +#include <linux/mfd/da9058/core.h>
> +#include <linux/mfd/da9058/registers.h>


I'd prefer to have the register definitions which are relevant for the ADC
driver inside the ADC driver rather than some header somewhere.

> +#include <linux/mfd/da9058/irq.h>
> +#include <linux/mfd/da9058/pdata.h>
> +#include <linux/mfd/da9058/adc.h>

There is no adc.h included in this patchset.

> +#include <linux/mfd/da9058/conf.h>
> +
> +struct da9058_adc {
> +	struct da9058 *da9058;
> +	struct platform_device *pdev;
> +	struct rtc_device *rtc_dev;
> +	int use_automatic_adc;
> +	int irq;
> +};
> +
> +/*
> + *  if the PMIC is in automatic ADC consersion mode we have the choice
> + *  of just getting the last (automatic) conversion or doing a manual
> + *  conversion anyway.
> + *
> + *  if the PMIC is not in automatic ADC consersion mode we have no choice
> + *  we just have to ignore the requested mode and just do a manual
> + *  ADC conversion.
> + */
> +static int da9058_automatic_adc_conversion(struct da9058 *da9058,
> +				const int channel, int *value)
> +{
> +	unsigned int adc_msh, adc_lsh;
> +	int ret;
> +
> +	switch (channel) {
> +	case DA9058_ADCMAN_MUXSEL_VBAT:
> +		ret = da9058_reg_read(da9058, DA9058_VBATRES_REG_MSB,
> +						&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_1,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh & 0x0F) | (adc_msh << 4);
> +
> +		return 0;
> +	case DA9058_ADCMAN_MUXSEL_TEMP:
> +		ret = da9058_reg_read(da9058, DA9058_TEMPRES_REG_MSB,
> +						&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_1,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh >> 4) | (adc_msh << 4);
> +
> +		return 0;
> +	case DA9058_ADCMAN_MUXSEL_VF:
> +		ret = da9058_reg_read(da9058, DA9058_VREF_REG,
> +					&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_2,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh & 0x0F) | (adc_msh << 4);
> +
> +		return 0;
> +	case DA9058_ADCMAN_MUXSEL_ADCIN:
> +		ret = da9058_reg_read(da9058, DA9058_ADCINRES_REG_MSB,
> +					&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_2,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh >> 4) | (adc_msh << 4);
> +
> +		return 0;
> +	case DA9058_ADCMAN_MUXSEL_TJUNC:
> +		ret = da9058_reg_read(da9058, DA9058_TJUNCRES_REG,
> +					&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_3,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh >> 4) | (adc_msh << 4);
> +
> +		return 0;

Hm, this is like the same code 5 times copy 'n pasted. If there is no pattern
in how the registers are laid out use a lookup table. E.g.

static const unsigned int da9058_channel_register[][2] = {
	[DA9058_ADCMAN_MUXSEL_TJUNC] = {
		DA9058_TJUNCRES_REG, DA9058_AUTORES_REG_3
	},
	...
};

> +	default:
> +		dev_err(da9058->dev, "ADC Channel %d is reserved\n", channel);
> +		return -EIO;
> +	}
> +}
> +
> +static int da9058_manual_adc_conversion(struct da9058 *da9058,
> +				const int channel, int *value)
> +{
> +	unsigned int adc_msh, adc_lsh;
> +	int ret;
> +
> +	mutex_lock(&da9058->adc_mutex);
> +
> +	ret = da9058_reg_write(da9058, DA9058_ADCMAN_REG,
> +					DA9058_ADCMAN_MANCONV | channel);
> +	if (ret < 0)
> +		goto err;
> +
> +	if (!wait_for_completion_timeout(&da9058->adc_read_done,
> +						msecs_to_jiffies(500))) {

500 ms is quite a long time, how about making this interruptible.

> +		dev_err(da9058->dev,
> +			"timeout waiting for ADC conversion interrupt\n");
> +		ret = -ETIMEDOUT;
> +		goto err;
> +	}
> +
> +	ret = da9058_reg_read(da9058, DA9058_ADCRESH_REG, &adc_msh);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = da9058_reg_read(da9058, DA9058_ADCRESL_REG, &adc_lsh);
> +	if (ret < 0)
> +		goto err;
> +
> +	*value = (adc_msh << 4) | (adc_lsh & 0x0F);
> +
> +err:
> +	mutex_unlock(&da9058->adc_mutex);
> +	return ret;
> +}
[...]
> +static irqreturn_t da9058_adc_interrupt(int irq, void *data)
> +{
> +	struct da9058 *da9058 = data;
> +
> +	complete(&da9058->adc_read_done);
> +
> +	return IRQ_HANDLED;
> +}

Missing newline

> +static int da9058_adc_read_raw(struct iio_dev *idev,
> +	struct iio_chan_spec const *chan, int *val, int *val2, long mask)

call it info instead of mask, it's not really a mask anymore.

> +{
> +	struct da9058_adc *adc = iio_priv(idev);
> +	struct da9058 *da9058 = adc->da9058;
> +	int ret;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		ret = da9058_adc_conversion_read(da9058, chan->channel,
> +					adc->use_automatic_adc, val);
> +		if (ret)
> +			return ret;
> +		else
> +			return IIO_VAL_INT;

You did set the IIO_CHAN_INFO_SCALE bit in the channel spec, but didn't
implement reporting the scale here.

> +	default:
> +		return -EINVAL;
> +	};
> +}
> +
> +static const struct iio_info da9058_adc_info = {
> +	.driver_module = THIS_MODULE,
> +	.read_raw = &da9058_adc_read_raw,
> +};
> +
> +struct iio_chan_spec da9058_adc_channels[] = {

static const

> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 0,
> +		.scan_index = 0,
> +		.scan_type.sign = 'u',
> +		.scan_type.realbits = 12,
> +		.scan_type.storagebits = 16,


		.scan_type = {
			.sign = 'u',
			...
		},

is the preferred style

> +		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
> +				IIO_CHAN_INFO_RAW_SEPARATE_BIT,

This has changed in upstream it needs to be
		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),

please always test your drivers against the latest upstream version before
submitting them.

> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 1,
> +		.scan_index = 1,
> +		.scan_type.sign = 'u',
> +		.scan_type.realbits = 12,
> +		.scan_type.storagebits = 16,
> +		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
> +				IIO_CHAN_INFO_RAW_SEPARATE_BIT,

You could use a helper macro to initialize the channels to eliminate some
duplicated lines.

> +	},
[...]
> +
> +};
> +unsigned long da9058_scan_masks[] = {
static const

> +
> +	(1 << ARRAY_SIZE(da9058_adc_channels)) - 1,
This needs to be NULL terminated.
> +};

Also this scan mask basically says you are only able to sample all channels at
once, which doesn't seem to be the case. Also you don't implement buffered
mode, so you don't need to setup a set of available scan masks at all.

> +
> +static int da9058_adc_probe(struct platform_device *pdev)
> +{
> +	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
> +	const struct mfd_cell *cell = mfd_get_cell(pdev);
> +	struct da9058_adc_pdata *adc_pdata;
> +	struct da9058_adc *adc;
> +	struct iio_dev *idev;

We use indio_dev for most drivers, it would be good to be consistent with those.

> +	int ret;
> +
> +	if (cell == NULL) {
> +		ret = -ENODEV;
> +		goto exit;
> +	}
> +
> +	if (da9058 == NULL) {
> +		ret = -ENODEV;
> +		goto exit;
> +	}
> +
> +	if (da9058->adc_read) {
> +		ret = -EEXIST;
> +		goto exit;
> +	}
> +
> +	adc_pdata = cell->platform_data;
> +
> +	if (adc_pdata == NULL) {
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	idev = iio_device_alloc(sizeof(struct da9058_adc));
> +	if (idev == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	adc = iio_priv(idev);
> +
> +	platform_set_drvdata(pdev, idev);
> +
> +	idev->dev.parent = &pdev->dev;
> +	idev->name = dev_name(&pdev->dev);
> +	idev->modes = INDIO_DIRECT_MODE;
> +	idev->info = &da9058_adc_info;
> +
> +	adc->irq = platform_get_irq(pdev, 0);
> +	if (adc->irq < 0) {
> +		dev_err(&pdev->dev, "can not get ADC IRQ error=%d\n",
> +				adc->irq);
> +		ret = -ENODEV;
> +		goto error_free_device;
> +	}
> +
> +	idev->channels = da9058_adc_channels;
> +	idev->num_channels = ARRAY_SIZE(da9058_adc_channels);
> +	idev->available_scan_masks = da9058_scan_masks;
> +	idev->masklength = ARRAY_SIZE(da9058_adc_channels);
> +
> +	platform_set_drvdata(pdev, adc);
> +	adc->da9058 = da9058;
> +	adc->pdev = pdev;
> +	adc->use_automatic_adc = adc_pdata->use_automatic_adc;
> +	da9058->adc_read = da9058_adc_conversion_read;
> +
> +	ret = iio_device_register(idev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Couldn't register the device.\n");
> +		goto error_free_device;
> +	}
> +
> +	ret = request_threaded_irq(da9058_to_virt_irq_num(da9058, adc->irq),
> +				NULL, da9058_adc_interrupt,
> +				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> +				"DA9058 ADC EOM", da9058);
> +	if (ret)
> +		goto failed_to_get_adc_interrupt;
> +
> +	goto exit;
> +
> +failed_to_get_adc_interrupt:
> +	iio_device_unregister(idev);
> +error_free_device:
> +	platform_set_drvdata(pdev, NULL);

This is not needed, the driver core takes care of it these days.

> +	iio_device_free(idev);
> +exit:
> +error_ret:
> +	return ret;
> +}

[...]
