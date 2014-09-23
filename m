Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaIWLv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:51:56 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:43756 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaIWLvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:51:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Sep 2014 13:51:17 +0200
From: Stefan Agner <stefan@agner.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] gpio: vf610: add gpiolib/IRQ chip driver for Vybird
In-Reply-To: <CACRpkdaNbTj+hXtNFZ6DqosHPfHg2G+X2Cb_S_15mULpdebgrQ@mail.gmail.com>
References: <cover.1410020458.git.stefan@agner.ch>
 <ff236f6dab7f3408551f8f4b0345e62b37fd99c5.1410020459.git.stefan@agner.ch>
 <CACRpkdaNbTj+hXtNFZ6DqosHPfHg2G+X2Cb_S_15mULpdebgrQ@mail.gmail.com>
Message-ID: <a7c933339713dc1783770faf1eceb734@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Thanks for your review!

Am 2014-09-23 11:58, schrieb Linus Walleij:
> On Sat, Sep 6, 2014 at 6:25 PM, Stefan Agner <stefan@agner.ch> wrote:
> 
>> Add a gpiolib and IRQ chip driver for Vybrid ARM SoC using the
>> Vybrid's GPIO and PORT module. The driver is instanced once per
>> each GPIO/PORT module pair and handles 32 GPIO's.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
> (...)
>>  obj-$(CONFIG_GPIO_UCB1400)     += gpio-ucb1400.o
>> +obj-$(CONFIG_GPIO_VF610)       += gpio-vf610.o
> 
> Some like to keep GPIOs tightly associated with a pin controller
> in a file next to the pin controller.
> 
> I.e. in drivers/pinctrl/freescale/gpio-vf610.c
> 
> But this works too. Any preference?

The other Freescale GPIO drivers (e.g. gpio-mxs.c/gpio-mxc.c) are
located under drivers/gpio/ hence I would prefer to leave them there,
even we use pinctrl here. Unless someone at Freescale has another
opinion on this?


> 
>> +#define GPIO_PER_PORT          32
> 
> Very generic define. VF610_GPIOS_PER_PORT?

Agreed

> 
>> +struct vf610_gpio_port {
>> +       struct gpio_chip gc;
>> +       void __iomem *base;
>> +       void __iomem *gpio_base;
>> +       u8 irqc[GPIO_PER_PORT];
>> +       int irq;
> 
> irq? Why do you need to keep this around?
> 
>> +static const struct of_device_id vf610_gpio_dt_ids[] = {
>> +       { .compatible = "fsl,vf610-gpio" },
>> +       { /* sentinel */ }
>> +};
>> +
>> +static inline void vf610_gpio_writel(u32 val, void __iomem *reg)
>> +{
>> +       __raw_writel(val, reg);
> 
> Use writel_relaxed() instead unless you can explain why you want this.
> 
> (Same for all occurences.)

Agreed, I have don't know why I used the __raw variant here. I think its
because copied this two stubs from gpio-tegra.c.

> 
>> +static int vf610_gpio_get(struct gpio_chip *gc, unsigned int gpio)
>> +{
>> +       struct vf610_gpio_port *port =
>> +               container_of(gc, struct vf610_gpio_port, gc);
>> +
>> +       return !!(vf610_gpio_readl(port->gpio_base + GPIO_PDIR) & 1 << gpio);
> 
> #include <linux/bitops.h>
> 
> ... & BIT(gpio)
> 
>> +static void vf610_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
>> +{
>> +       struct vf610_gpio_port *port =
>> +               container_of(gc, struct vf610_gpio_port, gc);
>> +       unsigned long mask = 1 << gpio;
> 
> = BIT(gpio);
> 
>> +static void vf610_gpio_irq_handler(u32 irq, struct irq_desc *desc)
>> +{
>> +       struct vf610_gpio_port *port = irq_get_handler_data(irq);
>> +       struct irq_chip *chip = irq_desc_get_chip(desc);
>> +       int pin;
>> +       unsigned long irq_isfr;
>> +
>> +       chained_irq_enter(chip, desc);
>> +
>> +       irq_isfr = vf610_gpio_readl(port->base + PORT_ISFR);
>> +
>> +       for_each_set_bit(pin, &irq_isfr, GPIO_PER_PORT) {
>> +               vf610_gpio_writel(1 << pin, port->base + PORT_ISFR);
> 
> BIT(pin)
> 
> (etc)

Ok, will replace those bit operations.

> 
>> +       port->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
>> +       if (port->irq == NO_IRQ)
>> +               return -ENODEV;
> 
> Can't you just use a local int irq; variable for this?
> 
>> +static int __init gpio_vf610_init(void)
>> +{
>> +       return platform_driver_register(&vf610_gpio_driver);
>> +}
>> +postcore_initcall(gpio_vf610_init);
> 
> postcore again. I don't like this, can you get rid of it?

I guess we could load this driver easily a bit later. IMHO, since lots
of other driver use GPIO's, we should it load before all the drivers
gets loaded (before device_initcall).

Most GPIO driver do this, some statistic again:
$ grep -h -o ".*_initcall" drivers/gpio/*.c | sort | uniq -c | sort -n
-r
     33 subsys_initcall
     14 postcore_initcall
      2 device_initcall
      2 arch_initcall
      1 late_initcall
      1 core_initcall

My proposal:
Use subsys_initcall (which is called after arch_initcall) in this GPIO
driver and leave the pinctrl driver as arch_initcall. This way we are
absolutely sure that the GPIO driver gets loaded after the pinctrl and
also leave the pinctrl at its current value.

--
Stefan


> 
> Overall the driver looks very nice except for these nitty gritty details.
> 
> Yours,
> Linus Walleij
