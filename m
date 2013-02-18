Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3BRJKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:10:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56244 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3BRJKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:10:10 -0500
Message-ID: <5121EFE7.7040301@ti.com>
Date: Mon, 18 Feb 2013 10:09:59 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] drivers/gpio/*twl* need call irq_free_descs when leaving
References: <511F34C3.6020406@asianux.com>
In-Reply-To: <511F34C3.6020406@asianux.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2013 08:26 AM, Chen Gang wrote:
> 
>   since already call irq_alloc_descs before,
>     we need call irq_free_descs when quiting, or resource leak.

While it is true that we need to free the descs, but this patch is not correct.
We have other issues to fix in the driver - I have not looked at the
probe/remove path yet, but the sequence is not right and also the call of
gpio_twl4030_remove() from probe is not correct.

I'll send a small series to fix these up.

> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/gpio/gpio-twl4030.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
> index 4d330e3..26aef72 100644
> --- a/drivers/gpio/gpio-twl4030.c
> +++ b/drivers/gpio/gpio-twl4030.c
> @@ -486,8 +486,10 @@ static int gpio_twl4030_probe(struct platform_device *pdev)
>  			      &irq_domain_simple_ops, NULL);
>  
>  	ret = twl4030_sih_setup(&pdev->dev, TWL4030_MODULE_GPIO, irq_base);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		irq_free_descs(irq_base, TWL4030_GPIO_MAX);
>  		return ret;
> +	}
>  
>  	priv->irq_base = irq_base;
>  
> @@ -578,6 +580,7 @@ static int gpio_twl4030_remove(struct platform_device *pdev)
>  
>  	/* REVISIT no support yet for deregistering all the IRQs */
>  	WARN_ON(1);
> +	irq_free_descs(priv->irq_base, TWL4030_GPIO_MAX);
>  	return -EIO;
>  }
>  
> 


-- 
P¨¦ter
