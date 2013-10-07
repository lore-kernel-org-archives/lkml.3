Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3JGKt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:49:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60827 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab3JGKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:49:23 -0400
Date: Mon, 7 Oct 2013 12:49:00 +0200
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
Message-ID: <20131007104900.GC3081@twins.programming.kicks-ass.net>
References: <20131004184614.GA17536@redhat.com>
 <20131004184640.GA17567@redhat.com>
 <20131004192944.GU15690@laptop.programming.kicks-ass.net>
 <20131004195623.GA19436@redhat.com>
 <20131004204159.GT3081@twins.programming.kicks-ass.net>
 <20131006132240.GA21357@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006132240.GA21357@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 03:22:40PM +0200, Oleg Nesterov wrote:
> On 10/04, Peter Zijlstra wrote:
> > That would yield something like so I suppose:
> >
> > void rcu_sync_enter(struct rcu_sync_struct *rss)
> > {
> > 	bool need_wait, need_sync;
> >
> > 	spin_lock_irq(&rss->rss_lock);
> > 	if (rss->exclusive && rss->gp_count) {
> > 		__wait_event_locked(rss->gp_wait, rss->gp_count);
>                                                   ^^^^^^^^^^^^^
> I guess you meant !rss->gp_count.

Uh yes, obviously :-)

> I am obviously biased, but imho the code looks worse this way.
> I like the current simple "need_wait" and "gp_count != 0" logic.

Yeah, I know.. but it doesn't add the extra variable and doesn't play
games with the completion implementation.

> And afaics this is racy,
> 
> Yes, but if rcu_sync_exit() does __wake_up_locked(), then
> autoremove_wake_function() makes waitqueue_active() == F. If the pending
> rcu_sync_func() takes ->rss_lock first we have a problem.

Ah indeed, it seems I got confused between DECLARE_WAITQUEUE and
DEFINE_WAIT; there's too damn many variants there :/

> Easy to fix, but needs more complications.
> 
> Or we can simply ignore the fact that rcu_sync_func() can race with
> wakeup. This can lead to unnecessary sched_sync() but this case is
> unlikely. IOW,
> 
> 	spin_lock_irq(&rss->rss_lock);
> 	if (rss->exclusive)
> 		wait_event_locked(rss->gp_wait, !rss->gp_count);
> 	need_wait = rss->gp_count++;
> 	need_sync = rss->gp_state == GP_IDLE;
> 	if (need_sync)
> 		rss->gp_state = GP_PENDING;
> 	spin_unlock_irq(&rss->lock);
> 
> But still I don't like the (imho) unnecessary complications. And the
> fact we can race with rcu_sync_func() even if this is very unlikely,
> this just doesn't look good.

OK.. I'll give up trying to wreck this stuff ;-)
