Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3GURZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 13:25:00 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58064 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab3GURY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 13:24:58 -0400
Message-ID: <51EC1967.4070500@kernel.org>
Date: Sun, 21 Jul 2013 18:24:55 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleksandr Kravchenko <x0199363@ti.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, jic23@cam.ac.uk,
        pmeerw@pmeerw.net, holler@ahsoftware.de, srinivas.pandruvada@intel.com,
        devicetree-discuss@lists.ozlabs.org, grygorii.strashko@ti.com,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: Re: [PATCH 3/3] iio: add APDS9300 ambilent light sensor driver
References: <1374142766-29736-1-git-send-email-x0199363@ti.com> <1374142766-29736-3-git-send-email-x0199363@ti.com>
In-Reply-To: <1374142766-29736-3-git-send-email-x0199363@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:19 AM, Oleksandr Kravchenko wrote:
> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
>
> This patch adds IIO driver for APDS9300 ambient light sensor (ALS).
> http://www.avagotech.com/docs/AV02-1077EN
>
> The driver allows to read raw data from ADC registers or calculate
> lux value. It also can handle threshold interrupt.
>
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>

Mostly looking very nice, couple of points though.

1) ALS_ is not a specific enough prefix to my mind.  I'd like them
replaced with APDS9300_ for all the defines.  Makes it pretty implausible
that a namespace clash will occur wherase ALS is too generic (as everyone
calls their ambient light sensors that - we even proposed a subsystem
under that name at one point a few years ago)

2) Suspend and resume look to have a bug with getting the wrong type
of pointer.

3) Modifiers for the two intensity channels give more info than simply
channel 0 and channel 1.  If you don't want to use them then argue
against it ;)

Anyhow, not much really so looking forward to the next revision!

Thanks,

