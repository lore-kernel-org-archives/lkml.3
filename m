Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbaKSWhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:37:50 -0500
Received: from mout.gmx.net ([212.227.17.21]:52507 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492AbaKSWhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:37:47 -0500
Message-ID: <546D1BB5.8010308@gmx.de>
Date: Wed, 19 Nov 2014 23:37:41 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Jonathan Cameron <jic23@kernel.org>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>
Subject: Re: [PATCH] iio: gyro: itg3200: add suspend/resume support.
References: <20141108111833.3829480c@notabene.brown>
In-Reply-To: <20141108111833.3829480c@notabene.brown>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V03:K0:W3Lq04/pQy/JkHzSEHQJptCpeEG6dEpNOFv51y3KGb3ysl1DI53
 a7nGmua9RZkoXbiHMSNEILnm6eO90pxjAscjVT9xQ8ZjS9yZPYVSF3L4TMHpVqXdpG35e+3
 TBJdK/sKHHD2q/sl0g1L8ljAHtEtg9edWzL6Efm+YHoEovdH4uRVcajnLZzfALH32Kh2jC7
 ZhsgtquOn++uDaBDWtMHg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown schrieb am 08.11.2014 01:18:
> 
> 
> Unless we put the device to sleep when not it use, it wastes
> 6mA.
> 
> If the device is asleep on probe, the 'id' register
> sometimes mis-reads - so reset first.  If the device responds
> at all a command sent to the address, it is almost certainly
> the correct device already.
> 
Hi Neil,
I still have some question and issues, see inline.
> Signed-off-by: NeilBrown <neil@brown.name>
> 
> diff --git a/drivers/iio/gyro/itg3200_core.c b/drivers/iio/gyro/itg3200_core.c
> index 6a8020d48140..394667fb23f9 100644
> --- a/drivers/iio/gyro/itg3200_core.c
> +++ b/drivers/iio/gyro/itg3200_core.c
> @@ -223,6 +223,7 @@ static int itg3200_initial_setup(struct iio_dev *indio_dev)
>  	int ret;
>  	u8 val;
>  
> +	ret = itg3200_reset(indio_dev);
You should check possible error codes here. Also, there is still another reset issued some lines further down, although in between, there is only the register-read performed, which we see right below here - I would assume this wouldn't change anything in the device to require another reset. So, in conclusion, wouldn't it be sufficient to just move the reset part from further down up here?
>  	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_ADDRESS, &val);
>  	if (ret)
>  		goto err_ret;
> @@ -351,6 +352,35 @@ static int itg3200_remove(struct i2c_client *client)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int itg3200_suspend(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct itg3200 *st = iio_priv(indio_dev);
> +	int ret;
> +
> +	dev_dbg(&st->i2c->dev, "suspend device");
> +
> +	ret = itg3200_write_reg_8(indio_dev,
> +			ITG3200_REG_POWER_MANAGEMENT,
> +			ITG3200_SLEEP);
> +	return ret;
No need for ret, if you do it like this (fixing also some indentation issue):
	return itg3200_write_reg_8(indio_dev, ITG3200_REG_POWER_MANAGEMENT,
				   ITG3200_SLEEP);
> +}
> +
> +static int itg3200_resume(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +
> +	itg3200_reset(indio_dev);
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(itg3200_pm_ops, itg3200_suspend, itg3200_resume);
> +#define ITG3200_PM_OPS (&itg3200_pm_ops)
> +#else
> +#define ITG3200_PM_OPS NULL
> +#endif
> +
>  static const struct i2c_device_id itg3200_id[] = {
>  	{ "itg3200", 0 },
>  	{ }
> @@ -361,6 +391,7 @@ static struct i2c_driver itg3200_driver = {
>  	.driver = {
>  		.owner  = THIS_MODULE,
>  		.name	= "itg3200",
> +		.pm	= ITG3200_PM_OPS,
>  	},
>  	.id_table	= itg3200_id,
>  	.probe		= itg3200_probe,
> 

