Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab3CLNHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:07:32 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:43748 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3CLNHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:07:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linus.walleij@linaro.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] gpio: Renesas R-Car GPIO driver
Date: Tue, 12 Mar 2013 14:07:59 +0100
Message-ID: <2638997.DezZavkCFy@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CANqRtoR=y99NycYFexTXxxCv+GDtVJJne0y-Eh64qba-1LmtaA@mail.gmail.com>
References: <20130305003219.14792.13300.sendpatchset@w520> <6341264.ceyzOgjW1K@avalon> <CANqRtoR=y99NycYFexTXxxCv+GDtVJJne0y-Eh64qba-1LmtaA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Tuesday 12 March 2013 14:27:25 Magnus Damm wrote:
> On Sun, Mar 10, 2013 at 3:16 AM, Laurent Pinchart wrote:
> > Hi Magnus,
> > 
> > Thank you for the patch.
> 
> Thanks for your review!

You're welcome.

> > On Tuesday 05 March 2013 09:32:19 Magnus Damm wrote:
> >> From: Magnus Damm <damm@opensource.se>
> >> 
> >> This patch implements a GPIO driver for the R-Car series
> >> of SoCs from Renesas. This driver is designed to be reusable
> >> between multiple SoCs that share the same basic building block,
> >> but so far it has only been used on R-Car H1 (r8a7779).
> >> 
> >> Each driver instance handles 32 GPIOs with individually
> >> maskable IRQs. The driver operates on a single I/O memory
> >> range and the 32 GPIOs are hooked up a single interrupt.
> >> 
> >> In the case of R-Car H1 either external IRQ pins or GPIOs
> >> with interrupts can be used for on-board interupts. For
> >> external IRQs 4 pins are supported, and in the case of GPIO
> >> there are 202 GPIOS as 202 interrupts hooked up via 6 driver
> >> instances and to the GIC and the Cortex-A9 Quad.
> >> 
> >> At this point this driver is interfacing as a regular
> >> platform device driver. In the future DT support will be
> >> submitted as an incremental feature patch.
> >> 
> >> Signed-off-by: Magnus Damm <damm@opensource.se>
> >> ---
> >> 
> >>  drivers/gpio/Kconfig                    |    6
> >>  drivers/gpio/Makefile                   |    1
> >>  drivers/gpio/gpio-rcar.c                |  406 +++++++++++++++++++++++++
> >>  include/linux/platform_data/gpio-rcar.h |   29 ++
> >>  4 files changed, 442 insertions(+)
> >> 
> >> --- /dev/null
> >> +++ work/drivers/gpio/gpio-rcar.c     2013-03-05 09:13:23.000000000 +0900
> >> @@ -0,0 +1,406 @@

[snip]

> >> +static void gpio_rcar_config_interrupt_input_mode(struct gpio_rcar_priv
> >> *p, +                                               unsigned int hwirq,
> >> +                                               bool
> >> active_high_rising_edge, +                                              
> >> bool level_trigger) +{
> >> +     unsigned long bit = BIT(hwirq);
> >> +     unsigned long flags, tmp;
> >> +
> >> +     /* follow steps in the GPIO documentation for
> >> +      * "Setting Edge-Sensitive Interrupt Input Mode" and
> >> +      * "Setting Level-Sensitive Interrupt Input Mode"
> >> +      */
> >> +
> >> +     spin_lock_irqsave(&p->lock, flags);
> >> +
> >> +     /* Configure postive or negative logic in POSNEG */
> >> +     tmp = gpio_rcar_read(p, POSNEG);
> >> +     if (active_high_rising_edge)
> >> +             tmp &= ~bit;
> >> +     else
> >> +             tmp |= bit;
> >> +     gpio_rcar_write(p, POSNEG, tmp);
> >> +
> >> +     /* Configure edge or level trigger in EDGLEVEL */
> >> +     tmp = gpio_rcar_read(p, EDGLEVEL);
> >> +     if (level_trigger)
> >> +             tmp &= ~bit;
> >> +     else
> >> +             tmp |= bit;
> >> +     gpio_rcar_write(p, EDGLEVEL, tmp);
> >> +
> >> +     /* Select "Interrupt Input Mode" in IOINTSEL */
> >> +     tmp = gpio_rcar_read(p, IOINTSEL);
> >> +     tmp |= bit;
> >> +     gpio_rcar_write(p, IOINTSEL, tmp);
> >> +
> >> +     /* Write INTCLR in case of edge trigger */
> >> +     if (!level_trigger)
> > 
> > Maybe you could do so unconditionally.
> 
> I could, but I wouldn't follow the recommended sequence in the data sheet
> then.
> >> +             gpio_rcar_write(p, INTCLR, bit);
> > 
> > I suppose the idea here it to avoid spurious interrupts when switching to
> > edge-triggered interrupt mode. If the interrupt was already enabled
> > wouldn't it still be registered before you clear the flag ?
> 
> Maybe. Perhaps I shall use IRQCHIP_SET_TYPE_MASKED here?

That's a good idea.

> >> +
> >> +     spin_unlock_irqrestore(&p->lock, flags);
> >> +}

