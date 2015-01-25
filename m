Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbbAYWnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 17:43:22 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:50946 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbbAYWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 17:43:20 -0500
Message-ID: <54C57180.10900@kernel.org>
Date: Sun, 25 Jan 2015 22:43:12 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Kevin Tsai <ktsai@capellamicro.com>, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Archana Patni <archana.patni@linux.intel.com>
CC: linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/1] iio: Added Capella cm3232 ambient light sensor
 driver.
References: <1421372464-30316-1-git-send-email-ktsai@capellamicro.com>
In-Reply-To: <1421372464-30316-1-git-send-email-ktsai@capellamicro.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/15 01:41, Kevin Tsai wrote:
> CM3232 is an advanced ambient light sensor with I2C protocol interface.
> The I2C slave address is internally hardwired as 0x10 (7-bit).  Writing
> to configure register is byte mode, but reading ALS register requests to
> use word mode for 16-bit resolution.
> 
> Signed-off-by: Kevin Tsai <ktsai@capellamicro.com>
Couple of little bits inline that I've cleared up in applying the patch...
(utterly trivial so lets not waste any time!)

I'ts been here a while since Daniel suggested he'd like to see comments
from Peter and Hartmut.  I'm going to take the view that it looks
fine to me, and those guys are either happy, or too busy to look!

Anyhow,

Applied with small changes as outlined below to the togreg branch of iio.git
Initially pushed out as testing for the autobuilders to play.

Thanks,

