Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3LVPmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 10:42:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45817 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab3LVPmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 10:42:42 -0500
Message-ID: <52B7080F.7000900@ti.com>
Date: Sun, 22 Dec 2013 21:11:03 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, <prabhakar.csengg@gmail.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] gpio: davinci: reuse for Keystone SoC
References: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com> <1387361272-20861-3-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1387361272-20861-3-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 December 2013 03:37 PM, Grygorii Strashko wrote:
> The similar GPIO HW block is used by keystone SoCs as
> in Davinci SoCs.
> Hence, reuse Davinci GPIO driver for Keystone taking into
> account that Keystone contains ARM GIC IRQ controller which
> is implemented using IRQ Chip.
> 
> Documentation:
> 	http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: devicetree@vger.kernel.org
> 
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../devicetree/bindings/gpio/gpio-davinci.txt      |    4 +-
>  drivers/gpio/gpio-davinci.c                        |   46 ++++++++++++++++----
>  2 files changed, 40 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> index a2e839d..4ce9862 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> @@ -1,7 +1,7 @@
> -Davinci GPIO controller bindings
> +Davinci/Keystone GPIO controller bindings
>  
>  Required Properties:
> -- compatible: should be "ti,dm6441-gpio"
> +- compatible: should be "ti,dm6441-gpio", "ti,keystone-gpio"
>  
>  - reg: Physical base address of the controller and the size of memory mapped
>         registers.
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 1b33806..38741cc 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -413,6 +413,26 @@ static const struct irq_domain_ops davinci_gpio_irq_ops = {
>  	.xlate = irq_domain_xlate_onetwocell,
>  };
>  
> +static struct irq_chip *davinci_gpio_get_irq_chip(unsigned int irq)
> +{
> +	static struct irq_chip_type gpio_unbanked;
> +
> +	gpio_unbanked = *container_of(irq_get_chip(irq),
> +				      struct irq_chip_type, chip);
> +
> +	return &gpio_unbanked.chip;
> +};
> +
> +static struct irq_chip *keystone_gpio_get_irq_chip(unsigned int irq)
> +{
> +	static struct irq_chip gpio_unbanked;
> +
> +	gpio_unbanked = *irq_get_chip(irq);
> +	return &gpio_unbanked;
> +};
> +
> +static const struct of_device_id davinci_gpio_ids[];
> +
>  /*
>   * NOTE:  for suspend/resume, probably best to make a platform_device with
>   * suspend_late/resume_resume calls hooking into results of the set_wake()
> @@ -433,6 +453,18 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>  	struct davinci_gpio_platform_data *pdata = dev->platform_data;
>  	struct davinci_gpio_regs __iomem *g;
>  	struct irq_domain	*irq_domain = NULL;
> +	const struct of_device_id *match;
> +	struct irq_chip *irq_chip;
> +	struct irq_chip *(*gpio_get_irq_chip)(unsigned int irq);
> +
> +	/*
> +	 * Use davinci_gpio_get_irq_chip by default to handle non DT cases
> +	 */
> +	gpio_get_irq_chip = davinci_gpio_get_irq_chip;
> +	match = of_match_device(of_match_ptr(davinci_gpio_ids),
> +				dev);
> +	if (match)
> +		gpio_get_irq_chip = match->data;

This produces a sparse warning:

  CHECK   drivers/gpio/gpio-davinci.c
drivers/gpio/gpio-davinci.c:467:35: warning: incorrect type in assignment (different modifiers)
drivers/gpio/gpio-davinci.c:467:35:    expected struct irq_chip *( *[assigned] gpio_get_irq_chip )( ... )
drivers/gpio/gpio-davinci.c:467:35:    got void const *const data

Thanks,
Sekhar
