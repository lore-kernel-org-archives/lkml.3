Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaHMPbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:31:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44617 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaHMPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:31:30 -0400
Date: Wed, 13 Aug 2014 08:31:29 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
Message-ID: <20140813153129.GH32301@codeaurora.org>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org>
 <20140813142257.GK30401@n2100.arm.linux.org.uk>
 <20140813145526.GF32301@codeaurora.org>
 <20140813150540.GL30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813150540.GL30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Russell King - ARM Linux wrote:
> On Wed, Aug 13, 2014 at 07:55:26AM -0700, Stephen Boyd wrote:
> > On 08/13, Russell King - ARM Linux wrote:
> > > On Wed, Aug 13, 2014 at 06:57:18AM -0700, Stephen Boyd wrote:
> > > > Commit 1a6b69b6548c (ARM: gic: add CPU migration support,
> > > > 2012-04-12) introduced an acquisition of the irq_controller_lock
> > > > in gic_raise_softirq() which can lead to a spinlock recursion if
> > > > the gic_arch_extn hooks call into the scheduler (via complete()
> > > > or wake_up(), etc.). This happens because gic_arch_extn hooks are
> > > > normally called with the irq_controller_lock held and calling
> > > > into the scheduler may cause us to call smp_send_reschedule()
> > > > which will grab the irq_controller_lock again. Here's an example
> > > > from a vendor kernel (note that the gic_arch_extn hook code here
> > > > isn't actually in mainline):
> > > 
> > > Here's a question: why would you want to call into the scheduler from
> > > the gic_arch_extn code?
> > 
> > In this case we want to send a message to another processor when
> > an interrupt is enabled that's only a wakeup interrupt in certain
> > low power states. It's done sort of indirectly, but basically we
> > block that low power state from being entered so we can ensure
> > that the interrupt wakes us up from a lighter version of suspend.
> 
> No, that's not the correct answer for the question I asked.  I did not
> ask "why would you want to call into the IRQ code from the scheduler".
> I asked "why would you want to call into the scheduler from the
> gic_arch_extn code?"
> 
> That's a completely different question.  Let me rephrase to try and get
> an answer to my question: Why are you calling complete() or wake_up()
> from the gic_arch_extn code?

That's the answer. I guess you think "another processor" means
some other CPU running linux? That isn't the case. We aren't
calling into the IRQ code from the scheduler. The IRQ code is
calling the gic_arch_extn code which is calling into the
scheduler. Let me try to clarify. The path from the stacktrace I
posted is:

 request_irq()
  irq_enable()
   gic_unmask_irq()
    msm_mpm_enable_irq()
     ...
     complete()

In this case a driver is requesting an interrupt that is wakeup
capable even in the lowest power state, so we wakeup a thread
that's sitting around waiting on that completion to notify the
non-linux running remote processor that we can go into the lowest
power state. We can only communicate with the other processor via
sleeping APIs. Another way to do it would be to schedule a work
but we would get into the same situation as this because
scheduling works may call into the scheduler too.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
