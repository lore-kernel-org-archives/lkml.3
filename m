Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3JYNfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:35:42 -0400
Received: from 15.mo4.mail-out.ovh.net ([91.121.62.11]:55903 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754897Ab3JYNfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:35:39 -0400
X-Greylist: delayed 8502 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2013 09:35:39 EDT
Date: Fri, 25 Oct 2013 13:11:25 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] backlight: atmel-pwm-bl: clean up probe error
 handling
Message-ID: <20131025111125.GS18477@ns203013.ovh.net>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1382522143-32072-5-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382522143-32072-5-git-send-email-jhovold@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 5865938515450768206
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:55 Wed 23 Oct     , Johan Hovold wrote:
> Clean up probe error handling by checking parameters before any
> allocations and removing an obsolete error label. Also remove
> unnecessary reset of private gpio number.
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 31 ++++++++++++-------------------
>  1 file changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> index cc5a5ed..52a8134 100644
> --- a/drivers/video/backlight/atmel-pwm-bl.c
> +++ b/drivers/video/backlight/atmel-pwm-bl.c
> @@ -126,40 +126,33 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
>  	struct atmel_pwm_bl *pwmbl;
>  	int retval;
>  
> +	pdata = dev_get_platdata(&pdev->dev);
> +	if (!pdata)
> +		return -ENODEV;
> +
> +	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
> +			pdata->pwm_duty_min > pdata->pwm_duty_max ||
> +			pdata->pwm_frequency == 0)
> +		return -EINVAL;
> +
>  	pwmbl = devm_kzalloc(&pdev->dev, sizeof(struct atmel_pwm_bl),
>  				GFP_KERNEL);
>  	if (!pwmbl)
>  		return -ENOMEM;
>  
>  	pwmbl->pdev = pdev;
> -
> -	pdata = dev_get_platdata(&pdev->dev);
> -	if (!pdata) {
> -		retval = -ENODEV;
> -		goto err_free_mem;
> -	}
> -
> -	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
> -			pdata->pwm_duty_min > pdata->pwm_duty_max ||
> -			pdata->pwm_frequency == 0) {
> -		retval = -EINVAL;
> -		goto err_free_mem;
> -	}
> -
>  	pwmbl->pdata = pdata;
>  	pwmbl->gpio_on = pdata->gpio_on;
>  
>  	retval = pwm_channel_alloc(pdata->pwm_channel, &pwmbl->pwmc);
>  	if (retval)
> -		goto err_free_mem;
> +		return retval;
>  
>  	if (pwmbl->gpio_on != -1) {
gpio_is_valid here
>  		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
>  					"gpio_atmel_pwm_bl");
> -		if (retval) {
> -			pwmbl->gpio_on = -1;
> +		if (retval)
>  			goto err_free_pwm;
> -		}
>  
>  		/* Turn display off by default. */
>  		retval = gpio_direction_output(pwmbl->gpio_on,
> @@ -197,7 +190,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
>  
>  err_free_pwm:
>  	pwm_channel_free(&pwmbl->pwmc);
> -err_free_mem:
> +
>  	return retval;
>  }
>  
> -- 
> 1.8.4
> 