Jonathan
> ---
> v3:
> Added hw_id to als_info structure.
> Removed unused include files.
> Modified cm3232_write_als_it() to handle register update fail.
> 
> Thanks comments from Daniel Baluta.
> 
> v2:
> Removed unused CM3232_CMD_ALS_HS.
> Modified cm3232_als_info structure.  Removed id field.
> Modified cm3232_chip structure.
> Merged CM3232_als_it_bits and CM3232_als_it_values to cm3232_it_scale.
> Removed mutex lock.
> Renamed als_raw to regs_als.  Moved it to cm3232_chip structure.
> Modified cm3232_read_als_it() and cm3232_write_als_it() to support val2.
> 
> Thanks comments from Jeremiah Mahler, Peter Meerwald, Daniel Baluta,
> and Joe Perches.
> 
> v1:
> Added cm3232.c to support Capella Microsystems CM3232 Ambient Light
> Sensor.
> 
>  .../devicetree/bindings/i2c/trivial-devices.txt    |   1 +
>  MAINTAINERS                                        |   6 +
>  drivers/iio/light/Kconfig                          |  11 +
>  drivers/iio/light/Makefile                         |   1 +
>  drivers/iio/light/cm3232.c                         | 409 +++++++++++++++++++++
>  5 files changed, 428 insertions(+)
>  create mode 100644 drivers/iio/light/cm3232.c
> 
> diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> index 9f4e382..572a7c4 100644
> --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> @@ -34,6 +34,7 @@ atmel,24c512		i2c serial eeprom  (24cxx)
>  atmel,24c1024		i2c serial eeprom  (24cxx)
>  atmel,at97sc3204t	i2c trusted platform module (TPM)
>  capella,cm32181		CM32181: Ambient Light Sensor
> +capella,cm3232		CM3232: Ambient Light Sensor
>  catalyst,24c32		i2c serial eeprom
>  cirrus,cs42l51		Cirrus Logic CS42L51 audio codec
>  dallas,ds1307		64 x 8, Serial, I2C Real-Time Clock
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ddb9ac8..06a613a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2378,6 +2378,12 @@ F:	security/capability.c
>  F:	security/commoncap.c
>  F:	kernel/capability.c
>  
> +CAPELLA MICROSYSTEMS LIGHT SENSOR DRIVER
> +M:	Kevin Tsai <ktsai@capellamicro.com>
> +S:	Maintained
> +F:	drivers/iio/light/cm*
> +F:	Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +
>  CC2520 IEEE-802.15.4 RADIO DRIVER
>  M:	Varka Bhadram <varkabhadram@gmail.com>
>  L:	linux-wpan@vger.kernel.org
> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
> index 5bea821..cd5028e 100644
> --- a/drivers/iio/light/Kconfig
> +++ b/drivers/iio/light/Kconfig
> @@ -48,6 +48,17 @@ config CM32181
>  	 To compile this driver as a module, choose M here:
>  	 the module will be called cm32181.
>  
> +config CM3232
> +	depends on I2C
> +	tristate "CM3232 ambient light sensor"
> +	help
> +	 Say Y here if you use cm3232.
> +	 This option enables ambient light sensor using
> +	 Capella Microsystems cm3232 device driver.
> +
> +	 To compile this driver as a module, choose M here:
> +	 the module will be called cm3232.
> +
>  config CM36651
>  	depends on I2C
>  	tristate "CM36651 driver"
> diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
> index 47877a3..f2c8d55 100644
> --- a/drivers/iio/light/Makefile
> +++ b/drivers/iio/light/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_ADJD_S311)		+= adjd_s311.o
>  obj-$(CONFIG_AL3320A)		+= al3320a.o
>  obj-$(CONFIG_APDS9300)		+= apds9300.o
>  obj-$(CONFIG_CM32181)		+= cm32181.o
> +obj-$(CONFIG_CM3232)		+= cm3232.o
>  obj-$(CONFIG_CM36651)		+= cm36651.o
>  obj-$(CONFIG_GP2AP020A00F)	+= gp2ap020a00f.o
>  obj-$(CONFIG_HID_SENSOR_ALS)	+= hid-sensor-als.o
> diff --git a/drivers/iio/light/cm3232.c b/drivers/iio/light/cm3232.c
> new file mode 100644
> index 0000000..8573f98
> --- /dev/null
> +++ b/drivers/iio/light/cm3232.c
> @@ -0,0 +1,409 @@
> +/*
> + * CM3232 Ambient Light Sensor
> + *
> + * Copyright (C) 2014-2015 Capella Microsystems Inc.
> + * Author: Kevin Tsai <ktsai@capellamicro.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2, as published
> + * by the Free Software Foundation.
> + *
> + * IIO driver for CM3232 (7-bit I2C slave address 0x10).
> + *
blank line here doesn't serve any purpose.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/init.h>
> +
> +/* Registers Address */
> +#define CM3232_REG_ADDR_CMD		0x00
> +#define CM3232_REG_ADDR_ALS		0x50
> +#define CM3232_REG_ADDR_ID		0x53
> +
> +#define CM3232_CMD_ALS_DISABLE		BIT(0)
> +
> +#define CM3232_CMD_ALS_IT_SHIFT		2
> +#define CM3232_CMD_ALS_IT_MASK		(BIT(2) | BIT(3) | BIT(4))
> +#define CM3232_CMD_ALS_IT_DEFAULT	(0x01 << CM3232_CMD_ALS_IT_SHIFT)
> +
> +#define CM3232_CMD_ALS_RESET		BIT(6)
> +
> +#define CM3232_CMD_DEFAULT		CM3232_CMD_ALS_IT_DEFAULT
> +
> +#define CM3232_HW_ID			0x32
> +#define CM3232_CALIBSCALE_DEFAULT	100000
> +#define CM3232_CALIBSCALE_RESOLUTION	100000
> +#define CM3232_MLUX_PER_LUX		1000
> +
> +#define CM3232_MLUX_PER_BIT_DEFAULT	64
> +#define CM3232_MLUX_PER_BIT_BASE_IT	100000
> +
> +static const struct {
> +	int val;
> +	int val2;
> +	u8 it;
> +} cm3232_als_it_scales[] = {
> +	{0, 100000, 0},	/* 0.100000 */
> +	{0, 200000, 1},	/* 0.200000 */
> +	{0, 400000, 2},	/* 0.400000 */
> +	{0, 800000, 3},	/* 0.800000 */
> +	{1, 600000, 4},	/* 1.600000 */
> +	{3, 200000, 5},	/* 3.200000 */
> +};
> +
> +struct cm3232_als_info {
> +	u8 regs_cmd_default;
> +	u8 hw_id;
> +	int calibscale;
> +	int mlux_per_bit;
> +	int mlux_per_bit_base_it;
> +};
> +
> +static struct cm3232_als_info cm3232_als_info_default = {
> +	.regs_cmd_default = CM3232_CMD_DEFAULT,
> +	.hw_id = CM3232_HW_ID,
> +	.calibscale = CM3232_CALIBSCALE_DEFAULT,
> +	.mlux_per_bit = CM3232_MLUX_PER_BIT_DEFAULT,
> +	.mlux_per_bit_base_it = CM3232_MLUX_PER_BIT_BASE_IT,
> +};
> +
> +struct cm3232_chip {
> +	struct i2c_client *client;
> +	struct cm3232_als_info *als_info;
> +	u8 regs_cmd;
> +	u16 regs_als;
> +};
> +
> +static int cm3232_get_lux(struct cm3232_chip *chip);
> +static int cm3232_read_als_it(struct cm3232_chip *chip, int *val, int *val2);
personally I'd just reorganize the code so these forward defs
aren't needed.  Oh, just checked.  You don't need them!

