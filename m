Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbaD3LKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:10:12 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60218 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427AbaD3LJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:09:55 -0400
Message-ID: <5360D9E5.9080206@gmail.com>
Date: Wed, 30 Apr 2014 13:09:25 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        linux-man@vger.kernel.org
Subject: Re: sched_{set,get}attr() manpage
References: <20131217122720.950475833@infradead.org> <20131217123352.692059839@infradead.org> <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com> <20140121153851.GZ31570@twins.programming.kicks-ass.net> <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com> <20140214161929.GL27965@twins.programming.kicks-ass.net> <53020C9D.1050208@gmail.com> <20140428081858.GX13658@twins.programming.kicks-ass.net> <535FA467.2070403@gmail.com> <20140429160441.GU11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140429160441.GU11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for the revision. More comments below. Could you revise in 
the light of those comments, and hopefully also after feedback from 
Juri and Dario?

On 04/29/2014 06:04 PM, Peter Zijlstra wrote:
> On Tue, Apr 29, 2014 at 03:08:55PM +0200, Michael Kerrisk (man-pages) wrote:
> 
> Juri, Dario, Can you have a look at the 2nd part; I'm not at all sure I
> got the activate/release the right way around.
> 
> My current thinking was that we activate first, and then release it to
> go run. But googling the terms only confused me more. I suppose its one
> of those things that's not actually _that_ well defined. And I hope the
> ASCII art actually clarifies things better than the terms used.
> 
>> [1] A page describing the sched_setattr() and sched_getattr() APIs
> 
> NAME
> 	sched_setattr, sched_getattr - set and get scheduling policy/attributes
> 
> SYNOPSIS
> 	#include <sched.h>
> 
> 	struct sched_attr {
> 		u32 size;
> 		u32 sched_policy;
> 		u64 sched_flags;
> 
> 		/* SCHED_NORMAL, SCHED_BATCH */
> 		s32 sched_nice;
> 
> 		/* SCHED_FIFO, SCHED_RR */
> 		u32 sched_priority;
> 
> 		/* SCHED_DEADLINE */
> 		u64 sched_runtime;
> 		u64 sched_deadline;
> 		u64 sched_period;
> 	};
> 
> 	int sched_setattr(pid_t pid, const struct sched_attr *attr, unsigned int flags);
> 
> 	int sched_getattr(pid_t pid, const struct sched_attr *attr, unsigned int size, unsigned int flags);
> 
> DESCRIPTION
> 	sched_setattr() sets both the scheduling policy and the
> 	associated attributes for the process whose ID is specified in
> 	pid.
> 
> 	sched_setattr() replaces sched_setscheduler(), sched_setparam(),
> 	nice() and some of setpriority().
> 
> 	If pid equals zero, the scheduling policy and attributes
> 	of the calling process will be set.  The interpretation of the
> 	argument attr depends on the selected policy.  Currently, Linux
> 	supports the following "normal" (i.e., non-real-time) scheduling
> 	policies:
> 
> 	SCHED_OTHER	the standard "fair" time-sharing policy;
> 
> 	SCHED_BATCH	for "batch" style execution of processes; and
> 
> 	SCHED_IDLE	for running very low priority background jobs.
> 
> 	The following "real-time" policies are also supported, for
> 	special time-critical applications that need precise control
> 	over the way in which runnable processes are selected for
> 	execution:
> 
> 	SCHED_FIFO	a static priority first-in, first-out policy;
> 
> 	SCHED_RR	a static priority round-robin policy; and
> 
> 	SCHED_DEADLINE	a dynamic priority deadline policy.
> 
> 	The semantics of each of these policies are detailed in
> 	sched(7).
> 
> 	sched_attr::size must be set to the size of the structure, as in
> 	sizeof(struct sched_attr), if the provided structure is smaller
> 	than the kernel structure, any additional fields are assumed
> 	'0'. If the provided structure is larger than the kernel
> 	structure, the kernel verifies all additional fields are '0' if
> 	not the syscall will fail with -E2BIG.
> 
> 	sched_attr::sched_policy the desired scheduling policy.
> 
> 	sched_attr::sched_flags additional flags that can influence
> 	scheduling behaviour. Currently as per Linux kernel 3.14:
> 
> 		SCHED_FLAG_RESET_ON_FORK - resets the scheduling policy
> 		to: (struct sched_attr){ .sched_policy = SCHED_OTHER, }
> 		on fork().
> 
> 	is the only supported flag.
> 
> 	sched_attr::sched_nice should only be set for SCHED_OTHER,
> 	SCHED_BATCH, the desired nice value [-20,19], see sched(7).
> 
> 	sched_attr::sched_priority should only be set for SCHED_FIFO,
> 	SCHED_RR, the desired static priority [1,99], see sched(7).
> 
> 	sched_attr::sched_runtime
> 	sched_attr::sched_deadline
> 	sched_attr::sched_period should only be set for SCHED_DEADLINE
> 	and are the traditional sporadic task model parameters, see
> 	sched(7).

