Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab3KXFPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 00:15:41 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16446 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3KXFPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 00:15:39 -0500
Message-ID: <1385270135.5402.43.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>, "Norton, Scott J" <scott.norton@hp.com>,
        tom.vaden@hp.com, "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 23 Nov 2013 21:15:35 -0800
In-Reply-To: <CA+55aFwzRqPHKp67EhJ9hsX4v5=p3uQxvnaVZko2ZXDf6CQAPQ@mail.gmail.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
	 <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
	 <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
	 <CA+55aFwzRqPHKp67EhJ9hsX4v5=p3uQxvnaVZko2ZXDf6CQAPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-23 at 19:46 -0800, Linus Torvalds wrote:
> On Sat, Nov 23, 2013 at 5:16 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Now the question is why we queue the waiter _AFTER_ reading the user
> > space value. The comment in the code is pretty non sensical:
> >
> >    * On the other hand, we insert q and release the hash-bucket only
> >    * after testing *uaddr.  This guarantees that futex_wait() will NOT
> >    * absorb a wakeup if *uaddr does not match the desired values
> >    * while the syscall executes.
> >
> > There is no reason why we cannot queue _BEFORE_ reading the user space
> > value. We just have to dequeue in all the error handling cases, but
> > for the fast path it does not matter at all.
> >
> > CPU 0                                   CPU 1
> >
> >     val = *futex;
> >     futex_wait(futex, val);
> >
> >     spin_lock(&hb->lock);
> >
> >     plist_add(hb, self);
> >     smp_wmb();
> >
> >     uval = *futex;
> >                                         *futex = newval;
> >                                         futex_wake();
> >
> >                                         smp_rmb();
> >                                         if (plist_empty(hb))
> >                                            return;
> > ...
> 
> This would seem to be a nicer approach indeed, without needing the
> extra atomics.

Yep, I think we can all agree that doing this optization without atomic
ops is a big plus.

> 
> Davidlohr, mind trying Thomas' approach?

I just took a quick look and it seems pretty straightforward, but not
without some details to consider. We basically have to redo/reorder
futex_wait_setup(), which checks that uval == val, and
futex_wait_queue_me(), which adds the task to the list and blocks. Now,
both futex_wait() and futex_wait_requeue_pi() have this logic, but since
we don't use futex_wake() to wakeup tasks on pi futex_qs, I believe it's
ok to only change futex_wait(), while the order of the uval checking
doesn't matter for futex_wait_requeue_pi() so it can stay as is.

The following is the general skeleton of what Thomas is probably
referring to (yes, it needs comments, cleanups, refactoring, etc, etc).
Futexes are easy to screw up but at least this passes a kernel build and
all futextests on a large box.

static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
		      ktime_t *abs_time, u32 bitset)
{
	struct hrtimer_sleeper timeout, *to = NULL;
	struct restart_block *restart;
	struct futex_hash_bucket *hb;
	struct futex_q q = futex_q_init;
	int prio, ret = 0;
	u32 uval;

	if (!bitset)
		return -EINVAL;
	q.bitset = bitset;

	if (abs_time) {
		to = &timeout;

		hrtimer_init_on_stack(&to->timer, (flags & FLAGS_CLOCKRT) ?
				      CLOCK_REALTIME : CLOCK_MONOTONIC,
				      HRTIMER_MODE_ABS);
		hrtimer_init_sleeper(to, current);
		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
					     current->timer_slack_ns);
	}
retry:	
	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key, VERIFY_READ);
	if (unlikely(ret != 0))
		goto out;

retry_private:
	hb = queue_lock(&q);
	prio = min(current->normal_prio, MAX_RT_PRIO);

	plist_node_init(&q.list, prio);
	plist_add(&q.list, &hb->chain);
	q.task = current;
	/* do NOT drop the lock here */
	smp_wmb();

	ret = get_futex_value_locked(&uval, uaddr);
	if (ret) {
		plist_del(&q.list, &hb->chain);
		spin_unlock(&hb->lock);
		
		ret = get_user(uval, uaddr);
		if (ret)
			goto out_put_key;

		if (!(flags & FLAGS_SHARED))
			goto retry_private;

		put_futex_key(&q.key);
		goto retry;

	}

	if (uval != val) {
		plist_del(&q.list, &hb->chain);
		spin_unlock(&hb->lock);
		ret = -EWOULDBLOCK;
		goto out_put_key;
	}

	set_current_state(TASK_INTERRUPTIBLE);
	spin_unlock(&hb->lock);

	/* Arm the timer */
	if (to) {
		hrtimer_start_expires(&to->timer, HRTIMER_MODE_ABS);
		if (!hrtimer_active(&to->timer))
			to->task = NULL;
	}

	/*
	 * If we have been removed from the hash list, then another task
	 * has tried to wake us, and we can skip the call to schedule().
	 */
	if (likely(!plist_node_empty(&q.list))) {
		/*
		 * If the timer has already expired, current will already be
		 * flagged for rescheduling. Only call schedule if there
		 * is no timeout, or if it has yet to expire.
		 */
		if (!to || to->task)
			freezable_schedule();
	}
	__set_current_state(TASK_RUNNING);


	/* If we were woken (and unqueued), we succeeded, whatever. */
	ret = 0;
	/* unqueue_me() drops q.key ref */
	if (!unqueue_me(&q))
		goto out;
	ret = -ETIMEDOUT;
	if (to && !to->task)
		goto out;

	/*
	 * We expect signal_pending(current), but we might be the
	 * victim of a spurious wakeup as well.
	 */
	if (!signal_pending(current))
		goto retry;

	ret = -ERESTARTSYS;
	if (!abs_time)
		goto out;

	restart = &current_thread_info()->restart_block;
	restart->fn = futex_wait_restart;
	restart->futex.uaddr = uaddr;
	restart->futex.val = val;
	restart->futex.time = abs_time->tv64;
	restart->futex.bitset = bitset;
	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;

	ret = -ERESTART_RESTARTBLOCK;

out_put_key:
	if (ret)
		put_futex_key(&q.key);
out:
	if (to) {
		hrtimer_cancel(&to->timer);
		destroy_hrtimer_on_stack(&to->timer);
	}
	return ret;
}

Thanks,
Davidlohr

