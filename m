Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaABMcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:32:52 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53662 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaABMcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:32:50 -0500
MIME-Version: 1.0
In-Reply-To: <1387309071-22382-12-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	<1387309071-22382-1-git-send-email-ynvich@gmail.com>
	<1387309071-22382-12-git-send-email-ynvich@gmail.com>
Date: Thu, 2 Jan 2014 13:32:49 +0100
Message-ID: <CACRpkdaY7xpoeeUqBBqUS2swe6Y5gKt67VYNvNRrsbFhyU=ATw@mail.gmail.com>
Subject: Re: [PATCH v3 11/21] ARM: pxa: support ICP DAS LP-8x4x FPGA irq
From: Linus Walleij <linus.walleij@linaro.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 8:37 PM, Sergei Ianovich <ynvich@gmail.com> wrote:

> ICP DAS LP-8x4x contains FPGA chip. The chip functions as a interrupt
> source providing 16 additional interrupts among other things. The
> interrupt lines are muxed to a GPIO pin. GPIO pins are in turn muxed
> to a CPU interrupt line.
>
> Until pxa is completely converted to device tree, it is impossible
> to use IRQCHIP_DECLARE() and the irqdomain needs to added manually.
>
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Linus Walleij <linus.walleij@linaro.org>

(...)
> +++ b/drivers/irqchip/irq-lp8x4x.c

Usually combined GPIO+IRQ controllers are put into drivers/gpio but
this is a bit special as it seems to handle also non-GPIO-related IRQs
so let's get some input on this.

> +static unsigned char irq_sys_enabled;
> +static unsigned char irq_high_enabled;
> +static void *base;
> +static int irq_base;
> +static int num_irq = 16;

Please use the state container design pattern and get rid of these
global variables.

This documentation patch describes this pattern and has been
merged for v3.14, so please read this:
http://marc.info/?l=linux-kernel&m=138615980524966&w=2

> +static void lp8x4x_mask_irq(struct irq_data *d)
> +{
> +       unsigned mask;
> +       int irq = d->irq - irq_base;

Don't calculate hardware IRQ numbers from offsets. Use
irqdomain, which is done for exactly this purpose.

> +       if (irq < 8) {
> +               irq_high_enabled &= ~(1 << irq);

I usually use the BIT() macro for this, like:

#include <linux/bitops.h>

irq_high_enabled &= ~BIT(irq);

> +static struct irq_chip lp8x4x_irq_chip = {
> +       .name                   = "FPGA",
> +       .irq_ack                = lp8x4x_mask_irq,
> +       .irq_mask               = lp8x4x_mask_irq,
> +       .irq_mask_ack           = lp8x4x_mask_irq,
> +       .irq_unmask             = lp8x4x_unmask_irq,
> +};

After you have added your state container you will have
a handle to your struct gpio_chip in the cookie passed to
as irqdata.

Then you need to mark the GPIO lines used for IRQs by
doing something similar to this patch in your startup()
and shutdown() callbacks:
http://marc.info/?l=linux-gpio&m=138547223832167&w=2

> +static void lp8x4x_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{> +static void lp8x4x_unmask_irq(struct irq_data *d)
> +{
> +       unsigned mask;
> +       int irq = d->irq - irq_base;

Use the irqdomain.

> +       int loop, n;
> +       unsigned long mask;
> +       struct irq_chip *chip = irq_desc_get_chip(desc);
> +
> +       chained_irq_enter(chip, desc);
> +
> +       do {
> +               loop = 0;
> +               mask = ioread8(base + CLRHILVINT) & 0xff;
> +               mask |= (ioread8(base + SECOINT) & 0x1f) << 8;
> +               mask |= (ioread8(base + PRIMINT) & 0xe0) << 8;

#define these magic constants so we know what they mean.
0x1f, 0xe0...

> +               mask &= (irq_high_enabled | (irq_sys_enabled << 8));
> +               for_each_set_bit(n, &mask, BITS_PER_LONG) {
> +                       loop = 1;
> +
> +                       generic_handle_irq(irq_base + n);
> +               }
> +       } while (loop);

If you're going to do it like this then have "loop" be a bool variable.

However I don't quite like this construction, an eternal for() loop
with a break; statement works too, but try to just use the mask and
get rid of the "loop" helper variable.

> +       iowrite8(0, base + EOI);

This looks dangerous, what are you doing here?

> +static int lp8x4x_irq_probe(struct platform_device *pdev)
> +{
> +       struct resource *rm, *ri;

Explain these names. Usually we call them "res" or something
simple like this.

> +       irq_base = irq_alloc_descs(-1, 0, num_irq, 0);
> +       if (irq_base < 0) {
> +               dev_err(&pdev->dev, "Failed to allocate IRQ numbers\n");
> +               return irq_base;
> +       }

Instead of doing this, create the descriptors by calling
irq_create_mapping() on all the hardware lines after adding
the irq domain.

> +       domain = irq_domain_add_legacy(np, num_irq, irq_base, 0,
> +                                      &lp8x4x_irq_domain_ops, NULL);
> +       if (!domain) {
> +               dev_err(&pdev->dev, "Failed to add IRQ domain\n");
> +               return -ENOMEM;
> +       }

Why are you using a legacy irqdomain? You're not dependent
on any specific base so use a linear domain.

> +       iowrite8(0, base + CLRRISEINT);
> +       iowrite8(0, base + ENRISEINT);
> +       iowrite8(0, base + CLRFALLINT);
> +       iowrite8(0, base + ENFALLINT);
> +       iowrite8(0, base + CLRHILVINT);
> +       iowrite8(0, base + ENHILVINT);
> +       iowrite8(0, base + ENSYSINT);
> +       iowrite8(0, base + SECOINT);

Add a comment explaining what you're doing here.

> +static int __init lp8x4x_irq_init(void)
> +{
> +       return platform_driver_register(&lp8x4x_irq_driver);
> +}
> +postcore_initcall(lp8x4x_irq_init);

Do you *have* to do it this early? I guess if it's used for
the UARTs then yes, but make a case for it...

Yours,
Linus Walleij
