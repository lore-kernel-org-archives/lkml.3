Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3IWQpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:45:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57710 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3IWQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:45:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/7b2Asz5WuZrsPgOB7X7zW
Date: Mon, 23 Sep 2013 09:45:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Jon Hunter <jgchunter@gmail.com>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ
Message-ID: <20130923164519.GF2684@atomide.com>
References: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130922 07:49]:
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -420,6 +420,29 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
>  	return 0;
>  }
>  
> +static void _set_gpio_mode(struct gpio_bank *bank, unsigned offset)
> +{
> +	if (bank->regs->pinctrl) {
> +		void __iomem *reg = bank->base + bank->regs->pinctrl;
> +
> +		/* Claim the pin for MPU */
> +		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
> +	}
> +
> +	if (bank->regs->ctrl && !bank->mod_usage) {
> +		void __iomem *reg = bank->base + bank->regs->ctrl;
> +		u32 ctrl;
> +
> +		ctrl = __raw_readl(reg);
> +		/* Module is enabled, clocks are not gated */
> +		ctrl &= ~GPIO_MOD_CTRL_BIT;
> +		__raw_writel(ctrl, reg);
> +		bank->context.ctrl = ctrl;
> +	}
> +
> +	bank->mod_usage |= 1 << offset;
> +}
> +
>  static int gpio_irq_type(struct irq_data *d, unsigned type)
>  {
>  	struct gpio_bank *bank = irq_data_get_irq_chip_data(d);
> @@ -427,8 +450,8 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
>  	int retval;
>  	unsigned long flags;
>  
> -	if (WARN_ON(!bank->mod_usage))
> -		return -EINVAL;
> +	if (!bank->mod_usage)
> +		pm_runtime_get_sync(bank->dev);
>  
>  #ifdef CONFIG_ARCH_OMAP1
>  	if (d->irq > IH_MPUIO_BASE)
> @@ -438,6 +461,11 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
>  	if (!gpio)
>  		gpio = irq_to_gpio(bank, d->hwirq);
>  
> +	spin_lock_irqsave(&bank->lock, flags);
> +	_set_gpio_mode(bank, GPIO_INDEX(bank, gpio));
> +	_set_gpio_direction(bank, GPIO_INDEX(bank, gpio), 1);
> +	spin_unlock_irqrestore(&bank->lock, flags);
> +
>  	if (type & ~IRQ_TYPE_SENSE_MASK)
>  		return -EINVAL;
>  

Hmm does this still work for legacy platform data based
drivers that are doing gpio_request() first?

And what's the path for clearing things for PM when free_irq()
gets called? It seems that this would leave the GPIO bank
enabled causing a PM regression?

Other than the two concerns above it seems that this might
be the way to go to fix the regression for the -rc cycle.

Regards,

Tony
