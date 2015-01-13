Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbbAMIxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:53:15 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62158 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbAMIxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:53:13 -0500
MIME-Version: 1.0
In-Reply-To: <1418696307-19392-3-git-send-email-rjui@broadcom.com>
References: <rjui@broadcom.com>
	<1418696307-19392-1-git-send-email-rjui@broadcom.com>
	<1418696307-19392-3-git-send-email-rjui@broadcom.com>
Date: Tue, 13 Jan 2015 09:53:12 +0100
Message-ID: <CACRpkdYGksEseGaO49=1rUi5WBdOxwAd-F1gpgZn+BFatRCdDg@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] gpio: Cygnus: add GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Ray Jui <rjui@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>, Scott Branden <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 3:18 AM, Ray Jui <rjui@broadcom.com> wrote:

> This GPIO driver supports all 3 GPIO controllers in the Broadcom Cygnus
> SoC. The 3 GPIO controllers are 1) the ASIU GPIO controller, 2) the
> chipCommonG GPIO controller, and 3) the ALWAYS-ON GPIO controller
>
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Scott Branden <sbranden@broadcom.com>

(Big thanks to Alexandre for doing the major part of the review,
good work with following up so far!)

(...)
> +config GPIO_BCM_CYGNUS
> +       bool "Broadcom Cygnus GPIO support"
> +       depends on ARCH_BCM_CYGNUS && OF_GPIO

select GPIOLIB_IRQCHIP

See more about this below.

> +++ b/drivers/gpio/gpio-bcm-cygnus.c
> @@ -0,0 +1,607 @@
> +/*
> + * Copyright (C) 2014 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/gpio.h>
> +#include <linux/ioport.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +#include <linux/irqchip/chained_irq.h>

Skip <linux/irq.h> and <linux/irqchip/chained_irq.h>
as these move to the core with GPIOLIB_IRQCHIP

> +#define CYGNUS_GPIO_DATA_IN_OFFSET   0x00
> +#define CYGNUS_GPIO_DATA_OUT_OFFSET  0x04
> +#define CYGNUS_GPIO_OUT_EN_OFFSET    0x08
> +#define CYGNUS_GPIO_IN_TYPE_OFFSET   0x0c
> +#define CYGNUS_GPIO_INT_DE_OFFSET    0x10
> +#define CYGNUS_GPIO_INT_EDGE_OFFSET  0x14
> +#define CYGNUS_GPIO_INT_MSK_OFFSET   0x18
> +#define CYGNUS_GPIO_INT_STAT_OFFSET  0x1c
> +#define CYGNUS_GPIO_INT_MSTAT_OFFSET 0x20
> +#define CYGNUS_GPIO_INT_CLR_OFFSET   0x24
> +#define CYGNUS_GPIO_PAD_RES_OFFSET   0x34
> +#define CYGNUS_GPIO_RES_EN_OFFSET    0x38
> +
> +/* drive strength control for ASIU GPIO */
> +#define CYGNUS_GPIO_ASIU_DRV0_CTRL_OFFSET 0x58
> +
> +/* drive strength control for CCM GPIO */
> +#define CYGNUS_GPIO_CCM_DRV0_CTRL_OFFSET  0x00

This stuff (drive strength) is pin control, pin config.
It does not belong in a pure GPIO driver. If you're
making a combined pin control + GPIO driver, it
shall be put in drivers/pinctrl/*

> +#define GPIO_BANK_SIZE 0x200
> +#define NGPIOS_PER_BANK 32
> +#define GPIO_BANK(pin) ((pin) / NGPIOS_PER_BANK)
> +
> +#define CYGNUS_GPIO_REG(pin, reg) (GPIO_BANK(pin) * GPIO_BANK_SIZE + (reg))
> +#define CYGNUS_GPIO_SHIFT(pin) ((pin) % NGPIOS_PER_BANK)
> +
> +#define GPIO_FLAG_BIT_MASK           0xffff
> +#define GPIO_PULL_BIT_SHIFT          16
> +#define GPIO_PULL_BIT_MASK           0x3
> +
> +#define GPIO_DRV_STRENGTH_BIT_SHIFT  20
> +#define GPIO_DRV_STRENGTH_BITS       3
> +#define GPIO_DRV_STRENGTH_BIT_MASK   ((1 << GPIO_DRV_STRENGTH_BITS) - 1)
> +
> +/*
> + * For GPIO internal pull up/down registers
> + */
> +enum gpio_pull {
> +       GPIO_PULL_NONE = 0,
> +       GPIO_PULL_UP,
> +       GPIO_PULL_DOWN,
> +       GPIO_PULL_INVALID,
> +};
> +
> +/*
> + * GPIO drive strength
> + */
> +enum gpio_drv_strength {
> +       GPIO_DRV_STRENGTH_2MA = 0,
> +       GPIO_DRV_STRENGTH_4MA,
> +       GPIO_DRV_STRENGTH_6MA,
> +       GPIO_DRV_STRENGTH_8MA,
> +       GPIO_DRV_STRENGTH_10MA,
> +       GPIO_DRV_STRENGTH_12MA,
> +       GPIO_DRV_STRENGTH_14MA,
> +       GPIO_DRV_STRENGTH_16MA,
> +       GPIO_DRV_STRENGTH_INVALID,
> +};


