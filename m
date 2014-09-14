Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaINRJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:09:46 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55550 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaINRJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:09:44 -0400
Message-ID: <5415CBD4.7050103@kernel.org>
Date: Sun, 14 Sep 2014 18:09:40 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 6/6] iio: sensorhub: Add sensorhub gyroscope sensor
References: <1409756150-30889-1-git-send-email-k.wrona@samsung.com> <1409756150-30889-7-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1409756150-30889-7-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 15:55, Karol Wrona wrote:
> This patch adds gyroscope iio driver which uses sensorhub as data
> provider.
>
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Clearly this is pretty much a clone of the accelerometer driver.
As such all the comments on that apply.

It might be possible to share more with the accelerometer driver but perhaps
it is best to wait until a few more subdrivers are in place so we can
evaluate how to reduce code repitition properly.

Jonathan
> ---
>  drivers/iio/gyro/Makefile          |    2 +
>  drivers/iio/gyro/ssp_gyro_sensor.c |  225 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 227 insertions(+)
>  create mode 100644 drivers/iio/gyro/ssp_gyro_sensor.c
>
> diff --git a/drivers/iio/gyro/Makefile b/drivers/iio/gyro/Makefile
> index 2f2752a..b9c57a0 100644
> --- a/drivers/iio/gyro/Makefile
> +++ b/drivers/iio/gyro/Makefile
> @@ -21,3 +21,5 @@ st_gyro-$(CONFIG_IIO_BUFFER) += st_gyro_buffer.o
>
>  obj-$(CONFIG_IIO_ST_GYRO_I2C_3AXIS) += st_gyro_i2c.o
>  obj-$(CONFIG_IIO_ST_GYRO_SPI_3AXIS) += st_gyro_spi.o
> +
> +obj-$(CONFIG_SSP_SENSOR_IIO) += ssp_gyro_sensor.o
> \ No newline at end of file
> diff --git a/drivers/iio/gyro/ssp_gyro_sensor.c b/drivers/iio/gyro/ssp_gyro_sensor.c
> new file mode 100644
> index 0000000..b2362a4
> --- /dev/null
> +++ b/drivers/iio/gyro/ssp_gyro_sensor.c
> @@ -0,0 +1,225 @@
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
> +#define SSP_GYROSCOPE_NAME "ssp-gyroscope"
> +static const char ssp_gyro_name[] = SSP_GYROSCOPE_NAME;
> +
> +enum gyro_3d_channel {
> +	CHANNEL_SCAN_INDEX_X,
> +	CHANNEL_SCAN_INDEX_Y,
> +	CHANNEL_SCAN_INDEX_Z,
> +	CHANNEL_SCAN_INDEX_TIME,
> +	GYRO_3D_CHANNEL_MAX,
> +};
> +
> +static int gyro_read_raw(struct iio_dev *indio_dev,
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
> +		t = ssp_get_sensor_delay(data, SSP_GYROSCOPE_SENSOR);
> +		ssp_convert_to_freq(t, val, val2);
> +		ret = IIO_VAL_INT_PLUS_MICRO;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int gyro_write_raw(struct iio_dev *indio_dev,
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
> +		ret = ssp_change_delay(data, SSP_GYROSCOPE_SENSOR, value);
> +		if (ret < 0) {
> +			dev_err(&indio_dev->dev, "gyro sensor enable fail\n");
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
> +static int gyro_write_raw_get_fmt(struct iio_dev *indio_dev,
> +			       struct iio_chan_spec const *chan,
> +			       long mask)
> +{
> +	return IIO_VAL_INT_PLUS_MICRO;
> +}
> +
> +static struct iio_info ssp_gyro_iio_info = {
> +	.read_raw = &gyro_read_raw,
> +	.write_raw = &gyro_write_raw,
> +	.write_raw_get_fmt = &gyro_write_raw_get_fmt,
> +};
> +
> +static const struct iio_chan_spec gyro_channels[] = {
> +	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_X, CHANNEL_SCAN_INDEX_X),
> +	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_Y, CHANNEL_SCAN_INDEX_Y),
> +	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_Z, CHANNEL_SCAN_INDEX_Z),
> +	IIO_CHAN_SOFT_TIMESTAMP(CHANNEL_SCAN_INDEX_TIME),
> +};
> +
> +static int process_gyro_data(struct iio_dev *indio_dev, void *buf,
> +			      s64 timestamp)
> +{
> +	__le64 time = 0;
> +	u8 data[16] = {0};
> +	const int len = SSP_GYROSCOPE_SIZE;
> +
> +	if (indio_dev->scan_bytes == 0)
> +		return indio_dev->scan_bytes;
> +
> +	memcpy(data, buf, SSP_GYROSCOPE_SIZE);
> +
> +	if (indio_dev->scan_timestamp) {
> +		memcpy(&time, &((char *)(buf))[len], SSP_TIME_SIZE);
> +		*(s64 *)((u8 *)data + ALIGN(len, sizeof(s64))) =
> +			timestamp + le64_to_cpu(time) * 1000000;
> +	}
> +
> +	iio_push_to_buffers(indio_dev, (u8 *)data);
> +
> +	return indio_dev->scan_bytes;
> +}
> +
> +static int ssp_gyro_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	ssp_common_destroy_sensor(indio_dev);
> +
> +	return 0;
> +}
> +
> +static int ssp_gyro_probe(struct platform_device *pdev)
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
> +	spd->process_data = process_gyro_data;
> +	spd->type = SSP_GYROSCOPE_SENSOR;
> +
> +	indio_dev->name = ssp_gyro_name;
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->info = &ssp_gyro_iio_info;
> +
> +	if (indio_dev->info == NULL)
> +		goto err_iio_alloc;
> +
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = gyro_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(gyro_channels);
> +
> +	ret = iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_time,
> +					 NULL, NULL);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Triggered buffer setup fail\n");
> +		goto err_iio_alloc;
> +	}
> +
> +	ret = ssp_sensor_setup_trigger(indio_dev, ssp_gyro_name, spd);
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
> +	ssp_register_consumer(indio_dev, SSP_GYROSCOPE_SENSOR);
> +
> +	return 0;
> +
> +err_ssp_trigger:
> +	ssp_sensor_remove_trigger(indio_dev);
> +err_iio_tbuffer:
> +	iio_triggered_buffer_cleanup(indio_dev);
> +err_iio_alloc:
> +	iio_device_free(indio_dev);
> +
> +	return ret;
> +}
> +
> +
> +static const struct of_device_id ssp_gyro_id_table[] = {
> +	{
> +		.compatible = "samsung,mpu6500-gyro",
> +	},
> +	{},
> +};
> +
> +static struct platform_driver ssp_gyro_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = SSP_GYROSCOPE_NAME,
> +		.of_match_table = ssp_gyro_id_table,
> +	},
> +	.probe = ssp_gyro_probe,
> +	.remove =  ssp_gyro_remove,
> +};
> +
> +module_platform_driver(ssp_gyro_driver);
> +
> +MODULE_AUTHOR("Karol Wrona <k.wwrona@samsung.com>");
> +MODULE_DESCRIPTION("Samsung sensorhub gyroscopes driver");
> +MODULE_LICENSE("GPL v2");
>
