Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3JWMAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:00:16 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36624 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3JWMAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:00:11 -0400
Date: Wed, 23 Oct 2013 05:00:04 -0700
From: walken@google.com
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v4 1/3] qrwlock: A queue read/write lock implementation
Message-ID: <20131023120004.GD2862@localhost>
References: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
 <1380722946-30468-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380722946-30468-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 10:09:04AM -0400, Waiman Long wrote:
> This patch introduces a new read/write lock implementation that put
> waiting readers and writers into a queue instead of actively contending
> the lock like the current read/write lock implementation. This will
> improve performance in highly contended situation by reducing the
> cache line bouncing effect.
> 
> The queue read/write lock (qrwlock) is mostly fair with respect to
> the writers, even though there is still a slight chance of write
> lock stealing.
> 
> Externally, there are two different types of readers - unfair (the
> default) and fair. A unfair reader will try to steal read lock even
> if a writer is waiting, whereas a fair reader will be waiting in
> the queue under this circumstance.  These variants are chosen at
> initialization time by using different initializers. The new *_fair()
> initializers are added for selecting the use of fair reader.
> 
> Internally, there is a third type of readers which steal lock more
> aggressively than the unfair reader. They simply increments the reader
> count and wait until the writer releases the lock. The transition to
> aggressive reader happens in the read lock slowpath when
> 1. In an interrupt context.
> 2. when a classic reader comes to the head of the wait queue.
> 3. When a fair reader comes to the head of the wait queue and sees
>    the release of a write lock.
> 
> The fair queue rwlock is more deterministic in the sense that late
> comers jumping ahead and stealing the lock is unlikely even though
> there is still a very small chance for lock stealing to happen if
> the readers or writers come at the right moment.  Other than that,
> lock granting is done in a FIFO manner.  As a result, it is possible
> to determine a maximum time period after which the waiting is over
> and the lock can be acquired.
> 
> The queue read lock is safe to use in an interrupt context (softirq
> or hardirq) as it will switch to become an aggressive reader in such
> environment allowing recursive read lock. However, the fair readers
> will not support recursive read lock in a non-interrupt environment
> when a writer is waiting.
> 
> The only downside of queue rwlock is the size increase in the lock
> structure by 4 bytes for 32-bit systems and by 12 bytes for 64-bit
> systems.
> 
> This patch will replace the architecture specific implementation
> of rwlock by this generic version of queue rwlock when the
> ARCH_QUEUE_RWLOCK configuration parameter is set.
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
> Queue read lock	     	     16.0	 13.5
> Queue fair read lock	     16.0	 13.5
> Queue write lock	      9.2	  7.8
> Queue fair write lock	     17.5	 14.5
> 
> The queue read lock is slightly slower than the spinlock, but is
> slightly faster than the read lock. The queue write lock, however,
> is the fastest of all. It is almost twice as fast as the write lock
> and about 1.5X of the spinlock. The queue fair write lock, on the
> other hand, is slightly slower than the write lock.
> 
> With lock contention, the speed of each individual lock/unlock function
> is less important than the amount of contention-induced delays.
> 
> To investigate the performance characteristics of the queue rwlock
> compared with the regular rwlock, Ingo's anon_vmas patch that convert
> rwsem to rwlock was applied to a 3.12-rc2 kernel. This kernel was
> then tested under the following 4 conditions:
> 
> 1) Plain 3.12-rc2
> 2) Ingo's patch
> 3) Ingo's patch + unfair qrwlock (default)
> 4) Ingo's patch + fair qrwlock
> 
> The jobs per minutes (JPM) results of the AIM7's high_systime workload
> at 1500 users on a 8-socket 80-core DL980 (HT off) were:
> 
> Kernel	JPM	%Change from (1)
> ------	---	----------------
>   1	148265		-
>   2	238715	       +61%
>   3	242048	       +63%
>   4	234881	       +58%
> 
> The use of unfair qrwlock provides a small boost of 2%, while using
> fair qrwlock leads to 3% decrease of performance. However, looking
> at the perf profiles, we can clearly see that other bottlenecks were
> constraining the performance improvement.
> 
> Perf profile of kernel (2):
> 
>   18.20%   reaim  [kernel.kallsyms]  [k] __write_lock_failed
>    9.36%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>    2.91%   reaim  [kernel.kallsyms]  [k] mspin_lock
>    2.73%   reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
>    2.23%      ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>    1.29%   reaim  [kernel.kallsyms]  [k] __read_lock_failed
>    1.21%    true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>    1.14%   reaim  [kernel.kallsyms]  [k] zap_pte_range
>    1.13%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock
>    1.04%   reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
> 
> Perf profile of kernel (3):
> 
>   10.57%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>    7.98%   reaim  [kernel.kallsyms]  [k] queue_write_lock_slowpath
>    5.83%   reaim  [kernel.kallsyms]  [k] mspin_lock
>    2.86%      ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>    2.71%   reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
>    1.52%    true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>    1.51%   reaim  [kernel.kallsyms]  [k] queue_read_lock_slowpath
>    1.35%   reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
>    1.12%   reaim  [kernel.kallsyms]  [k] zap_pte_range
>    1.06%   reaim  [kernel.kallsyms]  [k] perf_event_aux_ctx
>    1.01%   reaim  [kernel.kallsyms]  [k] perf_event_aux
> 
> Tim Chen also tested the qrwlock with Ingo's patch on a 4-socket
> machine.  It was found the performance improvement of 11% was the
> same with regular rwlock or queue rwlock.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

I haven't followed all the locking threads lately; did this get into any
tree yet and is it still being considered ?

> + * Writer state values & mask
> + */
> +#define	QW_WAITING	1			/* A writer is waiting	   */
> +#define	QW_LOCKED	0xff			/* A writer holds the lock */
> +#define QW_MASK_FAIR	((u8)~QW_WAITING)	/* Mask for fair reader    */
> +#define QW_MASK_UNFAIR	((u8)~0)		/* Mask for unfair reader  */

I'm confused - I expect fair readers want to queue behind a waiting writer,
so shouldn't this be QW_MASK_FAIR=~0 and QW_MASK_UNFAIR=~QW_WAITING ?

> +/**
> + * wait_in_queue - Add to queue and wait until it is at the head
> + * @lock: Pointer to queue rwlock structure
> + * @node: Node pointer to be added to the queue
> + *
> + * The use of smp_wmb() is to make sure that the other CPUs see the change
> + * ASAP.
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
> +		smp_wmb();
> +		/*
> +		 * Wait until the waiting flag is off
> +		 */
> +		while (ACCESS_ONCE(node->wait))
> +			cpu_relax();
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
> +		cpu_relax();
> +	/*
> +	 * The next one in queue is now at the head
> +	 */
> +notify_next:
> +	barrier();
> +	ACCESS_ONCE(next->wait) = false;
> +	smp_wmb();
> +}

I believe this could be unified with mspin_lock() / mspin_unlock() in
kernel/mutex.c ? (there is already talk of extending these functions
to be used by rwsem for adaptive spinning as well...)


Not a full review yet - I like the idea of making rwlock more fair but
I haven't dug too much into the details yet.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
