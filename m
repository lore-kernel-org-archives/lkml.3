Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3JYLUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:20:38 -0400
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:45047 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752164Ab3JYLUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:20:36 -0400
Date: Fri, 25 Oct 2013 13:13:12 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] backlight: atmel-pwm-bl: refactor gpio_on handling
Message-ID: <20131025111312.GU18477@ns203013.ovh.net>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1382522143-32072-9-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382522143-32072-9-git-send-email-jhovold@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 5896337813075700558
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
> Add helper function to control the gpio_on signal.
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

ok
> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> index ffc30d2..1277e0c 100644
> --- a/drivers/video/backlight/atmel-pwm-bl.c
> +++ b/drivers/video/backlight/atmel-pwm-bl.c
> @@ -26,6 +26,14 @@ struct atmel_pwm_bl {
>  	int					gpio_on;
>  };
>  
> +static void atmel_pwm_bl_set_gpio_on(struct atmel_pwm_bl *pwmbl, int on)
> +{
> +	if (!gpio_is_valid(pwmbl->gpio_on))
> +		return;
> +
> +	gpio_set_value(pwmbl->gpio_on, on ^ pwmbl->pdata->on_active_low);
> +}
> +
>  static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
>  {
>  	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
> @@ -48,19 +56,13 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
>  		pwm_duty = pwmbl->pdata->pwm_duty_min;
>  
>  	if (!intensity) {
> -		if (gpio_is_valid(pwmbl->gpio_on)) {
> -			gpio_set_value(pwmbl->gpio_on,
> -					0 ^ pwmbl->pdata->on_active_low);
> -		}
> +		atmel_pwm_bl_set_gpio_on(pwmbl, 0);
>  		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
>  		pwm_channel_disable(&pwmbl->pwmc);
>  	} else {
>  		pwm_channel_enable(&pwmbl->pwmc);
>  		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
> -		if (gpio_is_valid(pwmbl->gpio_on)) {
> -			gpio_set_value(pwmbl->gpio_on,
> -					1 ^ pwmbl->pdata->on_active_low);
> -		}
> +		atmel_pwm_bl_set_gpio_on(pwmbl, 1);
>  	}
>  
>  	return 0;
> @@ -196,10 +198,7 @@ static int atmel_pwm_bl_remove(struct platform_device *pdev)
>  {
>  	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
>  
> -	if (gpio_is_valid(pwmbl->gpio_on)) {
> -		gpio_set_value(pwmbl->gpio_on,
> -					0 ^ pwmbl->pdata->on_active_low);
> -	}
> +	atmel_pwm_bl_set_gpio_on(pwmbl, 0);
>  	pwm_channel_disable(&pwmbl->pwmc);
>  	pwm_channel_free(&pwmbl->pwmc);
>  
> -- 
> 1.8.4
> 