Jonathan
> ---
>  .../devicetree/bindings/iio/light/apds9300.txt     |   22 +
>  drivers/iio/light/Kconfig                          |   10 +
>  drivers/iio/light/Makefile                         |    1 +
>  drivers/iio/light/apds9300.c                       |  517 ++++++++++++++++++++
>  4 files changed, 550 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/light/apds9300.txt
>  create mode 100644 drivers/iio/light/apds9300.c
>
> diff --git a/Documentation/devicetree/bindings/iio/light/apds9300.txt b/Documentation/devicetree/bindings/iio/light/apds9300.txt
> new file mode 100644
> index 0000000..d6f66c7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/light/apds9300.txt
> @@ -0,0 +1,22 @@
> +* Avago APDS9300 ambient light sensor
> +
> +http://www.avagotech.com/docs/AV02-1077EN
> +
> +Required properties:
> +
> +  - compatible : should be "avago,apds9300"
> +  - reg : the I2C address of the sensor
> +
> +Optional properties:
> +
> +  - interrupt-parent : should be the phandle for the interrupt controller
> +  - interrupts : interrupt mapping for GPIO IRQ
> +
> +Example:
> +
> +apds9300@39 {
> +	compatible = "avago,apds9300";
> +	reg = <0x39>;
> +	interrupt-parent = <&gpio2>;
> +	interrupts = <29 8>;
> +};
> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
> index 5ef1a39..fb6af1b 100644
> --- a/drivers/iio/light/Kconfig
> +++ b/drivers/iio/light/Kconfig
> @@ -15,6 +15,16 @@ config ADJD_S311
>  	 This driver can also be built as a module.  If so, the module
>  	 will be called adjd_s311.
>
> +config APDS9300
> +	tristate "APDS9300 ambient light sensor"
> +	depends on I2C
> +	help
> +	 Say Y here if you want to build a driver for the Avago APDS9300
> +	 ambient light sensor.
> +
> +	 To compile this driver as a module, choose M here: the
> +	 module will be called apds9300.
> +
>  config SENSORS_LM3533
>  	tristate "LM3533 ambient light sensor"
>  	depends on MFD_LM3533
> diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
> index 040d9c7..da58e12 100644
> --- a/drivers/iio/light/Makefile
> +++ b/drivers/iio/light/Makefile
> @@ -6,4 +6,5 @@ obj-$(CONFIG_ADJD_S311)		+= adjd_s311.o
>  obj-$(CONFIG_SENSORS_LM3533)	+= lm3533-als.o
>  obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>  obj-$(CONFIG_VCNL4000)		+= vcnl4000.o
> +obj-$(CONFIG_APDS9300)		+= apds9300.o
>  obj-$(CONFIG_HID_SENSOR_ALS)	+= hid-sensor-als.o
> diff --git a/drivers/iio/light/apds9300.c b/drivers/iio/light/apds9300.c
> new file mode 100644
> index 0000000..c06a59e
> --- /dev/null
> +++ b/drivers/iio/light/apds9300.c
> @@ -0,0 +1,517 @@
> +/*
> + * apds9300.c - IIO driver for Avago APDS9300 ambient light sensor
> + *
> + * Copyright 2013 Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> + *
> + * This file is subject to the terms and conditions of version 2 of
> + * the GNU General Public License.  See the file COPYING in the main
> + * directory of this archive for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/pm.h>
> +#include <linux/i2c.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/interrupt.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/events.h>
> +
I'm not happy that ALS is sufficient to avoid
possible namespace clashes in future.
Please prefix these with APDS9300_

> +#define ALS_DRV_NAME "apds9300"
> +#define ALS_IRQ_NAME "apds9300_event"
> +
> +/* Command register bits */
> +#define ALS_CMD		BIT(7) /* Select command register. Must write as 1 */
> +#define ALS_WORD	BIT(5) /* I2C write/read: if 1 word, if 0 byte */
> +#define ALS_CLEAR	BIT(6) /* Interrupt clear. Clears pending interrupt */
> +
> +/* Register set */
> +#define ALS_CONTROL		0x00 /* Control of basic functions */
> +#define ALS_THRESHLOWLOW	0x02 /* Low byte of low interrupt threshold */
> +#define ALS_THRESHHIGHLOW	0x04 /* Low byte of high interrupt threshold */
> +#define ALS_INTERRUPT		0x06 /* Interrupt control */
> +#define ALS_DATA0LOW		0x0c /* Low byte of ADC channel 0 */
> +#define ALS_DATA1LOW		0x0e /* Low byte of ADC channel 1 */
> +
> +/* Power on/off value for ALS_CONTROL register */
> +#define ALS_POWER_ON		0x03
> +#define ALS_POWER_OFF		0x00
> +
> +/* Interrupts */
> +#define ALS_INTR_ENABLE		0x10
> +/* Interrupt Persist Function: Any value outside of threshold range */
> +#define ALS_THRESH_INTR		0x01
> +
> +#define ALS_THRESH_MAX		0xffff /* Max threshold value */
> +
> +struct als_data {
> +	struct i2c_client *client;
> +	struct mutex mutex;
> +	int power_state;
> +	int thresh_low;
> +	int thresh_hi;
> +	int intr_en;
> +};
> +
> +/* Lux calculation */
> +
> +/* Calculated values 1000 * (CH1/CH0)^1.4 for CH1/CH0 from 0 to 0.52 */
> +static const u16 lux_ratio[] = {
> +	0, 2, 4, 7, 11, 15, 19, 24, 29, 34, 40, 45, 51, 57, 64, 70, 77, 84, 91,
> +	98, 105, 112, 120, 128, 136, 144, 152, 160, 168, 177, 185, 194, 203,
> +	212, 221, 230, 239, 249, 258, 268, 277, 287, 297, 307, 317, 327, 337,
> +	347, 358, 368, 379, 390, 400,
> +};
> +
*laughs* even by normal ALS standards this is one ugly calculation ;)

