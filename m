Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3HAURO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:17:14 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53582 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab3HAURK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:17:10 -0400
Message-ID: <51FAC3BA.9050705@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 01:53:22 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1375324631-32868-1-git-send-email-Waiman.Long@hp.com> <1375324631-32868-2-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1375324631-32868-2-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080120-9264-0000-0000-0000043F941E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 08:07 AM, Waiman Long wrote:
> This patch introduces a new queue spinlock implementation that can
> serve as an alternative to the default ticket spinlock. Compared
> with the ticket spinlock, this queue spinlock should be as fair as
> the ticket spinlock. It is faster both in single-thread and in high
> contention situations. Only in light to moderate contention where
> the average queue depth is around 1-2 will this queue spinlock be
> potentially a bit slower due to the higher slowpath overhead.
>
> This queue spinlock is especially suit to NUMA machines with a large
> number of cores as the chance of spinlock contention is much higher
> in those machines.
>
> The idea behind this spinlock implementation is the fact that spinlocks
> are acquired with preemption disabled. In other words, the process
> will not be migrated to another CPU while it is trying to get a
> spinlock. Ignoring interrupt handling, a CPU can only be contending
> in one spinlock at any one time. Of course, interrupt handler can try
> to acquire one spinlock while the interrupted user process is in the
> process of getting another spinlock. By allocating a set of per-cpu
> queue nodes and used them to form a waiting queue, we can encode the
> queue node address into a much smaller 16-bit size. Together with
> the 1-byte lock bit, this queue spinlock implementation will only
> need 4 bytes to hold all the information that it needs.
>
> The current queue node address encoding is as follows:
> Bits 0-1 : queue node index in the per-cpu array (4 entries)
> Bits 2-16: cpu number + 1 (max cpus = 16383)
>
> By using also the unused byte, we could support more cpus and queue
> node entries in the array at the expense of more coding and probably
> performance overheads.
>
> In the extremely unlikely case that all the queue node entries are
> used up, the current code will fall back to busy spinning without
> waiting in a queue with warning message.
>
> With minor modification to the lock fastpath, we could also make a
> less fair version of queue spinlock that allows lock stealing. This
> can potentially provide better performance for some workloads.
>
> This patch allows the optional replacement of architecture specific
> implementation of ticket spinlock by this generic version of queue
> spinlock. Two new config parameters are introduced:
>
> 1. QUEUE_SPINLOCK
>     A select-able option that enables the building and replacement of
>     architecture specific spinlock by queue spinlock.
> 2. ARCH_QUEUE_SPINLOCK
>     Have to be defined in arch/$(ARCH)/Kconfig to enable QUEUE_SPINLOCK
>     option. This option, by itself, will not enable the queue spinlock
>     feature.
>
> For single-thread performance (no contention), a 256K lock/unlock
> loop was run on a 2.93Ghz Westmere x86-64 CPU.  The following table
> shows the average time (in ns) for a single lock/unlock sequence
> (including the looping and timing overhead):
>
> Lock Type		Time (ns)
> ---------		---------
> Ticket spinlock		  12.1
> Queue spinlock		  10.9
>
> So the queue spinlock is slightly faster.
>
> The AIM7 benchmark was run on a 8-socket 80-core DL980 with Westmere
> x86-64 CPUs to evaluate the performance impact of this patch on the
> 3.10.1 kernel. The jobs per minute (JPM) results for the 1100-2000
> user ranges are shown below:
>
> +------------+--------+--------+--------+--------+--------+--------+
> | Kernel     | 3.10.1 | 3.10.1 |%Change | 3.10.1 | 3.10.1 |%Change |
> |            |        | qlock  |        |        | qlock  |        |
> | HT         |  off   |  off   |        |   on   |   on   |        |
> +------------+--------+--------+--------+--------+--------+--------+
> |alltests    | 403590 | 397622 |  -1.5% | 411479 | 411428 |   0.0% |
> |custom      | 304581 | 307165 |  +0.9% | 230335 | 254798 | +10.6% |
> |dbase       | 896252 | 900597 |  +0.5% |1134659 |1137730 |  +0.3% |
> |disk        | 213679 | 270597 | +26.6% | 203974 | 249998 | +22.6% |
> |five_sec    | 144012 | 157286 |  +9.2% | 132599 | 150812 | +13.7% |
> |fserver     | 472741 | 467213 |  -1.2% | 270601 | 285737 |  +5.6% |
> |high_systime| 131106 | 139015 |  +6.0% | 120294 | 125802 |  +4.6% |
> |new_dbase   | 934871 | 936860 |  +0.2  |1177640 |1181679 |  +0.3% |
> |new_fserver | 452544 | 444967 |  -1.7% | 262368 | 275827 |  +5.1% |
> |shared      | 366750 | 369901 |  +0.9% | 403645 | 415840 |  +3.0% |
> |short       |1061663 |3003942 |+183.0% |1040392 |2834437 |+172.4% |
> +------------+--------+--------+--------+--------+--------+--------+
>
> There are cases where the performance drops 1-2%, but the majority
> of them are performance gains and some of them are pretty significant.
>
> For the disk workload, the spinlock bottleneck is the standalone
> mb_cache_spinlock in fs/mbcache.c. For the short workload, the spinlock
> bottleneck is the d_lock in the dentry structure.
>
> The following table shows the %time used up by the locks as reported
> by the perf command at 1000 users for disk workload & 1500 users for
> short workload with HT off.
>
> -----------------+----------+----------+----------+
>      Lock 	 | ticket   |  qlock   |  qlock   |
> 		 | spinlock | fastpath | slowpath |
> -----------------+----------+----------+----------+
> Disk w/o patch	 |  69.0%   |    -     |    -     |
> Disk with patch	 |    -     |  0.31%   |  73.6%   |
> Short w/o patch	 |  74.3%   |    -     |    -     |
> Short with patch |    -     |  0.72%   |  72.3%   |
> -----------------+----------+----------+----------+
>
> There are 2 observations here:
> 1. The %CPU time actually increases in the disk workload with the
>     patch. The fact that most of them are spinning on their own
>     cacheline with less congestion can probably skew the number up.
>
> 2. Both the short and disk workloads spend about 70% of their time
>     in the lock. However, performance improvement is 2.8X vs 1.3X.
>     This is probably due to the fact that d_lock is embedded next
>     to the d_count to be updated whereas mb_cache_spinlock is in a
>     standalone cacheline not shared by the data to be updated.
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>   include/asm-generic/qspinlock.h |  120 ++++++++++++++++++++
>   lib/Kconfig                     |   14 +++
>   lib/Makefile                    |    1 +
>   lib/qspinlock.c                 |  237 +++++++++++++++++++++++++++++++++++++++
>   4 files changed, 372 insertions(+), 0 deletions(-)
>   create mode 100644 include/asm-generic/qspinlock.h
>   create mode 100644 lib/qspinlock.c
>
> diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
> new file mode 100644
> index 0000000..4cfb369
> --- /dev/null
> +++ b/include/asm-generic/qspinlock.h
> @@ -0,0 +1,120 @@
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
> + * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
> + *
> + * Authors: Waiman Long <waiman.long@hp.com>
> + */
> +#ifndef __ASM_GENERIC_QSPINLOCK_H
> +#define __ASM_GENERIC_QSPINLOCK_H
> +
> +#include <linux/types.h>
> +#include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> +#include <asm/processor.h>
> +
> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> +#define	qspinlock arch_spinlock
> +#endif
> +
> +/*
> + * The queue spinlock data structure
> + */
> +typedef struct qspinlock {
> +	union {
> +		struct {
> +			u8	locked;		/* Bit lock */
> +			u8	reserved;
> +			u16	qcode;		/* Wait queue code */
> +		};
> +		u32		qlock;
> +	};
> +} arch_spinlock_t;
> +
> +/*
> + * External function declarations
> + */
> +extern void queue_spin_lock_slowpath(struct qspinlock *lock);
> +
> +/**
> + * queue_spin_is_locked - is the spinlock locked?
> + * @lock: Pointer to queue spinlock structure
> + * Return: 1 if it is locked, 0 otherwise
> + */
> +static __always_inline int queue_spin_is_locked(struct qspinlock *lock)
> +{
> +	return ACCESS_ONCE(lock->locked);
> +}
> +
> +/**
> + * queue_spin_is_contended - check if the lock is contended
> + * @lock : Pointer to queue spinlock structure
> + * Return: 1 if lock contended, 0 otherwise
> + */
> +static __always_inline int queue_spin_is_contended(struct qspinlock *lock)
> +{
> +	return ACCESS_ONCE(lock->qcode);
> +}
> +/**
> + * queue_spin_trylock - try to acquire the queue spinlock
> + * @lock : Pointer to queue spinlock structure
> + * Return: 1 if lock acquired, 0 if failed
> + */
> +static __always_inline int queue_spin_trylock(struct qspinlock *lock)
> +{
> +	if (!queue_spin_is_contended(lock) && (xchg(&lock->locked, 1) == 0))
> +		return 1;
> +	return 0;
> +}
> +
> +/**
> + * queue_spin_lock - acquire a queue spinlock
> + * @lock: Pointer to queue spinlock structure
> + */
> +static __always_inline void queue_spin_lock(struct qspinlock *lock)
> +{
> +	if (likely(queue_spin_trylock(lock)))
> +		return;
> +	queue_spin_lock_slowpath(lock);
> +}

