Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaIRTDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:03:54 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:38902 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaIRTDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:03:53 -0400
Date: Thu, 18 Sep 2014 21:03:51 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: David Barksdale <dbarksdale@uplogix.com>
cc: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH] IIO: add si701x driver
In-Reply-To: <541B2AB8.7020308@uplogix.com>
Message-ID: <alpine.DEB.2.01.1409182100150.30983@pmeerw.net>
References: <1411056475-22283-1-git-send-email-dbarksdale@uplogix.com> <alpine.DEB.2.01.1409181926001.30983@pmeerw.net> <541B2AB8.7020308@uplogix.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > This patch adds support to the Industrial IO subsystem
> > > for the Silicon Labs Si701x/2x Relative Humidity and
> > > Temperature Sensors.
> > 
> > the name si701x is problematic; the si7015 for example is supported by
> > the si7005 driver
> > 
> > how about calling the driver si7020 and stating that it also supports
> > si7013, si7021 -- the x notation in driver names always leads to touble...
> 
> Sounds good.
> 
> > the additional features of the si7013 are not supported by the driver
> > 
> > > Website:
> > > http://www.silabs.com/products/sensors/humidity-sensors/Pages/si7013-20-21.aspx
> > > 
> > > These are i2c devices which measure relative humidity
> > > and temperature and all use the same protocol. The
> > > Si7013 has an additional input with programmable
> > > linearization which is not supported because that's
> > > complicated and I didn't need it.
> > > 
> > > Signed-off-by: David Barksdale <dbarksdale@uplogix.com>
> > > 
> > > ---
> > >   drivers/iio/humidity/Kconfig  |  10 +++
> > >   drivers/iio/humidity/Makefile |   1 +
> > >   drivers/iio/humidity/si701x.c | 159
> > > ++++++++++++++++++++++++++++++++++++++++++
> > >   3 files changed, 170 insertions(+)
> > > 
> > > diff --git a/drivers/iio/humidity/Kconfig b/drivers/iio/humidity/Kconfig
> > > index e116bd8..ba0ef61 100644
> > > --- a/drivers/iio/humidity/Kconfig
> > > +++ b/drivers/iio/humidity/Kconfig
> > > @@ -22,4 +22,14 @@ config SI7005
> > >   	  To compile this driver as a module, choose M here: the module
> > >   	  will be called si7005.
> > > 
> > > +config SI701X
> > > +	tristate "Si701x/2x Relative Humidity and Temperature Sensors"
> > > +	depends on I2C
> > > +	help
> > > +	  Say yes here to build support for the Silicon Labs Si701x/2x
> > > Relative
> > > +	  Humidity and Temperature Sensors.
> > > +
> > > +	  To compile this driver as a module, choose M here: the module
> > > +	  will be called si701x.
> > > +
> > >   endmenu
> > > diff --git a/drivers/iio/humidity/Makefile b/drivers/iio/humidity/Makefile
> > > index e3f3d94..d2e9645 100644
> > > --- a/drivers/iio/humidity/Makefile
> > > +++ b/drivers/iio/humidity/Makefile
> > > @@ -4,3 +4,4 @@
> > > 
> > >   obj-$(CONFIG_DHT11) += dht11.o
> > >   obj-$(CONFIG_SI7005) += si7005.o
> > > +obj-$(CONFIG_SI701X) += si701x.o
> > > diff --git a/drivers/iio/humidity/si701x.c b/drivers/iio/humidity/si701x.c
> > > new file mode 100644
> > > index 0000000..1a2ee22
> > > --- /dev/null
> > > +++ b/drivers/iio/humidity/si701x.c
> > > @@ -0,0 +1,159 @@
> > > +/*
> > > + * si701x.c - Silicon Labs Si701x/2x Relative Humidity and Temperature
> > > Sensors
> > > + * Copyright (c) 2013,2014  Uplogix, Inc.
> > > + * David Barksdale <dbarksdale@uplogix.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > it
> > > + * under the terms and conditions of the GNU General Public License,
> > > + * version 2, as published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +/*
> > > + * The Silicon Labs Si701x/2x Relative Humidity and Temperature Sensors
> > > + * are i2c devices which have an identical programming interface for
> > > + * measuring relative humidity and temperature. The Si7013 has an
> > > additional
> > > + * temperature input which this driver does not support.
> > > + *
> > > + * Data Sheets:
> > > + *   Si7013:
> > > http://www.silabs.com/Support%20Documents/TechnicalDocs/Si7013.pdf
> > > + *   Si7020:
> > > http://www.silabs.com/Support%20Documents/TechnicalDocs/Si7020.pdf
> > > + *   Si7021:
> > > http://www.silabs.com/Support%20Documents/TechnicalDocs/Si7021.pdf
> > > + */
> > > +
> > > +#include <linux/i2c.h>
> > > +#include <linux/module.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/sysfs.h>
> > > +
> > > +#include <linux/iio/iio.h>
> > > +#include <linux/iio/sysfs.h>
> > > +
> > > +enum {
> > > +	/* Measure Relative Humidity, Hold Master Mode */
> > > +	SI701XCMD_RH_HOLD	= 0xE5,
> > > +	/* Measure Temperature, Hold Master Mode */
> > > +	SI701XCMD_TEMP_HOLD	= 0xE3,
> > > +};
> > > +
> > > +struct si701x_data {
> > > +	struct i2c_client *client;
> > > +	struct mutex lock;
> > > +};
> > > +
> > > +static int si701x_read_raw(struct iio_dev *indio_dev,
> > > +			   struct iio_chan_spec const *chan, int *val,
> > > +			   int *val2, long mask)
> > > +{
> > > +	struct si701x_data *data = iio_priv(indio_dev);
> > > +	int ret;
> > > +
> > > +	switch (mask) {
> > > +	case IIO_CHAN_INFO_RAW:
> > > +		mutex_lock(&data->lock);
> > 
> > is the locking needed? what is protected?
> 
> I copied this from the si7005 driver. I assumed because calls to read_raw were
> not serialized and calls to i2c_smbus_read_word_data on the same client need
> to be serialized.

reading the si7005 is totally different:
start conversion, wait for completion, read data -- this sequence must not 
be interrupted, hence the lock
 
> > > +		ret = i2c_smbus_read_word_data(data->client,
> > > +					       chan->type == IIO_TEMP ?
> > > +					       SI701XCMD_TEMP_HOLD :
> > > +					       SI701XCMD_RH_HOLD);
> > > +		mutex_unlock(&data->lock);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +		*val = ret;
> > > +		return IIO_VAL_INT;
> > > +	case IIO_CHAN_INFO_SCALE:
> > > +		if (chan->type == IIO_TEMP) {
> > > +			*val = 175.72 * 1000;
> > 
> > floating-point constants in kernel space makes me nervous
> > 
> 
> I was trying to make this easy to compare to constants that appear in the data
> sheets: 175.72, 125, 65536, -6, and -46.85. I figured the compiler would
> transform them to integers, but I suppose that's not a great assumption. I'll
> precompute them and explain them in a comment.
> 
> > > +			*val2 = 65536;
> > 
> > could set val2 once after the if
> > 
> > > +		} else {
> > > +			*val = 125 * 1000;
> > > +			*val2 = 65536;
> > > +		}
> > > +		return IIO_VAL_FRACTIONAL;
> > > +	case IIO_CHAN_INFO_OFFSET:
> > > +		if (chan->type == IIO_TEMP)
> > > +			*val = -46.85 * 65536 / 175.72;
> > > +		else
> > > +			*val = -6 * 65536 / 125;
> > > +		return IIO_VAL_INT;
> > > +	default:
> > > +		break;
> > > +	}
> > > +
> > > +	return -EINVAL;
> > > +}
> > > +
> > > +static const struct iio_chan_spec si701x_channels[] = {
> > > +	{
> > > +		.type = IIO_HUMIDITYRELATIVE,
> > > +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> > > +			BIT(IIO_CHAN_INFO_SCALE) | BIT(IIO_CHAN_INFO_OFFSET),
> > > +	},
> > > +	{
> > > +		.type = IIO_TEMP,
> > > +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> > > +			BIT(IIO_CHAN_INFO_SCALE) | BIT(IIO_CHAN_INFO_OFFSET),
> > > +	}
> > > +};
> > > +
> > > +static const struct iio_info si701x_info = {
> > > +	.read_raw = si701x_read_raw,
> > > +	.driver_module = THIS_MODULE,
> > > +};
> > > +
> > > +static int si701x_probe(struct i2c_client *client,
> > > +			const struct i2c_device_id *id)
> > > +{
> > > +	struct iio_dev *dev;
> > > +	struct si701x_data *data;
> > > +
> > > +	if (!i2c_check_functionality(client->adapter,
> > > I2C_FUNC_SMBUS_WORD_DATA))
> > > +		return -ENODEV;
> > > +
> > > +	dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
> > > +	if (!dev)
> > > +		return -ENOMEM;
> > > +
> > > +	data = iio_priv(dev);
> > > +	i2c_set_clientdata(client, dev);
> > > +	data->client = client;
> > > +	mutex_init(&data->lock);
> > > +
> > > +	dev->dev.parent = &client->dev;
> > > +	dev->name = dev_name(&client->dev);
> > > +	dev->modes = INDIO_DIRECT_MODE;
> > > +	dev->info = &si701x_info;
> > > +	dev->channels = si701x_channels;
> > > +	dev->num_channels = ARRAY_SIZE(si701x_channels);
> > > +
> > > +	return devm_iio_device_register(&client->dev, dev);
> > > +}
> > > +
> > > +static const unsigned short si701x_address_list[] = {
> > > +	0x40,
> > 
> > the alternate address is 0x41
> > 
> 
> Thanks.
> 
> > > +	I2C_CLIENT_END
> > > +};
> > > +
> > > +static const struct i2c_device_id si701x_id[] = {
> > > +	{ "si701x", 0 },
> > > +	{ }
> > > +};
> > > +MODULE_DEVICE_TABLE(i2c, si701x_id);
> > > +
> > > +static struct i2c_driver si701x_driver = {
> > > +	.class		= I2C_CLASS_HWMON,
> > > +	.driver.name	= "si701x",
> > > +	.probe		= si701x_probe,
> > > +	.address_list	= si701x_address_list,
> > > +	.id_table	= si701x_id,
> > 
> > address_list and I2C_CLASS_HWMON -- what for?
> > 
> > if doing auto-probing, I'd check the chip's ID
> > 
> 
> Oops. This was originally an hwmon driver but I ported it to iio when I saw
> that's where si7005 landed.

IIO drivers usually don't fill the I2C address list

> 
> > > +};
> > > +
> > > +module_i2c_driver(si701x_driver);
> > > +MODULE_DESCRIPTION("Silicon Labs Si701x/2x "
> > > +		   "Relative Humidity and Temperature Sensors");
> > > +MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
> > > +MODULE_LICENSE("GPL");
> > > +
> > > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 

Peter Meerwald
+43-664-2444418 (mobile)
