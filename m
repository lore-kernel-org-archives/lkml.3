Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbaD3MgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:36:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaD3MgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:36:04 -0400
Date: Wed, 30 Apr 2014 14:35:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, rostedt@goodmis.org,
        Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        Linux Kernel <linux-kernel@vger.kernel.org>, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        linux-man@vger.kernel.org
Subject: Re: sched_{set,get}attr() manpage
Message-ID: <20140430123535.GG11096@twins.programming.kicks-ass.net>
References: <20131217123352.692059839@infradead.org>
 <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
 <20140121153851.GZ31570@twins.programming.kicks-ass.net>
 <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com>
 <20140214161929.GL27965@twins.programming.kicks-ass.net>
 <53020C9D.1050208@gmail.com>
 <20140428081858.GX13658@twins.programming.kicks-ass.net>
 <535FA467.2070403@gmail.com>
 <20140429160441.GU11096@twins.programming.kicks-ass.net>
 <5360D9E5.9080206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5360D9E5.9080206@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 01:09:25PM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Peter,
> 
> Thanks for the revision. More comments below. Could you revise in 
> the light of those comments, and hopefully also after feedback from 
> Juri and Dario?
> 
> > 
> > 	sched_attr::sched_runtime
> > 	sched_attr::sched_deadline
> > 	sched_attr::sched_period should only be set for SCHED_DEADLINE
> > 	and are the traditional sporadic task model parameters, see
> > 	sched(7).
> 
> So, are there fields expressed in some unit (presumably microseconds)?
> Best to mention that here.

Oh wait, no its nanoseconds. Which means I should amend the text below.

> >> [2] A piece of text describing the SCHED_DEADLINE policy, which I can
> >> drop into sched(7).
> > 
> >     SCHED_DEADLINE: Sporadic task model deadline scheduling
> >        SCHED_DEADLINE is an implementation of GEDF (Global Earliest
> >        Deadline First) with additional CBS (Constant Bandwidth Server).
> > 
> >        A sporadic task is on that has a sequence of jobs, where each job
> >        is activated at most once per period [us]. Each job will have an
> >        absolute deadline relative to its activation before which it must

(A)

> >        finish its execution, and it shall at no time run longer
> >        than runtime [us] after its release.
> > 
> >               activation/wakeup       absolute deadline
> >               |        release        |
> >               v        v              v
> >        -------x--------x--------------x--------x-------
> >                        |<- Runtime -->|
> >               |<---------- Deadline ->|
> >               |<---------- Period  ----------->|
> > 
> >        This gives: runtime <= (rel) deadline <= period.
> 
> So, the 'sched_deadline' field in the 'sched_attr' expresses the release
> deadline? (I had initially thought it was the "absolute deadline".
> Could you make this clearer in the text please.

No, and yes, sched_attr::sched_deadline is a relative deadline wrt to
the activation. Like said at (A).

So we get: absolute deadline = activation + relative deadline.

And we must be done running at that point, so the very last possible
release moment is: absolute deadline - runtime.

And therefore, it too is a release deadline, since we must not release
later than that.

> >        The CBS guarantees that tasks that over-run their specified
> >        runtime are throttled and do not affect the correct performance
> >        of other SCHED_DEADLINE tasks.
> > 
> >        In general a task set of such tasks it not feasible/schedulable
> 
> That last line is garbled. Could you fix, please.

s/it/is/

> Also, could you add some words to explain what you mean by 'task set'.

A set of tasks? :-) In particular all tasks in the system of
SCHED_DEADLINE, indicated by 'of such'.

> >        within the given constraints. Therefore we must do an admittance
> >        test on setting/changing SCHED_DEADLINE policy/attributes.
> > 
> >        This admission test calculates that the task set is
> >        feasible/schedulable, failing this, sched_setattr() will return
> >        -EBUSY.
> > 
> >        For example, it is required (but not sufficient) for the total
> >        utilization to be less or equal to the total amount of cpu time
> >        available. That is, since each job can maximally run for runtime
> >        [us] per period [us], that task's utilization is runtime/period.
> >        Summing this over all tasks must be less than the total amount of
> >        CPUs present.
> > 
> >        SCHED_DEADLINE tasks will fail fork(2) with -EAGAIN.
> 
> Except if SCHED_RESET_ON_FORK was set, right? If yes, that should be
> mentioned here.

Ah, indeed.

> >        Because of the nature of (G)EDF, SCHED_DEADLINE tasks are the
> >        highest priority (user controllable) tasks in the system, if any
> >        SCHED_DEADLINE task is runnable it will preempt anything
> >        FIFO/RR/OTHER/BATCH/IDLE task out there.
> > 
> >        A SCHED_DEADLINE task calling sched_yield() will 'yield' the
> >        current job and wait for a new period to begin.
> 
> So, I'm trying to naively understand how this all works. If different 
> processes specify different deadline periods, how does the kernel deal
> with that? Is it worth adding some detail on this point?

Userspace should not rely on any implementation details there. Saying
its a (G)EDF scheduler is maybe already too much. All userspace should
really care about is that its tasks _should_ be scheduled such that it
meets the specified requirements.

There are multiple scheduling algorithms that can be employed to make it
so, and I don't want to pin us to whatever we chose to implement this
time.

That said, the current (G)EDF is a soft realtime scheduler in that it
guarantees a bounded tardiness (which is the time we can miss the
deadline by) but not a hard realtime, since the bound is not 0.

Anyway, for your elucidation; assuming no overhead and a UP system
(SMP is a right head-ache), and a further assumption that deadline ==
period. It is reasonable straight forward to see that scheduling the
task with the earliest deadline will satisfy the constraints IFF the
total utilization (\Sum runtime_i / deadline_i) <= 1.

Suppose two tasks: A := { 5, 10 } and B := { 10, 20 } with strict
periodic activation:

    A1,B1     A2        Ad2
    |         Ad1       Bd1
    v         v         v
  --AAAAABBBBBAAAAABBBBBx--
  --AAAAABBBBBBBBBBAAAAAx--

Where A# is the #th activation, Ad# is the corresponding #th deadline
before which we must have sufficient time.

Since we're perfectly synced up there is a tie and we get two possible
outcomes. But note that in either case A has gotten 2x its 5 As and B
has gotten its 10 Bs.

Non-periodic activation, and deadline != period make the thing more
interesting, but at that point I would ask Juri (or others) to refer you
to a paper/book.

Now, let me go update the texts yet again :-)
