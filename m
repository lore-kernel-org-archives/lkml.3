Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3BMHJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:09:35 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35273 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3BMHJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:09:34 -0500
Date: Tue, 12 Feb 2013 23:05:50 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH v3] gpio: Add device driver for GRGPIO cores and support
 custom accessors with gpio-generic
Message-ID: <20130213070550.GA17523@lizard.gateway.2wire.net>
References: <1360653873-25368-1-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360653873-25368-1-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 08:24:33AM +0100, Andreas Larsson wrote:
> This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP
> core library from Aeroflex Gaisler.
> 
> This also adds support to gpio-generic for using custom accessor
> functions. The grgpio driver uses this to use ioread32be and iowrite32be
> for big endian register accesses.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
[...]

Overall, the changes look good, so

Reviewed-by: Anton Vorontsov <anton@enomsg.org>

Though, you might still want to fix some nits down below.

> +/*
> + * Driver for Aeroflex Gaisler GRGPIO General Purpose I/O cores.
> + *
> + * 2013 (c) Aeroflex Gaisler AB
> + *
> + * This driver supports the GRGPIO GPIO core available in the GRLIB VHDL IP core
> + * library.
> + *
> + * Full documentation of the GRGPIO core can be found here:
> + * http://www.gaisler.com/products/grlib/grip.pdf
> + *
> + * See "Documentation/devicetree/bindings/gpio/gpio-grgpio.txt" for information
> + * on open firmware properties.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * Contributors: Andreas Larsson <andreas@gaisler.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/spinlock.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_irq.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include <linux/basic_mmio_gpio.h>
> +
> +#define DRV_NAME	"grgpio"
> +
> +#define GRGPIO_MAX_NGPIO 32
> +
> +struct grgpio_regs {
> +	u32 data;	/* 0x00 */
> +	u32 output;	/* 0x04 */
> +	u32 dir;	/* 0x08 */
> +	u32 imask;	/* 0x0c */
> +	u32 ipol;	/* 0x10  */
> +	u32 iedge;	/* 0x14 */
> +	u32 bypass;	/* 0x18 */
> +	u32 __reserved;	/* 0x1c */
> +	u32 imap[8];	/* 0x20-0x3c */
> +};
> +
> +struct grgpio_priv {
> +	struct bgpio_chip bgc;
> +	struct grgpio_regs __iomem *regs;
> +
> +	u32 imask;	/* irq mask shadow register */
> +	s32 *irqmap;	/* maps offset to irq or -1 if no irq */
> +};
> +
> +static unsigned long  grgpio_read_reg(void __iomem *reg)
> +{
> +	return ioread32be(reg);
> +}
> +
> +static void grgpio_write_reg(void __iomem *reg, unsigned long data)
> +{
> +	iowrite32be(data, reg);
> +}
> +
> +static inline struct grgpio_priv *grgpio_gc_to_priv(struct gpio_chip *gc)
> +{
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);

An empty line here is needed.

> +	return container_of(bgc, struct grgpio_priv, bgc);
> +}
> +
> +static void grgpio_set_imask(struct grgpio_priv *priv, unsigned int offset,
> +			     int val)
> +{
> +	struct bgpio_chip *bgc = &priv->bgc;
> +	unsigned long mask = bgc->pin2mask(bgc, offset);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +
> +	if (val)
> +		priv->imask |= mask;
> +	else
> +		priv->imask &= ~mask;
> +	bgc->write_reg(&priv->regs->imask, priv->imask);
> +
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +}
> +
> +static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct grgpio_priv *priv = grgpio_gc_to_priv(gc);
> +	int index, irq;

One variable declaration per line.

> +
> +	if (!priv->irqmap || offset > gc->ngpio)
> +		return -ENXIO;
> +
> +	index = priv->irqmap[offset];
> +	if (index < 0)
> +		return -ENXIO;
> +
> +	irq = irq_of_parse_and_map(priv->bgc.gc.dev->of_node, index);
> +	if (irq) {
> +		/* Enable interrupt and return irq */
> +		grgpio_set_imask(priv, offset, 1);
> +		return irq;
> +	} else {
> +		return -ENXIO;
> +	}

No need for else.

