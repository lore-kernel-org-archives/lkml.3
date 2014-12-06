Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaLGRn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:43:29 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39868 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaLGRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:43:22 -0500
Message-ID: <54831539.1020705@kernel.org>
Date: Sat, 06 Dec 2014 14:39:53 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 3/5] iio: common: ssp_sensors: Add sensorhub iio commons
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-4-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1417809290-9662-4-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 19:54, Karol Wrona wrote:
> This patch adds common library for sensorhub iio drivers.
> 
> Change-Id: I1038cb31c051f7e8ffde696a4121518daa5af081
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Few minor bits inline.

> ---
>  drivers/iio/common/ssp_sensors/ssp_iio.c        |   82 +++++++++++++++++++++++
>  drivers/iio/common/ssp_sensors/ssp_iio_sensor.h |   56 ++++++++++++++++
>  2 files changed, 138 insertions(+)
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio.c
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
> 
> diff --git a/drivers/iio/common/ssp_sensors/ssp_iio.c b/drivers/iio/common/ssp_sensors/ssp_iio.c
> new file mode 100644
> index 0000000..036be12
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/ssp_iio.c
> @@ -0,0 +1,82 @@
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
> +#include <linux/iio/kfifo_buf.h>
> +#include "ssp_iio_sensor.h"
> +
> +/**
> + * ssp_common_buffer_postenable() - generic postenable callback for ssp buffer
> + *
> + * @indio_dev:		iio device
> + *
> + * Returns 0 or negative value in case of error
> + */
> +int ssp_common_buffer_postenable(struct iio_dev *indio_dev)
> +{
> +	struct ssp_sensor_data *spd = iio_priv(indio_dev);
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	return ssp_enable_sensor(data, spd->type,
> +				 ssp_get_sensor_delay(data, spd->type));
> +}
> +EXPORT_SYMBOL(ssp_common_buffer_postenable);
> +
> +/**
> + * ssp_common_buffer_predisable() - generic predisable callback for ssp buffer
> + *
> + * @indio_dev:		iio device
> + *
> + * Returns 0 or negative value in case of error
> + */
> +int ssp_common_buffer_predisable(struct iio_dev *indio_dev)
> +{
> +	struct ssp_sensor_data *spd = iio_priv(indio_dev);
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	return ssp_disable_sensor(data, spd->type);
> +}
> +EXPORT_SYMBOL(ssp_common_buffer_predisable);
> +
> +/**
> + * ssp_common_setup_buffer() - creates iio kfifo and registers the buffer
> + *                             for device
> + *
> + * @indio_dev:		iio device
> + *
> + * Returns 0 or negative value in case of error
> + */
> +int ssp_common_setup_buffer(struct iio_dev *indio_dev,
> +			    const struct iio_buffer_setup_ops *ops)
> +{
> +	int ret;
> +	struct iio_buffer *buffer;
Whilst we aren't specifying a trigger, I wonder if the standard 
triggered_buffer helper can be modified to check for pollfuncs?  That
would allow us to drop this local function in favour of central support.
I'm sure we'll get more devices over time that can use it.

Maybe even a little wrapper function for the normal iio_triggered_buffer_setup
such as iio_notrigger_buffer_setup?
> +
> +	buffer = iio_kfifo_allocate(indio_dev);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	iio_device_attach_buffer(indio_dev, buffer);
> +
> +	indio_dev->setup_ops = ops;
> +
> +	ret = iio_buffer_register(indio_dev, indio_dev->channels,
> +				  indio_dev->num_channels);
> +	if (ret)
> +		iio_kfifo_free(buffer);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ssp_common_setup_buffer);
> diff --git a/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
> new file mode 100644
> index 0000000..4b79be0
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
> @@ -0,0 +1,56 @@
> +#ifndef __SSP_IIO_SENSOR_H__
> +#define __SSP_IIO_SENSOR_H__
> +
> +#define SSP_CHANNEL_AG(_type, _mod, _index) \
> +{ \
> +		.type = _type,\
> +		.modified = 1,\
> +		.channel2 = _mod,\
> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SAMP_FREQ),\
> +		.scan_index = _index,\
> +		.scan_type = {\
> +			.sign = 's',\
> +			.realbits = 16,\
Seems a little unlikely unless the device is padding appropriately. Even
then it is generally a bad idea to claim more accuracy than is real. Very
few accelerometers etc are 16 bit.  Please confirm.
> +			.storagebits = 16,\
> +			.shift = 0,\
> +			.endianness = IIO_LE,\
> +		},\
> +}
> +
> +#define SSP_DIVISOR	1000000ULL
> +#define SSP_MS_PER_S	1000
The name of the next one probably wants to indicate what it is for!
Same with divisor
> +#define SSP_DIVIDEND	(SSP_DIVISOR * SSP_MS_PER_S)
> +
> +int ssp_common_buffer_postenable(struct iio_dev *indio_dev);
> +
> +int ssp_common_buffer_predisable(struct iio_dev *indio_dev);
> +
> +int ssp_common_setup_buffer(struct iio_dev *indio_dev,
> +			    const struct iio_buffer_setup_ops *ops);
> +
> +/* Converts time in ms to frequency */
> +static inline void ssp_convert_to_freq(u32 time, int *integer_part,
> +				       int *fractional)
> +{
> +	if (time == 0) {
> +		*fractional = 0;
> +		*integer_part = 0;
> +		return;
> +	}
> +
> +	*integer_part = SSP_DIVIDEND / time;
> +	*fractional = do_div(*integer_part, SSP_DIVISOR);
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
> +	return div_u64(SSP_DIVIDEND, value);
> +}
> +#endif /* __SSP_IIO_SENSOR_H__ */
> 

