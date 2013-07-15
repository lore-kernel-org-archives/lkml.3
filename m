Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3GOOjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:39:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3GOOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:39:09 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=yb6feQQCT88A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=eG9mQB0CiyQA:10 a=cH6R9-kdAAAA:8 a=N85n-4EfaQ_2GaUU8SMA:9 a=QEXdDO2ut3YA:10 a=bt0zGP92IBIA:10 a=gwGeWa61Dvlj6azE:21 a=mksL66dqnobzRDBx:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373899141.17876.145.camel@gandalf.local.home>
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Date: Mon, 15 Jul 2013 10:39:01 -0400
In-Reply-To: <1373679249-27123-2-git-send-email-Waiman.Long@hp.com>
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com>
	 <1373679249-27123-2-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 21:34 -0400, Waiman Long wrote:

> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  include/asm-generic/qrwlock.h |  124 +++++++++++++++++++++
>  lib/Kconfig                   |   11 ++
>  lib/Makefile                  |    1 +
>  lib/qrwlock.c                 |  246 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 382 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-generic/qrwlock.h
>  create mode 100644 lib/qrwlock.c
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> new file mode 100644
> index 0000000..d758dd0
> --- /dev/null
> +++ b/include/asm-generic/qrwlock.h
> @@ -0,0 +1,124 @@
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
> +#include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> +
> +#if (CONFIG_NR_CPUS < 65536)
> +typedef u16 __nrcpu_t;
> +typedef u32 __nrcpupair_t;
> +#else
> +typedef u32 __nrcpu_t;
> +typedef u64 __nrcpupair_t;
> +#endif
> +
> +/*
> + * The queue read/write lock data structure
> + * The reader stealing flag, if sea,t will enable reader at the head of the

"sea,t"?

> + * waiting queue to steal the read lock even if a writer is waiting. However,
> + * that may cause starving of a writer by a perpetual stream of readers.
> + */
> +struct qrwnode {
> +	struct qrwnode *next;
> +	bool		wait;	/* Waiting flag */
> +};
> +
> +typedef struct qrwlock {
> +	union {
> +		__nrcpupair_t rw;		/* Reader/writer number pair */
> +		struct {
> +			u8	  writer;	/* Set if a writer is waiting */
> +			u8	  rsteal;	/* Reader stealing flag */
> +			__nrcpu_t readers;	/* Number of active readers */
> +		};
> +	};
> +	struct qrwnode *waitq;			/* Tail of waiting queue */
> +} arch_rwlock_t;
> +
> +/**
> + * queue_read_can_lock- would read_trylock() succeed?
> + * @lock: Pointer to queue read/writer lock structure
> + */
> +static inline int queue_read_can_lock(struct qrwlock *lock)
> +{
> +	return lock->writer == 0;
> +}
> +
> +/**
> + * queue_write_can_lock- would write_trylock() succeed?
> + * @lock: Pointer to queue read/writer lock structure
> + */
> +static inline int queue_write_can_lock(struct qrwlock *lock)
> +{
> +	return lock->rw == 0;
> +}
> +
> +/**
> + * queue_read_unlock - release read lock of a queue read/write lock
> + * @lock : Pointer to queue read/writer lock structure
> + */
> +static inline void queue_read_unlock(struct qrwlock *lock)
> +{
> +	/*
> +	 * Atomically decrement the reader count
> +	 */
> +	add_smp(&lock->readers, -1);
> +}
> +
> +/**
> + * queue_write_unlock - release write lock of a queue read/write lock
> + * @lock : Pointer to queue read/writer lock structure
> + */
> +static inline void queue_write_unlock(struct qrwlock *lock)
> +{
> +	ACCESS_ONCE(lock->writer) = 0;
> +	smp_wmb();
> +}
> +
> +/*
> + * External function declarations
> + */
> +extern void queue_read_lock(struct qrwlock *);
> +extern void queue_write_lock(struct qrwlock *);
> +extern int  queue_read_trylock(struct qrwlock *);
> +extern int  queue_write_trylock(struct qrwlock *);
> +
> +/*
> + * Initializier
> + */
> +#define	__ARCH_RW_LOCK_UNLOCKED	{ { .rw = 0 }, .waitq = NULL }
> +#define	__ARCH_RW_LOCK_UNLOCKED_RSTEAL	\
> +	{ { .writer = 0, .rsteal = 1, .readers = 0 }, waitq = NULL }
> +
> +/*
> + * Remapping read/write lock architecture specific functions to the
> + * corresponding queue read/write lock functions.
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
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 35da513..de32799 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -412,6 +412,17 @@ config SIGNATURE
>  	  Implementation is done using GnuPG MPI library
>  
>  #
> +# Generic queue read/write lock
> +#
> +config QUEUE_RWLOCK
> +	bool "Generic queue read/write lock"
> +	depends on ARCH_QUEUE_RWLOCK
> +	help
> +	  Use a NUMA optimized queue read/write lock implementation. This
> +	  improves performance under lock contention on systems with more
> +	  than two sockets.
> +
> +#
>  # libfdt files, only selected if needed.
>  #
>  config LIBFDT
> diff --git a/lib/Makefile b/lib/Makefile
> index 7baccfd..2888c17 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -187,3 +187,4 @@ quiet_cmd_build_OID_registry = GEN     $@
>  clean-files	+= oid_registry_data.c
>  
>  obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
> +obj-$(CONFIG_QUEUE_RWLOCK) += qrwlock.o
> diff --git a/lib/qrwlock.c b/lib/qrwlock.c
> new file mode 100644
> index 0000000..a206fae
> --- /dev/null
> +++ b/lib/qrwlock.c
> @@ -0,0 +1,246 @@
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
> +#include <asm-generic/qrwlock.h>
> +
> +/*
> + * Compared with regular read/write lock, the queue read/write lock has
> + * has the following advantages:
> + * 1. It is more deterministic. Even though there is a slight chance of
> + *    stealing the lock if come at the right moment, the granting of the
> + *    lock is mostly in FIFO order.
> + * 2. It is faster in high contention situation.
> + *
> + * The only downside is that the lock is 4 bytes larger in 32-bit systems
> + * and 12 bytes larger in 64-bit systems.
> + *
> + * There are two queues for writers. The writer field of the lock is a
> + * one-slot waiting queue. The writers that follows will have to wait
> + * in the combined reader/writer queue (waitq).
> + *
> + * Compared with x86 ticket spinlock, the queue read/write lock is faster
> + * in high contention situation. The writer lock is also faster in single
> + * thread operations. Therefore, queue read/write lock can be considered as
> + * a replacement for those spinlocks that are highly contended as long as
> + * an increase in lock size is not an issue.
> + */
> +
> +/**
> + * wait_in_queue - Add to queue and wait until it is at the head
> + * @lock: Pointer to queue read/writer lock structure
> + * @node: Node pointer to be added to the queue
> + */
> +static __always_inline void
> +wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
> +{
> +	struct qrwnode *prev;
> +
> +	node->next = NULL;
> +	node->wait = true;
> +	barrier();
> +	prev = xchg(&lock->waitq, node);

"barrier()" isn't needed, as xchg() is a full blown smp_mb(), it also
acts as a compiler barrier.

> +	if (prev) {
> +		prev->next = node;
> +		smp_wmb();
> +		/*
> +		 * Wait until the waiting flag is off
> +		 */
> +		while (ACCESS_ONCE(node->wait))
> +			cpu_relax();
> +	} else
> +		node->wait = false;
> +}
> +
> +/**
> + * signal_next - Signal the next one in queue to be at the head
> + * @lock: Pointer to queue read/writer lock structure
> + * @node: Node pointer to the current head of queue
> + */
> +static __always_inline void
> +signal_next(struct qrwlock *lock, struct qrwnode *node)
> +{
> +	struct qrwnode *next;
> +
> +	/*
> +	 * Notify the next one in queue or clear the waiting queue
> +	 */
> +	if (ACCESS_ONCE(lock->waitq) == node) {
> +		if (cmpxchg(&lock->waitq, node, NULL) == node)
> +			return;
> +	}
> +	/*
> +	 * Wait until the next one in queue set up the next field
> +	 */
> +	while (!likely(next = ACCESS_ONCE(node->next)))
> +		cpu_relax();
> +	/*
> +	 * The next one in queue is now at the head
> +	 */
> +	ACCESS_ONCE(next->wait) = false;
> +	smp_wmb();
> +}
> +
> +/**
> + * queue_read_lock - acquire read lock of a queue read/write lock
> + * @lock: Pointer to queue read/writer lock structure
> + */
> +void queue_read_lock(struct qrwlock *lock)
> +{
> +	struct qrwlock old, new;
> +	struct qrwnode node;
> +
> +	old.rw = ACCESS_ONCE(lock->rw);
> +	while (likely(!old.writer)) {
> +		/*
> +		 * Atomically increment the reader count while writer is 0
> +		 */
> +		new.rw = old.rw;
> +		new.readers++;
> +
> +		if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
> +			return;
> +		cpu_relax();
> +		old.rw = ACCESS_ONCE(lock->rw);
> +	}
> +	/*
> +	 * Slowpath
> +	 * Put the reader into the waiting queue
> +	 */
> +	wait_in_queue(lock, &node);
> +
> +	/*
> +	 * At the head of the wait queue now, wait until no writer is pending
> +	 * or when the reader stealing flag is set and readers are present.
> +	 * Then try to atomically inc the reader number.
> +	 */
> +	while (true) {
> +		old.rw = ACCESS_ONCE(lock->rw);
> +		if (old.writer && (!old.rsteal || !old.readers)) {
> +			cpu_relax();
> +			continue;
> +		}
> +		new.rw = old.rw;
> +		new.readers++;
> +		if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
> +			break;
> +		cpu_relax();
> +	}
> +	signal_next(lock, &node);
> +}
> +EXPORT_SYMBOL(queue_read_lock);
> +
> +
> +/*
> + * queue_read_trylock - try to acquire read lock of a queue read/write lock
> + * @lock : Pointer to queue read/writer lock structure
> + * Return: 1 if lock acquired, 0 if failed
> + */
> +int queue_read_trylock(struct qrwlock *lock)
> +{
> +	struct qrwlock old, new;
> +
> +	old.rw = ACCESS_ONCE(lock->rw);
> +	if (unlikely(old.writer))
> +		return 0;
> +	new.rw = old.rw;
> +	new.readers++;
> +
> +	if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
> +		return 1;
> +	cpu_relax();

What's the cpu_relax() for? It's not in a loop.


> +	return 0;
> +}
> +EXPORT_SYMBOL(queue_read_trylock);
> +
> +/**
> + * queue_write_lock - acquire write lock of a queue read/write lock
> + * @lock : Pointer to queue read/writer lock structure
> + */
> +void queue_write_lock(struct qrwlock *lock)
> +{
> +	struct qrwnode node, *next;
> +
> +	if (likely(!ACCESS_ONCE(lock->writer))) {
> +		/*
> +		 * Atomically set the writer to 1, then wait until reader
> +		 * count goes to 0.
> +		 */
> +		if (xchg(&lock->writer, 1) == 0) {
> +			while (ACCESS_ONCE(lock->readers))
> +				cpu_relax();
> +			return;
> +		}
> +		cpu_relax();

Another cpu_relax() outside of a loop.

> +	}
> +	/*
> +	 * Slowpath
> +	 * Put the writer into the waiting queue
> +	 */
> +	wait_in_queue(lock, &node);
> +
> +	/*
> +	 * At the head of the wait queue now, wait until no writer is pending
> +	 * and then atomically set it again.
> +	 */
> +	while (true) {
> +		if (ACCESS_ONCE(lock->writer)) {
> +			cpu_relax();
> +			continue;
> +		}
> +		if (xchg(&lock->writer, 1) != 0) {
> +			cpu_relax();
> +			continue;
> +		}
> +		break;
> +	}
> +	/*
> +	 * Wait until the reader count go to zero
> +	 */
> +	while (ACCESS_ONCE(lock->readers))
> +		cpu_relax();
> +
> +	signal_next(lock, &node);
> +}
> +EXPORT_SYMBOL(queue_write_lock);
> +
> +/**
> + * queue_write_trylock - try to acquire write lock of a queue read/write lock
> + * @lock : Pointer to queue read/writer lock structure
> + * Return: 1 if lock acquired, 0 if failed
> + */
> +int queue_write_trylock(struct qrwlock *lock)
> +{
> +	struct qrwlock old, new;
> +
> +	old.rw = ACCESS_ONCE(lock->rw);
> +	if (!old.rw) {
> +		/*
> +		 * Atomically set the writer to 1 if readers = 0
> +		 */
> +		new.rw = old.rw;
> +		new.writer = 1;
> +		if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
> +			return 1;
> +		cpu_relax();

Again the cpu_relax with no loop.

> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(queue_write_trylock);

I haven't seen anything bad about this with a quick review. But it
should have a more thorough review to check all corner cases.

-- Steve