quickly falling into slowpath may hurt performance in some cases. no?

Instead, I tried something like this:

#define SPIN_THRESHOLD 64

static __always_inline void queue_spin_lock(struct qspinlock *lock)
{
         unsigned count = SPIN_THRESHOLD;
         do {
                 if (likely(queue_spin_trylock(lock)))
                         return;
                 cpu_relax();
         } while (count--);
         queue_spin_lock_slowpath(lock);
}

Though I could see some gains in overcommit, but it hurted undercommit
in some workloads :(.

> +
> +/**
> + * queue_spin_unlock - release a queue spinlock
> + * @lock : Pointer to queue spinlock structure
> + */
> +static __always_inline void queue_spin_unlock(struct qspinlock *lock)
> +{
> +	barrier();
> +	ACCESS_ONCE(lock->locked) = 0;
> +	smp_wmb();
> +}
> +
> +/*
> + * Initializier
> + */
> +#define	__ARCH_SPIN_LOCK_UNLOCKED	{ { .qlock = 0 } }
> +
> +#ifndef CONFIG_PARAVIRT_SPINLOCKS
> +/*
> + * Remapping spinlock architecture specific functions to the corresponding
> + * queue spinlock functions.
> + */
> +#define arch_spin_is_locked(l)		queue_spin_is_locked(l)
> +#define arch_spin_is_contended(l)	queue_spin_is_contended(l)
> +#define arch_spin_lock(l)		queue_spin_lock(l)
> +#define arch_spin_trylock(l)		queue_spin_trylock(l)
> +#define arch_spin_unlock(l)		queue_spin_unlock(l)
> +#define arch_spin_lock_flags(l, f)	queue_spin_lock(l)
> +#endif
> +
> +#endif /* __ASM_GENERIC_QSPINLOCK_H */
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 35da513..15e0e02 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -412,6 +412,20 @@ config SIGNATURE
>   	  Implementation is done using GnuPG MPI library
>
>   #
> +# Generic queue spinlock
> +#
> +config QUEUE_SPINLOCK
> +	bool "Generic queue spinlock"
> +	depends on ARCH_QUEUE_SPINLOCK
> +	default n
> +	help
> +	  Use an alternative spinlock implementation that has the same
> +	  spinlock structure size but is more optimized for larger
> +	  NUMA systems with a lot of CPU cores. Specifically, waiting
> +	  lock spinners are put to wait in a queue on a local cacheline
> +	  rather than all spinning on the same lock cacheline.
> +
> +#
>   # libfdt files, only selected if needed.
>   #
>   config LIBFDT
> diff --git a/lib/Makefile b/lib/Makefile
> index 7baccfd..b53710a 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -187,3 +187,4 @@ quiet_cmd_build_OID_registry = GEN     $@
>   clean-files	+= oid_registry_data.c
>
>   obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
> +obj-$(CONFIG_QUEUE_SPINLOCK) += qspinlock.o
> diff --git a/lib/qspinlock.c b/lib/qspinlock.c
> new file mode 100644
> index 0000000..21d5f6e
> --- /dev/null
> +++ b/lib/qspinlock.c
> @@ -0,0 +1,237 @@
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
> + * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
> + *
> + * Authors: Waiman Long <waiman.long@hp.com>
> + */
> +#include <linux/smp.h>
> +#include <linux/bug.h>
> +#include <linux/cpumask.h>
> +#include <linux/percpu.h>
> +#include <linux/hardirq.h>
> +#include <asm-generic/qspinlock.h>
> +
> +/*
> + * The queue spinlock fastpath is as simple as it can get, all the heavy
> + * lifting is done in the lock slowpath. The main idea behind this queue
> + * spinlock implementation is to keep the spinlock size at 4 bytes while
> + * at the same time implement a queue structure to queue up the waiting
> + * lock spinners.
> + *
> + * Since preemption is disabled before getting the lock, a given CPU will
> + * only need to use one queue node structure in a non-interrupt context.
> + * A percpu queue node structure will be allocated for this purpose and the
> + * cpu number will be put into the queue spinlock structure to indicate the
> + * tail of the queue.
> + *
> + * To handle spinlock acquisition at interrupt context (softirq or hardirq),
> + * the queue node structure is actually an array for supporting nested spin
> + * locking operations in interrupt handlers. If all the entries in the
> + * array are used up, a warning message will be printed (as that shouldn't
> + * happen in normal circumstances) and the lock spinner will fall back to
> + * busy spinning instead of waiting in a queue.
> + */
> +
> +/*
> +#ifndef CONFIG_DEBUG_SPINLOCK
> +#define CONFIG_DEBUG_SPINLOCK 1
> +#endif
> + */
> +
> +/*
> + * The queue node structure
> + */
> +struct qnode {
> +	struct qnode	*next;
> +	u8		 wait;		/* Waiting flag	*/
> +	u8		 used;		/* Used flag	*/
> +#ifdef	CONFIG_DEBUG_SPINLOCK
> +	u16		 cpu_nr;	/* CPU number	*/
> +	void		*lock;		/* Lock address */
> +#endif
> +};
> +
> +/*
> + * The 16-bit wait queue code is divided into the following 2 fields:
> + * Bits 0-1 : queue node index
> + * Bits 2-15: cpu number + 1
> + *
> + * The current implementation will allow a maximum of (1<<14)-1 = 16383 CPUs.
> + */
> +#define	GET_QN_IDX(code)	((code) & 0x3)
> +#define GET_CPU_NR(code)	(((code) >> 2) - 1)
> +#define	SET_CPU_CODE(cpu, idx)	((((cpu) + 1) << 2) | idx)
> +#define	MAX_QNODES		4
> +#define	MAX_CPUS		((1<<14)-1)
> +
> +/*
> + * Per-CPU queue node structures
> + */
> +static DEFINE_PER_CPU(struct qnode [MAX_QNODES], qnodes) = { { 0 } };
> +
> +/**
> + * queue_trylock - try to acquire the lock bit ignoring the qcode in lock
> + * @lock: Pointer to queue spinlock structure
> + * Return: 1 if lock acquired, 0 if failed
> + */
> +static __always_inline int queue_trylock(struct qspinlock *lock)
> +{
> +	if (!ACCESS_ONCE(lock->locked) && (xchg(&lock->locked, 1) == 0))
> +		return 1;
> +	return 0;
> +}

It took long time for me to confirm myself that,
this is being used when we exhaust all the nodes. But not sure of
any better name so that it does not confuse with queue_spin_trylock.
anyway, they are in different files :).

