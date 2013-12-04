Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3LDRhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:37:13 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51281 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755004Ab3LDRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:37:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9v1fYhNVuv8rlE20febqw
Date: Wed, 4 Dec 2013 09:37:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: linus.walleij@linaro.org, peter.ujfalusi@ti.com, nm@ti.com,
        tomi.valkeinen@ti.com, balbi@ti.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] gpio: twl4030: Fix regression for twl gpio LED
 output
Message-ID: <20131204173705.GQ26766@atomide.com>
References: <1386156871-7639-1-git-send-email-rogerq@ti.com>
 <1386156871-7639-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386156871-7639-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [131204 03:35]:
> Commit 0b2aa8be introduced a regression that causes failure
> in setting LED GPO direction to OUT.
> 
> This causes USB host probe failures for Beagleboard C4.
> 
> [    2.075469] platform usb_phy_gen_xceiv.2: Driver usb_phy_gen_xceiv requests probe deferral
> [    2.090454] hsusb2_vcc: Failed to request enable GPIO510: -22
> [    2.100982] reg-fixed-voltage reg-fixed-voltage.0.auto: Failed to register regulator: -22
> [    2.109954] reg-fixed-voltage: probe of reg-fixed-voltage.0.auto failed with error -22
> 
> direction_out/direction_in must return 0 if the operation succeeded.

Uh, OK, sorry that was an unexpected side effect. We still should keep the
return values though instead of just ignoring them.
 
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
> index b97d6a6..0999ed1 100644
> --- a/drivers/gpio/gpio-twl4030.c
> +++ b/drivers/gpio/gpio-twl4030.c
> @@ -294,13 +294,13 @@ out:
>  static int twl_direction_in(struct gpio_chip *chip, unsigned offset)
>  {
>  	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
> -	int ret;
> +	int ret = 0;
>  
>  	mutex_lock(&priv->mutex);
>  	if (offset < TWL4030_GPIO_MAX)
> -		ret = twl4030_set_gpio_direction(offset, 1);
> +		twl4030_set_gpio_direction(offset, 1);
>  	else
> -		ret = -EINVAL;
> +		ret = -EINVAL;	/* LED outputs can't be set as input */
>  
>  	if (!ret)
>  		priv->direction &= ~BIT(offset);

This looks OK to me.

> @@ -354,18 +354,21 @@ static void twl_set(struct gpio_chip *chip, unsigned offset, int value)
>  static int twl_direction_out(struct gpio_chip *chip, unsigned offset, int value)
>  {
>  	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
> -	int ret = -EINVAL;
>  

Can't you just have:

	int ret = 0;

>  	mutex_lock(&priv->mutex);
>  	if (offset < TWL4030_GPIO_MAX)
> -		ret = twl4030_set_gpio_direction(offset, 0);
> +		twl4030_set_gpio_direction(offset, 0);
> +
> +	/*
> +	 *  LED gpio's i.e. offset >= TWL4030_GPIO_MAX are always output
> +	 */
>  
>  	priv->direction |= BIT(offset);
>  	mutex_unlock(&priv->mutex);
>  
>  	twl_set(chip, offset, value);
>  
> -	return ret;
> +	return 0;
>  }

Then the rest of this change is not needed and we check the return value for
twl4030_set_gpio_direction. Makes sense to keep the comment there though.

Regards,

Tony
