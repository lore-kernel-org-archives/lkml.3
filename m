Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaHUP3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:29:48 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:51200 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaHUP3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:29:47 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1408211456410.6001@pmeerw.net>
References: <1408625760-22038-1-git-send-email-daniel.baluta@intel.com>
	<alpine.DEB.2.01.1408211456410.6001@pmeerw.net>
Date: Thu, 21 Aug 2014 18:29:45 +0300
X-Google-Sender-Auth: 0WRs-ir3JRlQwb1_lNQykky-kHM
Message-ID: <CAEnQRZAPkpOpeBdf3OVXjMnTwFreYGJMFzjukpRgMbgHfmq73w@mail.gmail.com>
Subject: Re: [PATCH] iio: Add Dyna-Image AL3320A ambient light sensor driver
From: Daniel Baluta <daniel.baluta@intel.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tsechih_Lin@asus.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 4:04 PM, Peter Meerwald <pmeerw@pmeerw.net> wrote:
>
>> Minimal implementation. This driver provides raw illuminance readings.
>>
>> This is based on drivers/hwmon/al3320.c (*) driver from msm tree written
>> by Tsechih Lin <Tsechih_Lin@asus.com>
>>
>> * https://android.googlesource.com/kernel/msm.git
>>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>
> comments inline below

I addressed most of your comments in v2. See below.

>
>> ---
>>  drivers/iio/light/Kconfig   |  10 ++
>>  drivers/iio/light/Makefile  |   1 +
>>  drivers/iio/light/al3320a.c | 261 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 272 insertions(+)
>>  create mode 100644 drivers/iio/light/al3320a.c
>>
>> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
>> index bf05ca5..5bea821 100644
>> --- a/drivers/iio/light/Kconfig
>> +++ b/drivers/iio/light/Kconfig
>> @@ -17,6 +17,16 @@ config ADJD_S311
>>        This driver can also be built as a module.  If so, the module
>>        will be called adjd_s311.
>>
>> +config AL3320A
>> +     tristate "AL3320A ambient light sensor"
>> +     depends on I2C
>> +     help
>> +      Say Y here if you want to build a driver for the Dyna Image AL3320A
>> +      ambient light sensor.
>> +
>> +      To compile this driver as a module, choose M here: the
>> +      module will be called al3320a.
>> +
>>  config APDS9300
>>       tristate "APDS9300 ambient light sensor"
>>       depends on I2C
>> diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
>> index 8b8c09f..47877a3 100644
>> --- a/drivers/iio/light/Makefile
>> +++ b/drivers/iio/light/Makefile
>> @@ -4,6 +4,7 @@
>>
>>  # When adding new entries keep the list in alphabetical order
>>  obj-$(CONFIG_ADJD_S311)              += adjd_s311.o
>> +obj-$(CONFIG_AL3320A)                += al3320a.o
>>  obj-$(CONFIG_APDS9300)               += apds9300.o
>>  obj-$(CONFIG_CM32181)                += cm32181.o
>>  obj-$(CONFIG_CM36651)                += cm36651.o
>> diff --git a/drivers/iio/light/al3320a.c b/drivers/iio/light/al3320a.c
>> new file mode 100644
>> index 0000000..06ab557
>> --- /dev/null
>> +++ b/drivers/iio/light/al3320a.c
>> @@ -0,0 +1,261 @@
>> +/*
>> + * AL3320A - Dyna Image Ambient Light Sensor
>> + *
>> + * Copyright (c) 2014, Intel Corporation.
>> + *
>> + * This file is subject to the terms and conditions of version 2 of
>> + * the GNU General Public License.  See the file COPYING in the main
>> + * directory of this archive for more details.
>> + *
>> + * IIO driver for AL3320A (7-bit I2C slave address 0x1C).
>> + *
>> + * TODO: interrupt support
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/i2c.h>
>> +#include <linux/mutex.h>
>> +
>> +#include <linux/iio/iio.h>
>> +#include <linux/iio/sysfs.h>
>> +
>> +#define AL3320A_DRV_NAME "al3320a"
>> +
>> +#define AL3320A_REG_CONFIG           0x00
>> +#define AL3320A_REG_STATUS           0x01
>> +#define AL3320A_REG_INT                      0x02
>> +#define AL3320A_REG_WAIT             0x06
>> +#define AL3320A_REG_CONFIG_RANGE     0x07
>> +#define AL3320A_REG_PERSIST          0x08
>> +#define AL3320A_REG_MEAN_TIME                0x09
>> +#define AL3320A_REG_ADUMMY           0x0A
>> +#define AL3320A_REG_DATA_LOW         0x22
>> +#define AL3320A_REG_DATA_HIGH                0x23
>> +
>> +#define AL3320A_REG_LOW_THRESH_LOW   0x30
>> +#define AL3320A_REG_LOW_THRESH_HIGH  0x31
>> +#define AL3320A_REG_HIGH_THRESH_LOW  0x32
>> +#define AL3320A_REG_HIGH_THRESH_HIGH 0x33
>> +
>> +#define AL3320A_CONFIG_DISABLE               0x00
>> +#define AL3320A_CONFIG_ENABLE                BIT(0)
>> +#define AL3320A_CONFIG_SW_RESET              BIT(2)
>> +
>> +#define AL3320A_GAIN_SHIFT           1
>> +
>> +/* chip params default values */
>> +#define AL3320A_DEFAULT_MEAN_TIME    4
>> +#define AL3320A_DEFAULT_WAIT_TIME    0 /* no waiting */
>> +
>> +enum al3320a_range {
>> +     AL3320A_RANGE_1, /* 33.28K lux */
>> +     AL3320A_RANGE_2, /* 8.32K lux  */
>> +     AL3320A_RANGE_3, /* 2.08K lux  */
>> +     AL3320A_RANGE_4  /* 0.65K lux  */
>> +};
>> +
>> +static const int al3320a_scales[][2] = {
>> +     {0, 512000}, {0, 128000}, {0, 32000}, {0, 10000}
>> +};
>> +
>> +struct al3320a_data {
>> +     struct i2c_client *client;
>> +     u8 range;
>> +};
>> +
>> +static const struct iio_chan_spec al3320a_channels[] = {
>> +     {
>> +             .type   = IIO_LIGHT,
>> +             .info_mask_separate =
>> +                     BIT(IIO_CHAN_INFO_RAW) |
>> +                     BIT(IIO_CHAN_INFO_SCALE),
>> +     }
>> +};
>> +
>
> not sure if the minimal function below add to clarity or not...

