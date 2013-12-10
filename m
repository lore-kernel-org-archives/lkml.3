Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3LJANy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:13:54 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2180 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab3LJANu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:13:50 -0500
Date: Tue, 10 Dec 2013 00:10:31 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] pinctrl: Add Qualcomm TLMM driver
Message-ID: <20131210081031.GD11990@sonymobile.com>
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1386295805-13708-2-git-send-email-bjorn.andersson@sonymobile.com>
 <52A24438.4000908@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52A24438.4000908@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06 Dec 13:40 PST 2013, Stephen Boyd wrote:

> General nitpick: There seems to be a lot of checks for invalid input in
> the op functions. I hope that they're all unnecessary debugging that can
> be removed.
> 

Most of them checks that a gpio number is not larger than the number of pingroups.
This would be much cleaner to just replace with a validation in probe().

...
> >
> > +config PINCTRL_MSM
> > +     bool
> 
> Why not tristate?
> 

I have a hard time seeing an situation where you would like to build a system
with this driver as a module; it would force almost the entire system to be
loaded at a later time...

> > +/**
> > + * struct msm_pinctrl - state for a pinctrl-msm device
> > + * @dev:            device handle.
> > + * @pctrl:          pinctrl handle.
> > + * @domain:         irqdomain handle.
> > + * @chip:           gpiochip handle.
> > + * @irq:            parent irq for the TLMM irq_chip.
> > + * @lock:           Spinlock to protect register resources as well
> > + *                  as msm_pinctrl data structures.
> > + * @enabled_irqs:   Bitmap of currently enabled irqs.
> > + * @dual_edge_irqs: Bitmap of irqs that need sw emulated dual edge
> > + *                  detection.
> > + * @wake_irqs:      Bitmap of irqs with requested as wakeup source.
> > + * @soc;            Reference to soc_data of platform specific data.
> > + * @regs:           Base address for the TLMM register map.
> > + */
> > +struct msm_pinctrl {
> > +     struct device *dev;
> > +     struct pinctrl_dev *pctrl;
> > +     struct irq_domain *domain;
> > +     struct gpio_chip chip;
> > +     unsigned irq;
> > +
> > +     spinlock_t lock;
> > +
> > +     unsigned long *enabled_irqs;
> > +     unsigned long *dual_edge_irqs;
> > +     unsigned long *wake_irqs;
> 
> In the gpio driver we went with a static upper limit on the bitmap. That
> allowed us to avoid small allocations fragmenting the heap. Please do
> the same here (look at gpio-msm-v2.c).
> 

Sounds reasonable.

> > +static struct pinctrl_ops msm_pinctrl_ops = {
> 
> const?
> 

Of course.

> > +static struct pinmux_ops msm_pinmux_ops = {
> 
> const?
> 

Of course.

> > +static struct pinconf_ops msm_pinconf_ops = {
> 
> const?
> 

Of course.

> > +static int msm_gpio_direction_output(struct gpio_chip *chip, unsigned offset, int value)
> > +{
> > +     const struct msm_pingroup *g;
> > +     struct msm_pinctrl *pctrl = container_of(chip, struct msm_pinctrl, chip);
> > +     unsigned long flags;
> > +     u32 val;
> > +
> > +     if (WARN_ON(offset >= pctrl->soc->ngroups))
> > +             return -EINVAL;
> 
> How is this possible?
> 

If the soc specific ngpios is greater than ngroups this would happen. But it's much better
to catch that earlier!

> > +static void msm_gpio_dbg_show_one(struct seq_file *s,
> > +                               struct pinctrl_dev *pctldev,
> > +                               struct gpio_chip *chip,
> > +                               unsigned offset,
> > +                               unsigned gpio)
> > +{
> > +     const struct msm_pingroup *g;
> > +     struct msm_pinctrl *pctrl = container_of(chip, struct msm_pinctrl, chip);
> > +     unsigned func;
> > +     int is_out;
> > +     int drive;
> > +     int pull;
> > +     u32 ctl_reg;
> > +
> > +     const char *pulls[] = {
> 
> static const char * const ?
> 

Makes sense.
> > +             "no pull",
> > +             "pull down",
> > +             "keeper",
> > +             "pull up"
> > +     };
> > +
> > +     g = &pctrl->soc->groups[offset];
> > +     ctl_reg = readl(pctrl->regs + g->ctl_reg);
> > +
> > +     is_out = !!(ctl_reg & BIT(g->oe_bit));
> > +     func = (ctl_reg >> g->mux_bit) & 7;
> > +     drive = (ctl_reg >> g->drv_bit) & 7;
> > +     pull = (ctl_reg >> g->pull_bit) & 3;
> > +
> > +     seq_printf(s, " %-8s: %-3s %d", g->name, is_out ? "out" : "in", func);
> > +     seq_printf(s, " %dmA", msm_regval_to_drive[drive]);
> > +     seq_printf(s, " %s", pulls[pull]);
> > +}
> > +
> > +static void msm_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> > +{
> > +     unsigned gpio = chip->base;
> > +     unsigned i;
> > +
> > +     for (i = 0; i < chip->ngpio; i++, gpio++) {
> > +             msm_gpio_dbg_show_one(s, NULL, chip, i, gpio);
> > +             seq_printf(s, "\n");
> 
> seq_puts()?
> 

OK.

> > +static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
> > +{
> > +     const struct msm_pingroup *g;
> > +     struct msm_pinctrl *pctrl;
> > +     unsigned long flags;
> > +     u32 val;
> > +
> > +     pctrl = irq_data_get_irq_chip_data(d);
> > +     if (!pctrl)
> > +             return -EINVAL;
> 
> How is this possible?
> 

As long as probe() is single threaded this should never be an issue, so I think
it makes sense to drop it.

> > +     val = readl(pctrl->regs + g->intr_cfg_reg);
> > +     val |= BIT(g->intr_raw_status_bit);
> > +     if (g->intr_detection_width == 2) {
> > +             val &= ~(3 << g->intr_detection_bit);
> > +             val &= ~(1 << g->intr_polarity_bit);
> > +             switch (type) {
> > +             case IRQ_TYPE_EDGE_RISING:
> > +                     val |= 1 << g->intr_detection_bit;
> > +                     val |= BIT(g->intr_polarity_bit);
> > +                     break;
> > +             case IRQ_TYPE_EDGE_FALLING:
> > +                     val |= 2 << g->intr_detection_bit;
> > +                     val |= BIT(g->intr_polarity_bit);
> > +                     break;
> > +             case IRQ_TYPE_EDGE_BOTH:
> > +                     val |= 3 << g->intr_detection_bit;
> > +                     val |= BIT(g->intr_polarity_bit);
> > +                     break;
> > +             case IRQ_TYPE_LEVEL_LOW:
> > +                     break;
> > +             case IRQ_TYPE_LEVEL_HIGH:
> > +                     val |= BIT(g->intr_polarity_bit);
> > +                     break;
> > +             }
> > +     } else if (g->intr_detection_width == 1) {
> > +             val &= ~(1 << g->intr_detection_bit);
> > +             val &= ~(1 << g->intr_polarity_bit);
> > +             switch (type) {
> > +             case IRQ_TYPE_EDGE_RISING:
> > +                     val |= BIT(g->intr_detection_bit);
> > +                     val |= BIT(g->intr_polarity_bit);
> > +                     break;
> > +             case IRQ_TYPE_EDGE_FALLING:
> > +                     val |= BIT(g->intr_detection_bit);
> > +                     break;
> > +             case IRQ_TYPE_EDGE_BOTH:
> > +                     val |= BIT(g->intr_detection_bit);
> > +                     break;
> > +             case IRQ_TYPE_LEVEL_LOW:
> > +                     break;
> > +             case IRQ_TYPE_LEVEL_HIGH:
> > +                     val |= BIT(g->intr_polarity_bit);
> > +                     break;
> > +             }
> > +     } else {
> > +             BUG();
> > +     }
> 
> This would be better written as a collection of ifs so that
> IRQ_TYPE_EDGE_BOTH doesn't have to be tested and we duplicate less code.
> 

I've rewritten this numerous times and this is the cleanest way I can find
to do this in. Yes, there's some duplication but it has a cleaner structure
and easier to follow than the nested if/elseif/else statements.

So I would like to keep it as is.

> > +     /*
> > +      * Each pin have it's own IRQ status register, so use
> 
> s/have/has/
> 

Thanks.

> > +     /* No interrutps where flagged */
> 
> s/where/were/
> s/interrutps/interrupts/

Thanks.

> > +     pctrl->enabled_irqs = devm_kzalloc(pctrl->dev,
> > +                                        sizeof(unsigned long) * BITS_TO_LONGS(chip->ngpio),
> > +                                        GFP_KERNEL);
> 
> If you don't agree with how gpio-msm-v2.c does it, please use
> devm_kcalloc().
> 

If we're to cause churn I think it's better to go with your suggested
approach.

> > +     pctrl->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> 
> Why not use platform_get_irq()?
> 

I just followed suit, but as I have *pdev here there's no reason to call
irq_of_parse_and_map yet again.

> > +int msm_pinctrl_remove(struct platform_device *pdev)
> > +{
> > +     struct msm_pinctrl *pctrl = platform_get_drvdata(pdev);
> > +     int ret;
> > +
> > +     irq_set_chained_handler(pctrl->irq, NULL);
> > +     irq_domain_remove(pctrl->domain);
> > +     ret = gpiochip_remove(&pctrl->chip);
> > +     pinctrl_unregister(pctrl->pctrl);
> > +
> > +     return 0;
> 
> return ret?
> 

I was intentionally ignoring the return value of gpiochip_remove, but that's of
course incorrect. I'll restructure this to make sense, and care about
gpiochip_remove returning e.g EBUSY.

> > +#include <linux/pinctrl/pinctrl.h>
> > +#include <linux/pinctrl/pinmux.h>
> > +#include <linux/pinctrl/pinconf.h>
> > +#include <linux/pinctrl/machine.h>
> 
> Are any of these includes actually necessary? Can't we just forward
> declare struct pinctrl_pin_desc?
> 

None of them are needed in the current set of patches, as these are already
included in the c-files before including this.

But the right set should be: platform_device.h and pinctrl.h.

> > +
> >
> > +struct msm_pingroup {
> > +     const char *name;
> > +     const unsigned *pins;
> > +     unsigned npins;
> > +
> > +     unsigned funcs[8];
> > +
> > +     s16 ctl_reg;
> > +     s16 io_reg;
> > +     s16 intr_cfg_reg;
> > +     s16 intr_status_reg;
> > +     s16 intr_target_reg;
> 
> Why are these signed? Because the macros assign -1 to them? Perhaps make
> them unsigned and make the macro assign ~0U?
> 

Only reason is that I prefer to have invalid values falling outside the
possibly valid memory range.


Thanks for you review Stephen.

Regards,
Bjorn
