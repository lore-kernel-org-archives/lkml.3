Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966549AbaLMLYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 06:24:10 -0500
Received: from mout.gmx.net ([212.227.15.19]:61510 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966475AbaLMLYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 06:24:07 -0500
Message-ID: <548C21D0.7090802@gmx.de>
Date: Sat, 13 Dec 2014 12:24:00 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
CC: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Michael Welling <mwelling@ieee.org>,
        Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH v2 2/2] iio: add driver for the TI DAC8554
References: <1416858614-32265-1-git-send-email-nikolaus.schulz@avionic-design.de> <1416858614-32265-2-git-send-email-nikolaus.schulz@avionic-design.de> <5482EA33.7020305@gmx.de> <20141212155804.GA1142@avionic-0071.adnet.avionic-design.de> <548C209A.7000904@gmx.de>
In-Reply-To: <548C209A.7000904@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:BTamAZnctFVquxA1M+KNaRf/fK9liAC4EO33MqW9DcC/Em8q/0j
 sU9kvK6rbwiP3ZZ0zpN/BWLM0OOix9MaU8YHlCvSkltVGTYP93+yDOWPSYhYAJW5dSGTgbK
 jGe2+s8SM2V4LWccXjnGl9ghZs+XZeEdnb1LHXafAyx9GaHdJAuSUSUJw9sVLVLRGe+JfvG
 G2zHWRzEddVJnD5t0ErMA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hartmut Knaack schrieb am 13.12.2014 um 12:18:
