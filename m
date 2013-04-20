Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3DTPi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 11:38:57 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40787 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3DTPiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 11:38:55 -0400
Message-ID: <5172B68B.4010506@free-electrons.com>
Date: Sat, 20 Apr 2013 17:38:51 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1366299536-18353-1-git-send-email-alexandre.belloni@free-electrons.com> <1366299536-18353-2-git-send-email-alexandre.belloni@free-electrons.com> <51726541.6060304@kernel.org>
In-Reply-To: <51726541.6060304@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Thanks for your review,

On 20/04/2013 11:52, Jonathan Cameron wrote:
> A few bits and pieces inline.
>
> Ouch, that interrupt handling is annoyingly complex.  Pesky hardware
> designers...
>

Right, even worse is that on the board we are using, the interrupt line
is connected to a pca9555 and that seems to not handle interrupts very
well and I think something is fishy in the driver. From want I read in
the datasheet, I suspect it only handles level interrupts but the driver
is only accepting edge interrupts.
It seems that sometimes we end up with the nau7802 correctly sending an
interrupt, the pca also correctly sending an interrupt but the pca
driver is then not calling the interrupt handlers. I also suspect the
nau7802 to forget to switch the interrupt line when we ask for fast
conversions. I investigated that a bit but I'm still waiting for my
logic analyzer to get delivered to go further.

>> diff --git a/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt b/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
>> new file mode 100644
>> index 0000000..9bc4218
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
>> @@ -0,0 +1,17 @@
>> +* Nuvoton NAU7802 Analog to Digital Converter (ADC)
>> +
>> +Required properties:
>> +  - compatible: Should be "nuvoton,nau7802"
>> +  - reg: Should contain the ADC I2C address
>> +
>> +Optional properties:
>> +  - nuvoton,vldo: Reference voltage in millivolts (integer)
> As this is external I'd personally prefer using the regulator subsystem
> to provide it.  That gives a more flexible way of supplying it.
> If fixed you can always use a fixed regulator...

Actually, that one allows us to configure the internal LDO. The nau7802
is also able to get that voltage from an external source but indeed,
this is not well handled by the driver currently. How do you suggest to
manage those cases then ?

>
> +
> +struct nau7802_state {
> +	struct i2c_client	*client;
> +	s32			last_value;
> I can't immediately see why you need two locks...
> I think the datalock is only ever taken when the
> lock is already held (be it in a threaded irq).

Actually, "lock" is taken by read_raw() but, we still want the interrupt
handler thread to be able to run while waiting for the completion (else,
we would just timeout every time). Main goal of data_lock is to prevent
reading part of the output from the interrupt handler and part from
read_raw().

>> +	struct mutex		lock;
>> +	struct mutex		data_lock;
>> +	u32			vref_mv;
>> +	u32			conversion_count;
>> +	u32			min_conversions;
>> +	u8			sample_rate;
>> +	struct completion	value_ok;
>> +};
>> +
>> +static int nau7802_i2c_read(struct nau7802_state *st, u8 reg, u8 *data)
>> +{
>> +	int ret = 0;
>> +
>> +	ret = i2c_smbus_read_byte_data(st->client, reg);
>> +	if (ret < 0) {
>> +		dev_err(&st->client->dev, "failed to read from I2C\n");
>> +		return ret;
>> +	}
>> +
>> +	*data = ret;
>> +
>> +	return 0;
>> +}
>> +
> Don't wrap standard functions like this. Call them directly. It's not
> worth the added complexity to get a not particularly informative error message
> from the read.

OK, it was mainly useful for debugging as we had some troubles with the
underlying i2c driver. I will remove those.

