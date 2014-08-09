Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaHIQBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 12:01:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37692 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaHIQBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 12:01:44 -0400
Date: Sat, 9 Aug 2014 09:01:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140809160137.GJ5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809061514.GK9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080916-6688-0000-0000-000003E341C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 08:15:14AM +0200, Peter Zijlstra wrote:
> On Fri, Aug 08, 2014 at 01:58:26PM -0700, Paul E. McKenney wrote:
> > On Fri, Aug 08, 2014 at 09:13:26PM +0200, Peter Zijlstra wrote:
> > > 
> > > 
> > > So I think you can make the entire thing work with
> > > rcu_note_context_switch().
> > > 
> > > If we have the sync thing do something like:
> > > 
> > > 
> > > 	for_each_task(t) {
> > > 		atomic_inc(&rcu_tasks);
> > > 		atomic_or(&t->rcu_attention, RCU_TASK);
> > > 		smp_mb__after_atomic();
> > > 		if (!t->on_rq) {
> > > 			if (atomic_test_and_clear(&t->rcu_attention, RCU_TASK))
> > > 				atomic_dec(&rcu_tasks);
> > > 		}
> > > 	}
> > > 
> > > 	wait_event(&rcu_tasks_wq, !atomic_read(&rcu_tasks));
> > > 
> > > 
> > > And then we have rcu_task_note_context_switch() (as called from
> > > rcu_note_context_switch) do:
> > > 
> > > 
> > > 	/* we want actual context switches, ignore preemption */
> > > 	if (preempt_count() & PREEMPT_ACTIVE)
> > > 		return;
> > > 
> > > 	/* if not marked for RCU attention, bail */
> > > 	if (!(atomic_read(&t->rcu_attention) & RCU_TASK))
> > > 		return;
> > > 
> > > 	/* raced with sync_rcu_task(), all done */
> > > 	if (!atomic_test_and_clear(&t->rcu_attention, RCU_TASK))
> > > 		return;
> > > 
> > > 	/* not the last.. */
> > > 	if (!atomic_dec_and_test(&rcu_tasks))
> > > 		return;
> > > 
> > > 	wake_up(&rcu_task_rq);
> > > 
> > > 
> > > The idea is to share rcu_attention with rcu_preempt, such that we only
> > > touch a single 'extra' cacheline in case RCU doesn't need to pay
> > > attention to this task.
> > > 
> > > Also, it would be good if we can manage to squeeze this variable in a
> > > cacheline that's already touched by the schedule() so as not to incur
> > > undue overhead.
> > 
> > This approach does not get me the idle tasks and the NO_HZ_FULL usermode
> > tasks.  I am pretty sure that I am stuck polling in those cases, so I
> > might as well poll.
> 
> That's so wrong its not funny. If you need some abortion to deal with
> NOHZ_FULL then put it under CONFIG_NOHZ_FULL, don't burden the entire
> world with it.

Peter, the polling approach actually -reduces- the common-case
per-context-switch burden, as in when RCU-tasks isn't doing anything.
See your own code above.

> Also, I thought RCU already knew which CPUs were in nohz_full userspace,
> so we can insta check that in the sync, together with the !->on_rq test,
> if the task is running on a nohz_full cpu in rcu quiescent state, also
> clear the task.

RCU does know which are in nohz_full userspace, but it needs to handle
the case where they are not nohz_full at the beginning of the RCU-tasks
grace period.  Yes, I could hook into rcu_user_enter(), but that is
backwards from the viewpoint of the common case where there is no
RCU-tasks happening.

> As for idle tasks, I'm not sure about those, I think that we should say
> NO to anything that would require waking idle CPUs, push the pain to
> ftrace/kprobes, we should _not_ be waking idle cpus.

So the current patch set wakes an idle task once per RCU-tasks grace
period, but only when that idle task did not otherwise get awakened.
This is not a real problem.

And it could probably be reduced further, for example, for architectures
where the program counter of sleeping CPUs can be remotely accessed and
where the address of the am-asleep code is known.  I doubt that this
would really be worth it, but it could be done, in theory anyway.  Or, as
Steven suggested earlier, there could be a per-CPU variable that was set
(with approapriate memory ordering) when the CPU was actually sleeping.

So I don't believe that the current wakeup rate is a problem, and it
can be reduced if it proves to be a problem.

							Thanx, Paul

