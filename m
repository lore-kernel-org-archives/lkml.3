Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbbANJ6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:58:42 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:60153 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbbANJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:58:38 -0500
MIME-Version: 1.0
In-Reply-To: <1419409345-8297-3-git-send-email-thloh@altera.com>
References: <1419409345-8297-1-git-send-email-thloh@altera.com>
	<1419409345-8297-3-git-send-email-thloh@altera.com>
Date: Wed, 14 Jan 2015 10:58:34 +0100
Message-ID: <CACRpkdZ1kTjq979RbxzUSsb88v8XKjXRhRCpPkgS2wHrCcPGkg@mail.gmail.com>
Subject: Re: [PATCH v8 2/2] drivers/gpio: Altera soft IP GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Tien Hock Loh <thloh@altera.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 9:22 AM,  <thloh@altera.com> wrote:

> From: Tien Hock Loh <thloh@altera.com>
>
> Adds a new driver for Altera soft GPIO IP. The driver is able to
> do read/write and allows GPIO to be a interrupt controller.
>
> Tested on Altera GHRD on interrupt handling and IO.
>
> Signed-off-by: Tien Hock Loh <thloh@altera.com>

(...)
> +config GPIO_ALTERA
> +       tristate "Altera GPIO"
> +       depends on OF_GPIO

select GPIOLIB_IRQCHIP

Also, I think (see below)

select GENERIC_GPIO

> +#include <linux/gpio.h>

#include <linux/gpio/driver.h>

should be just fine instead of this old header.

> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>

Should not be needed.

> +#include <linux/irqchip/chained_irq.h>
> +#include <linux/irqdomain.h>

None of these should be needed.

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>

#include <linux/basic_mmio_gpio.h>

with GENERIC_GPIO (see below).

