Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaFPUuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:50:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22148 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaFPUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:50:21 -0400
Date: Mon, 16 Jun 2014 16:49:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 01/11] qspinlock: A simple generic 4-byte queue spinlock
Message-ID: <20140616204918.GA26140@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130152.912524881@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615130152.912524881@chello.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:46:58PM +0200, Peter Zijlstra wrote:
> From: Waiman Long <Waiman.Long@hp.com>
> 
> This patch introduces a new generic queue spinlock implementation that
> can serve as an alternative to the default ticket spinlock. Compared
> with the ticket spinlock, this queue spinlock should be almost as fair
> as the ticket spinlock. It has about the same speed in single-thread
> and it can be much faster in high contention situations especially when
> the spinlock is embedded within the data structure to be protected.
> 
> Only in light to moderate contention where the average queue depth
> is around 1-3 will this queue spinlock be potentially a bit slower
> due to the higher slowpath overhead.
> 
> This queue spinlock is especially suit to NUMA machines with a large
> number of cores as the chance of spinlock contention is much higher
> in those machines. The cost of contention is also higher because of
> slower inter-node memory traffic.
> 
> Due to the fact that spinlocks are acquired with preemption disabled,
> the process will not be migrated to another CPU while it is trying
> to get a spinlock. Ignoring interrupt handling, a CPU can only be
> contending in one spinlock at any one time. Counting soft IRQ, hard
> IRQ and NMI, a CPU can only have a maximum of 4 concurrent lock waiting
> activities.  By allocating a set of per-cpu queue nodes and used them
> to form a waiting queue, we can encode the queue node address into a
> much smaller 24-bit size (including CPU number and queue node index)
> leaving one byte for the lock.
> 
> Please note that the queue node is only needed when waiting for the
> lock. Once the lock is acquired, the queue node can be released to
> be used later.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Thank you for the repost. I have some questions about the implementation
that hopefully will be easy to answer and said answers I hope can
be added in the code to enlighten other folks.

See below.
.. snip..