> Nikolaus Schulz schrieb am 12.12.2014 um 16:58:
>> On Sat, Dec 06, 2014 at 12:36:19PM +0100, Hartmut Knaack wrote:
>>> Nikolaus Schulz schrieb am 24.11.2014 um 20:50:
>>>> The TI DAC8554 is a quad-channel Digital-to-Analog Converter with an SPI
>>>> interface.
>>>>
>>>> Changes in v2:
>>>> * Use DMA-safe buffer for SPI transfer
>>>> * Normalize powerdown_mode name "hi-z" to "three_state" as per
>>>>   ABI/testing/sysfs-bus-iio
>>>> * Register device late in probe function
>>>> * Avoid powerdown broadcast update, which touches all DAC on the bus
>>> There are a few issues left, please see my comments inline.
>>>>
>>>> Signed-off-by: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
>>>> ---
>>>>  drivers/iio/dac/Kconfig      |  10 ++
>>>>  drivers/iio/dac/Makefile     |   1 +
>>>>  drivers/iio/dac/ti-dac8554.c | 374 +++++++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 385 insertions(+)
>>>>  create mode 100644 drivers/iio/dac/ti-dac8554.c
>> [...]
>>>> diff --git a/drivers/iio/dac/ti-dac8554.c b/drivers/iio/dac/ti-dac8554.c
>>>> new file mode 100644
>>>> index 0000000..fca751f
>>>> --- /dev/null
>>>> +++ b/drivers/iio/dac/ti-dac8554.c
>>>> @@ -0,0 +1,374 @@
>>>> +/*
>>>> + * TI DAC8554 Digital to Analog Converter SPI driver
>>>> + *
>>>> + * Copyright (C) 2014 Avionic Design GmbH
>>>> + *
>>>> + * Based on ad5446r_spi.c
>>>> + * Copyright (C) 2010,2011 Analog Devices Inc.
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + */
>>>> +
>>>> +#include <linux/spi/spi.h>
>>>> +#include <linux/regulator/consumer.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/iio/iio.h>
>>>> +#include <linux/of.h>
>>>> +
>>>> +#define DAC8554_DRIVERNAME			"ti-dac8554"
>>>> +#define DAC8554_DAC_CHANNELS			4
>>>> +
>>>> +/* Load commands */
>>>> +#define DAC8554_CMD_STORE_DAC_N			0x0
>>>> +#define DAC8554_CMD_UPDATE_DAC_N		0x1
>>>> +#define DAC8554_CMD_STORE_DAC_N_UPDATE_ALL	0x2
>>>> +#define DAC8554_CMD_UPDATE_BROADCAST		0x3
>>>> +
>>>> +#define DAC8554_BROADCAST_USE_SRDATA		0x2
>>> Add a blank line here.
>>
>> Fixed.
>>
>>>> +/* Powerdown modes (ORed PD1|PD2 bits) */
>>> It took my some time to figure out ORed. I think you could drop it and just
>>> mention (PD1 | PD2 bits).
>>
>> Agreed, and fixed.
>>
>>>> +#define DAC8554_PWRDN_HIZ			0x0
>>>> +#define DAC8554_PWRDN_1K			0x1
>>>> +#define DAC8554_PWRDN_100K			0x2
>>>> +
>>>> +#define DAC8554_PWRDN_TO_SR(mode)		(BIT(16) | (mode) << 14)
>>>> +
>>>> +/**
>>>> + * struct dac8554_state - driver instance specific data
>>>> + * @spi:		spi_device
>>> SPI device?
>>
>> Yes, fixed.
>>
>>>> + * @reg:		supply regulator
>>>> + * @addr:		two-bit chip address
>>>> + * @vref_mv:		reference voltage in millivolt
>>>> + * @val			DAC/channel data
>>> DAC channel data?
>>
>> "channel data" will do, actually.
>>
>>>> + * @powerdown		channel powerdown flag
>>>> + * @powerdown_mode	channel powerdown mode
>>>> + * @xfer		SPI transfer buffer
>>> Half of the comments are with colon, the other half are missing it.
>>
>> Fixed.
>>
>>>> + */
>>>> +struct dac8554_state {
>>>> +	struct spi_device		*spi;
>>>> +	struct regulator		*reg;
>>>> +	unsigned			addr;
>>>> +	unsigned			vref_mv;
>>>> +	u16				val[DAC8554_DAC_CHANNELS];
>>>> +	bool				powerdown[DAC8554_DAC_CHANNELS];
>>>> +	u8				powerdown_mode[DAC8554_DAC_CHANNELS];
>>>> +
>>>> +	/*
>>>> +	 * DMA (thus cache coherency maintenance) requires the
>>>> +	 * transfer buffers to live in their own cache lines.
>>>> +	 */
>>>> +	u8				xfer[3] ____cacheline_aligned;
>>>> +};
>>>> +
>>>> +static int dac8554_spi_write(struct dac8554_state *st,
>>>> +			     unsigned cmd,
>>>> +			     unsigned chan_addr,
>>>> +			     unsigned val)
>>>> +{
>>>> +	u32 data;
>>>> +
>>>> +	/*
>>>> +	 * The input shift register is 24 bits wide. The 8 MSB are
>>>> +	 * control bits, followed by 16 data bits.
>>>> +	 * The first two bits A1 and A0 address a DAC8554 chip.
>>>> +	 * The next two are the command bits, LD1 and LD0.
>>>> +	 * After a don't-care-bit, the next two bits select the channel.
>>>> +	 * The final control bit PD0 is a flag signalling if the data
>>>> +	 * bits encode a powerdown mode. We merge PD0 with the adjacent
>>>> +	 * data bits.
>>>> +	 */
>>>> +
>>>> +	if (cmd > 3 || chan_addr > 3 ||
>>>> +			(val > 0xffff && (val & ~DAC8554_PWRDN_TO_SR(3))))
>>>> +		return -EINVAL;
>>>> +
>>>> +	data =st->addr << 22) | (cmd << 20) | (chan_addr << 17) | val;
>>> Could be more readable by using definition for the magic shifts, or macros.
>>
>> Hmm. The magic is all concentrated at this place, and the variable names
>> tell the story, so I figured that's ok.  But, why not: fixed.
>>
>>>> +	st->xfer[0] =ata >> 16;
>>>> +	st->xfer[1] =ata >> 8;
>>>> +	st->xfer[2] =ata;
>>>> +
>>>> +	return spi_write(st->spi, st->xfer, sizeof(st->xfer));
>>>> +}
>>>> +
>>>> +static int dac8554_read_raw(struct iio_dev *indio_dev,
>>>> +			    struct iio_chan_spec const *chan,
>>>> +			    int *val,
>>>> +			    int *val2,
>>>> +			    long m)
>>> Commonly, m is called mask (like you do in _write_raw).
>>
>> Ah yes. Fixed.
>>
>>>> +{
>>>> +	struct dac8554_state *st =io_priv(indio_dev);
>>>> +
>>>> +	switch (m) {
>>>> +	case IIO_CHAN_INFO_RAW:
>>>> +		*val =t->val[chan->address];
>>>> +		return IIO_VAL_INT;
>>>> +	case IIO_CHAN_INFO_SCALE:
>>>> +		*val =t->vref_mv;
>>>> +		*val2 =6;
>>>> +		return IIO_VAL_FRACTIONAL_LOG2;
>>>> +	}
>>>> +	return -EINVAL;
>>>> +}
>>>> +
>>>> +static int dac8554_write_raw(struct iio_dev *indio_dev,
>>>> +			     struct iio_chan_spec const *chan,
>>>> +			     int val,
>>>> +			     int val2,
>>>> +			     long mask)
>>>> +{
>>>> +	struct dac8554_state *st =io_priv(indio_dev);
>>>> +	int err;
>>>> +
>>>> +	switch (mask) {
>>>> +	case IIO_CHAN_INFO_RAW:
>>>> +		if (val > 0xffff || val < 0)
>>>> +			return -EINVAL;
>>>> +
>>>> +		err =ac8554_spi_write(st, DAC8554_CMD_UPDATE_DAC_N,
>>>> +					chan->address, val);
>>>> +		if (err)
>>>> +			return err;
>>>> +
>>>> +		st->val[chan->address] =al;
>>>> +
>>>> +		/* By hw design, DAC updates automatically trigger powerup. */
>>>> +		st->powerdown[chan->address] =alse;
>>>> +
>>>> +		return 0;
>>>> +
>>>> +	default:
>>>> +		return -EINVAL;
>>>> +	}
>>>> +}
>>>> +
>>>> +static int dac8554_get_powerdown_mode(struct iio_dev *indio_dev,
>>>> +				      const struct iio_chan_spec *chan)
>>>> +{
>>>> +	struct dac8554_state *st =io_priv(indio_dev);
>>>> +
>>>> +	return st->powerdown_mode[chan->address];
>>>> +}
>>>> +
>>>> +static int dac8554_set_powerdown_mode(struct iio_dev *indio_dev,
>>>> +				      const struct iio_chan_spec *chan,
>>>> +				      unsigned int mode)
>>>> +{
>>>> +	struct dac8554_state *st =io_priv(indio_dev);
>>>> +
>>>> +	st->powerdown_mode[chan->address] =ode;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static ssize_t dac8554_read_dac_powerdown(struct iio_dev *indio_dev,
>>>> +					  uintptr_t private,
>>>> +					  const struct iio_chan_spec *chan,
>>>> +					  char *buf)
>>>> +{
>>>> +	struct dac8554_state *st =io_priv(indio_dev);
>>>> +
>>>> +	return sprintf(buf, "%d\n", st->powerdown[chan->address]);
>>>> +}
>>>> +
>>>> +static ssize_t dac8554_write_dac_powerdown(struct iio_dev *indio_dev,
>>>> +					   uintptr_t private,
>>>> +					   const struct iio_chan_spec *chan,
>>>> +					   const char *buf,
>>>> +					   size_t len)
>>>> +{
>>>> +	bool powerdown;
>>>> +	int ret;
>>>> +	struct dac8554_state *st =io_priv(indio_dev);
>>>> +	u8 powerdown_mode;
>>>> +
>>>> +	ret =trtobool(buf, &powerdown);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	st->powerdown[chan->address] =owerdown;
>>>> +
>>>> +	if (powerdown) {
>>>> +		powerdown_mode =t->powerdown_mode[chan->address];
>>>> +		ret =ac8554_spi_write(st,
>>>> +				DAC8554_CMD_UPDATE_DAC_N,
>>>> +				chan->address,
>>>> +				DAC8554_PWRDN_TO_SR(powerdown_mode));
>>> The parameters sill fit on line even with proper indentation.
>>
>> Fixed.
>>
>>>> +	} else {
>>>> +		/* Load DAC with cached value. This triggers a powerup. */
>>>> +		ret =ac8554_spi_write(st,
>>>> +				DAC8554_CMD_UPDATE_DAC_N,
>>>> +				chan->address,
>>>> +				st->val[chan->address]);
>>> Same here with indentation.
>>
>> Fixed.
>>
>>>> +	}
>>>> +
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	return len;
>>> Just: return (ret) ? ret : len;
>>
>> I think avoiding the ternary operator makes the code more readable, and
>> it separates the error path from normal operation. So I would prefer to
>> keep it that way.
> Fair enough.
>>
>>>> +}
>>>> +
>>>> +static int dac8554_powerdown(struct dac8554_state *st,
>>>> +			     u8 powerdown_mode)
>>>> +{
>>>> +	int chan, cmd, ret;
>>>> +
>>>> +	for (chan =AC8554_DAC_CHANNELS-1; chan >= 0; --chan) {
>>> Please mind spaces around operators.
>>
>> Fixed.
>>
>>>> +		cmd =han ? DAC8554_CMD_STORE_DAC_N
>>>> +			   : DAC8554_CMD_STORE_DAC_N_UPDATE_ALL;
>>>> +		ret =ac8554_spi_write(st, cmd, chan,
>>>> +				DAC8554_PWRDN_TO_SR(powerdown_mode));
>>>> +		if (ret)
>>>> +			return ret;
>>>> +	}
>>>> +
>>>> +	memset(st->powerdown_mode, powerdown_mode, sizeof(st->powerdown_mode));
>>>> +	memset(st->powerdown, true, sizeof(st->powerdown));
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static const struct iio_info dac8554_info =
>>>> +	.write_raw = ac8554_write_raw,
>>>> +	.read_raw =ac8554_read_raw,
>>>> +	.driver_module =HIS_MODULE,
>>>> +};
>>>> +
>>>> +static const char * const dac8554_powerdown_modes[] =
>>>> +	"three_state",
>>>> +	"1kohm_to_gnd",
>>>> +	"100kohm_to_gnd"
>>>> +};
>>>> +
>>>> +static const struct iio_enum dac8854_powerdown_mode_enum =
>>>> +	.items = ac8554_powerdown_modes,
>>>> +	.num_items =RRAY_SIZE(dac8554_powerdown_modes),
>>>> +	.get =ac8554_get_powerdown_mode,
>>>> +	.set =ac8554_set_powerdown_mode,
>>>> +};
>>>> +
>>>> +static const struct iio_chan_spec_ext_info dac8554_ext_info[] =
>>>> +	{
>>>> +		.name =powerdown",
>>>> +		.read =ac8554_read_dac_powerdown,
>>>> +		.write =ac8554_write_dac_powerdown,
>>>> +		.shared =IO_SEPARATE,
>>>> +	},
>>>> +	IIO_ENUM("powerdown_mode", IIO_SEPARATE,
>>>> +		 &dac8854_powerdown_mode_enum),
>>>> +	IIO_ENUM_AVAILABLE("powerdown_mode", &dac8854_powerdown_mode_enum),
>>>> +	{ },
>>>> +};
>>>> +
>>>> +#define DAC8554_CHANNEL(chan) { \
>>>> +	.type =IO_VOLTAGE, \
>>>> +	.indexed =, \
>>>> +	.output =, \
>>>> +	.channel =chan), \
>>>> +	.info_mask_separate =IT(IIO_CHAN_INFO_RAW), \
>>>> +	.info_mask_shared_by_type =IT(IIO_CHAN_INFO_SCALE), \
>>>> +	.address =chan), \
>>>> +	.ext_info =ac8554_ext_info, \
>>>> +}
>>>> +const struct iio_chan_spec dac8554_channels[] =
>>>> +	DAC8554_CHANNEL(0),
>>>> +	DAC8554_CHANNEL(1),
>>>> +	DAC8554_CHANNEL(2),
>>>> +	DAC8554_CHANNEL(3),
>>>> +};
>>>> +#undef DAC8554_CHANNEL
>>>> +
>>>> +static int dac8554_probe(struct spi_device *spi)
>>>> +{
>>>> +	struct dac8554_state *st;
>>>> +	struct iio_dev *indio_dev;
>>>> +	int ret, voltage_uv;
>>>> +	u32 addr;
>>>> +
>>>> +	indio_dev =evm_iio_device_alloc(&spi->dev, sizeof(*st));
>>>> +	if (!indio_dev)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	indio_dev->dev.parent =spi->dev;
>>>> +	indio_dev->name =AC8554_DRIVERNAME;
>>>> +	indio_dev->info =dac8554_info;
>>>> +	indio_dev->modes =NDIO_DIRECT_MODE;
>>>> +	indio_dev->channels =ac8554_channels;
>>>> +	indio_dev->num_channels =RRAY_SIZE(dac8554_channels);
>>>> +
>>>> +	spi_set_drvdata(spi, indio_dev);
>>>> +
>>>> +	st =io_priv(indio_dev);
>>>> +
>>>> +	if (!spi->dev.of_node) {
>>>> +		dev_err(&spi->dev, "missing OF node");
>>>> +		return -ENODEV;
>>>> +	}
>>>> +	ret =f_property_read_u32(spi->dev.of_node, "address", &addr);
>>>> +	if (ret || addr < 0 || addr > 2) {
>>>> +		dev_err(&spi->dev, "no or invalid chip address");
>>>> +		return -ENODEV;
>>>> +	}
>>>> +
>>>> +	st->spi =pi;
>>>> +	st->addr =ddr;
>>>> +
>>> According to your DT bindings, the regulator from property "vref-supply" should
>>> be used. This is missing here.
>>
>> Uhm, it's right below, no?
> Looking into your DT bindings patch (which unfortunately didn't make it into our
> list), you specify "vref-supply" as a required property. So, I expected that you
> intended to make use of this property somewhere around here.
>>
>>>> +	st->reg =evm_regulator_get(&spi->dev, "vref");
>>>> +	if (IS_ERR(st->reg))
>>>> +		return PTR_ERR(st->reg);
>>>> +
>>>> +	ret =egulator_enable(st->reg);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	voltage_uv =egulator_get_voltage(st->reg);
>>>> +	if (voltage_uv < 0)
>>>> +		goto error_disable_reg;
>>> Missing ret =oltage_uv before goto. Or just drop voltage_uv completely and use ret instead.
>>
>> Fixed.
>>
>>>> +	st->vref_mv =oltage_uv / 1000;
>>> How hard do you want to depend on a voltage regulator? Doing regulator_get_voltage()
>>> could even be called dynamically in _read_raw(), making a real regulator optional.
>>
>> Hmm. I understand that the DAC voltage input may not be provided by a
>> regulator, but is that a common scenario?  No other DAC driver I looked
>> at handles that case, they all consider it an error if the regulator is
>> absent.
>>
> I had people in mind, who might want to use such DAC with one of the popular
> embedded boards like Raspberry Pi - people who would just like to "plug and
> play" without the need or ability to build a kernel (or would prefer to go
> with the convenience of a distribution kernel). But since you've put a
> dependency on OF, I don't see a way to use this device with a stock distribution
> kernel anyway.
> But I still think that calculating the actual voltage during _read_raw() would
> be a good idea, as there is support for regulators providing different voltages,
> which can be changed during runtime.
One more thing: you should consider to add a dependency on regulators in Kconfig.

