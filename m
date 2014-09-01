Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaIARrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:47:45 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46180 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIARrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:47:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1409011935270.24345@pmeerw.net>
References: <1409588330-19188-1-git-send-email-daniel.baluta@intel.com>
	<alpine.DEB.2.01.1409011935270.24345@pmeerw.net>
Date: Mon, 1 Sep 2014 20:47:41 +0300
X-Google-Sender-Auth: -Ps1xvhCrFcqyPvjTWdZR7prnCE
Message-ID: <CAEnQRZBhFFAw3GQmxRZW=-j3uUKXGvUoauy7QUOaxLPQ9kZgSw@mail.gmail.com>
Subject: Re: [PATCH v4] iio: Add Dyna-Image AL3320A ambient light sensor driver
From: Daniel Baluta <daniel.baluta@intel.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tsechih_Lin@asus.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 8:39 PM, Peter Meerwald <pmeerw@pmeerw.net> wrote:
> Hello Daniel,
>
>> Minimal implementation. This driver provides raw illuminance readings.
>>
>> This is based on drivers/hwmon/al3320.c (*) driver from msm tree written
>> by Tsechih Lin <Tsechih_Lin@asus.com>
>>
>> * https://android.googlesource.com/kernel/msm.git
>>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>> ---
>> Changes since v3: (reported by Hartmut and Jonathan)
>>       * dropped the local store for the range, instead read it when necessary
>>       * removed wrapper functions
>>       * added in_illuminance_scale_available attribute
>>       * fix bug when reading raw value, use i2c_smbus_read_word instead of
>>         i2c_smbus_read_word_swapped and fix the endianess after read.
>
> no need to fix endianness
>
>>       * small coding style fixes
>>
>> Changes since v2: (reported by Peter Meerwald)
>>         * removed definition of DATA_HIGH and SW_RESET as they are not used
>>         * added a comment to al3320a_get_adc_value() function
>>         * added thresholds on TODO list
>>         * small style fixes
>>
>> Changes since v1: (reported by Peter Meerwald)
>>         * used u8 instead of int for passing gain and mean_time
>>         * used i2c_smbus_read_word_swapped instead of 2 x i2c_smbus_read_byte_data
>>         * used devm_iio_device_register instead of iio_device_register
>>         * small style fixes
>>
>>
>>  drivers/iio/light/Kconfig   |  10 ++
>>  drivers/iio/light/Makefile  |   1 +
>>  drivers/iio/light/al3320a.c | 229 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 240 insertions(+)
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
>> index 0000000..ad9135a
>> --- /dev/null
>> +++ b/drivers/iio/light/al3320a.c
>> @@ -0,0 +1,229 @@
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
>> + * TODO: interrupt support, thresholds
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/i2c.h>
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
>> +
>> +#define AL3320A_REG_LOW_THRESH_LOW   0x30
>> +#define AL3320A_REG_LOW_THRESH_HIGH  0x31
>> +#define AL3320A_REG_HIGH_THRESH_LOW  0x32
>> +#define AL3320A_REG_HIGH_THRESH_HIGH 0x33
>> +
>> +#define AL3320A_CONFIG_DISABLE               0x00
>> +#define AL3320A_CONFIG_ENABLE                0x01
>> +
>> +#define AL3320A_GAIN_SHIFT           1
>> +
>> +/* chip params default values */
>> +#define AL3320A_DEFAULT_MEAN_TIME    4
>> +#define AL3320A_DEFAULT_WAIT_TIME    0 /* no waiting */
>> +
>> +#define AL3320A_SCALE_AVAILABLE "0.512 0.128 0.032 0.01"
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
>> +};
>> +
>> +static const struct iio_chan_spec al3320a_channels[] = {
>> +     {
>> +             .type   = IIO_LIGHT,
>> +             .info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
>> +                                   BIT(IIO_CHAN_INFO_SCALE),
>> +     }
>> +};
>> +
>> +static IIO_CONST_ATTR(in_illuminance_scale_available, AL3320A_SCALE_AVAILABLE);
>> +
>> +static struct attribute *al3320a_attributes[] = {
>> +     &iio_const_attr_in_illuminance_scale_available.dev_attr.attr,
>> +     NULL,
>> +};
>> +
>> +static const struct attribute_group al3320a_attribute_group = {
>> +     .attrs = al3320a_attributes,
>> +};
>> +
>> +static int al3320a_init(struct al3320a_data *data)
>> +{
>> +     int ret;
>> +
>> +     /* power on */
>> +     ret = i2c_smbus_write_byte_data(data->client, AL3320A_REG_CONFIG,
>> +                                     AL3320A_CONFIG_ENABLE);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     ret = i2c_smbus_write_byte_data(data->client, AL3320A_REG_CONFIG_RANGE,
>> +                                     AL3320A_RANGE_3 << AL3320A_GAIN_SHIFT);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     ret = i2c_smbus_write_byte_data(data->client, AL3320A_REG_MEAN_TIME,
>> +                                     AL3320A_DEFAULT_MEAN_TIME);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     ret = i2c_smbus_write_byte_data(data->client, AL3320A_REG_WAIT,
>> +                                     AL3320A_DEFAULT_WAIT_TIME);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     return 0;
>> +}
>> +
>> +static int al3320a_read_raw(struct iio_dev *indio_dev,
>> +                         struct iio_chan_spec const *chan, int *val,
>> +                         int *val2, long mask)
>> +{
>> +     struct al3320a_data *data = iio_priv(indio_dev);
>> +     int ret;
>> +
>> +     switch (mask) {
>> +     case IIO_CHAN_INFO_RAW:
>> +             /*
>> +              * ALS ADC value is stored in two adjacent registers:
>> +              * - low byte of output is stored at AL3320A_REG_DATA_LOW
>> +              * - high byte of output is stored at AL3320A_REG_DATA_LOW + 1
>> +              */
>> +             ret = i2c_smbus_read_word_data(data->client,
>> +                                            AL3320A_REG_DATA_LOW);
>
> i2c_smbus_read_word_data() must be used if the data is in I2C byte order
> (i.e. LSB first)
>
> i2c_smbus_read_word_swapped() must be used if the data is NOT in I2C byte
> order (i.e. MSB first)
>
> this has nothing to do with CPU byteorder; i2c_smbus_read_word_xxx() will
> take care to report the 16-bit value in native endianness
>
>> +             if (ret < 0)
>> +                     return ret;
>> +             *val = le16_to_cpu((__le16)ret);
>
> so it should be
> *val = ret;
I see. thanks! I will fix this asap.

Daniel.
