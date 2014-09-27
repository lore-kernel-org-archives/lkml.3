Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaI0KG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 06:06:59 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:35951 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaI0KG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 06:06:56 -0400
Message-ID: <54268C39.7030509@kernel.org>
Date: Sat, 27 Sep 2014 11:06:49 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] iio: iadc: Qualcomm SPMI PMIC current ADC driver
References: <1411046123-30625-1-git-send-email-iivanov@mm-sol.com>	 <541EDAE5.50307@kernel.org> <1411461092.18580.30.camel@iivanov-dev>
In-Reply-To: <1411461092.18580.30.camel@iivanov-dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
> 
>>> +static int iadc_poll_wait_eoc(struct iadc_chip *iadc, int interval_us)
>>> +{
>>> +	int ret, count, retry;
>>> +	u8 sta1;
>>> +
>>> +	retry = interval_us / IADC_CONV_TIME_MIN_US;
>>> +
>>> +	for (count = 0; count < retry; count++) {
>>> +		ret = iadc_read(iadc, IADC_STATUS1, &sta1);
>>> +		if (ret < 0)
>>> +			return ret;
>>> +
>>> +		sta1 &= IADC_STATUS1_REQ_STS_EOC_MASK;
>>> +		if (sta1 == IADC_STATUS1_EOC)
>>> +			return 0;
>>> +
>>> +		usleep_range(IADC_CONV_TIME_MIN_US, IADC_CONV_TIME_MAX_US);
>>> +	}
>>> +
>>> +	iadc_status_show(iadc);
>> What is this for?  Left over from debugging the driver?
> 
> This should not generally happen, but will be useful to see what was 
> ADC configuration and statuses, when conversion time outs.
Hmm. Fine I guess, just a lot of code for an unexpected condition
Should probably be as dev_err if it occurs.
> 
>>> +
>>> +	return -ETIMEDOUT;
>>> +}
>>> +
> 
> <snip>
> 
>>> +static int iadc_read_raw(struct iio_dev *indio_dev,
>>> +			 struct iio_chan_spec const *chan,
>>> +			 int *val, int *val2, long mask)
>>> +{
>>> +	struct iadc_chip *iadc = iio_priv(indio_dev);
>>> +	long rsense_ua, rsense_uv, rsense_raw;
>>> +	int ret = -EINVAL, negative;
>>> +	u16 adc_raw;
>>> +
>>> +	mutex_lock(&iadc->lock);
>>> +
>>> +	switch (mask) {
>>> +	case IIO_CHAN_INFO_PROCESSED:
>>> +		ret = iadc_do_conversion(iadc, chan->channel, &adc_raw);
>>> +		if (ret < 0)
>>> +			goto exit;
>>> +
>>> +		rsense_raw = adc_raw - iadc->offset_raw;
>>> +
>>> +		rsense_uv = (rsense_raw * IADC_REF_GAIN_MICRO_VOLTS);
>>> +		rsense_uv /= iadc->gain_raw - iadc->offset_raw;
>>> +
>>> +		negative = 0;
>>> +		if (rsense_uv < 0) {
>>> +			negative = 1;
>>> +			rsense_uv = -rsense_uv;
>>> +		}
>>> +
>>> +		rsense_ua = rsense_uv;
>>> +
>>> +		do_div(rsense_ua, iadc->rsense);
>>> +
>>> +		if (negative)
>>> +			rsense_ua = -rsense_ua;
>>> +
>>> +		dev_dbg(iadc->dev, "offset %d, gain %d, adc %d, V=%ld,uV, I=%ld,uA\n",
>>> +			iadc->offset_raw, iadc->gain_raw, adc_raw,
>>> +			rsense_uv, rsense_ua);
>>> +
>>> +		*val = rsense_ua;
>> Given the naming this seems unlikely to be in millamps?
> 
> Yes, it is micro amps. I was unable to find what should be correct
> dimension. There is nothing in sysfs-bus-iio or bindings/iio.
There is now (in the togreg branch of iio.git;)  Wasn't until very recently though.
Somehow it got lost in the move out of staging...  The scaling comes form hwmon,
With hindsight we should probably have ditched it in favour of using Volts and Amps
as our base scaling.  Less confusing, but too late now!
> 
>>> +		ret = IIO_VAL_INT;
>>> +		break;
>>> +	default:
>>> +		break;
>>> +	}
>>> +
>>> +exit:
>>> +	mutex_unlock(&iadc->lock);
>>> +
>>> +	return ret;
>>> +}
>>> +
> 
> <snip>

