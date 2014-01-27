Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaA0LXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:23:46 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:39800 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaA0LXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:23:44 -0500
Message-ID: <52E641BC.6010608@gmail.com>
Date: Mon, 27 Jan 2014 12:23:40 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: peterz@infradead.org, tglx@linutronix.de
CC: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        linux-doc@vger.kernel.org, rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
In-Reply-To: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 12:20 PM, Juri Lelli wrote:
> From: Dario Faggioli <raistlin@linux.it>
> 
> Add in Documentation/scheduler/ some hints about the design
> choices, the usage and the future possible developments of the
> sched_dl scheduling class and of the SCHED_DEADLINE policy.
> 
> Cc: bruce.ashfield@windriver.com
> Cc: claudio@evidence.eu.com
> Cc: darren@dvhart.com
> Cc: dhaval.giani@gmail.com
> Cc: fchecconi@gmail.com
> Cc: fweisbec@gmail.com
> Cc: harald.gustafsson@ericsson.com
> Cc: hgu1972@gmail.com
> Cc: insop.song@gmail.com
> Cc: jkacur@redhat.com
> Cc: johan.eker@ericsson.com
> Cc: liming.wang@windriver.com
> Cc: michael@amarulasolutions.com
> Cc: mingo@redhat.com
> Cc: nicola.manica@disi.unitn.it
> Cc: oleg@redhat.com
> Cc: paulmck@linux.vnet.ibm.com
> Cc: p.faure@akatech.ch
> Cc: rob@landley.net
> Cc: rostedt@goodmis.org
> Cc: tglx@linutronix.de
> Cc: tommaso.cucinotta@sssup.it
> Cc: vincent.guittot@linaro.org
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> [ Re-wrote sections 2 and 3. ]
> Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
> ---
>  Documentation/scheduler/00-INDEX           |    2 +
>  Documentation/scheduler/sched-deadline.txt |  281 ++++++++++++++++++++++++++++
>  kernel/sched/deadline.c                    |    3 +-
>  3 files changed, 285 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/scheduler/sched-deadline.txt
> 
> diff --git a/Documentation/scheduler/00-INDEX b/Documentation/scheduler/00-INDEX
> index d2651c4..46702e4 100644
> --- a/Documentation/scheduler/00-INDEX
> +++ b/Documentation/scheduler/00-INDEX
> @@ -10,5 +10,7 @@ sched-nice-design.txt
>  	- How and why the scheduler's nice levels are implemented.
>  sched-rt-group.txt
>  	- real-time group scheduling.
> +sched-deadline.txt
> +	- deadline scheduling.
>  sched-stats.txt
>  	- information on schedstats (Linux Scheduler Statistics).
> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
> new file mode 100644
> index 0000000..18adc92
> --- /dev/null
> +++ b/Documentation/scheduler/sched-deadline.txt
> @@ -0,0 +1,281 @@
> +			  Deadline Task Scheduling
> +			  ------------------------
> +
> +CONTENTS
> +========
> +
> + 0. WARNING
> + 1. Overview
> + 2. Scheduling algorithm
> + 3. Scheduling Real-Time Tasks

We also plan to add here something more about admission control in the next future.


Best,

- Juri

