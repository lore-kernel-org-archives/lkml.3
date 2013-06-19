Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326Ab3FSJnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:43:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47802 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032Ab3FSJnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:43:16 -0400
X-Spam-Score: -100.8
Message-ID: <51C17D01.2060208@asianux.com>
Date: Wed, 19 Jun 2013 17:42:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of spin_lock
 + local_irq_save, especially when CONFIG_LOCKDEP not defined
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 04:41 PM, Thomas Gleixner wrote:
> On Wed, 19 Jun 2013, Chen Gang wrote:
> 
>> > 
>> > When CONFIG_LOCKDEP is not defined, spin_lock_irqsave() is not equal to
>> > spin_lock() + local_irq_save().
>> > 
>> > In __mod_timer(), After call spin_lock_irqsave() with 'base->lock' in
>> > lock_timer_base(), it may use spin_lock() with the 'new_base->lock'.
>> > 
>> > It may let original call do_raw_spin_lock_flags() with 'base->lock',
>> > but new  call LOCK_CONTENDED() with 'new_base->lock'.
>> > 
>> > In fact, we need both of them call do_raw_spin_lock_flags(), so use
>> > spin_lock_irqsave() instead of spin_lock() + local_irq_save().
> Why do we need to do that? There is no reason to do so and it's
> totally irrelevant whether CONFIG_LOCKDEP is enabled or not.
>

Please see include/linux/spinlock_api_smp.h (or see bottom of this mail)

 
> The code is written intentionally this way.
> 
> What's the difference between:
> 
>        spin_lock_irqsave(&l1, flags);
>        spin_unlock(&l1);
>        spin_lock(l2);
>        spin_unlock_irqrestore(&l2, flags);
> 
> and
> 
>        spin_lock_irqsave(&l1, flags);
>        spin_unlock_irqrestore(&l1);
>        spin_lock_irqsave(l2, flags);
>        spin_unlock_irqrestore(&l2, flags);
> 

Yes


> The difference is that we avoid to touch the interrupt disable in the
> cpu, which might be an expensive operation depending on the cpu model.
> 
> There is no point in reenabling interrupts just to disable them
> again a few instruction cycles later.
> 
> And lockdep is perfectly fine with that code. All lockdep cares about
> is whether the lock context (interrupts disabled) is correct or
> not.

Please reference include/linux/spinlock_api_smp.h and include/linux/spinlock.h

  spin_lock_irqsave() ->
    raw_spin_lock_irqsave() ->
      _raw_spin_lock_irqsave() ->
        __raw_spin_lock_irqsave()

  spin_lock() ->
    raw_spin_lock() ->
      _raw_spin_lock() ->
        __raw_spin_lock()


104 static inline unsigned long __raw_spin_lock_irqsave(raw_spinlock_t *lock)
105 {
106         unsigned long flags;
107 
108         local_irq_save(flags);
109         preempt_disable();
110         spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
111         /*
112          * On lockdep we dont want the hand-coded irq-enable of
113          * do_raw_spin_lock_flags() code, because lockdep assumes
114          * that interrupts are not re-enabled during lock-acquire:
115          */
116 #ifdef CONFIG_LOCKDEP
117         LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
118 #else
119         do_raw_spin_lock_flags(lock, &flags);
120 #endif
121         return flags;
122 }
...

140 static inline void __raw_spin_lock(raw_spinlock_t *lock)
141 {
142         preempt_disable();
143         spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
144         LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
145 }



Thanks.
-- 
Chen Gang

Asianux Corporation
