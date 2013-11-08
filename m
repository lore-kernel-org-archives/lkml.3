Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab3KHWnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:43:06 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57159 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab3KHWnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:43:04 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Nov 2013 17:43:03 EST
Message-ID: <527D675C.2040008@hp.com>
Date: Fri, 08 Nov 2013 17:36:12 -0500
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
Subject: Re: [PATCH v5 1/4] qrwlock: A queue read/write lock implementation
References: <1383585440-4391-1-git-send-email-Waiman.Long@hp.com> <1383585440-4391-2-git-send-email-Waiman.Long@hp.com> <20131108211123.GH18245@linux.vnet.ibm.com>
In-Reply-To: <20131108211123.GH18245@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 04:11 PM, Paul E. McKenney wrote:
> On Mon, Nov 04, 2013 at 12:17:17PM -0500, Waiman Long wrote:
>> Kernel	JPM	%Change from (1)
>> ------	---	----------------
>>    1	148265		-
>>    2	238715	       +61%
>>    3	242048	       +63%
>>    4	234881	       +58%
>>
>> The use of unfair qrwlock provides a small boost of 2%, while using
>> fair qrwlock leads to 3% decrease of performance. However, looking
>> at the perf profiles, we can clearly see that other bottlenecks were
>> constraining the performance improvement.
>>
>> Perf profile of kernel (2):
>>
>>    18.20%   reaim  [kernel.kallsyms]  [k] __write_lock_failed
>>     9.36%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>>     2.91%   reaim  [kernel.kallsyms]  [k] mspin_lock
>>     2.73%   reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
>>     2.23%      ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>>     1.29%   reaim  [kernel.kallsyms]  [k] __read_lock_failed
>>     1.21%    true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>>     1.14%   reaim  [kernel.kallsyms]  [k] zap_pte_range
>>     1.13%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock
>>     1.04%   reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
>>
>> Perf profile of kernel (3):
>>
>>    10.57%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>>     7.98%   reaim  [kernel.kallsyms]  [k] queue_write_lock_slowpath
>>     5.83%   reaim  [kernel.kallsyms]  [k] mspin_lock
>>     2.86%      ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>>     2.71%   reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
>>     1.52%    true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>>     1.51%   reaim  [kernel.kallsyms]  [k] queue_read_lock_slowpath
>>     1.35%   reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
>>     1.12%   reaim  [kernel.kallsyms]  [k] zap_pte_range
>>     1.06%   reaim  [kernel.kallsyms]  [k] perf_event_aux_ctx
>>     1.01%   reaim  [kernel.kallsyms]  [k] perf_event_aux
> But wouldn't kernel (4) be the one that was the most highly constrained?
>
> (That said, yes, I get that _raw_spin_lock_irqsave() is some lock that
> is unrelated to the qrwlock.)

I think the performance data is a bit off as it was collected with a 
previous version that has a minor bug in it. I will rerun the test to 
get the new data.

