Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653Ab3FSKtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:49:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:54058 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830Ab3FSKtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:49:10 -0400
Date: Wed, 19 Jun 2013 12:49:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of
 spin_lock + local_irq_save, especially when CONFIG_LOCKDEP not defined
In-Reply-To: <51C182EE.5070500@asianux.com>
Message-ID: <alpine.DEB.2.02.1306191228030.4013@ionos.tec.linutronix.de>
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C182EE.5070500@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Chen Gang wrote:
> On 06/19/2013 05:59 PM, Thomas Gleixner wrote:
> > Lockdep tracks lock ordering and the context in which a lock is
> > taken. The timer base lock can be taken in interrupt context, so it
> > always needs to be taken with interrupts disabled. That's what lockdep
> > cares about.
> > 
> > And 
> > 	spin_lock_irqsave(&l1, flags);
> > 	spin_unlock(&l1);
> > 	spin_lock(&l2);
> > 	spin_unlock_irqrestore(&l2, flags);
> > 
> > fulfils that for both l1 and l2.
> > 
> > It does not matter whether the code pathes are different, what matters
> > is that they are semantically the same. And that's the case.
> 
> But I feel, they are not semantically the same.

This is not about feelings. This is about facts.
 
> if CONFIG_LOCKDEP is not defined, spin_lock_irqsave() should call
> do_raw_spin_lock_flags(), not call LOCK_CONTENDED().

That is what the code already does:

#ifdef CONFIG_LOCKDEP
        LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
#else
	do_raw_spin_lock_flags(lock, &flags);
#endif

If LOCKDEP is not defined it calls do_raw_spin_lock_flags(). Where is
your point?

And the reason why the LOCKDEP case and the !LOCKDEP case are
different is explained in the comment above that code. And both behave
the same way versus the spinlock semantics.

We must do this because some architectures implement
do_raw_spin_lock_flags() in the following way:

do_raw_spin_lock_flags(l, flags)
{
	while (!arch_spin_trylock(l)) {
	      if (!irq_disabled_flags(flags)) {
	      	      arch_irq_restore(flags);
		      cpu_relax();
		      arch_irq_disable();
	      }
	}
}

This is done to limit irq disabled time while we wait for the
lock. Though most architectures implement it as:

	while (!arch_spin_trylock(l))
	      cpu_relax();

In the lockdep case we CANNOT reenable interrupts in the spinning code
and therefor we use the 

	while (!arch_spin_trylock(l))
	      cpu_relax();

variant.

And again. Both are semantically the same.

spin_lock_irqsave() semantics are:

The function returns with the lock acquired, interrupts and preemption
disabled. Both variants do that.

The internal details whether an architecture reenables interrupts
while spinning on a contended lock or not are completely irrelevant
and do not affect the correctness of the code.

Thanks,

	tglx
