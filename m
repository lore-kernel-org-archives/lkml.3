Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaFOURf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:17:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:39855 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaFOUR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:17:27 -0400
Message-ID: <539DFFC8.3080406@kernel.org>
Date: Sun, 15 Jun 2014 21:19:20 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH 4/8] iio: Add support for DA9150 GPADC
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com> <3c1a7551c7deaeccdca731fa95f4349c57e04249.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <3c1a7551c7deaeccdca731fa95f4349c57e04249.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/14 12:11, Adam Thomson wrote:
> This patch adds support for DA9150 Charger & Fuel-Gauge IC GPADC.
>
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Hi Adam

Reasonably clean code, but the _ channels stuff doesn't comply with the ABI
and is rather confusing.

If it really does make sense to allow reading these channels at different
ranges (presumably to enhance the effective adc resolution) then we need
to control this via existing ABIs. Controlling it via scale with a
range attribute if required (read only but changes with whatever the
scale attribute it set to).

Often, for slow parts at least it makes little sense to have provide
software support for variable input ranges.

Looking at what is covered, is it the case that only one option will make
sense for a given hardware setup? (cover the required range and nothing more).

If so, perhaps this wants to go into the device tree or similar?

Jonathan
> ---
>   drivers/iio/adc/Kconfig          |   9 +
>   drivers/iio/adc/Makefile         |   1 +
>   drivers/iio/adc/da9150-gpadc.c   | 396 +++++++++++++++++++++++++++++++++++++++
>   include/linux/mfd/da9150/gpadc.h |  71 +++++++
>   4 files changed, 477 insertions(+)
>   create mode 100644 drivers/iio/adc/da9150-gpadc.c
>   create mode 100644 include/linux/mfd/da9150/gpadc.h
>
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 24c28e3..f5e9f72 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -105,6 +105,15 @@ config AT91_ADC
>   	help
>   	  Say yes here to build support for Atmel AT91 ADC.
>
> +config DA9150_GPADC
> +	tristate "Dialog DA9150 GPADC driver support"
> +	depends on MFD_DA9150
> +	help
> +	  Say yes here to build support for Dialog DA9150 GPADC.
> +
> +	  This driver can also be built as a module. If chosen, the module name
> +	  will be da9150-gpadc.
> +
>   config EXYNOS_ADC
>   	tristate "Exynos ADC driver support"
>   	depends on OF
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index ab346d8..414b22f 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_AD7791) += ad7791.o
>   obj-$(CONFIG_AD7793) += ad7793.o
>   obj-$(CONFIG_AD7887) += ad7887.o
>   obj-$(CONFIG_AT91_ADC) += at91_adc.o
> +obj-$(CONFIG_DA9150_GPADC) += da9150-gpadc.o
>   obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
>   obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>   obj-$(CONFIG_MAX1363) += max1363.o
> diff --git a/drivers/iio/adc/da9150-gpadc.c b/drivers/iio/adc/da9150-gpadc.c
> new file mode 100644
> index 0000000..2107f86
> --- /dev/null
> +++ b/drivers/iio/adc/da9150-gpadc.c
> @@ -0,0 +1,396 @@
> +/*
> + * DA9150 GPADC Driver
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +
> +#include <linux/mfd/da9150/core.h>
> +#include <linux/mfd/da9150/pdata.h>
> +#include <linux/mfd/da9150/registers.h>
> +#include <linux/mfd/da9150/gpadc.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/machine.h>
> +#include <linux/iio/driver.h>
> +
> +
> +/*
> + * IRQ Handling
Please get rid of excess white space and comments that just tell you
something obvious about the code following them.
> + */
> +
> +static irqreturn_t da9150_gpadc_irq(int irq, void *data)
> +{
> +
> +	struct da9150_gpadc *gpadc = data;
> +
> +	complete(&gpadc->complete);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +
> +/*
> + * GPADC access
> + */
> +
> +static inline int da9150_gpadc_gpio_2v_voltage_now(int raw_val)
> +{
> +	/* Convert to uV */
> +	return (((3 * ((raw_val * 1000) + 500)) / 2048) * 1000);
> +}
> +
> +static inline int da9150_gpadc_gpio_5v_voltage_now(int raw_val)
> +{
> +	/* Convert to uV */
> +	return (((6 * ((raw_val * 1000) + 500)) / 1024) * 1000);
> +}
> +
> +static inline int da9150_gpadc_ibus_current_avg(int raw_val)
> +{
> +	/* Convert to uA */
> +	return (((4 * ((raw_val * 1000) + 500)) / 2048) * 1000);
> +}
> +
> +static inline int da9150_gpadc_vbus_6v_voltage_now(int raw_val)
> +{
> +	/* Convert to uV */
> +	return (((3 * ((raw_val * 1000) + 500)) / 512) * 1000);
> +}
> +
> +static inline int da9150_gpadc_vbus_21v_voltage_now(int raw_val)
> +{
> +	/* Convert to uV */
> +	return (((21 * ((raw_val * 1000) + 500)) / 1024) * 1000);
> +}
> +
> +static inline int da9150_gpadc_vsys_6v_voltage_now(int raw_val)
> +{
> +	/* Convert to uV */
> +	return (((3 * ((raw_val * 1000) + 500)) / 512) * 1000);
> +}
> +
> +static inline int da9150_gpadc_vsys_1_5v_voltage_now(int raw_val)
> +{
> +	/* Convert to uV */
> +	return (((3 * ((raw_val * 1000) + 500)) / 2048) * 1000);
> +}
> +
> +static inline int da9150_gpadc_tjunc_temp(int raw_val)
> +{
> +	/* Convert to 0.1 degrees C */
> +	return (((879 - (1023 - raw_val)) * 10000) / 4420);
Linear in the coeeficients, so fine for raw output with a scale and offset.
> +}
> +
> +static inline int da9150_gpadc_vbat_voltage_now(int raw_val)
> +{
> +	/* Convert to uV */
> +	return ((2932 * raw_val) + 1500000);
> +}
> +
> +int da9150_gpadc_read_process(int channel, int raw_val)
> +{
> +	int ret;
> +
> +	switch (channel) {
> +	case DA9150_GPADC_CHAN_GPIOA_2V:
> +	case DA9150_GPADC_CHAN_GPIOA_2V_:
> +	case DA9150_GPADC_CHAN_GPIOB_2V:
> +	case DA9150_GPADC_CHAN_GPIOB_2V_:
> +	case DA9150_GPADC_CHAN_GPIOC_2V:
> +	case DA9150_GPADC_CHAN_GPIOC_2V_:
> +	case DA9150_GPADC_CHAN_GPIOD_2V:
> +	case DA9150_GPADC_CHAN_GPIOD_2V_:
> +		ret = da9150_gpadc_gpio_2v_voltage_now(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_IBUS_SENSE:
> +	case DA9150_GPADC_CHAN_IBUS_SENSE_:
> +		ret = da9150_gpadc_ibus_current_avg(raw_val);
> +		break;
Ah, so here is your reasoning behind the 'interesting' underscore channels.
This is just doing different range checks on the channel?  If so allow one
at a time and provide a writable scale info_mask element to control which
is used..

Looks like there are only thes two channels doing this, so shouldn't be
too hard to support it via more conventional means.

> +	case DA9150_GPADC_CHAN_VBUS_DIV:
> +		ret = da9150_gpadc_vbus_6v_voltage_now(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_VBUS_DIV_:
> +		ret = da9150_gpadc_vbus_21v_voltage_now(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_VSYS:
> +		ret = da9150_gpadc_vsys_6v_voltage_now(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_VSYS_:
> +		ret = da9150_gpadc_vsys_1_5v_voltage_now(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_GPIOA_5V:
> +	case DA9150_GPADC_CHAN_GPIOA_5V_:
> +	case DA9150_GPADC_CHAN_GPIOB_5V:
> +	case DA9150_GPADC_CHAN_GPIOB_5V_:
> +	case DA9150_GPADC_CHAN_GPIOC_5V:
> +	case DA9150_GPADC_CHAN_GPIOC_5V_:
> +	case DA9150_GPADC_CHAN_GPIOD_5V:
> +	case DA9150_GPADC_CHAN_GPIOD_5V_:
> +		ret = da9150_gpadc_gpio_5v_voltage_now(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_TJUNC_CORE:
> +	case DA9150_GPADC_CHAN_TJUNC_CORE_:
> +	case DA9150_GPADC_CHAN_TJUNC_OVP:
> +	case DA9150_GPADC_CHAN_TJUNC_OVP_:
> +		ret = da9150_gpadc_tjunc_temp(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_VBAT:
> +		ret = da9150_gpadc_vbat_voltage_now(raw_val);
> +		break;
> +	default:
> +		/* No processing for other channels so return raw value */
> +		ret = raw_val;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +int da9150_gpadc_read_raw(struct iio_dev *indio_dev,
> +			  struct iio_chan_spec const *chan,
> +			  int *val, int *val2, long mask)
> +{
> +	struct da9150_gpadc *gpadc = iio_priv(indio_dev);
> +	u8 reg = 0;
> +	u8 result_regs[2];
> +	u16 result;
> +
> +	if ((mask != IIO_CHAN_INFO_RAW) && (mask != IIO_CHAN_INFO_PROCESSED))
> +		return -EINVAL;
> +
> +	if ((chan->channel < DA9150_GPADC_CHAN_GPIOA_2V) ||
> +	    (chan->channel > DA9150_GPADC_CHAN_TJUNC_OVP_))
> +		return -EINVAL;
> +
> +	mutex_lock(&gpadc->lock);
> +
> +	/* Set channel & enable measurement */
> +	reg |= DA9150_GPADC_EN_MASK;
Don't use the |=, just = and you can't avoid assigning reg above.
Actually, it's not complex enough that you couldn't just do it directly into
the write function and skip this local variable.
> +	reg |= chan->channel << DA9150_GPADC_MUX_SHIFT;
> +	da9150_reg_write(gpadc->da9150, DA9150_GPADC_MAN, reg);
> +
> +	/* Consume left-over completion from a previous timeout */
> +	try_wait_for_completion(&gpadc->complete);
> +
> +	/* Check for actual completion */
> +	wait_for_completion_timeout(&gpadc->complete, msecs_to_jiffies(5));
> +
> +	/* Read result and status from device */
> +	da9150_bulk_read(gpadc->da9150, DA9150_GPADC_RES_A, 2, result_regs);
> +
> +	/* Check to make sure device really has completed reading */
> +	if (result_regs[1] & DA9150_GPADC_RUN_MASK) {
> +		mutex_unlock(&gpadc->lock);
Unlock first, then check for error.
> +		dev_err(gpadc->dev, "Timeout on channel %d of GP-ADC\n",
> +			chan->channel);
> +		return -ETIMEDOUT;
> +	}
> +
> +	mutex_unlock(&gpadc->lock);
> +
> +	/* LSBs - 2 bits */
> +	result = (result_regs[1] & DA9150_GPADC_RES_L_MASK) >>
> +		 DA9150_GPADC_RES_L_SHIFT;
The mixture of having defs here for the shift.
> +	/* MSBs - 8 bits */
> +	result |= result_regs[0] << 2;
and not here is inconsistent.  I honestly don't mind which way, but
just use one style.

You could just use an endian conversion and shift the combined 16bit result
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_PROCESSED:
> +		*val = da9150_gpadc_read_process(chan->channel, result);
> +		break;
> +	case IIO_CHAN_INFO_RAW:
> +		*val = result;
> +		break;
> +	}
> +
> +	return IIO_VAL_INT;
> +}
> +
> +
> +static const struct iio_info da9150_gpadc_info = {
> +	.read_raw = &da9150_gpadc_read_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +#define GPADC_CHANNEL(_id, _type, chan_info, _ext_name) {		\
> +	.type = _type,							\
> +	.indexed = 1,							\
> +	.channel = DA9150_GPADC_CHAN_##_id,				\
> +	.info_mask_separate = chan_info,				\
> +	.extend_name = _ext_name,					\
> +	.datasheet_name = #_id,						\
> +}
> +
> +#define GPADC_CHANNEL_RAW(_id, _type, _ext_name)	\
> +	GPADC_CHANNEL(_id, _type, BIT(IIO_CHAN_INFO_RAW), _ext_name)
> +
> +#define GPADC_CHANNEL_RAW_PROCESSED(_id, _type, _ext_name)			\
> +	GPADC_CHANNEL(_id, _type,						\
> +		      BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_PROCESSED),	\
It very rarely makes sense to provide both raw and processed interfaces.
If the transform is nasty and non linear then userspace won't have the info
to do anything with it.  If the transform is linear, then provide scale
and offset and let userspace perform the computation.

> +		      _ext_name)
> +
> +/* Supported channels */
Another comment that doesn't add any information.
> +static const struct iio_chan_spec da9150_gpadc_channels[] = {
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOA_2V, IIO_VOLTAGE, "GPIOA_2V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOA_2V_, IIO_VOLTAGE, "GPIOA_2V_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOB_2V, IIO_VOLTAGE, "GPIOB_2V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOB_2V_, IIO_VOLTAGE, "GPIOB_2V_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOC_2V, IIO_VOLTAGE, "GPIOC_2V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOC_2V_, IIO_VOLTAGE, "GPIOC_2V_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOD_2V, IIO_VOLTAGE, "GPIOD_2V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOD_2V_, IIO_VOLTAGE, "GPIOD_2V_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(IBUS_SENSE, IIO_CURRENT, "IBUS"),
> +	GPADC_CHANNEL_RAW_PROCESSED(IBUS_SENSE_, IIO_CURRENT, "IBUS_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(VBUS_DIV, IIO_VOLTAGE, "VBUS_6V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(VBUS_DIV_, IIO_VOLTAGE, "VBUS_21V"),
> +	GPADC_CHANNEL_RAW(ID, IIO_VOLTAGE, "ID"),
> +	GPADC_CHANNEL_RAW(ID_, IIO_VOLTAGE, "ID_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(VSYS, IIO_VOLTAGE, "VSYS_6V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(VSYS_, IIO_VOLTAGE, "VSYS_1_5V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOA_5V, IIO_VOLTAGE, "GPIOA_5V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOA_5V_, IIO_VOLTAGE, "GPIOA_5V_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOB_5V, IIO_VOLTAGE, "GPIOB_5V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOB_5V_, IIO_VOLTAGE, "GPIOB_5V_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOC_5V, IIO_VOLTAGE, "GPIOC_5V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOC_5V_, IIO_VOLTAGE, "GPIOC_5V_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOD_5V, IIO_VOLTAGE, "GPIOD_5V"),
> +	GPADC_CHANNEL_RAW_PROCESSED(GPIOD_5V_, IIO_VOLTAGE, "GPIOD_5V_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(VBAT, IIO_VOLTAGE, "VBAT"),
> +	GPADC_CHANNEL_RAW_PROCESSED(VBAT_, IIO_VOLTAGE, "VBAT_"),
> +	GPADC_CHANNEL_RAW(TBAT, IIO_VOLTAGE, "TBAT"),
> +	GPADC_CHANNEL_RAW(TBAT_, IIO_VOLTAGE, "TBAT_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(TJUNC_CORE, IIO_TEMP, "TJUNC_CORE"),
> +	GPADC_CHANNEL_RAW_PROCESSED(TJUNC_CORE_, IIO_TEMP, "TJUNC_CORE_"),
> +	GPADC_CHANNEL_RAW_PROCESSED(TJUNC_OVP, IIO_TEMP, "TJUNC_OVP"),
> +	GPADC_CHANNEL_RAW_PROCESSED(TJUNC_OVP_, IIO_TEMP, "TJUNC_OVP_"),
> +};
> +
> +/* Default maps used by da9150-charger */
> +static struct iio_map da9150_gpadc_default_maps[] = {
> +	{
> +		.consumer_dev_name = "da9150-charger",
> +		.consumer_channel = "CHAN_IBUS",
> +		.adc_channel_label = "IBUS_SENSE",
> +	},
> +	{
> +		.consumer_dev_name = "da9150-charger",
> +		.consumer_channel = "CHAN_VBUS",
> +		.adc_channel_label = "VBUS_DIV_",
> +	},
> +	{
> +		.consumer_dev_name = "da9150-charger",
> +		.consumer_channel = "CHAN_TJUNC",
> +		.adc_channel_label = "TJUNC_CORE",
> +	},
> +	{
> +		.consumer_dev_name = "da9150-charger",
> +		.consumer_channel = "CHAN_VBAT",
> +		.adc_channel_label = "VBAT",
> +	},
> +	{},
> +};
> +
> +
> +/*
> + * Driver top level functions
Get rid of this comment and any other ones that don't add any
actual information.  Also this is single line comment, please
check the comment syntax.
> + */
> +
> +static int da9150_gpadc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct da9150 *da9150 = dev_get_drvdata(dev->parent);
> +	struct da9150_gpadc *gpadc;
> +	struct iio_dev *indio_dev;
> +
Why a blank line here.
> +	int ret;
> +
> +	indio_dev = devm_iio_device_alloc(&pdev->dev,
> +					  sizeof(struct da9150_gpadc));
> +	if (!indio_dev) {
> +		dev_err(&pdev->dev, "Failed to allocate IIO device\n");
> +		return -ENOMEM;
> +	}
> +	gpadc = iio_priv(indio_dev);
> +
> +	platform_set_drvdata(pdev, indio_dev);
> +	gpadc->da9150 = da9150;
> +	gpadc->dev = dev;
> +
> +	ret = iio_map_array_register(indio_dev, da9150_gpadc_default_maps);
> +	if (ret) {
> +		dev_err(dev, "Failed to register IIO maps: %d\n", ret);
> +		goto iio_map_fail;
> +	}
> +
> +	indio_dev->name = dev_name(dev);
> +	indio_dev->dev.parent = dev;
> +	indio_dev->dev.of_node = pdev->dev.of_node;
> +	indio_dev->info = &da9150_gpadc_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = da9150_gpadc_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(da9150_gpadc_channels);
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret) {
> +		dev_err(dev, "Failed to register IIO device: %d\n", ret);
> +		goto iio_dev_fail;
> +	}
The device register call is the one that exposes userspace interfaces. As
a general rule it wants to be the last thing in probe as everything
else should be setup first.
> +
> +	mutex_init(&gpadc->lock);
> +	init_completion(&gpadc->complete);
> +
> +	/* Register IRQ */
> +	ret = da9150_register_irq(pdev, gpadc, da9150_gpadc_irq, "GPADC");
> +	if (ret < 0)
> +		goto irq_fail;
> +
> +	da9150->gpadc_ready = true;
> +	return ret;
> +
> +irq_fail:
> +	iio_device_unregister(indio_dev);
> +
> +iio_dev_fail:
> +	iio_map_array_unregister(indio_dev);
> +
> +iio_map_fail:
> +	return ret;
> +}
> +
> +static int da9150_gpadc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	iio_map_array_unregister(indio_dev);
> +	iio_device_unregister(indio_dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver da9150_gpadc_driver = {
> +	.driver = {
> +		.name = "da9150-gpadc",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = da9150_gpadc_probe,
> +	.remove = da9150_gpadc_remove,
> +};
> +
> +module_platform_driver(da9150_gpadc_driver);
> +
> +MODULE_DESCRIPTION("GPADC Driver for DA9150");
> +MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource@diasemi.com");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/da9150/gpadc.h b/include/linux/mfd/da9150/gpadc.h
> new file mode 100644
> index 0000000..3e46164
> --- /dev/null
> +++ b/include/linux/mfd/da9150/gpadc.h
> @@ -0,0 +1,71 @@
> +/*
> + * DA9150 GPADC Driver - GPADC Data
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef _DA9150_GPADC_H
> +#define _DA9150_GPADC_H
> +
> +#include <linux/device.h>
> +#include <linux/iio/machine.h>
This isn't used in the header, so should be included in the c file, not here.

> +#include <linux/mutex.h>
> +#include <linux/completion.h>
> +
> +#include <linux/mfd/da9150/core.h>
Having moved the struct definition into the c file
this header include will not want to be here.
> +
> +
> +/* Channels */
> +enum da9150_gpadc_channel {
> +	DA9150_GPADC_CHAN_GPIOA_2V = 0,
> +	DA9150_GPADC_CHAN_GPIOA_2V_,
> +	DA9150_GPADC_CHAN_GPIOB_2V,
> +	DA9150_GPADC_CHAN_GPIOB_2V_,
> +	DA9150_GPADC_CHAN_GPIOC_2V,
> +	DA9150_GPADC_CHAN_GPIOC_2V_,
> +	DA9150_GPADC_CHAN_GPIOD_2V,
> +	DA9150_GPADC_CHAN_GPIOD_2V_,
> +	DA9150_GPADC_CHAN_IBUS_SENSE,
> +	DA9150_GPADC_CHAN_IBUS_SENSE_,
> +	DA9150_GPADC_CHAN_VBUS_DIV,
> +	DA9150_GPADC_CHAN_VBUS_DIV_,
> +	DA9150_GPADC_CHAN_ID,
> +	DA9150_GPADC_CHAN_ID_,
> +	DA9150_GPADC_CHAN_VSYS,
> +	DA9150_GPADC_CHAN_VSYS_,
> +	DA9150_GPADC_CHAN_GPIOA_5V,
> +	DA9150_GPADC_CHAN_GPIOA_5V_,
> +	DA9150_GPADC_CHAN_GPIOB_5V,
> +	DA9150_GPADC_CHAN_GPIOB_5V_,
> +	DA9150_GPADC_CHAN_GPIOC_5V,
> +	DA9150_GPADC_CHAN_GPIOC_5V_,
> +	DA9150_GPADC_CHAN_GPIOD_5V,
> +	DA9150_GPADC_CHAN_GPIOD_5V_,
> +	DA9150_GPADC_CHAN_VBAT,
> +	DA9150_GPADC_CHAN_VBAT_,
> +	DA9150_GPADC_CHAN_TBAT,
> +	DA9150_GPADC_CHAN_TBAT_,
> +	DA9150_GPADC_CHAN_TJUNC_CORE,
> +	DA9150_GPADC_CHAN_TJUNC_CORE_,
> +	DA9150_GPADC_CHAN_TJUNC_OVP,
> +	DA9150_GPADC_CHAN_TJUNC_OVP_,
> +};
> +
> +
> +/* Private data */
Why is this in the header?  Should be defined directly in the c file
as nothing outside the driver should be touching it.

> +struct da9150_gpadc {
> +	struct da9150 *da9150;
> +	struct device *dev;
> +
> +	struct mutex lock;
> +	struct completion complete;
> +};
> +
> +#endif /* _DA9150_GPADC_H */
> --
> 1.9.3
>

