Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaA0PgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:36:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50395 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753483AbaA0PgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:36:07 -0500
Date: Mon, 27 Jan 2014 10:35:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com, linux-doc@vger.kernel.org,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140127103556.02d82e02@gandalf.local.home>
In-Reply-To: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
References: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014 12:20:15 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:


> +
> +2. Scheduling algorithm
> +==================
> +
> + SCHED_DEADLINE uses three parameters, named "runtime", "period", and
> + "deadline" to schedule tasks. A SCHED_DEADLINE task is guaranteed to receive
> + "runtime" microseconds of execution time every "period" microseconds, and
> + these "runtime" microseconds are available within "deadline" microseconds
> + from the beginning of the period.  In order to implement this behaviour,
> + every time the task wakes up, the scheduler computes a "scheduling deadline"
> + consistent with the guarantee (using the CBS[2,3] algorithm). Tasks are then
> + scheduled using EDF[1] on these scheduling deadlines (the task with the
> + smallest scheduling deadline is selected for execution). Notice that this

s/smallest/closest/

You can have a large deadline, but it could be the next one to trigger.

> + guaranteed is respected if a proper "admission control" strategy (see Section
> + "4. Bandwidth management") is used.
> +
> + Summing up, the CBS[2,3] algorithms assigns scheduling deadlines to tasks so
> + that each task runs for at most its runtime every period, avoiding any
> + interference between different tasks (bandwidth isolation), while the EDF[1]
> + algorithm selects the task with the smallest scheduling deadline as the one

Probably should say closest here too. Smallest doesn't mean that it is
the next deadline.

> + to be executed first.  Thanks to this feature, also tasks that do not
> + strictly comply with the "traditional" real-time task model (see Section 3)
> + can effectively use the new policy.
> +
> + In more details, the CBS algorithm assigns scheduling deadlines to
> + tasks in the following way:
> +
> +  - Each SCHED_DEADLINE task is characterised by the "runtime",
> +    "deadline", and "period" parameters;
> +
> +  - The state of the task is described by a "scheduling deadline", and
> +    a "current runtime". These two parameters are initially set to 0;
> +
> +  - When a SCHED_DEADLINE task wakes up (becomes ready for execution),
> +    the scheduler checks if
> +
> +                    current runtime                runtime
> +         ---------------------------------- > ----------------
> +         scheduling deadline - current time         period

Just a nit on formatting above. I was confused at first because the
above looks more like a movement in time (the > being an arrow), then
after reading the below, I realized that the above is actually an
equation. This can be fixed by adding more spaces between the fractions
and the greater than sign:

                 current runtime                      runtime
      ----------------------------------    >    ----------------
      scheduling deadline - current time               period


See, it no longer looks like a timeline:

     ---------------------------------- > ----------------


> +
> +    then, if the scheduling deadline is smaller than the current time, or
> +    this condition is verified, the scheduling deadline and the
> +    current budget are re-initialised as
> +
> +         scheduling deadline = current time + deadline
> +         current runtime = runtime
> +
> +    otherwise, the scheduling deadline and the current runtime are
> +    left unchanged;

I've been trying to wrap my head around this a bit. I started writing
an email about this when I first examined the patches and never sent it
out :-p

Lets take a case where deadline == period. It seems that the above
would be true any time there was any delay to starting the task or the
task was interrupted by another SCHED_DEADLINE task.

For example, lets say we have two SD tasks. One that has 50ms runtime
and a 100ms period. The other has a 1ms runtime and a 10ms period.

The above two should work perfectly fine together. The 10ms period task
will constantly schedule in on the 100ms task.

When the 100ms task runs, it could easily be delayed by 1ms due to the
10ms task. Then lets look at the above equation


50/99  >  50/100

That statement is true. Then I guess you make scheduling deadline =
current time + deadline, and leave the period alone? Then we run until
the next 10ms period. Get scheduled out by the 10ms task, and then
rescheduled back in. Looking at that we should have something like this:


(50 - 10) / (100 - 10 - 1)  = 40/89 which is less than 50/100

I haven't analyzed this down to see how this actually works, I have to
read the CBS papers. But is this what is expected?


