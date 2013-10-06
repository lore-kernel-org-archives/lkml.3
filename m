Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3JFN35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 09:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3JFN34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 09:29:56 -0400
Date: Sun, 6 Oct 2013 15:22:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20131006132240.GA21357@redhat.com>
References: <20131004184614.GA17536@redhat.com> <20131004184640.GA17567@redhat.com> <20131004192944.GU15690@laptop.programming.kicks-ass.net> <20131004195623.GA19436@redhat.com> <20131004204159.GT3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004204159.GT3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> On Fri, Oct 04, 2013 at 09:56:23PM +0200, Oleg Nesterov wrote:
>
> But yes, slightly more complex code :/

Yes. rcu_sync_busy() adds more obscurity and we need to implement
the logic which wait_for_completion already does.

> That would yield something like so I suppose:
>
> void rcu_sync_enter(struct rcu_sync_struct *rss)
> {
> 	bool need_wait, need_sync;
>
> 	spin_lock_irq(&rss->rss_lock);
> 	if (rss->exclusive && rss->gp_count) {
> 		__wait_event_locked(rss->gp_wait, rss->gp_count);
                                                  ^^^^^^^^^^^^^
I guess you meant !rss->gp_count.

> 		rss->gp_count++;
> 		need_wait = need_sync = false;
> 	} else {
> 		need_wait = rss->gp_count++;
> 		need_sync = rss->gp_state == GP_IDLE;
> 		if (need_sync)
> 			rss->gp_state = GP_PENDING;
> 	}
> 	spin_unlock_irq(&rss->lock);
>
> 	if (need_sync) {
> 		rss->sync();
> 		rss->gp_state = GP_PASSED;
> 		wake_up_all(&rss->gp_wait);
> 	} else if (need_wait) {
> 		wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
> 	} else {
> 		BUG_ON(rss->gp_state != GP_PASSED);
> 	}
> }

I am obviously biased, but imho the code looks worse this way.
I like the current simple "need_wait" and "gp_count != 0" logic.

And afaics this is racy,

> static bool rcu_sync_busy(struct rcu_sync_struct *rss)
> {
> 	return rss->gp_count ||
> 		(rss->exclusive && waitqueue_active(&rss->gp_wait));
> }
>
> static void rcu_sync_func(struct rcu_head *rcu)
> {
> 	struct rcu_sync_struct *rss =
> 		container_of(rcu, struct rcu_sync_struct, cb_head);
> 	unsigned long flags;
>
> 	BUG_ON(rss->gp_state != GP_PASSED);
> 	BUG_ON(rss->cb_state == CB_IDLE);
>
> 	spin_lock_irqsave(&rss->rss_lock, flags);
> 	if (rcu_sync_busy(rss)) {
> 		/*
> 		 * A new rcu_sync_begin() has happened; drop the callback.
> 		 */
> 		rss->cb_state = CB_IDLE;

Yes, but if rcu_sync_exit() does __wake_up_locked(), then
autoremove_wake_function() makes waitqueue_active() == F. If the pending
rcu_sync_func() takes ->rss_lock first we have a problem.

Easy to fix, but needs more complications.

Or we can simply ignore the fact that rcu_sync_func() can race with
wakeup. This can lead to unnecessary sched_sync() but this case is
unlikely. IOW,

	spin_lock_irq(&rss->rss_lock);
	if (rss->exclusive)
		wait_event_locked(rss->gp_wait, !rss->gp_count);
	need_wait = rss->gp_count++;
	need_sync = rss->gp_state == GP_IDLE;
	if (need_sync)
		rss->gp_state = GP_PENDING;
	spin_unlock_irq(&rss->lock);

But still I don't like the (imho) unnecessary complications. And the
fact we can race with rcu_sync_func() even if this is very unlikely,
this just doesn't look good.

Oleg.

