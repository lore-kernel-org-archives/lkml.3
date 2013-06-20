Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab3FTEPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:15:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:51293 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3FTEPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:15:03 -0400
X-Spam-Score: -100.8
Message-ID: <51C28193.3080106@asianux.com>
Date: Thu, 20 Jun 2013 12:14:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of spin_lock
 + local_irq_save, especially when CONFIG_LOCKDEP not defined
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C182EE.5070500@asianux.com> <alpine.DEB.2.02.1306191228030.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306191228030.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 06:49 PM, Thomas Gleixner wrote:
>> > But I feel, they are not semantically the same.
> This is not about feelings. This is about facts.
>  

Excuse me, my English is not quite well, the reason why I use 'feel' is
to want to say with more polite.

Maybe it is not the correct word for saying with more polite.


>> > if CONFIG_LOCKDEP is not defined, spin_lock_irqsave() should call
>> > do_raw_spin_lock_flags(), not call LOCK_CONTENDED().
> That is what the code already does:
> 
> #ifdef CONFIG_LOCKDEP
>         LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
> #else
> 	do_raw_spin_lock_flags(lock, &flags);
> #endif
> 
> If LOCKDEP is not defined it calls do_raw_spin_lock_flags(). Where is
> your point?
> 

Yes, it is my point.


> And the reason why the LOCKDEP case and the !LOCKDEP case are
> different is explained in the comment above that code. And both behave
> the same way versus the spinlock semantics.
> 
> We must do this because some architectures implement
> do_raw_spin_lock_flags() in the following way:
> 
> do_raw_spin_lock_flags(l, flags)
> {
> 	while (!arch_spin_trylock(l)) {
> 	      if (!irq_disabled_flags(flags)) {
> 	      	      arch_irq_restore(flags);
> 		      cpu_relax();
> 		      arch_irq_disable();
> 	      }
> 	}
> }
> 

For mn10300 and sparc64 (not space32), it doesn't like your demo above.

For powerpc and s390, it seems your demo above (although not quite
precious)

For x86 and parisc, it like your demo above.

And another will be no different between LOCKDEP and !LOCKDEP


> This is done to limit irq disabled time while we wait for the
> lock. Though most architectures implement it as:
> 
> 	while (!arch_spin_trylock(l))
> 	      cpu_relax();
> 

Yes.


> In the lockdep case we CANNOT reenable interrupts in the spinning code
> and therefor we use the 
> 
> 	while (!arch_spin_trylock(l))
> 	      cpu_relax();
> 
> variant.
> 
> And again. Both are semantically the same.
> 

I am not quite sure about mn10300 and sparc64.

Could you be sure about it ?

At least, for mn10300 and sparc64, they have no duty to make sure of
our using ways to be correct.


> spin_lock_irqsave() semantics are:
> 
> The function returns with the lock acquired, interrupts and preemption
> disabled. Both variants do that.
> 
> The internal details whether an architecture reenables interrupts
> while spinning on a contended lock or not are completely irrelevant
> and do not affect the correctness of the code.

For API definition, it has no duty to make it correct if the user call
them with informal ways, especially, the implementation is related with
various architectures.

At last if it is really correct now, it is still dangerous (the API has
no duty to let it always correct).



Thanks.
-- 
Chen Gang

Asianux Corporation
