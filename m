Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbbATUtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:49:41 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37012 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbbATUtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:49:39 -0500
Message-ID: <54BEBF58.30308@kernel.org>
Date: Tue, 20 Jan 2015 20:49:28 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: Re: [PATCH v5 3/7] iio: Add support for DA9150 GPADC
References: <cover.1419264383.git.Adam.Thomson.Opensource@diasemi.com> <58b7b001b38662c36595412f96c7d2eb5c3adcad.1419264383.git.Adam.Thomson.Opensource@diasemi.com> <54A976D2.9040104@kernel.org> <2E89032DDAA8B9408CB92943514A0337AB526A19@SW-EX-MBX01.diasemi.com> <54B1A563.5080404@kernel.org> <2E89032DDAA8B9408CB92943514A0337AB527B9D@SW-EX-MBX01.diasemi.com>
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337AB527B9D@SW-EX-MBX01.diasemi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/15 11:30, Opensource [Adam Thomson] wrote:
> On January 10, 2015 22:19, Jonathan Cameron wrote:
> 
>> On 07/01/15 16:03, Opensource [Adam Thomson] wrote:
>>> On January 4, 2015 17:22, Jonathan Cameron wrote:
>>>
>>>> On 22/12/14 16:51, Adam Thomson wrote:
>>>>> This patch adds support for DA9150 Charger & Fuel-Gauge IC GPADC.
>>>>>
>>>>> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
>>>> One last query from me.
>>>>
>>>> Using the extended channel names in IIO is only really appropriate when
>>>> they don't correspond to simple pins on the side of the chip. For those
>>>> just drop the extname bit.  Some of the channels you have here, definitely
>>>> need them though.
>>>>
>>>> Drop those first 4 or convince me otherwise and add
>>>> Acked-by: Jonathan Cameron <jic23@kernel.org>
>>>
>>> Have added responses below. If the comments are accepted then I'll respin
>>> and add you're 'Acked-by'. Is that ok?
>>>
>> Not accepted as yet :)
> 
> Yeah, that's why I added the 'if'. :)
> 
>>>>> +#define DA9150_GPADC_CHANNEL_PROCESSED(_id, _hw_id, _type,
>> _ext_name)
>>>> 	\
>>>>> +	DA9150_GPADC_CHANNEL(_id, _hw_id, _type,			\
>>>>> +			     BIT(IIO_CHAN_INFO_PROCESSED), _ext_name)
>>>>> +
>>>>> +/* Supported channels */
>>>>> +static const struct iio_chan_spec da9150_gpadc_channels[] = {
>>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOA, GPIOA_6V, IIO_VOLTAGE,
>>>> "GPIOA"),
>>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOB, GPIOB_6V, IIO_VOLTAGE,
>>>> "GPIOB"),
>>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOC, GPIOC_6V, IIO_VOLTAGE,
>>>> "GPIOC"),
>>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOD, GPIOD_6V, IIO_VOLTAGE,
>>>> "GPIOD"),
>>>> I'm not sure some of these really deserve extended names.  Those are usually
>>>> reserved for naming strange internal adc channels etc.  These first 4 are
>>>> presumably just for input pins?  Those should just be channels 0..3
>>>> On another note, unless you want really weird sysfs attribute names, the
>>>> extended names want to be lowercase.
>>>>
>>>
>>> I'd prefer to keep the names because the input pins are muxed with GPIOs of the
>>> chip, so thought it sensible to show that this is the case. Am happy to change
>>> to lower-case to follow convention.
>> Hmm.  It's a bit of an oddity as the point of the naming
>> is about the uses, not which pins they are on.  If we exposed the
>> 'datasheet_name' parameter directly rather than just using it internally
>> I'd suggest relying on that - but clearly you want it to be apparent
>> in the interface.  Whether that is useful is the question I'd raise
>> here (and is the reason datasheet_name is not exposed.
>>
>> The obvious question is does userspace care?  Answer is probably not.
>>
>> It cares what is being measured but this is about what pins it is
>> on and doesn't provide any information on what is connected to them.
>>
> 
> Surely it helps when using sysfs to access whatever is connected to one of
> those pins if we label the pin with something meaningful? If say you have a
> device connected to GPIC of the charger IC, it's easier to work out which ADC
> channel you need to access through sysfs if the naming is as I have now, rather
> than some arbitrary number which doesn't necessarily tally to the channel in the
> datasheet. You'd then need to look at the code and work out which channel number
> GPIOC actually was. Or am I just missing something here? :)
Not really for the vast majority of users.  They tend not to have a detailed
board layout in front of them.  It's more interesting if you know 'what' they
are measuring (hence we do use these names when that is true - such as
internal voltage measurements).

