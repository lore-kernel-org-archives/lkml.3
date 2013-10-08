Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3JHQFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:05:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10532 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753442Ab3JHQFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:05:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1//6aaSRXGM7x3BG52tAvYu
Date: Tue, 8 Oct 2013 09:05:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Jon Hunter <jgchunter@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
Message-ID: <20131008160529.GA7773@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054221.8941.87801.stgit@localhost>
 <CACRpkda5-dxD+-4mgY6v90awxQhHpNePb5uhWHusb7jf-j5s-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda5-dxD+-4mgY6v90awxQhHpNePb5uhWHusb7jf-j5s-g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [131008 05:18]:
> On Thu, Oct 3, 2013 at 7:42 AM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > This patch adds support for interrupts in a way that
> > should be pretty generic, and works for the omaps that
> > support wake-up interrupts. On omaps, there's an
> > interrupt enable and interrupt status bit for each pin.
> 
> So to be clear: is this enable and status bit in the *same*
> register as all other settings? Then it warrants having this
> under pinctrl-single still and I feel a bit better about this.

Yes there's a status bit on most omaps in the same register
for each pin.

There is a PRM interrupt that has wake-up events for internal
domain wake-ups and io chain wake-ups. The PRM interrupt is
already a chained IRQ. After we get the wake-up interrupt we
need to check the pinctrl registers that have wake-up bit
enabled for the wake-up status bit.

> Second: how does this relate to the case where say
> gpio-omap is using the same pins as a back-end (this
> is a real usecase right)?

The GPIO is a separate hardware block on omaps and has
it's own separate wake-up events.

> So gpio-omap already supports gpio_to_irq() and
> it does not support enable_irq_wake() on the GPIO
> lines as well.

Yeah those are specific to the GPIO block, and not related
to this driver. The GPIO lines have their own wake-up
mechanism that works for retention idle.

For off-idle, only for the first GPIO bank stays powered.
The other GPIO banks get powered down in off-idle mode.
 
> How does this play together? Is it like the pins have a set
> of wakeup IRQs and then the GPIO block has *another*
> set of wakeup IRQs?

Yes that's correct, they are completely separate.
 
> And if you do enable_irq_wake() on the GPIO line,
> should this not fall through to the pinctrl driver, so we
> should add pinctrl_gpio_enable_wake() and
> pinctrl_gpio_disable_wake() just like we have
> pinctrl_gpio_direction_input() and friends today,
> so that this request falls through to the pinctrl driver
> when a wakeup on a certain GPIO line is requested?

That's not needed for most cases at this point, the GPIO
block is already handling it's internal wake-up events.

Eventually we should also handle the corner case of
GPIO wake-up line connected to a GPIO bank that's not
the first bank for off-idle. For most low-power hardware
designs that's not needed as the critial pins typically
are placed in the first GPIO bank for this reason.

But let's first figure out how we want to handle the mapping
of wake-up interrupts to device interrupts in general.

Most omap devices have a dedicated io chain wake-up line, so
that's really the key thing to get working first.
 
> Now gpio-omap.c does not seem to use the pinctrl
> back-end commands, instead of using e.g.
> pinctrl_gpio_request() and GPIO to pin ranges it
> seems to use this hack:
> 
> static void _enable_gpio_module(struct gpio_bank *bank, unsigned offset)
> {
>         if (bank->regs->pinctrl) {
>                 void __iomem *reg = bank->base + bank->regs->pinctrl;
> 
>                 /* Claim the pin for MPU */
>                 __raw_writel(__raw_readl(reg) | (1 << offset), reg);
>         }
> 
> Can't we please make the OMAP GPIO driver use the
> pinctrl back-end with gpio ranges properly *before* we proceed
> to doing this kind of stuff? I think it is already looking
> like a bit of layered hacks :-(

Heh, that's not true. And I can totally see where the confusion
comes from :)

The naming "pinctrl" in the GPIO driver is a bit confusing and
it's use predates the pinctrl framework and has been in the GPIO
driver for probably 10 years or so.

The above does not have anything to do with the pinctrl
framework or this pinctrl driver. That is to mux the GPIO pins
inside the GPIO block between the ARM core and the DSP.
 
> Haojian is already using the pinctrl-single as backend to
> another GPIO controller (I think it's pinctrl-pl061.c) so surely
> this should be possible to do right.

Sure we can make the GPIO off-idle wake-up handling automatic
for the GPIO not in the first bank, but that's really a separate
patch.
 
> IIRC there are also other OMAP GPIO blocks so we need
> to look at the large picture here, for all of them.

Sorry I don't know which other OMAP GPIO blocks you're talking
about, care to be a bit more specific?

All the omaps I've seen use the gpio-omap.c. The other GPIOs
are typically on I2C chips.

Regards,

Tony