>> +static int nau7802_i2c_write(struct nau7802_state *st, u8 reg, u8 data)
>> +{
>> +	return i2c_smbus_write_byte_data(st->client, reg, data);
>> +}
>> +
>> +static const u16 nau7802_sample_freq_avail[] = {10, 20, 40, 80,
>> +						10, 10, 10, 320};
>> +
>> +static ssize_t nau7802_sysfs_set_sampling_frequency(struct device *dev,
>> +		struct device_attribute *attr,
>> +		const char *buf,
>> +		size_t len)
>> +{
>> +	struct iio_dev *idev = dev_to_iio_dev(dev);
>> +	struct nau7802_state *st = iio_priv(idev);
>> +	u32 val;
>> +	int ret, i;
>> +
>> +	ret = kstrtouint(buf, 10, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = -EINVAL;
>> +	for (i = 0; i < 8; i++)
>> +		if (val == nau7802_sample_freq_avail[i]) {
>> +			mutex_lock(&st->lock);
>> +			st->sample_rate = i;
>> +			st->conversion_count = 0;
>> +			nau7802_i2c_write(st, NAU7802_REG_CTRL2,
>> +					NAU7802_CTRL2_CRS(st->sample_rate));
>> +			mutex_unlock(&st->lock);
>> +			ret = len;
>> +			break;
>> +		}
>> +	return ret;
>> +}
>> +
>> +static ssize_t nau7802_sysfs_get_sampling_frequency(struct device *dev,
>> +		struct device_attribute *attr,
>> +		char *buf)
>> +{
>> +	struct iio_dev *idev = dev_to_iio_dev(dev);
>> +	struct nau7802_state *st = iio_priv(idev);
>> +
>> +	return sprintf(buf, "%d\n",
>> +	       nau7802_sample_freq_avail[st->sample_rate]);
>> +}
>> +
>> +static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
>> +		nau7802_sysfs_get_sampling_frequency,
>> +		nau7802_sysfs_set_sampling_frequency);
>> +
>> +static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("10 40 80 320");
>> +
>> +static IIO_CONST_ATTR(gain_available, "1 2 4 8 16 32 64 128");
>> +
>> +static ssize_t nau7802_sysfs_set_gain(struct device *dev,
>> +		struct device_attribute *attr,
>> +		const char *buf,
>> +		size_t len)
>> +{
>> +	struct iio_dev *idev = dev_to_iio_dev(dev);
>> +	struct nau7802_state *st = iio_priv(idev);
>> +	u32 val;
>> +	u8 data;
>> +	int ret;
>> +
>> +	ret = kstrtouint(buf, 10, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (val < 1 || val > 128 || !is_power_of_2(val))
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&st->lock);
>> +	st->conversion_count = 0;
>> +
>> +	ret = nau7802_i2c_read(st, NAU7802_REG_CTRL1, &data);
>> +	if (ret < 0)
>> +		goto nau7802_sysfs_set_gain_out;
>> +	ret = nau7802_i2c_write(st, NAU7802_REG_CTRL1,
>> +			(data & (~NAU7802_CTRL1_GAINS_BITS)) | ilog2(val));
>> +nau7802_sysfs_set_gain_out:
>> +	mutex_unlock(&st->lock);
>> +	return ret ? ret : len;
>> +}
>> +
>> +static ssize_t nau7802_sysfs_get_gain(struct device *dev,
>> +		struct device_attribute *attr,
>> +		char *buf)
>> +{
>> +	struct iio_dev *idev = dev_to_iio_dev(dev);
>> +	struct nau7802_state *st = iio_priv(idev);
>> +	u8 data;
>> +	int ret;
>> +
>> +	ret = nau7802_i2c_read(st, NAU7802_REG_CTRL1, &data);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return sprintf(buf, "%d\n", 1 << (data & NAU7802_CTRL1_GAINS_BITS));
>> +}
>> +
>> +static IIO_DEVICE_ATTR(gain, S_IWUSR | S_IRUGO,
>> +		nau7802_sysfs_get_gain,
>> +		nau7802_sysfs_set_gain, 0);
>> +
>> +static ssize_t nau7802_sysfs_set_min_conversions(struct device *dev,
>> +		struct device_attribute *attr,
>> +		const char *buf,
>> +		size_t len)
>> +{
>> +	struct iio_dev *idev = dev_to_iio_dev(dev);
>> +	struct nau7802_state *st = iio_priv(idev);
>> +	u32 val;
>> +	int ret;
>> +
>> +	ret = kstrtouint(buf, 10, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	mutex_lock(&st->lock);
>> +	st->min_conversions = val;
>> +	st->conversion_count = 0;
>> +	mutex_unlock(&st->lock);
>> +	return len;
>> +}
>> +
>> +static ssize_t nau7802_sysfs_get_min_conversions(struct device *dev,
>> +		struct device_attribute *attr,
>> +		char *buf)
>> +{
>> +	struct iio_dev *idev = dev_to_iio_dev(dev);
>> +	struct nau7802_state *st = iio_priv(idev);
>> +
>> +	return sprintf(buf, "%d\n", st->min_conversions);
>> +}
>> +
>> +static IIO_DEVICE_ATTR(min_conversions, S_IWUSR | S_IRUGO,
>> +		nau7802_sysfs_get_min_conversions,
>> +		nau7802_sysfs_set_min_conversions, 0);
>> +
>> +static struct attribute *nau7802_attributes[] = {
> Given you have only adc channels you could just use the relevant
> info_mask element for and have this as a shared attribute of them.

Right, I'll have a look at that.
>> +	&iio_dev_attr_sampling_frequency.dev_attr.attr,
>> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
> Just have a range of scale options available and figure out which
> gain they correspond to.  Obviously you'll need a write_raw callback
> to implement that, but it's pretty standard and conforms to the iio
> abi which this does not.   I've been meaning to clean up the way
> 'available' is handled but for now you will probaby want to have
> a suitable gain here.

Yeah, I was wondering about doing that. But as it is also possible to
set the internal voltage, I will have to be clever to get the best vldo
and gain couple to have the best range.

>> +	&iio_dev_attr_gain.dev_attr.attr,
>> +	&iio_const_attr_gain_available.dev_attr.attr,
>> +	&iio_dev_attr_min_conversions.dev_attr.attr,
> What governs this?  Looks to me more like it should be hidden away
> in the device tree than be here.

I guess it will depend on what you connect to your adc. Do we want to
fix that in the DT or to be able to change it at runtime ?

>> +	NULL
>> +};
>> +
>> +static const struct attribute_group nau7802_attribute_group = {
>> +	.attrs = nau7802_attributes,
>> +};
>> +
>> +static int nau7802_read_conversion(struct nau7802_state *st)
>> +{
>> +	int ret;
>> +	u8 data;
>> +
>> +	mutex_lock(&st->data_lock);
>> +	ret = nau7802_i2c_read(st, NAU7802_REG_ADC_B2, &data);
>> +	if (ret)
>> +		goto nau7802_read_conversion_out;
>> +	st->last_value = data << 24;
>> +
>> +	ret = nau7802_i2c_read(st, NAU7802_REG_ADC_B1, &data);
>> +	if (ret)
>> +		goto nau7802_read_conversion_out;
>> +	st->last_value |= data << 16;
>> +
>> +	ret = nau7802_i2c_read(st, NAU7802_REG_ADC_B0, &data);
>> +	if (ret)
>> +		goto nau7802_read_conversion_out;
>> +	st->last_value |= data << 8;
>> +
>> +	st->last_value >>= 8;
> umm. Why shift everything 8 to the left then 8 to the right?

The nau7802 is handling 24 bits of *signed* data. Doing that allows us
to store the signed 24bits value in a signed 32bits integer. Is there a
more clever way ?

>> +
>> +nau7802_read_conversion_out:
>> +	mutex_unlock(&st->data_lock);
>> +	return ret;
>> +}
>> +
> What does this do?  Perhaps a comment?
The conversions are synchronized on the rising edge of the CS bit of
PUCTRL. It is not necessarily needed but it can be nice when wse are
running slow, like at 10 samples per second.
>> +static int nau7802_sync(struct nau7802_state *st)
>> +{
>> +	int ret;
>> +	u8 data;
>> +
>> +	ret = nau7802_i2c_read(st, NAU7802_REG_PUCTRL, &data);
>> +	if (ret)
>> +		return ret;
>> +	ret = nau7802_i2c_write(st, NAU7802_REG_PUCTRL,
>> +				data | NAU7802_PUCTRL_CS_BIT);
>> +	return ret;
>> +}
>> +
>> +static irqreturn_t nau7802_eoc_trigger(int irq, void *private)
>> +{
>> +	struct iio_dev *idev = private;
>> +	struct nau7802_state *st = iio_priv(idev);
>> +	u8 status;
>> +	int ret;
>> +
>> +	ret = nau7802_i2c_read(st, NAU7802_REG_PUCTRL, &status);
>> +	if (ret)
>> +		return IRQ_HANDLED;
>> +
>> +	if (!(status & NAU7802_PUCTRL_CR_BIT))
>> +		return IRQ_NONE;
>> +
>> +	if (nau7802_read_conversion(st))
>> +		return IRQ_HANDLED;
>> +
>> +	/* wait for enough conversions before getting a stable value when
>> +	 * changing channels */
>> +	if (st->conversion_count < st->min_conversions)
>> +		st->conversion_count++;
>> +	if (st->conversion_count >= st->min_conversions)
>> +		complete_all(&st->value_ok);
> pretty much always stick in a  blank line before return statements.
> Makes it easier to read...

Will do.
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int nau7802_read_irq(struct iio_dev *idev,
>> +			struct iio_chan_spec const *chan,
>> +			int *val)
>> +{
>> +	struct nau7802_state *st = iio_priv(idev);
>> +	int ret;
>> +
>> +	INIT_COMPLETION(st->value_ok);
> So let me see if I have this correct.
>> +	enable_irq(st->client->irq);
> This will probably fire immediately as it is a level irq and we have had
> it masked.

It fires almost immediately. But like I said, on my setup the pca
doesn't seem to reliably call the interrupt handler at hte correct time.
Also, sometimes, as it is an interrupt thread, it may actually be
scheduled a bit later.
>> +
>> +	nau7802_sync(st);
> This flushes the device?
>> +
>> +	/* read registers to ensure we flush everything */
>> +	ret = nau7802_read_conversion(st);
>> +	if (ret)
>> +		goto read_chan_info_failure;
>> +
> This then ensures we have scrubbed any left over data?  Might scrub
> some extra but that isn't a problem...

We have to read the 3 output registers to be sure we shift out the
previous conversion result. It is also supposed to ensure we will get an
interrupt.

>> +	/* Wait for a conversion to finish */
>> +	ret = wait_for_completion_interruptible_timeout(&st->value_ok,
>> +			msecs_to_jiffies(1000));
> This will fire next time we have new data?

Yeah, we are actually waiting for a minimum number of conversions to
happen when switching channels because there is actually only one ADC
for the 2 channels. When the value are far apart, we have to wait for
some conversions to happen before we get a significant value. Maybe I
can add a comment for that too ?
> +	case IIO_CHAN_INFO_SCALE:
> +		ret = nau7802_i2c_read(st, NAU7802_REG_CTRL1, &data);
> +		if (ret < 0)
> +			return ret;
> +
> +		*val = 0;
> +		*val2 = (((u64)st->vref_mv) * 1000000000ULL) >>
> +			(chan->scan_type.realbits +
> +			 (data & NAU7802_CTRL1_GAINS_BITS));
> It's saturday morning and I'm half asleep so I'll take your word for
> this being the nicest way of computing this. However with a 23 bit
> adc measuring around 5V? I would have thought to get a decent number
> of significant figures you'd want to do IIO_VAL_INT_PLUS_NANO?

Sure, will do. It actually took me quite some time to get it right and
then I forgot to switch to IIO_VAL_INT_PLUS_NANO.

>> +		return IIO_VAL_INT_PLUS_MICRO;
>> +	default:
>> +		break;
>> +	}
>> +	return -EINVAL;
>> +}
>> +
>> +static const struct iio_info nau7802_info = {
>> +	.driver_module = THIS_MODULE,
>> +	.read_raw = &nau7802_read_raw,
>> +	.attrs = &nau7802_attribute_group,
>> +};
>> +
>> +static int nau7802_channel_init(struct iio_dev *idev)
>> +{
>> +	struct iio_chan_spec *chan_array;
>> +	int i;
>> +
>> +	idev->num_channels = 2;
>> +
>> +	chan_array = devm_kzalloc(&idev->dev,
>> +				  sizeof(*chan_array) * idev->num_channels,
>> +				  GFP_KERNEL);
>> +
> There are only two of them and that is pretty much fixed.  Do this with
> a const static array rather than dynamically. If you really want the
> flexibility on number of channels, then just set idev->num_channels
> appropriately and it'll ignore later entries in the table.
>
> Dynamic allocation only makes sense where we have a huge and complex
> set of possible channel combinations.

Ok, we only have 2 channels anyway.

>> +	for (i = 0; i < idev->num_channels; i++) {
>> +		struct iio_chan_spec *chan = chan_array + i;
>> +
>> +		chan->type = IIO_VOLTAGE;
>> +		chan->indexed = 1;
>> +		chan->channel = i;
>> +		chan->scan_index = i;
>> +		chan->scan_type.sign = 's';
>> +		chan->scan_type.realbits = 23;
> As I read it this part is a 24bit adc where they are committing to 23bits of good
> precision. As such realbits should be 24.
> Not that it's used for anything unless you are doing buffering!
> (so feel free to drop the scan_index and san_type entirely.
>> +		chan->scan_type.storagebits = 24;
>> +		chan->info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
>> +			IIO_CHAN_INFO_RAW_SEPARATE_BIT;
> This has changed, take a look at the latest staging-next.

I'll have a look.

>> +	}
>> +	idev->channels = chan_array;
>> +
>> +	return idev->num_channels;
>> +}
>> +
>> +static int nau7802_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct iio_dev *idev;
>> +	struct nau7802_state *st;
>> +	struct device_node *np = client->dev.of_node;
>> +	int ret;
>> +	u8 data;
>> +	u32 tmp;
>> +
>> +	if (!client->dev.of_node) {
>> +		dev_err(&client->dev, "No device tree node available.\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * If we have some interrupts declared, use them, if not, fall back
>> +	 * on polling.
>> +	 */
>> +	if (of_find_property(np, "interrupts", NULL)) {
>> +		if (client->irq <= 0) {
>> +			client->irq = irq_of_parse_and_map(np, 0);
>> +			if (client->irq <= 0)
>> +				return -EPROBE_DEFER;
>> +		}
>> +	} else
>> +		client->irq = 0;
>> +
>> +	idev = iio_device_alloc(sizeof(struct nau7802_state));
> sizeof(*st) is a little cleaner.
> Also we have pretty much standardized on calling the iio_dev
> indio_dev (no idea why but it's how it turned out ;)  Whilst
> it doesn't really matter it does make reviewers jobs marginally
> easier ;)

OK
>> +	if (idev == NULL)
>> +		return -ENOMEM;
>> +
>> +	st = iio_priv(idev);
>> +
>> +	i2c_set_clientdata(client, idev);
>> +
>> +	idev->dev.parent = &client->dev;
>> +	idev->name = dev_name(&client->dev);
>> +	idev->modes = INDIO_DIRECT_MODE;
>> +	idev->info = &nau7802_info;
>> +
>> +	st->client = client;
>> +
>> +	/* Reset the device */
>> +	nau7802_i2c_write(st, NAU7802_REG_PUCTRL, NAU7802_PUCTRL_RR_BIT);
>> +
>> +	/* Enter normal operation mode */
>> +	nau7802_i2c_write(st, NAU7802_REG_PUCTRL, NAU7802_PUCTRL_PUD_BIT);
>> +
>> +	/*
>> +	 * After about 200 usecs, the device should be ready and then
>> +	 * the Power Up bit will be set to 1. If not, wait for it.
>> +	 */
>> +	do {
>> +		udelay(200);
>> +		ret = nau7802_i2c_read(st, NAU7802_REG_PUCTRL, &data);
>> +		if (ret)
>> +			return -ENODEV;
> You want some sort of timeout and fail here.  Perasonally if the device
> should be ready in 200 usec, I'd only let it have one go at doing so
> before failing (or give 250 usec if it's not all that precise).
Right.
>> +	} while (!(data & NAU7802_PUCTRL_PUR_BIT));
>> +
>> +	of_property_read_u32(np, "nuvoton,vldo", &tmp);
>> +	st->vref_mv = tmp;
>> +
>> +	data = NAU7802_PUCTRL_PUD_BIT | NAU7802_PUCTRL_PUA_BIT |
>> +		NAU7802_PUCTRL_CS_BIT;
>> +	if (tmp >= 2400)
>> +		data |= NAU7802_PUCTRL_AVDDS_BIT;
>> +
>> +	nau7802_i2c_write(st, NAU7802_REG_PUCTRL, data);
>> +	nau7802_i2c_write(st, NAU7802_REG_ADC_CTRL, 0x30);
>> +
>> +	if (tmp >= 2400) {
>> +		data = NAU7802_CTRL1_VLDO((4500 - tmp) / 300);
>> +		nau7802_i2c_write(st, NAU7802_REG_CTRL1, data);
>> +	}
>> +
>> +	st->min_conversions = 6;
>> +
>> +	/*
>> +	 * The ADC fires continuously and we can't do anything about
>> +	 * it. So we need to have the IRQ disabled by default, and we
>> +	 * will enable them back when we will need them..
>> +	 */
>> +	if (client->irq) {
>> +		irq_set_status_flags(client->irq, IRQ_NOAUTOEN);
>> +		ret = request_threaded_irq(client->irq,
>> +				NULL,
>> +				nau7802_eoc_trigger,
>> +				IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
>> +				client->dev.driver->name,
>> +				idev);
>> +		if (ret) {
>> +			/*
>> +			 * What may happen here is that our IRQ controller is
>> +			 * not able to get level interrupt but this is required
>> +			 * by this ADC as when going over 40 sample per second,
>> +			 * the interrupt line may stay high between conversions.
>> +			 * So, we continue no matter what but we switch to
>> +			 * polling mode.
>> +			 */
> Good plan.  Pesky hardware designers and not guaranteeing transitions. ;)

Yeah, I'll still have to check whether it is an issue with the pca or
the nau. I actually suspect both ;)
But anyway, as we are able to poll, I think it is still a good idea to
choose polling when your interrupt controller is not able to handle your
interrupt type.

>> +			dev_info(&client->dev,
>> +				"Failed to allocate IRQ, using polling mode\n");
>> +			client->irq = 0;
>> +			/*
>> +			 * We are polling, use the fastest sample rate by
>> +			 * default
>> +			 */
>> +			st->sample_rate = 0x7;
>> +			nau7802_i2c_write(st, NAU7802_REG_CTRL2,
>> +					NAU7802_CTRL2_CRS(st->sample_rate));
>> +		}
>> +	}
>> +
>> +	/* Setup the ADC channels available on the board */
>> +	ret = nau7802_channel_init(idev);
>> +	if (ret < 0) {
>> +		dev_err(&client->dev, "Couldn't initialize the channels.\n");
>> +		goto error_channel_init;
>> +	}
>> +
>> +	init_completion(&st->value_ok);
>> +	mutex_init(&st->lock);
>> +	mutex_init(&st->data_lock);
>> +
>> +	ret = iio_device_register(idev);
>> +	if (ret < 0) {
>> +		dev_err(&client->dev, "Couldn't register the device.\n");
>> +		goto error_device_register;
>> +	}
>> +
>> +	return 0;
>> +
>> +error_device_register:
>> +	mutex_destroy(&st->lock);
> datalock?
oops

Thanks again for your review, I'll prepare a v2 while waiting for your
answers.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