All this pull up/down and drive strength is pin config for
the pin control subsystem.

> +struct cygnus_gpio {
> +       struct device *dev;
> +       void __iomem *base;
> +       void __iomem *io_ctrl;
> +       spinlock_t lock;
> +       struct gpio_chip gc;
> +       unsigned num_banks;
> +       int irq;
> +       struct irq_domain *irq_domain;

Skip irq and irqdomain and use GPIOLIB_IRQCHIP

> +static u32 cygnus_readl(struct cygnus_gpio *cygnus_gpio, unsigned int offset)
> +{
> +       return readl(cygnus_gpio->base + offset);
> +}
> +
> +static void cygnus_writel(struct cygnus_gpio *cygnus_gpio,
> +                         unsigned int offset, u32 val)
> +{
> +       writel(val, cygnus_gpio->base + offset);
> +}

I don't see the value of using these accessors over just inlining
your readl/writel stuff.

(...)
> +static int cygnus_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +       struct cygnus_gpio *cygnus_gpio = to_cygnus_gpio(gc);
> +
> +       return irq_find_mapping(cygnus_gpio->irq_domain, offset);
> +}

This goes away to the core with GPIOLIB_IRQCHIP

> +static void cygnus_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +       struct cygnus_gpio *cygnus_gpio;
> +       struct irq_chip *chip = irq_desc_get_chip(desc);
> +       int i, bit;
> +
> +       chained_irq_enter(chip, desc);
> +
> +       cygnus_gpio = irq_get_handler_data(irq);
> +
> +       /* go through the entire GPIO banks and handle all interrupts */
> +       for (i = 0; i < cygnus_gpio->num_banks; i++) {
> +               unsigned long val = cygnus_readl(cygnus_gpio,
> +                               (i * GPIO_BANK_SIZE) +
> +                               CYGNUS_GPIO_INT_MSTAT_OFFSET);
> +
> +               for_each_set_bit(bit, &val, NGPIOS_PER_BANK) {
> +                       unsigned pin = NGPIOS_PER_BANK * i + bit;
> +                       int child_irq =
> +                               cygnus_gpio_to_irq(&cygnus_gpio->gc, pin);
> +
> +                       /*
> +                        * Clear the interrupt before invoking the
> +                        * handler, so we do not leave any window
> +                        */
> +                       cygnus_writel(cygnus_gpio, (i * GPIO_BANK_SIZE) +
> +                               CYGNUS_GPIO_INT_CLR_OFFSET, BIT(bit));
> +
> +                       generic_handle_irq(child_irq);
> +               }
> +       }
> +
> +       chained_irq_exit(chip, desc);
> +}

Looks good, but you will need to have the struct gpio_chip * as
handler data to use GPIOLIB_IRQCHIP, so get from there to
the struct cygnus_gpio something like:

struct gpio_chip *gc = irq_desc_get_handler_data(desc);
struct cygnus_gpio *cyg = to_cygnus_gpio(gc);

