Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaINRKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:10:24 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55559 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaINRKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:10:23 -0400
Message-ID: <5415CBFC.4060308@kernel.org>
Date: Sun, 14 Sep 2014 18:10:20 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 5/6] iio: sensorhub: Add sensorhub accelerometer sensor
References: <1409756150-30889-1-git-send-email-k.wrona@samsung.com> <1409756150-30889-6-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1409756150-30889-6-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 15:55, Karol Wrona wrote:
> This patch adds accelerometer iio driver which uses sensorhub as data
> provider.
>
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
A few bits and bobs. The biggest one is that your triggers don't add anything.
It's not necessary to have triggers, you can have buffers directly without
them if they make no sense (as it appears the don't here).

Other bits inline.
> ---
>  drivers/iio/accel/Makefile           |    2 +
>  drivers/iio/accel/ssp_accel_sensor.c |  240 ++++++++++++++++++++++++++++++++++
>  2 files changed, 242 insertions(+)
>  create mode 100644 drivers/iio/accel/ssp_accel_sensor.c
>
> diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
> index a593996..2ab1ca6 100644
> --- a/drivers/iio/accel/Makefile
> +++ b/drivers/iio/accel/Makefile
> @@ -16,3 +16,5 @@ st_accel-$(CONFIG_IIO_BUFFER) += st_accel_buffer.o
>
>  obj-$(CONFIG_IIO_ST_ACCEL_I2C_3AXIS) += st_accel_i2c.o
>  obj-$(CONFIG_IIO_ST_ACCEL_SPI_3AXIS) += st_accel_spi.o
> +
> +obj-$(CONFIG_SSP_SENSOR_IIO) += ssp_accel_sensor.o
> diff --git a/drivers/iio/accel/ssp_accel_sensor.c b/drivers/iio/accel/ssp_accel_sensor.c
> new file mode 100644
> index 0000000..5e7d3e0
> --- /dev/null
> +++ b/drivers/iio/accel/ssp_accel_sensor.c
> @@ -0,0 +1,240 @@
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
> +#include <linux/platform_device.h>
> +#include <linux/stat.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/triggered_buffer.h>
> +#include <linux/iio/common/ssp_sensors.h>
> +#include <linux/iio/kfifo_buf.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/common/ssp_sensors.h>
> +#include "../common/ssp_sensors/ssp_iio_sensor.h"
> +
> +#define CHANNEL_COUNT 3
> +
> +#define SSP_ACCEL_NAME "ssp-accelrometer"
> +static const char ssp_accel_device_name[] = SSP_ACCEL_NAME;
> +
> +enum accel_3d_channel {
> +	CHANNEL_SCAN_INDEX_X,
> +	CHANNEL_SCAN_INDEX_Y,
> +	CHANNEL_SCAN_INDEX_Z,
> +	CHANNEL_SCAN_INDEX_TIME,
> +	ACCEL_3D_CHANNEL_MAX,
> +};
> +
> +struct ssp_accel_state {
> +	int accel_val;
> +	int accel_calibbias;
> +	struct ssp_data *data;
> +	short calibration_data[CHANNEL_COUNT];
> +};
> +
> +static struct ssp_accel_state accel_state;
Why not dynamically allocate this and loose the global?
Both more elegant and in theory allows multiple accelerometers on some
future variant of this part (you never know ;)
> +
> +static int accel_read_raw(struct iio_dev *indio_dev,
> +			  struct iio_chan_spec const *chan,
> +			  int *val,
> +			  int *val2,
> +			  long mask)
> +{
> +	int ret;
> +	u32 t;
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_SAMP_FREQ:
> +		t = ssp_get_sensor_delay(data, SSP_ACCELEROMETER_SENSOR);
> +		ssp_convert_to_freq(t, val, val2);
> +		ret = IIO_VAL_INT_PLUS_MICRO;
> +		break;
Interesting - no provision for polled data reading.  Fair enough if there
is no hardware support.... However, you have it in the info_mask for the
channels which isn't good.
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int accel_write_raw(struct iio_dev *indio_dev,
> +			   struct iio_chan_spec const *chan,
> +			   int val,
> +			   int val2,
> +			   long mask)
> +{
> +	int ret, value;
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_SAMP_FREQ:
> +		value = ssp_convert_to_time(val, val2);
> +		ret = ssp_change_delay(data, SSP_ACCELEROMETER_SENSOR, value);
> +		if (ret < 0) {
> +			dev_err(&indio_dev->dev, "accel sensor enable fail\n");
> +			ret = -EINVAL;
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int accel_write_raw_get_fmt(struct iio_dev *indio_dev,
> +			       struct iio_chan_spec const *chan,
> +			       long mask)
> +{
> +	return IIO_VAL_INT_PLUS_MICRO;
That's the default. No need to have this function.
> +}
> +
> +static struct iio_info ssp_accel_iio_info = {
> +	.read_raw = &accel_read_raw,
> +	.write_raw = &accel_write_raw,
> +	.write_raw_get_fmt = &accel_write_raw_get_fmt,
> +};
> +
> +static const struct iio_chan_spec acc_channels[] = {
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_X, CHANNEL_SCAN_INDEX_X),
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Y, CHANNEL_SCAN_INDEX_Y),
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Z, CHANNEL_SCAN_INDEX_Z),
> +	IIO_CHAN_SOFT_TIMESTAMP(CHANNEL_SCAN_INDEX_TIME),
> +};
> +
> +int accel_open_calibration(struct ssp_data *data)
> +{
> +	return 0;
What's this?
> +}
> +
> +static int process_accel_data(struct iio_dev *indio_dev, void *buf,
> +			      s64 timestamp)
> +{
> +	__le64 time = 0;
> +	u8 data[16] = {0};
> +	const int len = SSP_ACCELEROMETER_SIZE;
> +
> +	if (indio_dev->scan_bytes == 0)
> +		return indio_dev->scan_bytes;
> +
> +	memcpy(data, buf, SSP_ACCELEROMETER_SIZE);
> +
> +	if (indio_dev->scan_timestamp) {
> +		memcpy(&time, &((char *)(buf))[len], SSP_TIME_SIZE);
> +		*(s64 *)((u8 *)data +  ALIGN(len, sizeof(s64))) =
> +			timestamp + le64_to_cpu(time) * 1000000;
> +	}
> +
> +	iio_push_to_buffers(indio_dev, (u8 *)data);
Use iio_push_to_buffers_with_timestamp though beware that this still needs
there to be enough space in the buffer.
> +
> +	return indio_dev->scan_bytes;
> +}
> +
> +static int ssp_accel_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	ssp_common_destroy_sensor(indio_dev);
Don't like this call as it means that, to check ordering etc, I have
to go find that function. It'll be a few more lines, but I'd much
prefer the code being here.
> +
> +	return 0;
> +}
> +
> +static int ssp_accel_probe(struct platform_device *pdev)
> +{
> +	int ret = 0;
> +	struct iio_dev *indio_dev;
> +	struct ssp_sensor_data  *spd;
> +
> +	indio_dev = iio_device_alloc(sizeof(*spd));
> +	if (IS_ERR(indio_dev)) {
> +		dev_err(&pdev->dev, "device alloc fail\n");
> +		return PTR_ERR(indio_dev);
> +	}
> +
> +	spd = iio_priv(indio_dev);
> +
> +	spd->process_data = process_accel_data;
> +	spd->prv_data = &accel_state;
> +	spd->type = SSP_ACCELEROMETER_SENSOR;
> +
> +	indio_dev->name = ssp_accel_device_name;
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->dev.of_node = pdev->dev.of_node;
> +	indio_dev->info = &ssp_accel_iio_info;
> +
> +	if (indio_dev->info == NULL)
> +		goto err_iio_alloc;
> +
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = acc_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(acc_channels);
> +
> +	ret = iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_time,
> +					 NULL, NULL);
This is interesting.  On a trigger you stash the timestamp but then as
far as I can see never do anything with it?
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Triggered buffer setup fail\n");
> +		goto err_iio_alloc;
> +	}
> +
> +	ret = ssp_sensor_setup_trigger(indio_dev, ssp_accel_device_name, spd);
What does the trigger actually do?  Normally I'd expect it to cause the
poll func elements to be called and ultimately be responsible for causing
data to be pushed into the buffers.  Here that is not the case.

