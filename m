Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaBBUCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 15:02:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60712 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaBBUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 15:02:48 -0500
Date: Sun, 2 Feb 2014 21:02:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Message-ID: <20140202200223.GD5126@laptop.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
 <1390949495.2807.52.camel@j-VirtualBox>
 <20140129115142.GE9636@twins.programming.kicks-ass.net>
 <1391138977.6284.82.camel@j-VirtualBox>
 <20140131140941.GF4941@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131140941.GF4941@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 03:09:41PM +0100, Peter Zijlstra wrote:
> +struct m_spinlock {
> +	struct m_spinlock *next, *prev;
> +	int locked; /* 1 if lock acquired */
> +};
> +
> +/*
> + * Using a single mcs node per CPU is safe because mutex_lock() should not be
> + * called from interrupt context and we have preemption disabled over the mcs
> + * lock usage.
> + */
> +static DEFINE_PER_CPU(struct m_spinlock, m_node);
> +
> +static bool m_spin_lock(struct m_spinlock **lock)
> +{
> +	struct m_spinlock *node = this_cpu_ptr(&m_node);
> +	struct m_spinlock *prev, *next;
> +
> +	node->locked = 0;
> +	node->next = NULL;
> +
> +	node->prev = prev = xchg(lock, node);
> +	if (likely(prev == NULL))
> +		return true;
> +
> +	ACCESS_ONCE(prev->next) = node;
> +
> +	/*
> +	 * Normally @prev is untouchable after the above store; because at that
> +	 * moment unlock can proceed and wipe the node element from stack.
> +	 *
> +	 * However, since our nodes are static per-cpu storage, we're
> +	 * guaranteed their existence -- this allows us to apply
> +	 * cmpxchg in an attempt to undo our queueing.
> +	 */
> +
> +	while (!smp_load_acquire(&node->locked)) {
> +		if (need_resched())
> +			goto unqueue;
> +		arch_mutex_cpu_relax();
> +	}
> +	return true;
> +
> +unqueue:
> +	/*
> +	 * Step - A  -- stabilize @prev
> +	 *
> +	 * Undo our @prev->next assignment; this will make @prev's
> +	 * unlock()/cancel() wait for a next pointer since @lock points to us
> +	 * (or later).
> +	 */
> +
> +	for (;;) {
> +		next = cmpxchg(&prev->next, node, NULL); /* A -> B,C */
> +
> +		/*
> +		 * Because the unlock() path retains @prev->next (for
> +		 * performance) we must check @node->locked after clearing
> +		 * @prev->next to see if we raced.
> +		 *
> +		 * Ordered by the cmpxchg() above and the conditional-store in
> +		 * unlock().
> +		 */
> +		if (smp_load_acquire(&node->locked)) {
> +			/*
> +			 * OOPS, we were too late, we already got the lock. No
> +			 * harm done though; @prev is now unused an nobody
> +			 * cares we frobbed it.
> +			 */
> +			return true;
> +		}
> +
> +		if (next == node)
> +			break;
> +
> +		/*
> +		 * @prev->next didn't point to us anymore, we didn't own the
> +		 * lock, so reload and try again.
> +		 *
> +		 * Because we observed the new @prev->next, the smp_wmb() at
> +		 * (C) ensures that we must now observe the new @node->prev.
> +		 */
> +		prev = ACCESS_ONCE(node->prev);
> +	}
> +
> +	/*
> +	 * Step - B -- stabilize @next
> +	 *
> +	 * Similar to unlock(), wait for @node->next or move @lock from @node
> +	 * back to @prev.
> +	 */
> +
> +	for (;;) {
> +		if (*lock == node && cmpxchg(lock, node, prev) == node) {
> +			/*
> +			 * We were the last queued, we moved @lock back. @prev
> +			 * will now observe @lock and will complete its
> +			 * unlock()/cancel().
> +			 */
> +			return false;
> +		}
> +
> +		/*
> +		 * We must xchg() the @node->next value, because if we were to
> +		 * leave it in, a concurrent cancel() from @node->next might
> +		 * complete Step-A and think its @prev is still valid.
> +		 *
> +		 * If the concurrent cancel() wins the race, we'll wait for
> +		 * either @lock to point to us, through its Step-B, or wait for
> +		 * a new @node->next from its Step-C.
> +		 */
> +		next = xchg(&node->next, NULL); /* B -> A */
> +		if (next)
> +			break;
> +
> +		arch_mutex_cpu_relax();
> +	}
> +
> +	/*
> +	 * Step - C -- unlink
> +	 *
> +	 * @prev is stable because its still waiting for a new @prev->next
> +	 * pointer, @next is stable because our @node->next pointer is NULL and
> +	 * it will wait in Step-A.
> +	 */
> +
> +	ACCESS_ONCE(next->prev) = prev;
> +
> +	/*
> +	 * Ensure that @next->prev is written before we write @prev->next,
> +	 * this guarantees that when the cmpxchg at (A) fails we must
> +	 * observe the new prev value.
> +	 */
> +	smp_wmb(); /* C -> A */

OK, I've definitely stared at this code for too long :/

I don't think the above barrier is right -- or even required for that
matter. At this point I can't see anything wrong with the order of
either of these stores.

If the latter store hits first an unlock can can happen and release the
@next entry, which is fine as the Step-A loop can deal with that, if the
unlock doesn't happen, we'll simply wait for the first store to become
visible before trying to undo later again.

If the former store hits first, we'll simply wait for the later store to
appear and we'll try to undo it.

This obviously doesn't explain lockups, but it does reduce the code to
stare at ever so slightly.

> +	/*
> +	 * And point @prev to our next, and we're unlinked.
> +	 */
> +	ACCESS_ONCE(prev->next) = next;
> +
> +	return false;
> +}
> +
> +static void m_spin_unlock(struct m_spinlock **lock)
> +{
> +	struct m_spinlock *node = this_cpu_ptr(&m_node);
> +	struct m_spinlock *next;
> +
> +	for (;;) {
> +		if (likely(cmpxchg(lock, node, NULL) == node))
> +			return;
> +
> +		next = ACCESS_ONCE(node->next);
> +		if (unlikely(next))
> +			break;
> +
> +		arch_mutex_cpu_relax();
> +	}
> +	smp_store_release(&next->locked, 1);
> +}
