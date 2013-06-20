Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3FTHg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:36:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:59202 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3FTHg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:36:28 -0400
Date: Thu, 20 Jun 2013 09:36:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of
 spin_lock + local_irq_save, especially when CONFIG_LOCKDEP not defined
In-Reply-To: <51C28193.3080106@asianux.com>
Message-ID: <alpine.DEB.2.02.1306200903520.4013@ionos.tec.linutronix.de>
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C182EE.5070500@asianux.com>
 <alpine.DEB.2.02.1306191228030.4013@ionos.tec.linutronix.de> <51C28193.3080106@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Chen Gang wrote:
> On 06/19/2013 06:49 PM, Thomas Gleixner wrote:
> > We must do this because some architectures implement
> > do_raw_spin_lock_flags() in the following way:
> > 
> > do_raw_spin_lock_flags(l, flags)
> > {
> > 	while (!arch_spin_trylock(l)) {
> > 	      if (!irq_disabled_flags(flags)) {
> > 	      	      arch_irq_restore(flags);
> > 		      cpu_relax();
> > 		      arch_irq_disable();
> > 	      }
> > 	}
> > }
> > 
> 
> For mn10300 and sparc64 (not space32), it doesn't like your demo above.

Sigh. You're an sparc64 and mn10300 assembler expert, right?
 
> For powerpc and s390, it seems your demo above (although not quite
> precious)

It does not matter at all whether the code is implemented exactly that
way. What matters is that the semantics are the same.
 
> For x86 and parisc, it like your demo above.

For parisc, yes.

For x86, no. 

static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
                                                  unsigned long flags)
{
        arch_spin_lock(lock);
}

> > And again. Both are semantically the same.
> > 
> 
> I am not quite sure about mn10300 and sparc64.
> 
> Could you be sure about it ?

I am sure, because I can read _and_ understand the asm code.

> At least, for mn10300 and sparc64, they have no duty to make sure of
> our using ways to be correct.

You think that architectures can implement these functions as they
want and see fit? No, they can't otherwise their kernel would not work
at all. Again the semantics are what we care about, not the
implementation. And it's totally irrelevant whether its implemented in
C or in assembler.

> > spin_lock_irqsave() semantics are:
> > 
> > The function returns with the lock acquired, interrupts and preemption
> > disabled. Both variants do that.
> > 
> > The internal details whether an architecture reenables interrupts
> > while spinning on a contended lock or not are completely irrelevant
> > and do not affect the correctness of the code.
> 
> For API definition, it has no duty to make it correct if the user call
> them with informal ways, especially, the implementation is related with
> various architectures.

Nonsense.

We define an API and the semantics and every implementation has to
follow these semantics. Period.

If there is an implementation, which does not follow the
specification, then it needs to be fixed. Period.

And this has nothing to do how this is called and whether various
architecture specific implementations exist or not.
 
> At last if it is really correct now, it is still dangerous (the API has
> no duty to let it always correct).

The API CANNOT make sure that the implementations are correct. It's
the duty of the person who implements the API to make sure it is
correct.

And there is nothing dangerous except your ongoing attempts to patch
code which you really do not understand at all.

Thanks,

	tglx