> +static unsigned long als_calculate_lux(u16 ch0, u16 ch1)
> +{
> +	unsigned long lux, tmp;
> +
> +	/* avoid division by zero */
> +	if (ch0 == 0)
> +		return 0;
> +
> +	tmp = DIV_ROUND_UP(ch1 * 100, ch0);
> +	if (tmp <= 52) {
> +		/*
> +		 * Variable tmp64 need to avoid overflow of this part of lux
> +		 * calculation formula.
> +		 */
> +		lux = 3150 * ch0 - (unsigned long)DIV_ROUND_UP_ULL(ch0
> +				* lux_ratio[tmp] * 5930ull, 1000);
> +	} else if (tmp <= 65) {
> +		lux = 2290 * ch0 - 2910 * ch1;
> +	} else if (tmp <= 80) {
> +		lux = 1570 * ch0 - 1800 * ch1;
> +	} else if (tmp <= 130) {
> +		lux = 338 * ch0 - 260 * ch1;
> +	} else {
> +		lux = 0;
> +	}
> +
> +	return lux / 100000;
> +}
> +
Definitely drop this boilerplate - it's not even all that accurate
as I wouldn't count power state setting as such an operation.
> +/* I2C I/O operations */
> +
> +static int als_set_power_state(struct als_data *data, int state)
> +{
> +	int ret;
> +	u8 cmd;
> +
> +	cmd = state ? ALS_POWER_ON : ALS_POWER_OFF;
> +	ret = i2c_smbus_write_byte_data(data->client,
> +			ALS_CONTROL | ALS_CMD, cmd);
As for the one below, I'd prefer the logic flipped here even a the
cost of a couple more lines of code. (I review drivers backwards ;)
> +	if (!ret)
> +		data->power_state = state;
> +	else
> +		dev_err(&data->client->dev,
> +			"failed to set power state %d\n", state);
> +
> +	return ret;
> +}
> +
> +static int als_get_adc_val(struct als_data *data, int adc_number)
> +{
> +	int ret;
> +	u8 flags = ALS_CMD | ALS_WORD;
> +
> +	if (!data->power_state)
> +		return -EBUSY;
> +
> +	/* Select ADC0 or ADC1 data register */
> +	flags |= adc_number ? ALS_DATA1LOW : ALS_DATA0LOW;
> +
> +	ret = i2c_smbus_read_word_data(data->client, flags);
> +	if (ret < 0)
> +		dev_err(&data->client->dev,
> +			"failed to read ADC%d value\n", adc_number);
> +
> +	return ret;
> +}
> +
> +static int als_set_thresh_low(struct als_data *data, int value)
> +{
> +	int ret;
> +
> +	if (!data->power_state)
> +		return -EBUSY;
> +
Now this is a nasty one as to move your range to an non overlapping one
you have to move the right limit first.  I'd be tempted to be
more nefarious and if necessary 'push' the other limit along.

Note IIO never guarantees that writing to one attribute in sysfs
will not change any others.

The reason I suggest this is to make life easier for userspace
code which can then write the values in any order it likes though
I guess the trick I've suggested might in some case trigger an unexpected
interrupt.

Maybe your way was better in the first place.  I'll leave the decision
on this up to you (assuming no one else comments).
> +	if (value > ALS_THRESH_MAX || value > data->thresh_hi)
> +		return -EINVAL;
> +
> +	ret = i2c_smbus_write_word_data(data->client,
> +			ALS_THRESHLOWLOW | ALS_CMD | ALS_WORD, value);
Whilst you clearly save a couple of lines of code here, I'd prefer
the easier to read inverted option.

if (ret) {
   dev_err(...)
   return ret;
}
data->thresh_low = value;

return 0;
> +	if (!ret)
> +		data->thresh_low = value;
> +	else
> +		dev_err(&data->client->dev,
> +			"failed to set thresh_low\n");
> +
> +	return ret;
> +}
> +
> +static int als_set_thresh_hi(struct als_data *data, int value)
> +{
> +	int ret;
> +
> +	if (!data->power_state)
> +		return -EBUSY;
> +
> +	if (value > ALS_THRESH_MAX || value < data->thresh_low)
> +		return -EINVAL;
> +
> +	ret = i2c_smbus_write_word_data(data->client,
> +			ALS_THRESHHIGHLOW | ALS_CMD | ALS_WORD, value);
> +	if (!ret)
> +		data->thresh_hi = value;
> +	else
> +		dev_err(&data->client->dev,
> +			"failed to set thresh_hi\n");
> +
> +	return ret;
> +}
> +
> +static int als_set_intr_state(struct als_data *data, int state)
> +{
> +	int ret;
> +	u8 cmd;
> +
> +	if (!data->power_state)
> +		return -EBUSY;
> +
> +	cmd = state ? ALS_INTR_ENABLE | ALS_THRESH_INTR : 0x00;
> +	ret = i2c_smbus_write_byte_data(data->client,
> +			ALS_INTERRUPT | ALS_CMD, cmd);
> +	if (!ret)
> +		data->intr_en = state;
> +	else
> +		dev_err(&data->client->dev,
> +			"failed to set interrupt state %d\n", state);
> +
> +	return ret;
> +}
> +
> +static void als_clear_intr(struct als_data *data)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte(data->client, ALS_CLEAR | ALS_CMD);
> +	if (ret < 0)
> +		dev_err(&data->client->dev,
> +			"failed to clear interrupt\n");
> +}
> +
> +static int als_chip_init(struct als_data *data)
> +{
> +	int ret;
> +
> +	/* Need to set power off to ensure that the chip is off */
> +	ret = als_set_power_state(data, 0);
> +	if (ret < 0)
> +		goto err;
> +	/*
> +	 * Probe the chip. To do so we try to power up the device and then to
> +	 * read back the 0x03 code
> +	 */
> +	ret = als_set_power_state(data, 1);
> +	if (ret < 0)
> +		goto err;
> +	ret = i2c_smbus_read_byte_data(data->client, ALS_CONTROL | ALS_CMD);
> +	if (ret != ALS_POWER_ON) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +	/*
> +	 * Disable interrupt to ensure thai it is doesn't enable
> +	 * i.e. after device soft reset
> +	 */
> +	ret = als_set_intr_state(data, 0);
> +	if (ret < 0)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	dev_err(&data->client->dev, "failed to init the chip\n");
> +	return ret;
> +}
> +
Don't bother with boilerplate comments like this.
The only possible purpose is to tell anyone editting the driver
in the future where to put their changes.   For that we
rely on reviewers like me moaning at them ;)

