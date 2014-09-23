Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaIWIbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:31:37 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45567 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbaIWIbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:31:32 -0400
Message-ID: <1411461092.18580.30.camel@iivanov-dev>
Subject: Re: [PATCH] iio: iadc: Qualcomm SPMI PMIC current ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 23 Sep 2014 11:31:32 +0300
In-Reply-To: <541EDAE5.50307@kernel.org>
References: <1411046123-30625-1-git-send-email-iivanov@mm-sol.com>
	 <541EDAE5.50307@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Sun, 2014-09-21 at 15:04 +0100, Jonathan Cameron wrote:
> On 18/09/14 14:15, Ivan T. Ivanov wrote:

<snip>

> > +config QCOM_SPMI_IADC
> > +	tristate "Qualcomm SPMI PMIC current ADC"
> > +	select REGMAP_SPMI
> > +	depends on IIO
> > +	help
> > +	  This is the IIO Current ADC driver for Qualcomm QPNP IADC Chip.
> > +
> > +	  The driver supports single mode operation to read from upto seven channel
> channels?  You only seem to register one...

Will reword.

> > +	  configuration that include reading the external/internal Rsense, CSP_EX,
> > +	  CSN_EX pair along with the gain and offset calibration.
> > +
> >  endmenu

<snip>

> > +struct iadc_chip {
> > +	struct regmap *regmap;
> > +	struct device *dev;
> > +	u8 factory;
> > +	u16 base;
> > +	u16 trim_rds;
> > +	int rsense;
> > +	bool ext_sense;
> > +	bool poll_eoc;
> > +	u16 offset_raw;
> > +	u16 gain_raw;
> > +	struct mutex lock;
> > +	struct completion complete;
> > +	struct iio_chan_spec iio_chan;
> As explained below, better to have this as static const outside of
> here.

Thanks, already done as per Peter comments.

> > +};
> > +
> > +static int iadc_read(struct iadc_chip *iadc, u16 offset, u8 *data)
> > +{
> > +	unsigned int val;
> > +	int ret;
> > +
> > +	ret = regmap_read(iadc->regmap, iadc->base + offset, &val);
> > +	if (!ret)
> > +		*data = val;
> > +
> > +	return ret;
> > +}
> Borderline whether these wrappers add significant value... I suppose they
> hide the application of the offset.

Yes, and will like to keep them.

> > +
> > +static int iadc_write(struct iadc_chip *iadc, u16 offset, u8 data)
> > +{
> > +	return regmap_write(iadc->regmap, iadc->base + offset, data);
> > +}
> > +
> > +static int iadc_reset(struct iadc_chip *iadc)
> > +{
> > +	u8 data;
> > +	int ret;
> > +
> > +	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = iadc_read(iadc, IADC_PERH_RESET_CTL3, &data);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	data |= IADC_FOLLOW_WARM_RB;
> > +
> > +	return iadc_write(iadc, IADC_PERH_RESET_CTL3, data);
> > +}
> > +
> > +static int iadc_enable(struct iadc_chip *iadc, bool state)
> iadc_set_state prefered as enable(false) does not necessarily mean
> disable.

Ok.

> > +static int iadc_poll_wait_eoc(struct iadc_chip *iadc, int interval_us)
> > +{
> > +	int ret, count, retry;
> > +	u8 sta1;
> > +
> > +	retry = interval_us / IADC_CONV_TIME_MIN_US;
> > +
> > +	for (count = 0; count < retry; count++) {
> > +		ret = iadc_read(iadc, IADC_STATUS1, &sta1);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		sta1 &= IADC_STATUS1_REQ_STS_EOC_MASK;
> > +		if (sta1 == IADC_STATUS1_EOC)
> > +			return 0;
> > +
> > +		usleep_range(IADC_CONV_TIME_MIN_US, IADC_CONV_TIME_MAX_US);
> > +	}
> > +
> > +	iadc_status_show(iadc);
> What is this for?  Left over from debugging the driver?

This should not generally happen, but will be useful to see what was 
ADC configuration and statuses, when conversion time outs.

> > +
> > +	return -ETIMEDOUT;
> > +}
> > +

<snip>

