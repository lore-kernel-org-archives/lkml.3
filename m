Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaIJEy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:54:29 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51341 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaIJEy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:54:26 -0400
MIME-Version: 1.0
In-Reply-To: <540F7A13.4030802@gmx.de>
References: <1410163999-26703-1-git-send-email-daniel.baluta@intel.com>
	<540F7A13.4030802@gmx.de>
Date: Wed, 10 Sep 2014 07:54:24 +0300
X-Google-Sender-Auth: pfJJQ2fIBy-jJofxkiLqUDWNXSU
Message-ID: <CAEnQRZC3=P793sMqtoWS7QmAmrvNxaXUVD8mOYTFh6_m5rg4xw@mail.gmail.com>
Subject: Re: [PATCH v6] iio: Add Dyna-Image AL3320A ambient light sensor driver
From: Daniel Baluta <daniel.baluta@intel.com>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tsechih_Lin@asus.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 1:07 AM, Hartmut Knaack <knaack.h@gmx.de> wrote:
> Daniel Baluta schrieb, Am 08.09.2014 10:13:
>> Minimal implementation. This driver provides raw illuminance readings.
>>
>> This is based on drivers/hwmon/al3320.c (*) driver from msm tree written
>> by Tsechih Lin <Tsechih_Lin@asus.com>
>>
>> * https://android.googlesource.com/kernel/msm.git
>>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>> ---
>>
>> Changes since v5: (reported by Hartmut)
>>       * fix comments for al3320a_range
>>       * make sure we always use a valid index in al3320a_scales
>>
>> Changes since v4: (reported by Peter)
>>       * no need to fix endianess when reading raw value
>>
>> Changes since v3: (reported by Hartmut and Jonathan)
>>         * dropped the local store for the range, instead read it when necessary
>>         * removed wrapper functions
>>         * added in_illuminance_scale_available attribute
>>         * fix bug when reading raw value, use i2c_smbus_read_word instead of
>>           i2c_smbus_read_word_swapped and fix the endianess after read.
>>         * small coding style fixes
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
>>  drivers/iio/light/Kconfig   |  10 ++
>>  drivers/iio/light/Makefile  |   1 +
>>  drivers/iio/light/al3320a.c | 232 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 243 insertions(+)
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
>> index 0000000..bc6d670
>> --- /dev/null
>> +++ b/drivers/iio/light/al3320a.c
>> @@ -0,0 +1,232 @@
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
>> +#define AL3320A_GAIN_MASK            (BIT(2) | BIT(1))
>> +
>> +/* chip params default values */
>> +#define AL3320A_DEFAULT_MEAN_TIME    4
>> +#define AL3320A_DEFAULT_WAIT_TIME    0 /* no waiting */
>> +
>> +#define AL3320A_SCALE_AVAILABLE "0.512 0.128 0.032 0.01"
>> +
>> +enum al3320a_range {
>> +     AL3320A_RANGE_1, /* 33.28 Klx */
>> +     AL3320A_RANGE_2, /* 8.32 Klx  */
>> +     AL3320A_RANGE_3, /* 2.08 Klx  */
>> +     AL3320A_RANGE_4  /* 0.65 Klx  */
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
>> +     int ret, i;
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
>> +             if (ret < 0)
>> +                     return ret;
>> +             *val = ret;
>> +             return IIO_VAL_INT;
>> +     case IIO_CHAN_INFO_SCALE:
>> +             ret = i2c_smbus_read_byte_data(data->client,
>> +                                            AL3320A_REG_CONFIG_RANGE);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             i = (ret & AL3320A_GAIN_MASK) >> AL3320A_GAIN_SHIFT;
>> +             *val = al3320a_scales[i][0];
>> +             *val2 = al3320a_scales[i][1];
> I think there is no real need to introduce i, as it can be replaced by ret.

I know, but I wanted to make clear it that there is an index.
I will change it in the next version.

thanks,
Daniel.
