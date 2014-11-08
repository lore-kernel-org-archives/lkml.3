Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaKHLwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 06:52:37 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37250 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaKHLwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 06:52:35 -0500
Message-ID: <545E0401.2000505@kernel.org>
Date: Sat, 08 Nov 2014 11:52:33 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>,
        "chr >> Doug Anderson" <dianders@chromium.org>,
        Thorsten Nowak <thorsten.nowak@iis.fraunhofer.de>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        "christian.strobel@iis.fraunhofer.de >> Christian Strobel" 
	<christian.strobel@iis.fraunhofer.de>
Subject: Re: [PATCH] iio: gyro: itg3200: add suspend/resume support.
References: <20141108111833.3829480c@notabene.brown>
In-Reply-To: <20141108111833.3829480c@notabene.brown>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/14 00:18, NeilBrown wrote:
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
> Signed-off-by: NeilBrown <neil@brown.name>
Hi Neil,

Looks fine to me - but you should have cc'd a few people from
the listed driver authors.  Will give them a few days to respond...

Jonathan
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

