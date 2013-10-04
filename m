Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3JDUm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:42:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55434 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3JDUm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:42:26 -0400
Date: Fri, 4 Oct 2013 22:41:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] rcusync: introduce rcu_sync_struct->exclusive mode
Message-ID: <20131004204159.GT3081@twins.programming.kicks-ass.net>
References: <20131004184614.GA17536@redhat.com>
 <20131004184640.GA17567@redhat.com>
 <20131004192944.GU15690@laptop.programming.kicks-ass.net>
 <20131004195623.GA19436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004195623.GA19436@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 09:56:23PM +0200, Oleg Nesterov wrote:

> Hmm. perhaps you meant that this should be done before rcu_sync_enter()
> increments ->gp_count. Perhaps this can work, but the code will be more
> complex and this way rcu_sync_exit() will always schedule the callback?

Yah, however see below.

> And again, we do want to increment ->gp_count asap to disable this cb
> if it is already pending.

Ah indeed, I forgot about that. We'd have to wait until we'd get
scheduled to increment gp_count again. However I think we can fix this
and the above problem by introduction of rcu_sync_busy() which checks
for eiter gp_count or pending waiters.

But yes, slightly more complex code :/

That would yield something like so I suppose:

void rcu_sync_enter(struct rcu_sync_struct *rss)
{
	bool need_wait, need_sync;

	spin_lock_irq(&rss->rss_lock);
	if (rss->exclusive && rss->gp_count) {
		__wait_event_locked(rss->gp_wait, rss->gp_count);
		rss->gp_count++;
		need_wait = need_sync = false;
	} else {
		need_wait = rss->gp_count++;
		need_sync = rss->gp_state == GP_IDLE;
		if (need_sync)
			rss->gp_state = GP_PENDING;
	}
	spin_unlock_irq(&rss->lock);

	if (need_sync) {
		rss->sync();
		rss->gp_state = GP_PASSED;
		wake_up_all(&rss->gp_wait);
	} else if (need_wait) {
		wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
	} else {
		BUG_ON(rss->gp_state != GP_PASSED);
	}
}

static bool rcu_sync_busy(struct rcu_sync_struct *rss)
{
	return rss->gp_count ||
		(rss->exclusive && waitqueue_active(&rss->gp_wait));
}

static void rcu_sync_func(struct rcu_head *rcu)
{
	struct rcu_sync_struct *rss =
		container_of(rcu, struct rcu_sync_struct, cb_head);
	unsigned long flags;

	BUG_ON(rss->gp_state != GP_PASSED);
	BUG_ON(rss->cb_state == CB_IDLE);

	spin_lock_irqsave(&rss->rss_lock, flags);
	if (rcu_sync_busy(rss)) {
		/*
		 * A new rcu_sync_begin() has happened; drop the callback.
		 */
		rss->cb_state = CB_IDLE;
	} else if (rss->cb_state == CB_REPLAY) {
		/*
		 * A new rcu_sync_exit() has happened; requeue the callback
		 * to catch a later GP.
		 */
		rss->cb_state = CB_PENDING;
		rss->call(&rss->cb_head, rcu_sync_func);
	} else {
		/*
		 * We're at least a GP after rcu_sync_exit(); eveybody will now
		 * have observed the write side critical section. Let 'em rip!.
		 */
		rss->cb_state = CB_IDLE;
		rss->gp_state = GP_IDLE;
	}
	spin_unlock_irqrestore(&rss->rss_lock, flags);
}

void rcu_sync_exit(struct rcu_sync_struct *rss)
{
	spin_lock_irq(&rss->rss_lock);
	if (!--rss->gp_count) {
		if (!rcu_sync_busy(rss)) {
			if (rss->cb_state == CB_IDLE) {
				rss->cb_state = CB_PENDING;
				rss->call(&rss->cb_head, rcu_sync_func);
			} else if (rss->cb_state == CB_PENDING) {
				rss->cb_state = CB_REPLAY;
			}
		} else {
			__wake_up_locked(&rss->gp_wait, TASK_NORMAL, 1);
		}
	}
	spin_unlock_irq(&rss->rss_lock);
}
