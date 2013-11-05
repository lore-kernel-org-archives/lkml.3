Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3KEVcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:32:10 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38668 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3KEVcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:32:05 -0500
Message-ID: <527963D0.1050704@gmail.com>
Date: Tue, 05 Nov 2013 22:32:00 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
To: Alan Tull <delicious.quinoa@gmail.com>, linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Heiko Stuebner <heiko@sntech.de>,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH 2/3] gpio: dwapb: add support for GPIO interrupts
References: <1383670552-17566-1-git-send-email-delicious.quinoa@gmail.com> <1383670552-17566-3-git-send-email-delicious.quinoa@gmail.com>
In-Reply-To: <1383670552-17566-3-git-send-email-delicious.quinoa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 05:55 PM, Alan Tull wrote:
> From: Jamie Iles <jamie@jamieiles.com>
>
> The controller supports interrupts on bank A (up to 8 interrupt

s/bank/port/g

> sources).  Use the generic IRQ chip to implement interrupt support for
> this bank.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>   drivers/gpio/Kconfig      |    2 +-
>   drivers/gpio/gpio-dwapb.c |  181 +++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 182 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index c5e7868..4cc26ed 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -125,7 +125,7 @@ config GPIO_DWAPB
>   	bool "Synopsys DesignWare APB GPIO driver"
>   	select GPIO_GENERIC
>   	select GENERIC_IRQ_CHIP
> -	depends on OF_GPIO
> +	depends on OF_GPIO && IRQ_DOMAIN
>   	help
>   	  Say Y or M here to build support for the Synopsys DesignWare APB
>   	  GPIO block.  This requires device tree support.
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index 3a28697..64c7183 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -10,12 +10,22 @@
>   #include <linux/init.h>
>   #include <linux/io.h>
>   #include <linux/ioport.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
>   #include <linux/module.h>
>   #include <linux/basic_mmio_gpio.h>
>   #include <linux/of.h>
>   #include <linux/of_address.h>
> +#include <linux/of_irq.h>
>   #include <linux/platform_device.h>
>
> +#define INT_EN_REG_OFFS		0x30
> +#define INT_MASK_REG_OFFS	0x34
> +#define INT_TYPE_REG_OFFS	0x38
> +#define INT_POLARITY_REG_OFFS	0x3c
> +#define INT_STATUS_REG_OFFS	0x40
> +#define EOI_REG_OFFS		0x4c

For sane register names, check [1] pp. 1271. I also suggest
to get rid of _REG_OFFS.

[1] http://www.altera.com/literature/hb/arria-v/hps.pdf

