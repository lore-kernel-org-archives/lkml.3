Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbaH0Iti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:49:38 -0400
Received: from mout.gmx.net ([212.227.17.22]:55659 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbaH0Ita (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:49:30 -0400
Message-ID: <53FD9B88.5070901@gmx.de>
Date: Wed, 27 Aug 2014 10:49:12 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org,
        linux-iio@vger.kernel.org, pmeerw@pmeerw.net
CC: linux-kernel@vger.kernel.org, Tsechih_Lin@asus.com
Subject: Re: [PATCH v3] iio: Add Dyna-Image AL3320A ambient light sensor driver
References: <1408699042-17336-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1408699042-17336-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:2bI4jOJtU0QnsbrmDwZjErFCdektw2FBUkOC6s9U/lvB88pwaM9
 +yIEN4khBz2I7ReyDvi6dTE5ocLldfiscS/P0TbXk0TZfZus6y4+uOSmfSwRq2UzUgBiXrx
 LSDYGy/gsjbIyxyPfEmz6bTr9uLKZauVG+Pvs3DOa4SjFIv9OfhurGYufYxgnR0yiTaPZlX
 L5ynyJH97wGFhisLI8YHw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb:
> Minimal implementation. This driver provides raw illuminance readings.
>
> This is based on drivers/hwmon/al3320.c (*) driver from msm tree written
> by Tsechih Lin <Tsechih_Lin@asus.com>
>
> * https://android.googlesource.com/kernel/msm.git
>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Hi, I think you should protect your write_raw with a mutex. Other minor comments inline.
> ---
> Changes since v2: (reported by Peter Meerwald)
> 	* removed definition of DATA_HIGH and SW_RESET as they are not used
> 	* added a comment to al3320a_get_adc_value() function
> 	* added thresholds on TODO list
> 	* small stye fixes
>
> Changes since v1: (reported by Peter Meerwald)
> 	* used u8 instead of int for passing gain and mean_time
> 	* used i2c_smbus_read_word_swapped instead of 2 x i2c_smbus_read_byte_data
> 	* used devm_iio_device_register instead of iio_device_register
> 	* small style fixes
>
>  drivers/iio/light/Kconfig   |  10 ++
>  drivers/iio/light/Makefile  |   1 +
>  drivers/iio/light/al3320a.c | 255 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 266 insertions(+)
>  create mode 100644 drivers/iio/light/al3320a.c
>
> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
> index bf05ca5..5bea821 100644
> --- a/drivers/iio/light/Kconfig
> +++ b/drivers/iio/light/Kconfig
> @@ -17,6 +17,16 @@ config ADJD_S311
>  	 This driver can also be built as a module.  If so, the module
>  	 will be called adjd_s311.
>  
> +config AL3320A
> +	tristate "AL3320A ambient light sensor"
> +	depends on I2C
> +	help
> +	 Say Y here if you want to build a driver for the Dyna Image AL3320A
> +	 ambient light sensor.
> +
> +	 To compile this driver as a module, choose M here: the
> +	 module will be called al3320a.
> +
>  config APDS9300
>  	tristate "APDS9300 ambient light sensor"
>  	depends on I2C
> diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
> index 8b8c09f..47877a3 100644
> --- a/drivers/iio/light/Makefile
> +++ b/drivers/iio/light/Makefile
> @@ -4,6 +4,7 @@
>  
>  # When adding new entries keep the list in alphabetical order
>  obj-$(CONFIG_ADJD_S311)		+= adjd_s311.o
> +obj-$(CONFIG_AL3320A)		+= al3320a.o
>  obj-$(CONFIG_APDS9300)		+= apds9300.o
>  obj-$(CONFIG_CM32181)		+= cm32181.o
>  obj-$(CONFIG_CM36651)		+= cm36651.o
> diff --git a/drivers/iio/light/al3320a.c b/drivers/iio/light/al3320a.c
> new file mode 100644
> index 0000000..28fc8b0
> --- /dev/null
> +++ b/drivers/iio/light/al3320a.c
> @@ -0,0 +1,255 @@
> +/*
> + * AL3320A - Dyna Image Ambient Light Sensor
> + *
> + * Copyright (c) 2014, Intel Corporation.
> + *
> + * This file is subject to the terms and conditions of version 2 of
> + * the GNU General Public License.  See the file COPYING in the main
> + * directory of this archive for more details.
> + *
> + * IIO driver for AL3320A (7-bit I2C slave address 0x1C).
> + *
> + * TODO: interrupt support, thresholds
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +
> +#define AL3320A_DRV_NAME "al3320a"
> +
> +#define AL3320A_REG_CONFIG		0x00
> +#define AL3320A_REG_STATUS		0x01
> +#define AL3320A_REG_INT			0x02
> +#define AL3320A_REG_WAIT		0x06
> +#define AL3320A_REG_CONFIG_RANGE	0x07
> +#define AL3320A_REG_PERSIST		0x08
> +#define AL3320A_REG_MEAN_TIME		0x09
> +#define AL3320A_REG_ADUMMY		0x0A
> +#define AL3320A_REG_DATA_LOW		0x22
> +
> +#define AL3320A_REG_LOW_THRESH_LOW	0x30
> +#define AL3320A_REG_LOW_THRESH_HIGH	0x31
> +#define AL3320A_REG_HIGH_THRESH_LOW	0x32
> +#define AL3320A_REG_HIGH_THRESH_HIGH	0x33
> +
> +#define AL3320A_CONFIG_DISABLE		0x00
> +#define AL3320A_CONFIG_ENABLE		BIT(0)
> +
> +#define AL3320A_GAIN_SHIFT		1
> +
> +/* chip params default values */
> +#define AL3320A_DEFAULT_MEAN_TIME	4
> +#define AL3320A_DEFAULT_WAIT_TIME	0 /* no waiting */
> +
> +enum al3320a_range {
> +	AL3320A_RANGE_1, /* 33.28K lux */
> +	AL3320A_RANGE_2, /* 8.32K lux  */
> +	AL3320A_RANGE_3, /* 2.08K lux  */
> +	AL3320A_RANGE_4  /* 0.65K lux  */
> +};
> +
> +static const int al3320a_scales[][2] = {
> +	{0, 512000}, {0, 128000}, {0, 32000}, {0, 10000}
> +};
> +
> +struct al3320a_data {
> +	struct i2c_client *client;
> +	u8 range;
> +};
> +
> +static const struct iio_chan_spec al3320a_channels[] = {
> +	{
> +		.type	= IIO_LIGHT,
> +		.info_mask_separate =
> +			BIT(IIO_CHAN_INFO_RAW) |
> +			BIT(IIO_CHAN_INFO_SCALE),
I would indent it like this:

+		.type = IIO_LIGHT,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
+				      BIT(IIO_CHAN_INFO_SCALE),


> +	}
> +};
> +
> +static int al3320a_enable(struct al3320a_data *data)
> +{
> +	return i2c_smbus_write_byte_data(data->client, AL3320A_REG_CONFIG,
> +					 AL3320A_CONFIG_ENABLE);
> +}
> +
> +static int al3320a_disable(struct al3320a_data *data)
> +{
> +	return i2c_smbus_write_byte_data(data->client, AL3320A_REG_CONFIG,
> +					 AL3320A_CONFIG_DISABLE);
> +}
> +
> +static int al3320a_set_config_range(struct al3320a_data *data, u8 gain)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte_data(data->client, AL3320A_REG_CONFIG_RANGE,
> +					 gain << AL3320A_GAIN_SHIFT);
If you remove the whitespace before gain, you would get a perfect indentation.
> +	if (ret >= 0)
>From the description: This executes the SMBus "write byte" protocol, returning negative errno else zero on success.
So, checking for 0 is sufficient and fits better with your upper level functions.
> +		data->range = gain;
> +	return ret;
> +}
> +
> +static int al3320a_set_mean_time(struct al3320a_data *data, u8 mean_time)
> +{
> +	return i2c_smbus_write_byte_data(data->client, AL3320A_REG_MEAN_TIME,
> +					 mean_time);
> +}
> +
> +static int al3320a_set_wait_time(struct al3320a_data *data, u8 wait_time)
> +{
> +	return i2c_smbus_write_byte_data(data->client, AL3320A_REG_WAIT,
> +					 wait_time);
> +}
> +
> +/**
> + * al3320a_get_adc_value() - report raw ADC reading
> + * @data - pointer to struct al3320a_data
> + *
> + * ALS ADC value is stored in two adjacent registers:
> + *   - low byte of the channel output is stored at AL3320A_REG_DATA_LOW
> + *   - high byte of channel output is stored at AL3320A_REG_DATA_LOW + 1.
> + *
> + * Return: positive raw ADC reading or negative error code.
> + */
> +static int al3320a_get_adc_value(struct al3320a_data *data)
> +{
> +	return i2c_smbus_read_word_swapped(data->client, AL3320A_REG_DATA_LOW);
> +}
> +
> +static int al3320a_init(struct al3320a_data *data)
> +{
> +	int ret;
> +
> +	/* power on */
> +	ret = al3320a_enable(data);
> +	if (ret)
> +		return ret;
> +
> +	ret = al3320a_set_config_range(data, AL3320A_RANGE_3);
> +	if (ret)
> +		return ret;
> +
> +	ret = al3320a_set_mean_time(data, AL3320A_DEFAULT_MEAN_TIME);
> +	if (ret)
> +		return ret;
> +
> +	ret = al3320a_set_wait_time(data, AL3320A_DEFAULT_WAIT_TIME);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int al3320a_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val,
> +			    int *val2,
> +			    long mask)
Since you don't put a parameter per line in other function, do the same here and save some lines ;-)
> +{
> +	struct al3320a_data *data = iio_priv(indio_dev);
> +	int ret;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		ret = al3320a_get_adc_value(data);
> +		if (ret < 0)
> +			return ret;
> +		*val = ret;
> +		return IIO_VAL_INT;
> +	case IIO_CHAN_INFO_SCALE:
> +		*val = al3320a_scales[data->range][0];
> +		*val2 = al3320a_scales[data->range][1];
> +		return IIO_VAL_INT_PLUS_MICRO;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int al3320a_write_raw(struct iio_dev *indio_dev,
> +			     struct iio_chan_spec const *chan,
> +			     int val, int val2, long mask)
> +{
> +	struct al3320a_data *data = iio_priv(indio_dev);
> +	int i;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_SCALE:
> +		for (i = 0; i < ARRAY_SIZE(al3320a_scales); i++) {
> +			if (val == al3320a_scales[i][0] &&
> +			    val2 == al3320a_scales[i][1])
> +				return al3320a_set_config_range(data, i);
> +		}
> +		break;
> +	}
> +	return -EINVAL;
> +}
> +
> +static const struct iio_info al3320a_info = {
> +	.driver_module	= THIS_MODULE,
> +	.read_raw	= al3320a_read_raw,
> +	.write_raw	= al3320a_write_raw,
> +};
> +
> +static int al3320a_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct al3320a_data *data;
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
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->info = &al3320a_info;
> +	indio_dev->name = AL3320A_DRV_NAME;
> +	indio_dev->channels = al3320a_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(al3320a_channels);
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +
> +	ret = al3320a_init(data);
> +	if (ret) {
> +		dev_err(&client->dev, "al3320a chip init failed\n");
> +		return ret;
> +	}
> +
> +	return devm_iio_device_register(&client->dev, indio_dev);
> +}
> +
> +static int al3320a_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +	struct al3320a_data *data = iio_priv(indio_dev);
> +
> +	return al3320a_disable(data);
> +}
> +
> +static const struct i2c_device_id al3320a_id[] = {
> +	{"al3320a", 0},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, al3320a_id);
> +
> +static struct i2c_driver al3320a_driver = {
> +	.driver = {
> +		.name = AL3320A_DRV_NAME,
> +	},
> +	.probe		= al3320a_probe,
> +	.remove		= al3320a_remove,
> +	.id_table	= al3320a_id,
> +};
> +
> +module_i2c_driver(al3320a_driver);
> +
> +MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com>");
> +MODULE_DESCRIPTION("AL3320A Ambient Light Sensor driver");
> +MODULE_LICENSE("GPL v2");