>>>> +
>>>> +	ret =ac8554_powerdown(st, DAC8554_PWRDN_100K);
>>>> +	if (ret)
>>>> +		goto error_disable_reg;
>>>> +
>>>> +	ret =io_device_register(indio_dev);
>>>> +	if (ret)
>>>> +		goto error_disable_reg;
>>>> +
>>>> +	return 0;
>>>> +
>>>> +error_disable_reg:
>>>> +	regulator_disable(st->reg);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int dac8554_remove(struct spi_device *spi)
>>>> +{
>>>> +	struct iio_dev *indio_dev =pi_get_drvdata(spi);
>>>> +	struct dac8554_state *st =io_priv(indio_dev);
>>>> +
>>>> +	iio_device_unregister(indio_dev);
>>>> +	regulator_disable(st->reg);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static const struct of_device_id dac8554_of_match[] =
>>>> +	{ .compatible = ti,dac8554" },
>>>> +	{ }
>>>> +};
>>>> +MODULE_DEVICE_TABLE(of, dac8554_of_match);
>>>> +
>>>> +static struct spi_driver dac8554_driver =
>>>> +	.driver = 
>>>> +		.name = AC8554_DRIVERNAME,
>>>> +		.owner =HIS_MODULE,
>>>> +		.of_match_table =ac8554_of_match,
>>>> +	 },
>>>> +	.probe =ac8554_probe,
>>>> +	.remove =ac8554_remove,
>>>> +};
>>>> +module_spi_driver(dac8554_driver);
>>>> +
>>>> +MODULE_AUTHOR("Nikolaus Schulz <nikolaus.schulz@avionic-design.de>");
>>>> +MODULE_DESCRIPTION("Texas Instruments DAC8554 SPI driver");
>>>> +MODULE_LICENSE("GPL v2");
>>
>> Thanks for the review!
>>
>> Nikolaus
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

