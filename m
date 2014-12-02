Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaLBKIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:08:12 -0500
Received: from h1.radempa.de ([176.9.142.194]:58575 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaLBKII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:08:08 -0500
From: Harald Geyer <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iio: dht11: Add locking
In-reply-to: <1417465651-16036-1-git-send-email-richard@nod.at>
References: <1417465651-16036-1-git-send-email-richard@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Mon, 01 Dec 2014 21:27:30 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4035.1417514860.1@stardust.g4.wien.funkfeuer.at>
Date: Tue, 02 Dec 2014 11:07:40 +0100
Message-Id: <E1XvkMu-000137-KP@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

thanks for the patch. Comments inline.

Richard Weinberger writes:
> Protect the read function from concurrent reads.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/iio/humidity/dht11.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
> index 623c145..7636e66 100644
> --- a/drivers/iio/humidity/dht11.c
> +++ b/drivers/iio/humidity/dht11.c

#include <linux/mutex.h>

> @@ -57,6 +57,7 @@ struct dht11 {
>  	int				irq;
>  
>  	struct completion		completion;
> +	struct mutex			lock;
>  
>  	s64				timestamp;
>  	int				temperature;
> @@ -146,16 +147,17 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>  	int ret;
>  
>  	if (dht11->timestamp + DHT11_DATA_VALID_TIME < iio_get_time_ns()) {
> +		mutex_lock(&dht11->lock);

Move the locking out of the if statement.

BTW, it seems that there is already locking around read_raw() in the
in-kernel consumer interface but not in the sysfs interface. Is there
any reason for this difference?

Thanks,
Harald

>  		reinit_completion(&dht11->completion);
>  
>  		dht11->num_edges = 0;
>  		ret = gpio_direction_output(dht11->gpio, 0);
>  		if (ret)
> -			goto err;
> +			goto err_unlock;
>  		msleep(DHT11_START_TRANSMISSION);
>  		ret = gpio_direction_input(dht11->gpio);
>  		if (ret)
> -			goto err;
> +			goto err_unlock;
>  
>  		ret = wait_for_completion_killable_timeout(&dht11->completion,
>  								 HZ);
> @@ -166,14 +168,16 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>  			ret = -ETIMEDOUT;
>  		}
>  		if (ret < 0)
> -			goto err;
> +			goto err_unlock;
>  
>  		ret = dht11_decode(dht11,
>  				dht11->num_edges == DHT11_EDGES_PER_READ ?
>  					DHT11_EDGES_PREAMBLE :
>  					DHT11_EDGES_PREAMBLE - 2);
> +
> +		mutex_unlock(&dht11->lock);
>  		if (ret)
> -			goto err;
> +			goto out;
>  	}
>  
>  	ret = IIO_VAL_INT;
> @@ -183,9 +187,13 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>  		*val = dht11->humidity;
>  	else
>  		ret = -EINVAL;
> -err:
> +out:
>  	dht11->num_edges = -1;
>  	return ret;
> +
> +err_unlock:
> +	mutex_unlock(&dht11->lock);
> +	goto out;
>  }
>  
>  static const struct iio_info dht11_iio_info = {
> @@ -268,6 +276,7 @@ static int dht11_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, iio);
>  
>  	init_completion(&dht11->completion);
> +	mutex_init(&dht11->lock);
>  	iio->name = pdev->name;
>  	iio->dev.parent = &pdev->dev;
>  	iio->info = &dht11_iio_info;
> -- 
> 2.1.0
> 
