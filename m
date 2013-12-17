Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3LQTVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:21:39 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36823 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3LQTVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:21:35 -0500
Date: Tue, 17 Dec 2013 11:21:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] qrwlock: A queue read/write lock implementation
Message-ID: <20131217192128.GA15969@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
 <1385147087-26588-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385147087-26588-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121719-7164-0000-0000-00000456FE54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:04:44PM -0500, Waiman Long wrote:
> This patch introduces a new read/write lock implementation that put
> waiting readers and writers into a queue instead of actively contending
> the lock like the current read/write lock implementation. This will
> improve performance in highly contended situation by reducing the
> cache line bouncing effect.

Much improved, but still some issues called out inline.

							Thanx, Paul

> The queue read/write lock (qrwlock) is a fair lock even though there
> is still a slight chance of lock stealing if a reader or writer comes
> at the right moment.  Other than that, lock granting is done in a
> FIFO manner.  As a result, it is possible to determine a maximum time
> period after which the waiting is over and the lock can be acquired.
> 
> Internally, however, there is a second type of readers which try to
> steal lock aggressively. They simply increments the reader count and
> wait until the writer releases the lock. The transition to aggressive
> reader happens in the read lock slowpath when
> 
>  1. In an interrupt context.
>  2. When a reader comes to the head of the wait queue and sees
>     the release of a write lock.
> 
> The queue read lock is safe to use in an interrupt context (softirq
> or hardirq) as it will switch to become an aggressive reader in such
> environment allowing recursive read lock.
> 
> The only downside of queue rwlock is the size increase in the lock
> structure by 4 bytes for 32-bit systems and by 12 bytes for 64-bit
> systems.
> 
> In term of single-thread performance (no contention), a 256K
> lock/unlock loop was run on a 2.4GHz and 2.93Ghz Westmere x86-64
> CPUs. The following table shows the average time (in ns) for a single
> lock/unlock sequence (including the looping and timing overhead):
> 
> Lock Type		    2.4GHz	2.93GHz
> ---------		    ------	-------
> Ticket spinlock		     14.9	 12.3
> Read lock		     17.0	 13.5
> Write lock		     17.0	 13.5
> Queue read lock	     	     16.0	 13.4
> Queue write lock	      9.2	  7.8
> 
> The queue read lock is slightly slower than the spinlock, but is
> slightly faster than the read lock. The queue write lock, however,
> is the fastest of all. It is almost twice as fast as the write lock
> and about 1.5X of the spinlock.
> 
> With lock contention, the speed of each individual lock/unlock function
> is less important than the amount of contention-induced delays.
> 
> To investigate the performance characteristics of the queue rwlock
> compared with the regular rwlock, Ingo's anon_vmas patch that converts
> rwsem to rwlock was applied to a 3.12 kernel. This kernel was then
> tested under the following 3 conditions:
> 
>  1) Plain 3.12
>  2) Ingo's patch
>  3) Ingo's patch + qrwlock
> 
> Each of the 3 kernels were booted up twice with and without the
> "idle=poll" kernel parameter which keeps the CPUs in C0 state while
> idling instead of a more energy-saving sleep state.  The jobs per
> minutes (JPM) results of the AIM7's high_systime workload at 1500
> users on a 8-socket 80-core DL980 (HT off) were:
> 
>  Kernel	    JPMs	%Change from (1)
>  ------	    ----	----------------
>    1	145704/227295		-
>    2	229750/236066	    +58%/+3.8%
>    4	240062/248606	    +65%/+9.4%
> 
> The first JPM number is without the "idle=poll" kernel parameter,
> the second number is with that parameter. It can be seen that most
> of the performance benefit of converting rwsem to rwlock actually
> come from the latency improvement of not needing to wake up a CPU
> from deep sleep state when work is available.
> 
> The use of non-sleeping locks did improve performance by eliminating
> the context switching cost. Using queue rwlock gave almost tripling
> of performance gain. The performance gain was reduced somewhat with
> a fair lock which was to be expected.
> 
> Looking at the perf profiles (with idle=poll) below, we can clearly see
> that other bottlenecks were constraining the performance improvement.
> 
> Perf profile of kernel (2):
> 
>  18.65%    reaim  [kernel.kallsyms]  [k] __write_lock_failed
>   9.00%    reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>   5.21%  swapper  [kernel.kallsyms]  [k] cpu_idle_loop
>   3.08%    reaim  [kernel.kallsyms]  [k] mspin_lock
>   2.50%    reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
>   2.00%       ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>   1.29%    reaim  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
>   1.21%    reaim  [kernel.kallsyms]  [k] __read_lock_failed
>   1.12%    reaim  [kernel.kallsyms]  [k] _raw_spin_lock
>   1.10%    reaim  [kernel.kallsyms]  [k] perf_event_aux
>   1.09%     true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
> 
> Perf profile of kernel (3):
> 
>  20.14%  swapper  [kernel.kallsyms]  [k] cpu_idle_loop
>   7.94%    reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>   5.41%    reaim  [kernel.kallsyms]  [k] queue_write_lock_slowpath
>   5.01%    reaim  [kernel.kallsyms]  [k] mspin_lock
>   2.12%    reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
>   2.07%       ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>   1.58%    reaim  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
>   1.25%    reaim  [kernel.kallsyms]  [k] queue_write_3step_lock
>   1.18%    reaim  [kernel.kallsyms]  [k] queue_read_lock_slowpath
>   1.14%     true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>   0.95%    reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
> 
> The spinlock bottlenecks were shown below.
> 
>   7.94%    reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>               |--59.72%-- release_pages
>               |--37.41%-- pagevec_lru_move_fn
>               |--0.82%-- get_page_from_freelist
>               |--0.73%-- __page_cache_release
>                --1.32%-- [...]
> 
> For both release_pages() & pagevec_lru_move_fn() function, the
> spinlock contention was on zone->lru_lock. With the queue spinlock
> patch, however, the contention went away with a lot more idle time
> available and the JPM number went up to 265532 which was an additional
> performance improvement.
> 
>  28.40%  swapper  [kernel.kallsyms]  [k] cpu_idle_loop
>   6.89%    reaim  [kernel.kallsyms]  [k] mspin_lock
>   4.17%    reaim  [kernel.kallsyms]  [k] queue_write_lock_slowpath
>   2.10%    reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
>   1.82%    reaim  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
>   1.34%    reaim  [kernel.kallsyms]  [k] entity_tick
>   1.17%    reaim  [kernel.kallsyms]  [k] queue_write_3step_lock
>   1.06%    reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
>   0.86%    reaim  [kernel.kallsyms]  [k] perf_event_aux
>   0.83%       ls  [kernel.kallsyms]  [k] mspin_lock
>    :
>   0.53%    reaim  [kernel.kallsyms]  [k] _raw_spin_lock
>   0.14%    reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
> 
> Tim Chen also tested the qrwlock with Ingo's patch on a 4-socket
> machine.  It was found the performance improvement of 11% was the
> same with regular rwlock or queue rwlock.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  include/asm-generic/qrwlock.h |  205 +++++++++++++++++++++++++++++++
>  kernel/Kconfig.locks          |    7 +
>  kernel/locking/Makefile       |    1 +
>  kernel/locking/qrwlock.c      |  265 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 478 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-generic/qrwlock.h
>  create mode 100644 kernel/locking/qrwlock.c
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> new file mode 100644
> index 0000000..9d085cb
> --- /dev/null
> +++ b/include/asm-generic/qrwlock.h
> @@ -0,0 +1,205 @@
> +/*
> + * Queue read/write lock
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
> + *
> + * Authors: Waiman Long <waiman.long@hp.com>
> + */
> +#ifndef __ASM_GENERIC_QRWLOCK_H
> +#define __ASM_GENERIC_QRWLOCK_H
> +
> +#include <linux/types.h>
> +#include <asm/bitops.h>
> +#include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> +#include <asm/processor.h>
> +#include <asm/byteorder.h>
> +
> +#if !defined(__LITTLE_ENDIAN) && !defined(__BIG_ENDIAN)
> +#error "Missing either LITTLE_ENDIAN or BIG_ENDIAN definition."
> +#endif
> +
> +/*
> + * The queue read/write lock data structure
> + *
> + * The layout of the structure is endian-sensitive to make sure that adding
> + * _QR_BIAS to the rw field to increment the reader count won't disturb
> + * the writer field. The least significant 8 bits is the writer field
> + * whereas the remaining 24 bits is the reader count.
> + */
> +struct qrwnode {
> +	struct qrwnode *next;
> +	bool		wait;	/* Waiting flag */
> +};
> +
> +typedef struct qrwlock {
> +	union qrwcnts {
> +		struct {
> +#ifdef __LITTLE_ENDIAN
> +			u8  writer;	/* Writer state		*/
> +#else
> +			u16 r16;	/* Reader count - msb	*/
> +			u8  r8;		/* Reader count - lsb	*/
> +			u8  writer;	/* Writer state		*/
> +#endif
> +		};
> +		u32	rw;		/* Reader/writer number pair */
> +	} cnts;
> +	struct qrwnode *waitq;		/* Tail of waiting queue */
> +} arch_rwlock_t;
> +
> +/*
> + * Writer states & reader shift and bias
> + */
> +#define	_QW_WAITING	1		/* A writer is waiting	   */
> +#define	_QW_LOCKED	0xff		/* A writer holds the lock */
> +#define	_QR_SHIFT	8		/* Reader count shift	   */
> +#define _QR_BIAS	(1U << _QR_SHIFT)
> +
> +/*
> + * External function declarations
> + */
> +extern void queue_read_lock_slowpath(struct qrwlock *lock);
> +extern void queue_write_lock_slowpath(struct qrwlock *lock);
> +
> +/**
> + * queue_read_can_lock- would read_trylock() succeed?
> + * @lock: Pointer to queue rwlock structure
> + */
> +static inline int queue_read_can_lock(struct qrwlock *lock)
> +{
> +	return !ACCESS_ONCE(lock->cnts.writer);
> +}
> +
> +/**
> + * queue_write_can_lock- would write_trylock() succeed?
> + * @lock: Pointer to queue rwlock structure
> + */
> +static inline int queue_write_can_lock(struct qrwlock *lock)
> +{
> +	return !ACCESS_ONCE(lock->cnts.rw);
> +}
> +
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

