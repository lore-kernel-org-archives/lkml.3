Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaJNJhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:37:00 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:52841 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbaJNJg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:36:57 -0400
Message-ID: <543CEEB0.10601@mm-sol.com>
Date: Tue, 14 Oct 2014 12:36:48 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
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
Subject: Re: [PATCH v3 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
References: <1411563415-11933-1-git-send-email-svarbanov@mm-sol.com> <1411563415-11933-2-git-send-email-svarbanov@mm-sol.com> <543AFBBC.50400@gmx.de>
In-Reply-To: <543AFBBC.50400@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 01:07 AM, Hartmut Knaack wrote:
> Stanimir Varbanov schrieb am 24.09.2014 14:56:
>> The voltage ADC is peripheral of Qualcomm SPMI PMIC chips. It has
>> 15bits resolution and register space inside PMIC accessible across
>> SPMI bus.
>>
>> The vadc driver registers itself through IIO interface.
> Quite a lot of changes. Please see my comments inline.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>> ---
>>  drivers/iio/adc/Kconfig                       |   10 +
>>  drivers/iio/adc/Makefile                      |    1 +
>>  drivers/iio/adc/qcom-spmi-vadc.c              | 1029 +++++++++++++++++++++++++
>>  include/dt-bindings/iio/qcom,spmi-pmic-vadc.h |  119 +++
>>  4 files changed, 1159 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
>>  create mode 100644 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
>>

<snip>

>> +
>> +static int vadc_reset(struct vadc_priv *vadc)
>> +{
>> +	u8 data;
>> +	int ret;
>> +
>> +	ret = vadc_write(vadc, VADC_ACCESS, VADC_ACCESS_DATA);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = vadc_read(vadc, VADC_PERH_RESET_CTL3, &data);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = vadc_write(vadc, VADC_ACCESS, VADC_ACCESS_DATA);
>> +	if (ret)
>> +		return ret;
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
>> +#ifdef DEBUG
>> +static void vadc_show_status(struct vadc_priv *vadc)
>> +{
> You could also move the #ifdef in here...
>> +	u8 mode, sta1, chan, dig, en, req;
>> +	int ret;
>> +
>> +	ret = vadc_read(vadc, VADC_MODE_CTL, &mode);
>> +	if (ret)
>> +		return;
>> +
>> +	ret = vadc_read(vadc, VADC_ADC_DIG_PARAM, &dig);
>> +	if (ret)
>> +		return;
>> +
>> +	ret = vadc_read(vadc, VADC_ADC_CH_SEL_CTL, &chan);
>> +	if (ret)
>> +		return;
>> +
>> +	ret = vadc_read(vadc, VADC_CONV_REQ, &req);
>> +	if (ret)
>> +		return;
>> +
>> +	ret = vadc_read(vadc, VADC_STATUS1, &sta1);
>> +	if (ret)
>> +		return;
>> +
>> +	ret = vadc_read(vadc, VADC_EN_CTL1, &en);
>> +	if (ret)
>> +		return;
>> +
>> +	dev_dbg(vadc->dev,
>> +		"mode:%02x en:%02x chan:%02x dig:%02x req:%02x sta1:%02x\n",
>> +		mode, en, chan, dig, req, sta1);
> ...and the #endif here. Saves 2 lines of code ;-)

I don't like #ifdefs in function body, it makes code unreadable at least
for me :)

>> +}
>> +#else
>> +static void vadc_show_status(struct vadc_priv *vadc) {}
>> +#endif
>> +

<snip>

>> +
>> +static int vadc_get_dt_channel_data(struct device *dev,
>> +				    struct vadc_channel_prop *prop,
>> +				    struct device_node *node)
>> +{
>> +	const char *name = node->name;
>> +	u32 chan, value, varr[2];
>> +	int ret;
>> +
>> +	ret = of_property_read_u32(node, "reg", &chan);
>> +	if (ret) {
>> +		dev_dbg(dev, "invalid channel number %s\n", name);
>> +		return ret;
>> +	}
>> +
>> +	if (chan > VADC_CHAN_MAX || chan < VADC_CHAN_MIN) {
>> +		dev_dbg(dev, "%s invalid channel number %d\n", name, chan);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* the channel has DT description */
>> +	prop->channel = chan;
>> +
>> +	ret = of_property_read_u32(node, "qcom,decimation", &value);
>> +	if (!ret) {
>> +		ret = vadc_decimation_from_dt(value);
>> +		if (ret < 0) {
>> +			dev_dbg(dev, "%02x invalid decimation %d\n",
>> +				chan, value);
>> +			return ret;
>> +		}
>> +		prop->decimation = ret;
>> +	} else {
>> +		prop->decimation = VADC_DEF_DECIMATION;
>> +	}
>> +
>> +	ret = of_property_read_u32_array(node, "qcom,pre-scaling", varr, 2);
>> +	if (!ret) {
>> +		ret = vadc_prescaling_from_dt(varr[0], varr[1]);
>> +		if (ret < 0) {
>> +			dev_dbg(dev, "%02x invalid pre-scaling <%d %d>\n",
>> +				chan, varr[0], varr[1]);
>> +			return ret;
>> +		}
>> +		prop->prescale = ret;
>> +	} else {
>> +		prop->prescale = vadc_chans[prop->channel].prescale_index;
>> +	}
>> +
>> +	ret = of_property_read_u32(node, "qcom,hw-settle-time", &value);
>> +	if (!ret) {
>> +		ret = vadc_hw_settle_time_from_dt(value);
>> +		if (ret < 0) {
>> +			dev_dbg(dev, "%02x invalid hw-settle-time %d, us\n",
> The colon inside the string is probably an unintended leftover?

correct.

>> +				chan, value);
>> +			return ret;
>> +		}
>> +		prop->hw_settle_time = ret;
>> +	} else {
>> +		prop->hw_settle_time = VADC_DEF_HW_SETTLE_TIME;
>> +	}
>> +
>> +	ret = of_property_read_u32(node, "qcom,avg-samples", &value);
>> +	if (!ret) {
>> +		ret = vadc_avg_samples_from_dt(value);
>> +		if (ret < 0) {
>> +			dev_dbg(dev, "%02x invalid avg-samples %d\n",
>> +				chan, value);
>> +			return ret;
>> +		}
>> +		prop->avg_samples = ret;
>> +	} else {
>> +		prop->avg_samples = VADC_DEF_AVG_SAMPLES;
>> +	}
>> +
>> +	if (of_property_read_bool(node, "qcom,ratiometric"))
>> +		prop->calibration = VADC_CALIB_RATIOMETRIC;
>> +	else
>> +		prop->calibration = VADC_CALIB_ABSOLUTE;
>> +
>> +	dev_dbg(dev, "%02x name %s\n", chan, name);
>> +
>> +	return 0;
>> +}
>> +
>> +static int vadc_get_dt_data(struct vadc_priv *vadc, struct device_node *node)
>> +{
>> +	struct iio_chan_spec *iio_chan = vadc->iio_chans;
>> +	const struct vadc_channels *vadc_chan;
>> +	struct vadc_channel_prop prop;
>> +	struct device_node *child;
>> +	int ret, index = 0;
> index could be defined unsigned, as it should only carry unsigned values.

makes sense.

>> +
>> +	for_each_available_child_of_node(node, child) {
>> +		ret = vadc_get_dt_channel_data(vadc->dev, &prop, child);
>> +		if (ret)
>> +			return ret;
>> +
>> +		vadc->chan_props[index] = prop;
>> +
>> +		vadc_chan = &vadc_chans[prop.channel];
>> +
>> +		iio_chan->channel = prop.channel;
>> +		iio_chan->datasheet_name = vadc_chan->datasheet_name;
>> +		iio_chan->info_mask_separate = vadc_chan->info_mask;
>> +		iio_chan->type = vadc_chan->type;
>> +		iio_chan->indexed = 1;
>> +		iio_chan->scan_type.sign = 's';
>> +		iio_chan->scan_type.realbits = 15;
>> +		iio_chan->scan_type.storagebits = 16;
>> +		iio_chan->address = index++;
>> +
>> +		iio_chan++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +

<snip>

>> +
>> +static int vadc_probe(struct platform_device *pdev)
>> +{
>> +	struct device_node *node = pdev->dev.of_node;
>> +	struct device *dev = &pdev->dev;
>> +	struct iio_dev *indio_dev;
>> +	struct vadc_priv *vadc;
>> +	struct resource *res;
>> +	struct regmap *regmap;
>> +	int ret, irq_eoc;
>> +
>> +	regmap = dev_get_regmap(dev->parent, NULL);
>> +	if (!regmap)
>> +		return -ENODEV;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
>> +	if (!res)
>> +		return -ENODEV;
>> +
>> +	indio_dev = devm_iio_device_alloc(dev, sizeof(*vadc));
>> +	if (!indio_dev)
>> +		return -ENOMEM;
>> +
>> +	vadc = iio_priv(indio_dev);
>> +	vadc->regmap = regmap;
>> +	vadc->dev = dev;
>> +	vadc->base = res->start;
>> +	vadc->are_ref_measured = false;
>> +	init_completion(&vadc->complete);
>> +
>> +	ret = vadc_check_revision(vadc);
>> +	if (ret)
>> +		return ret;
>> +
>> +	vadc->nchannels = of_get_available_child_count(node);
>> +	if (!vadc->nchannels)
>> +		return -EINVAL;
>> +
>> +	vadc->iio_chans = devm_kcalloc(dev, vadc->nchannels,
>> +				       sizeof(*vadc->iio_chans), GFP_KERNEL);
>> +	if (!vadc->iio_chans)
>> +		return -ENOMEM;
>> +
>> +	vadc->chan_props = devm_kcalloc(dev, vadc->nchannels,
>> +					sizeof(*vadc->chan_props), GFP_KERNEL);
>> +	if (!vadc->chan_props)
>> +		return -ENOMEM;
>> +
>> +	ret = vadc_get_dt_data(vadc, node);
>> +	if (ret)
>> +		return ret;
>> +
>> +	irq_eoc = platform_get_irq(pdev, 0);
>> +	if (irq_eoc < 0) {
>> +		if (irq_eoc == -EPROBE_DEFER || irq_eoc == -EINVAL)
>> +			return irq_eoc;
>> +		vadc->poll_eoc = true;
>> +	}
>> +
> Isn't the part below actually the else section of the part above (and device_init_wakeup() belonging up there)?

you are right, might be I wanted to avoid indentation issues. Will see
how to make it better.

>> +	if (!vadc->poll_eoc) {
>> +		ret = devm_request_irq(dev, irq_eoc, vadc_isr,
>> +				       IRQF_TRIGGER_RISING, "spmi-vadc", vadc);
>> +		if (!ret)
>> +			enable_irq_wake(irq_eoc);
>> +		else
>> +			return ret;
> Usually this is done this way:

yes, I know just oversight it.

> 		if (ret)
> 			return ret;
> 
> 		enable_irq_wake(irq_eoc);
>> +	} else {
>> +		device_init_wakeup(vadc->dev, true);
>> +	}
>> +
>> +	ret = vadc_reset(vadc);
>> +	if (ret) {
>> +		dev_dbg(dev, "reset failed\n");
>> +		return ret;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, vadc);
> Why bother to call platform_set_drvdata()?

Seems leftover, will delete.

-- 
regards,
Stan
