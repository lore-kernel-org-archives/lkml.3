Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3HUDBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:01:16 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:39928 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3HUDBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:01:15 -0400
Message-ID: <52142D6C.6000400@hp.com>
Date: Tue, 20 Aug 2013 23:01:00 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Alexander Fyodorov <halcy@yandex.ru>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <15321377012704@web8h.yandex.ru>
In-Reply-To: <15321377012704@web8h.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 11:31 AM, Alexander Fyodorov wrote:
> Hi Waiman,
>
> I'm not subscribed to the lkml so I'm writing to you instead. In your patch you put smp_wmb() at the end of spin_unlock():
>
> +static __always_inline void queue_spin_unlock(struct qspinlock *lock)
> +{
> +	/*
> +	 * This unlock function may get inlined into the caller. The
> +	 * compiler barrier is needed to make sure that the lock will
> +	 * not be released before changes to the critical section is done.
> +	 * The ending smp_wmb() allows queue head process to get the lock ASAP.
> +	 */
> +	barrier();
> +#ifndef QSPINLOCK_MANYCPUS
> +	{
> +		u16 qcode = ACCESS_ONCE(lock->locked);
> +		if (unlikely(qcode != QSPINLOCK_LOCKED))
> +			queue_spin_unlock_slowpath(lock, qcode);
> +	}
> +#endif
> +	ACCESS_ONCE(lock->locked) = 0;
> +	smp_wmb();
> +}
>
> Isn't a race possible if another thread acquires the spinlock in the window between setting lock->locked to 0 and issuing smp_wmb()? Writes from the critical section from our thread might be delayed behind the write to lock->locked if the corresponding cache bank is busy.

The purpose of smp_wmb() is to make sure that content in the cache will 
be flushed out to the memory in case the cache coherency protocol cannot 
guarantee a single view of memory content on all processor. In other 
word, smp_wmb() is used to make other processors see that the lock has 
been freed ASAP. If another processor see that before smp_wmb(), it will 
be even better as the latency is reduced. As the lock holder is the only 
one that can release the lock, there is no race condition here.

> And shouldn't it be a full memory barrier (smp_mb()) instead? Because we want loads from critical section to finish too before giving spinlock to another thread (which might change memory contents).

That is a legitimate question. I don't think it is a problem on x86 as 
the x86 spinlock code doesn't do a full mb() in the lock and unlock 
paths. However, other architectures like ARM do requires a full mb() in 
the lock and unlock paths. A full mb() will be costly in x86. A possible 
solution is to make ARCH_QSPINLOCK a tri-state variable whose value can 
be off, on with mb, on without mb. The QSPINLOCK parameter will then 
become a hidden one.

> Comment in queue_spin_unlock() says: "The ending smp_wmb() allows queue head process to get the lock ASAP". But memory barriers can be costly on some architectures so issuing one just to empty write buffers might result in performance loss on them. Such things should be left to hardware IMHO.
>
> So I think unlock() should look like this:
>
> +static __always_inline void queue_spin_unlock(struct qspinlock *lock)
> +{
> +	/*
> +	 * Wait for the critical section to finish memory accesses.
> +	 */
> +	smp_mb();
> +
> +#ifndef QSPINLOCK_MANYCPUS
> +	{
> +		u16 qcode = ACCESS_ONCE(lock->locked);
> +		if (unlikely(qcode != QSPINLOCK_LOCKED))
> +			queue_spin_unlock_slowpath(lock, qcode);
> +	}
> +#endif
> +	ACCESS_ONCE(lock->locked) = 0;
> +}

The smp_mb() will be conditionalized depending on the ARCH_QSPINLOCK 
setting. The smp_wmb() may not be needed, but a compiler barrier should 
still be there.

> Also I don't understand why there are so many uses of ACCESS_ONCE() macro. It does not guarantee memory ordering with regard to other CPUs, so probably most of the uses can be removed (with exception of lock_is_contended(), where it prohibits gcc from optimizing the loop away).

All the lock/unlock code can be inlined and we don't know what the 
compiler will do to optimize code. The ACCESS_ONCE() macro is used to 
make sure that the compiler won't optimize away the actual fetch or 
write of the memory. Even if the compiler won't optimize away the memory 
access, adding the ACCESS_ONCE() macro won't have any extra overhead. So 
a more liberal use of it won't hurt performance.

Regards,
Longman
