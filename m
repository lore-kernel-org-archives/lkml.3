Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab3LFVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:25:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:60760 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3LFVZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:25:55 -0500
Date: Fri, 6 Dec 2013 22:25:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Neil Zhang <zhangwm@marvell.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        haojian.zhuang@gmail.com, LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: gic_arch_extn (Was: [PATCH v3] irqchip: mmp: add dt support
 for wakeup)
In-Reply-To: <20131205094931.GB4360@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1312062029560.30673@ionos.tec.linutronix.de>
References: <1386159214-31483-1-git-send-email-zhangwm@marvell.com> <alpine.DEB.2.02.1312042234190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312042347350.30673@ionos.tec.linutronix.de> <20131205005216.GA4360@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1312050157550.30673@ionos.tec.linutronix.de> <20131205094931.GB4360@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Russell King - ARM Linux wrote:
> So there's not much point discussing this with you until you:
> 
> (a) calm down

Done so :)

> (b) analyse it properly and work out the frequency under which each
> class of IRQ (those >= 32 and those < 32) call into these functions.

Here you go:

The frequency of invoking the gic_arch_extn callbacks is exactly equal
to the frequency of interrupts in the system which go through the GIC
at least for mask/unmask/eoi. The frequency of calls per interrupt
depends on the interrupt type, but at minimum it is one.

So basically it does for any interrupt independent of >= 32 or < 32:

irq_fn(d)
{
	do_something_common(d);
	if (gic_arch_extn.fn)
	   gic_arch_extn.fn(d);
	do_something_common(d);
}

which then does:

extn_fn(d)
{
	if (this_irq_is_affected(d))
	   do_some_more(d);
}      

So when this_irq_is_affected(d) boils down to

   if (d->irq [<>] n)

then I agree, that it's debatable, whether the conditonal function
call and the simple this_irq_is_affected(d) check is worth to worry
about. Though there are people who care about two pointless
conditonals for various reasons.

But at the point when this_irq_is_affected(d) is doing a loop lookup,
then this really starts to smell badly.

Sure you might argue, that it's the problem of that particular patch
author to put a loop lookup into this_irq_is_affected().

Fair enough, though you have to admit that the design of the
gic_arch_extn actually enforces that, if you can't do a simple "if irq
[<>] n" check for whatever reason.

The alternative approach to that is to use different irq chip
implementations for interrupts affected by gic_arch_extn and those
which are not affected as we do in lot of other places do deal with
the subtle differences of particular interrupt lines. That definitely
would avoid that people try to stick more complex decision functions
than "irq [<>] n" into this_irq_is_affected().

Now looking at the locking szenario of GIC, it might eventually create
quite some duplicated code, which is undesirable as well. OTOH, the
locking requirements especially if I look at gic_[un]mask_irq and
gic_eoi_irq are not entirely clear to me from the code.

gic_[un]mask_irq(d)
{
	mask = 1 << SFT(gic_irq(d));

	lock(controller_lock);
	if (gic_arch_extn.irq_[un]mask)
	   gic_arch_extn.irq_[un]mask(d);
	writel(mask, GIC_ENABLE_[CLEAR|SET]);
	unlock(controller_lock);
}

while

gic_eoi_irq(d)
{
	if (gic_arch_extn.irq_eoi) {
	   lock(controller_lock);
	   gic_arch_extn.irq_eoi(d);
	   unlock(controller_lock);
	}
	writel(gic_irq(d), GIC_EOI);
}

So is there a requirement to serialize the mask/unmask operations for
a particular interrupt line against mask/unmask operations on a
different core on some other interrupt line?

  The operations for a particular interrupt line are already
  serialized at the core code level.

  The CLEAR/SET registers are designed to avoid locking in contrary to
  the classic ENABLE reg, where you have to maintain consistency of
  the full set of interrupts affected by that register.

  So for the case where gic_arch_extn is not used, the locking is
  completely pointless, right?

Or is this locking required to maintain consistency between the
gic_arch_extn.[un]mask and the GIC.[un]mask itself?

And even if the locking is required for this, then having two separate
chips with two different callbacks makes sense.

gic_mask_irq()
{
	writel(mask, GIC_ENABLE_CLEAR);
}

gic_mask_extn_irq(d)
{
	lock(controller_lock);
	gic_arch_extn.irq_mask(d);
	gic_mask_irq(d);
	unlock(controller_lock);
}

And then have the gic_chip and gic_extn_chip set for the various
interrupt lines.

That avoids several things:

1) The locking for non gic_arch_extn interrupts

2) Two conditionals for gic_arch_extn interrupts

3) The enforcement of adding complex decision functions into the
   gic_extn functions if there is no simple x < N check possible.

I might have missed something as always, but at least I did a proper
analysis of the code as it is understandable to a mere mortal.

Thoughts?

Thanks,

	tglx

