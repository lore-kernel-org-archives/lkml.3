Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaHMOxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:53:55 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43505 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaHMOxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:53:53 -0400
Message-ID: <53EB7BF7.1080702@linaro.org>
Date: Wed, 13 Aug 2014 15:53:43 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org> <20140813142257.GK30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140813142257.GK30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 15:22, Russell King - ARM Linux wrote:
> On Wed, Aug 13, 2014 at 06:57:18AM -0700, Stephen Boyd wrote:
>> Commit 1a6b69b6548c (ARM: gic: add CPU migration support,
>> 2012-04-12) introduced an acquisition of the irq_controller_lock
>> in gic_raise_softirq() which can lead to a spinlock recursion if
>> the gic_arch_extn hooks call into the scheduler (via complete()
>> or wake_up(), etc.). This happens because gic_arch_extn hooks are
>> normally called with the irq_controller_lock held and calling
>> into the scheduler may cause us to call smp_send_reschedule()
>> which will grab the irq_controller_lock again. Here's an example
>> from a vendor kernel (note that the gic_arch_extn hook code here
>> isn't actually in mainline):
> 
> Here's a question: why would you want to call into the scheduler from
> the gic_arch_extn code?
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

irq_get_desc_buslock() results in us owning the descriptor's lock
(raw_spinlock_t).

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
>                 irq_disable(desc);
> }
> 
> You realise that disable_irq() and enable_irq() can be called by
> concurrently by different drivers for the /same/ interrupt.  For
> starters, that post-increment there is completely unprotected against
> races.  Secondly, the above is completely racy against a concurrent
> enable_irq() - what if we're in disable_irq(), we've incremented
> depth, but have yet to call irq_disable().  The count now has a
> value of 1.
> 
> We then preempt, and run another thread which calls enable_irq()
> on it.  This results in the depth being decremented, and the IRQ
> is now enabled.

We shouldn't get that far due to the spinlock taken during the disable.


> We resume the original thread, and continue to call irq_disable(),
> resulting in the interrupt being disabled.
> 
> That's not nice (the right answer is that it's strictly an unbalanced
> enable_irq(), but that's no excuse here.)
> 

