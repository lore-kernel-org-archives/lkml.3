Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaAUPje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:39:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaAUPjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:39:32 -0500
Date: Tue, 21 Jan 2014 16:38:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
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
        liming.wang@windriver.com, jkacur@redhat.com
Subject: Re: [PATCH 01/13] sched: Add 3 new scheduler syscalls to support an
 extended scheduling parameters ABI
Message-ID: <20140121153851.GZ31570@twins.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217123352.692059839@infradead.org>
 <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:36:37PM +0100, Michael Kerrisk wrote:
> Peter, Dario,

> Is someone (e.g., one of you) planning to write man pages for the new
> sched_setattr() and sched_getattr() system calls? (Also, for the
> future, please CC linux-api@vger.kernel.org on patches that change the
> API, then those of us who don't follow LKML get a heads up about
> upcoming API changes.)

first draft, shamelessly stolen from SCHED_SETSCHEDULER(2).

One note on both the original as well as the below: process is
ambiguous, the syscalls actually apply to a single thread of a process,
not the entire process.

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

	int sched_setattr(pid_t pid, const struct sched_attr *attr);

	int sched_getattr(pid_t pid, const struct sched_attr *attr, unsigned int size);

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

	The other sched_attr fields are filled out as described in
	sched_setattr().


${insert SCHED_* descriptions}

    SCHED_DEADLINE: Sporadic task model deadline scheduling
	SCHED_DEADLINE is an implementation of GEDF (Global Earliest
	Deadline First) with additional CBS (Constant Bandwidth Server).
	The CBS guarantees that tasks that over-run their specified
	budget are throttled and do not affect the correct performance
	of other SCHED_DEADLINE tasks.

	SCHED_DEADLINE tasks will fail FORK(2) with -EAGAIN

	Setting SCHED_DEADLINE can fail with -EINVAL when admission
	control tests fail.

${NOTE: should we change that to -EBUSY ? }


Other than that its pretty much the same as the existing
SCHED_SETSCHEDULER(2) page.