> +
> +#define ALTERA_GPIO_MAX_NGPIO          32
> +#define ALTERA_GPIO_DATA               0x0
> +#define ALTERA_GPIO_DIR                        0x4
> +#define ALTERA_GPIO_IRQ_MASK           0x8
> +#define ALTERA_GPIO_EDGE_CAP           0xc
> +
> +/**
> +* struct altera_gpio_chip
> +* @mmchip              : memory mapped chip structure.
> +* @gpio_lock           : synchronization lock so that new irq/set/get requests
> +                         will be blocked until the current one completes.
> +* @interrupt_trigger   : specifies the hardware configured IRQ trigger type
> +                         (rising, falling, both, high)
> +* @mapped_irq          : kernel mapped irq number.
> +*/
> +struct altera_gpio_chip {
> +       struct of_mm_gpio_chip mmchip;
> +       spinlock_t gpio_lock;
> +       int interrupt_trigger;
> +       int mapped_irq;
> +};
> +
> +static void altera_gpio_irq_unmask(struct irq_data *d)
> +{
> +       struct altera_gpio_chip *altera_gc;
> +       struct of_mm_gpio_chip *mm_gc;
> +       unsigned long flags;
> +       u32 intmask;
> +
> +       altera_gc = irq_data_get_irq_chip_data(d);
> +       mm_gc = &altera_gc->mmchip;
> +
> +       spin_lock_irqsave(&altera_gc->gpio_lock, flags);
> +       intmask = readl(mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
> +       /* Set ALTERA_GPIO_IRQ_MASK bit to unmask */
> +       intmask |= BIT(irqd_to_hwirq(d));
> +       writel(intmask, mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
> +       spin_unlock_irqrestore(&altera_gc->gpio_lock, flags);
> +}
> +
> +static void altera_gpio_irq_mask(struct irq_data *d)
> +{
> +       struct altera_gpio_chip *altera_gc;
> +       struct of_mm_gpio_chip *mm_gc;
> +       unsigned long flags;
> +       u32 intmask;
> +
> +       altera_gc = irq_data_get_irq_chip_data(d);
> +       mm_gc = &altera_gc->mmchip;
> +
> +       spin_lock_irqsave(&altera_gc->gpio_lock, flags);
> +       intmask = readl(mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
> +       /* Clear ALTERA_GPIO_IRQ_MASK bit to mask */
> +       intmask &= ~BIT(irqd_to_hwirq(d));
> +       writel(intmask, mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
> +       spin_unlock_irqrestore(&altera_gc->gpio_lock, flags);
> +}
> +
> +static int altera_gpio_irq_set_type(struct irq_data *d,
> +                                  unsigned int type)
> +{
> +       struct altera_gpio_chip *altera_gc = irq_data_get_irq_chip_data(d);
> +
> +       altera_gc = irq_data_get_irq_chip_data(d);
> +
> +       if (type == IRQ_TYPE_NONE)
> +               return 0;
> +       if (type == IRQ_TYPE_LEVEL_HIGH &&
> +               altera_gc->interrupt_trigger == IRQ_TYPE_LEVEL_HIGH)
> +               return 0;
> +       if (type == IRQ_TYPE_EDGE_RISING &&
> +               altera_gc->interrupt_trigger == IRQ_TYPE_EDGE_RISING)
> +               return 0;
> +       if (type == IRQ_TYPE_EDGE_FALLING &&
> +               altera_gc->interrupt_trigger == IRQ_TYPE_EDGE_FALLING)
> +               return 0;
> +       if (type == IRQ_TYPE_EDGE_BOTH &&
> +               altera_gc->interrupt_trigger == IRQ_TYPE_EDGE_BOTH)
> +               return 0;
> +
> +       return -EINVAL;
> +}

It took me a while to understand this. Write in a comment that
this is a hardware that is synthesized for a specific trigger
type, and that there is no way to software-configure the
trigger type.

> +
> +static unsigned int altera_gpio_irq_startup(struct irq_data *d)
> +{
> +       altera_gpio_irq_unmask(d);
> +
> +       return 0;
> +}
> +
> +static void altera_gpio_irq_shutdown(struct irq_data *d)
> +{
> +       altera_gpio_irq_mask(d);
> +}

Instead of those pointless functions just assign
the unmask/mask functions in the vtable right below.

> +
> +static struct irq_chip altera_irq_chip = {
> +       .name           = "altera-gpio",
> +       .irq_mask       = altera_gpio_irq_mask,
> +       .irq_unmask     = altera_gpio_irq_unmask,
> +       .irq_set_type   = altera_gpio_irq_set_type,
> +       .irq_startup    = altera_gpio_irq_startup,
> +       .irq_shutdown   = altera_gpio_irq_shutdown,

i.e. here.

> +static int altera_gpio_get(struct gpio_chip *gc, unsigned offset)
> +{
> +       struct of_mm_gpio_chip *mm_gc;
> +
> +       mm_gc = to_of_mm_gpio_chip(gc);
> +
> +       return !!(readl(mm_gc->regs + ALTERA_GPIO_DATA) >> offset);
> +}
> +
> +static void altera_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
> +{
> +       struct of_mm_gpio_chip *mm_gc;
> +       struct altera_gpio_chip *chip;
> +       unsigned long flags;
> +       unsigned int data_reg;
> +
> +       mm_gc = to_of_mm_gpio_chip(gc);
> +       chip = container_of(mm_gc, struct altera_gpio_chip, mmchip);
> +
> +       spin_lock_irqsave(&chip->gpio_lock, flags);
> +       data_reg = readl(mm_gc->regs + ALTERA_GPIO_DATA);
> +       if (value)
> +               data_reg |= BIT(offset);
> +       else
> +               data_reg &= ~BIT(offset);
> +       writel(data_reg, mm_gc->regs + ALTERA_GPIO_DATA);
> +       spin_unlock_irqrestore(&chip->gpio_lock, flags);
> +}
> +
> +static int altera_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
> +{
> +       struct of_mm_gpio_chip *mm_gc;
> +       struct altera_gpio_chip *chip;
> +       unsigned long flags;
> +       unsigned int gpio_ddr;
> +
> +       mm_gc = to_of_mm_gpio_chip(gc);
> +       chip = container_of(mm_gc, struct altera_gpio_chip, mmchip);
> +
> +       spin_lock_irqsave(&chip->gpio_lock, flags);
> +       /* Set pin as input, assumes software controlled IP */
> +       gpio_ddr = readl(mm_gc->regs + ALTERA_GPIO_DIR);
> +       gpio_ddr &= ~BIT(offset);
> +       writel(gpio_ddr, mm_gc->regs + ALTERA_GPIO_DIR);
> +       spin_unlock_irqrestore(&chip->gpio_lock, flags);
> +
> +       return 0;
> +}
> +
> +static int altera_gpio_direction_output(struct gpio_chip *gc,
> +               unsigned offset, int value)
> +{
> +       struct of_mm_gpio_chip *mm_gc;
> +       struct altera_gpio_chip *chip;
> +       unsigned long flags;
> +       unsigned int data_reg, gpio_ddr;
> +
> +       mm_gc = to_of_mm_gpio_chip(gc);
> +       chip = container_of(mm_gc, struct altera_gpio_chip, mmchip);
> +
> +       spin_lock_irqsave(&chip->gpio_lock, flags);
> +       /* Sets the GPIO value */
> +       data_reg = readl(mm_gc->regs + ALTERA_GPIO_DATA);
> +       if (value)
> +               data_reg |= BIT(offset);
> +       else
> +               data_reg &= ~BIT(offset);
> +       writel(data_reg, mm_gc->regs + ALTERA_GPIO_DATA);
> +
> +       /* Set pin as output, assumes software controlled IP */
> +       gpio_ddr = readl(mm_gc->regs + ALTERA_GPIO_DIR);
> +       gpio_ddr |= BIT(offset);
> +       writel(gpio_ddr, mm_gc->regs + ALTERA_GPIO_DIR);
> +       spin_unlock_irqrestore(&chip->gpio_lock, flags);
> +
> +       return 0;
> +}

These calls seem like pretty vanilla generic GPIO functions.
Use GENERIC_GPIO with bgpio_init() and override the default
functions only when really needed.

See e.g. drivers/gpio/gpio-74xx-mmio.c

> +static int altera_gpio_irq_map(struct irq_domain *h, unsigned int irq,
> +                             irq_hw_number_t hw_irq_num)
> +{
> +       irq_set_chip_data(irq, h->host_data);
> +       irq_set_chip_and_handler(irq, &altera_irq_chip, handle_level_irq);
> +
> +       return 0;
> +}
> +
> +static const struct irq_domain_ops altera_gpio_irq_ops = {
> +       .map    = altera_gpio_irq_map,
> +       .xlate = irq_domain_xlate_onecell,
> +};

This looks like some leftover garbage. You don't need them with
GPIOLIB_IRQCHIP so delete these two.

> +static int altera_gpio_remove(struct platform_device *pdev)
> +{
> +       struct altera_gpio_chip *altera_gc = platform_get_drvdata(pdev);
> +
> +       gpiochip_remove(&altera_gc->mmchip.gc);
> +
> +       irq_set_handler_data(altera_gc->mapped_irq, NULL);
> +       irq_set_chained_handler(altera_gc->mapped_irq, NULL);

These two calls should not be needed either.

Yours,
Linus Walleij
