Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaGGLpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:45:06 -0400
Received: from gloria.sntech.de ([95.129.55.99]:54512 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbaGGLpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:45:03 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] power: generic-adc-battery: use devm_kcalloc for psy->properties
Date: Mon, 07 Jul 2014 13:46:27 +0200
Message-ID: <2334092.40gIsm1RaB@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <3453746.GBc4Nvx1gU@phil>
References: <3453746.GBc4Nvx1gU@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 16. Mai 2014, 15:12:50 schrieb Heiko Stübner:
> From: Heiko Stuebner <heiko.stuebner@bq.com>
> 
> This reduces the amount of code spent on initialization and cleanup
> of the properties memory and also simplifies the error handling a bit.
> 
> Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>

any comments on these two patches?


Thanks
Heiko

> ---
>  drivers/power/generic-adc-battery.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/power/generic-adc-battery.c
> b/drivers/power/generic-adc-battery.c index 59a1421..540d57f 100644
> --- a/drivers/power/generic-adc-battery.c
> +++ b/drivers/power/generic-adc-battery.c
> @@ -267,13 +267,11 @@ static int gab_probe(struct platform_device *pdev)
>  	 * copying the static properties and allocating extra memory for holding
>  	 * the extra configurable properties received from platform data.
>  	 */
> -	psy->properties = kcalloc(ARRAY_SIZE(gab_props) +
> +	psy->properties = devm_kcalloc(&pdev->dev, ARRAY_SIZE(gab_props) +
>  					ARRAY_SIZE(gab_chan_name),
>  					sizeof(*psy->properties), GFP_KERNEL);
> -	if (!psy->properties) {
> -		ret = -ENOMEM;
> -		goto first_mem_fail;
> -	}
> +	if (!psy->properties)
> +		return -ENOMEM;
> 
>  	memcpy(psy->properties, gab_props, sizeof(gab_props));
>  	properties = (enum power_supply_property *)
> @@ -301,7 +299,7 @@ static int gab_probe(struct platform_device *pdev)
>  	/* none of the channels are supported so let's bail out */
>  	if (index == 0) {
>  		ret = -ENODEV;
> -		goto second_mem_fail;
> +		return ret;
>  	}
> 
>  	/*
> @@ -348,9 +346,6 @@ err_reg_fail:
>  		if (adc_bat->channel[chan])
>  			iio_channel_release(adc_bat->channel[chan]);
>  	}
> -second_mem_fail:
> -	kfree(psy->properties);
> -first_mem_fail:
>  	return ret;
>  }
> 
> @@ -372,7 +367,6 @@ static int gab_remove(struct platform_device *pdev)
>  			iio_channel_release(adc_bat->channel[chan]);
>  	}
> 
> -	kfree(adc_bat->psy.properties);
>  	cancel_delayed_work(&adc_bat->bat_work);
>  	return 0;
>  }

