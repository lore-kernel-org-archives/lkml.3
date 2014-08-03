Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaHCNAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 09:00:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaHCNAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 09:00:46 -0400
Date: Sun, 3 Aug 2014 14:57:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140803125758.GA671@redhat.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140801141144.GA30293@redhat.com> <20140801182837.GI4784@linux.vnet.ibm.com> <20140801184059.GB10718@redhat.com> <20140802230020.GD8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140802230020.GD8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Paul E. McKenney wrote:
>
> On Fri, Aug 01, 2014 at 08:40:59PM +0200, Oleg Nesterov wrote:
> > On 08/01, Paul E. McKenney wrote:
> > >
> > > On Fri, Aug 01, 2014 at 04:11:44PM +0200, Oleg Nesterov wrote:
> > > > Not sure this makes any sense, but perhaps we can check for the new
> > > > callbacks and start the next gp. IOW, the main loop roughly does
> > > >
> > > > 	for (;;) {
> > > > 		list = rcu_tasks_cbs_head;
> > > > 		rcu_tasks_cbs_head = NULL;
> > > >
> > > > 		if (!list)
> > > > 			sleep();
> > > >
> > > > 		synchronize_sched();
> > > >
> > > > 		wait_for_rcu_tasks_holdout();
> > > >
> > > > 		synchronize_sched();
> > > >
> > > > 		process_callbacks(list);
> > > > 	}
> > > >
> > > > we can "join" 2 synchronize_sched's and do
> > > >
> > > > 	ready_list = NULL;
> > > > 	for (;;) {
> > > > 		list = rcu_tasks_cbs_head;
> > > > 		rcu_tasks_cbs_head = NULL;
> > > >
> > > > 		if (!list && !ready_list)
> > > > 			sleep();
> > > >
> > > > 		synchronize_sched();
> > > >
> > > > 		if (ready_list) {
> > > > 			process_callbacks(ready_list);
> > > > 			ready_list = NULL;
> > > > 		}
> > > >
> > > > 		if (!list)
> > > > 			continue;
> > > >
> > > > 		wait_for_rcu_tasks_holdout();
> > > > 		ready_list = list;
> > > > 	}
> > >
> > > The lack of barriers for the updates I am checking mean that I really
> > > do need a synchronize_sched() on either side of the grace-period wait.
> >
> > Yes,
> >
> > > The grace period needs to guarantee that anything that happened on any
> > > CPU before the start of the grace period happens before anything that
> > > happens on any CPU after the end of the grace period.  If I leave off
> > > either synchronize_sched(), we lose this guarantee.
> >
> > But the 2nd variant still has synchronize_sched() on both sides?
>
> Your second variant above?  Unless it is in wait_for_rcu_tasks_holdouts(),
> I am not seeing it.

I guess I probably misunderstood you from the very beginning. And now I am
curious what exactly I missed...

The code above doesn't do process_callbacks() after wait_for_rcu_tasks_holdout(),
it does this only after another synchronize_sched(). The only difference is that
we dequeue the next generation of the pending rcu_tasks_cbs_head callbacks.

IOW. Lets look at the current code. Suppose that synchronize_rcu_tasks() is
called when rcu_tasks_kthread() sleeps in wait_for_rcu_tasks_holdout(). In
this case the new wakeme_after_rcu callback will sit in rcu_tasks_cbs_head
until rcu_tasks_kthread() does the 2nd synchronize_sched() + process_callbacks().
Only after that it will be dequeued and rcu_tasks_kthread() will start another gp.

This means that we have 3 synchronize_sched()'s before synchronize_rcu_tasks()
returns.

Do we really need this? With the 2nd variant the new callback will be dequeud
right after wait_for_rcu_tasks_holdout(), and we only have 2 necessary
synchronize_sched()'s around wait_for_rcu_tasks_holdout().

But it seems that I missed something else. Could you please spell?

Oleg.

