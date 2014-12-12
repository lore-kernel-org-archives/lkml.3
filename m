Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966354AbaLLLW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:22:57 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47210 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965845AbaLLLW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:22:56 -0500
Message-ID: <548AD00E.8080301@kernel.org>
Date: Fri, 12 Dec 2014 11:22:54 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2 4/4] iio: accel: kxcjk-1013: power off device if probe
 fails
References: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com> <1418228634-10505-5-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1418228634-10505-5-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 16:23, Irina Tirdea wrote:
> When the device is initialized in probe, it is also powered on.
> If there is an error after the initialization, the device will
> remain powered on.
> 
> Power off the device in case probe fails after device initialization.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Suggested-by: Daniel Baluta <daniel.baluta@intel.com>
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Applied to the togreg branch of iio.git - initially pushed out as
testing sometime later today.

Thanks,

Jonathan
> ---
>  drivers/iio/accel/kxcjk-1013.c |   18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 0dc6ccf..a5e7d30 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -1240,21 +1240,25 @@ static int kxcjk1013_probe(struct i2c_client *client,
>  						KXCJK1013_IRQ_NAME,
>  						indio_dev);
>  		if (ret)
> -			return ret;
> +			goto err_poweroff;
>  
>  		data->dready_trig = devm_iio_trigger_alloc(&client->dev,
>  							   "%s-dev%d",
>  							   indio_dev->name,
>  							   indio_dev->id);
> -		if (!data->dready_trig)
> -			return -ENOMEM;
> +		if (!data->dready_trig) {
> +			ret = -ENOMEM;
> +			goto err_poweroff;
> +		}
>  
>  		data->motion_trig = devm_iio_trigger_alloc(&client->dev,
>  							  "%s-any-motion-dev%d",
>  							  indio_dev->name,
>  							  indio_dev->id);
> -		if (!data->motion_trig)
> -			return -ENOMEM;
> +		if (!data->motion_trig) {
> +			ret = -ENOMEM;
> +			goto err_poweroff;
> +		}
>  
>  		data->dready_trig->dev.parent = &client->dev;
>  		data->dready_trig->ops = &kxcjk1013_trigger_ops;
> @@ -1263,7 +1267,7 @@ static int kxcjk1013_probe(struct i2c_client *client,
>  		iio_trigger_get(indio_dev->trig);
>  		ret = iio_trigger_register(data->dready_trig);
>  		if (ret)
> -			return ret;
> +			goto err_poweroff;
>  
>  		data->motion_trig->dev.parent = &client->dev;
>  		data->motion_trig->ops = &kxcjk1013_trigger_ops;
> @@ -1312,6 +1316,8 @@ err_trigger_unregister:
>  		iio_trigger_unregister(data->dready_trig);
>  	if (data->motion_trig)
>  		iio_trigger_unregister(data->motion_trig);
> +err_poweroff:
> +	kxcjk1013_set_mode(data, STANDBY);
>  
>  	return ret;
>  }
> 

