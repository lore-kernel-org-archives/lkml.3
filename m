Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3GOM1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:27:19 -0400
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:51743 "EHLO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3GOM1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:27:17 -0400
MIME-Version: 1.0
In-Reply-To: <51E03720.1010806@metafoo.de>
References: <1373461729-11261-1-git-send-email-x0199363@ti.com>
	<51E03720.1010806@metafoo.de>
Date: Mon, 15 Jul 2013 15:27:16 +0300
Message-ID: <CAGH3drqEPxW=QwadCLj=ZOQe0gp_c7mdSiNQnq1_-BMKL9CgJw@mail.gmail.com>
Subject: Re: [PATCH] iio: add APDS9300 ambilent light sensor driver
From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Oleksandr Kravchenko <x0199363@ti.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        jic23@cam.ac.uk, pmeerw@pmeerw.net, holler@ahsoftware.de,
        srinivas.pandruvada@intel.com, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for review! But I don't completely understand one of your comment:

>> +static int als_probe(struct i2c_client *client, const struct i2c_device_id *id)
[...]
>> +     if (client->irq) {
>> +             ret = devm_request_threaded_irq(&client->dev, client->irq,
>> +                             NULL, als_interrupt_handler,
>> +                             IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +                             ALS_IRQ_NAME, indio_dev);
>
> This is a bit racy, you access memory in the irq handler that is freed
> before the irq is freed.

Do you mean than that indio_dev may be used in interrupt handler after
iio_device_free(indio_dev) called in als_remove() function?

If so, can I use disable_irq() in als_remove() before iio_device_free()
to avoid this problem?

On Fri, Jul 12, 2013 at 8:04 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 07/10/2013 03:08 PM, Oleksandr Kravchenko wrote:
>> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
>>
>> This patch adds IIO driver for APDS9300 ambilent light sensor (ALS).
>
> s/ambilent/ambient/
>
>> http://www.avagotech.com/docs/AV02-1077EN
>>
>> The driver allows to read raw data from ADC registers or calculate
>> lux value. It also can handle threshold inrerrupt.
>
> s/inrerrupt/interrupt/
>
> The patch looks very good in general, a couple of comment inline.
>
>>
>> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
>> ---
>>  .../devicetree/bindings/iio/light/apds9300.txt     |   22 +
>>  drivers/iio/light/Kconfig                          |   10 +
>>  drivers/iio/light/Makefile                         |    1 +
>>  drivers/iio/light/apds9300.c                       |  528 ++++++++++++++++++++
>>  4 files changed, 561 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/iio/light/apds9300.txt
>>  create mode 100644 drivers/iio/light/apds9300.c
>>
>> diff --git a/Documentation/devicetree/bindings/iio/light/apds9300.txt b/Documentation/devicetree/bindings/iio/light/apds9300.txt
>> new file mode 100644
>> index 0000000..d6f66c7
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/light/apds9300.txt
>> @@ -0,0 +1,22 @@
>> +* Avago APDS9300 ambient light sensor
>> +
>> +http://www.avagotech.com/docs/AV02-1077EN
>> +
>> +Required properties:
>> +
>> +  - compatible : should be "avago,apds9300"
>
> You should also add the avago vendor prefix to
> Documentation/devicetree/bindings/vendor-prefixes.txt. Preferably in a
> separate patch.
>
>> +  - reg : the I2C address of the sensor
>> +
>> +Optional properties:
>> +
>> +  - interrupt-parent : should be the phandle for the interrupt controller
>> +  - interrupts : interrupt mapping for GPIO IRQ
>> +
>> +Example:
>> +
>> +apds9300@39 {
>> +     compatible = "avago,apds9300";
>> +     reg = <0x39>;
>> +     interrupt-parent = <&gpio2>;
>> +     interrupts = <29 8>;
>> +};
>> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
>> index 5ef1a39..08a6742 100644
>> --- a/drivers/iio/light/Kconfig
>> +++ b/drivers/iio/light/Kconfig
>> @@ -52,6 +52,16 @@ config VCNL4000
>>        To compile this driver as a module, choose M here: the
>>        module will be called vcnl4000.
>>
>> +config APDS9300
>> +     tristate "APDS9300 ambient light sensor"
>> +     depends on I2C
>> +     help
>> +      Say Y here if you want to build a driver for the Avago APDS9300
>> +      ambient light sensor.
>> +
>> +      To compile this driver as a module, choose M here: the
>> +      module will be called apds9300.
>> +
>
> Keeps this in alphabetical order
>
>>  config HID_SENSOR_ALS
>>       depends on HID_SENSOR_HUB
>>       select IIO_BUFFER
>> diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
>> index 040d9c7..da58e12 100644
>> --- a/drivers/iio/light/Makefile
>> +++ b/drivers/iio/light/Makefile
>> @@ -6,4 +6,5 @@ obj-$(CONFIG_ADJD_S311)               += adjd_s311.o
>>  obj-$(CONFIG_SENSORS_LM3533) += lm3533-als.o
>>  obj-$(CONFIG_SENSORS_TSL2563)        += tsl2563.o
>>  obj-$(CONFIG_VCNL4000)               += vcnl4000.o
>> +obj-$(CONFIG_APDS9300)               += apds9300.o
>
> Same here
>
>>  obj-$(CONFIG_HID_SENSOR_ALS) += hid-sensor-als.o
>> diff --git a/drivers/iio/light/apds9300.c b/drivers/iio/light/apds9300.c
>> new file mode 100644
>> index 0000000..2275ecc
>> --- /dev/null
>> +++ b/drivers/iio/light/apds9300.c
>> @@ -0,0 +1,528 @@
>> +/*
>> + * apds9300.c - IIO driver for Avago APDS9300 ambient light sensor
>> + *
>> + * Copyright 2013 Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
>> + *
>> + * This file is subject to the terms and conditions of version 2 of
>> + * the GNU General Public License.  See the file COPYING in the main
>> + * directory of this archive for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/pm.h>
>> +#include <linux/i2c.h>
>> +#include <linux/err.h>
>> +#include <linux/mutex.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>
> No device driver should ever need to include irq.h
>
>> +#include <linux/iio/iio.h>
>> +#include <linux/iio/sysfs.h>
>> +#include <linux/iio/events.h>
>> +
> [...]
>> +
>> +static unsigned long als_calculate_lux(u16 ch0, u16 ch1)
>> +{
>> +     unsigned long lux, tmp;
>> +     u64 tmp64;
>> +
>> +     /* avoid division by zero */
>> +     if (ch0 == 0)
>> +             return 0;
>> +
>> +     tmp = ch1 * 100 / ch0;
>> +     if (tmp <= 52) {
>> +             /*
>> +              * Variable tmp64 need to avoid overflow of this part of lux
>> +              * calculation formula.
>> +              */
>
> If you want to avoid the overflow you have to do the math as 64bit math. As
> it is right now it will do 32bit math and only store the result in a 64 bit
> variable.
>
>> +             tmp64 = ch0 * lux_ratio[tmp] * 5930 / 1000;
>> +             lux = 3150 * ch0 - (unsigned long)tmp64;
>> +     }
>> +     else if (tmp <= 65)
>> +             lux = 2290 * ch0 - 2910 * ch1;
>> +     else if (tmp <= 80)
>> +             lux = 1570 * ch0 - 1800 * ch1;
>> +     else if (tmp <= 130)
>> +             lux = 338 * ch0 - 260 * ch1;
>> +     else
>> +             lux = 0;
>> +
>> +     return lux / 100000;
>> +}
>> +
> [...]
>> +static int als_get_adc_val(struct als_data *data, int adc_number)
>> +{
>> +     int ret;
>> +     u8 flags = ALS_CMD | ALS_WORD;
>> +
>> +     if (!data->power_state)
>> +             return -EAGAIN;
>
> EAGAIN is probably not the right error code, maybe EBUSY or ENODEV.
>
>> +
>> +     /* Select ADC0 or ADC1 data register */
>> +     flags |= adc_number ? ALS_DATA1LOW : ALS_DATA0LOW;
>> +
>> +     ret = i2c_smbus_read_word_data(data->client, flags);
>> +     if (ret < 0)
>> +             dev_err(&data->client->dev,
>> +                             "failed to read ADC%d value\n", adc_number);
>> +
>> +     return ret;
>> +}
>> +
> [...]
>
>> +static irqreturn_t als_interrupt_handler(int irq, void *private)
>> +{
>> +     struct iio_dev *dev_info = private;
>> +     struct als_data *data = iio_priv(dev_info);
>> +
>> +     iio_push_event(dev_info,
>> +                     IIO_UNMOD_EVENT_CODE(IIO_INTENSITY, 0,
>> +                             IIO_EV_TYPE_THRESH,
>> +                             IIO_EV_DIR_FALLING),
>> +                     iio_get_time_ns());
>
> In the event mask you specify support for both falling and rising threshold
> events, yet the only event ever triggered is a falling event.
>
>> +
>> +     als_clear_intr(data);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +/* Probe/remove functions */
>
> I don't think we need the comment to know that als_probe is the probe
> function ;)
>
>> +
>> +static int als_probe(struct i2c_client *client, const struct i2c_device_id *id)
>> +{
>> +     struct als_data *data;
>> +     struct iio_dev *indio_dev;
>> +     int ret;
>> +
>> +     indio_dev = iio_device_alloc(sizeof(*data));
>> +     if (!indio_dev)
>> +             return -ENOMEM;
>> +
>> +     data = iio_priv(indio_dev);
>> +     i2c_set_clientdata(client, indio_dev);
>> +     data->client = client;
>> +
>> +     ret = als_chip_init(data);
>> +     if (ret < 0)
>> +             goto err;
>> +
>> +     mutex_init(&data->mutex);
>> +
>> +     indio_dev->dev.parent = &client->dev;
>> +     indio_dev->channels = als_channels;
>> +     indio_dev->num_channels = ARRAY_SIZE(als_channels);
>> +     indio_dev->name = ALS_DRV_NAME;
>> +     indio_dev->modes = INDIO_DIRECT_MODE;
>> +
>> +     if (client->irq)
>> +             indio_dev->info = &als_info;
>> +     else
>> +             indio_dev->info = &als_info_no_irq;
>> +
>> +     if (client->irq) {
>> +             ret = devm_request_threaded_irq(&client->dev, client->irq,
>> +                             NULL, als_interrupt_handler,
>> +                             IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +                             ALS_IRQ_NAME, indio_dev);
>
> This is a bit racy, you access memory in the irq handler that is freed
> before the irq is freed.
>
>> +             if (ret) {
>> +                     dev_err(&client->dev, "irq request error %d\n", -ret);
>> +                     goto err;
>> +             }
>> +     }
>> +
>> +     ret = iio_device_register(indio_dev);
>> +     if (ret < 0)
>> +             goto err;
>> +
>> +     dev_info(&client->dev, "ambient light sensor\n");
>
> This line is just noise in the bootlog, please remove it.
>
>> +
>> +     return 0;
>> +
>> +err:
>> +     /* Ensure that power off in case of error */
>> +     als_set_power_state(data, 0);
>> +     iio_device_free(indio_dev);
>> +     return ret;
>> +}
>> +
>> +static int als_remove(struct i2c_client *client)
>> +{
>> +     struct iio_dev *indio_dev = i2c_get_clientdata(client);
>> +     struct als_data *data = iio_priv(indio_dev);
>> +     int ret;
>> +
>> +     iio_device_unregister(indio_dev);
>> +
>> +     /* Ensure that power off and interrupts are disabled */
>> +     ret = als_set_intr_state(data, 0);
>> +     if (!ret)
>> +             ret = als_set_power_state(data, 0);
>> +
>> +     iio_device_free(indio_dev);
>> +
>> +     return ret;
>
> The remove callback must always return 0.
>
>> +}
> [...]
>



-- 
Oleksandr Kravchenko
GlobalLogic
P +380633213187
P +380994930248
www.globallogic.com

http://www.globallogic.com/email_disclaimer.txt
