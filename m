Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaJSTzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 15:55:14 -0400
Received: from mout.gmx.net ([212.227.17.20]:60927 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaJSTzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 15:55:09 -0400
Message-ID: <544416EF.8080603@gmx.de>
Date: Sun, 19 Oct 2014 21:54:23 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Fugang Duan <B38611@freescale.com>,
        Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3] iio: iadc: Qualcomm SPMI PMIC current ADC driver
References: <1412180088-24683-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1412180088-24683-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:MXOHqrq/vK8ThZobHMW5bkEW/eLSpl0ft4sy2RftmVafSkSyIHO
 DKeXfLeSXVakgWXz4LnsWgr8rLYa915hKEQ0DffQw0Kmuo+51raLnOIb38VJlF+HdeP3SZs
 nfhfjQ+yu4FPRZnDKRacHQcQ29e4ysFJ3+yqwCEOyWEwU7qngFYZj3P+bzNvaYm97HonlVz
 H1g+DuEip8UupPyA2sSGQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan T. Ivanov schrieb am 01.10.2014 18:14:
> The current ADC is peripheral of Qualcomm SPMI PMIC chips. It has
> 16 bits resolution and register space inside PMIC accessible across
> SPMI bus.
> 
> The driver registers itself through IIO interface.
> 
Hi, I spotted some issues, see inline.
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
> 
> Changes since v2:
> 
> - DT bindings fixed according comments.
> - IADC driver now register 2 channels instead of just one.
> - Fixed sense resistor Ohms dimensions. It is supposed that
>   values are around 0.010 Ohms not 10 Mega Ohms.
> - Removed direct driver access to registers in Battery Monitor 
>   peripheral address space. Which will impact correct internal
>   sense resistor calculation on some variants and vendors of
>   pm8110 and pm8226. This could be added once we figured out how
>   to pass/read PMIC device version from sub-function drivers.
> 
> v2: http://www.gossamer-threads.com/lists/linux/kernel/2016613
> 
>  .../devicetree/bindings/iio/adc/qcom,spmi-iadc.txt |  46 ++
>  drivers/iio/adc/Kconfig                            |  11 +
>  drivers/iio/adc/Makefile                           |   1 +
>  drivers/iio/adc/qcom-spmi-iadc.c                   | 626 +++++++++++++++++++++
>  4 files changed, 684 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
>  create mode 100644 drivers/iio/adc/qcom-spmi-iadc.c
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
> new file mode 100644
> index 0000000..833afd6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
> @@ -0,0 +1,46 @@
> +Qualcomm's SPMI PMIC current ADC
> +
> +QPNP PMIC current ADC (IADC) provides interface to clients to read current.
> +A 16 bit ADC is used for current measurements. IADC can measure the current
> +through an external resistor(channel 1)or internal(built-in) resistor
There are some whitespaces missing around the parenthesis.
> +(channel 0). When using an external resistor it is to be described by
> +qcom,external-resistor-micro-ohms property.
> +
> +IADC node:
> +
> +- compatible:
> +    Usage: required
> +    Value type: <string>
> +    Definition: Should contain "qcom,spmi-iadc".
> +
> +- reg:
> +    Usage: required
> +    Value type: <prop-encoded-array>
> +    Definition: IADC base address and length in the SPMI PMIC register map
> +
> +- interrupts:
> +    Usage: optional
> +    Value type: <prop-encoded-array>
> +    Definition: End of ADC conversion.
> +
> +- qcom,external-resistor-micro-ohms:
> +    Usage: optional
> +    Value type: <u32>
> +    Definition: Sense resister value in micro Ohm.
> +                If not defined value of 10000 micro Ohms will be used.
> +
> +Example:
> +	/* IADC node */
> +	pmic_iadc: iadc@3600 {
> +		compatible = "qcom,spmi-iadc";
> +		reg = <0x3600 0x100>;
> +		interrupts = <0x0 0x36 0x0 IRQ_TYPE_EDGE_RISING>;
> +		qcom,external-resistor-micro-ohms = <10000>;
> +		#io-channel-cells  = <1>;
> +	};
> +
> +	/* IIO client node */
> +	bat {
> +		io-channels = <&pmic_iadc>;
> +		io-channel-names = "iadc 0";
> +	};
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 11b048a..ee1ad5b 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -206,6 +206,17 @@ config NAU7802
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called nau7802.
>  
> +config QCOM_SPMI_IADC
> +	tristate "Qualcomm SPMI PMIC current ADC"
> +	depends on SPMI
> +	select REGMAP_SPMI
> +	help
> +	  This is the IIO Current ADC driver for Qualcomm QPNP IADC Chip.
> +
> +	  The driver supports single mode operation to read from two
> +	  channels (external or internal). Hardware have additional
> +	  channels internally used for gain and offset calibration.
To compile this driver as a module, choose M here: the module will be called qcom-spmi-iadc.
> +
>  config TI_ADC081C
>  	tristate "Texas Instruments ADC081C021/027"
>  	depends on I2C
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index ad81b51..c790543 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_VF610_ADC) += vf610_adc.o
>  obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
>  xilinx-xadc-y := xilinx-xadc-core.o xilinx-xadc-events.o
>  obj-$(CONFIG_XILINX_XADC) += xilinx-xadc.o
> +obj-$(CONFIG_QCOM_SPMI_IADC) += qcom-spmi-iadc.o
Please sort in your entry in alphabetic order.
> diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
> new file mode 100644
> index 0000000..f4328f2
> --- /dev/null
> +++ b/drivers/iio/adc/qcom-spmi-iadc.c
> @@ -0,0 +1,626 @@
> +/*
> + * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/completion.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/iio/iio.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +
> +/* IADC register and bit definition */
> +#define IADC_REVISION2				0x1
> +#define IADC_REVISION2_SUPPORTED_IADC		1
> +
> +#define IADC_PERPH_TYPE				0x4
> +#define IADC_PERPH_TYPE_ADC			8
> +
> +#define IADC_PERPH_SUBTYPE			0x5
> +#define IADC_PERPH_SUBTYPE_IADC			3
> +
> +#define IADC_STATUS1				0x8
> +#define IADC_STATUS1_OP_MODE			4
> +#define IADC_STATUS1_REQ_STS			BIT(1)
> +#define IADC_STATUS1_EOC			BIT(0)
> +#define IADC_STATUS1_REQ_STS_EOC_MASK		0x3
> +
> +#define IADC_MODE_CTL				0x40
> +#define IADC_OP_MODE_SHIFT			3
> +#define IADC_OP_MODE_NORMAL			0
> +#define IADC_TRIM_EN				BIT(0)
> +
> +#define IADC_EN_CTL1				0x46
> +#define IADC_EN_CTL1_SET			BIT(7)
> +
> +#define IADC_CH_SEL_CTL				0x48
> +
> +#define IADC_DIG_PARAM				0x50
> +#define IADC_DIG_DEC_RATIO_SEL_SHIFT		2
> +
> +#define IADC_HW_SETTLE_DELAY			0x51
> +
> +#define IADC_CONV_REQ				0x52
> +#define IADC_CONV_REQ_SET			BIT(7)
> +
> +#define IADC_FAST_AVG_CTL			0x5a
> +#define IADC_FAST_AVG_EN			0x5b
> +#define IADC_FAST_AVG_EN_SET			BIT(7)
> +
> +#define IADC_PERH_RESET_CTL3			0xda
> +#define IADC_FOLLOW_WARM_RB			BIT(2)
> +
> +#define IADC_DATA0				0x60
> +#define IADC_DATA1				0x61
> +
> +#define IADC_SEC_ACCESS				0xd0
> +#define IADC_SEC_ACCESS_DATA			0xa5
> +
> +#define IADC_NOMINAL_RSENSE			0xf4
> +#define IADC_NOMINAL_RSENSE_SIGN_MASK		BIT(7)
> +
> +#define IADC_REF_GAIN_MICRO_VOLTS		17857
> +
> +#define IADC_INT_RSENSE_DEVIATION		15625	/* nano Ohms per bit */
> +
> +#define IADC_INT_RSENSE_IDEAL_VALUE		10000	/* micro Ohms */
> +#define IADC_INT_RSENSE_DEFAULT_VALUE		7800	/* micro Ohms */
> +#define IADC_INT_RSENSE_DEFAULT_GF		9000	/* micro Ohms */
> +#define IADC_INT_RSENSE_DEFAULT_SMIC		9700	/* micro Ohms */
> +
> +#define IADC_CONV_TIME_MIN_US			2000
> +#define IADC_CONV_TIME_MAX_US			2100
> +
> +#define IADC_DEF_PRESCALING			0 /* 1:1 */
> +#define IADC_DEF_DECIMATION			0 /* 512 */
> +#define IADC_DEF_HW_SETTLE_TIME			0 /* 0 us */
> +#define IADC_DEF_AVG_SAMPLES			0 /* 1 sample */
> +
> +/* IADC channel list */
> +#define IADC_INT_RSENSE				0
> +#define IADC_EXT_RSENSE				1
> +#define IADC_GAIN_17P857MV			3
> +#define IADC_EXT_OFFSET_CSP_CSN			5
> +#define IADC_INT_OFFSET_CSP2_CSN2		6
> +
> +/**
> + * struct iadc_drv - IADC Current ADC device structure.
You actually call it iadc_chip now.
> + * @regmap: regmap for register read/write.
> + * @dev: This device pointer.
> + * @base: base offset for the ADC peripheral.
> + * @rsense: Values of the internal and external sense resister in micro Ohms.
> + * @poll_eoc: Poll for end of conversion instead of waiting for IRQ.
> + * @offset_raw: Raw offset values for the internal and external channels.
> + * @gain_raw: Raw gain of the channels.
> + * @lock: ADC lock for access to the peripheral.
> + * @complete: ADC notification after end of conversion interrupt is received.
> + */
> +struct iadc_chip {
> +	struct regmap	*regmap;
> +	struct device	*dev;
> +	u16		base;
> +	bool		poll_eoc;
> +	int		rsense[2];
An unsigned integer type for rsense seems more appropriate to me, maybe u32?
> +	u16		offset_raw[2];
> +	u16		gain_raw;
> +	struct mutex	lock;
> +	struct completion complete;
> +};
> +
> +static int iadc_read(struct iadc_chip *iadc, u16 offset, u8 *data)
> +{
> +	unsigned int val;
> +	int ret;
> +
> +	ret = regmap_read(iadc->regmap, iadc->base + offset, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	*data = val;
> +	return 0;
> +}
> +
> +static int iadc_write(struct iadc_chip *iadc, u16 offset, u8 data)
> +{
> +	return regmap_write(iadc->regmap, iadc->base + offset, data);
> +}
> +
> +static int iadc_reset(struct iadc_chip *iadc)
> +{
> +	u8 data;
> +	int ret;
> +
> +	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = iadc_read(iadc, IADC_PERH_RESET_CTL3, &data);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
> +	if (ret < 0)
> +		return ret;
> +
> +	data |= IADC_FOLLOW_WARM_RB;
> +
> +	return iadc_write(iadc, IADC_PERH_RESET_CTL3, data);
> +}
> +
> +static int iadc_set_state(struct iadc_chip *iadc, bool state)
> +{
> +	u8 data = 0;
> +
> +	if (state)
> +		data = IADC_EN_CTL1_SET;
> +
> +	return iadc_write(iadc, IADC_EN_CTL1, data);
The whole function body could just be consolidated to one line:
	return iadc_write(iadc, IADC_EN_CTL1, state ? IADC_EN_CTL1_SET : 0);
> +}
> +
> +static void iadc_status_show(struct iadc_chip *iadc)
> +{
> +	u8 mode, sta1, chan, dig, en, req;
> +	int ret;
> +
> +	ret = iadc_read(iadc, IADC_MODE_CTL, &mode);
> +	if (ret < 0)
> +		return;
> +
> +	ret = iadc_read(iadc, IADC_DIG_PARAM, &dig);
> +	if (ret < 0)
> +		return;
> +
> +	ret = iadc_read(iadc, IADC_CH_SEL_CTL, &chan);
> +	if (ret < 0)
> +		return;
> +
> +	ret = iadc_read(iadc, IADC_CONV_REQ, &req);
> +	if (ret < 0)
> +		return;
> +
> +	ret = iadc_read(iadc, IADC_STATUS1, &sta1);
> +	if (ret < 0)
> +		return;
> +
> +	ret = iadc_read(iadc, IADC_EN_CTL1, &en);
> +	if (ret < 0)
> +		return;
> +
> +	dev_err(iadc->dev,
> +		"mode:%02x en:%02x chan:%02x dig:%02x req:%02x sta1:%02x\n",
> +		mode, en, chan, dig, req, sta1);
> +}
> +
> +static int iadc_configure(struct iadc_chip *iadc, int channel)
> +{
> +	u8 decim, mode;
> +	int ret;
> +
> +	/* Mode selection */
> +	mode = (IADC_OP_MODE_NORMAL << IADC_OP_MODE_SHIFT) | IADC_TRIM_EN;
> +	ret = iadc_write(iadc, IADC_MODE_CTL, mode);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Channel selection */
> +	ret = iadc_write(iadc, IADC_CH_SEL_CTL, channel);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Digital parameter setup */
> +	decim = IADC_DEF_DECIMATION << IADC_DIG_DEC_RATIO_SEL_SHIFT;
> +	ret = iadc_write(iadc, IADC_DIG_PARAM, decim);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* HW settle time delay */
> +	ret = iadc_write(iadc, IADC_HW_SETTLE_DELAY, IADC_DEF_HW_SETTLE_TIME);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = iadc_write(iadc, IADC_FAST_AVG_CTL, IADC_DEF_AVG_SAMPLES);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (IADC_DEF_AVG_SAMPLES)
> +		ret = iadc_write(iadc, IADC_FAST_AVG_EN, IADC_FAST_AVG_EN_SET);
> +	else
> +		ret = iadc_write(iadc, IADC_FAST_AVG_EN, 0);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!iadc->poll_eoc)
> +		reinit_completion(&iadc->complete);
> +
> +	ret = iadc_set_state(iadc, true);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Request conversion */
> +	return iadc_write(iadc, IADC_CONV_REQ, IADC_CONV_REQ_SET);
> +}
> +
> +static int iadc_poll_wait_eoc(struct iadc_chip *iadc, int interval_us)
I think unsigned int interval_us would be more appropriate.
> +{
> +	int ret, count, retry;
count and retry should also be unsigned.
> +	u8 sta1;
> +
> +	retry = interval_us / IADC_CONV_TIME_MIN_US;
> +
> +	for (count = 0; count < retry; count++) {
> +		ret = iadc_read(iadc, IADC_STATUS1, &sta1);
> +		if (ret < 0)
> +			return ret;
> +
> +		sta1 &= IADC_STATUS1_REQ_STS_EOC_MASK;
> +		if (sta1 == IADC_STATUS1_EOC)
> +			return 0;
> +
> +		usleep_range(IADC_CONV_TIME_MIN_US, IADC_CONV_TIME_MAX_US);
> +	}
> +
> +	iadc_status_show(iadc);
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int iadc_read_result(struct iadc_chip *iadc, u16 *data)
> +{
> +	u8 lsb, msb;
> +	int ret;
> +
> +	ret = iadc_read(iadc, IADC_DATA0, &lsb);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = iadc_read(iadc, IADC_DATA1, &msb);
> +	if (ret < 0)
> +		return ret;
> +
> +	*data = (msb << 8) | lsb;
> +
> +	return 0;
I think using regmap_bulk_read() would be shorter and easier.
> +}
> +
> +static int iadc_do_conversion(struct iadc_chip *iadc, int chan, u16 *data)
> +{
> +	int wait, ret;
wait should be unsigned.
> +
> +	ret = iadc_configure(iadc, chan);
> +	if (ret < 0)
> +		goto exit;
> +
> +	wait = BIT(IADC_DEF_AVG_SAMPLES) * IADC_CONV_TIME_MIN_US * 2;
> +
> +	if (iadc->poll_eoc) {
> +		ret = iadc_poll_wait_eoc(iadc, wait);
> +	} else {
> +		ret = wait_for_completion_timeout(&iadc->complete, wait);
> +		if (!ret)
> +			ret = -ETIMEDOUT;
> +		else
> +			/* double check conversion status */
> +			ret = iadc_poll_wait_eoc(iadc, IADC_CONV_TIME_MIN_US);
> +	}
> +
> +	if (!ret)
> +		ret = iadc_read_result(iadc, data);
> +exit:
> +	iadc_set_state(iadc, false);
> +	if (ret < 0)
> +		dev_err(iadc->dev, "conversion failed\n");
> +
> +	return ret;
> +}
> +
> +static int iadc_read_raw(struct iio_dev *indio_dev,
> +			 struct iio_chan_spec const *chan,
> +			 int *val, int *val2, long mask)
> +{
> +	struct iadc_chip *iadc = iio_priv(indio_dev);
> +	long isense_ua, vsense_uv, vsense_raw;
vsense_raw perfectly fits into an int. For vsense_uv and isense_ua it depends, if IADC_REF_GAIN_MICRO_VOLTS could ever exceed 32768. But maybe s64 would be the better type for those two, see below.
> +	int ret, sign;
> +	u16 adc_raw;
> +
> +	mutex_lock(&iadc->lock);
I would move it down, as it is just necessary for IIO_CHAN_INFO_RAW.
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		ret = iadc_do_conversion(iadc, chan->channel, &adc_raw);
> +		if (ret < 0)
> +			goto exit;
> +
> +		vsense_raw = adc_raw - iadc->offset_raw[chan->channel];
> +
> +		vsense_uv = vsense_raw * IADC_REF_GAIN_MICRO_VOLTS;
> +		vsense_uv /= iadc->gain_raw - iadc->offset_raw[chan->channel];
> +
> +		sign = 1;
> +		if (vsense_uv < 0)
> +			sign = -1;
If it is really necessary to use sign, why not just:
		sign = (vsense_uv < 0) -1 : 1;
> +
> +		isense_ua = sign * vsense_uv;
> +
> +		do_div(isense_ua, iadc->rsense[chan->channel]);
I don't really understand, why you use do_div, since you discard the remainder. Wouldn't the following do the same, without removing the sign and applying it again, later?
		isense_ua = div_s64(vsense_uv, iadc->rsense[chan->channel]);
> +
> +		isense_ua = sign * isense_ua;
> +
> +		dev_dbg(iadc->dev, "offset %d, gain %d, adc %d, V=%ld,uV, I=%ld,uA\n",
> +			iadc->offset_raw[chan->channel], iadc->gain_raw,
> +			adc_raw, vsense_uv, isense_ua);
> +
> +		*val = isense_ua;
> +		ret = IIO_VAL_INT;
> +		break;
> +	case IIO_CHAN_INFO_SCALE:
> +		*val = 0;
> +		*val2 = 1000;
> +		ret = IIO_VAL_INT_PLUS_MICRO;
With the mutex_lock just for IIO_CHAN_INFO_RAW, you could return directly here.
> +		break;
> +	default:
> +		ret = -EINVAL;
And here as well.
> +		break;
> +	}
> +
> +exit:
> +	mutex_unlock(&iadc->lock);
> +
> +	return ret;
> +}
> +
> +static const struct iio_info iadc_info = {
> +	.read_raw = iadc_read_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +static irqreturn_t iadc_isr(int irq, void *dev_id)
> +{
> +	struct iadc_chip *iadc = dev_id;
> +
> +	complete(&iadc->complete);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int iadc_update_offset(struct iadc_chip *iadc)
> +{
> +	int ret;
> +
> +	ret = iadc_do_conversion(iadc, IADC_GAIN_17P857MV, &iadc->gain_raw);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = iadc_do_conversion(iadc, IADC_INT_OFFSET_CSP2_CSN2,
> +				 &iadc->offset_raw[IADC_INT_RSENSE]);
> +	if (ret < 0)
> +		return ret;
> +
> +	if ((iadc->gain_raw - iadc->offset_raw[IADC_INT_RSENSE]) == 0) {
Just: if (iadc->gain_raw == iadc->offset_raw[IADC_INT_RSENSE]) {
> +		dev_err(iadc->dev, "error: internal offset %d gain %d\n",
> +			iadc->offset_raw[IADC_INT_RSENSE], iadc->gain_raw);
> +		return -EINVAL;
> +	}
> +
> +	ret = iadc_do_conversion(iadc, IADC_EXT_OFFSET_CSP_CSN,
> +				 &iadc->offset_raw[IADC_EXT_RSENSE]);
> +	if (ret < 0)
> +		return ret;
> +
> +	if ((iadc->gain_raw - iadc->offset_raw[IADC_EXT_RSENSE]) == 0) {
Same here: if (iadc->gain_raw == iadc->offset_raw[IADC_EXT_RSENSE]) {
> +		dev_err(iadc->dev, "error: external offset %d gain %d\n",
> +			iadc->offset_raw[IADC_EXT_RSENSE], iadc->gain_raw);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int iadc_version_check(struct iadc_chip *iadc)
> +{
> +	u8 revision, type, subtype;
You could just use one variable and recylce it.
> +	int ret;
> +
> +	ret = iadc_read(iadc, IADC_PERPH_TYPE, &type);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (type < IADC_PERPH_TYPE_ADC) {
> +		dev_err(iadc->dev, "%d is not ADC\n", type);
> +		return -EINVAL;
> +	}
> +
> +	ret = iadc_read(iadc, IADC_PERPH_SUBTYPE, &subtype);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (subtype < IADC_PERPH_SUBTYPE_IADC) {
> +		dev_err(iadc->dev, "%d is not IADC\n", subtype);
> +		return -EINVAL;
> +	}
> +
> +	ret = iadc_read(iadc, IADC_REVISION2, &revision);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (revision < IADC_REVISION2_SUPPORTED_IADC) {
> +		dev_err(iadc->dev, "revision %d not supported\n", revision);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int iadc_rsense_read(struct iadc_chip *iadc, struct device_node *node)
> +{
> +	int ret, sign, int_sense;
> +	u8 deviation;
> +
> +	ret = of_property_read_u32(node, "qcom,external-resistor-micro-ohms",
> +				   &iadc->rsense[IADC_EXT_RSENSE]);
> +	if (ret < 0)
> +		iadc->rsense[IADC_EXT_RSENSE] = IADC_INT_RSENSE_IDEAL_VALUE;
> +
> +	if (!iadc->rsense[IADC_EXT_RSENSE]) {
> +		dev_err(iadc->dev, "qcom,external-resistor-micro-ohms can't be 0");
This exceeds the 80 character per line limit.
> +		return -EINVAL;
> +	}
> +
> +	ret = iadc_read(iadc, IADC_NOMINAL_RSENSE, &deviation);
> +	if (ret < 0)
> +		return ret;
> +
> +	sign = 1;
> +	if (deviation & IADC_NOMINAL_RSENSE_SIGN_MASK)
> +		sign = -1;
Or simply: sign = (deviation & IADC_NOMINAL_RSENSE_SIGN_MASK) ? -1 : 1;
> +
> +	deviation &= ~IADC_NOMINAL_RSENSE_SIGN_MASK;
What is actually the format of deviation, when read from the device, signed magnitude representation format? Putting a comment about this could be a good idea.
> +
> +	int_sense = IADC_INT_RSENSE_IDEAL_VALUE * 1000;
> +	int_sense += sign * deviation * IADC_INT_RSENSE_DEVIATION;
> +	int_sense /= 1000; /* micro Ohms */
> +
> +	iadc->rsense[IADC_INT_RSENSE] = int_sense;
> +
> +	return 0;
> +}
> +
> +static const struct iio_chan_spec iadc_channels[] = {
> +	{
> +		.type = IIO_CURRENT,
> +		.datasheet_name	= "INTERNAL_RSENSE",
> +		.channel = 0,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> +				      BIT(IIO_CHAN_INFO_SCALE),
> +		.indexed = 1,
> +	},
> +	{
> +		.type = IIO_CURRENT,
> +		.datasheet_name	= "EXTERNAL_RSENSE",
> +		.channel = 1,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> +				      BIT(IIO_CHAN_INFO_SCALE),
> +		.indexed = 1,
> +	},
> +};
> +
> +static int iadc_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct iio_dev *indio_dev;
> +	struct iadc_chip *iadc;
> +	int ret, irq_eoc, res[2];
Better use u32 for res?
> +
> +	indio_dev = devm_iio_device_alloc(dev, sizeof(*iadc));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	iadc = iio_priv(indio_dev);
> +	iadc->dev = dev;
> +
> +	iadc->regmap = dev_get_regmap(dev->parent, NULL);
> +	if (!iadc->regmap)
> +		return -ENODEV;
> +
> +	init_completion(&iadc->complete);
> +	mutex_init(&iadc->lock);
> +
> +	platform_set_drvdata(pdev, iadc);
Is this really necessary?
> +
> +	ret = of_property_read_u32_array(node, "reg", res, 2);
I don't see, where res[1] gets used, so is it really necessary to read it (and have it defined as array)?
> +	if (ret < 0)
> +		return -ENODEV;
> +
> +	iadc->base = res[0];
> +
> +	ret = iadc_version_check(iadc);
> +	if (ret < 0)
> +		return -ENODEV;
> +
> +	ret = iadc_rsense_read(iadc, node);
> +	if (ret < 0)
> +		return -ENODEV;
> +
> +	dev_dbg(iadc->dev, "sense resistors %d and %d micro Ohm\n",
> +		iadc->rsense[IADC_INT_RSENSE],
> +		iadc->rsense[IADC_EXT_RSENSE]);
> +
> +	irq_eoc = platform_get_irq(pdev, 0);
> +	if (irq_eoc == -EPROBE_DEFER)
> +		return irq_eoc;
> +
> +	if (irq_eoc < 0)
> +		iadc->poll_eoc = true;
> +
> +	ret = iadc_reset(iadc);
> +	if (ret < 0) {
> +		dev_err(dev, "reset failed\n");
> +		return ret;
> +	}
> +
> +	if (!iadc->poll_eoc) {
> +		ret = devm_request_irq(dev, irq_eoc, iadc_isr, 0,
> +					"spmi-iadc", iadc);
> +		if (!ret)
> +			enable_irq_wake(irq_eoc);
> +		else
> +			return ret;
> +	} else {
> +		device_init_wakeup(iadc->dev, 1);
> +	}
> +
> +	ret = iadc_update_offset(iadc);
> +	if (ret < 0) {
> +		dev_err(dev, "failed offset calibration\n");
> +		return ret;
> +	}
> +
> +	indio_dev->dev.parent = dev;
> +	indio_dev->dev.of_node = node;
> +	indio_dev->name = pdev->name;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->info = &iadc_info;
> +	indio_dev->channels = iadc_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(iadc_channels);
> +
> +	return devm_iio_device_register(dev, indio_dev);
> +}
> +
> +static const struct of_device_id iadc_match_table[] = {
> +	{ .compatible = "qcom,spmi-iadc" },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, iadc_match_table);
> +
> +static struct platform_driver iadc_driver = {
> +	.driver = {
> +		   .name = "spmi-iadc",
> +		   .of_match_table = iadc_match_table,
> +	},
> +	.probe = iadc_probe,
> +};
> +
> +module_platform_driver(iadc_driver);
> +
> +MODULE_ALIAS("platform:spmi-iadc");
> +MODULE_DESCRIPTION("Qualcomm SPMI PMIC current ADC driver");
> +MODULE_LICENSE("GPL v2");
> 

