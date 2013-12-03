Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3LCIuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:50:16 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61708 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3LCIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:50:12 -0500
MIME-Version: 1.0
In-Reply-To: <1385249897-16453-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1385249897-16453-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1385249897-16453-2-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 3 Dec 2013 09:50:11 +0100
Message-ID: <CACRpkdZts4qtrt15ppSNSpk-wE56fc6-sK5fT-5FvSVStao+ZA@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: Add Qualcomm TLMM driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 12:38 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> This adds a pinctrl, pinmux, pinconf and gpiolib driver for the
> Qualcomm TLMM block.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Overall this is looking *very* good, using established infrastructure
and design patterns like per-SoC plugs, utils, generic pinconf etc.

A few things remain to be fixed for v2 and after that I expect
to apply the patch for inclusion in kernel v3.14, just putting the
MSM maintainers into the To: line so they are aware that this is
what they will need to use.

Of course that requires the DT bindings to be ACKed by the
DT people though.

> +/**
> + * struct msm_pinctrl - state for a pinctrl-msm device
> + * @dev:            device handle.
> + * @pctrl:          pinctrl handle.
> + * @domain:         irqdomain handle.
> + * @chip:           gpiochip handle.
> + * @irq:            Summary irq for the TLMM chip.

I wonder what a summary IRQ is :-)
We could call it the parent IRQ for the TLMM irq_chip.

> + * @lock:           Spinlock to protect register resources as well
> + *                  as msm_pinctrl data structures.
> + * @enabled_irqs:   Bitmap of currently enabled irqs.
> + * @dual_edge_irqs: Bitmap of irqs that need sw emulated dual edge
> + *                  detection.
> + * @wake_irqs:      Bitmap of irqs with requested as wakeup source.

So these are bitmaps... see below.

> + * @soc;            Reference to soc_data of platform specific data.
> + * @regs:           Base address for the TLMM register map.
> + */
> +struct msm_pinctrl {
> +       struct device *dev;
> +       struct pinctrl_dev *pctrl;
> +       struct irq_domain *domain;
> +       struct gpio_chip chip;

It is especially nice to see this single state struct for both
pinctrl and gpio_chip.

> +       unsigned irq;
> +
> +       spinlock_t lock;
> +
> +       unsigned long *enabled_irqs;
> +       unsigned long *dual_edge_irqs;
> +       unsigned long *wake_irqs;

Further in probe() these are allocated like this:

> +       pctrl->enabled_irqs = devm_kzalloc(pctrl->dev,
> +                                          sizeof(unsigned long) * BITS_TO_LONGS(chip->ngpio),
> +                                          GFP_KERNEL);
> +       if (!pctrl->enabled_irqs) {
> +               dev_err(pctrl->dev, "Failed to allocate enabled_irqs bitmap\n");
> +               return -ENOMEM;
> +       }

I take it that this can be standardized and a bit simpler using
bitmap accessors from <linux/bitmap.h>?

(...)
> +static int msm_dt_subnode_to_map(struct pinctrl_dev *pctldev,
> +                                struct device_node *np,
> +                                struct pinctrl_map **map,
> +                                unsigned *reserved_maps,
> +                                unsigned *num_maps)
> +{
> +       ret = of_property_read_string(np, "qcom,function", &function);
(...)
> +       ret = of_property_count_strings(np, "qcom,pins");
(...)

I guess I need for these to be approved through the binding
patch (maybe that should be patch 1?) but we have recently
discussed the possibilty of creating a generic binding for this
and move to the utils. This driver is a potential candidate to
take the step and do that, bringing it into the
drivers/pinctrl/devicetree.c file.

However I will not require that right now.

> +static int msm_pinmux_enable(struct pinctrl_dev *pctldev,
> +                            unsigned function,
> +                            unsigned group)
> +{
(...)
> +       spin_lock_irqsave(&pctrl->lock, flags);
> +
> +       val = readl(pctrl->regs + g->ctl_reg);
> +       val &= ~(0x7 << g->mux_bit);
> +       val |= i << g->mux_bit;
> +       writel(val, pctrl->regs + g->ctl_reg);
> +
> +       spin_unlock_irqrestore(&pctrl->lock, flags);

Why do you need a lock around this read-modify-write?
The pin control core will serialize/marshal the calls to
this and other functions AFICT (I could be wrong, so check
me!). Of course it is nice to be on the safe side, but...

(Same comment on the disable() call)

> +static int msm_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
(...)
> +       spin_lock_irqsave(&pctrl->lock, flags);
> +
> +       val = readl(pctrl->regs + g->ctl_reg);
> +       val &= ~BIT(g->oe_bit);
> +       writel(val, pctrl->regs + g->ctl_reg);
> +
> +       spin_unlock_irqrestore(&pctrl->lock, flags);
> +
> +       return 0;
> +}

For the GPIO API it seems to be necessary to have the lock
though, as it is asynchronous.

> +static int msm_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       const struct msm_pingroup *g;
> +       struct msm_pinctrl *pctrl = container_of(chip, struct msm_pinctrl, chip);
> +       u32 val;
> +
> +       if (WARN_ON(offset >= pctrl->soc->ngroups))
> +               return -EINVAL;
> +
> +       g = &pctrl->soc->groups[offset];
> +
> +       val = readl(pctrl->regs + g->io_reg);
> +       return val & BIT(g->in_bit);

Nit: please clamp the returned value to {0,1} using this
funny pattern:

return !!(val & BIT(g->in_bit));

> +static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct msm_pinctrl *pctrl = container_of(chip, struct msm_pinctrl, chip);
> +
> +       return irq_create_mapping(pctrl->domain, offset);

Recently there has been discussions about not using gpio_to_irq()
to create this mapping, as it is legal to request an IRQ out of a
node without first requesting the GPIO and translationg it to an
IRQ, and on that path this function never gets called.

Intead: call irq_create_mapping() for all valid IRQs in probe() so they
are all mapped already, and just use irq_find_mapping() here.

> +static struct irq_chip msm_gpio_irq_chip = {
> +       .name           = "msmgpio",
> +       .irq_mask       = msm_gpio_irq_mask,
> +       .irq_unmask     = msm_gpio_irq_unmask,
> +       .irq_ack        = msm_gpio_irq_ack,
> +       .irq_set_type   = msm_gpio_irq_set_type,
> +       .irq_set_wake   = msm_gpio_irq_set_wake,
> +};

This kernel cycle I'm working on flagging GPIO lines used for
IRQs properly.

Please implement .irq_startup() and .irq_shutdown() in accordance
with one of the patches I sent for this, e.g. this:
http://marc.info/?l=linux-gpio&m=138546071323849&w=2
Notice that mask()/unmask() has to be called from these startup/shutdown
functions so as to satisfy the semantics of the interrupt core.

> +static irqreturn_t msm_gpio_irq_handler(int irq, void *data)
> +{
(...)
> +       for_each_set_bit(i, pctrl->enabled_irqs, ngpio) {
> +               g = &pctrl->soc->groups[i];
> +               val = readl(pctrl->regs + g->intr_status_reg);
> +               if (val & BIT(g->intr_status_bit))
> +                       generic_handle_irq(msm_gpio_to_irq(&pctrl->chip, i));
> +       }

This may miss IRQs  arriving while the handler is running I think?

If you look at the idiomatic implementations in drivers/irqchip/*
we usually do something like this:

static int handle_one(struct foo *foo, struct pt_regs *regs)
{
        u32 stat, irq;

        while ((stat = readl_relaxed(foo->base + STATUS))) {
                irq = ffs(stat) - 1;
                handle_IRQ(irq_find_mapping(foo->domain, irq), regs);
        }

        return IRQ_HANDLED;
}

By re-reading the status register on each iteration of the while()
clause, we make sure the status is really zero when we exit the loop.

If we should be zuper-picky you should actually do something
like this first:

if (status == 0) {
                do_bad_IRQ(irq, desc);
                return IRQ_INVALID;
}

It's not super-important maybe, but could avoid some nasty bug hunts
later in the history of this driver...

> +static int msm_gpio_irq_map(struct irq_domain *d, unsigned int irq,
> +                           irq_hw_number_t hwirq)
> +{
> +       struct msm_pinctrl *pctrl = d->host_data;
> +
> +       if (!pctrl)
> +               return -EINVAL;
> +
> +       irq_set_chip_and_handler(irq, &msm_gpio_irq_chip, handle_edge_irq);
> +       set_irq_flags(irq, IRQF_VALID);
> +       irq_set_chip_data(irq, pctrl);
> +       irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);

Is that really part of the semantics for the mapping function?

If you do as suggested and call create_map() for each valid IRQ
in probe() you can set the default type there instead.

> +static int msm_gpio_init(struct msm_pinctrl *pctrl)
> +{
(...)
> +       ret = gpiochip_add(&pctrl->chip);
> +       if (ret) {
> +               dev_err(pctrl->dev, "Failed register gpiochip\n");
> +               return ret;
> +       }
> +
> +       pctrl->domain = irq_domain_add_simple(chip->of_node,
> +                                             chip->ngpio,
> +                                             0,
> +                                             &msm_gpio_irq_simple_ops,
> +                                             pctrl);
> +       if (!pctrl->domain) {
> +               dev_err(pctrl->dev, "Failed to register irq domain\n");
> +               r = gpiochip_remove(&pctrl->chip);
> +               return -ENOSYS;
> +       }

Please use gpiochip_add_pin_range() from <linux/gpio.h>
here instead of using pinctrl_add_gpio_range() in the pinctrl
init call. Doing pinctrl_add_gpio_range() is the old way of
doing things that we want to get rid of.

The upside with gpiochip_add_pin_range() is that it
uses relative numbers (offsets) for the GPIOs instead
of having to know or calculate the global
GPIO numbers for the range.

> +int msm_pinctrl_probe(struct platform_device *pdev,
> +                     const struct msm_pinctrl_soc_data *soc_data)
> +{
(...)
> +       msm_pinctrl_desc.name = dev_name(&pdev->dev);
> +       msm_pinctrl_desc.pins = pctrl->soc->pins;
> +       msm_pinctrl_desc.npins = pctrl->soc->npins;
> +       pctrl->pctrl = pinctrl_register(&msm_pinctrl_desc, &pdev->dev, pctrl);
> +       if (!pctrl->pctrl) {
> +               dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
> +               irq_domain_remove(pctrl->domain);
> +               r = gpiochip_remove(&pctrl->chip);
> +               return -ENODEV;
> +       }
> +
> +       pinctrl_add_gpio_range(pctrl->pctrl, soc_data->gpio_range);

So get rid of this if you can, this may require you to twist the
init order around, so that you register the pin controller first,
then the gpio chip.

C.f. drivers/pinctrl/pinctrl-abx500.c

Those are the only few things standing out. Maybe this
last thing will be a bit hairy, sorry for that...

Yours,
Linus Walleij