Looks like xadd() is x86-specific, but this is common code.  One
approach would be to do xadd() for other arches, another approach
would be to make .rw be an atomic_t rather than a u32.  Making it
be atomic_t is probably easiest.  (The cmpxchg()s would then need
to be atomic_cmpxchg().)

Ditto for add_smp() further down.

> +		if (likely(!cnts.writer))
> +			return 1;
> +		add_smp(&lock->cnts.rw, -_QR_BIAS);
> +	}
> +	return 0;
> +}
> +
> +/**
> + * queue_write_trylock - try to acquire write lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + * Return: 1 if lock acquired, 0 if failed
> + */
> +static inline int queue_write_trylock(struct qrwlock *lock)
> +{
> +	union qrwcnts old, new;
> +
> +	old.rw = ACCESS_ONCE(lock->cnts.rw);
> +	if (likely(!old.rw)) {
> +		new.rw = old.rw;
> +		new.writer = _QW_LOCKED;
> +		if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
> +			return 1;
> +	}
> +	return 0;
> +}
> +/**
> + * queue_read_lock - acquire read lock of a queue rwlock
> + * @lock: Pointer to queue rwlock structure
> + */
> +static inline void queue_read_lock(struct qrwlock *lock)
> +{
> +	union qrwcnts cnts;
> +
> +	cnts.rw = xadd(&lock->cnts.rw, _QR_BIAS);
> +	if (likely(!cnts.writer))
> +		return;
> +	/*
> +	 * Slowpath will decrement the reader count, if necessary
> +	 */
> +	queue_read_lock_slowpath(lock);
> +}
> +
> +/**
> + * queue_write_lock - acquire write lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + */
> +static inline void queue_write_lock(struct qrwlock *lock)
> +{
> +	/*
> +	 * Optimize for the unfair lock case where the fair flag is 0.
> +	 */
> +	if (cmpxchg(&lock->cnts.rw, 0, _QW_LOCKED) == 0)
> +		return;
> +	queue_write_lock_slowpath(lock);
> +}
> +
> +/**
> + * queue_read_unlock - release read lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + */
> +static inline void queue_read_unlock(struct qrwlock *lock)
> +{
> +	/*
> +	 * Atomically decrement the reader count
> +	 */
> +	add_smp(&lock->cnts.rw, -_QR_BIAS);
> +}
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

