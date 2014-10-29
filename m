Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbaJ2KK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:10:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:48624 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328AbaJ2KKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:10:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,809,1406617200"; 
   d="scan'208";a="627535976"
Date: Wed, 29 Oct 2014 12:10:47 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] pinctrl: Add Intel Cherryview/Braswell pin
 controller support
Message-ID: <20141029101047.GL1304@lahna.fi.intel.com>
References: <1414153014-152246-1-git-send-email-mika.westerberg@linux.intel.com>
 <1414153014-152246-5-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdY0+VAfMJDtn2LovV_ngKSOr+sv51ns+FD9a2oZG3SZ5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY0+VAfMJDtn2LovV_ngKSOr+sv51ns+FD9a2oZG3SZ5g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:35:01AM +0100, Linus Walleij wrote:
> On Fri, Oct 24, 2014 at 2:16 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > This driver supports the pin/GPIO controllers found in newer Intel SoCs
> > like Cherryview and Braswell. The driver provides full GPIO support and
> > minimal set of pin controlling funtionality.
> >
> > The driver is based on the original Cherryview GPIO driver authored by Ning
> > Li and Alan Cox.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> *VERY* nice work Mika! Just minor nitpicks...
> 
> (...)
> > +static int chv_config_get(struct pinctrl_dev *pctldev, unsigned pin,
> > +                         unsigned long *config)
> > +{
> > +       struct chv_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
> > +       enum pin_config_param param = pinconf_to_config_param(*config);
> > +       unsigned long flags;
> > +       u32 ctrl0, ctrl1;
> > +       u16 arg = 0;
> > +       u32 term;
> > +
> > +       spin_lock_irqsave(&pctrl->lock, flags);
> > +       ctrl0 = readl(chv_padreg(pctrl, pin, CHV_PADCTRL0));
> > +       ctrl1 = readl(chv_padreg(pctrl, pin, CHV_PADCTRL1));
> > +       spin_unlock_irqrestore(&pctrl->lock, flags);
> > +
> > +       term = (ctrl0 & CHV_PADCTRL0_TERM_MASK) >> CHV_PADCTRL0_TERM_SHIFT;
> > +
> > +       switch (param) {
> > +       case PIN_CONFIG_BIAS_DISABLE:
> > +               if (term)
> > +                       return -EINVAL;
> > +               break;
> > +
> > +       case PIN_CONFIG_BIAS_PULL_UP:
> > +               if (!(ctrl0 & CHV_PADCTRL0_TERM_UP))
> > +                       return -EINVAL;
> > +
> > +               switch (term) {
> > +               case CHV_PADCTRL0_TERM_20K:
> > +                       arg = 20;
> 
> These are in Ohms IIRC so should be 20000
> 
> > +                       break;
> > +               case CHV_PADCTRL0_TERM_5K:
> > +                       arg = 5;
> 
> 5000
> 
> > +                       break;
> > +               case CHV_PADCTRL0_TERM_1K:
> > +                       arg = 1;
> 
> 1000
> 
> > +                       break;
> > +               }
> > +
> > +               break;
> > +
> > +       case PIN_CONFIG_BIAS_PULL_DOWN:
> > +               if (!term || (ctrl0 & CHV_PADCTRL0_TERM_UP))
> > +                       return -EINVAL;
> > +
> > +               switch (term) {
> > +               case CHV_PADCTRL0_TERM_20K:
> > +                       arg = 20;
> 
> 20000
> 
> > +                       break;
> > +               case CHV_PADCTRL0_TERM_5K:
> > +                       arg = 5;
> 
> 5000

Right, I'll change them.

> (...)
> > +static int chv_config_set_pull(struct chv_pinctrl *pctrl, unsigned pin,
> > +                              enum pin_config_param param, u16 arg)
> > +{
> > +       void __iomem *reg = chv_padreg(pctrl, pin, CHV_PADCTRL0);
> > +       unsigned long flags;
> > +       u32 ctrl0, pull;
> > +
> > +       spin_lock_irqsave(&pctrl->lock, flags);
> > +       ctrl0 = readl(reg);
> > +
> > +       pull = CHV_PADCTRL0_TERM_20K << CHV_PADCTRL0_TERM_SHIFT;
> > +       switch (arg) {
> 
> This looks seriously convoluted: you can't inspect an argument before
> checking what parameter you're dealing with. This should be
> under a case PIN_CONFIG_BIAS_PULL_UP in the switch (param)
> below I think?

OK.

> 
> > +       case 1:
> 
> case 1000
> 
> > +               /* For 1k there is only pull up */
> > +               if (param == PIN_CONFIG_BIAS_PULL_UP)
> > +                       pull = CHV_PADCTRL0_TERM_1K << CHV_PADCTRL0_TERM_SHIFT;
> 
> Well you do check it here but...0
> 
> > +               break;
> > +       case 5:
> 
> case 5000
> 
> > +               pull = CHV_PADCTRL0_TERM_5K << CHV_PADCTRL0_TERM_SHIFT;
> 
> This will be applied to whatever config with arg == 5000 comes here!
> 
> (...)
> > +static unsigned chv_gpio_offset_to_pin(struct chv_pinctrl *pctrl,
> > +                                      unsigned offset)
> > +{
> > +       return pctrl->community->pins[offset].number;
> > +}
> 
> I'm a bit worried about the massive pin<->offsets<->gpio# translations
> happening in this and patch 1/4 etc. It's a bit unsettling. Are you
> sure we are translating in the simplest way?

We are translating from ACPI GPIO number, which is relative to the GPIO
controller in question to pin controller space (which is not 1:1 in this
driver).

I'll double check this, just in case.

> > +static int chv_gpio_get(struct gpio_chip *chip, unsigned offset)
> > +{
> > +       struct chv_pinctrl *pctrl = gpiochip_to_pinctrl(chip);
> > +       int pin = chv_gpio_offset_to_pin(pctrl, offset);
> > +       unsigned long flags;
> > +       u32 ctrl0, cfg;
> > +
> > +       spin_lock_irqsave(&pctrl->lock, flags);
> > +       ctrl0 = readl(chv_padreg(pctrl, pin, CHV_PADCTRL0));
> > +       spin_unlock_irqrestore(&pctrl->lock, flags);
> 
> If you need a lock before and after reading every register in this
> range, consider regmap-mmio, because that is part of what
> it does. Just a hint...

Yeah, I don't think we need a lock for reading simple registers so I'll
remove such usage from the driver.

> (...)
> > +static void chv_gpio_irq_mask_unmask(struct irq_data *d, bool mask)
> > +{
> > +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> > +       struct chv_pinctrl *pctrl = gpiochip_to_pinctrl(gc);
> > +       int pin = chv_gpio_offset_to_pin(pctrl, irqd_to_hwirq(d));
> > +       u32 value, intr_line;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&pctrl->lock, flags);
> > +
> > +       intr_line = readl(chv_padreg(pctrl, pin, CHV_PADCTRL0));
> > +       intr_line &= CHV_PADCTRL0_INTSEL_MASK;
> > +       intr_line >>= CHV_PADCTRL0_INTSEL_SHIFT;
> > +
> > +       value = readl(pctrl->regs + CHV_INTMASK);
> > +       if (mask)
> > +               value &= ~(1 << intr_line);
> 
> I usually do this kind of stuff with
> 
> #include <linux/bitops.h>
> 
> value &= ~BIT(intr_line);
> 
> > +       else
> > +               value |= (1 << intr_line);
> 
> value |= BIT(intr_line);
> 
> (probably a few more occasions in the driver)

OK, will fix.
