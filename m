Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaLGRo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:44:27 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39872 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaLGRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:43:23 -0500
Message-ID: <54831837.4030604@kernel.org>
Date: Sat, 06 Dec 2014 14:52:39 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 4/5] iio: common: ssp_sensors: Add sensorhub accelerometer
 sensor
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-5-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1417809290-9662-5-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 19:54, Karol Wrona wrote:
> This patch adds accelerometer iio driver which uses sensorhub as data
> provider.
> 
> Change-Id: I4686741b7401ec5cbf4b5d0f2a5cc146fbe24d53
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/accel/Makefile           |    1 +
>  drivers/iio/accel/ssp_accel_sensor.c |  203 ++++++++++++++++++++++++++++++++++
>  2 files changed, 204 insertions(+)
>  create mode 100644 drivers/iio/accel/ssp_accel_sensor.c
> 
> diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
> index a593996..df6a0b2 100644
> --- a/drivers/iio/accel/Makefile
> +++ b/drivers/iio/accel/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_HID_SENSOR_ACCEL_3D) += hid-sensor-accel-3d.o
>  obj-$(CONFIG_KXCJK1013) += kxcjk-1013.o
>  obj-$(CONFIG_KXSD9)	+= kxsd9.o
>  obj-$(CONFIG_MMA8452)	+= mma8452.o
> +obj-$(CONFIG_IIO_SSP_SENSOR) += ssp_accel_sensor.o
>  
>  obj-$(CONFIG_IIO_ST_ACCEL_3AXIS) += st_accel.o
>  st_accel-y := st_accel_core.o
> diff --git a/drivers/iio/accel/ssp_accel_sensor.c b/drivers/iio/accel/ssp_accel_sensor.c
> new file mode 100644
> index 0000000..0a47c29
> --- /dev/null
> +++ b/drivers/iio/accel/ssp_accel_sensor.c
> @@ -0,0 +1,203 @@
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
> +#include <linux/iio/common/ssp_sensors.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/kfifo_buf.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include "../common/ssp_sensors/ssp_iio_sensor.h"
> +
> +#define SSP_CHANNEL_COUNT 3
> +
> +#define SSP_ACCEL_NAME "ssp-accelerometer"
> +static const char ssp_accel_device_name[] = SSP_ACCEL_NAME;
> +
> +enum ssp_accel_3d_channel {
> +	SSP_CHANNEL_SCAN_INDEX_X,
> +	SSP_CHANNEL_SCAN_INDEX_Y,
> +	SSP_CHANNEL_SCAN_INDEX_Z,
> +	SSP_CHANNEL_SCAN_INDEX_TIME,
> +	SSP_ACCEL_3D_CHANNEL_MAX,
you don't actually use this max element so drop it.
> +};
> +
> +static int ssp_accel_read_raw(struct iio_dev *indio_dev,
> +			      struct iio_chan_spec const *chan,  int *val,
> +			      int *val2, long mask)
> +{
> +	u32 t;
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_SAMP_FREQ:
> +		t = ssp_get_sensor_delay(data, SSP_ACCELEROMETER_SENSOR);
> +		ssp_convert_to_freq(t, val, val2);
> +		return IIO_VAL_INT_PLUS_MICRO;
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int ssp_accel_write_raw(struct iio_dev *indio_dev,
> +			       struct iio_chan_spec const *chan, int val,
> +			       int val2, long mask)
> +{
> +	int ret;
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_SAMP_FREQ:
> +		ret = ssp_convert_to_time(val, val2);
> +		ret = ssp_change_delay(data, SSP_ACCELEROMETER_SENSOR, ret);
> +		if (ret < 0)
> +			dev_err(&indio_dev->dev, "accel sensor enable fail\n");
> +
> +		return ret;
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static struct iio_info ssp_accel_iio_info = {
> +	.read_raw = &ssp_accel_read_raw,
> +	.write_raw = &ssp_accel_write_raw,
> +};
> +
> +static const struct iio_chan_spec ssp_acc_channels[] = {
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_X, SSP_CHANNEL_SCAN_INDEX_X),
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Y, SSP_CHANNEL_SCAN_INDEX_Y),
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Z, SSP_CHANNEL_SCAN_INDEX_Z),
> +	IIO_CHAN_SOFT_TIMESTAMP(SSP_CHANNEL_SCAN_INDEX_TIME),
hmm. Not actually a soft timestamp so I guess we should really rename that
macro.  Actually is your resulting timestamp 32 bit?  If so you could
specify the channel as such and include a scale to allow userspace to
convert it as it wishes.
> +};
> +
> +static int ssp_process_accel_data(struct iio_dev *indio_dev, void *buf,
> +				  int64_t timestamp)
We could hang a set of triggers of the parent device and use the in
conjunction with some local buffering to fire off the children.
There would be the advantage that we could trigger other sensors off them
(to get roughly synchronized additional signals).  Probably not worth it
though but I thought I'd mention the option.
> +{
> +	__le32 time;
> +	const int len = SSP_ACCELEROMETER_SIZE;
> +	int64_t calculated_time;
> +	char *data;
> +	int ret;
> +
> +	if (indio_dev->scan_bytes == 0)
> +		return 0;
> +
> +	data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
I'd allocate this in your iio_priv structure and setup the length in preenable
etc.  Last thing we want in here is to waste time with a memory allocation and
free.
> +
> +	memcpy(data, buf, len);
It's a little uggly but I think you can avoid the copy if the timestamp
isn't in use (as then we don't need the additional space).
> +
> +	if (indio_dev->scan_timestamp) {
> +		memcpy(&time, &((char *)buf)[len], SSP_TIME_SIZE);
> +		calculated_time =
> +			timestamp + (int64_t)le32_to_cpu(time) * 1000000;
Cool - our first hardware supplied timestamp ;)
> +	}
> +
> +	ret = iio_push_to_buffers_with_timestamp(indio_dev, data,
> +						 calculated_time);
> +
> +	kfree(data);
> +
> +	return ret;
> +}
> +
> +static const struct iio_buffer_setup_ops ssp_accel_buffer_ops = {
> +	.postenable = &ssp_common_buffer_postenable,
> +	.predisable = &ssp_common_buffer_predisable,
> +};
> +
> +static int ssp_accel_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct iio_dev *indio_dev;
> +	struct ssp_sensor_data *spd;
> +
> +	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*spd));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	spd = iio_priv(indio_dev);
> +
> +	spd->process_data = ssp_process_accel_data;
> +	spd->type = SSP_ACCELEROMETER_SENSOR;
> +
> +	indio_dev->name = ssp_accel_device_name;
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->dev.of_node = pdev->dev.of_node;
> +	indio_dev->info = &ssp_accel_iio_info;
> +	indio_dev->modes = INDIO_BUFFER_HARDWARE;
hmm. A rare beast with no polled access.  But is it actually a hardware
buffer?  Doesn't look that much like one.  I think we may need a more
refined set of options for the buffer type.
 
