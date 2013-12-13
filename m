Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3LMR2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:28:15 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55735 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753312Ab3LMR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:28:14 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 64.17.244.34
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/AoEXxCqgMLb/jcII8pz9T
Date: Fri, 13 Dec 2013 09:28:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Roger Quadros <rogerq@ti.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] gpio: twl4030: fix regression for twl gpio outputs for
 led pins
Message-ID: <20131213172810.GE28184@atomide.com>
References: <1386953222-26396-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386953222-26396-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [131213 08:48]:
> Commit 0b2aa8b (gpio: twl4030: Fix regression for twl gpio output)
> introduces yet another regression by ignoring the fact that we use twl
> gpio even for LED. For example, leda (offset 18) is used for USB port2
> power on beagleboard-xm.
> 
> The original logic was supposed to setup the TWL4030 GPIO direction
> if the offset was < TWL4030_GPIO_MAX, and anything greater used
> twl4030_led_set_value as part of twl_set to setup the LED pin. However,
> with the commit mentioned above, LEDa pin request will result in fail
> as the GPIO number for LEDa is equal to TWL4030_GPIO_MAX and USB fails
> to function on beagleboard-xm. This is reported in the log as:
> hsusb2_vbus: Failed to request enable GPIO510: -22
> 
> To fix this, we should handle the fail case of
> twl4030_set_gpio_direction independent of the offset < TWL4030_GPIO_MAX
> check.

Heh again :) Linus has already queued a similar fix, see
"[PATCH v2 1/1] gpio: twl4030: Fix regression for twl gpio LED output".

Regards,

Tony



 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> Applies on v3.13-rc3
> 
> Tested on beagleboard-xm which uses ethernet over usb:
> before the patch (USB regression): http://pastebin.mozilla.org/3769443
> After this patch: http://pastebin.mozilla.org/3769454
> 
>  drivers/gpio/gpio-twl4030.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
> index b97d6a6..9242276 100644
> --- a/drivers/gpio/gpio-twl4030.c
> +++ b/drivers/gpio/gpio-twl4030.c
> @@ -354,11 +354,16 @@ static void twl_set(struct gpio_chip *chip, unsigned offset, int value)
>  static int twl_direction_out(struct gpio_chip *chip, unsigned offset, int value)
>  {
>  	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
> -	int ret = -EINVAL;
> +	int ret = 0;
>  
>  	mutex_lock(&priv->mutex);
> -	if (offset < TWL4030_GPIO_MAX)
> +	if (offset < TWL4030_GPIO_MAX) {
>  		ret = twl4030_set_gpio_direction(offset, 0);
> +		if (ret) {
> +			mutex_unlock(&priv->mutex);
> +			return ret;
> +		}
> +	}
>  
>  	priv->direction |= BIT(offset);
>  	mutex_unlock(&priv->mutex);
> -- 
> 1.7.9.5
> 
