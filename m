Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaEHPhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:37:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60496 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbaEHPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:37:32 -0400
Date: Thu, 8 May 2014 08:37:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140508153727.GD8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140507123526.GD13658@twins.programming.kicks-ass.net>
 <20140507180621.GE13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507180621.GE13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050815-0928-0000-0000-000001CBA8D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 08:06:21PM +0200, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 02:35:26PM +0200, Peter Zijlstra wrote:
> >  static void ring_buffer_attach(struct perf_event *event,
> >  			       struct ring_buffer *rb)
> >  {
> > +	struct ring_buffer *old_rb = NULL;
> >  	unsigned long flags;
> >  
> > +	if (event->rb) {
> > +		/*
> > +		 * Should be impossible, we set this when removing
> > +		 * event->rb_entry and wait/clear when adding event->rb_entry.
> > +		 */
> > +		WARN_ON_ONCE(event->rcu_pending);
> >  
> > +		old_rb = event->rb;
> > +		event->rcu_batches = get_state_synchronize_rcu();
> > +		event->rcu_pending = 1;
> >  
> > +		spin_lock_irqsave(&rb->event_lock, flags);
> > +		list_del_rcu(&event->rb_entry);
> > +		spin_unlock_irqrestore(&rb->event_lock, flags);
> 
> This all works a whole lot better if you make that old_rb->event_lock.
> 
> > +	}
> >  
> > +	if (event->rcu_pending && rb) {
> > +		cond_synchronize_rcu(event->rcu_batches);

There is not a whole lot of code between the get_state_synchronize_rcu()
and the cond_synchronize_rcu(), so I would expect this to do a
synchronize_rcu() almost all the time.  Or am I missing something here?

							Thanx, Paul

> > +		event->rcu_pending = 0;
> > +	}
> >  
> > +	if (rb) {
> > +		spin_lock_irqsave(&rb->event_lock, flags);
> > +		list_add_rcu(&event->rb_entry, &rb->event_list);
> > +		spin_unlock_irqrestore(&rb->event_lock, flags);
> > +	}
> > +
> > +	rcu_assign_pointer(event->rb, rb);
> > +
> > +	if (old_rb) {
> > +		ring_buffer_put(old_rb);
> > +		/*
> > +		 * Since we detached before setting the new rb, so that we
> > +		 * could attach the new rb, we could have missed a wakeup.
> > +		 * Provide it now.
> > +		 */
> > +		wake_up_all(&event->waitq);
> > +	}
> >  }