I'll drop these in a merge if nothing else comes up.
> +
> +/**
> + * cm3232_reg_init() - Initialize CM3232
> + * @chip:	pointer of struct cm3232_chip.
> + *
> + * Check and initialize CM3232 ambient light sensor.
> + *
> + * Return: 0 for success; otherwise for error code.
> + */
> +static int cm3232_reg_init(struct cm3232_chip *chip)
> +{
> +	struct i2c_client *client = chip->client;
> +	s32 ret;
> +
> +	chip->als_info = &cm3232_als_info_default;
> +
> +	/* Identify device */
> +	ret = i2c_smbus_read_word_data(client, CM3232_REG_ADDR_ID);
> +	if (ret < 0) {
> +		dev_err(&chip->client->dev, "Error reading addr_id\n");
> +		return ret;
> +	}
> +
> +	if ((ret & 0xFF) != chip->als_info->hw_id)
> +		return -ENODEV;
> +
> +	/* Disable and reset device */
> +	chip->regs_cmd = CM3232_CMD_ALS_DISABLE | CM3232_CMD_ALS_RESET;
> +	ret = i2c_smbus_write_byte_data(client, CM3232_REG_ADDR_CMD,
> +					chip->regs_cmd);
> +	if (ret < 0) {
> +		dev_err(&chip->client->dev, "Error writing reg_cmd\n");
> +		return ret;
> +	}
> +
> +	/* Register default value */
> +	chip->regs_cmd = chip->als_info->regs_cmd_default;
> +
> +	/* Configure register */
> +	ret = i2c_smbus_write_byte_data(client, CM3232_REG_ADDR_CMD,
> +					chip->regs_cmd);
> +	if (ret < 0)
> +		dev_err(&chip->client->dev, "Error writing reg_cmd\n");
> +
> +	return 0;
> +}
> +
> +/**
> + *  cm3232_read_als_it() - Get sensor integration time
> + *  @chip:	pointer of struct cm3232_chip
> + *  @val:	pointer of int to load the integration (sec).
> + *  @val2:	pointer of int to load the integration time (microsecond).
> + *
> + *  Report the current integration time.
> + *
> + *  Return: IIO_VAL_INT_PLUS_MICRO for success, otherwise -EINVAL.
> + */
> +static int cm3232_read_als_it(struct cm3232_chip *chip, int *val, int *val2)
> +{
> +	u16 als_it;
> +	int i;
> +
> +	als_it = chip->regs_cmd;
> +	als_it &= CM3232_CMD_ALS_IT_MASK;
> +	als_it >>= CM3232_CMD_ALS_IT_SHIFT;
> +	for (i = 0; i < ARRAY_SIZE(cm3232_als_it_scales); i++) {
> +		if (als_it == cm3232_als_it_scales[i].it) {
> +			*val = cm3232_als_it_scales[i].val;
> +			*val2 = cm3232_als_it_scales[i].val2;
> +			return IIO_VAL_INT_PLUS_MICRO;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +/**
> + * cm3232_write_als_it() - Write sensor integration time
> + * @chip:	pointer of struct cm3232_chip.
> + * @val:	integration time in second.
> + * @val2:	integration time in microsecond.
> + *
> + * Convert integration time to sensor value.
> + *
> + * Return: i2c_smbus_write_byte_data command return value.
> + */
> +static int cm3232_write_als_it(struct cm3232_chip *chip, int val, int val2)
> +{
> +	struct i2c_client *client = chip->client;
> +	u16 als_it, cmd;
> +	int i;
> +	s32 ret;
> +
> +	for (i = 0; i < ARRAY_SIZE(cm3232_als_it_scales); i++) {
> +		if (val == cm3232_als_it_scales[i].val &&
> +			val2 == cm3232_als_it_scales[i].val2) {
> +
> +			als_it = cm3232_als_it_scales[i].it;
> +			als_it <<= CM3232_CMD_ALS_IT_SHIFT;
> +
> +			cmd = chip->regs_cmd & ~CM3232_CMD_ALS_IT_MASK;
> +			cmd |= als_it;
> +			ret = i2c_smbus_write_byte_data(client,
> +							CM3232_REG_ADDR_CMD,
> +							cmd);
> +			if (ret < 0)
> +				return ret;
> +			chip->regs_cmd = cmd;
> +			return 0;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +/**
> + * cm3232_get_lux() - report current lux value
> + * @chip:	pointer of struct cm3232_chip.
> + *
> + * Convert sensor data to lux.  It depends on integration
> + * time and calibscale variable.
> + *
> + * Return: Zero or positive value is lux, otherwise error code.
> + */
> +static int cm3232_get_lux(struct cm3232_chip *chip)
> +{
> +	struct i2c_client *client = chip->client;
> +	struct cm3232_als_info *als_info = chip->als_info;
> +	int ret;
> +	int val, val2;
> +	int als_it;
> +	u64 lux;
> +
> +	/* Calculate mlux per bit based on als_it */
> +	ret = cm3232_read_als_it(chip, &val, &val2);
> +	if (ret < 0)
> +		return -EINVAL;
> +	als_it = val * 1000000 + val2;
> +	lux = (__force u64)als_info->mlux_per_bit;
> +	lux *= als_info->mlux_per_bit_base_it;
> +	lux = div_u64(lux, als_it);
> +
> +	ret = i2c_smbus_read_word_data(client, CM3232_REG_ADDR_ALS);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Error reading reg_addr_als\n");
> +		return ret;
> +	}
> +
> +	chip->regs_als = (u16)ret;
> +	lux *= chip->regs_als;
> +	lux *= als_info->calibscale;
> +	lux = div_u64(lux, CM3232_CALIBSCALE_RESOLUTION);
> +	lux = div_u64(lux, CM3232_MLUX_PER_LUX);
> +
> +	if (lux > 0xFFFF)
> +		lux = 0xFFFF;
> +
> +	return (int)lux;
> +}
> +
> +static int cm3232_read_raw(struct iio_dev *indio_dev,
> +			struct iio_chan_spec const *chan,
> +			int *val, int *val2, long mask)
> +{
> +	struct cm3232_chip *chip = iio_priv(indio_dev);
> +	struct cm3232_als_info *als_info = chip->als_info;
> +	int ret;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_PROCESSED:
> +		ret = cm3232_get_lux(chip);
> +		if (ret < 0)
> +			return ret;
> +		*val = ret;
> +		return IIO_VAL_INT;
> +	case IIO_CHAN_INFO_CALIBSCALE:
> +		*val = als_info->calibscale;
> +		return IIO_VAL_INT;
> +	case IIO_CHAN_INFO_INT_TIME:
> +		return cm3232_read_als_it(chip, val, val2);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int cm3232_write_raw(struct iio_dev *indio_dev,
> +			struct iio_chan_spec const *chan,
> +			int val, int val2, long mask)
> +{
> +	struct cm3232_chip *chip = iio_priv(indio_dev);
> +	struct cm3232_als_info *als_info = chip->als_info;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_CALIBSCALE:
> +		als_info->calibscale = val;
> +		return 0;
> +	case IIO_CHAN_INFO_INT_TIME:
> +		return cm3232_write_als_it(chip, val, val2);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +/**
> + * cm3232_get_it_available() - Get available ALS IT value
> + * @dev:	pointer of struct device.
> + * @attr:	pointer of struct device_attribute.
> + * @buf:	pointer of return string buffer.
> + *
> + * Display the available integration time in second.
> + *
> + * Return: string length.
> + */
> +static ssize_t cm3232_get_it_available(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	int i, len;
> +
> +	for (i = 0, len = 0; i < ARRAY_SIZE(cm3232_als_it_scales); i++)
> +		len += scnprintf(buf + len, PAGE_SIZE - len, "%u.%06u ",
> +			cm3232_als_it_scales[i].val,
> +			cm3232_als_it_scales[i].val2);
> +	return len + scnprintf(buf + len, PAGE_SIZE - len, "\n");
> +}
> +
> +static const struct iio_chan_spec cm3232_channels[] = {
> +	{
> +		.type = IIO_LIGHT,
> +		.info_mask_separate =
> +			BIT(IIO_CHAN_INFO_PROCESSED) |
> +			BIT(IIO_CHAN_INFO_CALIBSCALE) |
> +			BIT(IIO_CHAN_INFO_INT_TIME),
> +	}
> +};
> +
> +static IIO_DEVICE_ATTR(in_illuminance_integration_time_available,
> +			S_IRUGO, cm3232_get_it_available, NULL, 0);
> +
> +static struct attribute *cm3232_attributes[] = {
> +	&iio_dev_attr_in_illuminance_integration_time_available.dev_attr.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group cm3232_attribute_group = {
> +	.attrs = cm3232_attributes
> +};
> +
> +static const struct iio_info cm3232_info = {
> +	.driver_module		= THIS_MODULE,
> +	.read_raw		= &cm3232_read_raw,
> +	.write_raw		= &cm3232_write_raw,
> +	.attrs			= &cm3232_attribute_group,
> +};
> +
> +static int cm3232_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct cm3232_chip *chip;
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*chip));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	chip = iio_priv(indio_dev);
> +	i2c_set_clientdata(client, indio_dev);
> +	chip->client = client;
> +
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->channels = cm3232_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(cm3232_channels);
> +	indio_dev->info = &cm3232_info;
> +	if (id && id->name)
> +		indio_dev->name = id->name;
> +	else
> +		indio_dev->name = (char *)dev_name(&client->dev);
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +
> +	ret = cm3232_reg_init(chip);
> +	if (ret) {
> +		dev_err(&client->dev,
> +			"%s: register init failed\n",
> +			__func__);
> +		return ret;
> +	}
> +
> +	return iio_device_register(indio_dev);
> +}
> +
> +static int cm3232_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +
> +	i2c_smbus_write_byte_data(client, CM3232_REG_ADDR_CMD,
> +		CM3232_CMD_ALS_DISABLE);
> +
> +	iio_device_unregister(indio_dev);
If getting really fussy, a blank line here is the convention.
> +	return 0;
> +}
> +
> +static const struct i2c_device_id cm3232_id[] = {
> +	{"cm3232", 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, cm3232_id);
> +
> +static const struct of_device_id cm3232_of_match[] = {
> +	{.compatible = "capella,cm3232"},
> +	{}
> +};
> +
> +static struct i2c_driver cm3232_driver = {
> +	.driver = {
> +		.name	= "cm3232",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(cm3232_of_match),
> +	},
> +	.id_table	= cm3232_id,
> +	.probe		= cm3232_probe,
> +	.remove		= cm3232_remove,
> +};
> +
> +module_i2c_driver(cm3232_driver);
> +
> +MODULE_AUTHOR("Kevin Tsai <ktsai@capellamicro.com>");
> +MODULE_DESCRIPTION("CM3232 ambient light sensor driver");
> +MODULE_LICENSE("GPL");
> 

