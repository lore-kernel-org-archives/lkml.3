Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaIWJ6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:58:03 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:58133 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaIWJ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:58:00 -0400
MIME-Version: 1.0
In-Reply-To: <ff236f6dab7f3408551f8f4b0345e62b37fd99c5.1410020459.git.stefan@agner.ch>
References: <cover.1410020458.git.stefan@agner.ch>
	<ff236f6dab7f3408551f8f4b0345e62b37fd99c5.1410020459.git.stefan@agner.ch>
Date: Tue, 23 Sep 2014 11:58:00 +0200
Message-ID: <CACRpkdaNbTj+hXtNFZ6DqosHPfHg2G+X2Cb_S_15mULpdebgrQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: vf610: add gpiolib/IRQ chip driver for Vybird
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 6:25 PM, Stefan Agner <stefan@agner.ch> wrote:

> Add a gpiolib and IRQ chip driver for Vybrid ARM SoC using the
> Vybrid's GPIO and PORT module. The driver is instanced once per
> each GPIO/PORT module pair and handles 32 GPIO's.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
(...)
>  obj-$(CONFIG_GPIO_UCB1400)     += gpio-ucb1400.o
> +obj-$(CONFIG_GPIO_VF610)       += gpio-vf610.o

Some like to keep GPIOs tightly associated with a pin controller
in a file next to the pin controller.

I.e. in drivers/pinctrl/freescale/gpio-vf610.c

But this works too. Any preference?

> +#define GPIO_PER_PORT          32

Very generic define. VF610_GPIOS_PER_PORT?

> +struct vf610_gpio_port {
> +       struct gpio_chip gc;
> +       void __iomem *base;
> +       void __iomem *gpio_base;
> +       u8 irqc[GPIO_PER_PORT];
> +       int irq;

irq? Why do you need to keep this around?

> +static const struct of_device_id vf610_gpio_dt_ids[] = {
> +       { .compatible = "fsl,vf610-gpio" },
> +       { /* sentinel */ }
> +};
> +
> +static inline void vf610_gpio_writel(u32 val, void __iomem *reg)
> +{
> +       __raw_writel(val, reg);

Use writel_relaxed() instead unless you can explain why you want this.

(Same for all occurences.)

> +static int vf610_gpio_get(struct gpio_chip *gc, unsigned int gpio)
> +{
> +       struct vf610_gpio_port *port =
> +               container_of(gc, struct vf610_gpio_port, gc);
> +
> +       return !!(vf610_gpio_readl(port->gpio_base + GPIO_PDIR) & 1 << gpio);

#include <linux/bitops.h>

... & BIT(gpio)

> +static void vf610_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
> +{
> +       struct vf610_gpio_port *port =
> +               container_of(gc, struct vf610_gpio_port, gc);
> +       unsigned long mask = 1 << gpio;

= BIT(gpio);

> +static void vf610_gpio_irq_handler(u32 irq, struct irq_desc *desc)
> +{
> +       struct vf610_gpio_port *port = irq_get_handler_data(irq);
> +       struct irq_chip *chip = irq_desc_get_chip(desc);
> +       int pin;
> +       unsigned long irq_isfr;
> +
> +       chained_irq_enter(chip, desc);
> +
> +       irq_isfr = vf610_gpio_readl(port->base + PORT_ISFR);
> +
> +       for_each_set_bit(pin, &irq_isfr, GPIO_PER_PORT) {
> +               vf610_gpio_writel(1 << pin, port->base + PORT_ISFR);

BIT(pin)

(etc)

> +       port->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +       if (port->irq == NO_IRQ)
> +               return -ENODEV;

Can't you just use a local int irq; variable for this?

> +static int __init gpio_vf610_init(void)
> +{
> +       return platform_driver_register(&vf610_gpio_driver);
> +}
> +postcore_initcall(gpio_vf610_init);

postcore again. I don't like this, can you get rid of it?

Overall the driver looks very nice except for these nitty gritty details.

Yours,
Linus Walleij
