Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3JHMKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:10:30 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54779 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3JHMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:10:27 -0400
MIME-Version: 1.0
In-Reply-To: <20131003054221.8941.87801.stgit@localhost>
References: <20131003054104.8941.88857.stgit@localhost>
	<20131003054221.8941.87801.stgit@localhost>
Date: Tue, 8 Oct 2013 14:10:27 +0200
Message-ID: <CACRpkda5-dxD+-4mgY6v90awxQhHpNePb5uhWHusb7jf-j5s-g@mail.gmail.com>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Jon Hunter <jgchunter@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 7:42 AM, Tony Lindgren <tony@atomide.com> wrote:

> This patch adds support for interrupts in a way that
> should be pretty generic, and works for the omaps that
> support wake-up interrupts. On omaps, there's an
> interrupt enable and interrupt status bit for each pin.

So to be clear: is this enable and status bit in the *same*
register as all other settings? Then it warrants having this
under pinctrl-single still and I feel a bit better about this.

Second: how does this relate to the case where say
gpio-omap is using the same pins as a back-end (this
is a real usecase right)?

So gpio-omap already supports gpio_to_irq() and
it does not support enable_irq_wake() on the GPIO
lines as well.

How does this play together? Is it like the pins have a set
of wakeup IRQs and then the GPIO block has *another*
set of wakeup IRQs?

And if you do enable_irq_wake() on the GPIO line,
should this not fall through to the pinctrl driver, so we
should add pinctrl_gpio_enable_wake() and
pinctrl_gpio_disable_wake() just like we have
pinctrl_gpio_direction_input() and friends today,
so that this request falls through to the pinctrl driver
when a wakeup on a certain GPIO line is requested?

Now gpio-omap.c does not seem to use the pinctrl
back-end commands, instead of using e.g.
pinctrl_gpio_request() and GPIO to pin ranges it
seems to use this hack:

static void _enable_gpio_module(struct gpio_bank *bank, unsigned offset)
{
        if (bank->regs->pinctrl) {
                void __iomem *reg = bank->base + bank->regs->pinctrl;

                /* Claim the pin for MPU */
                __raw_writel(__raw_readl(reg) | (1 << offset), reg);
        }

Can't we please make the OMAP GPIO driver use the
pinctrl back-end with gpio ranges properly *before* we proceed
to doing this kind of stuff? I think it is already looking
like a bit of layered hacks :-(

Haojian is already using the pinctrl-single as backend to
another GPIO controller (I think it's pinctrl-pl061.c) so surely
this should be possible to do right.

IIRC there are also other OMAP GPIO blocks so we need
to look at the large picture here, for all of them.

Yours,
Linus Walleij
