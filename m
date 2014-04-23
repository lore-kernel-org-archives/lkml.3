Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaDWO2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:28:49 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61265 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaDWO2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <5357A594.6050404@linux.intel.com>
References: <1397443272-31467-1-git-send-email-yao.jin@linux.intel.com>
	<534B4C6D.5070003@linux.intel.com>
	<CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com>
	<5357A594.6050404@linux.intel.com>
Date: Wed, 23 Apr 2014 16:28:45 +0200
Message-ID: <CACRpkdYztACye5Xht3f4UuaWDA0gB7t2rgRmpTaL330YcxYhfQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-baytrail: workaround for irq descriptor conflict
 on ASUS T100TA
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Jin, Yao" <yao.jin@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 1:35 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> The real issue to my understanding is that the x86 io-apic code is not
> really capable of living together with other interrupt controllers at the
> same time. There are some assumptions that interrupts 0-15 belong to the
> legacy ISA world, from there on we got io-apic PCI interrupts
> ( I think io-apic interrupt controller handles something like 24 - 48
> interrupts?) we want to be outside that range until this is fixed.
>
> The x86 io-apic code does nasty things, for example the function
> that allocates the irq and the private chip data assumes that if the irq
> descriptor is taken, (returns -EEXISTS) then io-apic just must have reserved
> it earlier and can anyway use it, and access the chip data in a format only
> io-apic (struct irq_cfg) uses. This is of course not the case if a gpio
> interrupt controller like pinctrl-baytrail reserved the interrupt descriptor
> earler.  -> oops
>
> here's the io_apic.c function:
>
> static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
> {
>         int res = irq_alloc_desc_at(at, node);
>         struct irq_cfg *cfg;
>
>         if (res < 0) {
>                 if (res != -EEXIST)
>                         return NULL;
>                 cfg = irq_get_chip_data(at);
>                 if (cfg)
>                         return cfg;
>         }
>
>         cfg = alloc_irq_cfg(at, node);
>         if (cfg)
>                 irq_set_chip_data(at, cfg);
>         else
>                 irq_free_desc(at);
>         return cfg;
> }
>
> We tried to fix this particular issue (make sure the interrupt belongs to a
> io_apic controller before letting io_apic touch it), but we just opened a
> can of worms of other issues I don't know how to deal with.

This looks pretty scary.

io_apic.c is maintained by every single kernel bigshot and I sure
as hell would like to not under any circumstance step on its toes
so whatever solution we can think of until the next merge window
will be applied. (AFICT this affects all baytrails, no desktops etc).

However this is a first time for an embedded irqchip (coupled
with GPIO ACPI) creeping into the x86 world, so it needs some
attention I think, do we have a direction forward for peaceful
coexistence of several irq controllers picking some IRQ
numbers/descriptors dynamically as they probe, also on
x86 systems?

Other archs doesn't seem to have this problem, but they also
do not have the same legacy.

Yours,
Linus Walleij
