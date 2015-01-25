Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbbAYK1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 05:27:35 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47051 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbbAYK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 05:27:32 -0500
Message-ID: <54C4C510.5090306@kernel.org>
Date: Sun, 25 Jan 2015 10:27:28 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: ktsai@capellamicro.com, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: light: Add support for Capella CM3323 color/light
 sensor
References: <1421921412-7710-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1421921412-7710-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 10:10, Daniel Baluta wrote:
> Minimal implementation providing raw light intensity and illuminance
> readings. For illuminance user can compute lux values using raw readings
> and scale.
> 
> This driver also supports CM3323E sensor chip.
> 
> Cc: Kevin Tsai <ktsai@capellamicro.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>

Hi Daniel,

My only real question on this one is whether using the 'green' channel
and pretending it is a measure of illuminance is a good idea or whether
we are better leaving that decision to userspace...

I'm guessing the reason it is green rather than clear is that
the clear is letting infrared through and we don't have an additional
infrared sensor available to allow that component to be removed?

Jonathan
> ---
>  drivers/iio/light/Kconfig  |  10 ++
>  drivers/iio/light/Makefile |   1 +
>  drivers/iio/light/cm3323.c | 345 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 356 insertions(+)
>  create mode 100644 drivers/iio/light/cm3323.c
> 
> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
> index 5bea821..aeaf1c7 100644
> --- a/drivers/iio/light/Kconfig
> +++ b/drivers/iio/light/Kconfig
> @@ -48,6 +48,16 @@ config CM32181
>  	 To compile this driver as a module, choose M here:
>  	 the module will be called cm32181.
>  
> +config CM3323
> +	depends on I2C
> +	tristate "Capella CM3323 color/ambient light sensor"
> +	help
> +	 Say Y here if you want to build a driver for Capela CM3323
> +	 color sensor. This driver also supports CM3323E sensor.
> +
> +	 To compile this driver as a module, choose M here: the module will
> +	 be called cm3323.
> +
>  config CM36651
>  	depends on I2C
>  	tristate "CM36651 driver"
> diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
> index 47877a3..0815b38 100644
> --- a/drivers/iio/light/Makefile
> +++ b/drivers/iio/light/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_ADJD_S311)		+= adjd_s311.o
>  obj-$(CONFIG_AL3320A)		+= al3320a.o
>  obj-$(CONFIG_APDS9300)		+= apds9300.o
>  obj-$(CONFIG_CM32181)		+= cm32181.o
> +obj-$(CONFIG_CM3323)		+= cm3323.o
>  obj-$(CONFIG_CM36651)		+= cm36651.o
>  obj-$(CONFIG_GP2AP020A00F)	+= gp2ap020a00f.o
>  obj-$(CONFIG_HID_SENSOR_ALS)	+= hid-sensor-als.o
> diff --git a/drivers/iio/light/cm3323.c b/drivers/iio/light/cm3323.c
> new file mode 100644
> index 0000000..5e9b32d
> --- /dev/null
> +++ b/drivers/iio/light/cm3323.c
> @@ -0,0 +1,345 @@
> +/*
> + * CM3323/CM3323E - Capella Color/Ambient Light Sensor
> + *
> + * Copyright (c) 2015, Intel Corporation.
> + *
> + * This file is subject to the terms and conditions of version 2 of
> + * the GNU General Public License.  See the file COPYING in the main
> + * directory of this archive for more details.
> + *
> + * IIO driver for CM3323/CM3323E (7-bit I2C slave address 0x10)
> + *
> + * TODO: calibscale to correct the lens factor
> + */
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/mutex.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +
> +#define CM3323_DRV_NAME "cm3323"
> +
> +#define CM3323_CMD_CONF		0x00
> +#define CM3323_CMD_RED_DATA	0x08
> +#define CM3323_CMD_GREEN_DATA	0x09
> +#define CM3323_CMD_BLUE_DATA	0x0A
> +#define CM3323_CMD_CLEAR_DATA	0x0B
> +
> +#define CM3323_CONF_SD_BIT	BIT(0) /* sensor disable */
> +#define CM3323_CONF_AF_BIT	BIT(1) /* auto/manual force mode */
> +#define CM3323_CONF_IT_MASK	(BIT(4) | BIT(5) | BIT(6))
> +#define CM3323_CONF_IT_SHIFT	4
> +
> +#define CM3323_INT_TIME_AVAILABLE "0.04 0.08 0.16 0.32 0.64 1.28"
> +#define CM3323_SCALE_AVAILABLE "0.18 0.09 0.045 0.0225 0.01125 0.005625"
> +
> +static const struct {
> +	int val;
> +	int val2;
> +} cm3323_int_time[] = {
> +	{0, 40000},  /* 40 ms */
> +	{0, 80000},  /* 80 ms */
> +	{0, 160000}, /* 160 ms */
> +	{0, 320000}, /* 320 ms */
> +	{0, 640000}, /* 640 ms */
> +	{1, 280000}, /* 1280 ms */
> +};
> +
> +/* scale depends on integration time */
> +static int cm3323_uscale[] = {
> +	180000, /* 40 ms */
> +	 90000, /* 80 ms */
> +	 45000, /* 160 ms */
> +	 22500, /* 320 ms */
> +	 11250, /* 640 ms */
> +	 5625,  /* 1280 ms */
> +};
> +
> +struct cm3323_data {
> +	struct i2c_client *client;
> +	u16 reg_conf;
> +	struct mutex mutex;
> +};
> +
> +#define CM3323_COLOR_CHANNEL(_color, _addr) {\
> +	.type = IIO_INTENSITY, \
> +	.modified = 1, \
> +	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW), \
> +	.info_mask_shared_by_all = BIT(IIO_CHAN_INFO_INT_TIME), \
> +	.channel2 = IIO_MOD_LIGHT_##_color, \
> +	.address = _addr, \
> +}
> +
> +/*
> + * CM3323's GREEN channel is used for reading illuminance
That's impressively random and unlikely to be anywhere near correct
pretty much all the time!

I'd personally prefer just not providing an illuminance channel
and leaving it up to userspace to make the decision on whether the
green channel is good enough...
> + */
> +#define CM3323_LIGHT_CHANNEL(_addr) {\
> +	.type = IIO_LIGHT, \
> +	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) | \
> +			      BIT(IIO_CHAN_INFO_SCALE), \
> +	.info_mask_shared_by_all = BIT(IIO_CHAN_INFO_INT_TIME), \
> +	.address = _addr, \
> +}
> +
> +static const struct iio_chan_spec cm3323_channels[] = {
> +	CM3323_COLOR_CHANNEL(RED, CM3323_CMD_RED_DATA),
> +	CM3323_COLOR_CHANNEL(GREEN, CM3323_CMD_GREEN_DATA),
> +	CM3323_COLOR_CHANNEL(BLUE, CM3323_CMD_BLUE_DATA),
> +	CM3323_COLOR_CHANNEL(CLEAR, CM3323_CMD_CLEAR_DATA),
> +	CM3323_LIGHT_CHANNEL(CM3323_CMD_GREEN_DATA),
> +};
> +
> +static IIO_CONST_ATTR(in_illuminance_scale_available, CM3323_SCALE_AVAILABLE);
> +static IIO_CONST_ATTR_INT_TIME_AVAIL(CM3323_INT_TIME_AVAILABLE);
> +
> +static struct attribute *cm3323_attributes[] = {
> +	&iio_const_attr_integration_time_available.dev_attr.attr,
> +	&iio_const_attr_in_illuminance_scale_available.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group cm3323_attribute_group = {
> +	.attrs = cm3323_attributes,
> +};
> +
> +static int cm3323_init(struct iio_dev *indio_dev)
> +{
> +	int ret;
> +	struct cm3323_data *data = iio_priv(indio_dev);
> +
> +	ret = i2c_smbus_read_word_data(data->client, CM3323_CMD_CONF);
> +	if (ret < 0) {
> +		dev_err(&data->client->dev, "Error reading reg_conf\n");
> +		return ret;
> +	}
> +
> +	/* enable sensor and set auto force mode */
> +	ret &= ~(CM3323_CONF_SD_BIT | CM3323_CONF_AF_BIT);
> +
> +	ret = i2c_smbus_write_word_data(data->client, CM3323_CMD_CONF, ret);
> +	if (ret < 0) {
> +		dev_err(&data->client->dev, "Error writing reg_conf\n");
> +		return ret;
> +	}
> +
> +	data->reg_conf = ret;
> +
> +	return 0;
> +}
> +
> +static int cm3323_set_it_bits(struct cm3323_data *data, int val, int val2)
> +{
> +	int i, ret;
> +	u16 reg_conf;
> +
> +	for (i = 0; i < ARRAY_SIZE(cm3323_int_time); i++) {
> +		if (val == cm3323_int_time[i].val &&
> +			val2 == cm3323_int_time[i].val2) {
> +			reg_conf = data->reg_conf;
> +			reg_conf |= i << CM3323_CONF_IT_SHIFT;
> +
> +			ret = i2c_smbus_write_word_data(data->client,
> +				 CM3323_CMD_CONF, reg_conf);
> +			if (ret < 0)
> +				return ret;
> +
> +			data->reg_conf = reg_conf;
> +			return 0;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +static int cm3323_set_scale(struct cm3323_data *data, int val, int val2)
> +{
> +	int i, ret;
> +	u16 reg_conf;
> +
> +	if (val != 0)
> +		return 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(cm3323_uscale); i++) {
> +		if (val2 == cm3323_uscale[i]) {
> +			reg_conf = data->reg_conf;
> +			reg_conf |= i << CM3323_CONF_IT_SHIFT;
> +
> +			ret = i2c_smbus_write_word_data(data->client,
> +				 CM3323_CMD_CONF, reg_conf);
> +			if (ret < 0)
> +				return ret;
> +
> +			data->reg_conf = reg_conf;
> +			return 0;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +static int cm3323_get_it_bits(struct cm3323_data *data)
> +{
> +	int bits;
> +
> +	bits = (data->reg_conf & CM3323_CONF_IT_MASK) >>
> +		CM3323_CONF_IT_SHIFT;
> +
> +	if (bits >= ARRAY_SIZE(cm3323_int_time))
> +		return -EINVAL;
> +	return bits;
> +}
> +
> +static int cm3323_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan, int *val,
> +			    int *val2, long mask)
> +{
> +	int i, ret;
> +	struct cm3323_data *data = iio_priv(indio_dev);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		mutex_lock(&data->mutex);
> +		ret = i2c_smbus_read_word_data(data->client, chan->address);
> +		if (ret < 0) {
> +			mutex_unlock(&data->mutex);
> +			return ret;
> +		}
> +		*val = ret;
> +		mutex_unlock(&data->mutex);
> +
> +		return IIO_VAL_INT;
> +	case IIO_CHAN_INFO_INT_TIME:
> +		mutex_lock(&data->mutex);
> +		i = cm3323_get_it_bits(data);
> +		if (i < 0) {
> +			mutex_unlock(&data->mutex);
> +			return -EINVAL;
> +		}
> +
> +		*val = cm3323_int_time[i].val;
> +		*val2 = cm3323_int_time[i].val2;
> +		mutex_unlock(&data->mutex);
> +
> +		return IIO_VAL_INT_PLUS_MICRO;
> +	case IIO_CHAN_INFO_SCALE:
> +		if (chan->type != IIO_LIGHT)
> +			return -EINVAL;
> +
> +		mutex_lock(&data->mutex);
> +		i = cm3323_get_it_bits(data);
> +		if (i < 0) {
> +			mutex_unlock(&data->mutex);
> +			return -EINVAL;
> +		}
> +		*val = 0;
> +		*val2 = cm3323_uscale[i];
> +		mutex_unlock(&data->mutex);
> +
> +		return IIO_VAL_INT_PLUS_MICRO;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int cm3323_write_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan, int val,
> +			    int val2, long mask)
> +{
> +	struct cm3323_data *data = iio_priv(indio_dev);
> +	int ret;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_INT_TIME:
> +		mutex_lock(&data->mutex);
> +		ret = cm3323_set_it_bits(data, val, val2);
> +		mutex_unlock(&data->mutex);
> +
> +		return ret;
> +	case IIO_CHAN_INFO_SCALE:
> +		if (chan->type != IIO_LIGHT)
> +			return -EINVAL;
> +		mutex_lock(&data->mutex);
> +		ret = cm3323_set_scale(data, val, val2);
> +		mutex_unlock(&data->mutex);
> +		return ret;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct iio_info cm3323_info = {
> +	.driver_module	= THIS_MODULE,
> +	.read_raw	= cm3323_read_raw,
> +	.write_raw	= cm3323_write_raw,
> +	.attrs		= &cm3323_attribute_group,
> +};
> +
> +static int cm3323_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct cm3323_data *data;
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	data = iio_priv(indio_dev);
> +	i2c_set_clientdata(client, indio_dev);
> +	data->client = client;
> +
> +	mutex_init(&data->mutex);
> +
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->info = &cm3323_info;
> +	indio_dev->name = CM3323_DRV_NAME;
> +	indio_dev->channels = cm3323_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(cm3323_channels);
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +
> +	ret = cm3323_init(indio_dev);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "cm3323 chip init failed\n");
> +		return ret;
> +	}
> +	return devm_iio_device_register(&client->dev, indio_dev);
> +}
> +
> +static int cm3323_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +	struct cm3323_data *data  = iio_priv(indio_dev);
> +	int ret;
> +
> +	mutex_lock(&data->mutex);
> +	/* disable sensor */
> +	ret = i2c_smbus_write_word_data(client, CM3323_CMD_CONF,
> +					CM3323_CONF_SD_BIT);
> +	if (ret < 0)
> +		dev_err(&client->dev, "Error writing reg_conf\n");
> +
> +	mutex_unlock(&data->mutex);
> +	return ret;
> +}
> +
> +static const struct i2c_device_id cm3323_id[] = {
> +	{"cm3323", 0},
> +	{"cm3323e", 0},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, cm3323_id);
> +
> +static struct i2c_driver cm3323_driver = {
> +	.driver = {
> +		.name = CM3323_DRV_NAME,
> +	},
> +	.probe		= cm3323_probe,
> +	.remove		= cm3323_remove,
> +	.id_table	= cm3323_id,
> +};
> +
> +module_i2c_driver(cm3323_driver);
> +
> +MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com>");
> +MODULE_DESCRIPTION("Capella CM3323 Color/Ambient Light Sensor driver");
> +MODULE_LICENSE("GPL v2");
> 

