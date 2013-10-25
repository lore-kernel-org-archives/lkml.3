Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3JYLah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:30:37 -0400
Received: from 11.mo4.mail-out.ovh.net ([46.105.34.195]:40012 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751559Ab3JYLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:30:36 -0400
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2013 07:30:35 EDT
Date: Fri, 25 Oct 2013 13:15:43 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] backlight: atmel-pwm-bl: use gpio_request_one
Message-ID: <20131025111543.GV18477@ns203013.ovh.net>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1382522143-32072-10-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382522143-32072-10-git-send-email-jhovold@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 5938559059751775054
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
> Use devm_gpio_request_one rather than requesting and setting direction
> in two calls.

this is the same I do not see any advantage

and as I said for ather backligth It's wrong to enable or disable it at probe
as the bootloader might have already enable it for splash screen

Best Regards,
J.
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>:w
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> index 1277e0c..5ea2517 100644
> --- a/drivers/video/backlight/atmel-pwm-bl.c
> +++ b/drivers/video/backlight/atmel-pwm-bl.c
> @@ -124,6 +124,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
>  	const struct atmel_pwm_bl_platform_data *pdata;
>  	struct backlight_device *bldev;
>  	struct atmel_pwm_bl *pwmbl;
> +	int flags;
>  	int retval;
>  
>  	pdata = dev_get_platdata(&pdev->dev);
> @@ -149,14 +150,14 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
>  		return retval;
>  
>  	if (gpio_is_valid(pwmbl->gpio_on)) {
> -		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
> -					"gpio_atmel_pwm_bl");
> -		if (retval)
> -			goto err_free_pwm;
> -
>  		/* Turn display off by default. */
> -		retval = gpio_direction_output(pwmbl->gpio_on,
> -				0 ^ pdata->on_active_low);
> +		if (pdata->on_active_low)
> +			flags = GPIOF_OUT_INIT_HIGH;
> +		else
> +			flags = GPIOF_OUT_INIT_LOW;
> +
> +		retval = devm_gpio_request_one(&pdev->dev, pwmbl->gpio_on,
> +						flags, "gpio_atmel_pwm_bl");
>  		if (retval)
>  			goto err_free_pwm;
>  	}
> -- 
> 1.8.4
> 
