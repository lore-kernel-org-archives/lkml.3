Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935423Ab3FTIn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:43:26 -0400
Received: from intranet.asianux.com ([58.214.24.6]:20004 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935353Ab3FTInX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:43:23 -0400
X-Spam-Score: -100.8
Message-ID: <51C2C077.2050900@asianux.com>
Date: Thu, 20 Jun 2013 16:42:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of spin_lock
 + local_irq_save, especially when CONFIG_LOCKDEP not defined
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C182EE.5070500@asianux.com> <alpine.DEB.2.02.1306191228030.4013@ionos.tec.linutronix.de> <51C28193.3080106@asianux.com> <alpine.DEB.2.02.1306200903520.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306200903520.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:36 PM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, Chen Gang wrote:
>> > On 06/19/2013 06:49 PM, Thomas Gleixner wrote:
>>> > > We must do this because some architectures implement
>>> > > do_raw_spin_lock_flags() in the following way:
>>> > > 
>>> > > do_raw_spin_lock_flags(l, flags)
>>> > > {
>>> > > 	while (!arch_spin_trylock(l)) {
>>> > > 	      if (!irq_disabled_flags(flags)) {
>>> > > 	      	      arch_irq_restore(flags);
>>> > > 		      cpu_relax();
>>> > > 		      arch_irq_disable();
>>> > > 	      }
>>> > > 	}
>>> > > }
>>> > > 
>> > 
>> > For mn10300 and sparc64 (not space32), it doesn't like your demo above.
> Sigh. You're an sparc64 and mn10300 assembler expert, right?
>  

No, do you mean: "only the related expert can discuss about it" ?


>> > For powerpc and s390, it seems your demo above (although not quite
>> > precious)
> It does not matter at all whether the code is implemented exactly that
> way. What matters is that the semantics are the same.
>  

>> > For x86 and parisc, it like your demo above.
> For parisc, yes.
> 
> For x86, no. 
> 
> static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
>                                                   unsigned long flags)
> {
>         arch_spin_lock(lock);
> }
> 

That is one of x86 implementation, not all (please see xen implementation)


>>> > > And again. Both are semantically the same.
>>> > > 
>> > 
>> > I am not quite sure about mn10300 and sparc64.
>> > 
>> > Could you be sure about it ?
> I am sure, because I can read _and_ understand the asm code.
> 

Are you expert of them ?  ;-)

But whether you stick to or not, I do not care about it.


>> > At least, for mn10300 and sparc64, they have no duty to make sure of
>> > our using ways to be correct.
> You think that architectures can implement these functions as they
> want and see fit? No, they can't otherwise their kernel would not work
> at all. Again the semantics are what we care about, not the
> implementation. And it's totally irrelevant whether its implemented in
> C or in assembler.
> 

Of cause, it is independent with language.

>>> > > spin_lock_irqsave() semantics are:
>>> > > 
>>> > > The function returns with the lock acquired, interrupts and preemption
>>> > > disabled. Both variants do that.
>>> > > 
>>> > > The internal details whether an architecture reenables interrupts
>>> > > while spinning on a contended lock or not are completely irrelevant
>>> > > and do not affect the correctness of the code.
>> > 
>> > For API definition, it has no duty to make it correct if the user call
>> > them with informal ways, especially, the implementation is related with
>> > various architectures.
> Nonsense.
>

The word 'Nonsense' seems not quite polite.  ;-)

At least, when some one see this usage below:

   spin_lock_irqsave(&l1, flags);
   spin_unlock(&l1);
   spin_lock(&l2);
   spin_unlock_irqrestore(&l2, flags);

most of them will be amazing.


Thanks.
-- 
Chen Gang

Asianux Corporation