Interesting combination...  It does seem to work out, though.

> +}
> +
> +/*
> + * Initializier
> + */
> +#define	__ARCH_RW_LOCK_UNLOCKED	{ .cnts = { .rw = 0 }, .waitq = NULL }
> +
> +/*
> + * Remapping rwlock architecture specific functions to the corresponding
> + * queue rwlock functions.
> + */
> +#define arch_read_can_lock(l)	queue_read_can_lock(l)
> +#define arch_write_can_lock(l)	queue_write_can_lock(l)
> +#define arch_read_lock(l)	queue_read_lock(l)
> +#define arch_write_lock(l)	queue_write_lock(l)
> +#define arch_read_trylock(l)	queue_read_trylock(l)
> +#define arch_write_trylock(l)	queue_write_trylock(l)
> +#define arch_read_unlock(l)	queue_read_unlock(l)
> +#define arch_write_unlock(l)	queue_write_unlock(l)
> +
> +#endif /* __ASM_GENERIC_QRWLOCK_H */
> diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
> index d2b32ac..b665478 100644
> --- a/kernel/Kconfig.locks
> +++ b/kernel/Kconfig.locks
> @@ -223,3 +223,10 @@ endif
>  config MUTEX_SPIN_ON_OWNER
>  	def_bool y
>  	depends on SMP && !DEBUG_MUTEXES
> +
> +config ARCH_QUEUE_RWLOCK
> +	bool
> +
> +config QUEUE_RWLOCK
> +	def_bool y if ARCH_QUEUE_RWLOCK
> +	depends on SMP
> diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
> index baab8e5..3e7bab1 100644
> --- a/kernel/locking/Makefile
> +++ b/kernel/locking/Makefile
> @@ -23,3 +23,4 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
>  obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
>  obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
>  obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
> +obj-$(CONFIG_QUEUE_RWLOCK) += qrwlock.o
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> new file mode 100644
> index 0000000..ea5553d
> --- /dev/null
> +++ b/kernel/locking/qrwlock.c
> @@ -0,0 +1,265 @@
> +/*
> + * Queue read/write lock
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
> + *
> + * Authors: Waiman Long <waiman.long@hp.com>
> + */
> +#include <linux/smp.h>
> +#include <linux/bug.h>
> +#include <linux/cpumask.h>
> +#include <linux/percpu.h>
> +#include <linux/hardirq.h>
> +#include <asm-generic/qrwlock.h>
> +
> +/*
> + * Compared with regular rwlock, the queue rwlock has has the following
> + * advantages:
> + * 1. Even though there is a slight chance of stealing the lock if come at
> + *    the right moment, the granting of the lock is mostly in FIFO order.
> + * 2. It is usually faster in high contention situation.
> + *
> + * The only downside is that the lock is 4 bytes larger in 32-bit systems
> + * and 12 bytes larger in 64-bit systems.
> + *
> + * There are two queues for writers. The writer field of the lock is a
> + * one-slot wait queue. The writers that follow will have to wait in the
> + * combined reader/writer queue (waitq).
> + *
> + * Compared with x86 ticket spinlock, the queue rwlock is faster in high
> + * contention situation. The writer lock is also faster in single thread
> + * operations. Therefore, queue rwlock can be considered as a replacement
> + * for those spinlocks that are highly contended as long as an increase
> + * in lock size is not an issue.

Judging from the #defines at the end of qrwlock.h, this replacement is
done on a file-by-file basis?  Looks to me more like the replacement
must be all-or-nothing across the entire kernel, otherwise trouble would
ensue for locks used across multiple files.  What am I missing here?

> + */
> +
> +#ifndef arch_mutex_cpu_relax
> +# define arch_mutex_cpu_relax() cpu_relax()
> +#endif
> +
> +#ifndef smp_mb__load_acquire
> +# ifdef CONFIG_X86
> +#   define smp_mb__load_acquire()	barrier()
> +# else
> +#   define smp_mb__load_acquire()	smp_mb()
> +# endif
> +#endif
> +
> +#ifndef smp_mb__store_release
> +# ifdef CONFIG_X86
> +#   define smp_mb__store_release()	barrier()
> +# else
> +#   define smp_mb__store_release()	smp_mb()
> +# endif
> +#endif

