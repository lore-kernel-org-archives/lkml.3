Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3LRSpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:45:16 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11525 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3LRSpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:45:14 -0500
Message-ID: <52B1ED2D.3020000@hp.com>
Date: Wed, 18 Dec 2013 13:45:01 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, "" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] qrwlock: A queue read/write lock implementation
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com> <1385147087-26588-2-git-send-email-Waiman.Long@hp.com> <20131217192128.GA15969@linux.vnet.ibm.com>
In-Reply-To: <20131217192128.GA15969@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 02:21 PM, Paul E. McKenney wrote:
> +/**
> + * queue_read_trylock - try to acquire read lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + * Return: 1 if lock acquired, 0 if failed
> + */
> +static inline int queue_read_trylock(struct qrwlock *lock)
> +{
> +	union qrwcnts cnts;
> +
> +	cnts.rw = ACCESS_ONCE(lock->cnts.rw);
> +	if (likely(!cnts.writer)) {
> +		cnts.rw = xadd(&lock->cnts.rw, _QR_BIAS);
> Looks like xadd() is x86-specific, but this is common code.  One
> approach would be to do xadd() for other arches, another approach
> would be to make .rw be an atomic_t rather than a u32.  Making it
> be atomic_t is probably easiest.  (The cmpxchg()s would then need
> to be atomic_cmpxchg().)
>
> Ditto for add_smp() further down.

You are right that xadd() and add_smp() are x86 specific. I will change 
the code to use atomic_t for rw as suggested.

> +
> +/**
> + * queue_write_unlock - release write lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + */
> +static inline void queue_write_unlock(struct qrwlock *lock)
> +{
> +	/*
> +	 * Make sure that none of the critical section will be leaked out.
> +	 */
> +	smp_mb__before_clear_bit();
> +	ACCESS_ONCE(lock->cnts.writer) = 0;
> +	smp_mb__after_clear_bit();
> Interesting combination...  It does seem to work out, though.

They are used for the time being. They will be changed to better 
alternatives like smp_store_release() once they are available.

>> +++ b/kernel/locking/qrwlock.c
>> @@ -0,0 +1,265 @@
>> +/*
>> + * Queue read/write lock
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
>> + *
>> + * Authors: Waiman Long<waiman.long@hp.com>
>> + */
>> +#include<linux/smp.h>
>> +#include<linux/bug.h>
>> +#include<linux/cpumask.h>
>> +#include<linux/percpu.h>
>> +#include<linux/hardirq.h>
>> +#include<asm-generic/qrwlock.h>
>> +
>> +/*
>> + * Compared with regular rwlock, the queue rwlock has has the following
>> + * advantages:
>> + * 1. Even though there is a slight chance of stealing the lock if come at
>> + *    the right moment, the granting of the lock is mostly in FIFO order.
>> + * 2. It is usually faster in high contention situation.
>> + *
>> + * The only downside is that the lock is 4 bytes larger in 32-bit systems
>> + * and 12 bytes larger in 64-bit systems.
>> + *
>> + * There are two queues for writers. The writer field of the lock is a
>> + * one-slot wait queue. The writers that follow will have to wait in the
>> + * combined reader/writer queue (waitq).
>> + *
>> + * Compared with x86 ticket spinlock, the queue rwlock is faster in high
>> + * contention situation. The writer lock is also faster in single thread
>> + * operations. Therefore, queue rwlock can be considered as a replacement
>> + * for those spinlocks that are highly contended as long as an increase
>> + * in lock size is not an issue.
> Judging from the #defines at the end of qrwlock.h, this replacement is
> done on a file-by-file basis?  Looks to me more like the replacement
> must be all-or-nothing across the entire kernel, otherwise trouble would
> ensue for locks used across multiple files.  What am I missing here?

Yes, it is either all or nothing. Activating queue rwlock will replace 
the existing implementation.

>> + */
>> +
>> +#ifndef arch_mutex_cpu_relax
>> +# define arch_mutex_cpu_relax() cpu_relax()
>> +#endif
>> +
>> +#ifndef smp_mb__load_acquire
>> +# ifdef CONFIG_X86
>> +#   define smp_mb__load_acquire()	barrier()
>> +# else
>> +#   define smp_mb__load_acquire()	smp_mb()
>> +# endif
>> +#endif
>> +
>> +#ifndef smp_mb__store_release
>> +# ifdef CONFIG_X86
>> +#   define smp_mb__store_release()	barrier()
>> +# else
>> +#   define smp_mb__store_release()	smp_mb()
>> +# endif
>> +#endif
> These are now smp_load_acquire() and smp_store_release().

Will change that in the next version.

>> +
>> +/**
>> + * wait_in_queue - Add to queue and wait until it is at the head
>> + * @lock: Pointer to queue rwlock structure
>> + * @node: Node pointer to be added to the queue
>> + */
>> +static __always_inline void
>> +wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
>> +{
>> +	struct qrwnode *prev;
>> +
>> +	node->next = NULL;
>> +	node->wait = true;
>> +	prev = xchg(&lock->waitq, node);
>> +	if (prev) {
>> +		prev->next = node;
>> +		/*
>> +		 * Wait until the waiting flag is off
>> +		 */
>> +		while (ACCESS_ONCE(node->wait))
>> +			arch_mutex_cpu_relax();
>> +		smp_mb__load_acquire();
> 		while (smp_load_acquire(&node->wait))
> 			arch_mutex_cpu_relax();
>
> On TSO systems like x86, this should generate the same code.

OK, I can change that too.

>> +	}
>> +}
>> +
>> +/**
>> + * signal_next - Signal the next one in queue to be at the head
>> + * @lock: Pointer to queue rwlock structure
>> + * @node: Node pointer to the current head of queue
>> + */
>> +static __always_inline void
>> +signal_next(struct qrwlock *lock, struct qrwnode *node)
>> +{
>> +	struct qrwnode *next;
>> +
>> +	/*
>> +	 * Try to notify the next node first without disturbing the cacheline
>> +	 * of the lock. If that fails, check to see if it is the last node
>> +	 * and so should clear the wait queue.
>> +	 */
>> +	next = ACCESS_ONCE(node->next);
>> +	if (likely(next))
>> +		goto notify_next;
>> +
>> +	/*
>> +	 * Clear the wait queue if it is the last node
>> +	 */
>> +	if ((ACCESS_ONCE(lock->waitq) == node)&&
>> +	    (cmpxchg(&lock->waitq, node, NULL) == node))
>> +			return;
>> +	/*
>> +	 * Wait until the next one in queue set up the next field
>> +	 */
>> +	while (likely(!(next = ACCESS_ONCE(node->next))))
>> +		arch_mutex_cpu_relax();
>> +	/*
>> +	 * The next one in queue is now at the head
>> +	 */
>> +notify_next:
>> +	smp_mb__store_release();
>> +	ACCESS_ONCE(next->wait) = false;
> The above pair of lines can be simply:
>
> 	smp_store_release(&next->wait, false);
>
> This pairs nicely with the smp_load_acquire() in wait_in_queue().

Will do.

>> +}
>> +
>> +/**
>> + * rspin_until_writer_unlock - inc reader count&  spin until writer is gone
>> + * @lock: Pointer to queue rwlock structure
>> + * @cnts: Current queue rwlock counts structure
>> + *
>> + * In interrupt context or at the head of the queue, the reader will just
>> + * increment the reader count&  wait until the writer releases the lock.
>> + */
>> +static __always_inline void
>> +rspin_until_writer_unlock(struct qrwlock *lock, union qrwcnts cnts)
>> +{
>> +	while (cnts.writer == _QW_LOCKED) {
>> +		arch_mutex_cpu_relax();
>> +		cnts.rw = ACCESS_ONCE(lock->cnts.rw);
>> +	}
>> +}
>> +
>> +/**
>> + * queue_read_lock_slowpath - acquire read lock of a queue rwlock
>> + * @lock: Pointer to queue rwlock structure
>> + */
>> +void queue_read_lock_slowpath(struct qrwlock *lock)
>> +{
>> +	struct qrwnode node;
>> +	union qrwcnts cnts;
>> +
>> +	/*
>> +	 * Readers come here when it cannot get the lock without waiting
> Grammar nit: s/it/they/
> Or s/Readers come/Each reader comes/

Will fix that.

>> +	 */
>> +	if (unlikely(irq_count())) {
>> +		/*
>> +		 * Readers in interrupt context will spin until the lock is
>> +		 * available without waiting in the queue.
>> +		 */
>> +		cnts.rw = ACCESS_ONCE(lock->cnts.rw);
> This needs to be:
>
> 		cnts.rw = smp_load_acquire(&lock->cnts.rw);
>
> I was going to argue that the above assignment should be pushed into
> rspin_until_writer_unlock(), but I see that this won't work for the
> call later in this function.  ;-)
>

Will made the change.

>> +		rspin_until_writer_unlock(lock, cnts);
> We do need a memory barrier in this path, otherwise we are not guaranteed
> to see the writer's critical section.  One approach would be to make
> rspin_until_writer_unlock()s "while" loop body do:
>
> 		arch_mutex_cpu_relax();
> 		cnts.rw = smp_load_acquire(&lock->cnts.rw);

Yes, Will do.

>> +		return;
>> +	}
>> +	add_smp(&lock->cnts.rw, -_QR_BIAS);
>> +
>> +	/*
>> +	 * Put the reader into the wait queue
>> +	 */
>> +	wait_in_queue(lock,&node);
>> +
>> +	/*
>> +	 * At the head of the wait queue now, wait until the writer state
>> +	 * goes to 0 and then try to increment the reader count and get
>> +	 * the lock.
>> +	 */
>> +	while (ACCESS_ONCE(lock->cnts.writer))
>> +		arch_mutex_cpu_relax();
>> +	cnts.rw = xadd(&lock->cnts.rw, _QR_BIAS);
>> +	rspin_until_writer_unlock(lock, cnts);
>> +	/*
>> +	 * Need to have a barrier with read-acquire semantics
>> +	 */
>> +	smp_mb__load_acquire();
> Making rspin_until_writer_unlock() do an smp_load_acquire() makes this
> unnecessary.

Yes.

>> +	signal_next(lock,&node);
> Good, this allows multiple readers to acquire the lock concurrently,
> give or take memory latency compared to critical-section duration.
> When the first writer shows up, it presumably spins on the lock word.
>

Yes, that was the intention. The first writer that shows up will block 
succeeding readers from getting the lock.

BTW, what was the status of the TSO memory barrier patch? This patch has 
some partial dependency it.

-Longman
