Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967131Ab3DRPLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:11:04 -0400
Received: from smtp-out-202.synserver.de ([212.40.185.202]:1117 "EHLO
	smtp-out-200.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966627Ab3DRPLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:11:01 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13652
Message-ID: <51700CD4.9040401@metafoo.de>
Date: Thu, 18 Apr 2013 17:10:12 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
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
Subject: Re: [NEW DRIVER V5 2/7] drivers/iio/adc: DA9058 ADC driver
References: <201304171648.r3HGm5rd023889@latitude>
In-Reply-To: <201304171648.r3HGm5rd023889@latitude>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks almost good.

The patch subject prefix should be 'iio:adc:'. Different subsystems use
different styles for the subject prefix, so it's always to run a short git
log on the subsystems folder and take a look at what was used in the past.

On 04/17/2013 06:33 PM, Anthony Olech wrote:
> This patch is relative to linux next-20130417
> 
> This is the ADC component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC
> driver. It depends on the DA9058 CORE component driver.
> The HWMON component driver depends on this ADC component driver.
> 
> This component driver recieves the actual platform data from
> the DA9058 CORE driver, whose settings may be overridden from
> the platform data supplied from the machine driver.
> 
> Changes relative to V4 of this patch:
> - rebased to latest tagged linux-next - previously relative to mainline
> drivers/iio/adc/Kconfig
> - removed dependancy on IIO_BUFFER, IIO_KFIFO_BUF and IIO_TRIGGER
> - added dependancy on MFD_DA9058
> - changed wait_for_completion_timeout to wait_for_completion_interruptible_timeout
> - added blank line before static function declaration
> - removed IIO_CHAN_INFO_SCALE
> - marked struct da9058_adc_channels as static const
> - changed to prefered style of nested struct instantiation
> - change to .info_mask_separate in struct instantiation
> - remove scan_mask
> - removed clearing of platform_set_drvdata
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> ---
>  drivers/iio/adc/Kconfig      |   12 ++
>  drivers/iio/adc/Makefile     |    1 +
>  drivers/iio/adc/da9058-adc.c |  397 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 410 insertions(+)
>  create mode 100644 drivers/iio/adc/da9058-adc.c
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index ab0767e6..68162bf 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -111,6 +111,18 @@ config EXYNOS_ADC
>  	  of SoCs for drivers such as the touchscreen and hwmon to use to share
>  	  this resource.
>  
> +config DA9058_ADC
> +	tristate "Dialog DA9058 PMIC ADC"
> +	depends on MFD_DA9058
> +	select SYSFS
> +	help
> +	  Say yes here to build support for the ADC component of
> +	  the DAILOG DA9058 PMIC.
> +	  If unsure, say N (but it's safe to say "Y").
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called da9058-adc.
> +

This should go above the EXYNOS_ADC entry to keep it sorted.

>  config LP8788_ADC
>  	bool "LP8788 ADC driver"
>  	depends on MFD_LP8788
[...]
> diff --git a/drivers/iio/adc/da9058-adc.c b/drivers/iio/adc/da9058-adc.c
> new file mode 100644
> index 0000000..d0ff431
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

The driver doesn't use anything from regmap.h as far as I can see

> +#include <linux/mfd/core.h>
> +
> +#include <linux/mfd/da9058/version.h>
> +#include <linux/mfd/da9058/core.h>
> +#include <linux/mfd/da9058/registers.h>
> +#include <linux/mfd/da9058/irq.h>
> +#include <linux/mfd/da9058/pdata.h>
> +#include <linux/mfd/da9058/adc.h>
> +#include <linux/mfd/da9058/conf.h>
> +
> +struct da9058_adc {
> +	struct da9058 *da9058;
> +	struct platform_device *pdev;
> +	struct rtc_device *rtc_dev;

rtc_device? ;)

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
> +				const int channel, unsigned int *value)
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

Same comment as last time, this is pretty much the same code over and over
again. Please put it in a common helper function.


> +	default:
> +		dev_err(da9058->dev, "ADC Channel %d is reserved\n", channel);
> +		return -EIO;
> +	}
> +}
> +
> +static int da9058_manual_adc_conversion(struct da9058 *da9058,
> +				const int channel, unsigned int *value)
> +{
> +	unsigned int adc_msh, adc_lsh;
> +	int ret;
> +
> +	mutex_lock(&da9058->adc_mutex);

Adding

	INIT_COMPLETION(&st->completion);

shouldn't hurt

> +
> +	ret = da9058_reg_write(da9058, DA9058_ADCMAN_REG,
> +					DA9058_ADCMAN_MANCONV | channel);
> +	if (ret < 0)
> +		goto err;
> +
> +	if (!wait_for_completion_interruptible_timeout(&da9058->adc_read_done,
> +						msecs_to_jiffies(500))) {

You need to handle the case where this function is interrupted in which case
it returns a negative error which should be passed on to the caller.

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

And here it is again.

> +err:
> +	mutex_unlock(&da9058->adc_mutex);
> +	return ret;
> +}
> +
> +static int da9058_adc_conversion_read(struct da9058 *da9058, const int channel,
> +					int automatic_mode, unsigned int *value)
> +{
> +	if (!value)
> +		return -EINVAL;
> +
> +	if (automatic_mode) {
> +		unsigned int adc_ctrl;
> +		int ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_ADCCONT_REG, &adc_ctrl);
> +		if (ret)
> +			return ret;
> +
> +		if (adc_ctrl & DA9058_ADCCONT_AUTOADCEN)
> +			return da9058_automatic_adc_conversion(da9058,
> +						channel, value);
> +		else
> +			return da9058_manual_adc_conversion(da9058,
> +						channel, value);
> +	} else {
> +		return da9058_manual_adc_conversion(da9058, channel, value);
> +	}
> +}
> +
[...]
> +static int da9058_adc_read_raw(struct iio_dev *idev,
> +	struct iio_chan_spec const *chan, int *val, int *val2, long info)
> +{
> +	struct da9058_adc *adc = iio_priv(idev);
> +	struct da9058 *da9058 = adc->da9058;
> +	int ret;
> +
> +	switch (info) {
> +	case IIO_CHAN_INFO_RAW:
> +		ret = da9058_adc_conversion_read(da9058, chan->channel,
> +					adc->use_automatic_adc, val);
> +		if (ret)
> +			return ret;
> +		else
> +			return IIO_VAL_INT;

Just a codestyle nitpick. I'd drop the else.

> +	default:
> +		return -EINVAL;
> +	};
> +}
[...]
> +static const struct iio_chan_spec da9058_adc_channels[] = {
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 0,
> +		.scan_index = 0,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 12,
> +			.storagebits = 16,
> +			},
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 1,
> +		.scan_index = 1,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 12,
> +			.storagebits = 16,
> +			},
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 2,
> +		.scan_index = 2,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 12,
> +			.storagebits = 16,
> +			},
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 3,
> +		.scan_index = 3,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 12,
> +			.storagebits = 16,
> +			},
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 4,
> +		.scan_index = 4,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 12,
> +			.storagebits = 16,
> +			},
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),

Same comment as last time. Use a helper macro to initialize the channels.

> +	},
> +
> +};
> +
> +static int da9058_adc_probe(struct platform_device *pdev)
> +{
> +	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
> +	const struct mfd_cell *cell = mfd_get_cell(pdev);
> +	struct da9058_adc_pdata *adc_pdata;
> +	struct da9058_adc *adc;
> +	struct iio_dev *idev;

I know this is really nitpicking, but same comment as before indio_dev
instead of idev to be consistent with other drivers.

[...]