> > +static int iadc_read_raw(struct iio_dev *indio_dev,
> > +			 struct iio_chan_spec const *chan,
> > +			 int *val, int *val2, long mask)
> > +{
> > +	struct iadc_chip *iadc = iio_priv(indio_dev);
> > +	long rsense_ua, rsense_uv, rsense_raw;
> > +	int ret = -EINVAL, negative;
> > +	u16 adc_raw;
> > +
> > +	mutex_lock(&iadc->lock);
> > +
> > +	switch (mask) {
> > +	case IIO_CHAN_INFO_PROCESSED:
> > +		ret = iadc_do_conversion(iadc, chan->channel, &adc_raw);
> > +		if (ret < 0)
> > +			goto exit;
> > +
> > +		rsense_raw = adc_raw - iadc->offset_raw;
> > +
> > +		rsense_uv = (rsense_raw * IADC_REF_GAIN_MICRO_VOLTS);
> > +		rsense_uv /= iadc->gain_raw - iadc->offset_raw;
> > +
> > +		negative = 0;
> > +		if (rsense_uv < 0) {
> > +			negative = 1;
> > +			rsense_uv = -rsense_uv;
> > +		}
> > +
> > +		rsense_ua = rsense_uv;
> > +
> > +		do_div(rsense_ua, iadc->rsense);
> > +
> > +		if (negative)
> > +			rsense_ua = -rsense_ua;
> > +
> > +		dev_dbg(iadc->dev, "offset %d, gain %d, adc %d, V=%ld,uV, I=%ld,uA\n",
> > +			iadc->offset_raw, iadc->gain_raw, adc_raw,
> > +			rsense_uv, rsense_ua);
> > +
> > +		*val = rsense_ua;
> Given the naming this seems unlikely to be in millamps?

Yes, it is micro amps. I was unable to find what should be correct
dimension. There is nothing in sysfs-bus-iio or bindings/iio.

> > +		ret = IIO_VAL_INT;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +exit:
> > +	mutex_unlock(&iadc->lock);
> > +
> > +	return ret;
> > +}
> > +

<snip>

> > +
> > +static int iadc_update_trim_offset(struct iadc_chip *iadc)
> > +{
> > +	u16 adc_raw;
> > +	u8  lsb, msb;
> > +	int ret, chan;
> > +
> > +	ret = iadc_do_conversion(iadc, IADC_GAIN_17P857MV, &adc_raw);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	iadc->gain_raw = adc_raw;
> There is no real purpose in having the local variable adc_raw.
> It won't get written unless everything is fine anyway so why
> not use iadc->gain_raw directly in the do_conversion call.
> 
> > +
> > +	chan = IADC_OFFSET_CSP2_CSN2;
> > +	if (iadc->ext_sense)
> > +		chan = IADC_OFFSET_CSP_CSN;
> > +
> > +	ret = iadc_do_conversion(iadc, chan, &adc_raw);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	iadc->offset_raw = adc_raw;
> > +
> > +	if ((iadc->gain_raw - iadc->offset_raw) == 0) {
> > +		dev_err(iadc->dev, "error: offset %d gain %d\n",
> > +			iadc->offset_raw, iadc->gain_raw);
> > +		return -EINVAL;
> > +	}
> > +
> > +	msb = adc_raw >> 8;
> > +	lsb = adc_raw & 0xff;
> Do these directly where needed rather than bothering with local
> variables.

Ok. No local variables, I get it :-)

> > +
> > +	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = iadc_write(iadc, IADC_MSB_OFFSET, msb);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return iadc_write(iadc, IADC_LSB_OFFSET, lsb);
> > +}
> > +