>>> +
>>> +static int iadc_rsense_read(struct iadc_chip *iadc, struct device_node *node)
>>> +{
>>> +	unsigned int trim_val;
>>> +	u8  rsense, const_rds;
>>> +	int ret, negative;
>>> +	u32 trim_type;
>>> +
>>> +	ret = of_property_read_u32(node, "qcom,rsense", &iadc->rsense);
>>> +	if (!ret) {
>>> +		iadc->ext_sense = true;
>>> +		return 0;
>>> +	}
> 
> User specify external sense resistor value, which means external
> channel should be used.
> 
>>> +
>>> +	ret = iadc_read(iadc, IADC_NOMINAL_RSENSE, &rsense);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	negative = 0;
>>> +	if (rsense & IADC_NOMINAL_RSENSE_SIGN_MASK)
>>> +		negative = 1;
>> I'm a little confused.  The docs say that rsense is a resistor value in
>> ohms (u32).  Why does bit 7 allow encode other information?
> 
> External sense resistor value not specified, driver will use internal
> ADC channel and internal sense resistor, so read what was trimmed
> during manufacturing process. Sense register value is read from
> register. If bit 7 of value is set value in register is negative.
> Register itself didn't contain value in ohms, but difference between
> desired and actual value.
Ah got it.  Thanks for the explanation.
Perhaps ensure that iadc->rsense is clearly in ohms wherease this local
rsense is the register value (rename one of them!)
> 
>>> +
>>> +	rsense &= ~IADC_NOMINAL_RSENSE_SIGN_MASK;
>>> +
>>> +	iadc->rsense = IADC_INTERNAL_RSENSE_OHMS;
>>> +	if (negative)
>>> +		iadc->rsense -=	rsense * IADC_RSENSE_OHMS_PER_BIT;
>>> +	else
>>> +		iadc->rsense +=	rsense * IADC_RSENSE_OHMS_PER_BIT;
> 
> internal rsense = 10000000 + sign * 15625 * value;
> 
>>> +
>>> +	if (rsense < IADC_TRIM2_FULLSCALE)
>>> +		return 0;
>>> +	/*
>>> +	 * Trim register is "saturated", check for specific trim value
>>> +	 * based on manufacturer and RDS constant
>>> +	 */
>>> +	ret = of_property_read_u32(node, "qcom,rds-trim", &trim_type);
>>> +	if (ret)
>>> +		return 0;
>>> +
>>> +	ret = regmap_read(iadc->regmap, iadc->trim_rds, &trim_val);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	const_rds = trim_val & IADC_TRIM_CNST_RDS_MASK;
>>> +
>>> +	dev_dbg(iadc->dev, "factory %d trim type %d rsense %d const %d\n",
>>> +		iadc->factory, trim_type, rsense, const_rds);
>>> +
>>> +	switch (trim_type) {
>>> +	case 0:
>>> +		if (const_rds == 2)
>>> +			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
>> So this is overwriting rsense if properties are obeyed.  Would it not
>> make sense to do this before using the rsense value above (if these
>> constraints are not met?)
> 
> We are coming here only if value trimmed into IADC_NOMINAL_RSENSE
> register is saturated i.e, u8 value is 127, bit 7 is sign bit. Which 
> means that internal resistor is far from desired value. And this 
> depends on the factory used for manufacturing the chip. The whole 
> logic here is simplified version, I believe, on the downstream 
> implementation, which could be found here[1].
> 
> [1] https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/hwmon/qpnp-adc-current.c?h=msm-3.10
> 
>>> +		break;
>>> +	case 1:
>>> +		if (const_rds >= 2) {
>>> +			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
>>> +		} else if (const_rds < 2) {
>>> +			if (iadc->factory == IADC_FACTORY_GF)
>>> +				iadc->rsense = IADC_RSENSE_DEFAULT_GF;
>>> +			else if (iadc->factory == IADC_FACTORY_SMIC)
>>> +				iadc->rsense = IADC_RSENSE_DEFAULT_SMIC;
>>> +		}
>>> +		break;
>>> +	case 2:
>>> +		if (const_rds > 0 && const_rds <= 2)
>>> +			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int iadc_probe(struct platform_device *pdev)
>>> +{
>>> +	struct device_node *node = pdev->dev.of_node;
>>> +	struct device *dev = &pdev->dev;
>>> +	struct iio_chan_spec *iio_chan;
>>> +	struct iio_dev *indio_dev;
>>> +	struct iadc_chip *iadc;
>>> +	struct resource *res;
>>> +	struct regmap *regmap;
>>> +	int ret, irq_eoc;
>>> +
>>> +	regmap = dev_get_regmap(dev->parent, NULL);
>>> +	if (!regmap)
>>> +		return -ENODEV;
>>> +
>>> +	indio_dev = devm_iio_device_alloc(dev, sizeof(*iadc));
>>> +	if (!indio_dev)
>>> +		return -ENOMEM;
>> Spinning the order of the regmap get and iio_device_alloc would perhaps
>> give a cleaner result as you could then fill iadc->regmap directly...
>> (marginal!)
> 
> No local variables, right? :-)
Well only when they actually make the code cleaner!

> Thank you for review.
You are welcome

Jonathan
> 
> Regards,
> Ivan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
