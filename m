Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3LNQ2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 11:28:31 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49213 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3LNQ23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 11:28:29 -0500
Message-ID: <52AC8728.80907@kernel.org>
Date: Sat, 14 Dec 2013 16:28:24 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Kevin Tsai <ktsai@capellamicro.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/1] Added Capella CM32181 Ambient Light Sensor IIO Driver.
References: <1386986359-1830-1-git-send-email-ktsai@capellamicro.com>
In-Reply-To: <1386986359-1830-1-git-send-email-ktsai@capellamicro.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/13 01:59, Kevin Tsai wrote:
> Signed-off-by: Kevin Tsai <ktsai@capellamicro.com>
Hi Kevin.

Generally for a new driver we'd expect a very brief description of what
functionality it provides in the patch comment.

As a starting point, you've cc'd the devicetree list and maintainers but
there is documentation in here?  Looks at a quick glance like it might
be a candidate for a trivial binding file, but it does need to be somewhere.

If publically available it is also helpful to provide a link to the
device datasheet. Cuts down on questions by allowing reviewers to take
a look for themselves :)  A quick google implies there isn't an easily
available datasheet. Oh well.

Couple of minor bits inline.

One big question is whether the retries are inherently necessary
(i.e. does the device actually have periods when it won't reply?)
If not then drop them at which point the wrappers just add code and
make reviewing harder.  Hence please drop them infavour of calling
the i2c functions inline.

Another is whether providing the i2c detection functions makes sense
for this device.  Is it ever used of devices where its location /address
is not known in advance.

Also, you have a couple of attributes which are handled as info_mask
elements in IIO.  Finally why provide both raw and processed accesses to the
data?

Anyhow, whilst it sounds a lot, this is just a few quick tweaks and this driver
will be ready to merge.

Jonathan
> ---
>  drivers/iio/light/Kconfig   |  11 ++
>  drivers/iio/light/Makefile  |   1 +
>  drivers/iio/light/cm32181.c | 437 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 449 insertions(+)
>  create mode 100644 drivers/iio/light/cm32181.c
>
> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
> index a022f27..d12b2a0 100644
> --- a/drivers/iio/light/Kconfig
> +++ b/drivers/iio/light/Kconfig
> @@ -27,6 +27,17 @@ config APDS9300
>  	 To compile this driver as a module, choose M here: the
>  	 module will be called apds9300.
>
> +config CM32181
> +	depends on I2C
> +	tristate "CM32181 driver"
> +	help
> +	 Say Y here if you use cm32181.
> +	 This option enables ambient light sensor using
> +	 Capella cm32181 device driver.
> +
> +	 To compile this driver as a module, choose M here:
> +	 the module will be called cm32181.
> +
>  config CM36651
>  	depends on I2C
>  	tristate "CM36651 driver"
> diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
> index daa327f..60e35ac 100644
> --- a/drivers/iio/light/Makefile
> +++ b/drivers/iio/light/Makefile
> @@ -5,6 +5,7 @@
>  # When adding new entries keep the list in alphabetical order
>  obj-$(CONFIG_ADJD_S311)		+= adjd_s311.o
>  obj-$(CONFIG_APDS9300)		+= apds9300.o
> +obj-$(CONFIG_CM32181)		+= cm32181.o
>  obj-$(CONFIG_CM36651)		+= cm36651.o
>  obj-$(CONFIG_GP2AP020A00F)	+= gp2ap020a00f.o
>  obj-$(CONFIG_HID_SENSOR_ALS)	+= hid-sensor-als.o
> diff --git a/drivers/iio/light/cm32181.c b/drivers/iio/light/cm32181.c
> new file mode 100644
> index 0000000..58ab1b2
> --- /dev/null
> +++ b/drivers/iio/light/cm32181.c
> @@ -0,0 +1,437 @@
> +/*
> + * Copyright (C) 2013 Capella Microsystems Inc.
> + * Author: Kevin Tsai <ktsai@capellamicro.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General Public License version 2, as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/events.h>
> +#include <linux/init.h>
> +
> +/* Registers Address */
> +#define	CM32181_REG_ADDR_CMD		0x00
> +#define	CM32181_REG_ADDR_ALS		0x04
> +#define	CM32181_REG_ADDR_STATUS		0x06
> +#define	CM32181_REG_ADDR_ID		0x07
> +
> +/* Number of Configurable Registers */
> +#define CM32181_CONF_REG_NUM		0x01
> +
> +/* CMD register */
> +#define CM32181_CMD_ALS_ENABLE		0x00
> +#define CM32181_CMD_ALS_DISABLE		0x01
> +#define CM32181_CMD_ALS_INT_EN		0x02
> +
> +#define	CM32181_CMD_ALS_IT_SHIFT	6
> +#define	CM32181_CMD_ALS_IT_MASK		(0x0F << CM32181_CMD_ALS_IT_SHIFT)
> +#define	CM32181_CMD_ALS_IT_DEFAULT	(0x00 << CM32181_CMD_ALS_IT_SHIFT)
> +
> +#define CM32181_CMD_ALS_SM_SHIFT	11
> +#define	CM32181_CMD_ALS_SM_MASK		(0x03 << CM32181_CMD_ALS_SM_SHIFT)
> +#define	CM32181_CMD_ALS_SM_DEFAULT	(0x01 << CM32181_CMD_ALS_SM_SHIFT)
> +
> +#define	CM32181_MLUX_PER_BIT		5	/* ALS_SM=01 IT=800ms */
> +#define	CM32181_MLUX_PER_BIT_BASE_IT	800000	/* Based on IT=800ms */
> +#define	CM32181_CALIBSCALE_RESOLUTION	1000
> +#define	MLUX_PER_LUX			1000
> +
> +enum cm32181_command {
> +	CM32181_CMD_READ_RAW_LIGHT,
> +};
> +
> +static const u16 normal_i2c[] = {
> +	0x10, 0x48, I2C_CLIENT_END };
> +
> +static const u8 cm32181_reg[CM32181_CONF_REG_NUM] = {
> +	CM32181_REG_ADDR_CMD,
> +};
> +
> +static const int als_it_bits[] = {12, 8, 0, 1, 2, 3};
> +static int als_it_value[] = {25000, 50000, 100000, 200000, 400000, 800000};
> +
> +struct cm32181_chip {
> +	struct i2c_client *client;
> +	struct mutex lock;
> +	u16 conf_regs[CM32181_CONF_REG_NUM];
> +	int calibscale;
> +};
> +
> +static int cm32181_read_reg(struct i2c_client *client, u8 reg, u16 *reg_data)
> +{
> +	s32 ret;
> +	int wd;
> +
> +	wd = 5;
> +	while ((ret = i2c_smbus_read_word_data(client, reg)) < 0 &&
> +		wd-- > 0)
> +		;
> +
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Error in reading Reg.0x%02X\n", reg);
> +	} else {
> +		if (ret > 0xFFFF)
> +			ret = 0xFFFF;

This should be unnecesary in a read_word_data call.

As with the write below, unless there is a very strong reason to allow
for retries on the i2c bus (which should be very reliable) don't do so.
It is usually better to know there is a problem than to try and work
around it.

Without the retries, this wrapper adds very little so should be removed
in favour of just calling the i2c_smbus_read_word_data function instead.
> +		*reg_data = (u16)ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int cm32181_write_reg(struct i2c_client *client, u8 reg, u16 reg_data)
> +{
> +	int ret;
> +	int wd;
> +
Is comms with the device really this flakey?  If not, then drop the repeats
at which point this becomes a standard i2c_smbus_write_word_data call
and hence you should use it directly without the wrapper.
> +	wd = 5;
> +	while ((ret = i2c_smbus_write_word_data(client, reg, reg_data)) < 0 &&
> +		wd-- > 0)
> +		;
> +
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Error in writing 0x%04X to Reg.0x%02X\n",
> +			reg_data, reg);
> +	}
> +
> +	return ret;
> +}
> +
> +static int cm32181_reg_init(struct cm32181_chip *cm32181)
> +{
> +	struct i2c_client *client = cm32181->client;
> +	int i, ret;
> +
> +	cm32181->conf_regs[CM32181_REG_ADDR_CMD] = CM32181_CMD_ALS_ENABLE |
> +			CM32181_CMD_ALS_IT_DEFAULT | CM32181_CMD_ALS_SM_DEFAULT;
> +
> +	for (i = 0; i < CM32181_CONF_REG_NUM; i++) {
> +		ret = cm32181_write_reg(client, cm32181_reg[i],
> +			cm32181->conf_regs[i]);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	cm32181->calibscale = 1000;
> +
> +	return 0;
> +}
> +
> +static int cm32181_read_als_it(struct cm32181_chip *cm32181, int *val)
> +{
> +	u16 als_it;
> +	int i;
> +
> +	als_it = cm32181->conf_regs[CM32181_REG_ADDR_CMD];
> +	als_it &= CM32181_CMD_ALS_IT_MASK;
> +	als_it >>= CM32181_CMD_ALS_IT_SHIFT;
> +	for (i = 0; i < sizeof(als_it_bits)/sizeof(als_it_bits[0]); i++) {
> +		if (als_it == als_it_bits[i]) {
> +			*val = als_it_value[i];
> +			return IIO_VAL_INT;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int cm32181_write_als_it(struct cm32181_chip *cm32181, int val)
> +{
> +	struct i2c_client *client = cm32181->client;
> +	u16 als_it;
> +	int ret, i, n;
> +
> +	n = sizeof(als_it_value)/sizeof(als_it_value[0]);
> +	for (i = 0; i < n; i++)
> +		if (val <= als_it_value[i])
> +			break;
> +	if (i >= n && n > 0)
> +		i = n-1;
> +
> +	als_it = als_it_bits[i];
> +	als_it <<= CM32181_CMD_ALS_IT_SHIFT;
> +
> +	mutex_lock(&cm32181->lock);
> +	cm32181->conf_regs[CM32181_REG_ADDR_CMD] &=
> +		~CM32181_CMD_ALS_IT_MASK;
> +	cm32181->conf_regs[CM32181_REG_ADDR_CMD] |= als_it;
> +	ret = cm32181_write_reg(client, CM32181_REG_ADDR_CMD,
> +			cm32181->conf_regs[CM32181_REG_ADDR_CMD]);
> +	mutex_unlock(&cm32181->lock);
> +
> +	return ret;
> +}
> +
> +static int cm32181_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val, int *val2, long mask)
> +{
> +	struct cm32181_chip *cm32181 = iio_priv(indio_dev);
> +	struct i2c_client *client = cm32181->client;
> +	int ret = -EINVAL;
> +	u16 val16 = 0;
> +
> +	if (chan->type != IIO_LIGHT)
> +		return -EINVAL;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		ret = cm32181_read_reg(client, CM32181_REG_ADDR_ALS, &val16);
I would prefer that the logic is reversed
i.e.
	if (ret < 0)
	   return ret;
	*val = val16 (note the typecast isn't needed)
	ret = IIO_VAL_INT;

> +		if (ret >= 0) {
> +			ret = IIO_VAL_INT;
> +			*val = (int)val16;
> +		}
> +		break;
> +	case IIO_CHAN_INFO_INT_TIME:
> +		ret = cm32181_read_als_it(cm32181, val);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int cm32181_write_raw(struct iio_dev *indio_dev,
> +			     struct iio_chan_spec const *chan,
> +			     int val, int val2, long mask)
> +{
> +	struct cm32181_chip *cm32181 = iio_priv(indio_dev);
> +	struct i2c_client *client = cm32181->client;
> +	int ret = -EINVAL;
Run sparse over your code as well as checkpatch and you'll get
a warning saying that this initialization is pointless as it
is always overwritten.
> +
Can this happen?  Nope - so don't bother checking it.
> +	if (chan->type != IIO_LIGHT)
> +		return -EINVAL;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_INT_TIME:
> +		ret = cm32181_write_als_it(cm32181, val);
> +		if (ret < 0)
> +			dev_err(&client->dev, "INT_TIME write failed\n");
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t get_lux(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
> +	struct i2c_client *client = cm32181->client;
> +	unsigned long lux;
> +	int ret;
> +	int als_it;
> +	u16 val;
> +
> +	ret = cm32181_read_als_it(cm32181, &als_it);
> +	if (ret < 0 || als_it == 0)
> +		return sprintf(buf, "invalid\n");
(same comment as below).
> +
> +	lux = CM32181_MLUX_PER_BIT;
> +	lux *= CM32181_MLUX_PER_BIT_BASE_IT;
> +	lux /= als_it;
> +
> +	ret = cm32181_read_reg(client, CM32181_REG_ADDR_ALS, &val);
> +	if (ret < 0)

Return the error code - don't fill the buffer with garbage.
Any userspace program should be checking the error codes when reading
anyway and so will know the buffer doesn't have anything valid it in.

> +		return sprintf(buf, "error\n");
> +
> +	lux *= val;
> +	lux *= cm32181->calibscale;
> +	lux /= CM32181_CALIBSCALE_RESOLUTION;
> +	lux /= MLUX_PER_LUX;
blank line here please.
> +	return sprintf(buf, "%d\n", (int)lux);

If it is an unsigned long then output it is as such.
return sprintf(buf, "%lu\n", lux);

> +}
> +
> +static ssize_t get_it_available(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	int i, n, len;
> +
> +	n = sizeof(als_it_value)/sizeof(als_it_value[0]);
> +	for (i = 0, len = 0; i < n; i++)
Please run checkpatch.pl over your patches.  There should be some
spaces around the + in buf+len.

> +		len += sprintf(buf+len, "%d ", (int)als_it_value[i]);
I'm confused - why the type cast? it is already an int.
> +	return len + sprintf(buf+len, "\n");
> +}
> +
> +static ssize_t get_calibscale(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
> +	return sprintf(buf, "%d\n", cm32181->calibscale);
> +}
> +
> +static ssize_t set_calibscale(struct device *dev,
> +			struct device_attribute *attr, const char *buf,
> +			size_t count)
> +{
> +	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
> +	unsigned long lval;
> +
> +	if (kstrtoul(buf, 10, &lval))
> +		return -EINVAL;
> +
> +	cm32181->calibscale = lval;
> +	return count;
> +}
> +
> +static const struct iio_chan_spec cm32181_channels[] = {
> +	{
> +		.type = IIO_LIGHT,
> +		.indexed = 0,
> +		.channel = 0,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> +				BIT(IIO_CHAN_INFO_INT_TIME),
> +	}
> +};
> +
> +

Why are you definitn an attribute for the illuminance outputs?
These are well handled in iio-chan_spec.  Just add
BIT(IIO_CHAN_INFO_PROCESSED) to the info_mask_separate and
handle it in the read_raw callback.  The same is true for
calibscale with BIT(IIO_CHAN_INFO_CALIBSCALE).

There is a patch set under review to deal iwth the _available
attributes as well, but as it isn't there yet we can take it
as a separate attribute for now.

> +static IIO_DEVICE_ATTR(in_illuminance_input, S_IRUGO,
> +			get_lux, NULL, 0);
> +static IIO_DEVICE_ATTR(in_illuminance_integration_time_available,
> +			S_IRUGO, get_it_available, NULL, 0);
> +static IIO_DEVICE_ATTR(in_illuminance_calibscale, S_IRUGO | S_IWUSR,
> +			get_calibscale, set_calibscale, 0);
> +
> +static struct attribute *cm32181_attributes[] = {
> +	&iio_dev_attr_in_illuminance_input.dev_attr.attr,
> +	&iio_dev_attr_in_illuminance_integration_time_available.dev_attr.attr,
> +	&iio_dev_attr_in_illuminance_calibscale.dev_attr.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group cm32181_attribute_group = {
> +	.attrs = cm32181_attributes
> +};
> +
> +static const struct iio_info cm32181_info = {
> +	.driver_module		= THIS_MODULE,
> +	.read_raw		= &cm32181_read_raw,
> +	.write_raw		= &cm32181_write_raw,
> +	.attrs			= &cm32181_attribute_group,
> +};
> +
> +static int cm32181_probe(struct i2c_client *client,
> +			     const struct i2c_device_id *id)
> +{
> +	struct cm32181_chip *cm32181;
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*cm32181));
> +	if (!indio_dev) {
> +		dev_err(&client->dev, "devm_iio_device_alloc failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	cm32181 = iio_priv(indio_dev);
> +
> +	i2c_set_clientdata(client, indio_dev);
> +
> +	cm32181->client = client;
> +	mutex_init(&cm32181->lock);
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->channels = cm32181_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(cm32181_channels);
> +	indio_dev->info = &cm32181_info;
> +	indio_dev->name = id->name;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +
> +	ret = cm32181_reg_init(cm32181);
> +	if (ret) {
> +		dev_err(&client->dev, "%s: register init failed\n", __func__);
> +		goto error_disable_reg;
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret) {
Don't worry too much about the 80 char limit on error messages, though
you can break this line up as:
dev_err(&client->dev,
	"%s: register device failed\n",
	__func__);

without effecting the ability to grep for the message (which is why we don't
break error messages across multiple lines).

> +		dev_err(&client->dev, "%s: regist device failed\n", __func__);
> +		goto error_disable_reg;
> +	}
> +
> +	return 0;
> +
> +error_disable_reg:
> +	return ret;
> +}
> +
> +static int cm32181_detect(struct i2c_client *client,
> +				struct i2c_board_info *info)
> +{
> +	struct i2c_adapter *adapter = client->adapter;
> +	const char *name = NULL;
> +	u16 id;
> +	int ret;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -ENODEV;
> +
> +	ret = cm32181_read_reg(client, CM32181_REG_ADDR_ID, &id);
> +	if (ret < 0)
return ret;

There may be more information in that return in theory than
it simply didn't work.
> +		return -ENODEV;
> +

This looks like it would be cleaner as:
if ((id & 0xFF) != 0x81)
   return -ENODEV;

etc.  i.e. deal with the error case first.
> +	switch (id&0xFF) {
> +	case 0x81:
> +		name = "cm32181";
> +		break;
> +	default:
> +		return -ENODEV;
> +	}
> +
> +	strlcpy(info->type, name, I2C_NAME_SIZE);
> +	return 0;
> +}
> +
> +static int cm32181_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
If this is really all that wants to be in the remove, then you can
use the devm_iio_device_register function recently introduced
and drop this remove function entirely.

> +
> +	iio_device_unregister(indio_dev);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id cm32181_id[] = {
> +	{ "cm32181", 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, cm32181_id);
> +
> +static const struct of_device_id cm32181_of_match[] = {
> +	{ .compatible = "capella,cm32181" },
> +	{ }
> +};
> +
> +static struct i2c_driver cm32181_driver = {
> +	.driver = {
> +		.name	= "cm32181",
> +		.of_match_table = of_match_ptr(cm32181_of_match),
> +		.owner	= THIS_MODULE,
> +	},
> +	.id_table       = cm32181_id,
> +	.probe		= cm32181_probe,
> +	.remove		= cm32181_remove,
> +	/* for autodetection */
> +	.class = I2C_CLASS_HWMON,
This is not a hwmon device so this is wrong.  IF there
is a true use case for detecting these devices automatically rather than
describing them in the device tree, then propose a new class for IIO devices.

I would not normally expect to see this in an IIO driver, but I suppose
someone might connect them up to a bus on a PC motherboard or similar
(the i2c-sensors usecase).
> +	.detect		= cm32181_detect,
> +	.address_list	= normal_i2c,
> +};
> +
> +module_i2c_driver(cm32181_driver);
> +
> +MODULE_AUTHOR("Kevin Tsai <ktsai@capellamicro.com>");
> +MODULE_DESCRIPTION("CM32181 ambient light sensor driver");
> +MODULE_LICENSE("GPL");
>