For the moment I think its good to leave them like that.

> the datatype for gain, mean_time, etc. could be u8
Good point. Changed them in v2.

>
>> +static int al3320a_enable(struct al3320a_data *data)
>> +{
>> +     return i2c_smbus_write_byte_data(data->client, AL3320A_REG_CONFIG,
>> +                                      AL3320A_CONFIG_ENABLE);
>> +}
>> +
>> +static int al3320a_disable(struct al3320a_data *data)
>> +{
>> +     return i2c_smbus_write_byte_data(data->client, AL3320A_REG_CONFIG,
>> +                                      AL3320A_CONFIG_DISABLE);
>> +}
>> +
>> +static int al3320a_set_config_range(struct al3320a_data *data, int gain)
>> +{
>> +     data->range = gain;
>> +
>> +     return i2c_smbus_write_byte_data(data->client, AL3320A_REG_CONFIG_RANGE,
>> +                                      gain << AL3320A_GAIN_SHIFT);
>> +}
>> +
>> +static int al3320a_set_mean_time(struct al3320a_data *data, int mean_time)
>> +{
>> +     return i2c_smbus_write_byte_data(data->client, AL3320A_REG_MEAN_TIME,
>> +                                      mean_time);
>> +}
>> +
>> +static int al3320a_set_wait_time(struct al3320a_data *data, int wait_time)
>> +{
>> +     return i2c_smbus_write_byte_data(data->client, AL3320A_REG_WAIT,
>> +                                      wait_time);
>> +}
>> +
>> +static int al3320a_get_adc_value(struct al3320a_data *data)
>> +{
>> +     unsigned int low, high;
>> +
>
> could use a single i2c_smbus_read_word_swapped() instead of this function

I've changed this in v2 and it seems to be fine. My only concern is
the following comment
from datasheet:

The upper byte data registers can be read after a read to the lower
byte register. When the lower byte register is
read, the upper byte is stored in a temporary register and read after
the lower byte register. By storing the upper byte in
the temporary register as the lower byte is read, the correct value
will be read even if the data register has been updated
to the next value.

>
>> +     high = i2c_smbus_read_byte_data(data->client, AL3320A_REG_DATA_HIGH);
>> +     if (high < 0)
>> +             return high;
>> +
>> +     low = i2c_smbus_read_byte_data(data->client, AL3320A_REG_DATA_LOW);
>> +     if (low < 0)
>> +             return low;
>> +     return (high << 8) | low;
>> +}
>> +
>> +static int al3320a_init(struct al3320a_data *data)
>> +{
>> +     int ret;
>> +
>> +     /*  power on */
>
> extra space before power

Fixed in v2.

>
>> +     ret = al3320a_enable(data);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = al3320a_set_config_range(data, AL3320A_RANGE_3);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = al3320a_set_mean_time(data, AL3320A_DEFAULT_MEAN_TIME);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = al3320a_set_wait_time(data, AL3320A_DEFAULT_WAIT_TIME);
>> +     if (ret)
>> +             return ret;
>> +
>> +     return 0;
>> +}
>> +
>> +static int al3320a_read_raw(struct iio_dev *indio_dev,
>> +                         struct iio_chan_spec const *chan,
>> +                         int *val,
>> +                         int *val2,
>> +                         long mask)
>> +{
>> +     struct al3320a_data *data = iio_priv(indio_dev);
>> +     int ret;
>> +
>> +     switch (mask) {
>> +     case IIO_CHAN_INFO_RAW:
>> +             ret = al3320a_get_adc_value(data);
>> +             if (ret < 0)
>> +                     return ret;
>> +             *val = ret;
>> +             return IIO_VAL_INT;
>> +     case IIO_CHAN_INFO_SCALE:
>> +             *val = al3320a_scales[data->range][0];
>> +             *val2 = al3320a_scales[data->range][1];
>> +             return IIO_VAL_INT_PLUS_MICRO;
>> +     }
>> +     return -EINVAL;
>> +}
>> +
>> +static int al3320a_write_raw(struct iio_dev *indio_dev,
>> +                          struct iio_chan_spec const *chan,
>> +                          int val, int val2, long mask)
>> +{
>> +     struct al3320a_data *data = iio_priv(indio_dev);
>> +     int i;
>> +
>> +     switch (mask) {
>> +     case IIO_CHAN_INFO_SCALE:
>> +             for (i = 0; i < ARRAY_SIZE(al3320a_scales); i++) {
>> +                     if (val == al3320a_scales[i][0] &&
>> +                         val2 == al3320a_scales[i][1]) {
>> +                             data->range = i;
>
> strictly, should try to write the range value and only on success update
> data->range
>
> data->range is also set in _set_config_range(), done twice!
Correct. I removed the assignment above in v2.
>
>> +                             return al3320a_set_config_range(data, i);
>> +                     }
>> +             }
>> +     }
>> +     return -EINVAL;
>> +}
>> +
>> +static const struct iio_info al3320a_info = {
>> +     .driver_module  = THIS_MODULE,
>> +     .read_raw       = al3320a_read_raw,
>> +     .write_raw      = al3320a_write_raw,
>> +};
>> +
>> +static int al3320a_probe(struct i2c_client *client,
>> +                      const struct i2c_device_id *id)
>> +{
>> +     struct al3320a_data *data;
>> +     struct iio_dev *indio_dev;
>> +     int ret;
>> +
>> +     indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
>> +     if (!indio_dev)
>> +             return -ENOMEM;
>> +
>> +     data = iio_priv(indio_dev);
>> +     i2c_set_clientdata(client, indio_dev);
>> +     data->client = client;
>> +
>> +     indio_dev->dev.parent = &client->dev;
>> +     indio_dev->info = &al3320a_info;
>> +     indio_dev->name = AL3320A_DRV_NAME;
>> +     indio_dev->channels = al3320a_channels;
>> +     indio_dev->num_channels = ARRAY_SIZE(al3320a_channels);
>> +     indio_dev->modes = INDIO_DIRECT_MODE;
>> +
>> +     ret = al3320a_init(data);
>> +
>
> remove extra newline?
ok. changed in v2.
>
>> +     if (ret < 0)
>
> all the check in _init() are
> if (ret) return ret;
> but here you check ret < 0
>
>> +             return ret;
>> +
>> +     return iio_device_register(indio_dev);
>
> devm_iio_device_register...?
Yes. This also simplifies the .remove function.
>
>> +}
>> +
>> +static int al3320a_remove(struct i2c_client *client)
>> +{
>> +     struct iio_dev *indio_dev = i2c_get_clientdata(client);
>> +     struct al3320a_data *data = iio_priv(indio_dev);
>> +     int ret;
>> +
>> +     iio_device_unregister(indio_dev);
>> +
>> +     ret = al3320a_disable(data);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct i2c_device_id al3320a_id[] = {
>> +     {"al3320a", 0},
>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, al3320a_id);
>> +
>> +static struct i2c_driver al3320a_driver = {
>> +     .driver = {
>> +             .name = AL3320A_DRV_NAME,
>> +     },
>> +     .probe          = al3320a_probe,
>> +     .remove         = al3320a_remove,
>> +     .id_table       = al3320a_id,
>> +};
>> +
>> +module_i2c_driver(al3320a_driver);
>> +
>> +MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com>");
>> +MODULE_DESCRIPTION("AL3320A Ambient Light Sensor driver");
>> +MODULE_LICENSE("GPL v2");
>>
>
> --
>
> Peter Meerwald

Thanks for review Peter!

Daniel.