> +	indio_dev->channels = ssp_acc_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(ssp_acc_channels);
> +
> +	ret = ssp_common_setup_buffer(indio_dev, &ssp_accel_buffer_ops);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Buffer setup fail\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, indio_dev);
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret < 0) {
> +		iio_buffer_unregister(indio_dev);
> +		iio_kfifo_free(indio_dev->buffer);
> +		return ret;
> +	}
> +
> +	/* need to be really sure about success for this one */
err, what does the comment mean?
> +	ssp_register_consumer(indio_dev, SSP_ACCELEROMETER_SENSOR);
> +
> +	return 0;
> +}
> +
> +static int ssp_accel_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	iio_device_unregister(indio_dev);
> +	iio_buffer_unregister(indio_dev);
> +	iio_kfifo_free(indio_dev->buffer);
Feels rather like we need a devm_iio_kfifo_alloc
Actually, as you are wrapping the allocation, I'd prefer you have
an obviously matched cleanup function to ssp_common_setup_buffer
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ssp_accel_id_table[] = {
> +	{
> +		.compatible = "samsung,mpu6500-accel",
> +	},
> +	{},
> +};
> +
> +static struct platform_driver ssp_accel_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = SSP_ACCEL_NAME,
> +		.of_match_table = ssp_accel_id_table,
> +	},
> +	.probe = ssp_accel_probe,
> +	.remove =  ssp_accel_remove,
> +};
> +
> +module_platform_driver(ssp_accel_driver);
> +
> +MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
> +MODULE_DESCRIPTION("Samsung sensorhub accelerometers driver");
> +MODULE_LICENSE("GPL");
> 