> +/* Industrial I/O data and functions */
> +
> +static int als_read_raw(struct iio_dev *indio_dev,
> +		struct iio_chan_spec const *chan, int *val, int *val2,
> +		long mask)
> +{
> +	int ch0, ch1, ret = -EINVAL;
> +	struct als_data *data = iio_priv(indio_dev);
> +
> +	mutex_lock(&data->mutex);

The cynical coder (e.g. me) would just not bother checking
the mask at all.  Afterall we know that no read requests
for anything else can come in as the driver doesn't claim
to provide them.

> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +	case IIO_CHAN_INFO_PROCESSED:
> +		switch (chan->type) {
> +		case IIO_LIGHT:
> +			ch0 = als_get_adc_val(data, 0);
> +			if (ch0 < 0) {
> +				ret = ch0;
> +				break;
> +			}
> +			ch1 = als_get_adc_val(data, 1);
> +			if (ch1 < 0) {
> +				ret = ch1;
> +				break;
> +			}
> +			*val = als_calculate_lux(ch0, ch1);
> +			ret = IIO_VAL_INT;
> +			break;
> +		case IIO_INTENSITY:
> +			ret = als_get_adc_val(data, chan->channel);
> +			if (ret < 0)
> +				break;
> +			*val = ret;
> +			ret = IIO_VAL_INT;
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static int als_read_thresh(struct iio_dev *indio_dev, u64 event_code, int *val)
> +{
> +	struct als_data *data = iio_priv(indio_dev);
> +
> +	switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
> +	case IIO_EV_DIR_RISING:
> +		*val = data->thresh_hi;
> +		break;
> +	case IIO_EV_DIR_FALLING:
> +		*val = data->thresh_low;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int als_write_thresh(struct iio_dev *indio_dev, u64 event_code, int val)
> +{
> +	struct als_data *data = iio_priv(indio_dev);
> +	int ret;
> +
> +	mutex_lock(&data->mutex);
> +	if (IIO_EVENT_CODE_EXTRACT_DIR(event_code) == IIO_EV_DIR_RISING)
> +		ret = als_set_thresh_hi(data, val);
> +	else
> +		ret = als_set_thresh_low(data, val);
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static int als_read_interrupt_config(struct iio_dev *indio_dev,
> +		u64 event_code)
> +{
> +	struct als_data *data = iio_priv(indio_dev);
blank line here to keep it the same as the rest of your driver
(which incidentally is very nicely formatted ;)
> +	return data->intr_en;
> +}
> +
> +static int als_write_interrupt_config(struct iio_dev *indio_dev,
> +		u64 event_code, int state)
> +{
> +	struct als_data *data = iio_priv(indio_dev);
> +	int ret = 0;
I'm surprised sparse or checkpatch didn't point out that the = 0;
is pointless given it is always set 2 lines below.
Hence drop it.
> +
> +	mutex_lock(&data->mutex);
> +	ret = als_set_intr_state(data, state);
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static const struct iio_info als_info_no_irq = {
> +	.driver_module	= THIS_MODULE,
> +	.read_raw	= &als_read_raw,
> +};
> +
> +static const struct iio_info als_info = {
> +	.driver_module		= THIS_MODULE,
> +	.read_raw		= als_read_raw,
> +	.read_event_value	= &als_read_thresh,
> +	.write_event_value	= &als_write_thresh,
> +	.read_event_config	= &als_read_interrupt_config,
> +	.write_event_config	= &als_write_interrupt_config,
> +};
> +
> +static const struct iio_chan_spec als_channels[] = {
> +	{
> +		.type = IIO_LIGHT,
> +		.channel = 0,
> +		.indexed = true,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> +	}, {
> +		.type = IIO_INTENSITY,
> +		.channel = 0,
> +		.indexed = true,
We did define some 'axis modifiers' for the different sensitive ranges
for these sensors. IIO_MOD_IR and IIO_MOD_BOTH.  Now those
are arguably not some of our better interfaces, but they do
give more information than we get here from a simple channel number.
(note I'm assuming that this part has the usual approach or
 one unfiltered sensor and one with an infrared pass filter?)


> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +		.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					  IIO_EV_DIR_RISING) |
> +			       IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					  IIO_EV_DIR_FALLING)),
> +	}, {
> +		.type = IIO_INTENSITY,
> +		.channel = 1,
> +		.indexed = true,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +	},
> +};
> +
> +static irqreturn_t als_interrupt_handler(int irq, void *private)
> +{
> +	struct iio_dev *dev_info = private;
> +	struct als_data *data = iio_priv(dev_info);
> +
> +	iio_push_event(dev_info,
> +		       IIO_UNMOD_EVENT_CODE(IIO_INTENSITY, 0,
> +					    IIO_EV_TYPE_THRESH,
> +					    IIO_EV_DIR_EITHER),
> +		       iio_get_time_ns());
> +
> +	als_clear_intr(data);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int als_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +	struct als_data *data;
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
> +	ret = als_chip_init(data);
> +	if (ret < 0)
> +		goto err;
> +
> +	mutex_init(&data->mutex);
> +
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->channels = als_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(als_channels);
> +	indio_dev->name = ALS_DRV_NAME;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +
> +	if (client->irq)
> +		indio_dev->info = &als_info;
> +	else
> +		indio_dev->info = &als_info_no_irq;
> +
> +	if (client->irq) {
> +		ret = devm_request_threaded_irq(&client->dev, client->irq,
> +				NULL, als_interrupt_handler,
> +				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +				ALS_IRQ_NAME, indio_dev);
> +		if (ret) {
> +			dev_err(&client->dev, "irq request error %d\n", -ret);
> +			goto err;
> +		}
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret < 0)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	/* Ensure that power off in case of error */
> +	als_set_power_state(data, 0);
> +	return ret;
> +}
> +
> +static int als_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +	struct als_data *data = iio_priv(indio_dev);
> +
> +	iio_device_unregister(indio_dev);
> +
> +	/* Ensure that power off and interrupts are disabled */
> +	als_set_intr_state(data, 0);
> +	als_set_power_state(data, 0);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int als_suspend(struct device *dev)
> +{
> +	struct als_data *data = i2c_get_clientdata(to_i2c_client(dev));

i2c_get_client_data elsewhere gives the pointer to the
struct iio_dev not the iio_priv(indio_dev) that you are using here.

> +	int ret;
> +
> +	mutex_lock(&data->mutex);
> +	ret = als_set_power_state(data, 0);
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static int als_resume(struct device *dev)
> +{
> +	struct als_data *data = i2c_get_clientdata(to_i2c_client(dev));
> +	int ret;
same here.  Incidentally this is the sort of thing that makes me
glad most IIO drivers now have roughly the same form.  I spotted this
simply because I'd normally expect i2c_get_clientdata to return a
struct iio_dev * and it didn't.
> +
> +	mutex_lock(&data->mutex);
> +	ret = als_set_power_state(data, 1);
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(als_pm_ops, als_suspend, als_resume);
> +#define ALS_PM_OPS (&als_pm_ops)
> +#else
> +#define ALS_PM_OPS NULL
> +#endif
> +
> +static struct i2c_device_id als_id[] = {
> +	{ ALS_DRV_NAME, 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, als_id);
> +
> +static struct i2c_driver als_driver = {
> +	.driver = {
> +		.name	= ALS_DRV_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	= ALS_PM_OPS,
> +	},
> +	.probe		= als_probe,
> +	.remove		= als_remove,
> +	.id_table	= als_id,
> +};
> +
> +module_i2c_driver(als_driver);
> +
> +MODULE_AUTHOR("Kravchenko Oleksandr <o.v.kravchenko@globallogic.com>");
> +MODULE_AUTHOR("GlobalLogic inc.");
> +MODULE_DESCRIPTION("APDS9300 ambient light photo sensor driver");
> +MODULE_LICENSE("GPL");
>
