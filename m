Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaEMPw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:52:26 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45636 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaEMPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:52:15 -0400
Date: Tue, 13 May 2014 17:52:10 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [SCHED_DEADLINE man pages 2/2] sched(7) SCHED_DEADLINE
Message-Id: <20140513175210.49eed2e34ac06a3c109ce963@gmail.com>
In-Reply-To: <537233A9.6040102@gmail.com>
References: <53723235.40101@gmail.com>
	<537233A9.6040102@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 13 May 2014 17:00:57 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> Hello Peter et al.
> 
> Here is the section of the sched(7) page that describes SCHED_DEADLINE,
> as rendered text, with the (entire) raw page source attached. Please 
> carefully review.
> 
> Cheers,
> 
> Michael
> 
>    SCHED_DEADLINE: Sporadic task model deadline scheduling
>        Since version 3.14, Linux provides a deadline scheduling pol‐
>        icy (SCHED_DEADLINE).  This policy is  currently  implemented
>        using  GEDF  (Global  Earliest Deadline First) in conjunction
>        with CBS (Constant Bandwidth Server).  To set and fetch  this
>        policy and associated attributes, one must use the Linux-spe‐
>        cific sched_setattr(2) and sched_getattr(2) system calls.
> 
>        A sporadic task is one that has a  sequence  of  jobs,  where
>        each job is activated at most once per period.  Each job also
>        has a relative deadline, before which it should finish execu‐
>        tion, and a computation time, which is the CPU time necessary
>        for executing the job.  The  moment  when  a  task  wakes  up
>        because  a  new  job has to be executed is called the arrival
>        time (also referred to as the request time or release  time).
>        The  start time is the time at which a task starts its execu‐
>        tion.  The absolute deadline is thus obtained by  adding  the
>        relative deadline to the arrival time.
> 
>        The following diagram clarifies these terms:
> 
>            arrival/wakeup                   absolute deadline
>                 |    start time                   |
>                 |        |                        |
>                 v        v                        v
>            -----x--------xooooooooooooooooo-------x--------x---
>                          |<- comp. time ->|
>                 |<------- relative deadline ----->|
>                 |<-------------- period ------------------>|
> 
>        When  setting  a  SCHED_DEADLINE  policy  for  a thread using
>        sched_setattr(2), one can specify three parameters:  Runtime,
>        Deadline,  and  Period.   These parameters do not necessarily
>        correspond to the aforementioned terms: usual practice is  to
>        set  Runtime to something bigger than the average computation
>        time (or worst-case execution time for hard real-time tasks),
>        Deadline  to  the relative deadline, and Period to the period
>        of the task.  Thus, for SCHED_DEADLINE scheduling, we have:
> 
>            arrival/wakeup                   absolute deadline
>                 |    start time                   |
>                 |        |                        |
>                 v        v                        v
>            -----x--------xooooooooooooooooo-------x--------x---
>                          |<-- Runtime --->|

                           |<-- Runtime   --->|

I originally drew this slightly bigger than comp. time above because we
usually don't want tasks to be throttled in the average case. It's just
a rule of thumb.

>                 |<----------- Deadline ---------->|
>                 |<-------------- Period ------------------>|
> 
>        The three deadline-scheduling parameters  correspond  to  the
>        sched_runtime, sched_deadline, and sched_period fields of the
>        sched_attr structure;  see  sched_setattr(2).   These  fields
>        express  value  in nanoseconds.  If sched_period is specified
>        as 0, then it is made the same as sched_deadline.
> 
>        The kernel requires that:
> 
>            sched_runtime <= sched_deadline <= sched_period
> 
>        In addition, under the current  implementation,  all  of  the
>        parameter  values  must be at least 1024 (i.e., just over one
>        microsecond, which is the resolution of the  implementation).

And below 2^63, as per the last bug fix we discussed.

>        If any of these checks fails, sched_setattr(2) fails with the
>        error EINVAL.
> 
>        The CBS guarantees non-interference between tasks, by  throt‐
>        tling  threads  that attempt to over-run their specified Run‐
>        time.
> 
>        To ensure deadline scheduling  guarantees,  the  kernel  must
>        prevent situations where the set of SCHED_DEADLINE threads is
>        not feasible (schedulable) within the given constraints.  The
>        kernel  thus  performs  an  admittance  test  when setting or
>        changing SCHED_DEADLINE policy and attributes.   This  admis‐
>        sion test calculates whether the change is feasible; if it is
>        not sched_setattr(2) fails with the error EBUSY.
> 
>        For example, it is required (but not necessarily  sufficient)
>        for  the  total  utilization  to be less than or equal to the
>        total number of CPUs available, where, since each thread  can
>        maximally  run for Runtime per Period, that thread's utiliza‐
>        tion is its Runtime divided by its Period.
> 
>        In order to fulfil the guarantees that are made when a thread
>        is  admitted  to  the  SCHED_DEADLINE  policy, SCHED_DEADLINE
>        threads are the highest priority (user controllable)  threads
>        in  the  system; if any SCHED_DEADLINE thread is runnable, it
>        will preempt any thread scheduled  under  one  of  the  other
>        policies.
> 
>        A call to fork(2) by a thread scheduled under the SCHED_DEAD‐
>        LINE policy will fail  with  the  error  EAGAIN,  unless  the
>        thread has its reset-on-fork flag set (see below).
> 
>        A  SCHED_DEADLINE thread that calls sched_yield(2) will yield
>        the current job and wait for a new period to begin.
> 

Thanks,

- Juri
