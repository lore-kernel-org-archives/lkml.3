Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaHAPGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:06:11 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64003 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAPGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:06:10 -0400
Date: Fri, 1 Aug 2014 17:06:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140801150601.GC13134@localhost.localdomain>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140731235748.GA13134@localhost.localdomain>
 <20140801020416.GI11241@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801020416.GI11241@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 07:04:16PM -0700, Paul E. McKenney wrote:
> On Fri, Aug 01, 2014 at 01:57:50AM +0200, Frederic Weisbecker wrote:
> > 
> > So this thread is going to poll every second? I guess something prevents it
> > to run when system is idle somewhere? But I'm not familiar with the whole patchset
> > yet. But even without that it looks like a very annoying noise. why not use something
> > wait/wakeup based?
> 
> And a later patch does the wait/wakeup thing.  Start stupid, add small
> amounts of sophistication incrementally.

Aah indeed! :)

> 
> > > +			flush_signals(current);
> > > +			continue;
> > > +		}
> > > +
> > > +		/*
> > > +		 * Wait for all pre-existing t->on_rq and t->nvcsw
> > > +		 * transitions to complete.  Invoking synchronize_sched()
> > > +		 * suffices because all these transitions occur with
> > > +		 * interrupts disabled.  Without this synchronize_sched(),
> > > +		 * a read-side critical section that started before the
> > > +		 * grace period might be incorrectly seen as having started
> > > +		 * after the grace period.
> > > +		 *
> > > +		 * This synchronize_sched() also dispenses with the
> > > +		 * need for a memory barrier on the first store to
> > > +		 * ->rcu_tasks_holdout, as it forces the store to happen
> > > +		 * after the beginning of the grace period.
> > > +		 */
> > > +		synchronize_sched();
> > > +
> > > +		/*
> > > +		 * There were callbacks, so we need to wait for an
> > > +		 * RCU-tasks grace period.  Start off by scanning
> > > +		 * the task list for tasks that are not already
> > > +		 * voluntarily blocked.  Mark these tasks and make
> > > +		 * a list of them in rcu_tasks_holdouts.
> > > +		 */
> > > +		rcu_read_lock();
> > > +		for_each_process_thread(g, t) {
> > > +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> > > +			    !is_idle_task(t)) {
> > > +				get_task_struct(t);
> > > +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> > > +				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
> > > +				list_add(&t->rcu_tasks_holdout_list,
> > > +					 &rcu_tasks_holdouts);
> > > +			}
> > > +		}
> > > +		rcu_read_unlock();
> > > +
> > > +		/*
> > > +		 * Each pass through the following loop scans the list
> > > +		 * of holdout tasks, removing any that are no longer
> > > +		 * holdouts.  When the list is empty, we are done.
> > > +		 */
> > > +		while (!list_empty(&rcu_tasks_holdouts)) {
> > > +			schedule_timeout_interruptible(HZ / 10);
> > 
> > OTOH here it is not annoying because it should only happen when rcu task
> > is used, which should be rare.
> 
> Glad you like it!
> 
> I will likely also add checks for other things needing the current CPU.

Ok, thanks!
