Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaLQWUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:20:45 -0500
Received: from mout.gmx.net ([212.227.17.21]:55076 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaLQWUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:20:44 -0500
Message-ID: <549201B6.1070502@gmx.de>
Date: Wed, 17 Dec 2014 23:20:38 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 5/5] iio: common: ssp_sensors: Add sensorhub
 gyroscope sensor
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-6-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1417809290-9662-6-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:TufW92oDnz4Zieqjhsg1n9AnK5iNOT4bSQlmab9m69U1dbI8WEg
 1+0aAKL/TqhXPvYFUMvN9ntndHckVuIi5J/o8Thpug6/IzgN1mBPWgo168SgjIZO0q1U+mL
 jvHjv19yy9ajgyGYFg+Dw+5M+TafoiI2A1zHeCGoN9JvHZrFS9hxRQx4ndLviTmStdG0LYV
 iQT3QCVbEtNBZFNmPAmfQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Wrona schrieb am 05.12.2014 um 20:54:
> This patch adds gyroscope iio driver which uses sensorhub as data
> provider.
> 
This one has got a more serious issue.
> Change-Id: Ia16bc92159d062a29957de8e62ea3fefdcd7985a
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/gyro/Makefile          |    2 +
>  drivers/iio/gyro/ssp_gyro_sensor.c |  202 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 204 insertions(+)
>  create mode 100644 drivers/iio/gyro/ssp_gyro_sensor.c
> 

> +static int ssp_gyro_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct iio_dev *indio_dev;
> +	struct ssp_sensor_data *spd;
> +
> +	indio_dev = iio_device_alloc(sizeof(*spd));
Need to use devm_iio_device_alloc(), since iio_device_free() has been dropped.
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	spd = iio_priv(indio_dev);
> +
> +	spd->process_data = ssp_process_gyro_data;
> +	spd->type = SSP_GYROSCOPE_SENSOR;
> +
> +	indio_dev->name = ssp_gyro_name;
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->info = &ssp_gyro_iio_info;
> +	indio_dev->modes = INDIO_BUFFER_HARDWARE;
> +	indio_dev->channels = ssp_gyro_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(ssp_gyro_channels);
> +
> +	ret = ssp_common_setup_buffer(indio_dev, &ssp_gyro_buffer_ops);
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
> +	};
> +
> +	/* similar to accel */
> +	ssp_register_consumer(indio_dev, SSP_GYROSCOPE_SENSOR);
> +
> +	return 0;
> +}
> +
> +static int ssp_gyro_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	iio_device_unregister(indio_dev);
> +	iio_buffer_unregister(indio_dev);
> +	iio_kfifo_free(indio_dev->buffer);
> +
> +	return 0;
> +}
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
> +	.remove = ssp_gyro_remove,
> +};
> +
> +module_platform_driver(ssp_gyro_driver);
> +
> +MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
> +MODULE_DESCRIPTION("Samsung sensorhub gyroscopes driver");
> +MODULE_LICENSE("GPL");
> 