> +}
> +
> +static void grgpio_free(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct grgpio_priv *priv = grgpio_gc_to_priv(gc);
> +	struct bgpio_chip *bgc = &priv->bgc;
> +	unsigned long mask = bgc->pin2mask(bgc, offset);
> +
> +	if (unlikely(priv->imask & mask))
> +		grgpio_set_imask(priv, offset, 0);
> +}
> +
> +static int grgpio_probe(struct platform_device *ofdev)
> +{
> +	struct device_node *np = ofdev->dev.of_node;
> +	struct grgpio_regs __iomem *regs;
> +	struct gpio_chip *gc;
> +	struct bgpio_chip *bgc;
> +	struct grgpio_priv *priv;
> +	struct resource *res;
> +	int err, i, size;

One variable declaration per line.

> +	u32 prop;
> +	s32 *irqmap;
> +	char *label;
> +
> +	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
> +	regs = devm_request_and_ioremap(&ofdev->dev, res);

Just wonder, is it safe to pass null res to devm_request_and_ioremap()?

> +	if (!regs) {
> +		dev_err(&ofdev->dev, "Couldn't map registers\n");
> +		return -EADDRNOTAVAIL;
> +	}
> +
> +	bgc = &priv->bgc;
> +	bgc->read_reg = grgpio_read_reg;
> +	bgc->write_reg = grgpio_write_reg;
> +	err = bgpio_init(bgc, &ofdev->dev, 4, &regs->data, &regs->output, NULL,
> +			 &regs->dir, NULL, 0);
> +	if (err) {
> +		dev_err(&ofdev->dev, "bgpio_init() failed\n");
> +		return err;
> +	}
> +
> +	priv->regs = regs;
> +	priv->imask = bgc->read_reg(&regs->imask);
> +
> +	gc = &bgc->gc;
> +	gc->of_node = np;
> +	gc->owner = THIS_MODULE;
> +	gc->to_irq = grgpio_to_irq;
> +	gc->free = grgpio_free;
> +
> +	err = of_property_read_u32(np, "base", &prop);
> +	if (err) {
> +		dev_dbg(&ofdev->dev, "No base property: use dynamic base\n");
> +		gc->base = -1;
> +	} else {
> +		gc->base = prop;
> +	}
> +
> +	err = of_property_read_u32(np, "nbits", &prop);
> +	if (err || prop <= 0 || prop > GRGPIO_MAX_NGPIO) {
> +		gc->ngpio = GRGPIO_MAX_NGPIO;
> +		dev_dbg(&ofdev->dev,
> +			"No or invalid nbits property: assume %d\n", gc->ngpio);
> +	} else {
> +		gc->ngpio = prop;
> +	}
> +
> +	irqmap = (s32 *)of_get_property(np, "irqmap", &size);
> +	if (irqmap) {
> +		if (size < gc->ngpio) {
> +			dev_err(&ofdev->dev,
> +				"irqmap shorter than ngpio (%d < %d)\n",
> +				size, gc->ngpio);
> +			return -EINVAL;
> +		}
> +
> +		priv->irqmap = devm_kzalloc(&ofdev->dev,
> +					    gc->ngpio * sizeof(s32),
> +					    GFP_KERNEL);
> +		if (!priv->irqmap)
> +			return -ENOMEM;
> +
> +		for (i = 0; i < gc->ngpio; i++)
> +			priv->irqmap[i] = irqmap[i];
> +	} else {
> +		dev_dbg(&ofdev->dev, "No irqmap\n");
> +	}
> +
> +	label = kstrdup(np->full_name, GFP_KERNEL);
> +	if (label)
> +		gc->label = label;

Do we need to free label? If not, having a comment would be awesome. :)
And should we print a warning for !label case?

> +
> +	platform_set_drvdata(ofdev, priv);
> +
> +	err = gpiochip_add(gc);
> +	if (err) {
> +		dev_err(&ofdev->dev, "Couldn't add gpiochip\n");
> +		return err;
> +	}
> +
> +	dev_info(&ofdev->dev, "regs=0x%p, base=%d, npgio=%d\n",
> +		 priv->regs, gc->base, gc->ngpio);
> +
> +	return 0;
> +}
> +
> +static int grgpio_remove(struct platform_device *ofdev)
> +{
> +	dev_set_drvdata(&ofdev->dev, NULL);

Is this really needed?

> +	return 0;
> +}
> +
> +static struct of_device_id grgpio_match[] = {
> +	{.name = "GAISLER_GPIO"},
> +	{.name = "01_01a"},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, grgpio_match);
> +
> +static struct platform_driver grgpio_driver = {
> +	.driver = {
> +		.name = DRV_NAME,

I guess you don't need DRV_NAME definition, you use it just once...

> +		.owner = THIS_MODULE,
> +		.of_match_table = grgpio_match,
> +	},
> +	.probe = grgpio_probe,
> +	.remove = grgpio_remove,
> +};
> +
No need for this empty line, I think.

> +module_platform_driver(grgpio_driver);
> +
> +MODULE_AUTHOR("Aeroflex Gaisler AB.");
> +MODULE_DESCRIPTION("Driver for Aeroflex Gaisler GRGPIO");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.0.4

Thanks!

Anton
