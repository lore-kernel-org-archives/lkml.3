Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaINPzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:55:07 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55202 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaINPzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:55:04 -0400
Message-ID: <5415BA52.9030004@kernel.org>
Date: Sun, 14 Sep 2014 16:54:58 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 4/6] iio: sensorhub: Add sensorhub iio commons
References: <1409756150-30889-1-git-send-email-k.wrona@samsung.com> <1409756150-30889-5-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1409756150-30889-5-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 15:55, Karol Wrona wrote:
> This patch adds common library and trigger module for sensorhub iio drivers.
>
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
A few litle bits inline.
> ---
>  drivers/iio/common/Kconfig                         |    1 +
>  drivers/iio/common/Makefile                        |    1 +
>  drivers/iio/common/ssp_sensors/Kconfig             |   15 ++++
>  drivers/iio/common/ssp_sensors/Makefile            |    6 ++
>  .../iio/common/ssp_sensors/ssp-sensor-trigger.c    |   92 ++++++++++++++++++++
>  drivers/iio/common/ssp_sensors/ssp_iio.c           |   35 ++++++++
>  drivers/iio/common/ssp_sensors/ssp_iio_sensor.h    |   62 +++++++++++++
>  7 files changed, 212 insertions(+)
>  create mode 100644 drivers/iio/common/ssp_sensors/Kconfig
>  create mode 100644 drivers/iio/common/ssp_sensors/Makefile
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp-sensor-trigger.c
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio.c
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
>
> diff --git a/drivers/iio/common/Kconfig b/drivers/iio/common/Kconfig
> index 0b6e97d..630f9d8 100644
> --- a/drivers/iio/common/Kconfig
> +++ b/drivers/iio/common/Kconfig
> @@ -4,3 +4,4 @@
>
>  source "drivers/iio/common/hid-sensors/Kconfig"
>  source "drivers/iio/common/st_sensors/Kconfig"
> +source "drivers/iio/common/ssp_sensors/Kconfig"
> diff --git a/drivers/iio/common/Makefile b/drivers/iio/common/Makefile
> index 3112df0..5119642 100644
> --- a/drivers/iio/common/Makefile
> +++ b/drivers/iio/common/Makefile
> @@ -9,3 +9,4 @@
>  # When adding new entries keep the list in alphabetical order
>  obj-y += hid-sensors/
>  obj-y += st_sensors/
> +obj-y += ssp_sensors/
> diff --git a/drivers/iio/common/ssp_sensors/Kconfig b/drivers/iio/common/ssp_sensors/Kconfig
> new file mode 100644
> index 0000000..eefabdb
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/Kconfig
> @@ -0,0 +1,15 @@
> +#
> +# Hid Sensor common modules
> +#
> +menu "SSP Sensor IIO Common"
> +
> +config SSP_SENSOR_IIO
> +	tristate "Common module (trigger) for all SSP Sensor IIO drivers"
> +	depends on SENSORS_SSP
> +	select IIO_TRIGGER
> +	select IIO_TRIGGERED_BUFFER
> +	help
> +	  Say yes here to build trigger support for SSP sensors.
> +	  Triggers will be send if all requested attributes were read.
> +
> +endmenu
> diff --git a/drivers/iio/common/ssp_sensors/Makefile b/drivers/iio/common/ssp_sensors/Makefile
> new file mode 100644
> index 0000000..da47549
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for the SSP sensor common modules.
> +#
> +
> +obj-$(CONFIG_SSP_SENSOR_IIO) += ssp-sensor-trigger.o
> +obj-$(CONFIG_SSP_SENSOR_IIO) += ssp_iio.o
> diff --git a/drivers/iio/common/ssp_sensors/ssp-sensor-trigger.c b/drivers/iio/common/ssp_sensors/ssp-sensor-trigger.c
> new file mode 100644
> index 0000000..0783cca
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/ssp-sensor-trigger.c
> @@ -0,0 +1,92 @@
> +/*
> + *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/slab.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/kfifo_buf.h>
Lots of headers in ehre I can't actually see you using... Please check them
in all the files.
> +#include <linux/iio/common/ssp_sensors.h>
> +#include "ssp_iio_sensor.h"
> +
> +static int set_rdy_trigger_state(struct iio_trigger *trigger, bool state)
> +{
> +	int ret = 0;
> +	struct ssp_sensor_data *c = iio_trigger_get_drvdata(trigger);
> +	struct ssp_data *data = dev_get_drvdata(trigger->dev.parent->parent);
> +
> +	if (state)
> +		ret = ssp_enable_sensor(data, c->type,
> +				ssp_get_sensor_delay(data,
> +						     c->type));
> +	else
> +		ret = ssp_disable_sensor(data, c->type);
> +
> +	return ret;
> +}
> +
> +static struct iio_trigger_ops ssp_sensor_trigger_ops = {
> +	.owner = THIS_MODULE,
> +	.set_trigger_state = set_rdy_trigger_state,
> +};
> +
> +void ssp_sensor_remove_trigger(struct iio_dev *indio_dev)
> +{
> +	iio_trigger_unregister(indio_dev->trig);
> +	iio_trigger_free(indio_dev->trig);
> +	indio_dev->trig = NULL;
This immediately suggests an issue... You should never be explicitly using
indio_dev->trig.  (checks below and finds the matching call which actually
has the problem).
> +}
> +EXPORT_SYMBOL(ssp_sensor_remove_trigger);
> +
> +int ssp_sensor_setup_trigger(struct iio_dev *indio_dev, const char *name,
> +			     struct ssp_sensor_data *sdata)
Hohum.  I wonder if we would benefit from having a funciton like
this directly in the IIO core?  Certainly looks like it!

Can do that at some later point though...
> +{
> +	int ret;
> +	struct iio_trigger *trigger;
> +
> +	trigger = iio_trigger_alloc("%s-dev%d", name, indio_dev->id);
> +	if (trigger == NULL) {
> +		dev_err(&indio_dev->dev, "Trigger alloc failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	trigger->dev.parent = indio_dev->dev.parent;
> +	trigger->ops = &ssp_sensor_trigger_ops;
> +	iio_trigger_set_drvdata(trigger, sdata);
> +
> +	ret = iio_trigger_register(trigger);
> +	if (ret) {
> +		dev_err(&indio_dev->dev, "Trigger register failed\n");
> +		goto error_free;
> +	}
> +	indio_dev->trig = trigger;
We keep hitting this.  The above is a bug as it doesn't take a reference
to the trigger.  You need an iio_trigger_get call.  We have a fix set for
this issue queued up that allows
indio_dev->trig = iio_trigger_get(trigger);  which is cleaner.
> +
> +	return ret;
> +
> +error_free:
> +	iio_trigger_free(trigger);
> +	return ret;
> +}
> +EXPORT_SYMBOL(ssp_sensor_setup_trigger);
> +
> +MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
> +MODULE_DESCRIPTION("SSP Sensor trigger processing");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/iio/common/ssp_sensors/ssp_iio.c b/drivers/iio/common/ssp_sensors/ssp_iio.c
> new file mode 100644
> index 0000000..fc88643
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/ssp_iio.c
> @@ -0,0 +1,35 @@
> +/*
> + *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/iio/iio.h>
> +#include <linux/kernel.h>
> +#include <linux/iio/common/ssp_sensors.h>
> +#include <linux/iio/triggered_buffer.h>
> +#include "ssp_iio_sensor.h"
> +
> +/**
> + * @ssp_common_destroy_sensor() - ssp sensor cleanup
> + *
> + * @indio_dev: iio device
> + */
> +void ssp_common_destroy_sensor(struct iio_dev *indio_dev)
> +{
> +	iio_device_unregister(indio_dev);
> +	ssp_sensor_remove_trigger(indio_dev);
> +	iio_triggered_buffer_cleanup(indio_dev);
> +	iio_device_free(indio_dev);
No blank line here.  I wonder if it is worth using devm_iio_device_alloc
and loosing the iio_device_free.  Perhaps it will add more confusion than
anything.  Right now I'd argue this function is not worth bothering with
at all as it slightly obscures what is going on in the callers.
> +
> +}
> +EXPORT_SYMBOL(ssp_common_destroy_sensor);
> diff --git a/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
> new file mode 100644
> index 0000000..1911fbd
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
> @@ -0,0 +1,62 @@
> +#ifndef __SSP_IIO_SENSOR_H__
> +#define __SSP_IIO_SENSOR_H__
> +
I suspect you'll fairly quickly end up moving this nearer to the individual
sub drivers as they will have their own slight differences. However
you can do that when it becomes necessary.  Fine having it here for now.
> +#define SSP_CHANNEL_AG(_type, _mod, _index) \
> +{ \
> +		.type = _type,\
> +		.modified = 1,\
> +		.channel2 = _mod,\
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |\
> +					BIT(IIO_CHAN_INFO_SAMP_FREQ),\
> +		.scan_index = _index,\
> +		.scan_type = {\
> +			.sign = 's',\
> +			.realbits = 16,\
> +			.storagebits = 16,\
> +			.shift = 0,\
> +			.endianness = IIO_LE,\
> +		},\
> +}
> +
> +#define SSP_DIVISOR	1000000ULL
> +#define SSP_MS_PER_S	1000
> +#define SSP_DIVIDEND	(SSP_DIVISOR * SSP_MS_PER_S)
> +
> +int ssp_sensor_setup_trigger(struct iio_dev *indio_dev, const char *name,
> +			     struct ssp_sensor_data *data);
> +
> +void ssp_sensor_remove_trigger(struct iio_dev *indio_dev);
> +
> +/* Converts time in ms to frequency */
> +static inline void ssp_convert_to_freq(u32 time, int *integer_part,
> +				       int *fractional)
> +{
> +	unsigned int value;
> +
> +	if (time == 0) {
> +		*fractional = 0;
> +		*integer_part = 0;
> +		return;
> +	}
> +
> +	value = SSP_DIVIDEND / time;
> +	*fractional = value % SSP_DIVISOR;
> +	*integer_part = value / SSP_DIVISOR;
> +}
> +
> +/* Converts frequency to time in ms*/
> +static inline int ssp_convert_to_time(int integer_part, int fractional)
> +{
> +	u64 value;
> +
> +	value = integer_part * SSP_DIVISOR + fractional;
> +	if (value == 0)
> +		return 0;
> +
> +	return  div_u64(SSP_DIVIDEND, value);
> +}
> +
> +void ssp_common_destroy_sensor(struct iio_dev *indio_dev);
> +
> +#endif /* __SSP_IIO_SENSOR_H__ */
> +
>
