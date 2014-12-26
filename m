Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaLZQLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 11:11:12 -0500
Received: from mout.gmx.net ([212.227.17.21]:49735 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaLZQK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 11:10:59 -0500
Message-ID: <549D8886.7020109@gmx.de>
Date: Fri, 26 Dec 2014 17:10:46 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>,
        Nikolaus Schulz <nikolaus.schulz@avionic-design.de>,
        linux-iio@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Michael Welling <mwelling@ieee.org>,
        Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
CC: Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH v3 2/2] iio: add driver for the TI DAC8554
References: <1418643605-15554-1-git-send-email-nikolaus.schulz@avionic-design.de> <1418643605-15554-2-git-send-email-nikolaus.schulz@avionic-design.de> <549D4BD1.8050807@kernel.org>
In-Reply-To: <549D4BD1.8050807@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:OTRQhRNnp7adxvRzgAxNVSbmfMHGq5LOnPvErJvs4RwQeCcSacl
 rgXUHuwO7fn+pkxtq7Z91h9KCZoB09Aj43vk6k381kDnNcdNYQCAItuSnXq13j3GEjCh+Nf
 zPV4MgRvQaR1YfXkdWVutFhVTUEDwvGw+KOncq92g2trlPuZR0JjVQrpVNFM2kz8XJqL15w
 j/e3O0hPT2Gi8xs48id7w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron schrieb am 26.12.2014 um 12:51:
