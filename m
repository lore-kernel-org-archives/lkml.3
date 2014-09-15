Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaIOQL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:11:56 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:34819 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaIOQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:11:53 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5416F3E2.3030009@mm-sol.com>
References: <1410448403-19402-1-git-send-email-svarbanov@mm-sol.com> <1410448403-19402-2-git-send-email-svarbanov@mm-sol.com> <54138151.8010902@gmx.de> <54147E97.60808@kernel.org> <5416F3E2.3030009@mm-sol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
From: Jonathan Cameron <jic23@kernel.org>
Date: Mon, 15 Sep 2014 17:11:37 +0100
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Hartmut Knaack <knaack.h@gmx.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <4dbc485f-599a-4b50-854c-c2e1c44d4810@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On September 15, 2014 3:12:50 PM GMT+01:00, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
>Hi Jonathan,
>
>Thanks for the review!
>
>On 09/13/2014 08:27 PM, Jonathan Cameron wrote:
>> On 13/09/14 00:27, Hartmut Knaack wrote:
>>> Stanimir Varbanov schrieb, Am 11.09.2014 17:13:
>>>> The voltage ADC is peripheral of Qualcomm SPMI PMIC chips. It has
>>>> 15bits resolution and register space inside PMIC accessible across
>>>> SPMI bus.
>>>>
>>>> The vadc driver registers itself through IIO interface.
>>>>
>>> Looks already pretty good. Things you should consider in regard of
>common coding style are to use the variable name ret instead of rc,
>since it is used in almost all adc drivers and thus makes reviewing a
>bit easier. Besides that, you seem to use unsigned as well as unsigned
>int, so to be consistent, please stick to one of them. Other comments
>in line.
>> 
>> A few additional comments from me.  My biggest question is whether
>> you are actually making life difficult for yourself by having
>> vadc_channels and vadc->channels (don't like the similar naming btw!)
>> in different orders.  I think you can move the ordering into the
>device
>> tree reading code rather than doing it in lots of other places. 
>Hence
>> rather than an order based on the device tree description, put the
>> data into a fixed ofer in vadc->channels.
>> 
>> Entirely possible I'm missing something though :)
>>>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>>>> ---
>>>>  drivers/iio/adc/Kconfig                       |   11 +
>>>>  drivers/iio/adc/Makefile                      |    1 +
>>>>  drivers/iio/adc/qcom-spmi-vadc.c              |  999
>+++++++++++++++++++++++++
>>>>  include/dt-bindings/iio/qcom,spmi-pmic-vadc.h |  119 +++
>>>>  4 files changed, 1130 insertions(+), 0 deletions(-)
>>>>  create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
>>>>  create mode 100644 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
>
><snip>
>
>>>> +
>>>> +static int
>>> Don't wrap line here.
>>>> +vadc_read_raw(struct iio_dev *indio_dev, struct iio_chan_spec
>const *chan,
>>>> +	      int *val, int *val2, long mask)
>>>> +{
>>>> +	struct vadc_priv *vadc = iio_priv(indio_dev);
>>>> +	struct vadc_channel *vchan;
>>>> +	struct vadc_result result;
>>>> +	int rc;
>>>> +
>> It is a bit of a pitty we can't avoid this lookup. Normally I'd
>suggest
>> putting an index in chan->address but you've already used that.
>> The purpose of this is to (I think) allow you to have the private
>> data stored in a random order... What is the benefit of doing that?
>> (see various comments elsewhere)
>
>So the vadc_channels array describe all possible vadc channels for all
>supported PMICs from this driver. On the other side vadc->channels
>pointer should contain only the channels described in DT.
>
>Thus we need a below function to check is the current channel is active
>for the current DT (current PMIC version). This is because we have in
>vadc_channels the full set of channels but not every supported PMIC
>have
>support for them.
>
>I agree that this peace of code is not so clear. So I will try to
>rework
>this and register to the IIO core only those channels that have channel
>descriptions in DT.
Cool
>
>Also I wonder can I use iio_chan_spec::address field as a pointer to
>private structure with vadc channel properties like decimation,
>prescale
>etc. got from DT or the default values.
Yes or an index into an array of them perhaps?
>
>> 
>>>> +	vchan = vadc_find_channel(vadc, chan->channel);
>>>> +	if (!vchan)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (!vadc->is_ref_measured) {
>>>> +		rc = vadc_measure_reference_points(vadc);
>>>> +		if (rc)
>>>> +			return rc;
>>>> +
>>>> +		vadc->is_ref_measured = true;
>>>> +	}
>>>> +
>>>> +	switch (mask) {
>>>> +	case IIO_CHAN_INFO_PROCESSED:
>>>> +		rc = vadc_do_conversion(vadc, vchan, &result.adc_code);
>>>> +		if (rc)
>>>> +			return rc;
>>>> +
>>>> +		vadc_calibrate(vadc, vchan, &result);
>>>> +
>>>> +		*val = result.physical;
>> I'm a little suspicious here.  Are the resulting values in milivolts
>for
>> all the channels?  Very handy if so, but seems a little unlikely with
>15 bit
>> ADC that you'd have no part of greater accuracy than a milivolt.
>
>In fact *val is in microvolts. What is the expected unit from IIO ADC
>users?
See Documentation/ABI/sysfs-bus-iio
Millivolts I think... We copied hwmon where possible.
>
>>>> +		rc = IIO_VAL_INT;
>>> return IIO_VAL_INT;
>>>> +		break;
>>>> +	default:
>>>> +		rc = -EINVAL;
>>>> +		break;
>>> Drop default case, or leave empty.
>>>> +	}
>>>> +
>>>> +	return rc;
>>> return -EINVAL;
>>>> +}
>>>> +
>>>> +static const struct iio_info vadc_info = {
>>>> +	.read_raw = vadc_read_raw,
>>>> +	.driver_module = THIS_MODULE,
>>>> +};
>>>> +
>>>> +#define VADC_CHAN(_id, _pre)						\
>>>> +	[VADC_##_id] = {						\
>>>> +		.type = IIO_VOLTAGE,					\
>> A few of the below look to be temp sensors.  If they are hardwired
>> in some way to this functionality (i.e. is it on chip) then it might
>be
>> nice to reflect this in the channel type.
>
>There are a dedicated channels to measure temperature. Those channels
>have connected thermistor but I don't think it is on chip. So the
>returned adc code is in microvolts and we have a translation table to
>convert measured voltage to miliCelsius. I thought that if I mark the
>channel type as IIO_TEMP then the user would expect the returned units
>to be miliCelsius. If that assumption is not correct I can change the
>type of those channels.
You are correct. Leave them as voltages.
If they were hardwired inside the chip it would be different.
>
>>>> +		.indexed = 1,						\
>>>> +		.channel = VADC_##_id,					\
>>>> +		.address = _pre,					\
>>>> +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),	\
>>>> +		.datasheet_name = __stringify(VADC_##_id),		\
>>>> +		.scan_type = {						\
>>>> +			.sign		= 's',				\
>>>> +			.realbits	= 15,				\
>>>> +			.storagebits	= 16,				\
>>>> +			.endianness	= IIO_CPU,			\
>>>> +		},							\
>>>> +	},
>>>> +
>>>> +static const struct iio_chan_spec vadc_channels[] = {
>>>> +	VADC_CHAN(USBIN, 4)				/* 0x00 */
>>>> +	VADC_CHAN(DCIN, 4)
>>>> +	VADC_CHAN(VCHG_SNS, 3)
>>>> +	VADC_CHAN(SPARE1_03, 1)
>>>> +	VADC_CHAN(USB_ID_MV, 1)
>>>> +	VADC_CHAN(VCOIN, 1)
>>>> +	VADC_CHAN(VBAT_SNS, 1)
>>>> +	VADC_CHAN(VSYS, 1)
>>>> +	VADC_CHAN(DIE_TEMP, 0)
>>>> +	VADC_CHAN(REF_625MV, 0)
>>>> +	VADC_CHAN(REF_1250MV, 0)
>>>> +	VADC_CHAN(CHG_TEMP, 0)
>>>> +	VADC_CHAN(SPARE1, 0)
>>>> +	VADC_CHAN(SPARE2, 0)
>>>> +	VADC_CHAN(GND_REF, 0)
>>>> +	VADC_CHAN(VDD_VADC, 0)				/* 0x0f */
>>>> +
>>>> +	VADC_CHAN(P_MUX1_1_1, 0)			/* 0x10 */
>>>> +	VADC_CHAN(P_MUX2_1_1, 0)
>>>> +	VADC_CHAN(P_MUX3_1_1, 0)
>>>> +	VADC_CHAN(P_MUX4_1_1, 0)
>>>> +	VADC_CHAN(P_MUX5_1_1, 0)
>>>> +	VADC_CHAN(P_MUX6_1_1, 0)
>>>> +	VADC_CHAN(P_MUX7_1_1, 0)
>>>> +	VADC_CHAN(P_MUX8_1_1, 0)
>>>> +	VADC_CHAN(P_MUX9_1_1, 0)
>>>> +	VADC_CHAN(P_MUX10_1_1, 0)
>>>> +	VADC_CHAN(P_MUX11_1_1, 0)
>>>> +	VADC_CHAN(P_MUX12_1_1, 0)
>>>> +	VADC_CHAN(P_MUX13_1_1, 0)
>>>> +	VADC_CHAN(P_MUX14_1_1, 0)
>>>> +	VADC_CHAN(P_MUX15_1_1, 0)
>>>> +	VADC_CHAN(P_MUX16_1_1, 0)			/* 0x1f */
>>>> +
>>>> +	VADC_CHAN(P_MUX1_1_3, 1)			/* 0x20 */
>>>> +	VADC_CHAN(P_MUX2_1_3, 1)
>>>> +	VADC_CHAN(P_MUX3_1_3, 1)
>>>> +	VADC_CHAN(P_MUX4_1_3, 1)
>>>> +	VADC_CHAN(P_MUX5_1_3, 1)
>>>> +	VADC_CHAN(P_MUX6_1_3, 1)
>>>> +	VADC_CHAN(P_MUX7_1_3, 1)
>>>> +	VADC_CHAN(P_MUX8_1_3, 1)
>>>> +	VADC_CHAN(P_MUX9_1_3, 1)
>>>> +	VADC_CHAN(P_MUX10_1_3, 1)
>>>> +	VADC_CHAN(P_MUX11_1_3, 1)
>>>> +	VADC_CHAN(P_MUX12_1_3, 1)
>>>> +	VADC_CHAN(P_MUX13_1_3, 1)
>>>> +	VADC_CHAN(P_MUX14_1_3, 1)
>>>> +	VADC_CHAN(P_MUX15_1_3, 1)
>>>> +	VADC_CHAN(P_MUX16_1_3, 1)			/* 0x2f */
>>>> +
>>>> +	VADC_CHAN(LR_MUX1_BAT_THERM, 0)			/* 0x30 */
>>>> +	VADC_CHAN(LR_MUX2_BAT_ID, 0)
>>>> +	VADC_CHAN(LR_MUX3_XO_THERM, 0)
>>>> +	VADC_CHAN(LR_MUX4_AMUX_THM1, 0)
>>>> +	VADC_CHAN(LR_MUX5_AMUX_THM2, 0)
>>>> +	VADC_CHAN(LR_MUX6_AMUX_THM3, 0)
>>>> +	VADC_CHAN(LR_MUX7_HW_ID, 0)
>>>> +	VADC_CHAN(LR_MUX8_AMUX_THM4, 0)
>>>> +	VADC_CHAN(LR_MUX9_AMUX_THM5, 0)
>>>> +	VADC_CHAN(LR_MUX10_USB_ID, 0)
>>>> +	VADC_CHAN(AMUX_PU1, 0)
>>>> +	VADC_CHAN(AMUX_PU2, 0)
>>>> +	VADC_CHAN(LR_MUX3_BUF_XO_THERM, 0)		/* 0x3c */
>>>> +
>>>> +	VADC_CHAN(LR_MUX1_PU1_BAT_THERM, 0)		/* 0x70 */
>>>> +	VADC_CHAN(LR_MUX2_PU1_BAT_ID, 0)
>>>> +	VADC_CHAN(LR_MUX3_PU1_XO_THERM, 0)
>>>> +	VADC_CHAN(LR_MUX4_PU1_AMUX_THM1, 0)
>>>> +	VADC_CHAN(LR_MUX5_PU1_AMUX_THM2, 0)
>>>> +	VADC_CHAN(LR_MUX6_PU1_AMUX_THM3, 0)
>>>> +	VADC_CHAN(LR_MUX7_PU1_AMUX_HW_ID, 0)
>>>> +	VADC_CHAN(LR_MUX8_PU1_AMUX_THM4, 0)
>>>> +	VADC_CHAN(LR_MUX9_PU1_AMUX_THM5, 0)
>>>> +	VADC_CHAN(LR_MUX10_PU1_AMUX_USB_ID, 0)		/* 0x79 */
>>>> +	VADC_CHAN(LR_MUX3_BUF_PU1_XO_THERM, 0)		/* 0x7c */
>>>> +
>>>> +	VADC_CHAN(LR_MUX1_PU2_BAT_THERM, 0)		/* 0xb0 */
>>>> +	VADC_CHAN(LR_MUX2_PU2_BAT_ID, 0)
>>>> +	VADC_CHAN(LR_MUX3_PU2_XO_THERM, 0)
>>>> +	VADC_CHAN(LR_MUX4_PU2_AMUX_THM1, 0)
>>>> +	VADC_CHAN(LR_MUX5_PU2_AMUX_THM2, 0)
>>>> +	VADC_CHAN(LR_MUX6_PU2_AMUX_THM3, 0)
>>>> +	VADC_CHAN(LR_MUX7_PU2_AMUX_HW_ID, 0)
>>>> +	VADC_CHAN(LR_MUX8_PU2_AMUX_THM4, 0)
>>>> +	VADC_CHAN(LR_MUX9_PU2_AMUX_THM5, 0)
>>>> +	VADC_CHAN(LR_MUX10_PU2_AMUX_USB_ID, 0)		/* 0xb9 */
>>>> +	VADC_CHAN(LR_MUX3_BUF_PU2_XO_THERM, 0)		/* 0xbc */
>>>> +
>>>> +	VADC_CHAN(LR_MUX1_PU1_PU2_BAT_THERM, 0)		/* 0xf0 */
>>>> +	VADC_CHAN(LR_MUX2_PU1_PU2_BAT_ID, 0)
>>>> +	VADC_CHAN(LR_MUX3_PU1_PU2_XO_THERM, 0)
>>>> +	VADC_CHAN(LR_MUX4_PU1_PU2_AMUX_THM1, 0)
>>>> +	VADC_CHAN(LR_MUX5_PU1_PU2_AMUX_THM2, 0)
>>>> +	VADC_CHAN(LR_MUX6_PU1_PU2_AMUX_THM3, 0)
>>>> +	VADC_CHAN(LR_MUX7_PU1_PU2_AMUX_HW_ID, 0)
>>>> +	VADC_CHAN(LR_MUX8_PU1_PU2_AMUX_THM4, 0)
>>>> +	VADC_CHAN(LR_MUX9_PU1_PU2_AMUX_THM5, 0)
>>>> +	VADC_CHAN(LR_MUX10_PU1_PU2_AMUX_USB_ID, 0)	/* 0xf9 */
>>>> +	VADC_CHAN(LR_MUX3_BUF_PU1_PU2_XO_THERM, 0)	/* 0xfc */
>>>> +};
>>>> +
>>>> +static int
>>>> +vadc_get_dt_channel_data(struct vadc_priv *vadc, struct
>device_node *node)
>>>> +{
>>>> +	struct vadc_channel *vchan;
>>>> +	u32 channel, value, varr[2];
>>>> +	int rc, pre, time, avg, decim;
>>> Drop pre, time, avg and decim and reuse rc instead?
>>>> +	const char *name = node->name;
>>>> +
>>>> +	rc = of_property_read_u32(node, "reg", &channel);
>>>> +	if (rc) {
>>>> +		dev_dbg(vadc->dev, "invalid channel number %s\n", name);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	if (channel >= vadc->nchannels) {
>>>> +		dev_dbg(vadc->dev, "%s invalid channel number %d\n", name,
>>>> +			channel);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	vchan = &vadc->channels[channel];
>> Could you not have these in the same order as the iio_chan_spec
>array?
>> Hence move the lookups that are scattered elsewhere in the driver to
>here?
>> 
>
><snip>
>
>>>> +static int vadc_probe(struct platform_device *pdev)
>>>> +{
>>>> +	struct device_node *node = pdev->dev.of_node;
>>>> +	struct device *dev = &pdev->dev;
>>>> +	struct iio_dev *indio_dev;
>>>> +	struct vadc_channel *vchan;
>>>> +	struct vadc_priv *vadc;
>>>> +	struct resource *res;
>>>> +	struct regmap *regmap;
>>>> +	int rc, irq_eoc, n;
>>> unsigned int n?
>>>> +
>>>> +	regmap = dev_get_regmap(dev->parent, NULL);
>>>> +	if (!regmap)
>>>> +		return -ENODEV;
>>>> +
>>>> +	indio_dev = devm_iio_device_alloc(dev, sizeof(*vadc));
>>>> +	if (!indio_dev)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	vadc = iio_priv(indio_dev);
>>>> +	vadc->dev = dev;
>>>> +	vadc->regmap = regmap;
>>>> +	vadc->is_ref_measured = false;
>>>> +	init_completion(&vadc->complete);
>>>> +
>>>> +	vadc->nchannels = ARRAY_SIZE(vadc_channels);
>>>> +	vadc->channels = devm_kcalloc(dev, vadc->nchannels,
>>>> +				      sizeof(*vadc->channels), GFP_KERNEL);
>> Interesting.  This is always the same size as the vadc_channels so
>you
>> might as well keep them in the same order and simplify various
>corners of
>> the code.
>>>> +	if (!vadc->channels)
>>>> +		return -ENOMEM;
>>>> +
>> I wonder if we can't vadc->channels rather more different from
>vadc_channels?
>> Perhaps vadc->channelspriv or similar? Confused me a little at first.
>>>> +	for (n = 0; n < vadc->nchannels; n++) {
>>>> +		vchan = &vadc->channels[n];
>>>> +		/* set default channel properties */
>>>> +		vchan->number = -1;	/* inactive */
>>>> +		vchan->prescaling = vadc_channels[n].address;
>>>> +		vchan->decimation = VADC_DEF_DECIMATION;
>>>> +		vchan->hw_settle_time = VADC_DEF_HW_SETTLE_TIME;
>>>> +		vchan->avg_samples = VADC_DEF_AVG_SAMPLES;
>>>> +		vchan->calibration = VADC_DEF_CALIB_TYPE;
>>>> +	}
>>>> +
>>>> +	platform_set_drvdata(pdev, vadc);
>>>> +
>>>> +	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
>>>> +	if (!res)
>>>> +		return -ENODEV;
>>>> +
>>>> +	vadc->base = res->start;
>>>> +
>>>> +	rc = vadc_version_check(vadc);
>>>> +	if (rc < 0)
>>>> +		return -ENODEV;
>>>> +
>>>> +	rc = vadc_get_dt_data(vadc, node);
>>>> +	if (rc < 0)
>>>> +		return rc;
>>>> +
>> Do we need an explicit flag to indicate poll mode rather than just
>> using the absense of the irq being specified to select that mode?
>
>I will think about this. Maybe I will check the returned value from
>platform_get_irq to see is the IRQ resource exist. If the IRQ doesn't
>exist I will fallback to polling.
That was my thought.
>
><snip>

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