> +static int cygnus_gpio_get(struct gpio_chip *gc, unsigned gpio)
> +{
> +       struct cygnus_gpio *cygnus_gpio = to_cygnus_gpio(gc);
> +       unsigned int offset = CYGNUS_GPIO_REG(gpio,
> +                       CYGNUS_GPIO_DATA_IN_OFFSET);
> +       unsigned int shift = CYGNUS_GPIO_SHIFT(gpio);
> +       u32 val;
> +
> +       val = cygnus_readl(cygnus_gpio, offset);
> +       val = (val >> shift) & 1;

No, do this:

return !!(cygnus_readl(cygnus_gpio, offset) & BIT(shift));

Maybe rename the "shift" variable to "bit" or just use the macro
directly in the readl().

> +static int cygnus_gpio_irq_map(struct irq_domain *d, unsigned int irq,
> +                              irq_hw_number_t hwirq)
> +{
> +       int ret;
> +
> +       ret = irq_set_chip_data(irq, d->host_data);
> +       if (ret < 0)
> +               return ret;
> +       irq_set_lockdep_class(irq, &gpio_lock_class);
> +       irq_set_chip_and_handler(irq, &cygnus_gpio_irq_chip,
> +                       handle_simple_irq);
> +       set_irq_flags(irq, IRQF_VALID);
> +
> +       return 0;
> +}
> +
> +static void cygnus_gpio_irq_unmap(struct irq_domain *d, unsigned int irq)
> +{
> +       irq_set_chip_and_handler(irq, NULL, NULL);
> +       irq_set_chip_data(irq, NULL);
> +}
> +
> +static struct irq_domain_ops cygnus_irq_ops = {
> +       .map = cygnus_gpio_irq_map,
> +       .unmap = cygnus_gpio_irq_unmap,
> +       .xlate = irq_domain_xlate_twocell,
> +};

All this goes away with GPIOLIB_IRQCHIP (that is what is good about it).

> +#ifdef CONFIG_OF_GPIO

What, that should be defined all the time, you depend on it in
Kconfig!

> +static void cygnus_gpio_set_pull(struct cygnus_gpio *cygnus_gpio,
> +                                unsigned gpio, enum gpio_pull pull)
(...)
> +static void cygnus_gpio_set_strength(struct cygnus_gpio *cygnus_gpio,
> +               unsigned gpio, enum gpio_drv_strength strength)
(...)
> +static int cygnus_gpio_of_xlate(struct gpio_chip *gc,
> +               const struct of_phandle_args *gpiospec, u32 *flags)

NAK. This is pin control, put this in the pin control driver.

I guess the same that is part of this patch series.

(...)
> +static int cygnus_gpio_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct resource *res;
> +       struct cygnus_gpio *cygnus_gpio;
> +       struct gpio_chip *gc;
> +       u32 i, ngpios;
> +       int ret;
> +
> +       cygnus_gpio = devm_kzalloc(dev, sizeof(*cygnus_gpio), GFP_KERNEL);
> +       if (!cygnus_gpio)
> +               return -ENOMEM;
> +
> +       cygnus_gpio->dev = dev;
> +       platform_set_drvdata(pdev, cygnus_gpio);
> +
> +       if (of_property_read_u32(dev->of_node, "ngpios", &ngpios)) {
> +               dev_err(&pdev->dev, "missing ngpios DT property\n");
> +               return -ENODEV;
> +       }
> +       cygnus_gpio->num_banks = (ngpios + NGPIOS_PER_BANK - 1) /
> +               NGPIOS_PER_BANK;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       cygnus_gpio->base = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(cygnus_gpio->base)) {
> +               dev_err(&pdev->dev, "unable to map I/O memory\n");
> +               return PTR_ERR(cygnus_gpio->base);
> +       }
> +
> +       /*
> +        * Only certain types of Cygnus GPIO interfaces have I/O control
> +        * registers
> +        */
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +       if (res) {
> +               cygnus_gpio->io_ctrl = devm_ioremap_resource(dev, res);
> +               if (IS_ERR(cygnus_gpio->io_ctrl)) {
> +                       dev_err(&pdev->dev, "unable to map I/O memory\n");
> +                       return PTR_ERR(cygnus_gpio->io_ctrl);
> +               }
> +       }

This is a good indication that it's a separate piece of HW and should
be a separate pin control driver.

> +
> +       spin_lock_init(&cygnus_gpio->lock);
> +
> +       gc = &cygnus_gpio->gc;
> +       gc->base = -1;
> +       gc->ngpio = ngpios;
> +       gc->label = dev_name(dev);
> +       gc->dev = dev;
> +#ifdef CONFIG_OF_GPIO

You depend on this symbol.

> +       gc->of_node = dev->of_node;
> +       gc->of_gpio_n_cells = 2;
> +       gc->of_xlate = cygnus_gpio_of_xlate;
> +#endif
> +       gc->direction_input = cygnus_gpio_direction_input;
> +       gc->direction_output = cygnus_gpio_direction_output;
> +       gc->set = cygnus_gpio_set;
> +       gc->get = cygnus_gpio_get;
> +       gc->to_irq = cygnus_gpio_to_irq;
> +
> +       ret = gpiochip_add(gc);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "unable to add GPIO chip\n");
> +               return ret;
> +       }
> +
> +       /*
> +        * Some of the GPIO interfaces do not have interrupt wired to the main
> +        * processor
> +        */
> +       cygnus_gpio->irq = platform_get_irq(pdev, 0);
> +       if (cygnus_gpio->irq < 0) {
> +               ret = cygnus_gpio->irq;
> +               if (ret == -EPROBE_DEFER)
> +                       goto err_rm_gpiochip;
> +
> +               dev_info(&pdev->dev, "no interrupt hook\n");
> +       }

>From here:

> +       cygnus_gpio->irq_domain = irq_domain_add_linear(dev->of_node,
> +                       gc->ngpio, &cygnus_irq_ops, cygnus_gpio);
> +       if (!cygnus_gpio->irq_domain) {
> +               dev_err(&pdev->dev, "unable to allocate IRQ domain\n");
> +               ret = -ENXIO;
> +               goto err_rm_gpiochip;
> +       }
> +
> +       for (i = 0; i < gc->ngpio; i++) {
> +               int irq = irq_create_mapping(cygnus_gpio->irq_domain, i);
> +
> +               irq_set_lockdep_class(irq, &gpio_lock_class);
> +               irq_set_chip_data(irq, cygnus_gpio);
> +               irq_set_chip_and_handler(irq, &cygnus_gpio_irq_chip,
> +                               handle_simple_irq);
> +               set_irq_flags(irq, IRQF_VALID);
> +       }
> +
> +       irq_set_chained_handler(cygnus_gpio->irq, cygnus_gpio_irq_handler);
> +       irq_set_handler_data(cygnus_gpio->irq, cygnus_gpio);

To here, replace with a single call to
gpiochip_set_chained_irqchip(chip *, irq_chip *, irq, handler)...

Look at other drivers using GPIOLIB_IRQCHIP for inspiration.

Yours,
Linus Walleij
