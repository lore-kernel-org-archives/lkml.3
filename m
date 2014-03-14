Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaCNUro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:47:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39498 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbaCNUrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:47:42 -0400
Date: Fri, 14 Mar 2014 13:47:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140314204736.GG21124@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314095033.GP27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031420-0928-0000-0000-000000798F3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:50:33AM +0100, Peter Zijlstra wrote:
> On Thu, Mar 13, 2014 at 12:58:16PM -0700, Paul E. McKenney wrote:
> > On Fri, Mar 07, 2014 at 03:38:46PM +0200, Alexander Shishkin wrote:
> > > This is more of a problem description than an actual bugfix, but currently
> > > ring_buffer_detach() can kick in while ring_buffer_wakeup() is traversing
> > > the ring buffer's event list, leading to cpu stalls.
> > > 
> > > What this patch does is crude, but fixes the problem, which is: one rcu
> > > grace period has to elapse between ring_buffer_detach() and subsequent
> > > ring_buffer_attach(), otherwise either the attach will fail or the wakeup
> > > will misbehave. Also, making it a call_rcu() callback will make it race
> > > with attach().
> > > 
> > > Another solution that I see is to check for list_empty(&event->rb_entry)
> > > before wake_up_all() in ring_buffer_wakeup() and restart the list
> > > traversal if it is indeed empty, but that is ugly too as there will be
> > > extra wakeups on some events.
> > > 
> > > Anything that I'm missing here? Any better ideas?
> > 
> > Not sure it qualifies as "better", but git call to ring_buffer_detach()
> > is going to free the event anyway, so the synchronize_rcu() and the
> > INIT_LIST_HEAD() should not be needed in that case.  I am guessing that
> > the same is true for perf_mmap_close().
> > 
> > So that leaves the call in perf_event_set_output(), which detaches from an
> > old rb before attaching that same event to a new one.  So maybe have the
> > synchronize_rcu() and INIT_LIST_HEAD() instead be in the "if (old_rb)",
> > which might be a reasonably uncommon case?
> 
> How about something like so that only does the sync_rcu() if really
> needed.

This general idea can be made to work, but it will need some
internal-to-RCU help.  One vulnerability of the patch below is the
following sequence of steps:

1.	RCU has just finished a grace period, and is doing the
	end-of-grace-period accounting.

2.	The code below invokes rcu_batches_completed().  Let's assume
	the result returned is 42.

3.	RCU completes the end-of-grace-period accounting, and increments
	rcu_sched_state.completed.

4.	The code below checks ->rcu_batches against the result from
	another invocation of rcu_batches_completed() and sees that
	the 43 is not equal to 42, so skips the synchronize_rcu().

Except that a grace period has not actually completed.  Boom!!!

The problem is that rcu_batches_completed() is only intended to give
progress information on RCU.

What I can do is give you a pair of functions, one to take a snapshot of
the current grace-period state (returning an unsigned long) and another
to evaluate a previous snapshot, invoking synchronize_rcu() if there has
not been a full grace period in the meantime.

The most straightforward approach would invoke acquiring the global
rcu_state ->lock on each call, which I am guessing just might be
considered to be excessive overhead.  ;-)  I should be able to decrease
the overhead to a memory barrier on each call, and perhaps even down
to an smp_load_acquire().  Accessing the RCU state probably costs you
a cache miss both times.

Thoughts?

							Thanx, Paul

> ---
>  kernel/events/core.c     | 11 +++++++++--
>  kernel/events/internal.h |  1 +
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 661951ab8ae7..88c8c810e081 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3856,12 +3856,17 @@ static void ring_buffer_attach(struct perf_event *event,
>  {
>  	unsigned long flags;
> 
> +	if (rb->rcu_batches == rcu_batches_completed()) {
> +		synchronize_rcu();
> +		INIT_LIST_HEAD(&event->rb_entry);
> +	}
> +
>  	if (!list_empty(&event->rb_entry))
>  		return;
> 
>  	spin_lock_irqsave(&rb->event_lock, flags);
>  	if (list_empty(&event->rb_entry))
> -		list_add(&event->rb_entry, &rb->event_list);
> +		list_add_rcu(&event->rb_entry, &rb->event_list);
>  	spin_unlock_irqrestore(&rb->event_lock, flags);
>  }
> 
> @@ -3873,9 +3878,11 @@ static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
>  		return;
> 
>  	spin_lock_irqsave(&rb->event_lock, flags);
> -	list_del_init(&event->rb_entry);
> +	list_del_rcu(&event->rb_entry);
>  	wake_up_all(&event->waitq);
>  	spin_unlock_irqrestore(&rb->event_lock, flags);
> +
> +	rb->rcu_batches = rcu_batches_completed();
>  }
> 
>  static void ring_buffer_wakeup(struct perf_event *event)
> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> index 569b218782ad..698b5881b2a4 100644
> --- a/kernel/events/internal.h
> +++ b/kernel/events/internal.h
> @@ -30,6 +30,7 @@ struct ring_buffer {
>  	/* poll crap */
>  	spinlock_t			event_lock;
>  	struct list_head		event_list;
> +	unsigned long			rcu_batches;
> 
>  	atomic_t			mmap_count;
>  	unsigned long			mmap_locked;
> 

