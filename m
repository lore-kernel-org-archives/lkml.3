Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3IXPlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:41:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56259 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3IXPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:41:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18oYxVlMhC3gBo7hlD4Wxh2
Date: Tue, 24 Sep 2013 08:40:48 -0700
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        r.sricharan@ti.com, holler@ahsoftware.de
Subject: Re: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
Message-ID: <20130924154048.GM2684@atomide.com>
References: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130924 01:06]:
> The OMAP GPIO controller HW requires a pin to be configured in GPIO
> input mode in order to operate as an interrupt input. Since drivers
> should not be aware of whether an interrupt pin is also a GPIO or not,
> the HW should be fully configured/enabled as an IRQ if a driver solely
> uses IRQ APIs such as request_irq(), and never calls any GPIO-related
> APIs. As such, add the missing HW setup to the OMAP GPIO controller's
> irq_chip driver.
> 
> Since this bypasses the GPIO subsystem we have to ensure that another
> caller won't be able to request the same GPIO pin that is used as an
> IRQ and set its direction as output. Requesting the GPIO and setting
> its direction as input is allowed though.

Also please mention the regression that this fixes. So far we know
that smsc911x for tobi and igep boards in mainline, and also the
MMC card detect for omap4 boards.
 
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -63,6 +63,7 @@ struct gpio_bank {
>  	struct gpio_chip chip;
>  	struct clk *dbck;
>  	u32 mod_usage;
> +	u32 irq_usage;
>  	u32 dbck_enable_mask;
>  	bool dbck_enabled;
>  	struct device *dev;
> @@ -86,6 +87,9 @@ struct gpio_bank {
>  #define GPIO_BIT(bank, gpio) (1 << GPIO_INDEX(bank, gpio))
>  #define GPIO_MOD_CTRL_BIT	BIT(0)
>  
> +#define BANK_USED(bank) (bank->mod_usage || bank->irq_usage)
> +#define LINE_USED(line, offset) (line & (1 << offset))

Hmm this patch is hard to read, maybe break it into two patches?

First you could do a patch to prepare thing by introducing
BANK_USED and LINE_USED.

> +static int gpio_is_input(struct gpio_bank *bank, int mask)
> +{
> +	void __iomem *reg = bank->base + bank->regs->direction;
> +
> +	return __raw_readl(reg) & mask;
> +}

And also move gpio_is_input() around in the first patch.

Then the second patch for the fix would probably be much
easier to read.

Regards,

Tony