>
> +/**
> + * queue_write_can_lock- would write_trylock() succeed?
> + * @lock: Pointer to queue rwlock structure
> + */
> +static inline int queue_write_can_lock(struct qrwlock *lock)
> +{
> +	union qrwcnts rwcnts;
> +
> +	rwcnts.rw = ACCESS_ONCE(lock->cnts.rw);
> +	return !rwcnts.writer&&  !rwcnts.readers;
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
> +	u8 wmask;
> +
> +	cnts.rw = ACCESS_ONCE(lock->cnts.rw);
> +	wmask   = cnts.fair ? QW_MASK_FAIR : QW_MASK_UNFAIR;
> +	if (likely(!(cnts.writer&  wmask))) {
> +		cnts.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
> On an unfair lock, this can momentarily make queue_read_can_lock() give
> a false positive.  Not sure that this is a problem -- after all, the
> return value from queue_read_can_lock() is immediately obsolete anyway.

Yes, this is an issue. However, I don't this is a big deal as you said. 
Using cmpxchg may avoid this issue, but then their will be a fair chance 
of false collision among readers. So it is probably something we may 
have to live with.

>> +/**
>> + * queue_write_unlock - release write lock of a queue rwlock
>> + * @lock : Pointer to queue rwlock structure
>> + */
>> +static inline void queue_write_unlock(struct qrwlock *lock)
>> +{
>> +	/*
>> +	 * Make sure that none of the critical section will be leaked out.
>> +	 */
>> +	smp_mb__before_clear_bit();
>> +	ACCESS_ONCE(lock->cnts.writer) = 0;
>> +	smp_mb__after_clear_bit();
> How about the new smp_store_release() for this write?  Looks to me that
> smp_mb__before_clear_bit() and smp_mb__after_clear_bit() work by accident,
> if they in fact do work for all architectures.

Yes, I am thinking about updating the patch to use smp_store_release() 
once it is in. I don't want to create such a dependency for this patch 
yet. Anyway, clearing a bit looks the same as clearing a byte to me.

>> +/*
>> + * Compared with regular rwlock, the queue rwlock has has the following
>> + * advantages:
>> + * 1. It is more deterministic for the fair variant. Even though there is
>> + *    a slight chance of stealing the lock if come at the right moment, the
>> + *    granting of the lock is mostly in FIFO order. Even the default unfair
>> + *    variant is fairer at least among the writers.
>> + * 2. It is faster in high contention situation.
> Sometimes, anyway!  (Referring to your performance results on top of
> Ingo's patch.)

Will adjust the wording by adding "usually".

>
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
> This smp_wmb() desperately needs a comment.  Presumably it is ordering
> the above "prev->next = node" with some later write, but what write?
>
> Oh...  I see the header comment above.
>
> Actually, memory barriers don't necessarily make things visible sooner.
> They are instead used for ordering.  Or did you actually measure a
> performance increase with this?  (Seems -highly- unlikely given smp_wmb()'s
> definition on x86...)

I have some incorrect assumptions about memory barrier. Anyway, this 
issue will be gone once I use the MCS lock/unlock code.

>> +		/*
>> +		 * Wait until the waiting flag is off
>> +		 */
>> +		while (ACCESS_ONCE(node->wait))
>> +			cpu_relax();
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
>> +		cpu_relax();
>> +	/*
>> +	 * The next one in queue is now at the head
>> +	 */
>> +notify_next:
>> +	barrier();
>> +	ACCESS_ONCE(next->wait) = false;
>> +	smp_wmb();
> Because smp_wmb() does not order reads, reads from the critical section
> could leak out of the critical section.  A full memory barrier (smp_mb())
> seems necessary to avoid this.
>
> Yes, you do have full memory barriers implicit in various atomic operations,
> but it appears to be possible to avoid them all in some situations.

Yes, you are right.

>> +/**
>> + * queue_write_3step_lock - acquire write lock in 3 steps
>> + * @lock : Pointer to queue rwlock structure
>> + * Return: 1 if lock acquired, 0 otherwise
>> + *
>> + * Step 1 - Try to acquire the lock directly if no reader is present
>> + * Step 2 - Set the waiting flag to notify readers that a writer is waiting
>> + * Step 3 - When the readers field goes to 0, set the locked flag
>> + *
>> + * When not in fair mode, the readers actually ignore the second step.
>> + * However, this is still necessary to force other writers to fall in line.
>> + */
>> +static __always_inline int queue_write_3step_lock(struct qrwlock *lock)
>> +{
>> +	union qrwcnts old, new;
>> +
>> +	old.rw = ACCESS_ONCE(lock->cnts.rw);
>> +
>> +	/* Step 1 */
>> +	if (!old.writer&  !old.readers) {
>> +		new.rw     = old.rw;
>> +		new.writer = QW_LOCKED;
>> +		if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
>> +			return 1;
>> +	}
>> +
>> +	/* Step 2 */
>> +	if (old.writer || (cmpxchg(&lock->cnts.writer, 0, QW_WAITING) != 0))
>> +		return 0;
>> +
>> +	/* Step 3 */
>> +	while (true) {
>> +		cpu_relax();
>> +		old.rw = ACCESS_ONCE(lock->cnts.rw);
> Suppose that there now is a writer, but no readers...
>
>> +		if (!old.readers) {
>> +			new.rw     = old.rw;
>> +			new.writer = QW_LOCKED;
>> +			if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw)
>> +				== old.rw))
> ... can't this mistakenly hand out the lock to a second writer?
>
> Ah, the trick is that we are at the head of the queue, so the only writer
> we can possibly contend with is a prior holder of the lock.  Once that
> writer leaves, no other writer but can appear.  And the QW_WAITING bit
> prevents new writers from immediately grabbing the lock.

Yes, that is the point. The current has 2 queue for writers - a one 
position queue in the waiting bit and the MCS locking queue that are 
used by both readers and writers.

>> +				return 1;
>> +		}
>> +	}
>> +	/* Should never reach here */
>> +	return 0;
>> +}
>> +
>> +/**
>> + * queue_write_lock_slowpath - acquire write lock of a queue rwlock
>> + * @lock : Pointer to queue rwlock structure
>> + */
>> +void queue_write_lock_slowpath(struct qrwlock *lock)
>> +{
>> +	struct qrwnode node;
>> +
>> +	/*
>> +	 * Put the writer into the wait queue
>> +	 */
>> +	wait_in_queue(lock,&node);
>> +
>> +	/*
>> +	 * At the head of the wait queue now, call queue_write_3step_lock()
>> +	 * to acquire the lock until it is done.
>> +	 */
>> +	while (!queue_write_3step_lock(lock))
>> +		cpu_relax();
> If we get here, queue_write_3step_lock() just executed a successful
> cmpxchg(), which implies a full memory barrier.  This prevents the
> critical section from leaking out, good!
>
>> +	signal_next(lock,&node);
>> +}
>> +EXPORT_SYMBOL(queue_write_lock_slowpath);
>> -- 
>> 1.7.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Thank for the review.

-Longman