> On 15/12/14 11:39, Nikolaus Schulz wrote:
>> The TI DAC8554 is a quad-channel Digital-to-Analog Converter with an SPI
>> interface.
>>
>> Changes in v3:
>> * Small fixes in the documentation of struct dac8554_state
>> * Replace some magic constants with macros
>> * Replace memset on powerdown state arrays with explicit loop
>> * If probing fails due to invalid DT data, return -EINVAL instead of
>>   -ENODEV
>> * Add driver dependency on regulator support
>> * Move regulator_get_voltage call from probe time to dac8554_read_raw
>> * Rename _(read|write)_raw argument "mask" to "info"
>> * Make iio_chan_spec variable static
>> * DT: add vendor prefix to device specific "address" property
>> * Whitespace fixes
>>
>> Changes in v2:
>> * Use DMA-safe buffer for SPI transfer
>> * Normalize powerdown_mode name "hi-z" to "three_state" as per
>>   ABI/testing/sysfs-bus-iio
>> * Register device late in probe function
>> * Avoid powerdown broadcast update, which touches all DAC on the bus
>>
>> Signed-off-by: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
> A slightly inconsistency inline (you only allow for chip addresses up
> to 2 rather than 3)
> 
> Otherwise, looks good - though we'll want Mark to say if he is fine with
> the addressing bit of the device tree file and you to drop the line at
> the top as asked for.
> 
> Thanks,
> 
> Jonathan
>> ---
>>  drivers/iio/dac/Kconfig      |  11 ++
>>  drivers/iio/dac/Makefile     |   1 +
>>  drivers/iio/dac/ti-dac8554.c | 381 +++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 393 insertions(+)
>>  create mode 100644 drivers/iio/dac/ti-dac8554.c
>>
>> diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
>> index 2236ea2..d3b21c853b5 100644
>> --- a/drivers/iio/dac/Kconfig
>> +++ b/drivers/iio/dac/Kconfig
>> @@ -181,4 +181,15 @@ config MCP4922
>>  	  To compile this driver as a module, choose M here: the module
>>  	  will be called mcp4922.
>>  
>> +config TI_DAC8554
>> +	tristate "TI DAC8554 driver"
>> +	depends on SPI
>> +	depends on OF
>> +	depends on REGULATOR
>> +	help
>> +	  Say yes here to build the driver for the TI DAC8554.
>> +
>> +	  To compile this driver as a module, choose M here: the module
>> +	  will be called ti-dac8554.
>> +
>>  endmenu
>> diff --git a/drivers/iio/dac/Makefile b/drivers/iio/dac/Makefile
>> index 52be7e1..b98d79a 100644
>> --- a/drivers/iio/dac/Makefile
>> +++ b/drivers/iio/dac/Makefile
>> @@ -20,3 +20,4 @@ obj-$(CONFIG_MAX517) += max517.o
>>  obj-$(CONFIG_MAX5821) += max5821.o
>>  obj-$(CONFIG_MCP4725) += mcp4725.o
>>  obj-$(CONFIG_MCP4922) += mcp4922.o
>> +obj-$(CONFIG_TI_DAC8554) += ti-dac8554.o
>> diff --git a/drivers/iio/dac/ti-dac8554.c b/drivers/iio/dac/ti-dac8554.c
>> new file mode 100644
>> index 0000000..84b9f42
>> --- /dev/null
>> +++ b/drivers/iio/dac/ti-dac8554.c
>> @@ -0,0 +1,381 @@
>> +/*
>> + * TI DAC8554 Digital to Analog Converter SPI driver
>> + *
>> + * Copyright (C) 2014 Avionic Design GmbH
>> + *
>> + * Based on ad5446r_spi.c
>> + * Copyright (C) 2010,2011 Analog Devices Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/spi/spi.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/module.h>
>> +#include <linux/iio/iio.h>
>> +#include <linux/of.h>
>> +
>> +#define DAC8554_DRIVERNAME			"ti-dac8554"
>> +#define DAC8554_DAC_CHANNELS			4
>> +#define DAC8554_DATABITS			16
>> +
>> +/* Load commands */
>> +#define DAC8554_CMD_STORE_DAC_N			0x0
>> +#define DAC8554_CMD_UPDATE_DAC_N		0x1
>> +#define DAC8554_CMD_STORE_DAC_N_UPDATE_ALL	0x2
>> +#define DAC8554_CMD_UPDATE_BROADCAST		0x3
>> +
>> +#define DAC8554_BROADCAST_USE_SRDATA		0x2
>> +
>> +/* Powerdown modes (PD1 | PD2 bits) */
>> +#define DAC8554_PWRDN_HIZ			0x0
>> +#define DAC8554_PWRDN_1K			0x1
>> +#define DAC8554_PWRDN_100K			0x2
>> +
>> +/* Input shift register composition */
>> +#define DAC8554_ADDR_TO_SR(addr)		((addr) << 22)
>> +#define DAC8554_CMD_TO_SR(cmd)			((cmd) << 20)
>> +#define DAC8554_CHAN_TO_SR(chan)		((chan) << 17)
>> +#define DAC8554_PWRDN_TO_SR(mode)		(BIT(16) | (mode) << 14)
>> +
>> +/**
>> + * struct dac8554_state - driver instance specific data
>> + * @spi:		SPI device
>> + * @reg:		supply regulator
>> + * @addr:		two-bit chip address
>> + * @val:		channel data
>> + * @powerdown:		channel powerdown flag
>> + * @powerdown_mode:	channel powerdown mode
>> + * @xfer:		SPI transfer buffer
>> + */
>> +struct dac8554_state {
>> +	struct spi_device		*spi;
>> +	struct regulator		*reg;
>> +	unsigned			addr;
>> +	u16				val[DAC8554_DAC_CHANNELS];
>> +	bool				powerdown[DAC8554_DAC_CHANNELS];
>> +	u8				powerdown_mode[DAC8554_DAC_CHANNELS];
>> +
>> +	/*
>> +	 * DMA (thus cache coherency maintenance) requires the
>> +	 * transfer buffers to live in their own cache lines.
>> +	 */
>> +	u8				xfer[3] ____cacheline_aligned;
>> +};
>> +
>> +static int dac8554_spi_write(struct dac8554_state *st,
>> +			     unsigned cmd,
>> +			     unsigned chan_addr,
>> +			     unsigned val)
>> +{
>> +	u32 data;
>> +
>> +	/*
>> +	 * The input shift register is 24 bits wide. The 8 MSB are
>> +	 * control bits, followed by 16 data bits.
>> +	 * The first two bits A1 and A0 address a DAC8554 chip.
>> +	 * The next two are the command bits, LD1 and LD0.
>> +	 * After a don't-care-bit, the next two bits select the channel.
>> +	 * The final control bit PD0 is a flag signalling if the data
>> +	 * bits encode a powerdown mode. We merge PD0 with the adjacent
>> +	 * data bits.
>> +	 */
>> +
>> +	if (cmd > 3 || chan_addr > 3 ||
>> +			(val > 0xffff && (val & ~DAC8554_PWRDN_TO_SR(3))))
>> +		return -EINVAL;
>> +
>> +	data = DAC8554_ADDR_TO_SR(st->addr) | DAC8554_CMD_TO_SR(cmd) |
>> +	       DAC8554_CHAN_TO_SR(chan_addr) | val;
>> +
>> +	st->xfer[0] = data >> 16;
>> +	st->xfer[1] = data >> 8;
>> +	st->xfer[2] = data;
>> +
>> +	return spi_write(st->spi, st->xfer, sizeof(st->xfer));
>> +}
>> +
>> +static int dac8554_read_raw(struct iio_dev *indio_dev,
>> +			    struct iio_chan_spec const *chan,
>> +			    int *val,
>> +			    int *val2,
>> +			    long info)
>> +{
>> +	struct dac8554_state *st = iio_priv(indio_dev);
>> +	int voltage_uv;
>> +
>> +	switch (info) {
>> +	case IIO_CHAN_INFO_RAW:
>> +		*val = st->val[chan->address];
>> +		return IIO_VAL_INT;
>> +	case IIO_CHAN_INFO_SCALE:
>> +		voltage_uv = regulator_get_voltage(st->reg);
>> +		if (voltage_uv < 0)
>> +			return voltage_uv;
>> +		*val = voltage_uv / 1000;
>> +		*val2 = DAC8554_DATABITS;
>> +		return IIO_VAL_FRACTIONAL_LOG2;
>> +	}
>> +	return -EINVAL;
>> +}
>> +
>> +static int dac8554_write_raw(struct iio_dev *indio_dev,
>> +			     struct iio_chan_spec const *chan,
>> +			     int val,
>> +			     int val2,
>> +			     long info)
>> +{
>> +	struct dac8554_state *st = iio_priv(indio_dev);
>> +	int err;
>> +
>> +	switch (info) {
>> +	case IIO_CHAN_INFO_RAW:
>> +		if (val > 0xffff || val < 0)
>> +			return -EINVAL;
>> +
>> +		err = dac8554_spi_write(st, DAC8554_CMD_UPDATE_DAC_N,
>> +					chan->address, val);
>> +		if (err)
>> +			return err;
>> +
>> +		st->val[chan->address] = val;
>> +
>> +		/* By hw design, DAC updates automatically trigger powerup. */
>> +		st->powerdown[chan->address] = false;
>> +
>> +		return 0;
>> +
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>> +static int dac8554_get_powerdown_mode(struct iio_dev *indio_dev,
>> +				      const struct iio_chan_spec *chan)
>> +{
>> +	struct dac8554_state *st = iio_priv(indio_dev);
>> +
>> +	return st->powerdown_mode[chan->address];
>> +}
>> +
>> +static int dac8554_set_powerdown_mode(struct iio_dev *indio_dev,
>> +				      const struct iio_chan_spec *chan,
>> +				      unsigned int mode)
>> +{
>> +	struct dac8554_state *st = iio_priv(indio_dev);
>> +
>> +	st->powerdown_mode[chan->address] = mode;
>> +
>> +	return 0;
>> +}
>> +
>> +static ssize_t dac8554_read_dac_powerdown(struct iio_dev *indio_dev,
>> +					  uintptr_t private,
>> +					  const struct iio_chan_spec *chan,
>> +					  char *buf)
>> +{
>> +	struct dac8554_state *st = iio_priv(indio_dev);
>> +
>> +	return sprintf(buf, "%d\n", st->powerdown[chan->address]);
>> +}
>> +
>> +static ssize_t dac8554_write_dac_powerdown(struct iio_dev *indio_dev,
>> +					   uintptr_t private,
>> +					   const struct iio_chan_spec *chan,
>> +					   const char *buf,
>> +					   size_t len)
>> +{
>> +	bool powerdown;
>> +	int ret;
>> +	struct dac8554_state *st = iio_priv(indio_dev);
>> +	u8 powerdown_mode;
>> +
>> +	ret = strtobool(buf, &powerdown);
>> +	if (ret)
>> +		return ret;
>> +
>> +	st->powerdown[chan->address] = powerdown;
>> +
>> +	if (powerdown) {
>> +		powerdown_mode = st->powerdown_mode[chan->address];
>> +		ret = dac8554_spi_write(st,
>> +					DAC8554_CMD_UPDATE_DAC_N,
>> +					chan->address,
>> +					DAC8554_PWRDN_TO_SR(powerdown_mode));
>> +	} else {
>> +		/* Load DAC with cached value. This triggers a powerup. */
>> +		ret = dac8554_spi_write(st,
>> +					DAC8554_CMD_UPDATE_DAC_N,
>> +					chan->address,
>> +					st->val[chan->address]);
>> +	}
>> +
>> +	if (ret)
>> +		return ret;
>> +
>> +	return len;
>> +}
>> +
>> +static int dac8554_powerdown(struct dac8554_state *st,
>> +			     u8 powerdown_mode)
>> +{
>> +	int chan, cmd, ret;
>> +
>> +	for (chan = DAC8554_DAC_CHANNELS - 1; chan >= 0; --chan) {
>> +		cmd = chan ? DAC8554_CMD_STORE_DAC_N
>> +			   : DAC8554_CMD_STORE_DAC_N_UPDATE_ALL;
>> +		ret = dac8554_spi_write(st, cmd, chan,
>> +					DAC8554_PWRDN_TO_SR(powerdown_mode));
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	for (chan = 0; chan < DAC8554_DAC_CHANNELS; ++chan) {
>> +		st->powerdown_mode[chan] = powerdown_mode;
>> +		st->powerdown[chan] = true;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct iio_info dac8554_info = {
>> +	.write_raw = dac8554_write_raw,
>> +	.read_raw = dac8554_read_raw,
>> +	.driver_module = THIS_MODULE,
>> +};
>> +
>> +static const char * const dac8554_powerdown_modes[] = {
>> +	"three_state",
>> +	"1kohm_to_gnd",
>> +	"100kohm_to_gnd"
>> +};
>> +
>> +static const struct iio_enum dac8854_powerdown_mode_enum = {
>> +	.items = dac8554_powerdown_modes,
>> +	.num_items = ARRAY_SIZE(dac8554_powerdown_modes),
>> +	.get = dac8554_get_powerdown_mode,
>> +	.set = dac8554_set_powerdown_mode,
>> +};
>> +
>> +static const struct iio_chan_spec_ext_info dac8554_ext_info[] = {
>> +	{
>> +		.name = "powerdown",
>> +		.read = dac8554_read_dac_powerdown,
>> +		.write = dac8554_write_dac_powerdown,
>> +		.shared = IIO_SEPARATE,
>> +	},
>> +	IIO_ENUM("powerdown_mode", IIO_SEPARATE,
>> +		 &dac8854_powerdown_mode_enum),
>> +	IIO_ENUM_AVAILABLE("powerdown_mode", &dac8854_powerdown_mode_enum),
>> +	{ },
>> +};
>> +
>> +#define DAC8554_CHANNEL(chan) { \
>> +	.type = IIO_VOLTAGE, \
>> +	.indexed = 1, \
>> +	.output = 1, \
>> +	.channel = (chan), \
>> +	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW), \
>> +	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE), \
>> +	.address = (chan), \
>> +	.ext_info = dac8554_ext_info, \
>> +}
>> +static const struct iio_chan_spec dac8554_channels[] = {
>> +	DAC8554_CHANNEL(0),
>> +	DAC8554_CHANNEL(1),
>> +	DAC8554_CHANNEL(2),
>> +	DAC8554_CHANNEL(3),
>> +};
>> +#undef DAC8554_CHANNEL
>> +
>> +static int dac8554_probe(struct spi_device *spi)
>> +{
>> +	struct dac8554_state *st;
>> +	struct iio_dev *indio_dev;
>> +	int ret;
>> +	u32 addr;
>> +
>> +	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*st));
>> +	if (!indio_dev)
>> +		return -ENOMEM;
>> +
>> +	indio_dev->dev.parent = &spi->dev;
>> +	indio_dev->name = DAC8554_DRIVERNAME;
>> +	indio_dev->info = &dac8554_info;
>> +	indio_dev->modes = INDIO_DIRECT_MODE;
>> +	indio_dev->channels = dac8554_channels;
>> +	indio_dev->num_channels = ARRAY_SIZE(dac8554_channels);
>> +
>> +	spi_set_drvdata(spi, indio_dev);
>> +
>> +	st = iio_priv(indio_dev);
>> +
>> +	if (!spi->dev.of_node) {
>> +		dev_err(&spi->dev, "missing OF node");
>> +		return -EINVAL;
>> +	}
>> +	ret = of_property_read_u32(spi->dev.of_node, "ti,address", &addr);
>> +	if (ret || addr < 0 || addr > 2) {
> In your reply to Mark, you said the address allows 4 chips.  Here you
> limit it at 0,1,2 giving 3 devices.  Should this be > 3?
> 
Good catch. The datasheet says that 4 devices are possible.
Btw. given that addr is unsigned, checking for values lower than 0 is not
really beneficial.

>> +		dev_err(&spi->dev, "no or invalid chip address");
>> +		return -EINVAL;
>> +	}
>> +
>> +	st->spi = spi;
>> +	st->addr = addr;
>> +
>> +	st->reg = devm_regulator_get(&spi->dev, "vref");
>> +	if (IS_ERR(st->reg))
>> +		return PTR_ERR(st->reg);
>> +
>> +	ret = regulator_enable(st->reg);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = dac8554_powerdown(st, DAC8554_PWRDN_100K);
>> +	if (ret)
>> +		goto error_disable_reg;
>> +
>> +	ret = iio_device_register(indio_dev);
>> +	if (ret)
>> +		goto error_disable_reg;
>> +
>> +	return 0;
>> +
>> +error_disable_reg:
>> +	regulator_disable(st->reg);
>> +	return ret;
>> +}
>> +
>> +static int dac8554_remove(struct spi_device *spi)
>> +{
>> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>> +	struct dac8554_state *st = iio_priv(indio_dev);
>> +
>> +	iio_device_unregister(indio_dev);
>> +	regulator_disable(st->reg);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id dac8554_of_match[] = {
>> +	{ .compatible = "ti,dac8554" },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, dac8554_of_match);
>> +
>> +static struct spi_driver dac8554_driver = {
>> +	.driver = {
>> +		.name = DAC8554_DRIVERNAME,
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = dac8554_of_match,
>> +	 },
>> +	.probe = dac8554_probe,
>> +	.remove = dac8554_remove,
>> +};
>> +module_spi_driver(dac8554_driver);
>> +
>> +MODULE_AUTHOR("Nikolaus Schulz <nikolaus.schulz@avionic-design.de>");
>> +MODULE_DESCRIPTION("Texas Instruments DAC8554 SPI driver");
>> +MODULE_LICENSE("GPL v2");
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

