Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaD1IT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:19:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaD1ITV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:19:21 -0400
Date: Mon, 28 Apr 2014 10:18:58 +0200
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
Subject: sched_{set,get}attr() manpage
Message-ID: <20140428081858.GX13658@twins.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217123352.692059839@infradead.org>
 <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
 <20140121153851.GZ31570@twins.programming.kicks-ass.net>
 <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com>
 <20140214161929.GL27965@twins.programming.kicks-ass.net>
 <53020C9D.1050208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53020C9D.1050208@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

find below an updated manpage, I did not apply the comments on parts
that are identical to SCHED_SETSCHEDULER(2) in order to keep these texts
in alignment. I feel that if we change one we should also change the
other, and such a 'patch' is best done separate from the new manpage
itself.

I did add the missing EBUSY error, and amended the text where it said
we'd return EINVAL in that case.

I added a paragraph stating that SCHED_DEADLINE preempted anything else
userspace can do (with the explicit mention of userspace to leave me
wriggle room for the kernel's stop task :-).

I also did a short paragraph on the deadline sched_yield(). For further
deadline yield details we should maybe add to the SCHED_YIELD(2)
manpage.

Re juri/claudio; no I think sched_yield() as implemented for deadline
makes sense, no other yield semantics other than NOP makes sense for it,
and since we have the syscall already might as well make it do something
useful.


---

NAME
	sched_setattr, sched_getattr - set and get scheduling policy/attributes

SYNOPSIS
	#include <sched.h>

	struct sched_attr {
		u32 size;
		u32 sched_policy;
		u64 sched_flags;

		/* SCHED_NORMAL, SCHED_BATCH */
		s32 sched_nice;
		/* SCHED_FIFO, SCHED_RR */
		u32 sched_priority;
		/* SCHED_DEADLINE */
		u64 sched_runtime;
		u64 sched_deadline;
		u64 sched_period;
	};
	int sched_setattr(pid_t pid, const struct sched_attr *attr, unsigned int flags);

	int sched_getattr(pid_t pid, const struct sched_attr *attr, unsigned int size, unsigned int flags);

DESCRIPTION
	sched_setattr() sets both the scheduling policy and the
	associated attributes for the process whose ID is specified in
	pid.  If pid equals zero, the scheduling policy and attributes
	of the calling process will be set.  The interpretation of the
	argument attr depends on the selected policy.  Currently, Linux
	supports the following "normal" (i.e., non-real-time) scheduling
	policies:

	SCHED_OTHER	the standard "fair" time-sharing policy;

	SCHED_BATCH	for "batch" style execution of processes; and

	SCHED_IDLE	for running very low priority background jobs.

	The following "real-time" policies are also supported, for
	special time-critical applications that need precise control
	over the way in which runnable processes are selected for
	execution:

	SCHED_FIFO	a first-in, first-out policy;

	SCHED_RR	a round-robin policy; and

	SCHED_DEADLINE	a deadline policy.

	The semantics of each of these policies are detailed below.

	sched_attr::size must be set to the size of the structure, as in
	sizeof(struct sched_attr), if the provided structure is smaller
	than the kernel structure, any additional fields are assumed
	'0'. If the provided structure is larger than the kernel
	structure, the kernel verifies all additional fields are '0' if
	not the syscall will fail with -E2BIG.

	sched_attr::sched_policy the desired scheduling policy.

	sched_attr::sched_flags additional flags that can influence
	scheduling behaviour. Currently as per Linux kernel 3.14:

		SCHED_FLAG_RESET_ON_FORK - resets the scheduling policy
		to: (struct sched_attr){ .sched_policy = SCHED_OTHER, }
		on fork().

	is the only supported flag.

	sched_attr::sched_nice should only be set for SCHED_OTHER,
	SCHED_BATCH, the desired nice value [-20,19], see NICE(2).

	sched_attr::sched_priority should only be set for SCHED_FIFO,
	SCHED_RR, the desired static priority [1,99].

	sched_attr::sched_runtime
	sched_attr::sched_deadline
	sched_attr::sched_period should only be set for SCHED_DEADLINE
	and are the traditional sporadic task model parameters.

	The flags argument should be 0.

	sched_getattr() queries the scheduling policy currently applied
	to the process identified by pid.  If pid equals zero, the
	policy of the calling process will be retrieved.

	The size argument should reflect the size of struct sched_attr
	as known to userspace. The kernel fills out sched_attr::size to
	the size of its sched_attr structure. If the user provided
	structure is larger, additional fields are not touched. If the
	user provided structure is smaller, but the kernel needs to
	return values outside the provided space, the syscall will fail
	with -E2BIG.

	The flags argument should be 0.

	The other sched_attr fields are filled out as described in
	sched_setattr().

   Scheduling Policies
       The  scheduler  is  the  kernel  component  that decides which runnable
       process will be executed by the CPU next.  Each process has an  associ‐
       ated  scheduling  policy and a static scheduling priority, sched_prior‐
       ity; these are the settings that are modified by  sched_setscheduler().
       The  scheduler  makes it decisions based on knowledge of the scheduling
       policy and static priority of all processes on the system.

       For processes scheduled under one of  the  normal  scheduling  policies
       (SCHED_OTHER,  SCHED_IDLE,  SCHED_BATCH), sched_priority is not used in
       scheduling decisions (it must be specified as 0).

       Processes scheduled under one of the  real-time  policies  (SCHED_FIFO,
       SCHED_RR)  have  a  sched_priority  value  in  the  range 1 (low) to 99
       (high).  (As the numbers imply, real-time processes always have  higher
       priority than normal processes.)  Note well: POSIX.1-2001 only requires
       an implementation to support a minimum 32 distinct priority levels  for
       the  real-time  policies,  and  some  systems supply just this minimum.
       Portable   programs   should    use    sched_get_priority_min(2)    and
       sched_get_priority_max(2) to find the range of priorities supported for
       a particular policy.

       Conceptually, the scheduler maintains a list of runnable processes  for
       each  possible  sched_priority  value.   In  order  to  determine which
       process runs next, the scheduler looks for the nonempty list  with  the
       highest  static  priority  and  selects the process at the head of this
       list.

       A process's scheduling policy determines where it will be inserted into
       the  list  of processes with equal static priority and how it will move
       inside this list.

       All scheduling is preemptive: if a process with a higher static  prior‐
       ity  becomes  ready  to run, the currently running process will be pre‐
       empted and returned to the wait list for  its  static  priority  level.
       The  scheduling  policy only determines the ordering within the list of
       runnable processes with equal static priority.

    SCHED_DEADLINE: Sporadic task model deadline scheduling
       SCHED_DEADLINE is an implementation of GEDF (Global Earliest
       Deadline First) with additional CBS (Constant Bandwidth Server).
       The CBS guarantees that tasks that over-run their specified
       budget are throttled and do not affect the correct performance
       of other SCHED_DEADLINE tasks.

       SCHED_DEADLINE tasks will fail FORK(2) with -EAGAIN

       Setting SCHED_DEADLINE can fail with -EBUSY when admission
       control tests fail.

       Because of the nature of (G)EDF, SCHED_DEADLINE tasks are the
       highest priority (user controllable) tasks in the system, if any
       SCHED_DEADLINE task is runnable it will preempt anything
       FIFO/RR/OTHER/BATCH/IDLE task out there.

       A SCHED_DEADLINE task calling sched_yield() will 'yield' the
       current job and wait for a new period to begin.

   SCHED_FIFO: First In-First Out scheduling
       SCHED_FIFO can only be used with static priorities higher than 0, which
       means that when a SCHED_FIFO processes becomes runnable, it will always
       immediately preempt any currently running SCHED_OTHER, SCHED_BATCH,  or
       SCHED_IDLE  process.  SCHED_FIFO is a simple scheduling algorithm with‐
       out time slicing.  For processes scheduled under the SCHED_FIFO policy,
       the following rules apply:

       *  A  SCHED_FIFO  process that has been preempted by another process of
          higher priority will stay at the head of the list for  its  priority
          and  will resume execution as soon as all processes of higher prior‐
          ity are blocked again.

       *  When a SCHED_FIFO process becomes runnable, it will be  inserted  at
          the end of the list for its priority.

       *  A  call  to  sched_setscheduler()  or sched_setparam(2) will put the
          SCHED_FIFO (or SCHED_RR) process identified by pid at the  start  of
          the  list  if it was runnable.  As a consequence, it may preempt the
          currently  running  process   if   it   has   the   same   priority.
          (POSIX.1-2001 specifies that the process should go to the end of the
          list.)

       *  A process calling sched_yield(2) will be put at the end of the list.

       No other events will move a process scheduled under the SCHED_FIFO pol‐
       icy in the wait list of runnable processes with equal static priority.

       A SCHED_FIFO process runs until either it is blocked by an I/O request,
       it  is  preempted  by  a  higher  priority   process,   or   it   calls
       sched_yield(2).

   SCHED_RR: Round Robin scheduling
       SCHED_RR  is  a simple enhancement of SCHED_FIFO.  Everything described
       above for SCHED_FIFO also applies to SCHED_RR, except that each process
       is  only  allowed  to  run  for  a maximum time quantum.  If a SCHED_RR
       process has been running for a time period equal to or longer than  the
       time  quantum,  it will be put at the end of the list for its priority.
       A SCHED_RR process that has been preempted by a higher priority process
       and  subsequently  resumes execution as a running process will complete
       the unexpired portion of its round robin time quantum.  The  length  of
       the time quantum can be retrieved using sched_rr_get_interval(2).

   SCHED_OTHER: Default Linux time-sharing scheduling
       SCHED_OTHER  can only be used at static priority 0.  SCHED_OTHER is the
       standard Linux time-sharing scheduler that is  intended  for  all  pro‐
       cesses  that  do  not  require  the  special real-time mechanisms.  The
       process to run is chosen from the static priority 0  list  based  on  a
       dynamic priority that is determined only inside this list.  The dynamic
       priority is based on the nice value (set by nice(2) or  setpriority(2))
       and  increased  for  each time quantum the process is ready to run, but
       denied to run by the scheduler.  This ensures fair progress  among  all
       SCHED_OTHER processes.

   SCHED_BATCH: Scheduling batch processes
       (Since  Linux 2.6.16.)  SCHED_BATCH can only be used at static priority
       0.  This policy is similar to SCHED_OTHER  in  that  it  schedules  the
       process  according  to  its dynamic priority (based on the nice value).
       The difference is that this policy will cause the scheduler  to  always
       assume  that the process is CPU-intensive.  Consequently, the scheduler
       will apply a small scheduling penalty with respect to wakeup behaviour,
       so that this process is mildly disfavored in scheduling decisions.

       This policy is useful for workloads that are noninteractive, but do not
       want to lower their nice value, and for workloads that want a determin‐
       istic scheduling policy without interactivity causing extra preemptions
       (between the workload's tasks).

   SCHED_IDLE: Scheduling very low priority jobs
       (Since Linux 2.6.23.)  SCHED_IDLE can only be used at  static  priority
       0; the process nice value has no influence for this policy.

       This  policy  is  intended  for  running jobs at extremely low priority
       (lower even than a +19 nice value with the SCHED_OTHER  or  SCHED_BATCH
       policies).

RETURN VALUE
	On success, sched_setattr() and sched_getattr() return 0. On
	error, -1 is returned, and errno is set appropriately.

ERRORS
       EINVAL The scheduling policy is not one  of  the  recognized  policies,
              param is NULL, or param does not make sense for the policy.

       EPERM  The calling process does not have appropriate privileges.

       ESRCH  The process whose ID is pid could not be found.

       E2BIG  The provided storage for struct sched_attr is either too
              big, see sched_setattr(), or too small, see sched_getattr().

       EBUSY  SCHED_DEADLINE admission control failure

NOTES
	While the text above (and in SCHED_SETSCHEDULER(2)) talks about
	processes, in actual fact these system calls are thread specific.