These are now smp_load_acquire() and smp_store_release().

> +
> +/**
> + * wait_in_queue - Add to queue and wait until it is at the head
> + * @lock: Pointer to queue rwlock structure
> + * @node: Node pointer to be added to the queue
> + */
> +static __always_inline void
> +wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
> +{
> +	struct qrwnode *prev;
> +
> +	node->next = NULL;
> +	node->wait = true;
> +	prev = xchg(&lock->waitq, node);
> +	if (prev) {
> +		prev->next = node;
> +		/*
> +		 * Wait until the waiting flag is off
> +		 */
> +		while (ACCESS_ONCE(node->wait))
> +			arch_mutex_cpu_relax();
> +		smp_mb__load_acquire();

		while (smp_load_acquire(&node->wait))
			arch_mutex_cpu_relax();

On TSO systems like x86, this should generate the same code.

> +	}
> +}
> +
> +/**
> + * signal_next - Signal the next one in queue to be at the head
> + * @lock: Pointer to queue rwlock structure
> + * @node: Node pointer to the current head of queue
> + */
> +static __always_inline void
> +signal_next(struct qrwlock *lock, struct qrwnode *node)
> +{
> +	struct qrwnode *next;
> +
> +	/*
> +	 * Try to notify the next node first without disturbing the cacheline
> +	 * of the lock. If that fails, check to see if it is the last node
> +	 * and so should clear the wait queue.
> +	 */
> +	next = ACCESS_ONCE(node->next);
> +	if (likely(next))
> +		goto notify_next;
> +
> +	/*
> +	 * Clear the wait queue if it is the last node
> +	 */
> +	if ((ACCESS_ONCE(lock->waitq) == node) &&
> +	    (cmpxchg(&lock->waitq, node, NULL) == node))
> +			return;
> +	/*
> +	 * Wait until the next one in queue set up the next field
> +	 */
> +	while (likely(!(next = ACCESS_ONCE(node->next))))
> +		arch_mutex_cpu_relax();
> +	/*
> +	 * The next one in queue is now at the head
> +	 */
> +notify_next:
> +	smp_mb__store_release();
> +	ACCESS_ONCE(next->wait) = false;

The above pair of lines can be simply:

	smp_store_release(&next->wait, false);

This pairs nicely with the smp_load_acquire() in wait_in_queue().

> +}
> +
> +/**
> + * rspin_until_writer_unlock - inc reader count & spin until writer is gone
> + * @lock: Pointer to queue rwlock structure
> + * @cnts: Current queue rwlock counts structure
> + *
> + * In interrupt context or at the head of the queue, the reader will just
> + * increment the reader count & wait until the writer releases the lock.
> + */
> +static __always_inline void
> +rspin_until_writer_unlock(struct qrwlock *lock, union qrwcnts cnts)
> +{
> +	while (cnts.writer == _QW_LOCKED) {
> +		arch_mutex_cpu_relax();
> +		cnts.rw = ACCESS_ONCE(lock->cnts.rw);
> +	}
> +}
> +
> +/**
> + * queue_read_lock_slowpath - acquire read lock of a queue rwlock
> + * @lock: Pointer to queue rwlock structure
> + */
> +void queue_read_lock_slowpath(struct qrwlock *lock)
> +{
> +	struct qrwnode node;
> +	union qrwcnts cnts;
> +
> +	/*
> +	 * Readers come here when it cannot get the lock without waiting

Grammar nit: s/it/they/
Or s/Readers come/Each reader comes/

> +	 */
> +	if (unlikely(irq_count())) {
> +		/*
> +		 * Readers in interrupt context will spin until the lock is
> +		 * available without waiting in the queue.
> +		 */
> +		cnts.rw = ACCESS_ONCE(lock->cnts.rw);

This needs to be:

		cnts.rw = smp_load_acquire(&lock->cnts.rw);

I was going to argue that the above assignment should be pushed into
rspin_until_writer_unlock(), but I see that this won't work for the
call later in this function.  ;-)

> +		rspin_until_writer_unlock(lock, cnts);

We do need a memory barrier in this path, otherwise we are not guaranteed
to see the writer's critical section.  One approach would be to make
rspin_until_writer_unlock()s "while" loop body do:

		arch_mutex_cpu_relax();
		cnts.rw = smp_load_acquire(&lock->cnts.rw);

> +		return;
> +	}
> +	add_smp(&lock->cnts.rw, -_QR_BIAS);
> +
> +	/*
> +	 * Put the reader into the wait queue
> +	 */
> +	wait_in_queue(lock, &node);
> +
> +	/*
> +	 * At the head of the wait queue now, wait until the writer state
> +	 * goes to 0 and then try to increment the reader count and get
> +	 * the lock.
> +	 */
> +	while (ACCESS_ONCE(lock->cnts.writer))
> +		arch_mutex_cpu_relax();
> +	cnts.rw = xadd(&lock->cnts.rw, _QR_BIAS);
> +	rspin_until_writer_unlock(lock, cnts);
> +	/*
> +	 * Need to have a barrier with read-acquire semantics
> +	 */
> +	smp_mb__load_acquire();

