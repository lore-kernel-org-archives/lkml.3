Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3JCQmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:42:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49013 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3JCQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:42:12 -0400
Date: Thu, 3 Oct 2013 09:42:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131003164205.GE5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131002145655.361606532@infradead.org>
 <20131002150518.675931976@infradead.org>
 <20131002154901.GA13389@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002154901.GA13389@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100316-1344-0000-0000-00000222241E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 05:49:01PM +0200, Oleg Nesterov wrote:
> On 10/02, Peter Zijlstra wrote:
> >
> > From: Oleg Nesterov <oleg@redhat.com>
> 
> Thanks! I was writing the patch, and I chose almost the same naming ;)
> 
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> In fact I'd like to add my sob to 1/3 and 3/3 as well.
> 
> 
> Paul, to remind, this is only the first step. I am going to send
> the following improvements:
> 
> 	1. Add rcu_sync->exlusive. The change is simple, just we
> 	   need s/wait_queue_head_t/completion/ in rcu_sync_struct
> 	   and a couple of "if (rss->exclusive)" checks in enter/exit.
> 
> 	2. rcu_sync_enter() should return !!need_sync. This can help
> 	   in exclusive mode.
> 
> 	3. rcu_sync_struct needs more function pointers (perhaps we
> 	   should add a single rcu_sync_struct->ops pointer but this
> 	   is minor). See below.
> 
> But let me repeat just in case, we should do this later.
> And once this series is applied, I'll change percpu_rw_semaphore.

I took this into account in my review, the upgrades would be good!  ;-)

							Thanx, Paul

> > +struct rcu_sync_struct {
> > +	int			gp_state;
> > +	int			gp_count;
> > +	wait_queue_head_t	gp_wait;
> > +
> > +	int			cb_state;
> > +	struct rcu_head		cb_head;
> > +
> > +	void (*sync)(void);
> > +	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> 
> Yes, and we also need rcu_sync_struct->barrier(). From the patch I was
> working on:
> 
> 	void rcu_sync_wait_for_callback(struct rcu_sync *sync)
> 	{
> 		int cb_state;
> 
> 		BUG_ON(sync->gp_count);
> 
> 		spin_lock_irq(&sync->state_lock);
> 		if (sync->cb_state == CB_REPLAY)
> 			sync->cb_state = CB_PENDING;
> 		cb_state = sync->cb_state;
> 		spin_unlock_irq(&sync->state_lock);
> 
> 		if (cb_state != CB_IDLE) {
> 			rcu_barrier_sched();
> 			BUG_ON(sync->cb_state != CB_IDLE);
> 		}
> 	}
> 
> It should be called if you are going to kfree the object.
> 
> Perhaps another rcu_sync_struct->state_change(new_state) callback (set
> by the user) makes sense too, this can help (for example) to implement
> the array of semaphores with a single rcu_sync_struct (freeze_super).
> 
> Thanks.
> 
> Oleg.
> 

