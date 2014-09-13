Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaIMR2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 13:28:03 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48377 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaIMR17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 13:27:59 -0400
Message-ID: <54147E97.60808@kernel.org>
Date: Sat, 13 Sep 2014 18:27:51 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Stanimir Varbanov <svarbanov@mm-sol.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v2 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
References: <1410448403-19402-1-git-send-email-svarbanov@mm-sol.com> <1410448403-19402-2-git-send-email-svarbanov@mm-sol.com> <54138151.8010902@gmx.de>
In-Reply-To: <54138151.8010902@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/14 00:27, Hartmut Knaack wrote:
> Stanimir Varbanov schrieb, Am 11.09.2014 17:13:
>> The voltage ADC is peripheral of Qualcomm SPMI PMIC chips. It has
>> 15bits resolution and register space inside PMIC accessible across
>> SPMI bus.
>>
>> The vadc driver registers itself through IIO interface.
>>
> Looks already pretty good. Things you should consider in regard of common coding style are to use the variable name ret instead of rc, since it is used in almost all adc drivers and thus makes reviewing a bit easier. Besides that, you seem to use unsigned as well as unsigned int, so to be consistent, please stick to one of them. Other comments in line.

A few additional comments from me.  My biggest question is whether
you are actually making life difficult for yourself by having
vadc_channels and vadc->channels (don't like the similar naming btw!)
in different orders.  I think you can move the ordering into the device
tree reading code rather than doing it in lots of other places.  Hence
rather than an order based on the device tree description, put the
data into a fixed ofer in vadc->channels.

Entirely possible I'm missing something though :)
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>> ---
>>  drivers/iio/adc/Kconfig                       |   11 +
>>  drivers/iio/adc/Makefile                      |    1 +
>>  drivers/iio/adc/qcom-spmi-vadc.c              |  999 +++++++++++++++++++++++++
>>  include/dt-bindings/iio/qcom,spmi-pmic-vadc.h |  119 +++
>>  4 files changed, 1130 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
>>  create mode 100644 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
>>
>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>> index 11b048a..08700d4 100644
>> --- a/drivers/iio/adc/Kconfig
>> +++ b/drivers/iio/adc/Kconfig
>> @@ -206,6 +206,17 @@ config NAU7802
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called nau7802.
>>
>> +config QCOM_SPMI_VADC
>> +	tristate "Qualcomm SPMI PMIC voltage ADC"
>> +	depends on SPMI
>> +	help
>> +	  Say yes here if you want support for the Qualcomm SPMI PMIC voltage ADC.
>> +
>> +	  The driver supports reading the HKADC, XOADC through the ADC AMUX arbiter.
>> +	  The VADC includes support for the conversion sequencer. The driver
>> +	  supports reading the ADC through the AMUX channels for external pull-ups
>> +	  simultaneously.
>> +
>>  config TI_ADC081C
>>  	tristate "Texas Instruments ADC081C021/027"
>>  	depends on I2C
>> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
>> index ad81b51..d5d18f4 100644
>> --- a/drivers/iio/adc/Makefile
>> +++ b/drivers/iio/adc/Makefile
>> @@ -22,6 +22,7 @@ obj-$(CONFIG_MCP320X) += mcp320x.o
>>  obj-$(CONFIG_MCP3422) += mcp3422.o
>>  obj-$(CONFIG_MEN_Z188_ADC) += men_z188_adc.o
>>  obj-$(CONFIG_NAU7802) += nau7802.o
>> +obj-$(CONFIG_QCOM_SPMI_VADC) += qcom-spmi-vadc.o
>>  obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
>>  obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
>>  obj-$(CONFIG_TWL4030_MADC) += twl4030-madc.o
>> diff --git a/drivers/iio/adc/qcom-spmi-vadc.c b/drivers/iio/adc/qcom-spmi-vadc.c
>> new file mode 100644
>> index 0000000..e30eb04
>> --- /dev/null
>> +++ b/drivers/iio/adc/qcom-spmi-vadc.c
>> @@ -0,0 +1,999 @@
>> +/*
>> + * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/bitops.h>
>> +#include <linux/completion.h>
>> +#include <linux/delay.h>
>> +#include <linux/err.h>
>> +#include <linux/iio/iio.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/slab.h>
>> +#include <linux/log2.h>
>> +
>> +#include <dt-bindings/iio/qcom,spmi-pmic-vadc.h>
>> +
>> +/* VADC register and bit definition */
>> +#define VADC_REVISION2				0x1
>> +#define VADC_REVISION2_SUPPORTED_VADC		1
>> +
>> +#define VADC_PERPH_TYPE				0x4
>> +#define VADC_PERPH_TYPE_ADC			8
>> +
>> +#define VADC_PERPH_SUBTYPE			0x5
>> +#define VADC_PERPH_SUBTYPE_VADC			1
>> +
>> +#define VADC_STATUS1				0x8
>> +#define VADC_STATUS1_OP_MODE			4
>> +#define VADC_STATUS1_REQ_STS			BIT(1)
>> +#define VADC_STATUS1_EOC			BIT(0)
>> +#define VADC_STATUS1_REQ_STS_EOC_MASK		0x3
>> +
>> +#define VADC_MODE_CTL				0x40
>> +#define VADC_OP_MODE_SHIFT			3
>> +#define VADC_OP_MODE_NORMAL			0
>> +#define VADC_AMUX_TRIM_EN			BIT(1)
>> +#define VADC_ADC_TRIM_EN			BIT(0)
>> +
>> +#define VADC_EN_CTL1				0x46
>> +#define VADC_EN_CTL1_SET			BIT(7)
>> +
>> +#define VADC_ADC_CH_SEL_CTL			0x48
>> +
>> +#define VADC_ADC_DIG_PARAM			0x50
>> +#define VADC_ADC_DIG_DEC_RATIO_SEL_SHIFT	2
>> +
>> +#define VADC_HW_SETTLE_DELAY			0x51
>> +
>> +#define VADC_CONV_REQ				0x52
>> +#define VADC_CONV_REQ_SET			BIT(7)
>> +
>> +#define VADC_FAST_AVG_CTL			0x5a
>> +#define VADC_FAST_AVG_EN			0x5b
>> +#define VADC_FAST_AVG_EN_SET			BIT(7)
>> +
>> +#define VADC_ACCESS				0xd0
>> +#define VADC_ACCESS_DATA			0xa5
>> +
>> +#define VADC_PERH_RESET_CTL3			0xda
>> +#define VADC_FOLLOW_WARM_RB			BIT(2)
>> +
>> +#define VADC_DATA0				0x60
>> +#define VADC_DATA1				0x61
>> +
>> +#define VADC_CONV_TIME_MIN_US			2000
>> +#define VADC_CONV_TIME_MAX_US			2100
>> +
>> +/* Min ADC code represents 0V */
>> +#define VADC_MIN_ADC_CODE			0x6000
>> +/* Max ADC code represents full-scale range of 1.8V */
>> +#define VADC_MAX_ADC_CODE			0xA800
>> +
>> +#define VADC_ABSOLUTE_RANGE_UV			625000
>> +#define VADC_RATIOMETRIC_RANGE_UV		1800000
>> +
>> +#define VADC_DEF_PRESCALING			0 /* 1:1 */
>> +#define VADC_DEF_DECIMATION			0 /* 512 */
>> +#define VADC_DEF_HW_SETTLE_TIME			0 /* 0 us */
>> +#define VADC_DEF_AVG_SAMPLES			0 /* 1 sample */
>> +#define VADC_DEF_CALIB_TYPE			VADC_CALIB_ABSOLUTE
>> +
>> +#define VADC_DECIMATION_MIN			512
>> +#define VADC_DECIMATION_MAX			4096
>> +
>> +#define VADC_HW_SETTLE_DELAY_MAX		10000
>> +#define VADC_AVG_SAMPLES_MAX			512
>> +
>> +/*
>> + * VADC_CALIB_ABSOLUTE: Uses the 625mV and 1.25V reference channels.
>> + * VADC_CALIB_RATIOMETRIC: Uses the reference Voltage/GND for calibration.
>> + */
>> +enum vadc_calibration {
>> +	VADC_CALIB_ABSOLUTE = 0,
>> +	VADC_CALIB_RATIOMETRIC
>> +};
>> +
>> +/**
>> + * struct vadc_linear_graph - Represent ADC characteristics.
>> + * @dy: Numerator slope to calculate the gain.
>> + * @dx: Denominator slope to calculate the gain.
>> + * @vref: A/D word of the voltage reference used for the channel.
>> + * @gnd: A/D word of the ground reference used for the channel.
>> + *
>> + * Each ADC device has different offset and gain parameters which are
>> + * computed to calibrate the device.
>> + */
>> +struct vadc_linear_graph {
>> +	s32 dy;
>> +	s32 dx;
>> +	s32 vref;
>> +	s32 gnd;
>> +};
>> +
>> +/**
>> + * struct vadc_prescaling - Represent scaling ratio for ADC input.
>> + * @num: The inverse numerator of the gain applied to the input channel.
>> + * @den: The inverse denominator of the gain applied to the input channel.
>> + */
>> +struct vadc_prescaling {
>> +	u32 num;
>> +	u32 den;
>> +};
>> +
>> +/**
>> + * struct vadc_result - Represent the res of the QPNP ADC.
> ... Represents the result...
>> + * @adc_code: The pre-calibrated digital output of a given ADC relative to the
>> + *	the ADC reference.
>> + * @measurement: In units specific for a given ADC; most ADC uses reference
>> + *	voltage but some ADC uses reference current. This measurement
>> + *	here is a number relative to a reference of a given ADC.
>> + * @physical: The data meaningful for each individual channel whether it is
>> + *      voltage, current, temperature, etc.
>> + */
>> +struct vadc_result {
>> +	s32 adc_code;
>> +	s64 measurement;
>> +	s64 physical;
>> +};
>> +
>> +/**
>> + * struct vadc_channel - QPNP VADC amux channel property.
>> + * @number - Channel number, refer to the channel list.
>> + * @calibration - Calibration type.
>> + * @decimation - Sampling rate supported for the channel.
>> + * @prescaling - Channel scaling performed on the input signal.
>> + * @hw_settle_time - The time between AMUX being configured and the
>> + *	start of conversion.
>> + * @avg_samples - Ability to provide single result from the ADC
>> + *	that is an average of multiple measurements.
>> + */
>> +struct vadc_channel {
>> +	int number;
>> +	enum vadc_calibration calibration;
>> +	unsigned decimation;
>> +	unsigned prescaling;
>> +	unsigned hw_settle_time;
>> +	unsigned avg_samples;
>> +};
>> +
>> +/**
>> + * struct vadc_priv - VADC private structure.
>> + * @regmap - pointer to struct regmap
>> + * @dev - pointer to struct device.
>> + * @base - base address for the ADC peripheral.
>> + * @nchannels - number of ADC channels
> Missing period at end of line of @regmap and @nchannels.
>> + * @channels - AMUX properties representing the ADC peripheral.
>> + * @is_ref_measured - does reference points are measured.
> This is expressed wrong.
>> + * @poll_eoc - do we use polling instead of interrupt.
>> + * @complete - ADC result notification after interrupt is received.
>> + * @graph - store parameters for calibration.
>> + */
>> +struct vadc_priv {
>> +	struct regmap *regmap;
>> +	struct device *dev;
>> +	u16 base;
>> +	unsigned nchannels;
>> +	struct vadc_channel *channels;
>> +	bool is_ref_measured;
>> +	bool poll_eoc;
>> +	struct completion complete;
>> +	struct vadc_linear_graph graph[2];
>> +};
>> +
>> +static const struct vadc_prescaling vadc_prescale[] = {
>> +	{1,  1},
>> +	{1,  3},
>> +	{1,  4},
>> +	{1,  6},
>> +	{1,  20},
>> +	{1,  8},
>> +	{10, 81},
>> +	{1,  10}
>> +};
>> +
>> +static int vadc_read(struct vadc_priv *vadc, u16 offset, u8 *data)
>> +{
>> +	return regmap_bulk_read(vadc->regmap, vadc->base + offset, data, 1);
>> +}
>> +
>> +static int vadc_write(struct vadc_priv *vadc, u16 offset, u8 data)
>> +{
>> +	return regmap_write(vadc->regmap, vadc->base + offset, data);
>> +}
>> +
>> +static int vadc_reset(struct vadc_priv *vadc)
>> +{
>> +	u8 data;
>> +	int rc;
>> +
>> +	rc = vadc_write(vadc, VADC_ACCESS, VADC_ACCESS_DATA);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = vadc_read(vadc, VADC_PERH_RESET_CTL3, &data);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = vadc_write(vadc, VADC_ACCESS, VADC_ACCESS_DATA);
>> +	if (rc)
>> +		return rc;
>> +
>> +	data |= VADC_FOLLOW_WARM_RB;
>> +
>> +	return vadc_write(vadc, VADC_PERH_RESET_CTL3, data);
>> +}
>> +
>> +static int vadc_enable(struct vadc_priv *vadc, bool state)
>> +{
>> +	return vadc_write(vadc, VADC_EN_CTL1, state ? VADC_EN_CTL1_SET : 0);
>> +}
>> +
>> +static int vadc_request_conversion(struct vadc_priv *vadc)
>> +{
>> +	return vadc_write(vadc, VADC_CONV_REQ, VADC_CONV_REQ_SET);
>> +}
>> +
>> +static void vadc_status_show(struct vadc_priv *vadc)
>> +{
>> +	u8 mode, sta1, chan, dig, en, req;
>> +	int rc;
>> +
>> +	rc = vadc_read(vadc, VADC_MODE_CTL, &mode);
>> +	if (rc)
>> +		return;
>> +
>> +	rc = vadc_read(vadc, VADC_ADC_DIG_PARAM, &dig);
>> +	if (rc)
>> +		return;
>> +
>> +	rc = vadc_read(vadc, VADC_ADC_CH_SEL_CTL, &chan);
>> +	if (rc)
>> +		return;
>> +
>> +	rc = vadc_read(vadc, VADC_CONV_REQ, &req);
>> +	if (rc)
>> +		return;
>> +
>> +	rc = vadc_read(vadc, VADC_STATUS1, &sta1);
>> +	if (rc)
>> +		return;
>> +
>> +	rc = vadc_read(vadc, VADC_EN_CTL1, &en);
>> +	if (rc)
>> +		return;
>> +
>> +	dev_dbg(vadc->dev,
>> +		"mode:%02x en:%02x chan:%02x dig:%02x req:%02x sta1:%02x\n",
>> +		mode, en, chan, dig, req, sta1);
>> +}
>> +
>> +static int vadc_configure(struct vadc_priv *vadc, struct vadc_channel *vchan)
>> +{
>> +	u8 decim, mode_ctrl;
>> +	int rc;
>> +
>> +	/* Mode selection */
>> +	mode_ctrl = (VADC_OP_MODE_NORMAL << VADC_OP_MODE_SHIFT) |
>> +		     VADC_ADC_TRIM_EN | VADC_AMUX_TRIM_EN;
>> +	rc = vadc_write(vadc, VADC_MODE_CTL, mode_ctrl);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/* Channel selection */
>> +	rc = vadc_write(vadc, VADC_ADC_CH_SEL_CTL, vchan->number);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/* Digital parameter setup */
>> +	decim = vchan->decimation << VADC_ADC_DIG_DEC_RATIO_SEL_SHIFT;
>> +	rc = vadc_write(vadc, VADC_ADC_DIG_PARAM, decim);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/* HW settle time delay */
>> +	rc = vadc_write(vadc, VADC_HW_SETTLE_DELAY, vchan->hw_settle_time);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = vadc_write(vadc, VADC_FAST_AVG_CTL, vchan->avg_samples);
>> +	if (rc)
>> +		return rc;
>> +
>> +	if (vchan->avg_samples)
>> +		rc = vadc_write(vadc, VADC_FAST_AVG_EN, VADC_FAST_AVG_EN_SET);
>> +	else
>> +		rc = vadc_write(vadc, VADC_FAST_AVG_EN, 0);
>> +
>> +	return rc;
>> +}
>> +
>> +static int vadc_poll_wait_eoc(struct vadc_priv *vadc, unsigned int interval_us)
>> +{
>> +	unsigned int count, retry;
>> +	u8 sta1;
>> +	int rc;
>> +
>> +	retry = interval_us / VADC_CONV_TIME_MIN_US;
>> +
>> +	for (count = 0; count < retry; count++) {
>> +		rc = vadc_read(vadc, VADC_STATUS1, &sta1);
>> +		if (rc)
>> +			return rc;
>> +
>> +		sta1 &= VADC_STATUS1_REQ_STS_EOC_MASK;
>> +		if (sta1 == VADC_STATUS1_EOC)
>> +			return 0;
>> +
>> +		usleep_range(VADC_CONV_TIME_MIN_US, VADC_CONV_TIME_MAX_US);
>> +	}
>> +
>> +	vadc_status_show(vadc);
>> +
>> +	return -ETIMEDOUT;
>> +}
>> +
>> +static int vadc_read_result(struct vadc_priv *vadc, u32 *data)
>> +{
>> +	u8 lsb, msb;
>> +	int rc;
>> +
>> +	rc = vadc_read(vadc, VADC_DATA0, &lsb);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = vadc_read(vadc, VADC_DATA1, &msb);
> Better have a wrapper function vadc_read_word()?
>> +	if (rc)
>> +		return rc;
>> +
>> +	*data = clamp_t(u32, (msb << 8) | lsb, VADC_MIN_ADC_CODE,
>> +			VADC_MAX_ADC_CODE);
> Although Peter suggested to use u32 for *data, I think it would be cleaner to use s32 here. It would be more consistent, as *data is s32 in vadc_do_conversion() as well as read_1 and read_2 in vadc_measure_reference_points(). It seems messy to me to pass a s32 by reference to a function, which expects a reference to an u32.
> Any other opinions on this?
>> +
>> +	return 0;
>> +}
>> +
>> +static struct vadc_channel *vadc_find_channel(struct vadc_priv *vadc, int num)
>> +{
>> +	unsigned i;
>> +
>> +	for (i = 0; i < vadc->nchannels; i++)
>> +		if (vadc->channels[i].number == num)
>> +			return &vadc->channels[num];
>> +
>> +	dev_dbg(vadc->dev, "no such channel %02x\n", num);
>> +
>> +	return NULL;
>> +}
>> +
>> +static int vadc_do_conversion(struct vadc_priv *vadc,
>> +			      struct vadc_channel *vchan, s32 *data)
>> +{
>> +	unsigned int timeout;
>> +	int rc;
>> +
>> +	rc = vadc_configure(vadc, vchan);
>> +	if (rc)
>> +		return rc;
>> +
>> +	if (!vadc->poll_eoc)
>> +		reinit_completion(&vadc->complete);
>> +
>> +	rc = vadc_enable(vadc, true);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = vadc_request_conversion(vadc);
>> +	if (rc)
>> +		goto err_disable;
>> +
>> +	timeout = BIT(vchan->avg_samples) * VADC_CONV_TIME_MIN_US * 2;
>> +
>> +	if (vadc->poll_eoc) {
>> +		rc = vadc_poll_wait_eoc(vadc, timeout);
>> +	} else {
>> +		rc = wait_for_completion_timeout(&vadc->complete,
>> +						 msecs_to_jiffies(1000));
>> +		if (!rc) {
>> +			rc = -ETIMEDOUT;
>> +			goto err_disable;
>> +		}
>> +
>> +		/* double check conversion status */
>> +		rc = vadc_poll_wait_eoc(vadc, VADC_CONV_TIME_MIN_US * 2);
>> +		if (rc)
>> +			goto err_disable;
>> +	}
>> +
>> +	rc = vadc_read_result(vadc, data);
>> +
>> +err_disable:
>> +	vadc_enable(vadc, false);
>> +
>> +	if (rc)
>> +		dev_dbg(vadc->dev, "conversion failed\n");
>> +
>> +	return rc;
>> +}
>> +
>> +static int vadc_measure_reference_points(struct vadc_priv *vadc)
>> +{
>> +	struct vadc_channel *vchan;
>> +	s32 read_1, read_2;
>> +	int rc = -EINVAL;
>> +
>> +	vadc->graph[VADC_CALIB_RATIOMETRIC].dx = VADC_RATIOMETRIC_RANGE_UV;
>> +	vadc->graph[VADC_CALIB_ABSOLUTE].dx = VADC_ABSOLUTE_RANGE_UV;
>> +
>> +	vchan = vadc_find_channel(vadc, VADC_REF_1250MV);
>> +	if (!vchan)
>> +		goto err;
>> +
>> +	rc = vadc_do_conversion(vadc, vchan, &read_1);
>> +	if (rc)
>> +		goto err;
>> +
>> +	/* Try with buffered 625mV channel first */
>> +	vchan = vadc_find_channel(vadc, VADC_SPARE1);
>> +	if (!vchan) {
>> +		vchan = vadc_find_channel(vadc, VADC_REF_625MV);
>> +		if (!vchan) {
>> +			rc = -EINVAL;
>> +			goto err;
>> +		}
>> +	}
>> +
>> +	rc = vadc_do_conversion(vadc, vchan, &read_2);
>> +	if (rc)
>> +		goto err;
>> +
>> +	if (read_1 == read_2) {
>> +		rc = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	vadc->graph[VADC_CALIB_ABSOLUTE].dy = read_1 - read_2;
>> +	vadc->graph[VADC_CALIB_ABSOLUTE].vref = read_1;
>> +	vadc->graph[VADC_CALIB_ABSOLUTE].gnd = read_2;
>> +
>> +	/* Ratiometric calibration */
>> +	vchan = vadc_find_channel(vadc, VADC_VDD_VADC);
>> +	if (!vchan) {
>> +		rc = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	rc = vadc_do_conversion(vadc, vchan, &read_1);
>> +	if (rc)
>> +		goto err;
>> +
>> +	vchan = vadc_find_channel(vadc, VADC_GND_REF);
>> +	if (!vchan) {
>> +		rc = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	rc = vadc_do_conversion(vadc, vchan, &read_2);
>> +	if (rc)
>> +		goto err;
>> +
>> +	if (read_1 == read_2) {
>> +		rc = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	vadc->graph[VADC_CALIB_RATIOMETRIC].dy = read_1 - read_2;
>> +	vadc->graph[VADC_CALIB_RATIOMETRIC].vref = read_1;
>> +	vadc->graph[VADC_CALIB_RATIOMETRIC].gnd = read_2;
>> +err:
>> +	if (rc)
>> +		dev_dbg(vadc->dev, "measure reference points failed\n");
>> +
>> +	return rc;
>> +}
>> +
>> +static void vadc_calibrate(struct vadc_priv *vadc,
>> +			   const struct vadc_channel *vchan,
>> +			   struct vadc_result *res)
>> +{
>> +	const struct vadc_prescaling *prescale;
>> +	bool negative = false;
>> +	s64 voltage;
>> +
>> +	voltage = res->adc_code - vadc->graph[vchan->calibration].gnd;
>> +	voltage *= vadc->graph[vchan->calibration].dx;
>> +
>> +	if (voltage < 0) {
>> +		negative = true;
>> +		voltage = -voltage;
>> +	}
>> +
>> +	do_div(voltage, vadc->graph[vchan->calibration].dy);
>> +	if (negative)
>> +		voltage = -voltage;
>> +
>> +	if (vchan->calibration == VADC_CALIB_ABSOLUTE)
>> +		voltage += vadc->graph[vchan->calibration].dx;
>> +
>> +	if (voltage < 0)
>> +		voltage = 0;
>> +
>> +	prescale = &vadc_prescale[vchan->prescaling];
>> +
>> +	res->measurement = voltage * prescale->den;
>> +
>> +	do_div(res->measurement, prescale->num);
>> +
>> +	res->physical = res->measurement;
>> +}
>> +
>> +static unsigned vadc_decimation_from_dt(unsigned int value)
> static int vadc_decimation_from_dt
>> +{
>> +	if (!is_power_of_2(value) || value < VADC_DECIMATION_MIN ||
>> +	    value > VADC_DECIMATION_MAX)
>> +		return -EINVAL;
>> +
>> +	return __ffs64(value / VADC_DECIMATION_MIN);
>> +}
>> +
>> +static int vadc_prescaling_from_dt(unsigned int num, unsigned int den)
> Better use u32 num, u32 den?
>> +{
>> +	unsigned int pre;
>> +
>> +	for (pre = 0; pre < ARRAY_SIZE(vadc_prescale); pre++)
>> +		if (vadc_prescale[pre].num == num &&
>> +		    vadc_prescale[pre].den == den)
>> +			break;
>> +
>> +	if (pre == ARRAY_SIZE(vadc_prescale))
>> +		return -EINVAL;
>> +
>> +	return pre;
>> +}
>> +
>> +static int vadc_hw_settle_time_from_dt(unsigned int value)
>
>> +{
>> +	if ((value <= 1000 && value % 100) || (value > 1000 && value % 2000))
>> +		return -EINVAL;
>> +
>> +	if (value <= 1000)
>> +		value /= 100;
>> +	else
>> +		value = value / 2000 + 10;
>> +
>> +	return value;
>> +}
>> +
>> +static int vadc_avg_samples_from_dt(unsigned int value)
> Better use u32 value?
>> +{
>> +	if (!is_power_of_2(value) || value > VADC_AVG_SAMPLES_MAX)
>> +		return -EINVAL;
>> +
>> +	return __ffs64(value);
>> +}
>> +
>> +static int
> Don't wrap line here.
>> +vadc_read_raw(struct iio_dev *indio_dev, struct iio_chan_spec const *chan,
>> +	      int *val, int *val2, long mask)
>> +{
>> +	struct vadc_priv *vadc = iio_priv(indio_dev);
>> +	struct vadc_channel *vchan;
>> +	struct vadc_result result;
>> +	int rc;
>> +
It is a bit of a pitty we can't avoid this lookup. Normally I'd suggest
putting an index in chan->address but you've already used that.
The purpose of this is to (I think) allow you to have the private
data stored in a random order... What is the benefit of doing that?
(see various comments elsewhere)

>> +	vchan = vadc_find_channel(vadc, chan->channel);
>> +	if (!vchan)
>> +		return -EINVAL;
>> +
>> +	if (!vadc->is_ref_measured) {
>> +		rc = vadc_measure_reference_points(vadc);
>> +		if (rc)
>> +			return rc;
>> +
>> +		vadc->is_ref_measured = true;
>> +	}
>> +
>> +	switch (mask) {
>> +	case IIO_CHAN_INFO_PROCESSED:
>> +		rc = vadc_do_conversion(vadc, vchan, &result.adc_code);
>> +		if (rc)
>> +			return rc;
>> +
>> +		vadc_calibrate(vadc, vchan, &result);
>> +
>> +		*val = result.physical;
I'm a little suspicious here.  Are the resulting values in milivolts for
all the channels?  Very handy if so, but seems a little unlikely with 15 bit
ADC that you'd have no part of greater accuracy than a milivolt.
>> +		rc = IIO_VAL_INT;
> return IIO_VAL_INT;
>> +		break;
>> +	default:
>> +		rc = -EINVAL;
>> +		break;
> Drop default case, or leave empty.
>> +	}
>> +
>> +	return rc;
> return -EINVAL;
>> +}
>> +
>> +static const struct iio_info vadc_info = {
>> +	.read_raw = vadc_read_raw,
>> +	.driver_module = THIS_MODULE,
>> +};
>> +
>> +#define VADC_CHAN(_id, _pre)						\
>> +	[VADC_##_id] = {						\
>> +		.type = IIO_VOLTAGE,					\
A few of the below look to be temp sensors.  If they are hardwired
in some way to this functionality (i.e. is it on chip) then it might be
nice to reflect this in the channel type.
>> +		.indexed = 1,						\
>> +		.channel = VADC_##_id,					\
>> +		.address = _pre,					\
>> +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),	\
>> +		.datasheet_name = __stringify(VADC_##_id),		\
>> +		.scan_type = {						\
>> +			.sign		= 's',				\
>> +			.realbits	= 15,				\
>> +			.storagebits	= 16,				\
>> +			.endianness	= IIO_CPU,			\
>> +		},							\
>> +	},
>> +
>> +static const struct iio_chan_spec vadc_channels[] = {
>> +	VADC_CHAN(USBIN, 4)				/* 0x00 */
>> +	VADC_CHAN(DCIN, 4)
>> +	VADC_CHAN(VCHG_SNS, 3)
>> +	VADC_CHAN(SPARE1_03, 1)
>> +	VADC_CHAN(USB_ID_MV, 1)
>> +	VADC_CHAN(VCOIN, 1)
>> +	VADC_CHAN(VBAT_SNS, 1)
>> +	VADC_CHAN(VSYS, 1)
>> +	VADC_CHAN(DIE_TEMP, 0)
>> +	VADC_CHAN(REF_625MV, 0)
>> +	VADC_CHAN(REF_1250MV, 0)
>> +	VADC_CHAN(CHG_TEMP, 0)
>> +	VADC_CHAN(SPARE1, 0)
>> +	VADC_CHAN(SPARE2, 0)
>> +	VADC_CHAN(GND_REF, 0)
>> +	VADC_CHAN(VDD_VADC, 0)				/* 0x0f */
>> +
>> +	VADC_CHAN(P_MUX1_1_1, 0)			/* 0x10 */
>> +	VADC_CHAN(P_MUX2_1_1, 0)
>> +	VADC_CHAN(P_MUX3_1_1, 0)
>> +	VADC_CHAN(P_MUX4_1_1, 0)
>> +	VADC_CHAN(P_MUX5_1_1, 0)
>> +	VADC_CHAN(P_MUX6_1_1, 0)
>> +	VADC_CHAN(P_MUX7_1_1, 0)
>> +	VADC_CHAN(P_MUX8_1_1, 0)
>> +	VADC_CHAN(P_MUX9_1_1, 0)
>> +	VADC_CHAN(P_MUX10_1_1, 0)
>> +	VADC_CHAN(P_MUX11_1_1, 0)
>> +	VADC_CHAN(P_MUX12_1_1, 0)
>> +	VADC_CHAN(P_MUX13_1_1, 0)
>> +	VADC_CHAN(P_MUX14_1_1, 0)
>> +	VADC_CHAN(P_MUX15_1_1, 0)
>> +	VADC_CHAN(P_MUX16_1_1, 0)			/* 0x1f */
>> +
>> +	VADC_CHAN(P_MUX1_1_3, 1)			/* 0x20 */
>> +	VADC_CHAN(P_MUX2_1_3, 1)
>> +	VADC_CHAN(P_MUX3_1_3, 1)
>> +	VADC_CHAN(P_MUX4_1_3, 1)
>> +	VADC_CHAN(P_MUX5_1_3, 1)
>> +	VADC_CHAN(P_MUX6_1_3, 1)
>> +	VADC_CHAN(P_MUX7_1_3, 1)
>> +	VADC_CHAN(P_MUX8_1_3, 1)
>> +	VADC_CHAN(P_MUX9_1_3, 1)
>> +	VADC_CHAN(P_MUX10_1_3, 1)
>> +	VADC_CHAN(P_MUX11_1_3, 1)
>> +	VADC_CHAN(P_MUX12_1_3, 1)
>> +	VADC_CHAN(P_MUX13_1_3, 1)
>> +	VADC_CHAN(P_MUX14_1_3, 1)
>> +	VADC_CHAN(P_MUX15_1_3, 1)
>> +	VADC_CHAN(P_MUX16_1_3, 1)			/* 0x2f */
>> +
>> +	VADC_CHAN(LR_MUX1_BAT_THERM, 0)			/* 0x30 */
>> +	VADC_CHAN(LR_MUX2_BAT_ID, 0)
>> +	VADC_CHAN(LR_MUX3_XO_THERM, 0)
>> +	VADC_CHAN(LR_MUX4_AMUX_THM1, 0)
>> +	VADC_CHAN(LR_MUX5_AMUX_THM2, 0)
>> +	VADC_CHAN(LR_MUX6_AMUX_THM3, 0)
>> +	VADC_CHAN(LR_MUX7_HW_ID, 0)
>> +	VADC_CHAN(LR_MUX8_AMUX_THM4, 0)
>> +	VADC_CHAN(LR_MUX9_AMUX_THM5, 0)
>> +	VADC_CHAN(LR_MUX10_USB_ID, 0)
>> +	VADC_CHAN(AMUX_PU1, 0)
>> +	VADC_CHAN(AMUX_PU2, 0)
>> +	VADC_CHAN(LR_MUX3_BUF_XO_THERM, 0)		/* 0x3c */
>> +
>> +	VADC_CHAN(LR_MUX1_PU1_BAT_THERM, 0)		/* 0x70 */
>> +	VADC_CHAN(LR_MUX2_PU1_BAT_ID, 0)
>> +	VADC_CHAN(LR_MUX3_PU1_XO_THERM, 0)
>> +	VADC_CHAN(LR_MUX4_PU1_AMUX_THM1, 0)
>> +	VADC_CHAN(LR_MUX5_PU1_AMUX_THM2, 0)
>> +	VADC_CHAN(LR_MUX6_PU1_AMUX_THM3, 0)
>> +	VADC_CHAN(LR_MUX7_PU1_AMUX_HW_ID, 0)
>> +	VADC_CHAN(LR_MUX8_PU1_AMUX_THM4, 0)
>> +	VADC_CHAN(LR_MUX9_PU1_AMUX_THM5, 0)
>> +	VADC_CHAN(LR_MUX10_PU1_AMUX_USB_ID, 0)		/* 0x79 */
>> +	VADC_CHAN(LR_MUX3_BUF_PU1_XO_THERM, 0)		/* 0x7c */
>> +
>> +	VADC_CHAN(LR_MUX1_PU2_BAT_THERM, 0)		/* 0xb0 */
>> +	VADC_CHAN(LR_MUX2_PU2_BAT_ID, 0)
>> +	VADC_CHAN(LR_MUX3_PU2_XO_THERM, 0)
>> +	VADC_CHAN(LR_MUX4_PU2_AMUX_THM1, 0)
>> +	VADC_CHAN(LR_MUX5_PU2_AMUX_THM2, 0)
>> +	VADC_CHAN(LR_MUX6_PU2_AMUX_THM3, 0)
>> +	VADC_CHAN(LR_MUX7_PU2_AMUX_HW_ID, 0)
>> +	VADC_CHAN(LR_MUX8_PU2_AMUX_THM4, 0)
>> +	VADC_CHAN(LR_MUX9_PU2_AMUX_THM5, 0)
>> +	VADC_CHAN(LR_MUX10_PU2_AMUX_USB_ID, 0)		/* 0xb9 */
>> +	VADC_CHAN(LR_MUX3_BUF_PU2_XO_THERM, 0)		/* 0xbc */
>> +
>> +	VADC_CHAN(LR_MUX1_PU1_PU2_BAT_THERM, 0)		/* 0xf0 */
>> +	VADC_CHAN(LR_MUX2_PU1_PU2_BAT_ID, 0)
>> +	VADC_CHAN(LR_MUX3_PU1_PU2_XO_THERM, 0)
>> +	VADC_CHAN(LR_MUX4_PU1_PU2_AMUX_THM1, 0)
>> +	VADC_CHAN(LR_MUX5_PU1_PU2_AMUX_THM2, 0)
>> +	VADC_CHAN(LR_MUX6_PU1_PU2_AMUX_THM3, 0)
>> +	VADC_CHAN(LR_MUX7_PU1_PU2_AMUX_HW_ID, 0)
>> +	VADC_CHAN(LR_MUX8_PU1_PU2_AMUX_THM4, 0)
>> +	VADC_CHAN(LR_MUX9_PU1_PU2_AMUX_THM5, 0)
>> +	VADC_CHAN(LR_MUX10_PU1_PU2_AMUX_USB_ID, 0)	/* 0xf9 */
>> +	VADC_CHAN(LR_MUX3_BUF_PU1_PU2_XO_THERM, 0)	/* 0xfc */
>> +};
>> +
>> +static int
>> +vadc_get_dt_channel_data(struct vadc_priv *vadc, struct device_node *node)
>> +{
>> +	struct vadc_channel *vchan;
>> +	u32 channel, value, varr[2];
>> +	int rc, pre, time, avg, decim;
> Drop pre, time, avg and decim and reuse rc instead?
>> +	const char *name = node->name;
>> +
>> +	rc = of_property_read_u32(node, "reg", &channel);
>> +	if (rc) {
>> +		dev_dbg(vadc->dev, "invalid channel number %s\n", name);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (channel >= vadc->nchannels) {
>> +		dev_dbg(vadc->dev, "%s invalid channel number %d\n", name,
>> +			channel);
>> +		return -EINVAL;
>> +	}
>> +
>> +	vchan = &vadc->channels[channel];
Could you not have these in the same order as the iio_chan_spec array?
Hence move the lookups that are scattered elsewhere in the driver to here?

>> +
>> +	/* the channel is active */
>> +	vchan->number = channel;
>> +
>> +	rc = of_property_read_u32(node, "qcom,decimation", &value);
>> +	if (!rc) {
>> +		decim = vadc_decimation_from_dt(value);
>> +		if (decim < 0) {
>> +			dev_dbg(vadc->dev, "%02x invalid decimation %d\n",
>> +				channel, value);
>> +			return -EINVAL;
> return decim;
>> +		}
>> +		vchan->decimation = decim;
>> +	}
>> +
>> +	rc = of_property_read_u32_array(node, "qcom,pre-scaling", varr, 2);
>> +	if (!rc) {
>> +		pre = vadc_prescaling_from_dt(varr[0], varr[1]);
>> +		if (pre < 0) {
>> +			dev_dbg(vadc->dev,
>> +				"%02x invalid pre-scaling <%d %d>\n",
>> +				channel, varr[0], varr[1]);
>> +			return -EINVAL;
> return pre;
>> +		}
>> +		vchan->prescaling = pre;
>> +	}
>> +
>> +	rc = of_property_read_u32(node, "qcom,hw-settle-time", &value);
>> +	if (!rc) {
>> +		time = vadc_hw_settle_time_from_dt(value);
>> +		if (time < 0) {
>> +			dev_dbg(vadc->dev,
>> +				"%02x invalid hw-settle-time %d, us\n",
>> +				channel, value);
>> +			return -EINVAL;
> return time;
>> +		}
>> +		vchan->hw_settle_time = time;
>> +	}
>> +
>> +	rc = of_property_read_u32(node, "qcom,avg-samples", &value);
>> +	if (!rc) {
>> +		avg = vadc_avg_samples_from_dt(value);
>> +		if (avg < 0) {
>> +			dev_dbg(vadc->dev, "%02x invalid avg-samples %d\n",
>> +				channel, value);
>> +			return -EINVAL;
> return avg;
>> +		}
>> +		vchan->avg_samples = avg;
>> +	}
>> +
>> +	if (of_property_read_bool(node, "qcom,ratiometric"))
>> +		vchan->calibration = VADC_CALIB_RATIOMETRIC;
>> +	else
>> +		vchan->calibration = VADC_CALIB_ABSOLUTE;
> Or simply vchan->calibration = of_property_read_bool(node, "qcom,ratiometric")?
>> +
>> +	dev_dbg(vadc->dev, "%02x name %s\n", channel, name);
>> +
>> +	return 0;
>> +}
>> +
>> +static int vadc_get_dt_data(struct vadc_priv *vadc, struct device_node *node)
>> +{
>> +	struct device_node *child;
>> +	int rc;
>> +
>> +	vadc->poll_eoc = of_property_read_bool(node, "qcom,poll-eoc");
>> +
>> +	for_each_available_child_of_node(node, child) {
>> +		rc = vadc_get_dt_channel_data(vadc, child);
>> +		if (rc < 0)
>> +			return rc;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static irqreturn_t vadc_isr(int irq, void *dev_id)
>> +{
>> +	struct vadc_priv *vadc = dev_id;
>> +
>> +	complete(&vadc->complete);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int vadc_version_check(struct vadc_priv *vadc)
>> +{
>> +	u8 revision, type, subtype;
>> +	int rc;
>> +
>> +	rc = vadc_read(vadc, VADC_PERPH_TYPE, &type);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	if (type < VADC_PERPH_TYPE_ADC) {
>> +		dev_dbg(vadc->dev, "%d is not ADC\n", type);
>> +		return -EINVAL;
>> +	}
>> +
>> +	rc = vadc_read(vadc, VADC_PERPH_SUBTYPE, &subtype);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	if (subtype < VADC_PERPH_SUBTYPE_VADC) {
>> +		dev_dbg(vadc->dev, "%d is not VADC\n", subtype);
>> +		return -EINVAL;
>> +	}
>> +
>> +	rc = vadc_read(vadc, VADC_REVISION2, &revision);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	if (revision < VADC_REVISION2_SUPPORTED_VADC) {
>> +		dev_dbg(vadc->dev, "revision %d not supported\n", revision);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int vadc_probe(struct platform_device *pdev)
>> +{
>> +	struct device_node *node = pdev->dev.of_node;
>> +	struct device *dev = &pdev->dev;
>> +	struct iio_dev *indio_dev;
>> +	struct vadc_channel *vchan;
>> +	struct vadc_priv *vadc;
>> +	struct resource *res;
>> +	struct regmap *regmap;
>> +	int rc, irq_eoc, n;
> unsigned int n?
>> +
>> +	regmap = dev_get_regmap(dev->parent, NULL);
>> +	if (!regmap)
>> +		return -ENODEV;
>> +
>> +	indio_dev = devm_iio_device_alloc(dev, sizeof(*vadc));
>> +	if (!indio_dev)
>> +		return -ENOMEM;
>> +
>> +	vadc = iio_priv(indio_dev);
>> +	vadc->dev = dev;
>> +	vadc->regmap = regmap;
>> +	vadc->is_ref_measured = false;
>> +	init_completion(&vadc->complete);
>> +
>> +	vadc->nchannels = ARRAY_SIZE(vadc_channels);
>> +	vadc->channels = devm_kcalloc(dev, vadc->nchannels,
>> +				      sizeof(*vadc->channels), GFP_KERNEL);
Interesting.  This is always the same size as the vadc_channels so you
might as well keep them in the same order and simplify various corners of
the code.
>> +	if (!vadc->channels)
>> +		return -ENOMEM;
>> +
I wonder if we can't vadc->channels rather more different from vadc_channels?
Perhaps vadc->channelspriv or similar? Confused me a little at first.
>> +	for (n = 0; n < vadc->nchannels; n++) {
>> +		vchan = &vadc->channels[n];
>> +		/* set default channel properties */
>> +		vchan->number = -1;	/* inactive */
>> +		vchan->prescaling = vadc_channels[n].address;
>> +		vchan->decimation = VADC_DEF_DECIMATION;
>> +		vchan->hw_settle_time = VADC_DEF_HW_SETTLE_TIME;
>> +		vchan->avg_samples = VADC_DEF_AVG_SAMPLES;
>> +		vchan->calibration = VADC_DEF_CALIB_TYPE;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, vadc);
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
>> +	if (!res)
>> +		return -ENODEV;
>> +
>> +	vadc->base = res->start;
>> +
>> +	rc = vadc_version_check(vadc);
>> +	if (rc < 0)
>> +		return -ENODEV;
>> +
>> +	rc = vadc_get_dt_data(vadc, node);
>> +	if (rc < 0)
>> +		return rc;
>> +
Do we need an explicit flag to indicate poll mode rather than just
using the absense of the irq being specified to select that mode?

I guess the explicit flag makes it harder to get things wrong.
>> +	if (!vadc->poll_eoc) {
>> +		irq_eoc = platform_get_irq(pdev, 0);
>> +		if (irq_eoc < 0)
>> +			return irq_eoc;
>> +
>> +		rc = devm_request_irq(dev, irq_eoc, vadc_isr, 0,
>> +				      "spmi-vadc", vadc);
>> +		if (!rc)
>> +			enable_irq_wake(irq_eoc);
>> +		else
>> +			return rc;
>> +	} else {
>> +		device_init_wakeup(vadc->dev, true);
>> +	}
>> +
>> +	rc = vadc_reset(vadc);
>> +	if (rc < 0) {
>> +		dev_dbg(dev, "reset failed\n");
>> +		return rc;
>> +	}
>> +
>> +	indio_dev->dev.parent = dev;
>> +	indio_dev->dev.of_node = node;
>> +	indio_dev->name = pdev->name;
>> +	indio_dev->modes = INDIO_DIRECT_MODE;
>> +	indio_dev->info = &vadc_info;
>> +	indio_dev->channels = vadc_channels;
>> +	indio_dev->num_channels = ARRAY_SIZE(vadc_channels);
>> +
>> +	return devm_iio_device_register(dev, indio_dev);
>> +}
>> +
>> +static const struct of_device_id vadc_match_table[] = {
>> +	{ .compatible = "qcom,spmi-vadc" },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, vadc_match_table);
>> +
>> +static struct platform_driver vadc_driver = {
>> +	.driver = {
>> +		   .name = "spmi-vadc",
>> +		   .of_match_table = vadc_match_table,
>> +	},
>> +	.probe = vadc_probe,
>> +};
>> +module_platform_driver(vadc_driver);
>> +
>> +MODULE_ALIAS("platform:spmi-vadc");
>> +MODULE_DESCRIPTION("Qualcomm SPMI PMIC voltage ADC driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/include/dt-bindings/iio/qcom,spmi-pmic-vadc.h b/include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
>> new file mode 100644
>> index 0000000..d543f24
>> --- /dev/null
>> +++ b/include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
>> @@ -0,0 +1,119 @@
>> +/*
>> + * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _DT_BINDINGS_QCOM_PMIC_ADC_H
>> +#define _DT_BINDINGS_QCOM_PMIC_ADC_H
>> +
>> +/* Voltage ADC channels */
>> +#define VADC_USBIN				0x00
>> +#define VADC_DCIN				0x01
>> +#define VADC_VCHG_SNS				0x02
>> +#define VADC_SPARE1_03				0x03
>> +#define VADC_USB_ID_MV				0x04
>> +#define VADC_VCOIN				0x05
>> +#define VADC_VBAT_SNS				0x06
>> +#define VADC_VSYS				0x07
>> +#define VADC_DIE_TEMP				0x08
>> +#define VADC_REF_625MV				0x09
>> +#define VADC_REF_1250MV				0x0a
>> +#define VADC_CHG_TEMP				0x0b
>> +#define VADC_SPARE1				0x0c
>> +#define VADC_SPARE2				0x0d
>> +#define VADC_GND_REF				0x0e
>> +#define VADC_VDD_VADC				0x0f
>> +
>> +#define VADC_P_MUX1_1_1				0x10
>> +#define VADC_P_MUX2_1_1				0x11
>> +#define VADC_P_MUX3_1_1				0x12
>> +#define VADC_P_MUX4_1_1				0x13
>> +#define VADC_P_MUX5_1_1				0x14
>> +#define VADC_P_MUX6_1_1				0x15
>> +#define VADC_P_MUX7_1_1				0x16
>> +#define VADC_P_MUX8_1_1				0x17
>> +#define VADC_P_MUX9_1_1				0x18
>> +#define VADC_P_MUX10_1_1			0x19
>> +#define VADC_P_MUX11_1_1			0x1a
>> +#define VADC_P_MUX12_1_1			0x1b
>> +#define VADC_P_MUX13_1_1			0x1c
>> +#define VADC_P_MUX14_1_1			0x1d
>> +#define VADC_P_MUX15_1_1			0x1e
>> +#define VADC_P_MUX16_1_1			0x1f
>> +
>> +#define VADC_P_MUX1_1_3				0x20
>> +#define VADC_P_MUX2_1_3				0x21
>> +#define VADC_P_MUX3_1_3				0x22
>> +#define VADC_P_MUX4_1_3				0x23
>> +#define VADC_P_MUX5_1_3				0x24
>> +#define VADC_P_MUX6_1_3				0x25
>> +#define VADC_P_MUX7_1_3				0x26
>> +#define VADC_P_MUX8_1_3				0x27
>> +#define VADC_P_MUX9_1_3				0x28
>> +#define VADC_P_MUX10_1_3			0x29
>> +#define VADC_P_MUX11_1_3			0x2a
>> +#define VADC_P_MUX12_1_3			0x2b
>> +#define VADC_P_MUX13_1_3			0x2c
>> +#define VADC_P_MUX14_1_3			0x2d
>> +#define VADC_P_MUX15_1_3			0x2e
>> +#define VADC_P_MUX16_1_3			0x2f
>> +
>> +#define VADC_LR_MUX1_BAT_THERM			0x30
>> +#define VADC_LR_MUX2_BAT_ID			0x31
>> +#define VADC_LR_MUX3_XO_THERM			0x32
>> +#define VADC_LR_MUX4_AMUX_THM1			0x33
>> +#define VADC_LR_MUX5_AMUX_THM2			0x34
>> +#define VADC_LR_MUX6_AMUX_THM3			0x35
>> +#define VADC_LR_MUX7_HW_ID			0x36
>> +#define VADC_LR_MUX8_AMUX_THM4			0x37
>> +#define VADC_LR_MUX9_AMUX_THM5			0x38
>> +#define VADC_LR_MUX10_USB_ID			0x39
>> +#define VADC_AMUX_PU1				0x3a
>> +#define VADC_AMUX_PU2				0x3b
>> +#define VADC_LR_MUX3_BUF_XO_THERM		0x3c
>> +
>> +#define VADC_LR_MUX1_PU1_BAT_THERM		0x70
>> +#define VADC_LR_MUX2_PU1_BAT_ID			0x71
>> +#define VADC_LR_MUX3_PU1_XO_THERM		0x72
>> +#define VADC_LR_MUX4_PU1_AMUX_THM1		0x73
>> +#define VADC_LR_MUX5_PU1_AMUX_THM2		0x74
>> +#define VADC_LR_MUX6_PU1_AMUX_THM3		0x75
>> +#define VADC_LR_MUX7_PU1_AMUX_HW_ID		0x76
>> +#define VADC_LR_MUX8_PU1_AMUX_THM4		0x77
>> +#define VADC_LR_MUX9_PU1_AMUX_THM5		0x78
>> +#define VADC_LR_MUX10_PU1_AMUX_USB_ID		0x79
>> +#define VADC_LR_MUX3_BUF_PU1_XO_THERM		0x7c
>> +
>> +#define VADC_LR_MUX1_PU2_BAT_THERM		0xb0
>> +#define VADC_LR_MUX2_PU2_BAT_ID			0xb1
>> +#define VADC_LR_MUX3_PU2_XO_THERM		0xb2
>> +#define VADC_LR_MUX4_PU2_AMUX_THM1		0xb3
>> +#define VADC_LR_MUX5_PU2_AMUX_THM2		0xb4
>> +#define VADC_LR_MUX6_PU2_AMUX_THM3		0xb5
>> +#define VADC_LR_MUX7_PU2_AMUX_HW_ID		0xb6
>> +#define VADC_LR_MUX8_PU2_AMUX_THM4		0xb7
>> +#define VADC_LR_MUX9_PU2_AMUX_THM5		0xb8
>> +#define VADC_LR_MUX10_PU2_AMUX_USB_ID		0xb9
>> +#define VADC_LR_MUX3_BUF_PU2_XO_THERM		0xbc
>> +
>> +#define VADC_LR_MUX1_PU1_PU2_BAT_THERM		0xf0
>> +#define VADC_LR_MUX2_PU1_PU2_BAT_ID		0xf1
>> +#define VADC_LR_MUX3_PU1_PU2_XO_THERM		0xf2
>> +#define VADC_LR_MUX4_PU1_PU2_AMUX_THM1		0xf3
>> +#define VADC_LR_MUX5_PU1_PU2_AMUX_THM2		0xf4
>> +#define VADC_LR_MUX6_PU1_PU2_AMUX_THM3		0xf5
>> +#define VADC_LR_MUX7_PU1_PU2_AMUX_HW_ID		0xf6
>> +#define VADC_LR_MUX8_PU1_PU2_AMUX_THM4		0xf7
>> +#define VADC_LR_MUX9_PU1_PU2_AMUX_THM5		0xf8
>> +#define VADC_LR_MUX10_PU1_PU2_AMUX_USB_ID	0xf9
>> +#define VADC_LR_MUX3_BUF_PU1_PU2_XO_THERM	0xfc
>> +
>> +#endif /* _DT_BINDINGS_QCOM_PMIC_ADC_H */
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
