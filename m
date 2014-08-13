Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaHMOza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:55:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42528 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaHMOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:55:28 -0400
Date: Wed, 13 Aug 2014 07:55:26 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
Message-ID: <20140813145526.GF32301@codeaurora.org>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org>
 <20140813142257.GK30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813142257.GK30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Russell King - ARM Linux wrote:
> On Wed, Aug 13, 2014 at 06:57:18AM -0700, Stephen Boyd wrote:
> > Commit 1a6b69b6548c (ARM: gic: add CPU migration support,
> > 2012-04-12) introduced an acquisition of the irq_controller_lock
> > in gic_raise_softirq() which can lead to a spinlock recursion if
> > the gic_arch_extn hooks call into the scheduler (via complete()
> > or wake_up(), etc.). This happens because gic_arch_extn hooks are
> > normally called with the irq_controller_lock held and calling
> > into the scheduler may cause us to call smp_send_reschedule()
> > which will grab the irq_controller_lock again. Here's an example
> > from a vendor kernel (note that the gic_arch_extn hook code here
> > isn't actually in mainline):
> 
> Here's a question: why would you want to call into the scheduler from
> the gic_arch_extn code?

In this case we want to send a message to another processor when
an interrupt is enabled that's only a wakeup interrupt in certain
low power states. It's done sort of indirectly, but basically we
block that low power state from being entered so we can ensure
that the interrupt wakes us up from a lighter version of suspend.

> 
> Oh.  My.  God.  Thomas, what have you done to the generic IRQ layer?
> This is /totally/ unsafe:
> 
> void disable_irq(unsigned int irq)
> {
>         if (!__disable_irq_nosync(irq))
>                 synchronize_irq(irq);
> }
> 
> static int __disable_irq_nosync(unsigned int irq)
> {
>         unsigned long flags;
>         struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);

We got the lock here.

> 
>         if (!desc)
>                 return -EINVAL;
>         __disable_irq(desc, irq, false);
>         irq_put_desc_busunlock(desc, flags);
>         return 0;
> }
> 
> void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
> {
>         if (suspend) {
>                 if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
>                         return;
>                 desc->istate |= IRQS_SUSPENDED;
>         }
> 
>         if (!desc->depth++)

We're still holding the lock here right?

>                 irq_disable(desc);
> }
> 
> You realise that disable_irq() and enable_irq() can be called by
> concurrently by different drivers for the /same/ interrupt. 

Sure.

> For
> starters, that post-increment there is completely unprotected against
> races.  Secondly, the above is completely racy against a concurrent
> enable_irq() - what if we're in disable_irq(), we've incremented
> depth, but have yet to call irq_disable().  The count now has a
> value of 1.
> 
> We then preempt, and run another thread which calls enable_irq()
> on it.  This results in the depth being decremented, and the IRQ
> is now enabled.

How? Aren't we holding the descriptor lock?

> 
> We resume the original thread, and continue to call irq_disable(),
> resulting in the interrupt being disabled.
> 
> That's not nice (the right answer is that it's strictly an unbalanced
> enable_irq(), but that's no excuse here.)
> 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