> + 4. Bandwidth management
> +   4.1 System-wide settings
> +   4.2 Task interface
> +   4.3 Default behavior
> + 5. Tasks CPU affinity
> +   5.1 SCHED_DEADLINE and cpusets HOWTO
> + 6. Future plans
> +
> +
> +0. WARNING
> +==========
> +
> + Fiddling with these settings can result in an unpredictable or even unstable
> + system behavior. As for -rt (group) scheduling, it is assumed that root users
> + know what they're doing.
> +
> +
> +1. Overview
> +===========
> +
> + The SCHED_DEADLINE policy contained inside the sched_dl scheduling class is
> + basically an implementation of the Earliest Deadline First (EDF) scheduling
> + algorithm, augmented with a mechanism (called Constant Bandwidth Server, CBS)
> + that makes it possible to isolate the behavior of tasks between each other.
> +
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
> + guaranteed is respected if a proper "admission control" strategy (see Section
> + "4. Bandwidth management") is used.
> +
> + Summing up, the CBS[2,3] algorithms assigns scheduling deadlines to tasks so
> + that each task runs for at most its runtime every period, avoiding any
> + interference between different tasks (bandwidth isolation), while the EDF[1]
> + algorithm selects the task with the smallest scheduling deadline as the one
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
> + Moreover, to make it possible to manipulate such bandwidth, readable/writable
> + controls have been added to both procfs (for system wide settings) and cgroupfs
> + (for per-group settings).
> + Therefore, the same interface is being used for controlling the bandwidth
> + distrubution to -deadline tasks.
> +
> + However, more discussion is needed in order to figure out how we want to manage
> + SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEADLINE
> + uses (for now) a less sophisticated, but actually very sensible, mechanism to
> + ensure that a certain utilization cap is not overcome per each root_domain.
> +
> + Another main difference between deadline bandwidth management and RT-throttling
> + is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
> + and thus we don't need an higher level throttling mechanism to enforce the
> + desired bandwidth.
> +
> +4.1 System wide settings
> +------------------------
> +
> + The system wide settings are configured under the /proc virtual file system.
> +
> + For now the -rt knobs are used for dl admission control and the -deadline
> + runtime is accounted against the -rt runtime. We realise that this isn't
> + entirely desirable; however, it is better to have a small interface for now,
> + and be able to change it easily later. The ideal situation (see 5.) is to run
> + -rt tasks from a -deadline server; in which case the -rt bandwidth is a direct
> + subset of dl_bw.
> +
> + This means that, for a root_domain comprising M CPUs, -deadline tasks
> + can be created while the sum of their bandwidths stays below:
> +
> +   M * (sched_rt_runtime_us / sched_rt_period_us)
> +
> + It is also possible to disable this bandwidth management logic, and
> + be thus free of oversubscribing the system up to any arbitrary level.
> + This is done by writing -1 in /proc/sys/kernel/sched_rt_runtime_us.
> +
> +
> +4.2 Task interface
> +------------------
> +
> + Specifying a periodic/sporadic task that executes for a given amount of
> + runtime at each instance, and that is scheduled according to the urgency of
> + its own timing constraints needs, in general, a way of declaring:
> +  - a (maximum/typical) instance execution time,
> +  - a minimum interval between consecutive instances,
> +  - a time constraint by which each instance must be completed.
> +
> + Therefore:
> +  * a new struct sched_attr, containing all the necessary fields is
> +    provided;
> +  * the new scheduling related syscalls that manipulate it, i.e.,
> +    sched_setattr() and sched_getattr() are implemented.
> +
> +
> +4.3 Default behavior
> +---------------------
> +
> + The default value for SCHED_DEADLINE bandwidth is to have rt_runtime equal to
> + 950000. With rt_period equal to 1000000, by default, it means that -deadline
> + tasks can use at most 95%, multiplied by the number of CPUs that compose the
> + root_domain, for each root_domain.
> +
> + A -deadline task cannot fork.
> +
> +5. Tasks CPU affinity
> +=====================
> +
> + -deadline tasks cannot have an affinity mask smaller that the entire
> + root_domain they are created on. However, affinities can be specified
> + through the cpuset facility (Documentation/cgroups/cpusets.txt).
> +
> +5.1 SCHED_DEADLINE and cpusets HOWTO
> +------------------------------------
> +
> + An example of a simple configuration (pin a -deadline task to CPU0)
> + follows (rt-app is used to create a -deadline task).
> +
> + mkdir /dev/cpuset
> + mount -t cgroup -o cpuset cpuset /dev/cpuset
> + cd /dev/cpuset
> + mkdir cpu0
> + echo 0 > cpu0/cpuset.cpus
> + echo 0 > cpu0/cpuset.mems
> + echo 1 > cpuset.cpu_exclusive
> + echo 0 > cpuset.sched_load_balance
> + echo 1 > cpu0/cpuset.cpu_exclusive
> + echo 1 > cpu0/cpuset.mem_exclusive
> + echo $$ > cpu0/tasks
> + rt-app -t 100000:10000:d:0 -D5 (it is now actually superfluous to specify
> + task affinity)
> +
> +6. Future plans
> +===============
> +
> + Still missing:
> +
> +  - refinements to deadline inheritance, especially regarding the possibility
> +    of retaining bandwidth isolation among non-interacting tasks. This is
> +    being studied from both theoretical and practical points of view, and
> +    hopefully we should be able to produce some demonstrative code soon;
> +  - (c)group based bandwidth management, and maybe scheduling;
> +  - access control for non-root users (and related security concerns to
> +    address), which is the best way to allow unprivileged use of the mechanisms
> +    and how to prevent non-root users "cheat" the system?
> +
> + As already discussed, we are planning also to merge this work with the EDF
> + throttling patches [https://lkml.org/lkml/2010/2/23/239] but we still are in
> + the preliminary phases of the merge and we really seek feedback that would
> + help us decide on the direction it should take.
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 0de2482..0dd5e09 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -351,7 +351,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
>   * disrupting the schedulability of the system. Otherwise, we should
>   * refill the runtime and set the deadline a period in the future,
>   * because keeping the current (absolute) deadline of the task would
> - * result in breaking guarantees promised to other tasks.
> + * result in breaking guarantees promised to other tasks (refer to
> + * Documentation/scheduler/sched-deadline.txt for more informations).
>   *
>   * This function returns true if:
>   *
> 