[snip]

> >> +static int gpio_rcar_get(struct gpio_chip *chip, unsigned offset)
> >> +{
> >> +     return (int)(gpio_rcar_read(gpio_to_priv(chip), INDT) &
> >> BIT(offset));
> >> +}
> > 
> > Isn't the get operation supposed to return 0 or 1 ? In that case
> > 
> >         return !!(gpio_rcar_read(gpio_to_priv(chip), INDT) & BIT(offset));
> > 
> > would be better.
> 
> I recall that for micro optimization purpose I believe the double
> negation is unnecessary for the GPIO ->get() operation.
> 
> Or perhaps things have changed?

I'm not sure to be honest, I was hoping you would know :-)

[snip]

> >> +static int gpio_rcar_probe(struct platform_device *pdev)
> >> +{
> >> +     struct gpio_rcar_config *pdata = pdev->dev.platform_data;
> >> +     struct gpio_rcar_priv *p;
> >> +     struct resource *io, *irq;
> >> +     struct gpio_chip *gpio_chip;
> >> +     struct irq_chip *irq_chip;
> >> +     const char *name = dev_name(&pdev->dev);
> >> +     int ret;
> >> +
> >> +     p = kzalloc(sizeof(*p), GFP_KERNEL);
> > 
> > You can use devm_kzalloc() to simplify error management.
> 
> Yep, devm is not bad.
> 
> >> +     if (!p) {
> >> +             dev_err(&pdev->dev, "failed to allocate driver data\n");
> >> +             ret = -ENOMEM;
> > 
> > You can return -ENOMEM; directly here.
> 
> I prefer to have a single point of error return.

So do I when there's any cleanup to be done in the error path, which isn't the 
case here. I'm OK if you keep the goto though.

> >> +             goto err0;
> >> +     }
> >> +
> >> +     /* deal with driver instance configuration */
> >> +     if (pdata)
> > 
> > Shouldn't you return an error if pdata == NULL ?
> 
> Platform data isn't required by this driver.
> 
> >> +             memcpy(&p->config, pdata, sizeof(*pdata));
> >> 
> >         p->config = *pdata;
> > 
> > seems to be the preferred style nowadays. You could also store a pointer
> > to a struct gpio_rcar_config in gpio_rcar_priv, but I suppose you have
> > decided not to do so in prevision for DT support.
> 
> Yes because of upcoming DT support. And this way the platform data can
> be put in some special init section too. As for memcpy(), I like to
> explicitly use that compared over your suggestion. This way it is easy
> to see which code that shouldn't happen during hot path.

I wasn't too fond of the structure assignment style to start with but changed 
my mind after receiving patches that removed memcpy() calls from across the 
whole kernel :-)