So, are there fields expressed in some unit (presumably microseconds)?
Best to mention that here.

> 	The flags argument should be 0.
> 
> 	sched_getattr() queries the scheduling policy currently applied
> 	to the process identified by pid.
> 
> 	Similar to sched_setattr(), sched_getattr() replaces
> 	sched_getscheduler(), sched_getparam() and some of
> 	getpriority().
> 
> 	If pid equals zero, the policy of the calling process will be
> 	retrieved.
> 
> 	The size argument should reflect the size of struct sched_attr
> 	as known to userspace. The kernel fills out sched_attr::size to
> 	the size of its sched_attr structure. If the user provided
> 	structure is larger, additional fields are not touched. If the
> 	user provided structure is smaller, but the kernel needs to
> 	return values outside the provided space, the syscall will fail
> 	with -E2BIG.
> 
> 	The flags argument should be 0.
> 
> 	The other sched_attr fields are filled out as described in
> 	sched_setattr().
> 
> RETURN VALUE
> 	On success, sched_setattr() and sched_getattr() return 0. On
> 	error, -1 is returned, and errno is set appropriately.
> 
> ERRORS
>        EINVAL The scheduling policy is not one  of  the  recognized  policies,
>               param is NULL, or param does not make sense for the selected
> 	      policy.
> 
>        EPERM  The calling process does not have appropriate privileges.
> 
>        ESRCH  The process whose ID is pid could not be found.
> 
>        E2BIG  The provided storage for struct sched_attr is either too
>               big, see sched_setattr(), or too small, see sched_getattr().
> 
>        EBUSY  SCHED_DEADLINE admission control failure, see sched(7).
> 
> NOTES
>        While the text above (and in sched_setscheduler(2)) talks about
>        processes, in actual fact these system calls are thread specific.
> 
>> [2] A piece of text describing the SCHED_DEADLINE policy, which I can
>> drop into sched(7).
> 
>     SCHED_DEADLINE: Sporadic task model deadline scheduling
>        SCHED_DEADLINE is an implementation of GEDF (Global Earliest
>        Deadline First) with additional CBS (Constant Bandwidth Server).
> 
>        A sporadic task is on that has a sequence of jobs, where each job
>        is activated at most once per period [us]. Each job will have an
>        absolute deadline relative to its activation before which it must
>        finish its execution, and it shall at no time run longer
>        than runtime [us] after its release.
> 
>               activation/wakeup       absolute deadline
>               |        release        |
>               v        v              v
>        -------x--------x--------------x--------x-------
>                        |<- Runtime -->|
>               |<---------- Deadline ->|
>               |<---------- Period  ----------->|
> 
>        This gives: runtime <= (rel) deadline <= period.

So, the 'sched_deadline' field in the 'sched_attr' expresses the release
deadline? (I had initially thought it was the "absolute deadline".
Could you make this clearer in the text please.

>        The CBS guarantees that tasks that over-run their specified
>        runtime are throttled and do not affect the correct performance
>        of other SCHED_DEADLINE tasks.
> 
>        In general a task set of such tasks it not feasible/schedulable

That last line is garbled. Could you fix, please.

Also, could you add some words to explain what you mean by 'task set'.

>        within the given constraints. Therefore we must do an admittance
>        test on setting/changing SCHED_DEADLINE policy/attributes.
> 
>        This admission test calculates that the task set is
>        feasible/schedulable, failing this, sched_setattr() will return
>        -EBUSY.
> 
>        For example, it is required (but not sufficient) for the total
>        utilization to be less or equal to the total amount of cpu time
>        available. That is, since each job can maximally run for runtime
>        [us] per period [us], that task's utilization is runtime/period.
>        Summing this over all tasks must be less than the total amount of
>        CPUs present.
> 
>        SCHED_DEADLINE tasks will fail fork(2) with -EAGAIN.

Except if SCHED_RESET_ON_FORK was set, right? If yes, that should be
mentioned here.

>        Because of the nature of (G)EDF, SCHED_DEADLINE tasks are the
>        highest priority (user controllable) tasks in the system, if any
>        SCHED_DEADLINE task is runnable it will preempt anything
>        FIFO/RR/OTHER/BATCH/IDLE task out there.
> 
>        A SCHED_DEADLINE task calling sched_yield() will 'yield' the
>        current job and wait for a new period to begin.

So, I'm trying to naively understand how this all works. If different 
processes specify different deadline periods, how does the kernel deal
with that? Is it worth adding some detail on this point?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