> +
> +  - When a SCHED_DEADLINE task executes for an amount of time t, its
> +    current runtime is decreased as
> +
> +         current runtime = current runtime - t
> +
> +    (technically, the runtime is decreased at every tick, or when the
> +    task is descheduled / preempted);
> +
> +  - When the current runtime becomes less or equal than 0, the task is
> +    said to be "throttled" (also known as "depleted" in real-time literature)
> +    and cannot be scheduled until its scheduling deadline. The "replenishment
> +    time" for this task (see next item) is set to be equal to the current
> +    value of the scheduling deadline;
> +
> +  - When the current time is equal to the replenishment time of a
> +    throttled task, the scheduling deadline and the current runtime are
> +    updated as
> +
> +         scheduling deadline = scheduling deadline + period
> +         current runtime = current runtime + runtime
> +
> +
> +3. Scheduling Real-Time Tasks
> +=============================
> +
> + * BIG FAT WARNING ******************************************************
> + *
> + * This section contains a (not-thorough) summary on classical deadline
> + * scheduling theory, and how it applies to SCHED_DEADLINE.
> + * The reader can "safely" skip to Section 4 if only interested in seeing
> + * how the scheduling policy can be used. Anyway, we strongly recommend
> + * to come back here and continue reading (once the urge for testing is
> + * satisfied :P) to be sure of fully understanding all technical details.
> + ************************************************************************
> +
> + There are no limitations on what kind of task can exploit this new
> + scheduling discipline, even if it must be said that it is particularly
> + suited for periodic or sporadic real-time tasks that need guarantees on their
> + timing behavior, e.g., multimedia, streaming, control applications, etc.
> +
> + A typical real-time task is composed of a repetition of computation phases
> + (task instances, or jobs) which are activated on a periodic or sporadic
> + fashion.
> + Each job J_j (where J_j is the j^th job of the task) is characterised by an
> + arrival time r_j (the time when the job starts), an amount of computation
> + time c_j needed to finish the job, and a job absolute deadline d_j, which
> + is the time within which the job should be finished. The maximum execution
> + time max_j{c_j} is called "Worst Case Execution Time" (WCET) for the task.
> + A real-time task can be periodic with period P if r_{j+1} = r_j + P, or
> + sporadic with minimum inter-arrival time P is r_{j+1} >= r_j + P. Finally,
> + d_j = r_j + D, where D is the task's relative deadline.
> +
> + SCHED_DEADLINE can be used to schedule real-time tasks guaranteeing that
> + the jobs' deadlines of a task are respected. In order to do this, a task
> + must be scheduled by setting:
> +
> +  - runtime >= WCET
> +  - deadline = D
> +  - period <= P
> +
> + IOW, if runtime >= WCET and if period is >= P, then the scheduling deadlines
> + and the absolute deadlines (d_j) coincide, so a proper admission control
> + allows to respect the jobs' absolute deadlines for this task (this is what is
> + called "hard schedulability property" and is an extension of Lemma 1 of [2]).

I wonder if we should state the obvious (which is never obvious). That
is the user must also have the following.

  runtime < deadline <= period

Although it is fine for deadline = period, runtime should be less than
deadline, otherwise the task will take over the system.

> +
> + References:
> +  1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogram-
> +      ming in a hard-real-time environment. Journal of the Association for
> +      Computing Machinery, 20(1), 1973.
> +  2 - L. Abeni , G. Buttazzo. Integrating Multimedia Applications in Hard
> +      Real-Time Systems. Proceedings of the 19th IEEE Real-time Systems
> +      Symposium, 1998. http://retis.sssup.it/~giorgio/paps/1998/rtss98-cbs.pdf
> +  3 - L. Abeni. Server Mechanisms for Multimedia Applications. ReTiS Lab
> +      Technical Report. http://xoomer.virgilio.it/lucabe72/pubs/tr-98-01.ps
> +
> +4. Bandwidth management
> +=======================
> +
> + In order for the -deadline scheduling to be effective and useful, it is
> + important to have some method to keep the allocation of the available CPU
> + bandwidth to the tasks under control.
> + This is usually called "admission control" and if it is not performed at all,
> + no guarantee can be given on the actual scheduling of the -deadline tasks.
> +
> + Since when RT-throttling has been introduced each task group has a bandwidth
> + associated, calculated as a certain amount of runtime over a period.

The above sentence doesn't make any sense. Most notably the "Since
when". As that is something my teenage daughter usually shots at me
when I tell her she needs to do one of her chores.


> + Moreover, to make it possible to manipulate such bandwidth, readable/writable
> + controls have been added to both procfs (for system wide settings) and cgroupfs
> + (for per-group settings).
> + Therefore, the same interface is being used for controlling the bandwidth
> + distrubution to -deadline tasks.

The last sentence above is also confusing. We added controls to proc
and cgroupfs, but then state the same interface is being used. Do you
mean that the proc and cgroupfs have the same type of interface for
each? Perhaps say something like "the same interface files are being
used in both locations".

> +
> + However, more discussion is needed in order to figure out how we want to manage
> + SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEADLINE
> + uses (for now) a less sophisticated, but actually very sensible, mechanism to
> + ensure that a certain utilization cap is not overcome per each root_domain.

What mechanism is this?

> +
> + Another main difference between deadline bandwidth management and RT-throttling
> + is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
> + and thus we don't need an higher level throttling mechanism to enforce the
> + desired bandwidth.
> +
> +4.1 System wide settings
> +------------------------


The rest looks good.

-- Steve