> +
> +/**
> + * queue_spin_lock_slowpath - acquire the queue spinlock
> + * @lock: Pointer to queue spinlock structure
> + */
> +void queue_spin_lock_slowpath(struct qspinlock *lock)
> +{
> +	unsigned int cpu_nr, qn_idx;
> +	struct qnode *node, *prev, *next;
> +	u16 oldcode, newcode;
> +
> +	/*
> +	 * The current code does not work with more than 64K-1 cpus.
> +	 */
> +	BUILD_BUG_ON(CONFIG_NR_CPUS >= MAX_CPUS);
> +
> +	/*
> +	 * Get the queue node
> +	 */
> +	cpu_nr = smp_processor_id();
> +	node   = per_cpu_ptr(&qnodes[0], cpu_nr);
> +	qn_idx = 0;
> +
> +	if (unlikely(node->used)) {
> +		/*
> +		 * The node has bee used, try to find an empty queue node entry
> +		 */
> +		for (qn_idx = 1; qn_idx < MAX_QNODES; qn_idx++)
> +			if (!node[qn_idx].used)
> +				break;
> +		if (unlikely(qn_idx == MAX_QNODES)) {
> +			/*
> +			 * This shouldn't happen, print a warning message
> +			 * & busy spinning on the lock.
> +			 */
> +			pr_warn("qspinlock: queue node table exhausted at "
> +				"cpu %d!\n", cpu_nr);

as discussed, may be debugfs could help in debugging the code, and as
well as profiling, how many locks taken in slowpath, etc.. etc..
so that we can get rid of printk s.

Result:
sandybridge 32 cpu/ 16 core (HT on) 2 node machine with 16 vcpu kvm
guests.

In general, I am seeing undercommit loads are getting benefited by the 
patches.

base = 3.11-rc1
patched = base + qlock
+----+-----------+-----------+-----------+------------+-----------+
                      hackbench (time in sec lower is better)
+----+-----------+-----------+-----------+------------+-----------+
  oc      base        stdev       patched    stdev       %improvement
+----+-----------+-----------+-----------+------------+-----------+
0.5x    18.9326     1.6072	20.0686     2.9968	  -6.00023
1.0x    34.0585     5.5120	33.2230     1.6119	   2.45313
+----+-----------+-----------+-----------+------------+-----------+
+----+-----------+-----------+-----------+------------+-----------+
                       ebizzy  (records/sec higher is better)
+----+-----------+-----------+-----------+------------+-----------+
  oc      base        stdev       patched    stdev       %improvement
+----+-----------+-----------+-----------+------------+-----------+
0.5x  20499.3750   466.7756	 22257.8750   884.8308	   8.57831
1.0x  15903.5000   271.7126	 17993.5000   682.5095	  13.14176
1.5x  1883.2222   166.3714	  1742.8889   135.2271	  -7.45177
2.5x   829.1250    44.3957	   803.6250    78.8034	  -3.07553
+----+-----------+-----------+-----------+------------+-----------+
+----+-----------+-----------+-----------+------------+-----------+
                    dbench  (Throughput in MB/sec higher is better)
+----+-----------+-----------+-----------+------------+-----------+
  oc      base        stdev       patched    stdev       %improvement
+----+-----------+-----------+-----------+------------+-----------+
0.5x 11623.5000    34.2764	 11667.0250    47.1122	   0.37446
1.0x  6945.3675    79.0642	  6798.4950   161.9431	  -2.11468
1.5x  3950.4367    27.3828	  3910.3122    45.4275	  -1.01570
2.0x  2588.2063    35.2058	  2520.3412    51.7138	  -2.62209
+----+-----------+-----------+-----------+------------+-----------+

I saw dbench results improving to 0.3529, -2.9459, 3.2423, 4.8027
respectively after delaying entering to slowpath above.
[...]

I have not yet tested on bigger machine. I hope that bigger machine will
see significant undercommit improvements.