> >> +     p->pdev = pdev;
> >> +     platform_set_drvdata(pdev, p);
> >> +     spin_lock_init(&p->lock);
> >> +
> >> +     io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +     irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >> +
> >> +     if (!io || !irq) {
> >> +             dev_err(&pdev->dev, "missing IRQ or IOMEM\n");
> >> +             ret = -EINVAL;
> >> 
> >         return -EINVAL;
> >> 
> >> +             goto err1;
> >> +     }
> >> +
> >> +     p->base = ioremap_nocache(io->start, resource_size(io));
> > 
> > devm_ioremap_nocache()
> 
> Yep, devm.
> 
> >> +     if (!p->base) {
> >> +             dev_err(&pdev->dev, "failed to remap I/O memory\n");
> >> +             ret = -ENXIO;
> >> 
> >         return -ENXIO;
> >> 
> >> +             goto err1;
> >> +     }
> >> +
> >> +     gpio_chip = &p->gpio_chip;
> >> +     gpio_chip->direction_input = gpio_rcar_direction_input;
> >> +     gpio_chip->get = gpio_rcar_get;
> >> +     gpio_chip->direction_output = gpio_rcar_direction_output;
> >> +     gpio_chip->set = gpio_rcar_set;
> >> +     gpio_chip->to_irq = gpio_rcar_to_irq;
> >> +     gpio_chip->label = name;
> >> +     gpio_chip->owner = THIS_MODULE;
> >> +     gpio_chip->base = p->config.gpio_base;
> >> +     gpio_chip->ngpio = p->config.number_of_pins;
> >> +
> >> +     irq_chip = &p->irq_chip;
> >> +     irq_chip->name = name;
> >> +     irq_chip->irq_mask = gpio_rcar_irq_disable;
> >> +     irq_chip->irq_unmask = gpio_rcar_irq_enable;
> >> +     irq_chip->irq_enable = gpio_rcar_irq_enable;
> >> +     irq_chip->irq_disable = gpio_rcar_irq_disable;
> >> +     irq_chip->irq_set_type = gpio_rcar_irq_set_type;
> >> +     irq_chip->flags = IRQCHIP_SKIP_SET_WAKE;
> >> +
> >> +     p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
> >> +                                           p->config.number_of_pins,
> >> +                                           p->config.irq_base,
> >> +                                           &gpio_rcar_irq_domain_ops,
> >> p);
> >> +     if (!p->irq_domain) {
> >> +             ret = -ENXIO;
> >> +             dev_err(&pdev->dev, "cannot initialize irq domain\n");
> >> +             goto err2;
> > 
> > return -ENXIO;
> 
> In case of devm, yes.
> 
> >> +     }
> >> +
> >> +     if (request_irq(irq->start, gpio_rcar_irq_handler, 0, name, p)) {
> > 
> > devm_request_irq()
> 
> Yes, like the devm patch for gpio-em does it. =)
> 
> >> +             dev_err(&pdev->dev, "failed to request IRQ\n");
> >> +             ret = -ENOENT;
> >> +             goto err3;
> >> +     }
> >> +
> >> +     ret = gpiochip_add(gpio_chip);
> >> +     if (ret) {
> >> +             dev_err(&pdev->dev, "failed to add GPIO controller\n");
> >> +             goto err4;
> >> +     }
> >> +
> >> +     dev_info(&pdev->dev, "driving %d GPIOs\n",
> >> p->config.number_of_pins);
> >> +
> >> +     /* warn in case of mismatch if irq base is specified */
> > 
> > When does this happen ?
> 
> If happens if the user has requested a certain static IRQ base but
> this interrupts were already installed there by some other driver.
> 
> >> +     if (p->config.irq_base) {
> >> +             ret = irq_find_mapping(p->irq_domain, 0);
> >> +             if (p->config.irq_base != ret)
> >> +                     dev_warn(&pdev->dev, "irq base mismatch (%d/%d)\n",
> > 
> > p->config.irq_base is unsigned and irq_find_mapping() returns an unsigned.
> > %u/%u would this be more appropriate.
> 
> Ok!
> 
> >> +                              p->config.irq_base, ret);
> >> +     }
> >> +
> >> +     return 0;
> >> +
> >> +err4:
> >> +     free_irq(irq->start, p);
> >> +err3:
> >> +     irq_domain_remove(p->irq_domain);
> >> +err2:
> >> +     iounmap(p->base);
> >> +err1:
> >> +     kfree(p);
> >> +err0:
> >> +     return ret;
> > 
> > With the devm_* functions used above you will have a single error label to
> > call irq_domain_remove.
> 
> Right, that makes the code simpler, I agree. I actually had devm planned as
> an incremental feature.
> 
> So what is the preferred way to handle update of this driver? I intend to
> add devm and DT support anyway, and I want both of them to be incremental to
> avoid making back porting more difficult than absolutely necessary.

How far back do you need to backport the driver ? devm_kzalloc was introduced 
in 2.6.21, devm_ioremap_nocache in 2.6.26 and devm_request_irq in 2.6.30. That 
gives you nearly 4 years of backporting, I hope it would be enough :-)

> Shall I make a V2 with everything except DT and devm, doesn't that sound
> pretty straight forward?

Could you submit a v2 with all the changes except DT ?

-- 
Regards,

Laurent Pinchart

