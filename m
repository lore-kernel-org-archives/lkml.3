Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaIYILX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:11:23 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51799 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaIYILM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:11:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Sep 2014 10:10:31 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, kernel@pengutronix.de,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com
Subject: Re: [PATCH v2 3/5] gpio: vf610: add gpiolib/IRQ chip driver for
 Vybrid
In-Reply-To: <20140925055446.GC6405@dragon>
References: <cover.1411492954.git.stefan@agner.ch>
 <81b47949f0806a335f380be916ec88f07b31290a.1411492954.git.stefan@agner.ch>
 <20140925055446.GC6405@dragon>
Message-ID: <fc26fd2a2b95b010d43ec653b6724d7d@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-25 07:55, schrieb Shawn Guo:
> On Tue, Sep 23, 2014 at 07:37:55PM +0200, Stefan Agner wrote:
>> diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
>> new file mode 100644
>> index 0000000..6649a13
>> --- /dev/null
>> +++ b/drivers/gpio/gpio-vf610.c
>> @@ -0,0 +1,284 @@
>> +/*
>> + * vf610 GPIO support through PORT and GPIO module
>> + *
>> + * Copyright (c) 2014 Toradex AG.
>> + *
>> + * Author: Stefan Agner <stefan@agner.ch>.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/irq.h>
>> +#include <linux/bitops.h>
>> +#include <linux/gpio.h>
> 
> You might want to have the headers sort alphabetically.
> 
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/module.h>
>> +#include <asm-generic/bug.h>
> 
> Why do we need this header?
> 
>> +
>> +
> 
> One new line is enough.
> 
>> +#define VF610_GPIO_PER_PORT		32
>> +
>> +struct vf610_gpio_port {
>> +	struct gpio_chip gc;
>> +	void __iomem *base;
>> +	void __iomem *gpio_base;
>> +	u8 irqc[VF610_GPIO_PER_PORT];
>> +};
>> +
>> +#define GPIO_PDOR		0x00
>> +#define GPIO_PSOR		0x04
>> +#define GPIO_PCOR		0x08
>> +#define GPIO_PTOR		0x0c
>> +#define GPIO_PDIR		0x10
>> +
>> +#define PORT_PCR(n)		(n * 0x4)
> 
> s/n/(n)
> 
> ...
> 
>> +static int vf610_gpio_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct device_node *np = dev->of_node;
>> +	struct vf610_gpio_port *port;
>> +	struct resource *iores;
>> +	struct gpio_chip *gc;
>> +	int irq, ret;
>> +
>> +	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
>> +	if (!port)
>> +		return -ENOMEM;
>> +
>> +	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	port->base = devm_ioremap_resource(dev, iores);
>> +	if (IS_ERR(port->base))
>> +		return PTR_ERR(port->base);
>> +
>> +	iores = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +	port->gpio_base = devm_ioremap_resource(dev, iores);
>> +	if (IS_ERR(port->gpio_base))
>> +		return PTR_ERR(port->gpio_base);
>> +
>> +	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> 
> Why not platform_get_irq()?

I thought we need that mapping, but this is done dynamically when using
gpiochip_irqchip_add.

> 
>> +	if (irq == NO_IRQ)
>> +		return -ENODEV;
> 
> Instead of using NO_IRQ, we should check if irq is a negative value and
> propagate the value as the return, something like:
> 
> 	if (irq < 0)
> 		return irq;
> 

Agreed on everything, will fix that.

> 
>> +
>> +	gc = &port->gc;
>> +	gc->of_node = np;
>> +	gc->dev = dev;
>> +	gc->label = "vf610-gpio",
>> +	gc->ngpio = VF610_GPIO_PER_PORT,
>> +	gc->base = of_alias_get_id(np, "gpio") * VF610_GPIO_PER_PORT;
>> +
>> +	gc->request = vf610_gpio_request,
>> +	gc->free = vf610_gpio_free,
>> +	gc->direction_input = vf610_gpio_direction_input,
>> +	gc->get = vf610_gpio_get,
>> +	gc->direction_output = vf610_gpio_direction_output,
>> +	gc->set = vf610_gpio_set,
>> +
>> +	ret = gpiochip_add(gc);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* Clear the interrupt status register for all GPIO's */
>> +	vf610_gpio_writel(~0, port->base + PORT_ISFR);
>> +
>> +	ret = gpiochip_irqchip_add(gc, &vf610_gpio_irq_chip, 0,
>> +				   handle_simple_irq, IRQ_TYPE_NONE);
>> +	if (ret) {
>> +		dev_err(dev, "failed to add irqchip\n");
>> +		gpiochip_remove(gc);
>> +		return ret;
>> +	}
>> +	gpiochip_set_chained_irqchip(gc, &vf610_gpio_irq_chip, irq,
>> +				     vf610_gpio_irq_handler);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver vf610_gpio_driver = {
>> +	.driver		= {
>> +		.name	= "gpio-vf610",
>> +		.owner	= THIS_MODULE,
>> +		.of_match_table = vf610_gpio_dt_ids,
>> +	},
>> +	.probe		= vf610_gpio_probe,
>> +};
>> +
>> +static int __init gpio_vf610_init(void)
>> +{
>> +	return platform_driver_register(&vf610_gpio_driver);
>> +}
>> +subsys_initcall(gpio_vf610_init);
>> +
>> +MODULE_AUTHOR("Stefan Agner <stefan@agner.ch>");
>> +MODULE_DESCRIPTION("Freescale VF610 GPIO");
>> +MODULE_LICENSE("GPL v2");
>> --
>> 2.1.0
>>
