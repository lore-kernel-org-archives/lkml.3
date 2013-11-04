Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3KDSa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:30:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56187 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab3KDSaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:30:55 -0500
Message-ID: <5277E722.50205@ti.com>
Date: Mon, 4 Nov 2013 20:27:46 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        <devicetree@vger.kernel.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH v4 3/6] gpio: davinci: use irqdomain
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com> <1383406775-14902-4-git-send-email-prabhakar.csenng@gmail.com>
In-Reply-To: <1383406775-14902-4-git-send-email-prabhakar.csenng@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar Lad,

On 11/02/2013 05:39 PM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch converts the davinci gpio driver to use irqdomain
> support.

This patch needs to be splitted in two:
1) add IRQ domain support
2) remove intc_irq_num

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>   arch/arm/mach-davinci/da830.c              |    1 -
>   arch/arm/mach-davinci/da850.c              |    1 -
>   arch/arm/mach-davinci/dm355.c              |    1 -
>   arch/arm/mach-davinci/dm365.c              |    1 -
>   arch/arm/mach-davinci/dm644x.c             |    1 -
>   arch/arm/mach-davinci/dm646x.c             |    1 -
>   drivers/gpio/gpio-davinci.c                |   49 ++++++++++++++++++----------
>   include/linux/platform_data/gpio-davinci.h |    3 +-
>   8 files changed, 32 insertions(+), 26 deletions(-)
> 

[...]

>   
>   int __init dm646x_gpio_register(void)
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 95c6df1..bcb6d8d 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -16,6 +16,7 @@
>   #include <linux/err.h>
>   #include <linux/io.h>
>   #include <linux/irq.h>
> +#include <linux/irqdomain.h>
>   #include <linux/platform_device.h>
>   #include <linux/platform_data/gpio-davinci.h>
>   
> @@ -292,7 +293,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
>   		__raw_writel(status, &g->intstat);
>   
>   		/* now demux them to the right lowlevel handler */
> -		n = d->irq_base;
> +		n = irq_find_mapping(d->irq_domain, 0);

Sorry, but I don't understand why have you used <0> as hwirq?

