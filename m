Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCFTDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:03:24 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57707 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaCFTDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:03:22 -0500
Message-ID: <5318C6AC.9070107@kernel.org>
Date: Thu, 06 Mar 2014 19:04:12 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Ranostay <mranostay@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org
CC: matt.porter@linaro.org, pantelis.antoniou@gmail.com
Subject: Re: [PATCH v7 2/2] iio: Add AS3935 lightning sensor support
References: <1392179475-2611-1-git-send-email-mranostay@gmail.com> <1392179475-2611-3-git-send-email-mranostay@gmail.com>
In-Reply-To: <1392179475-2611-3-git-send-email-mranostay@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/14 04:31, Matt Ranostay wrote:
> AS3935 chipset can detect lightning strikes and reports those back as
> events and the estimated distance to the storm.
>
> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
Given the resounding lack of support for my spherical coordinates
suggestion, assuming nothing changes, I'll take this as a proximity driver.

However, some outstanding bits and pieces and I'm not keen on a custom
driver attribute for the boost gain if we can manage something more general.
> ---
>   .../ABI/testing/sysfs-bus-iio-proximity-as3935     |  18 +
>   drivers/iio/Kconfig                                |   1 +
>   drivers/iio/Makefile                               |   1 +
>   drivers/iio/proximity/Kconfig                      |  19 +
>   drivers/iio/proximity/Makefile                     |   6 +
>   drivers/iio/proximity/as3935.c                     | 446 +++++++++++++++++++++
>   6 files changed, 491 insertions(+)
>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935
>   create mode 100644 drivers/iio/proximity/Kconfig
>   create mode 100644 drivers/iio/proximity/Makefile
>   create mode 100644 drivers/iio/proximity/as3935.c
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935 b/Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935
> new file mode 100644
> index 0000000..fc92bce
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935
> @@ -0,0 +1,18 @@
> +What		/sys/bus/iio/devices/iio:deviceX/in_proximity_raw
> +Date:		January 2014
> +KernelVersion:	3.15
> +Contact:	Matt Ranostay <mranostay@gmail.com>
> +Description:
> +		Get the current distance in meters of storm (1km steps)
> +		1000       = storm overhead
> +		1000-40000 = distance in meters
> +		63000      = out of range
If these are 'real' units then it should be in_proximity_input (IIO_INFO_PROCESSED).  The overhead one is a litle interesting.  I'd be tempted to just define
it as meters and neglect to mention that it is meaningless any nearer.
Also we proximity is a standard type so we the help should be in the main
file and not device specific.  I wonder if for out of range it should return
an error as it means it really doesn't have any answer rather than anything
else...
> +
> +What		/sys/bus/iio/devices/iio:deviceX/gain_boost
> +Date:		January 2014
> +KernelVersion:	3.15
> +Contact:	Matt Ranostay <mranostay@gmail.com>
> +Description:
> +		Show or set the gain boost of the amp, from 0-31 range.
> +		18 = indoors (default)
> +		14 = outdoors
> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
> index 5dd0e12..743485e 100644
> --- a/drivers/iio/Kconfig
> +++ b/drivers/iio/Kconfig
> @@ -74,6 +74,7 @@ if IIO_TRIGGER
>      source "drivers/iio/trigger/Kconfig"
>   endif #IIO_TRIGGER
>   source "drivers/iio/pressure/Kconfig"
> +source "drivers/iio/proximity/Kconfig"
>   source "drivers/iio/temperature/Kconfig"
>
>   endif # IIO
> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
> index 887d390..698afc2 100644
> --- a/drivers/iio/Makefile
> +++ b/drivers/iio/Makefile
> @@ -24,5 +24,6 @@ obj-y += light/
>   obj-y += magnetometer/
>   obj-y += orientation/
>   obj-y += pressure/
> +obj-y += proximity/
>   obj-y += temperature/
>   obj-y += trigger/
> diff --git a/drivers/iio/proximity/Kconfig b/drivers/iio/proximity/Kconfig
> new file mode 100644
> index 0000000..0c8cdf5
> --- /dev/null
> +++ b/drivers/iio/proximity/Kconfig
> @@ -0,0 +1,19 @@
> +#
> +# Proximity sensors
> +#
> +
> +menu "Lightning sensors"
> +
> +config AS3935
> +	tristate "AS3935 Franklin lightning sensor"
> +	select IIO_BUFFER
> +	select IIO_TRIGGERED_BUFFER
> +	depends on SPI
> +	help
> +	  Say Y here to build SPI interface support for the Austrian
> +	  Microsystems AS3935 lightning detection sensor.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called as3935
> +
> +endmenu
> diff --git a/drivers/iio/proximity/Makefile b/drivers/iio/proximity/Makefile
> new file mode 100644
> index 0000000..743adee
> --- /dev/null
> +++ b/drivers/iio/proximity/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for IIO proximity sensors
> +#
> +
> +# When adding new entries keep the list in alphabetical order
> +obj-$(CONFIG_AS3935)		+= as3935.o
> diff --git a/drivers/iio/proximity/as3935.c b/drivers/iio/proximity/as3935.c
> new file mode 100644
> index 0000000..75ef034
> --- /dev/null
> +++ b/drivers/iio/proximity/as3935.c
> @@ -0,0 +1,446 @@
> +/*
> + * as3935.c - Support for AS3935 Franklin lightning sensor
> + *
> + * Copyright (C) 2014 Matt Ranostay <mranostay@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
No blank line here.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/workqueue.h>
> +#include <linux/mutex.h>
> +#include <linux/err.h>
> +#include <linux/irq.h>
> +#include <linux/gpio.h>
> +#include <linux/spi/spi.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/triggered_buffer.h>
> +#include <linux/pm_runtime.h>
This isn't doing runtime pm so is this the right header?

> +#include <linux/of_gpio.h>
> +
> +
> +#define AS3935_AFE_GAIN		0x00
> +#define AS3935_AFE_MASK		0x3F
> +#define AS3935_AFE_GAIN_MAX	0x1F
> +#define AS3935_AFE_PWR_BIT	BIT(0)
> +
> +#define AS3935_INT		0x03
> +#define AS3935_INT_MASK		0x07
> +#define AS3935_EVENT_INT	BIT(3)
> +#define AS3935_NOISE_INT	BIT(1)
> +
> +#define AS3935_DATA		0x07
> +#define AS3935_DATA_MASK	0x3F
> +
> +#define AS3935_TUNE_CAP		0x08
> +#define AS3935_CALIBRATE	0x3D
> +
> +#define AS3935_WRITE_DATA	BIT(15)
> +#define AS3935_READ_DATA	BIT(14)
> +#define AS3935_ADDRESS(x)	((x) << 8)
> +
> +#define MAX_PF_CAP		120
> +#define TUNE_CAP_DIV		8
> +
> +struct as3935_state {
> +	struct spi_device *spi;
> +	struct iio_trigger *trig;
> +	struct mutex lock;
> +	struct delayed_work work;
> +
The point of the ____cacheline_aligned is to ensure that when allocated
the buffer does not share a cacheline with anything else.  It does this
by fixing teh starting location.   Nothing is done about the end location.
Hence this *must* be the last element in the structure.   Care is taken
in the iio_dev allocation to ensure that the start of the private structure
is appropriately aligned and there is nothing after it.

i.e. tune_cap must be above the next line.
> +	u8 buf[2] ____cacheline_aligned;
> +	u32 tune_cap;
> +};
> +
> +static const struct iio_chan_spec as3935_channels[] = {
> +	{
> +		.type           = IIO_PROXIMITY,
> +		.info_mask_separate =
> +			BIT(IIO_CHAN_INFO_RAW),
> +		.scan_index     = 0,
> +		.scan_type = {
> +			.sign           = 'u',
> +			.realbits       = 6,
> +			.storagebits    = 8,
> +		},
> +	},
> +	IIO_CHAN_SOFT_TIMESTAMP(1),
> +};
> +
> +static int as3935_read(struct as3935_state *st, unsigned int reg, int *val)
> +{
> +	u8 cmd;
> +	int ret;
> +
> +	cmd = (AS3935_READ_DATA | AS3935_ADDRESS(reg)) >> 8;
> +	ret = spi_w8r8(st->spi, cmd);
> +	if (ret < 0)
> +		return ret;
> +	*val = ret;
> +
> +	return 0;
> +};
> +
> +static int as3935_write(struct as3935_state *st,
> +				unsigned int reg,
> +				unsigned int val)
> +{
I wouldn't bother with the local pointer copy. Slightly
obscures what is giong on to save a few character.
> +	u8 *buf = st->buf;
> +
> +	buf[0] = (AS3935_WRITE_DATA | AS3935_ADDRESS(reg)) >> 8;
> +	buf[1] = val;
> +
> +	return spi_write(st->spi, (u8 *) buf, 2);
Why the typecast? It's already a u8 *
> +};
> +
> +static ssize_t as3935_gain_boost_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct as3935_state *st = iio_priv(dev_to_iio_dev(dev));
> +	int val, ret;
> +
> +	ret = as3935_read(st, AS3935_AFE_GAIN, &val);
> +	if (ret)
> +		return ret;
> +	val = (val & AS3935_AFE_MASK) >> 1;
> +
> +	return sprintf(buf, "%d\n", val);
> +};
> +
> +static ssize_t as3935_gain_boost_store(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t len)
> +{
> +	struct as3935_state *st = iio_priv(dev_to_iio_dev(dev));
> +	unsigned long val;
> +	int ret;
> +
> +	ret = kstrtoul((const char *) buf, 10, &val);
> +	if (ret)
> +		return -EINVAL;
> +
> +	if (val > AS3935_AFE_GAIN_MAX)
> +		return -EINVAL;
> +
> +	as3935_write(st, AS3935_AFE_GAIN, val << 1);
> +
> +	return len;
> +};
> +
> +static IIO_DEVICE_ATTR(gain_boost, S_IRUGO | S_IWUSR,
> +	as3935_gain_boost_show, as3935_gain_boost_store, 0);
> +
> +
> +static struct attribute *as3935_attributes[] = {
> +	&iio_dev_attr_gain_boost.dev_attr.attr,

So what is this really?  Could it be considered a calibration scale?
Or a straight _scale?  Is it effecting the measurement, or
the sensitivity to make a measurement?  If the second then
we probably want a more general naming.

Perhaps
in_detectionsensitivy or similar (that's a quick random suggestion
- I'd prefer something better thought out ;)

> +	NULL,
> +};
> +
> +static struct attribute_group as3935_attribute_group = {
> +	.attrs = as3935_attributes,
> +};
> +
> +static int as3935_read_raw(struct iio_dev *indio_dev,
> +			   struct iio_chan_spec const *chan,
> +			   int *val,
> +			   int *val2,
> +			   long m)
> +{
> +	struct as3935_state *st = iio_priv(indio_dev);
> +	int ret;
> +
> +	if (m != IIO_CHAN_INFO_RAW)
> +		return -EINVAL;
> +
> +	*val2 = 0;
> +	ret = as3935_read(st, AS3935_DATA, val);
> +	if (ret)
> +		return ret;
> +	*val *= 1000;
> +
> +	return IIO_VAL_INT;
> +}
> +
> +static const struct iio_info as3935_info = {
> +	.driver_module = THIS_MODULE,
> +	.attrs = &as3935_attribute_group,
> +	.read_raw = &as3935_read_raw,
> +};
> +
> +static const struct iio_buffer_setup_ops iio_triggered_buffer_setup_ops = {
> +	.postenable = &iio_triggered_buffer_postenable,
> +	.predisable = &iio_triggered_buffer_predisable,
> +};
These are the defaults - don't provide any and you'll get the same thing
(see industrialio-triggered-buffer.c)
> +
> +static irqreturn_t as3935_trigger_handler(int irq, void *private)
> +{
> +	struct iio_poll_func *pf = private;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct as3935_state *st = iio_priv(indio_dev);
> +	int val, ret;
> +
> +	ret = as3935_read(st, AS3935_DATA, &val);
> +	if (ret)
> +		goto err_read;
> +	val &= AS3935_DATA_MASK;
> +	val *= 1000;
> +
> +	iio_push_to_buffers_with_timestamp(indio_dev, &val, pf->timestamp);
> +err_read:
> +	iio_trigger_notify_done(indio_dev->trig);
> +
> +	return IRQ_HANDLED;
> +};
> +
> +static const struct iio_trigger_ops iio_interrupt_trigger_ops = {
> +	.owner = THIS_MODULE,
> +};
> +
> +static void as3935_event_work(struct work_struct *work)
> +{
> +	struct as3935_state *st;
> +	int val;
> +
> +	st = container_of(work, struct as3935_state, work.work);
> +
> +	as3935_read(st, AS3935_INT, &val);
> +	val &= AS3935_INT_MASK;
> +
> +	switch (val) {
> +	case AS3935_EVENT_INT:
> +		iio_trigger_poll(st->trig, iio_get_time_ns());
> +		break;
> +	case AS3935_NOISE_INT:
This could be provided as an event perhaps?  Not sure, but splurging in
the log is probably going to be missed.

> +		dev_warn(&st->spi->dev, "noise level is too high");
> +		break;
> +	}
> +};
> +
> +static irqreturn_t as3935_interrupt_handler(int irq, void *private)
> +{
> +	struct iio_dev *indio_dev = private;
> +	struct as3935_state *st = iio_priv(indio_dev);
> +
/*
  * Delay..
> +	/* Delay work for >2 milliseconds after an interrupt to allow
> +	 * estimated distance to recalculated.
> +	 */
> +
> +	schedule_delayed_work(&st->work, msecs_to_jiffies(3));
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void calibrate_as3935(struct as3935_state *st)
> +{
> +	mutex_lock(&st->lock);
> +
> +	/* mask disturber interrupt bit */
> +	as3935_write(st, AS3935_INT, 1<<5);
> +
> +	as3935_write(st, AS3935_CALIBRATE, 0x96);
1 << 5 as it's a binary operator.
> +	as3935_write(st, AS3935_TUNE_CAP, 1<<5 | (st->tune_cap / TUNE_CAP_DIV));
> +
> +	mdelay(2);
> +	as3935_write(st, AS3935_TUNE_CAP, (st->tune_cap / TUNE_CAP_DIV));
> +
> +	mutex_unlock(&st->lock);
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int as3935_suspend(struct spi_device *spi, pm_message_t msg)
> +{
> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> +	struct as3935_state *st = iio_priv(indio_dev);
> +	int val, ret;
> +
> +	mutex_lock(&st->lock);
> +	ret = as3935_read(st, AS3935_AFE_GAIN, &val);
> +	if (ret)
> +		goto err_suspend;
> +	val |= AS3935_AFE_PWR_BIT;
> +
> +	ret = as3935_write(st, AS3935_AFE_GAIN, val);
> +
> +err_suspend:
> +	mutex_unlock(&st->lock);
> +
> +	return ret;
> +}
> +
> +static int as3935_resume(struct spi_device *spi)
> +{
> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> +	struct as3935_state *st = iio_priv(indio_dev);
> +	int val, ret;
> +
> +	mutex_lock(&st->lock);
> +	ret = as3935_read(st, AS3935_AFE_GAIN, &val);
> +	if (ret)
> +		goto err_resume;
> +	val &= ~AS3935_AFE_PWR_BIT;
> +	ret = as3935_write(st, AS3935_AFE_GAIN, val);
> +
> +err_resume:
> +	mutex_unlock(&st->lock);
> +
> +	return ret;
> +}
> +#else
> +#define as3935_suspend	NULL
> +#define as3935_resume	NULL
> +#endif
> +
> +static int as3935_probe(struct spi_device *spi)
> +{
> +	struct iio_dev *indio_dev;
> +	struct iio_trigger *trig;
> +	struct as3935_state *st;
> +	struct device_node *np = spi->dev.of_node;
> +	int ret;
> +
... is specified?
> +	/* Be sure lightning event interrupt */
> +	if (!spi->irq) {
> +		dev_err(&spi->dev, "unable to get event interrupt\n");
> +		return -EINVAL;
> +	}
> +
> +	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(st));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	st = iio_priv(indio_dev);
> +	st->spi = spi;
> +	st->tune_cap = 0;
> +
> +	spi_set_drvdata(spi, indio_dev);
> +	mutex_init(&st->lock);
> +	INIT_DELAYED_WORK(&st->work, as3935_event_work);
> +
> +	ret = of_property_read_u32(np,
> +			"ams,tuning-capacitor-pf", &st->tune_cap);
> +	if (ret) {
> +		st->tune_cap = 0;
> +		dev_warn(&spi->dev,
> +			"no tuning-capacitor-pf set, defaulting to %d",
> +			st->tune_cap);
> +	}
> +
> +	if (st->tune_cap > MAX_PF_CAP) {
> +		dev_err(&spi->dev,
> +			"wrong tuning-capacitor-pf setting of %d\n",
> +			st->tune_cap);
> +		return -EINVAL;
> +	}
> +
> +	indio_dev->dev.parent = &spi->dev;
> +	indio_dev->name = spi_get_device_id(spi)->name;
> +	indio_dev->channels = as3935_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(as3935_channels);
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->info = &as3935_info;
> +
> +	trig = devm_iio_trigger_alloc(&spi->dev, "%s-dev%d",
> +				      indio_dev->name, indio_dev->id);
> +
> +	if (!trig)
> +		return -ENOMEM;
> +
> +	st->trig = trig;
> +	trig->dev.parent = indio_dev->dev.parent;
> +	iio_trigger_set_drvdata(trig, indio_dev);
> +	trig->ops = &iio_interrupt_trigger_ops;
> +
> +	ret = iio_trigger_register(trig);
> +	if (ret) {
> +		dev_err(&spi->dev, "failed to register trigger\n");
> +		return ret;
> +	}
> +
> +	ret = iio_triggered_buffer_setup(indio_dev, NULL,
> +					&as3935_trigger_handler,
> +					&iio_triggered_buffer_setup_ops);
> +
> +	if (ret) {
> +		dev_err(&spi->dev, "cannot setup iio trigger\n");
This will unroll the triggered_buffer_setup that has errored out.
Hence you will unregister a buffer that was never registered.
This should have it's own label to goto that only unregisters the
trigger.

> +		goto unregister_trigger;
> +	}
> +
> +	calibrate_as3935(st);
> +
> +	ret = devm_request_irq(&spi->dev, spi->irq,
> +				&as3935_interrupt_handler,
> +				IRQF_TRIGGER_RISING,
> +				dev_name(&spi->dev),
> +				indio_dev);
> +
> +	if (ret) {
> +		dev_err(&spi->dev, "unable to request irq\n");
> +		goto unregister_trigger;
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "unable to register device\n");
> +		goto unregister_trigger;
> +	}
> +	return 0;
> +
> +unregister_trigger:
These should be in the opposite order to conform to standard
error unrolling (undo things in reverse order.

> +	iio_trigger_unregister(st->trig);
> +	iio_triggered_buffer_cleanup(indio_dev);
> +
> +	return ret;
> +};
> +
> +static int as3935_remove(struct spi_device *spi)
> +{
> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> +	struct as3935_state *st = iio_priv(indio_dev);
> +
> +	iio_device_unregister(indio_dev);
> +	iio_triggered_buffer_cleanup(indio_dev);
> +	iio_trigger_unregister(st->trig);
> +
> +	return 0;
> +};
> +
> +static const struct spi_device_id as3935_id[] = {
> +	{"as3935", 0},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(spi, as3935_id);
> +
> +static struct spi_driver as3935_driver = {
> +	.driver = {
> +		.name	= "as3935",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= as3935_probe,
> +	.remove		= as3935_remove,
> +	.id_table	= as3935_id,
> +	.suspend	= as3935_suspend,
> +	.resume		= as3935_resume,
> +};
> +module_spi_driver(as3935_driver);
> +
> +MODULE_AUTHOR("Matt Ranostay <mranostay@gmail.com>");
> +MODULE_DESCRIPTION("AS3935 lightning sensor");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("spi:as3935");
>

