Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaHMOXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:23:12 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49150 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751518AbaHMOXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:23:11 -0400
Date: Wed, 13 Aug 2014 15:22:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call
	into scheduler
Message-ID: <20140813142257.GK30401@n2100.arm.linux.org.uk>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 06:57:18AM -0700, Stephen Boyd wrote:
> Commit 1a6b69b6548c (ARM: gic: add CPU migration support,
> 2012-04-12) introduced an acquisition of the irq_controller_lock
> in gic_raise_softirq() which can lead to a spinlock recursion if
> the gic_arch_extn hooks call into the scheduler (via complete()
> or wake_up(), etc.). This happens because gic_arch_extn hooks are
> normally called with the irq_controller_lock held and calling
> into the scheduler may cause us to call smp_send_reschedule()
> which will grab the irq_controller_lock again. Here's an example
> from a vendor kernel (note that the gic_arch_extn hook code here
> isn't actually in mainline):

Here's a question: why would you want to call into the scheduler from
the gic_arch_extn code?

Oh.  My.  God.  Thomas, what have you done to the generic IRQ layer?
This is /totally/ unsafe:

void disable_irq(unsigned int irq)
{
        if (!__disable_irq_nosync(irq))
                synchronize_irq(irq);
}

static int __disable_irq_nosync(unsigned int irq)
{
        unsigned long flags;
        struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);

        if (!desc)
                return -EINVAL;
        __disable_irq(desc, irq, false);
        irq_put_desc_busunlock(desc, flags);
        return 0;
}

void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
{
        if (suspend) {
                if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
                        return;
                desc->istate |= IRQS_SUSPENDED;
        }

        if (!desc->depth++)
                irq_disable(desc);
}

You realise that disable_irq() and enable_irq() can be called by
concurrently by different drivers for the /same/ interrupt.  For
starters, that post-increment there is completely unprotected against
races.  Secondly, the above is completely racy against a concurrent
enable_irq() - what if we're in disable_irq(), we've incremented
depth, but have yet to call irq_disable().  The count now has a
value of 1.

We then preempt, and run another thread which calls enable_irq()
on it.  This results in the depth being decremented, and the IRQ
is now enabled.

We resume the original thread, and continue to call irq_disable(),
resulting in the interrupt being disabled.

That's not nice (the right answer is that it's strictly an unbalanced
enable_irq(), but that's no excuse here.)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