>   struct dwapb_gpio;
>
>   struct dwapb_gpio_bank {
> @@ -31,6 +41,8 @@ struct dwapb_gpio {
>   	void __iomem		*regs;
>   	struct dwapb_gpio_bank	*banks;
>   	unsigned int		nr_banks;
> +	struct irq_chip_generic	*irq_gc;
> +	unsigned long		toggle_edge;
>   };
>
>   static unsigned int dwapb_gpio_nr_banks(struct device_node *of_node)
> @@ -44,6 +56,168 @@ static unsigned int dwapb_gpio_nr_banks(struct device_node *of_node)
>   	return nr_banks;
>   }
>
> +static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +	struct dwapb_gpio_bank *bank = container_of(bgc, struct
> +						    dwapb_gpio_bank, bgc);
> +	struct dwapb_gpio *gpio = bank->gpio;
> +
> +	return irq_domain_to_irq(&gpio->irq_gc->domain, offset);
> +}
> +
> +static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
> +{
> +	u32 v = readl(gpio->regs + INT_TYPE_REG_OFFS);

s/readl/readl_relaxed/g
s/writel/writel_relaxed/g ?

> +	if (gpio_get_value(gpio->banks[0].bgc.gc.base + offs))
> +		v &= ~BIT(offs);
> +	else
> +		v |= BIT(offs);
> +
> +	writel(v, gpio->regs + INT_TYPE_REG_OFFS);
> +}
> +
> +static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
> +{
> +	struct dwapb_gpio *gpio = irq_get_handler_data(irq);
> +	u32 irq_status = readl(gpio->regs + INT_STATUS_REG_OFFS);
> +
> +	while (irq_status) {
> +		int irqoffset = fls(irq_status) - 1;
> +		int irq = irq_domain_to_irq(&gpio->irq_gc->domain, irqoffset);
> +
> +		generic_handle_irq(irq);
> +		irq_status &= ~(1 << irqoffset);
> +
> +		if (gpio->toggle_edge & BIT(irqoffset))
> +			dwapb_toggle_trigger(gpio, irqoffset);

if ((irq_get_trigger_type(irq) & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)

and get rid of ->toggle_edge cache variable.

> +	}
> +}
> +
> +static void dwapb_irq_enable(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct dwapb_gpio *gpio = gc->private;
> +
> +	u32 val = readl(gpio->regs + INT_EN_REG_OFFS);
> +	val |= 1 << d->hwirq;
> +	writel(val, gpio->regs + INT_EN_REG_OFFS);
> +}
> +
> +static void dwapb_irq_disable(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct dwapb_gpio *gpio = gc->private;
> +
> +	u32 val = readl(gpio->regs + INT_EN_REG_OFFS);
> +	val &= ~(1 << d->hwirq);
> +	writel(val, gpio->regs + INT_EN_REG_OFFS);
> +}
> +
> +static int dwapb_irq_set_type(struct irq_data *d, u32 type)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct dwapb_gpio *gpio = gc->private;
> +	int bit = d->hwirq;
> +	unsigned long level, polarity;
> +
> +	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
> +		     IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
> +		return -EINVAL;
> +
> +	level = readl(gpio->regs + INT_TYPE_REG_OFFS);
> +	polarity = readl(gpio->regs + INT_POLARITY_REG_OFFS);
> +
> +	gpio->toggle_edge &= ~BIT(bit);
> +	if (type & IRQ_TYPE_EDGE_BOTH) {
> +		gpio->toggle_edge |= BIT(bit);
> +		level |= (1 << bit);

If you remove ->toggle_edge, read current pin value here and
set next edge accordingly.

> +		dwapb_toggle_trigger(gpio, bit);
> +	} else if (type & IRQ_TYPE_EDGE_RISING) {
> +		level |= (1 << bit);
> +		polarity |= (1 << bit);
> +	} else if (type & IRQ_TYPE_EDGE_FALLING) {
> +		level |= (1 << bit);
> +		polarity &= ~(1 << bit);
> +	} else if (type & IRQ_TYPE_LEVEL_HIGH) {
> +		level &= ~(1 << bit);
> +		polarity |= (1 << bit);
> +	} else if (type & IRQ_TYPE_LEVEL_LOW) {
> +		level &= ~(1 << bit);
> +		polarity &= ~(1 << bit);
> +	}

switch (type) for the above if-else-if ?

> +	writel(level, gpio->regs + INT_TYPE_REG_OFFS);
> +	writel(polarity, gpio->regs + INT_POLARITY_REG_OFFS);
> +
> +	return 0;
> +}
> +
> +static int dwapb_create_irqchip(struct dwapb_gpio *gpio,
> +				struct dwapb_gpio_bank *bank,
> +				unsigned int irq_base)
> +{
> +	struct irq_chip_type *ct;
> +
> +	gpio->irq_gc = irq_alloc_generic_chip("gpio-dwapb", 1, irq_base,
> +					      gpio->regs, handle_level_irq);
> +	if (!gpio->irq_gc)
> +		return -EIO;
> +
> +	gpio->irq_gc->domain.of_node = of_node_get(bank->bgc.gc.of_node);
> +	gpio->irq_gc->private = gpio;
> +	ct = gpio->irq_gc->chip_types;
> +	ct->chip.irq_ack = irq_gc_ack_set_bit;
> +	ct->chip.irq_mask = irq_gc_mask_set_bit;
> +	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
> +	ct->chip.irq_set_type = dwapb_irq_set_type;
> +	ct->chip.irq_enable = dwapb_irq_enable;
> +	ct->chip.irq_disable = dwapb_irq_disable;

I can see no functional difference between enable/mask and always
enable and mask initially. If there are no objections, remove
enable/disable callbacks and mask and enable in _probe().

> +	ct->regs.ack = EOI_REG_OFFS;
> +	ct->regs.mask = INT_MASK_REG_OFFS;
> +	irq_setup_generic_chip(gpio->irq_gc, IRQ_MSK(bank->bgc.gc.ngpio),
> +			       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
> +
> +	return 0;
> +}
> +
> +static int dwapb_configure_irqs(struct dwapb_gpio *gpio,
> +				struct dwapb_gpio_bank *bank)
> +{
> +	unsigned int m, irq, ngpio = bank->bgc.gc.ngpio;
> +	int irq_base;
> +
> +	for (m = 0; m < ngpio; ++m) {
> +		irq = irq_of_parse_and_map(bank->bgc.gc.of_node, m);

Only port A can raise interrupts. Are you sure, that all IP has
one irq per gpio? As you always use the same handler, just map
all irqs passed and install the handler; no need to match against
individual gpios here.

Sebastian

> +		if (!irq && m == 0) {
> +			dev_warn(gpio->dev, "no irq for bank %s\n",
> +				 bank->bgc.gc.of_node->full_name);
> +			return -ENXIO;
> +		} else if (!irq) {
> +			break;
> +		}
> +
> +		irq_set_chained_handler(irq, dwapb_irq_handler);
> +		irq_set_handler_data(irq, gpio);
> +	}
> +	bank->bgc.gc.to_irq = dwapb_gpio_to_irq;
> +
> +	irq_base = irq_alloc_descs(-1, 0, ngpio, NUMA_NO_NODE);
> +	if (irq_base < 0)
> +		return irq_base;

I was going to mention irqdomain_linear here, but then I realized
that patch 3/3 reverts most of irq handling here and replaces it
with irqdomain. Alan, I think Jamie is fine with you mangling patches
2 and 3 into one.

> +	if (dwapb_create_irqchip(gpio, bank, irq_base))
> +		goto out_free_descs;
> +
> +	return 0;
> +
> +out_free_descs:
> +	irq_free_descs(irq_base, ngpio);
> +
> +	return -EIO;
> +}
> +
>   static int dwapb_gpio_add_bank(struct dwapb_gpio *gpio,
>   			       struct device_node *bank_np,
>   			       unsigned int offs)
> @@ -81,6 +255,13 @@ static int dwapb_gpio_add_bank(struct dwapb_gpio *gpio,
>   	bank->bgc.gc.ngpio = ngpio;
>   	bank->bgc.gc.of_node = bank_np;
>
> +	/*
> +	 * Only bank A can provide interrupts in all configurations of the IP.
> +	 */
> +	if (bank_idx == 0 &&
> +	    of_get_property(bank_np, "interrupt-controller", NULL))
> +		dwapb_configure_irqs(gpio, bank);
> +
>   	err = gpiochip_add(&bank->bgc.gc);
>   	if (err)
>   		dev_err(gpio->dev, "failed to register gpiochip for %s\n",
>

