Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaGVMYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:24:17 -0400
Received: from relay.parallels.com ([195.214.232.42]:37005 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaGVMYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:24:14 -0400
Message-ID: <1406031840.3526.60.camel@tkhai>
Subject: Re: [PATCH 2/5] sched: Teach scheduler to understand ONRQ_MIGRATING
 state
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <tkhai@yandex.ru>, Oleg Nesterov <oleg@redhat.com>
Date: Tue, 22 Jul 2014 16:24:00 +0400
In-Reply-To: <20140722114542.GG20603@laptop.programming.kicks-ass.net>
References: <20140722102425.29682.24086.stgit@tkhai>
	 <1406028616.3526.20.camel@tkhai>
	 <20140722114542.GG20603@laptop.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 22/07/2014 в 13:45 +0200, Peter Zijlstra пишет:
> On Tue, Jul 22, 2014 at 03:30:16PM +0400, Kirill Tkhai wrote:
> > 
> > This is new on_rq state for the cases when task is migrating
> > from one src_rq to another dst_rq, and locks of the both RQs
> > are unlocked.
> > 
> > We will use the state this way:
> > 
> > 	raw_spin_lock(&src_rq->lock);
> > 	dequeue_task(src_rq, p, 0);
> > 	p->on_rq = ONRQ_MIGRATING;
> > 	set_task_cpu(p, dst_cpu);
> > 	raw_spin_unlock(&src_rq->lock);
> > 
> > 	raw_spin_lock(&dst_rq->lock);
> > 	p->on_rq = ONRQ_QUEUED;
> > 	enqueue_task(dst_rq, p, 0);
> > 	raw_spin_unlock(&dst_rq->lock);
> > 
> > The profit is that double_rq_lock() is not needed now,
> > and this may reduce the latencies in some situations.
> > 
> > The logic of try_to_wake_up() remained the same as it
> > was. Its behaviour changes in a small subset of cases
> > (when preempted task in ~TASK_RUNNING state is queued
> >  on rq and we are migrating it to another).
> 
> more details is better ;-) Also, I think Oleg enjoys these kind of
> things, so I've added him to the CC.

try_to_wake_up() wakes tasks in the particular states,
no one calls it with TASK_RUNNING argument. So, our
logic will have a deal with tasks in !TASK_RUNNING state.

If they are on rq and !TASK_RUNNING, this means, they were
preempted using preempt_schedule{,_irq}. If they were preempted
in !TASK_RUNNING state, this was in one of the cases like:

	set_current_state(TASK_INTERRUPTIBLE);

	(actions)

	schedule();

And someone is migrating this task.

Really small subset of cases :)

> A few questions, haven't really thought about things yet.
> 
> > @@ -1491,10 +1491,14 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
> >  static void
> >  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
> >  {
> > -	check_preempt_curr(rq, p, wake_flags);
> >  	trace_sched_wakeup(p, true);
> >  
> >  	p->state = TASK_RUNNING;
> > +
> > +	if (!task_queued(p))
> > +		return;
> 
> How can this happen? we're in the middle of a wakeup, we're just added
> the task to the rq and are still holding the appropriate rq->lock.

try_to_wake_up()->ttwu_remote()->ttwu_do_wakeup():

task is migrating at the moment, and the only thing we do is we change
its state on TASK_RUNNING. It will be queued with new state (TASK_RUNNING) by the code, which is migrating it.

It looks like this situation in general is not very often. It's only
for the cases when we're migrating a task, which was preempted with
!TASK_RUNNING state.


> > @@ -4623,9 +4629,14 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
> >  	struct rq *rq;
> >  	unsigned int dest_cpu;
> >  	int ret = 0;
> > -
> > +again:
> >  	rq = task_rq_lock(p, &flags);
> >  
> > +	if (unlikely(p->on_rq) == ONRQ_MIGRATING) {
> > +		task_rq_unlock(rq, p, &flags);
> > +		goto again;
> > +	}
> > +
> >  	if (cpumask_equal(&p->cpus_allowed, new_mask))
> >  		goto out;
> >  
> 
> That looks like a non-deterministic spin loop, 'waiting' for the
> migration to finish. Not particularly nice and something I think we
> should avoid for it has bad (TM) worst case behaviour.
> 
> Also, why only this site and not all task_rq_lock() sites?

All other places tests for task_queued(p) under rq's lock. I watched
all of them and did not find a place who needs that. For example,
rt_mutex_setprio() enqueues only if task was really queued before.
Patch [1/5] made all preparation for that. With a hope, nothing was
skipped by /me.

About set_cpus_allowed_ptr(). We could return -EAGAIN if a task is
migrating, but set_cpus_allowed_ptr() must not fail on kernel threads.
We'd would miss something important this way, it's softirq affinity
for example.

Going to again label looks like manual spinlock for me. We used to
spin there before. The time of held lock was similar, and we also
had competition with other rq's lock users. The lock just was locked
permanently, and we didn't have overhead with repeating spin_{lock,unlock}
here.

I don't see what to do instead..

Thanks,
Kirill