The numbers almost never tally with the datasheet, but then datasheet numbering
has a habit of being inconsistent as well!
> 
>>
>>>
>>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(IBUS, IBUS_SENSE, IIO_CURRENT,
>>>> "IBUS"),
>>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(VBUS, VBUS_DIV_, IIO_VOLTAGE,
>>>> "VBUS"),
>>>>> +	DA9150_GPADC_CHANNEL_RAW(ID, ID, IIO_VOLTAGE, "ID"),
>>>> You hae an identifier voltage? That's certainly unusual but if so - fair enough
>>>> and it defintely needs the extname!
>>>
>>> Thanks for pointing that out. Having checked again, this is not needed and can
>>> be dispensed with.
>>>
>>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(VSYS, VSYS, IIO_VOLTAGE, "VSYS"),
>>>>> +	DA9150_GPADC_CHANNEL_SCALED(VBAT, VBAT, IIO_VOLTAGE, "VBAT"),
>>>>> +	DA9150_GPADC_CHANNEL_RAW(TBAT, TBAT, IIO_VOLTAGE, "TBAT"),
>>>>> +	DA9150_GPADC_CHANNEL_SCALED(TJUNC_CORE, TJUNC_CORE,
>>>> IIO_TEMP,
>>>>> +				    "TJUNC_CORE"),
>>>> tjunc_core is a good use of extname ;)
>>>>> +	DA9150_GPADC_CHANNEL_SCALED(TJUNC_OVP, TJUNC_OVP, IIO_TEMP,
>>>>> +				    "TJUNC_OVP"),
>>>>> +};
>>>>> +
>>>>> +/* Default maps used by da9150-charger */
>>>>> +static struct iio_map da9150_gpadc_default_maps[] = {
>>>>> +	{
>>>>> +		.consumer_dev_name = "da9150-charger",
>>>>> +		.consumer_channel = "CHAN_IBUS",
>>>>> +		.adc_channel_label = "IBUS",
>>>>> +	},
>>>>> +	{
>>>>> +		.consumer_dev_name = "da9150-charger",
>>>>> +		.consumer_channel = "CHAN_VBUS",
>>>>> +		.adc_channel_label = "VBUS",
>>>>> +	},
>>>>> +	{
>>>>> +		.consumer_dev_name = "da9150-charger",
>>>>> +		.consumer_channel = "CHAN_TJUNC",
>>>>> +		.adc_channel_label = "TJUNC_CORE",
>>>>> +	},
>>>>> +	{
>>>>> +		.consumer_dev_name = "da9150-charger",
>>>>> +		.consumer_channel = "CHAN_VBAT",
>>>>> +		.adc_channel_label = "VBAT",
>>>>> +	},
>>>>> +	{},
>>>>> +};
>>>>> +
>>>>> +static int da9150_gpadc_probe(struct platform_device *pdev)
>>>>> +{
>>>>> +	struct device *dev = &pdev->dev;
>>>>> +	struct da9150 *da9150 = dev_get_drvdata(dev->parent);
>>>>> +	struct da9150_gpadc *gpadc;
>>>>> +	struct iio_dev *indio_dev;
>>>>> +	int irq, ret;
>>>>> +
>>>>> +	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*gpadc));
>>>>> +	if (!indio_dev) {
>>>>> +		dev_err(&pdev->dev, "Failed to allocate IIO device\n");
>>>>> +		return -ENOMEM;
>>>>> +	}
>>>>> +	gpadc = iio_priv(indio_dev);
>>>>> +
>>>>> +	platform_set_drvdata(pdev, indio_dev);
>>>>> +	gpadc->da9150 = da9150;
>>>>> +	gpadc->dev = dev;
>>>>> +	mutex_init(&gpadc->lock);
>>>>> +	init_completion(&gpadc->complete);
>>>>> +
>>>>> +	irq = platform_get_irq_byname(pdev, "GPADC");
>>>>> +	if (irq < 0) {
>>>>> +		dev_err(dev, "Failed to get IRQ: %d\n", irq);
>>>>> +		return irq;
>>>>> +	}
>>>>> +
>>>>> +	ret = devm_request_threaded_irq(dev, irq, NULL, da9150_gpadc_irq,
>>>>> +					IRQF_ONESHOT, "GPADC", gpadc);
>>>>> +	if (ret) {
>>>>> +		dev_err(dev, "Failed to request IRQ %d: %d\n", irq, ret);
>>>>> +		return ret;
>>>>> +	}
>>>>> +
>>>>> +	ret = iio_map_array_register(indio_dev, da9150_gpadc_default_maps);
>>>>> +	if (ret) {
>>>>> +		dev_err(dev, "Failed to register IIO maps: %d\n", ret);
>>>>> +		return ret;
>>>>> +	}
>>>>> +
>>>>> +	indio_dev->name = dev_name(dev);
>>>>> +	indio_dev->dev.parent = dev;
>>>>> +	indio_dev->dev.of_node = pdev->dev.of_node;
>>>>> +	indio_dev->info = &da9150_gpadc_info;
>>>>> +	indio_dev->modes = INDIO_DIRECT_MODE;
>>>>> +	indio_dev->channels = da9150_gpadc_channels;
>>>>> +	indio_dev->num_channels = ARRAY_SIZE(da9150_gpadc_channels);
>>>>> +
>>>>> +	ret = iio_device_register(indio_dev);
>>>>> +	if (ret) {
>>>>> +		dev_err(dev, "Failed to register IIO device: %d\n", ret);
>>>>> +		goto iio_map_unreg;
>>>>> +	}
>>>>> +
>>>>> +	return 0;
>>>>> +
>>>>> +iio_map_unreg:
>>>>> +	iio_map_array_unregister(indio_dev);
>>>>> +
>>>>> +	return ret;
>>>>> +}
>>>>> +
>>>>> +static int da9150_gpadc_remove(struct platform_device *pdev)
>>>>> +{
>>>>> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
>>>>> +
>>>>> +	iio_device_unregister(indio_dev);
>>>>> +	iio_map_array_unregister(indio_dev);
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static struct platform_driver da9150_gpadc_driver = {
>>>>> +	.driver = {
>>>>> +		.name = "da9150-gpadc",
>>>>> +	},
>>>>> +	.probe = da9150_gpadc_probe,
>>>>> +	.remove = da9150_gpadc_remove,
>>>>> +};
>>>>> +
>>>>> +module_platform_driver(da9150_gpadc_driver);
>>>>> +
>>>>> +MODULE_DESCRIPTION("GPADC Driver for DA9150");
>>>>> +MODULE_AUTHOR("Adam Thomson
>>>> <Adam.Thomson.Opensource@diasemi.com>");
>>>>> +MODULE_LICENSE("GPL");
>>>>> --
>>>>> 1.9.3
>>>>>

