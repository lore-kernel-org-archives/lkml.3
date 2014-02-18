Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaBRHkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 02:40:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36511 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaBRHkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 02:40:10 -0500
Date: Tue, 18 Feb 2014 08:39:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 1/3] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20140218073951.GZ27965@twins.programming.kicks-ass.net>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
 <1392669684-4807-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392669684-4807-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 03:41:22PM -0500, Waiman Long wrote:
> +void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval)
> +{
> +	unsigned int cpu_nr, qn_idx;
> +	struct qnode *node, *next;
> +	u32 prev_qcode, my_qcode;
> +
> +#ifdef queue_spin_trylock_quick
> +	/*
> +	 * Try the quick spinning code path
> +	 */
> +	if (queue_spin_trylock_quick(lock, qsval))
> +		return;
> +#endif

why oh why?

> +	/*
> +	 * Get the queue node
> +	 */
> +	cpu_nr = smp_processor_id();
> +	node   = get_qnode(&qn_idx);
> +
> +	if (unlikely(!node)) {
> +		/*
> +		 * This shouldn't happen, print a warning message
> +		 * & busy spinning on the lock.
> +		 */
> +		printk_sched(
> +		  "qspinlock: queue node table exhausted at cpu %d!\n",
> +		  cpu_nr);
> +		while (!queue_spin_trylock_unfair(lock))
> +			arch_mutex_cpu_relax();
> +		return;
> +	}
> +
> +	/*
> +	 * Set up the new cpu code to be exchanged
> +	 */
> +	my_qcode = _SET_QCODE(cpu_nr, qn_idx);
> +
> +	/*
> +	 * Initialize the queue node
> +	 */
> +	node->wait = true;
> +	node->next = NULL;
> +
> +	/*
> +	 * The lock may be available at this point, try again if no task was
> +	 * waiting in the queue.
> +	 */
> +	if (!(qsval >> _QCODE_OFFSET) && queue_spin_trylock(lock)) {
> +		put_qnode();
> +		return;
> +	}
> +
> +#ifdef queue_code_xchg
> +	prev_qcode = queue_code_xchg(lock, my_qcode);
> +#else
> +	/*
> +	 * Exchange current copy of the queue node code
> +	 */
> +	prev_qcode = atomic_xchg(&lock->qlcode, my_qcode);
> +	/*
> +	 * It is possible that we may accidentally steal the lock. If this is
> +	 * the case, we need to either release it if not the head of the queue
> +	 * or get the lock and be done with it.
> +	 */
> +	if (unlikely(!(prev_qcode & _QSPINLOCK_LOCKED))) {
> +		if (prev_qcode == 0) {
> +			/*
> +			 * Got the lock since it is at the head of the queue
> +			 * Now try to atomically clear the queue code.
> +			 */
> +			if (atomic_cmpxchg(&lock->qlcode, my_qcode,
> +					  _QSPINLOCK_LOCKED) == my_qcode)
> +				goto release_node;
> +			/*
> +			 * The cmpxchg fails only if one or more tasks
> +			 * are added to the queue. In this case, we need to
> +			 * notify the next one to be the head of the queue.
> +			 */
> +			goto notify_next;
> +		}
> +		/*
> +		 * Accidentally steal the lock, release the lock and
> +		 * let the queue head get it.
> +		 */
> +		queue_spin_unlock(lock);
> +	} else
> +		prev_qcode &= ~_QSPINLOCK_LOCKED;	/* Clear the lock bit */
> +	my_qcode &= ~_QSPINLOCK_LOCKED;
> +#endif /* queue_code_xchg */

WTF is this #ifdef for?

> +	if (prev_qcode) {
> +		/*
> +		 * Not at the queue head, get the address of the previous node
> +		 * and set up the "next" fields of the that node.
> +		 */
> +		struct qnode *prev = xlate_qcode(prev_qcode);
> +
> +		ACCESS_ONCE(prev->next) = node;
> +		/*
> +		 * Wait until the waiting flag is off
> +		 */
> +		while (smp_load_acquire(&node->wait))
> +			arch_mutex_cpu_relax();
> +	}
> +
> +	/*
> +	 * At the head of the wait queue now
> +	 */
> +	while (true) {
> +		u32 qcode;
> +		int retval;
> +
> +		retval = queue_get_lock_qcode(lock, &qcode, my_qcode);
> +		if (retval > 0)
> +			;	/* Lock not available yet */
> +		else if (retval < 0)
> +			/* Lock taken, can release the node & return */
> +			goto release_node;
> +		else if (qcode != my_qcode) {
> +			/*
> +			 * Just get the lock with other spinners waiting
> +			 * in the queue.
> +			 */
> +			if (queue_spin_trylock_unfair(lock))
> +				goto notify_next;

Why is this an option at all?

> +		} else {
> +			/*
> +			 * Get the lock & clear the queue code simultaneously
> +			 */
> +			if (queue_spin_trylock_and_clr_qcode(lock, qcode))
> +				/* No need to notify the next one */
> +				goto release_node;
> +		}
> +		arch_mutex_cpu_relax();
> +	}
> +
> +notify_next:
> +	/*
> +	 * Wait, if needed, until the next one in queue set up the next field
> +	 */
> +	while (!(next = ACCESS_ONCE(node->next)))
> +		arch_mutex_cpu_relax();
> +	/*
> +	 * The next one in queue is now at the head
> +	 */
> +	smp_store_release(&next->wait, false);
> +
> +release_node:
> +	put_qnode();
> +}
> +EXPORT_SYMBOL(queue_spin_lock_slowpath);
> -- 
> 1.7.1
> 