You are simply using the enabling of the trigger to turn on the sensor.
Don't do this.  Drop the trigger and register a buffer directly.  See for
example how adc/ti_am335x.c does it. That way there is no 'fake' trigger
in place.  If there is no means of attaching other devices to the trigger then
there is little point in exposing it.
> +	if (ret < 0) {
> +		dev_err(&indio_dev->dev, "Trigger setup fail\n");
> +		goto err_iio_tbuffer;
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret < 0)
> +		goto err_ssp_trigger;
> +
> +	platform_set_drvdata(pdev, indio_dev);
> +
> +	ssp_register_consumer(indio_dev, SSP_ACCELEROMETER_SENSOR);
> +
> +	return 0;
> +
> +err_ssp_trigger:
> +	ssp_sensor_remove_trigger(indio_dev);
> +err_iio_tbuffer:
> +	iio_triggered_buffer_cleanup(indio_dev);
> +err_iio_alloc:
If you use a devm_iio_device_alloc call this can be dropped.  As mentioned
previously I don't like hiding the remove free in a wrapper function.
> +	iio_device_free(indio_dev);
> +
> +	return ret;
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
> +MODULE_AUTHOR("Karol Wrona <k.wwrona@samsung.com>");
> +MODULE_DESCRIPTION("Samsung sensorhub accelerometers driver");
> +MODULE_LICENSE("GPL v2");
>