Making rspin_until_writer_unlock() do an smp_load_acquire() makes this
unnecessary.

> +	signal_next(lock, &node);

Good, this allows multiple readers to acquire the lock concurrently,
give or take memory latency compared to critical-section duration.
When the first writer shows up, it presumably spins on the lock word.

> +}
> +EXPORT_SYMBOL(queue_read_lock_slowpath);
> +
> +/**
> + * qwrite_trylock - Try to acquire the write lock
> + * @lock : Pointer to queue rwlock structure
> + * @old  : The current queue rwlock count structure
> + * Return: 1 if lock acquired, 0 otherwise
> + */
> +static __always_inline int
> +qwrite_trylock(struct qrwlock *lock, union qrwcnts old)
> +{
> +	register union qrwcnts new;
> +
> +	new.rw     = old.rw;
> +	new.writer = _QW_LOCKED;
> +	if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
> +		return 1;
> +	return 0;
> +}
> +
> +/**
> + * queue_write_3step_lock - acquire write lock in 3 steps
> + * @lock : Pointer to queue rwlock structure
> + * Return: 1 if lock acquired, 0 otherwise
> + *
> + * Step 1 - Try to acquire the lock directly if no reader is present
> + * Step 2 - Set the waiting flag to notify readers that a writer is waiting
> + * Step 3 - When the readers field goes to 0, set the locked flag
> + *
> + * In x86, the use of noinline generates a slight better optimized code
> + * with less memory access.
> + */
> +static noinline int queue_write_3step_lock(struct qrwlock *lock)
> +{
> +	register union qrwcnts old;
> +
> +	old.rw = ACCESS_ONCE(lock->cnts.rw);
> +
> +	/* Step 1 */
> +	if (!old.rw && qwrite_trylock(lock, old))
> +		return 1;
> +
> +	/* Step 2 */
> +	if (old.writer || (cmpxchg(&lock->cnts.writer, 0, _QW_WAITING) != 0))
> +		return 0;
> +
> +	/* Step 3 */
> +	arch_mutex_cpu_relax();
> +	old.rw = ACCESS_ONCE(lock->cnts.rw);
> +	while ((old.rw > _QW_WAITING) || !qwrite_trylock(lock, old)) {
> +		arch_mutex_cpu_relax();
> +		old.rw = ACCESS_ONCE(lock->cnts.rw);
> +	}
> +	return 1;
> +}
> +
> +/**
> + * queue_write_lock_slowpath - acquire write lock of a queue rwlock
> + * @lock : Pointer to queue rwlock structure
> + */
> +void queue_write_lock_slowpath(struct qrwlock *lock)
> +{
> +	struct qrwnode node;
> +
> +	/*
> +	 * Put the writer into the wait queue
> +	 */
> +	wait_in_queue(lock, &node);
> +
> +	/*
> +	 * At the head of the wait queue now, call queue_write_3step_lock()
> +	 * to acquire the lock until it is done.
> +	 */
> +	while (!queue_write_3step_lock(lock))
> +		arch_mutex_cpu_relax();
> +	signal_next(lock, &node);
> +}
> +EXPORT_SYMBOL(queue_write_lock_slowpath);
> -- 
> 1.7.1
> 