> > +
> > +static int iadc_rsense_read(struct iadc_chip *iadc, struct device_node *node)
> > +{
> > +	unsigned int trim_val;
> > +	u8  rsense, const_rds;
> > +	int ret, negative;
> > +	u32 trim_type;
> > +
> > +	ret = of_property_read_u32(node, "qcom,rsense", &iadc->rsense);
> > +	if (!ret) {
> > +		iadc->ext_sense = true;
> > +		return 0;
> > +	}

User specify external sense resistor value, which means external
channel should be used.

> > +
> > +	ret = iadc_read(iadc, IADC_NOMINAL_RSENSE, &rsense);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	negative = 0;
> > +	if (rsense & IADC_NOMINAL_RSENSE_SIGN_MASK)
> > +		negative = 1;
> I'm a little confused.  The docs say that rsense is a resistor value in
> ohms (u32).  Why does bit 7 allow encode other information?

External sense resistor value not specified, driver will use internal
ADC channel and internal sense resistor, so read what was trimmed
during manufacturing process. Sense register value is read from
register. If bit 7 of value is set value in register is negative.
Register itself didn't contain value in ohms, but difference between
desired and actual value. 

> > +
> > +	rsense &= ~IADC_NOMINAL_RSENSE_SIGN_MASK;
> > +
> > +	iadc->rsense = IADC_INTERNAL_RSENSE_OHMS;
> > +	if (negative)
> > +		iadc->rsense -=	rsense * IADC_RSENSE_OHMS_PER_BIT;
> > +	else
> > +		iadc->rsense +=	rsense * IADC_RSENSE_OHMS_PER_BIT;

internal rsense = 10000000 + sign * 15625 * value;

> > +
> > +	if (rsense < IADC_TRIM2_FULLSCALE)
> > +		return 0;
> > +	/*
> > +	 * Trim register is "saturated", check for specific trim value
> > +	 * based on manufacturer and RDS constant
> > +	 */
> > +	ret = of_property_read_u32(node, "qcom,rds-trim", &trim_type);
> > +	if (ret)
> > +		return 0;
> > +
> > +	ret = regmap_read(iadc->regmap, iadc->trim_rds, &trim_val);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	const_rds = trim_val & IADC_TRIM_CNST_RDS_MASK;
> > +
> > +	dev_dbg(iadc->dev, "factory %d trim type %d rsense %d const %d\n",
> > +		iadc->factory, trim_type, rsense, const_rds);
> > +
> > +	switch (trim_type) {
> > +	case 0:
> > +		if (const_rds == 2)
> > +			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
> So this is overwriting rsense if properties are obeyed.  Would it not
> make sense to do this before using the rsense value above (if these
> constraints are not met?)

We are coming here only if value trimmed into IADC_NOMINAL_RSENSE
register is saturated i.e, u8 value is 127, bit 7 is sign bit. Which 
means that internal resistor is far from desired value. And this 
depends on the factory used for manufacturing the chip. The whole 
logic here is simplified version, I believe, on the downstream 
implementation, which could be found here[1].

[1] https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/hwmon/qpnp-adc-current.c?h=msm-3.10

> > +		break;
> > +	case 1:
> > +		if (const_rds >= 2) {
> > +			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
> > +		} else if (const_rds < 2) {
> > +			if (iadc->factory == IADC_FACTORY_GF)
> > +				iadc->rsense = IADC_RSENSE_DEFAULT_GF;
> > +			else if (iadc->factory == IADC_FACTORY_SMIC)
> > +				iadc->rsense = IADC_RSENSE_DEFAULT_SMIC;
> > +		}
> > +		break;
> > +	case 2:
> > +		if (const_rds > 0 && const_rds <= 2)
> > +			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int iadc_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *node = pdev->dev.of_node;
> > +	struct device *dev = &pdev->dev;
> > +	struct iio_chan_spec *iio_chan;
> > +	struct iio_dev *indio_dev;
> > +	struct iadc_chip *iadc;
> > +	struct resource *res;
> > +	struct regmap *regmap;
> > +	int ret, irq_eoc;
> > +
> > +	regmap = dev_get_regmap(dev->parent, NULL);
> > +	if (!regmap)
> > +		return -ENODEV;
> > +
> > +	indio_dev = devm_iio_device_alloc(dev, sizeof(*iadc));
> > +	if (!indio_dev)
> > +		return -ENOMEM;
> Spinning the order of the regmap get and iio_device_alloc would perhaps
> give a cleaner result as you could then fill iadc->regmap directly...
> (marginal!)

No local variables, right? :-)

> > +
> > +	iadc = iio_priv(indio_dev);
> > +	iadc->dev = dev;
> > +	iadc->regmap = regmap;
> > +	init_completion(&iadc->complete);
> > +	mutex_init(&iadc->lock);
> > +
> > +	platform_set_drvdata(pdev, iadc);
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
> > +	if (!res)
> > +		return -ENODEV;
> > +
> > +	iadc->base = res->start;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_REG, 1);
> > +	if (!res)
> > +		return -ENODEV;
> > +
> > +	iadc->trim_rds = res->start;
> > +
> > +	ret = iadc_version_check(iadc);
> > +	if (ret < 0)
> > +		return -ENODEV;
> > +
> > +	ret = iadc_rsense_read(iadc, node);
> > +	if (ret < 0)
> > +		return -ENODEV;
> > +
> > +	dev_dbg(iadc->dev, "%s sense resistor %d Ohm\n", iadc->ext_sense ?
> > +		"external" : "internal", iadc->rsense);
> > +
> > +	irq_eoc = platform_get_irq(pdev, 0);
> > +	if (irq_eoc == -EPROBE_DEFER)
> > +		return irq_eoc;
> > +
> > +	if (irq_eoc < 0)
> > +		iadc->poll_eoc = true;
> > +
> > +	ret = iadc_reset(iadc);
> > +	if (ret < 0) {
> > +		dev_err(dev, "reset failed\n");
> > +		return ret;
> > +	}
> > +
> > +	if (!iadc->poll_eoc) {
> > +		ret = devm_request_irq(dev, irq_eoc, iadc_isr, 0,
> > +					"spmi-iadc", iadc);
> > +		if (!ret)
> > +			enable_irq_wake(irq_eoc);
> > +		else
> > +			return ret;
> > +	} else {
> > +		device_init_wakeup(iadc->dev, 1);
> > +	}
> > +
> > +	ret = iadc_update_trim_offset(iadc);
> > +	if (ret < 0) {
> > +		dev_err(dev, "failed trim offset calibration\n");
> > +		return ret;
> > +	}
> > +
> This stuff is basically constant configuration data, except that you
> have two choices.   Just have two static const struct iio_chan entries
> outside here and pick between them based on ext_sense.
> Also, why give them different channel numbers?  Looks like it is just
> to distinguish them in driver.  If so, use address instead.
> e.g.
> 
> static const struct iio_chan_spec iadc_channel_ext_rsense = {
>        .type = IIO_CURRENT,
>        .info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
>        .address = 1,
>        .datasheet_name = "EXTERNAL_RSENSE",
> };
> 
> static const struct iio_chan_spec iadc_channel_int_rsense = {
>        .type = IIO_CURRENT,
>        .info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
>        .address = 0,
>        .datasheet_name = "INTERNAL_RSENSE",
> };
> 
> No need to have a copy in iadc then...
> 
> The only time dynamic allocation of iio_chan_spec structures
> makes sense is when there are lots of combinations and the
> static const approach becomes too unweildy.

Already done.

Thank you for review.

Regards,
Ivan

