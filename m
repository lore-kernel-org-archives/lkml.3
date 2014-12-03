Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaLCX3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:29:36 -0500
Received: from mout.gmx.net ([212.227.17.22]:52384 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaLCX3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:29:34 -0500
Message-ID: <547F9CD1.2030707@gmx.de>
Date: Thu, 04 Dec 2014 00:29:21 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 4/5] iio: sensorhub: Add sensorhub accelerometer sensor
References: <1416593957-19788-1-git-send-email-k.wrona@samsung.com> <1416593957-19788-5-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1416593957-19788-5-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V03:K0:q3UaKUSYQVPc6jV9jwVJ8qs95Ne2MRjKTEwbbujWZuT5N3sMMXh
 lzvbgEpp/UqzNh4qc6ymsRCOGCgMzafxmD/BuqIs+RIJzqw1UdzAtGgegt2Wr0kHJppm+Jx
 Rq52KtiHUTWw5nkqX4Kp133bB1b8rSxE/CRARfMk4blCpWjcs3HSmPgqoV26gRA1KsLfZaq
 bjszVKkHM3igcqcX4I8QA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Wrona schrieb am 21.11.2014 um 19:19:
> This patch adds accelerometer iio driver which uses sensorhub as data
> provider.
> 
Since the next patch is almost a copy of this one, most comments apply there, as well. As mentioned earlier, the ssp_ prefix is missing here in some cases. Other issues inline.
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/accel/Makefile           |    2 +
>  drivers/iio/accel/ssp_accel_sensor.c |  223 ++++++++++++++++++++++++++++++++++
>  2 files changed, 225 insertions(+)
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
Maintain alphabetic order and common config name scheme.
> diff --git a/drivers/iio/accel/ssp_accel_sensor.c b/drivers/iio/accel/ssp_accel_sensor.c
> new file mode 100644
> index 0000000..e167479
> --- /dev/null
> +++ b/drivers/iio/accel/ssp_accel_sensor.c
> @@ -0,0 +1,223 @@
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
> +#define CHANNEL_COUNT 3
> +
> +#define SSP_ACCEL_NAME "ssp-accelrometer"
Typo: ssp-accelerometer
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
> +static int accel_read_raw(struct iio_dev *indio_dev,
> +			  struct iio_chan_spec const *chan,
> +			  int *val,
> +			  int *val2,
> +			  long mask)
It's common practice to put these 3 parameters in one line.
> +{
> +	int ret;
ret is not needed.
> +	u32 t;
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_SAMP_FREQ:
> +		t = ssp_get_sensor_delay(data, SSP_ACCELEROMETER_SENSOR);
> +		ssp_convert_to_freq(t, val, val2);
> +		ret = IIO_VAL_INT_PLUS_MICRO;
Simply return IIO_VAL_INT_PLUS_MICRO here.
> +		break;
> +	default:
> +		ret = -EINVAL;
Simply return -EINVAL here and drop return below, or break here and
return -EINVAL below.
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
Consolidate parameters in one line.
> +{
> +	int ret, value;
ret could be used instead of value, making it obsolete.
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_SAMP_FREQ:
> +		value = ssp_convert_to_time(val, val2);
> +		ret = ssp_change_delay(data, SSP_ACCELEROMETER_SENSOR, value);
> +		if (ret < 0) {
> +			dev_err(&indio_dev->dev, "accel sensor enable fail\n");
> +			ret = -EINVAL;
Pass up real error code.
> +		}
		return ret;
> +		break;
> +	default:
> +		ret = -EINVAL;
Same here. Directly return here and drop return below, or just break here and
return -EINVAL below.
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static struct iio_info ssp_accel_iio_info = {
> +	.read_raw = &accel_read_raw,
> +	.write_raw = &accel_write_raw,
> +};
> +
> +static const struct iio_chan_spec acc_channels[] = {
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_X, CHANNEL_SCAN_INDEX_X),
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Y, CHANNEL_SCAN_INDEX_Y),
> +	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Z, CHANNEL_SCAN_INDEX_Z),
> +	IIO_CHAN_SOFT_TIMESTAMP(CHANNEL_SCAN_INDEX_TIME),
> +};
> +
> +static int process_accel_data(struct iio_dev *indio_dev, void *buf,
> +			      int64_t timestamp)
> +{
> +	__le32 time = 0;
No need to initialize time.
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
> +
> +	memcpy(data, buf, len);
> +
> +	if (indio_dev->scan_timestamp) {
> +		memcpy(&time, &((char *)buf)[len], SSP_TIME_SIZE);
> +		calculated_time =
> +			timestamp + (int64_t)le32_to_cpu(time) * 1000000;
> +	}
> +
> +	ret = iio_push_to_buffers_with_timestamp(indio_dev, data,
> +						  calculated_time);
Improve indentation.
> +
> +	kfree(data);
> +
> +	return ret;
> +}
> +
Weird to have _remove() defined before _probe()
> +static int ssp_accel_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	iio_buffer_unregister(indio_dev);
> +	iio_kfifo_free(indio_dev->buffer);
> +	iio_device_unregister(indio_dev);
Move up iio_device_unregister to be first operation?
> +	iio_device_free(indio_dev);
> +
> +	return 0;
> +}
> +
> +static const struct iio_buffer_setup_ops accel_buffer_ops = {
> +	.postenable = &ssp_common_buffer_postenable,
> +	.predisable = &ssp_common_buffer_predisable,
> +};
> +
> +static int ssp_accel_probe(struct platform_device *pdev)
> +{
> +	int ret = 0;
No need to initialize ret.
> +	struct iio_dev *indio_dev;
> +	struct ssp_sensor_data  *spd;
Double whitespace. Instances of ssp_sensor_data are also named sdata and c in
previous patches. Please stick to one.
> +
> +	indio_dev = iio_device_alloc(sizeof(*spd));
Why not use devm_ variant?
> +	if (IS_ERR(indio_dev)) {
> +		dev_err(&pdev->dev, "device alloc fail\n");
> +		return PTR_ERR(indio_dev);
> +	}
It is ususally:
	if (!indio_dev)
		return -ENOMEM;
> +
> +	spd = iio_priv(indio_dev);
> +
> +	spd->process_data = process_accel_data;
> +	spd->type = SSP_ACCELEROMETER_SENSOR;
> +
> +	indio_dev->name = ssp_accel_device_name;
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->dev.of_node = pdev->dev.of_node;
> +	indio_dev->info = &ssp_accel_iio_info;
> +
> +	if (indio_dev->info == NULL)
How can this be NULL?
> +		goto err_iio_alloc;
> +
> +	indio_dev->modes = INDIO_BUFFER_HARDWARE;
> +	indio_dev->channels = acc_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(acc_channels);
> +
> +	ret = ssp_common_setup_buffer(indio_dev, &accel_buffer_ops);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Buffer setup fail\n");
> +		goto err_iio_alloc;
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret < 0)
> +		goto err_iio_buffer;
Move iio_device_register() down to make it last operation in probe?
> +
> +	platform_set_drvdata(pdev, indio_dev);
> +
> +	ssp_register_consumer(indio_dev, SSP_ACCELEROMETER_SENSOR);
> +
> +	return 0;
> +
> +err_iio_buffer:
> +	iio_buffer_unregister(indio_dev);
> +	iio_kfifo_free(indio_dev->buffer);
> +err_iio_alloc:
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
Double whitespace.
> +};
> +
> +module_platform_driver(ssp_accel_driver);
> +
> +MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
> +MODULE_DESCRIPTION("Samsung sensorhub accelerometers driver");
> +MODULE_LICENSE("GPL");
> 

