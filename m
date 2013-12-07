Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161528Ab3LGAoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:44:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44060 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3LGAoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:44:10 -0500
Date: Sat, 7 Dec 2013 00:43:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Neil Zhang <zhangwm@marvell.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        haojian.zhuang@gmail.com, LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: gic_arch_extn (Was: [PATCH v3] irqchip: mmp: add dt
	support for wakeup)
Message-ID: <20131207004337.GN4360@n2100.arm.linux.org.uk>
References: <1386159214-31483-1-git-send-email-zhangwm@marvell.com> <alpine.DEB.2.02.1312042234190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312042347350.30673@ionos.tec.linutronix.de> <20131205005216.GA4360@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1312050157550.30673@ionos.tec.linutronix.de> <20131205094931.GB4360@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1312062029560.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312062029560.30673@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 10:25:49PM +0100, Thomas Gleixner wrote:
> The frequency of invoking the gic_arch_extn callbacks is exactly equal
> to the frequency of interrupts in the system which go through the GIC
> at least for mask/unmask/eoi. The frequency of calls per interrupt
> depends on the interrupt type, but at minimum it is one.
> 
> So basically it does for any interrupt independent of >= 32 or < 32:
> 
> irq_fn(d)
> {
> 	do_something_common(d);
> 	if (gic_arch_extn.fn)
> 	   gic_arch_extn.fn(d);
> 	do_something_common(d);
> }
> 
> which then does:
> 
> extn_fn(d)
> {
> 	if (this_irq_is_affected(d))
> 	   do_some_more(d);
> }      
> 
> So when this_irq_is_affected(d) boils down to
> 
>    if (d->irq [<>] n)
> 
> then I agree, that it's debatable, whether the conditonal function
> call and the simple this_irq_is_affected(d) check is worth to worry
> about. Though there are people who care about two pointless
> conditonals for various reasons.


Right - and as you correctly identify, it has become clear through code
evolution that there is a difference between the extended handling of
IRQs above and below the 32 breakpoint.

Now, what you previously termed the hotpath - IRQs less than 32 - isn't
the path we want to optimise for, unless it is our intention to optimise
for an idle system.  Why?

IRQs 0-15 won't be seen in this path - they're the IPIs which are handled
completely outside of genirq.  So that leaves IRQs 16 to 31.  Of course,
only one or two are normally used (the watchdog driver has been removed,
so we're really down to just the local timer interrupt.)  In a system
doing work, you're going to have normal IRQs (IRQs >= 32) occuring,
probably at a much faster rate than the local timer interrupt.

Hence, there are two cases to optimise for: the case without the
extension hooks, and the case with the extension hook for IRQs >= 32.
Optimising the case for IRQ < 32 makes no sense because we're
effectively optimising for one IRQ vs all the rest.

Moving the test for IRQs >= 32 to the GIC code puts extra code and
overhead into that path, perturbing the case without extension - and
that's the use case we want to encourage.  Hence, having that test in
the code where the extension is needed makes total sense.

> But at the point when this_irq_is_affected(d) is doing a loop lookup,
> then this really starts to smell badly.

And why would that be a loop?  I can't speak for how it's been used
since it was introduced for OMAP - and it's well known why - remember,
we have arm-soc, and arm-soc deals with the SoC specific code, and as
such I no longer know what SoCs are doing with this stuff.

> The alternative approach to that is to use different irq chip
> implementations for interrupts affected by gic_arch_extn and those
> which are not affected as we do in lot of other places do deal with
> the subtle differences of particular interrupt lines. That definitely
> would avoid that people try to stick more complex decision functions
> than "irq [<>] n" into this_irq_is_affected().

... which results in more complexity.  Do we need complex code?  Do
we have implementations which loop?  Why make the thing complex in this
way if it's not actually required.  What you seem to be asking is for
overdesign to happen.  That's completely contary to the Linux philosophy.

Now, it may be that _since_ this code was originally merged, it does
need this complexity, but I'm not aware of it (see above for _why_), and
no one else has spotted this.  So to rant about it as if it's the worst
thing on the planet is a total over-reaction.

You may also like to note that I'm not Cc'd on GIC patches anymore.

> Now looking at the locking szenario of GIC, it might eventually create
> quite some duplicated code, which is undesirable as well. OTOH, the
> locking requirements especially if I look at gic_[un]mask_irq and
> gic_eoi_irq are not entirely clear to me from the code.
> 
> gic_[un]mask_irq(d)
> {
> 	mask = 1 << SFT(gic_irq(d));
> 
> 	lock(controller_lock);
> 	if (gic_arch_extn.irq_[un]mask)
> 	   gic_arch_extn.irq_[un]mask(d);
> 	writel(mask, GIC_ENABLE_[CLEAR|SET]);
> 	unlock(controller_lock);
> }

Do you really want to know what's absolutely hillarious here?  You're
now complaining about the locking in here...

commit c4bfa28aec58c588de55babe99f4c172ec534704
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Jul 1 22:32:14 2006 +0100

    [ARM] 3686/1: ARM: arm/common: convert irq handling
    
    Patch from Thomas Gleixner
    
    From: Thomas Gleixner <tglx@linutronix.de>
    
    Convert the files in arch/arm/common to use the generic
    irq handling functions.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index c02dc8116a18..f3c1ebfdd0aa 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -33,6 +33,7 @@
 
 static void __iomem *gic_dist_base;
 static void __iomem *gic_cpu_base;
+static DEFINE_SPINLOCK(irq_controller_lock);
 
 /*
  * Routines to acknowledge, disable and enable interrupts
@@ -52,32 +53,45 @@ static void __iomem *gic_cpu_base;
 static void gic_ack_irq(unsigned int irq)
 {
        u32 mask = 1 << (irq % 32);
+
+       spin_lock(&irq_controller_lock);
        writel(mask, gic_dist_base + GIC_DIST_ENABLE_CLEAR + (irq / 32) * 4);
        writel(irq, gic_cpu_base + GIC_CPU_EOI);
+       spin_unlock(&irq_controller_lock);
 }
 
 static void gic_mask_irq(unsigned int irq)
 {
        u32 mask = 1 << (irq % 32);
+
+       spin_lock(&irq_controller_lock);
        writel(mask, gic_dist_base + GIC_DIST_ENABLE_CLEAR + (irq / 32) * 4);
+       spin_unlock(&irq_controller_lock);
 }
 
 static void gic_unmask_irq(unsigned int irq)
 {
        u32 mask = 1 << (irq % 32);
+
+       spin_lock(&irq_controller_lock);
        writel(mask, gic_dist_base + GIC_DIST_ENABLE_SET + (irq / 32) * 4);
+       spin_unlock(&irq_controller_lock);
 }

... which is something you added in the first place, when you converted
the GIC to your genirq stuff. :)

> And even if the locking is required for this, then having two separate
> chips with two different callbacks makes sense.
> 
> gic_mask_irq()
> {
> 	writel(mask, GIC_ENABLE_CLEAR);
> }
> 
> gic_mask_extn_irq(d)
> {
> 	lock(controller_lock);
> 	gic_arch_extn.irq_mask(d);
> 	gic_mask_irq(d);
> 	unlock(controller_lock);
> }
> 
> And then have the gic_chip and gic_extn_chip set for the various
> interrupt lines.

Since knowledge of what platforms do with this extension has been long
lost (well, no one person ever had it because responsibility for this
stuff has been devolved...) I doubt we can safely get rid of that lock
without someone auditing this stuff.

Since I'm apparantly no longer responsible for the GIC - and I'm rarely
copied with patches for it anymore, I've basically washed my hands of
it - it seems everyone else maintains it now.
