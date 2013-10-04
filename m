Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3JDUDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab3JDUDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:03:33 -0400
Date: Fri, 4 Oct 2013 21:56:23 +0200
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
Message-ID: <20131004195623.GA19436@redhat.com>
References: <20131004184614.GA17536@redhat.com> <20131004184640.GA17567@redhat.com> <20131004192944.GU15690@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004192944.GU15690@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> On Fri, Oct 04, 2013 at 08:46:40PM +0200, Oleg Nesterov wrote:
>
> > Note: it would be more clean to do __complete_locked() under
> > ->rss_lock in rcu_sync_exit() in the "else" branch, but we don't
> > have this trivial helper.
>
> Something equivalent in available functions would be:
>
> 	rss->gp_comp.done++;
> 	__wake_up_locked_key(&rss->gp_comp.wait, TASK_NORMAL, NULL);

Or __wake_up_locked(&rss->gp_comp.wait, TASK_NORMAL, 1).

Sure, this is what I had in mind. Just I thought that you also dislike
the idea to use/add the new helper ;) (and I think it would be better
to add the new helper even if we are not going to export it).

> >  struct rcu_sync_struct {
> >  	int			gp_state;
> >  	int			gp_count;
> > -	wait_queue_head_t	gp_wait;
> > +	struct completion	gp_comp;
> >
> >  	int			cb_state;
> >  	struct rcu_head		cb_head;
> >
> > +	bool			exclusive;
> >  	struct rcu_sync_ops	*ops;
> >  };
>
> I suppose we have a hole before or after cb_state to fit exclusive in.,
> now it looks like we're going to create another hole before the *ops
> pointer.

Yes, it probably makes sense to rearrange the members. And, for example,
gp_state and cb_state can be "char" and packed together.

> > @@ -4,7 +4,7 @@
> >  enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
> >  enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
> >
> > -#define	rss_lock	gp_wait.lock
> > +#define	rss_lock	gp_comp.wait.lock
>
> Should we, for convenience, also do:
>
> #define rss_wait	gp_comp.wait

Yes, I considered this too. OK, will do.

> >  void rcu_sync_enter(struct rcu_sync_struct *rss)
> > @@ -56,9 +58,13 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
> >  	if (need_sync) {
> >  		rss->ops->sync();
> >  		rss->gp_state = GP_PASSED;
> > -		wake_up_all(&rss->gp_wait);
> > +		if (!rss->exclusive)
> > +			wake_up_all(&rss->gp_comp.wait);
> >  	} else if (need_wait) {
> > -		wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
> > +		if (!rss->exclusive)
> > +			wait_event(rss->gp_comp.wait, rss->gp_state == GP_PASSED);
> > +		else
> > +			wait_for_completion(&rss->gp_comp);
>
> I'm still not entirely sure why we need the completion; we already have
> the gp_count variable and a waitqueue;

and we also need the resource counter (like completion->done).

> together those should be able to
> implement the condition/semaphore variable, no?
>
> wait_for_completion:
>
> 	spin_lock_irq(&rss->rss_lock);
> 	if (rss->gp_count > 0) {
> 		__wait_event_locked(rss->gp_wait, (rss->gp_count > 0),

How? I do not even understand what did you mean ;) both conditions
are "gp_count > 0".

We simply can not define the CONDITION for wait_event() here, without
the additional accounting.

Hmm. perhaps you meant that this should be done before rcu_sync_enter()
increments ->gp_count. Perhaps this can work, but the code will be more
complex and this way rcu_sync_exit() will always schedule the callback?
And again, we do want to increment ->gp_count asap to disable this cb
if it is already pending.

Oleg.

