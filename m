Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbaHHU6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:58:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56454 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbaHHU6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:58:33 -0400
Date: Fri, 8 Aug 2014 13:58:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140808205826.GG5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808191326.GE3935@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080820-1542-0000-0000-000003DD0693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 09:13:26PM +0200, Peter Zijlstra wrote:
> 
> 
> So I think you can make the entire thing work with
> rcu_note_context_switch().
> 
> If we have the sync thing do something like:
> 
> 
> 	for_each_task(t) {
> 		atomic_inc(&rcu_tasks);
> 		atomic_or(&t->rcu_attention, RCU_TASK);
> 		smp_mb__after_atomic();
> 		if (!t->on_rq) {
> 			if (atomic_test_and_clear(&t->rcu_attention, RCU_TASK))
> 				atomic_dec(&rcu_tasks);
> 		}
> 	}
> 
> 	wait_event(&rcu_tasks_wq, !atomic_read(&rcu_tasks));
> 
> 
> And then we have rcu_task_note_context_switch() (as called from
> rcu_note_context_switch) do:
> 
> 
> 	/* we want actual context switches, ignore preemption */
> 	if (preempt_count() & PREEMPT_ACTIVE)
> 		return;
> 
> 	/* if not marked for RCU attention, bail */
> 	if (!(atomic_read(&t->rcu_attention) & RCU_TASK))
> 		return;
> 
> 	/* raced with sync_rcu_task(), all done */
> 	if (!atomic_test_and_clear(&t->rcu_attention, RCU_TASK))
> 		return;
> 
> 	/* not the last.. */
> 	if (!atomic_dec_and_test(&rcu_tasks))
> 		return;
> 
> 	wake_up(&rcu_task_rq);
> 
> 
> The idea is to share rcu_attention with rcu_preempt, such that we only
> touch a single 'extra' cacheline in case RCU doesn't need to pay
> attention to this task.
> 
> Also, it would be good if we can manage to squeeze this variable in a
> cacheline that's already touched by the schedule() so as not to incur
> undue overhead.

This approach does not get me the idle tasks and the NO_HZ_FULL usermode
tasks.  I am pretty sure that I am stuck polling in those cases, so I
might as well poll.

> And on that, you probably should change rcu_sched_rq() to read:
> 
> 	this_cpu_inc(rcu_sched_data.passed_quiesce);
> 
> That avoids touching the per-cpu data offset.

Hmmm...  Interrupts are disabled, so no need to further disable
interrupts.  Storing 1 works fine, no need to increment.  If I followed
the twisty per_cpu passages correctly, my guess is that you would like
me to do something like this:

	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);

Does that work?

> And it would be very good if we could avoid the unconditional IRQ flag
> fiddling in rcu_preempt_note_context_switch(), them expensive, this
> looks entirely feasibly in the 'normal' case where
> t->rcu_read_unlock_special doesn't have RCU_READ_UNLOCK_NEED_QS set.

Agreed, but sometimes RCU_READ_UNLOCK_NEED_QS is set.

That said, I should probably revisit RCU_READ_UNLOCK_NEED_QS.  A lot has
changed since I wrote that code.

							Thanx, Paul