> Index: linux-2.6/kernel/locking/mcs_spinlock.h
> ===================================================================
> --- linux-2.6.orig/kernel/locking/mcs_spinlock.h
> +++ linux-2.6/kernel/locking/mcs_spinlock.h
> @@ -17,6 +17,7 @@
>  struct mcs_spinlock {
>  	struct mcs_spinlock *next;
>  	int locked; /* 1 if lock acquired */
> +	int count;

This could use a comment.

>  };
>  
>  #ifndef arch_mcs_spin_lock_contended
> Index: linux-2.6/kernel/locking/qspinlock.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/kernel/locking/qspinlock.c
> @@ -0,0 +1,197 @@
> +/*
> + * Queue spinlock
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
> + * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
> + *
> + * Authors: Waiman Long <waiman.long@hp.com>
> + *          Peter Zijlstra <pzijlstr@redhat.com>
> + */
> +#include <linux/smp.h>
> +#include <linux/bug.h>
> +#include <linux/cpumask.h>
> +#include <linux/percpu.h>
> +#include <linux/hardirq.h>
> +#include <linux/mutex.h>
> +#include <asm/qspinlock.h>
> +
> +/*
> + * The basic principle of a queue-based spinlock can best be understood
> + * by studying a classic queue-based spinlock implementation called the
> + * MCS lock. The paper below provides a good description for this kind
> + * of lock.
> + *
> + * http://www.cise.ufl.edu/tr/DOC/REP-1992-71.pdf
> + *
> + * This queue spinlock implementation is based on the MCS lock, however to make
> + * it fit the 4 bytes we assume spinlock_t to be, and preserve its existing
> + * API, we must modify it some.
> + *
> + * In particular; where the traditional MCS lock consists of a tail pointer
> + * (8 bytes) and needs the next pointer (another 8 bytes) of its own node to
> + * unlock the next pending (next->locked), we compress both these: {tail,
> + * next->locked} into a single u32 value.
> + *
> + * Since a spinlock disables recursion of its own context and there is a limit
> + * to the contexts that can nest; namely: task, softirq, hardirq, nmi, we can
> + * encode the tail as and index indicating this context and a cpu number.
> + *
> + * We can further change the first spinner to spin on a bit in the lock word
> + * instead of its node; whereby avoiding the need to carry a node from lock to
> + * unlock, and preserving API.
> + */
> +
> +#include "mcs_spinlock.h"
> +
> +/*
> + * Per-CPU queue node structures; we can never have more than 4 nested
> + * contexts: task, softirq, hardirq, nmi.
> + *
> + * Exactly fits one cacheline.
> + */
> +static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[4]);
> +
> +/*
> + * We must be able to distinguish between no-tail and the tail at 0:0,
> + * therefore increment the cpu number by one.
> + */
> +
> +static inline u32 encode_tail(int cpu, int idx)
> +{
> +	u32 tail;
> +
> +	tail  = (cpu + 1) << _Q_TAIL_CPU_OFFSET;
> +	tail |= idx << _Q_TAIL_IDX_OFFSET; /* assume < 4 */

Should there an

ASSSERT (idx < 4)

just in case we screw up somehow (I can't figure out how, but
that is partially why ASSERTS are added).

> +
> +	return tail;
> +}
> +
> +static inline struct mcs_spinlock *decode_tail(u32 tail)
> +{
> +	int cpu = (tail >> _Q_TAIL_CPU_OFFSET) - 1;
> +	int idx = (tail &  _Q_TAIL_IDX_MASK) >> _Q_TAIL_IDX_OFFSET;
> +
> +	return per_cpu_ptr(&mcs_nodes[idx], cpu);
> +}
> +
> +/**
> + * queue_spin_lock_slowpath - acquire the queue spinlock
> + * @lock: Pointer to queue spinlock structure
> + * @val: Current value of the queue spinlock 32-bit word
> + *
> + * (queue tail, lock bit)

Except it is not a lock bit. It is a lock uint8_t.

Is the queue tail at this point the composite of 'cpu|idx'?

> + *
> + *              fast      :    slow                                  :    unlock
> + *                        :                                          :
> + * uncontended  (0,0)   --:--> (0,1) --------------------------------:--> (*,0)
> + *                        :       | ^--------.                    /  :
> + *                        :       v           \                   |  :
> + * uncontended            :    (n,x) --+--> (n,0)                 |  :

So many CPUn come in right? Is 'n' for the number of CPUs?


> + *   queue                :       | ^--'                          |  :
> + *                        :       v                               |  :
> + * contended              :    (*,x) --+--> (*,0) -----> (*,1) ---'  :
> + *   queue                :         ^--'                             :

And here um, what are the '*' for? Are they the four different
types of handlers that can be nested? So task, sofitrq, hardisk, and
nmi?

> + *
> + */
> +void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
> +{
> +	struct mcs_spinlock *prev, *next, *node;
> +	u32 new, old, tail;
> +	int idx;
> +
> +	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
> +
> +	node = this_cpu_ptr(&mcs_nodes[0]);
> +	idx = node->count++;

If this is the first time we enter this, wouldn't idx end up
being 1?

> +	tail = encode_tail(smp_processor_id(), idx);
> +
> +	node += idx;

Meaning we end up skipping the 'mcs_nodes[0]' one altogether - even
on the first 'level' (task, softirq, hardirq, nmi)? Won't that
cause us to blow past the array when we are nested at the nmi
handler?

> +	node->locked = 0;
> +	node->next = NULL;
> +
> +	/*
> +	 * trylock || xchg(lock, node)
> +	 *
> +	 * 0,0 -> 0,1 ; trylock
> +	 * p,x -> n,x ; prev = xchg(lock, node)

I looked at that for 10 seconds and I was not sure what you meant.
Is this related to the MCS document you had pointed to? It would help
if you mention that the comments follow the document. (But they
don't seem to)

I presume what you mean is that if we are the next after the
lock-holder we need only to update the 'next' (or the
composite value of smp_processor_idx | idx) to point to us.

As in, swap the 'L' with 'I' (looking at the doc)

> +	 */
> +	for (;;) {
> +		new = _Q_LOCKED_VAL;
> +		if (val)

Could you add a comment here, like this:

/*
 * N.B. Initially 'val' will have some value (as we are called
 * after the _Q_LOCKED_VAL could not be set by queue_spin_lock).
 * But on subsequent iterations, either the lock holder will
 * decrement the val (queue_spin_unlock - to zero) and we
 * needn't to record our status in the queue as we have set the
 * Q_LOCKED_VAL (new) and are the lock holder. Or we are next
 * in line and need to record our 'next' (aka, smp_processor_id() | idx)
 * position. */
 */

> +			new = tail | (val & _Q_LOCKED_MASK);
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +
> +	/*
> +	 * we won the trylock; forget about queueing.
> +	 */
> +	if (new == _Q_LOCKED_VAL)
> +		goto release;
> +
> +	/*
> +	 * if there was a previous node; link it and wait.
> +	 */
> +	if (old & ~_Q_LOCKED_MASK) {
> +		prev = decode_tail(old);
> +		ACCESS_ONCE(prev->next) = node;
> +
> +		arch_mcs_spin_lock_contended(&node->locked);
> +	}
> +
> +	/*
> +	 * we're at the head of the waitqueue, wait for the owner to go away.
> +	 *
> +	 * *,x -> *,0
> +	 */
> +	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
> +		cpu_relax();
> +
> +	/*
> +	 * claim the lock:
> +	 *
> +	 * n,0 -> 0,1 : lock, uncontended
> +	 * *,0 -> *,1 : lock, contended
> +	 */
> +	for (;;) {
> +		new = _Q_LOCKED_VAL;
> +		if (val != tail)
> +			new |= val;

You lost me here. If we are at the head of the queue, and the owner
has called queue_spin_unlock (hence made us get out of the 'val = atomic_read'
loop, how can val != tail?

I suspect it has something to do with the comment, but I am still unsure
what it means.

Could you help a bit in explaining it in English please?

> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +
> +	/*
> +	 * contended path; wait for next, release.
> +	 */
> +	if (new != _Q_LOCKED_VAL) {

Hm, wouldn't it be just easier to do a 'goto restart' where
restart label points at the first loop statement? Ah never
mind - we have already inserted ourselves in the previous's
node.

But that is confusing - we have done: "prev->next = node;"

And then exited out of 'val = atomic_read(&lock->val))' which
suggests that queue_spin_unlock has called us. How can we be
contended again?


Thanks!
> +		while (!(next = ACCESS_ONCE(node->next)))
> +			cpu_relax();
> +
> +		arch_mcs_spin_unlock_contended(&next->locked);
> +	}
> +
> +release:
> +	/*
> +	 * release the node
> +	 */
> +	this_cpu_dec(mcs_nodes[0].count);
> +}
> +EXPORT_SYMBOL(queue_spin_lock_slowpath);
> 
> 