All below logic may not work in case if we switch to use Linear IRQ domain :(
- irq_create_mapping() may return ANY Linux IRQ number. It means, for 
example, for bank0(ngpio=32)[0] it may return Linux_IRQ=200 or 201 or any other.
 Also, for bank3(ngpio=16)[0] it may return Linux_IRQ=150, etc.
- More over, if you call irq_create_mapping() 32 times you may NOT get
 sequential Linux_IRQ numbers.

So, the better sequence here can be smth. as below
(I can't verify it - my HW support only unbanked IRQs):

	if (irq & 1)
		mask <<= 16;

	while (1) {
		u32		status;
		int		bit;

		/* ack any irqs */
		status = __raw_readl(&g->intstat) & mask;
		if (!status)
			break;
		__raw_writel(status, &g->intstat);

		/* now demux them to the right lowlevel handler */
		while (status) {
			bit = __ffs(status);
                        status &= ~(1 << bit);
			generic_handle_irq(irq_find_mapping(d->irq_domain, bit));
		}
	}


>   		if (irq & 1) {
>   			n += 16;
>   			status >>= 16;
> @@ -313,10 +314,7 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
>   {
>   	struct davinci_gpio_controller *d = chip2controller(chip);
>   
> -	if (d->irq_base >= 0)
> -		return d->irq_base + offset;
> -	else
> -		return -ENODEV;
> +	return irq_find_mapping(d->irq_domain, offset);

I think you can use irq_create_mapping() here instead of 
irq_find_mapping(), so IRQ will be mapped/allocated on demand.
Also, it seems, above code may crash in case if SoC has >1 GPIO banks and
gpio_unbanked > 0 and someone will call gpio_to_irq(>31).

>   }
>   
>   static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
> @@ -373,6 +371,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>   	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
>   	struct davinci_gpio_platform_data *pdata = dev->platform_data;
>   	struct davinci_gpio_regs __iomem *g;
> +	int gpio_irq = 0;
>   
>   	ngpio = pdata->ngpio;
>   	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> @@ -402,9 +401,15 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>   	 */
>   	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
>   		chips[bank].chip.to_irq = gpio_to_irq_banked;
> -		chips[bank].irq_base = pdata->gpio_unbanked
> -			? -EINVAL
> -			: (pdata->intc_irq_num + gpio);
> +		if (!pdata->gpio_unbanked) {
> +			chips[bank].irq_domain =
> +				irq_domain_add_linear(NULL, 32,

Use chips[i].chip.ngpio here instead of const 32?

> +						      &irq_domain_simple_ops,

Pass &davinci_gpio_irq_ops (see below)

> +						      NULL);

Pass &chips[bank] as host_data and use .map() callback (see below)

> +
> +			if (!chips[bank].irq_domain)
> +				return -ENOMEM;
> +		}
>   	}
>   
>   	/*
> @@ -445,9 +450,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>   	 * Or, AINTC can handle IRQs for banks of 16 GPIO IRQs, which we
>   	 * then chain through our own handler.
>   	 */
> -	for (gpio = 0, irq = gpio_to_irq(0), bank = 0;
> -			gpio < ngpio;
> -			bank++, bank_irq++) {
> +	for (gpio = 0, irq = 0, bank = 0; gpio < ngpio; bank++, bank_irq++) {
>   		unsigned		i;
>   
>   		/* disabled by default, enabled only as needed */
> @@ -465,12 +468,22 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>   		 */
>   		irq_set_handler_data(bank_irq, &chips[gpio / 32]);
>   
> -		for (i = 0; i < 16 && gpio < ngpio; i++, irq++, gpio++) {
> -			irq_set_chip(irq, &gpio_irqchip);
> -			irq_set_chip_data(irq, (__force void *)g);
> -			irq_set_handler_data(irq, (void *)__gpio_mask(gpio));
> -			irq_set_handler(irq, handle_simple_irq);
> -			set_irq_flags(irq, IRQF_VALID);
> +		if (!(bank % 2))
> +			irq = 0;
> +		else
> +			irq = 16;

As I mentioned above, I think, it is not good to play with IRQ numbers here.
Only chained IRQs and <binten> can be configured in this cycle.

> +
> +		for (i = 0; i < 16 && gpio < ngpio; i++, gpio++) {
> +			int irqno =
> +				irq_create_mapping(chips[gpio / 32].irq_domain,
> +						   i + irq);
> +
> +			irq_set_chip(irqno, &gpio_irqchip);
> +			irq_set_chip_data(irqno, (__force void *)g);
> +			irq_set_handler_data(irqno, (void *)__gpio_mask(gpio));
> +			irq_set_handler(irqno, handle_simple_irq);
> +			set_irq_flags(irqno, IRQF_VALID);

It makes no sense to manually create mapping. Usually it can be done in
.map() callback of IRQ domain. Like:

static int davinci_gpio_irq_map(struct irq_domain *d, unsigned int irq,
			    irq_hw_number_t hw)
{
	struct davinci_gpio_controller *chip = d->host_data;
	unsigned gpio = chip->chip.base + hw;

	irq_set_chip_and_handler_name(irq, &gpio_irqchip, handle_simple_irq,
				      "davinci_gpio");
	irq_set_irq_type(irq, IRQ_TYPE_NONE);
	set_irq_flags(irq, IRQF_VALID);
...
	return 0;
}

static const struct irq_domain_ops davinci_gpio_irq_ops = {
	.map = davinci_gpio_irq_map,
	.xlate = irq_domain_xlate_onetwocell,
};


> +			gpio_irq++;
>   		}
>   
>   		binten |= BIT(bank);
> @@ -483,7 +496,7 @@ done:
>   	 */
>   	__raw_writel(binten, gpio_base + BINTEN);
>   
> -	printk(KERN_INFO "DaVinci: %d gpio irqs\n", irq - gpio_to_irq(0));
> +	pr_info("DaVinci: %d gpio irqs\n", gpio_irq);
>   
>   	return 0;
>   }
[...]
>   	spinlock_t		lock;
>   	void __iomem		*regs;
> 
start

Regards,
- grygorii
