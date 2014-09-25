Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaIYFzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:55:48 -0400
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:32878
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751160AbaIYFzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:55:46 -0400
Date: Thu, 25 Sep 2014 13:55:03 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>, <kernel@pengutronix.de>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpringlemeir@nbsps.com>
Subject: Re: [PATCH v2 3/5] gpio: vf610: add gpiolib/IRQ chip driver for
 Vybrid
Message-ID: <20140925055446.GC6405@dragon>
References: <cover.1411492954.git.stefan@agner.ch>
 <81b47949f0806a335f380be916ec88f07b31290a.1411492954.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <81b47949f0806a335f380be916ec88f07b31290a.1411492954.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [180.108.234.93]
X-ClientProxiedBy: SINPR01CA006.apcprd01.prod.exchangelabs.com (10.242.48.16)
 To DM2PR03MB350.namprd03.prod.outlook.com (10.141.54.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB350;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(189002)(51704005)(110136001)(66066001)(80022003)(74502003)(101416001)(85852003)(50466002)(105586002)(102836001)(97736003)(107046002)(77982003)(46102003)(97756001)(47776003)(81542003)(90102001)(85306004)(23726002)(74662003)(106356001)(76176999)(77096002)(92566001)(83322001)(83072002)(4396001)(64706001)(575784001)(20776003)(46406003)(19580395003)(31966008)(120916001)(79102003)(42186005)(87976001)(81342003)(83506001)(19580405001)(95666004)(10300001)(99396003)(21056001)(33716001)(54356999)(86362001)(76482002)(92726001)(50986999)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB350;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:37:55PM +0200, Stefan Agner wrote:
> diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
> new file mode 100644
> index 0000000..6649a13
> --- /dev/null
> +++ b/drivers/gpio/gpio-vf610.c
> @@ -0,0 +1,284 @@
> +/*
> + * vf610 GPIO support through PORT and GPIO module
> + *
> + * Copyright (c) 2014 Toradex AG.
> + *
> + * Author: Stefan Agner <stefan@agner.ch>.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/bitops.h>
> +#include <linux/gpio.h>

You might want to have the headers sort alphabetically.

> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +#include <linux/module.h>
> +#include <asm-generic/bug.h>

Why do we need this header?

> +
> +

One new line is enough.

> +#define VF610_GPIO_PER_PORT		32
> +
> +struct vf610_gpio_port {
> +	struct gpio_chip gc;
> +	void __iomem *base;
> +	void __iomem *gpio_base;
> +	u8 irqc[VF610_GPIO_PER_PORT];
> +};
> +
> +#define GPIO_PDOR		0x00
> +#define GPIO_PSOR		0x04
> +#define GPIO_PCOR		0x08
> +#define GPIO_PTOR		0x0c
> +#define GPIO_PDIR		0x10
> +
> +#define PORT_PCR(n)		(n * 0x4)

s/n/(n)

...

> +static int vf610_gpio_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct vf610_gpio_port *port;
> +	struct resource *iores;
> +	struct gpio_chip *gc;
> +	int irq, ret;
> +
> +	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
> +	if (!port)
> +		return -ENOMEM;
> +
> +	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	port->base = devm_ioremap_resource(dev, iores);
> +	if (IS_ERR(port->base))
> +		return PTR_ERR(port->base);
> +
> +	iores = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	port->gpio_base = devm_ioremap_resource(dev, iores);
> +	if (IS_ERR(port->gpio_base))
> +		return PTR_ERR(port->gpio_base);
> +
> +	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);

Why not platform_get_irq()?

> +	if (irq == NO_IRQ)
> +		return -ENODEV;

Instead of using NO_IRQ, we should check if irq is a negative value and
propagate the value as the return, something like:

	if (irq < 0)
		return irq;

Shawn

> +
> +	gc = &port->gc;
> +	gc->of_node = np;
> +	gc->dev = dev;
> +	gc->label = "vf610-gpio",
> +	gc->ngpio = VF610_GPIO_PER_PORT,
> +	gc->base = of_alias_get_id(np, "gpio") * VF610_GPIO_PER_PORT;
> +
> +	gc->request = vf610_gpio_request,
> +	gc->free = vf610_gpio_free,
> +	gc->direction_input = vf610_gpio_direction_input,
> +	gc->get = vf610_gpio_get,
> +	gc->direction_output = vf610_gpio_direction_output,
> +	gc->set = vf610_gpio_set,
> +
> +	ret = gpiochip_add(gc);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Clear the interrupt status register for all GPIO's */
> +	vf610_gpio_writel(~0, port->base + PORT_ISFR);
> +
> +	ret = gpiochip_irqchip_add(gc, &vf610_gpio_irq_chip, 0,
> +				   handle_simple_irq, IRQ_TYPE_NONE);
> +	if (ret) {
> +		dev_err(dev, "failed to add irqchip\n");
> +		gpiochip_remove(gc);
> +		return ret;
> +	}
> +	gpiochip_set_chained_irqchip(gc, &vf610_gpio_irq_chip, irq,
> +				     vf610_gpio_irq_handler);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver vf610_gpio_driver = {
> +	.driver		= {
> +		.name	= "gpio-vf610",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = vf610_gpio_dt_ids,
> +	},
> +	.probe		= vf610_gpio_probe,
> +};
> +
> +static int __init gpio_vf610_init(void)
> +{
> +	return platform_driver_register(&vf610_gpio_driver);
> +}
> +subsys_initcall(gpio_vf610_init);
> +
> +MODULE_AUTHOR("Stefan Agner <stefan@agner.ch>");
> +MODULE_DESCRIPTION("Freescale VF610 GPIO");
> +MODULE_LICENSE("GPL v2");
> -- 
> 2.1.0
> 
