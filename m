Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaAUKYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:24:44 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50734 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaAUKYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:24:40 -0500
Date: Tue, 21 Jan 2014 11:21:27 +0100
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com, rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140121102126.GB12002@austad.us>
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
 <20140120112442.GA8907@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120112442.GA8907@austad.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 12:24:42PM +0100, Henrik Austad wrote:
> On Mon, Jan 20, 2014 at 11:40:40AM +0100, Juri Lelli wrote:
> > From: Dario Faggioli <raistlin@linux.it>
> > 
> > Add in Documentation/scheduler/ some hints about the design
> > choices, the usage and the future possible developments of the
> > sched_dl scheduling class and of the SCHED_DEADLINE policy.
> > [...]


> > +++ b/Documentation/scheduler/sched-deadline.txt
> > @@ -0,0 +1,189 @@
> > +			  Deadline Task Scheduling
> > +			  ------------------------
> > +
> > +CONTENTS
> > +========
> > +
> > + 0. WARNING
> > + 1. Overview
> > + 2. Task scheduling
> > + 2. The Interface
      ^^^^^
 I just noticed, where did this one go?

-- 
H

> > + 3. Bandwidth management
> > +   3.1 System-wide settings
> > +   3.2 Task interface
> > +   3.4 Default behavior
> > + 4. Tasks CPU affinity
> > +   4.1 SCHED_DEADLINE and cpusets HOWTO
> > + 5. Future plans
> > +
> > +
> > +0. WARNING
> > +==========
> > +
> > + Fiddling with these settings can result in an unpredictable or even unstable
> > + system behavior. As for -rt (group) scheduling, it is assumed that root users
> > + know what they're doing.
> > +
> > +
> > +1. Overview
> > +===========
> > +
> > + The SCHED_DEADLINE policy contained inside the sched_dl scheduling class is
> > + basically an implementation of the Earliest Deadline First (EDF) scheduling
> > + algorithm, augmented with a mechanism (called Constant Bandwidth Server, CBS)
> > + that makes it possible to isolate the behavior of tasks between each other.
> 
> 
> Why not something along the lines of giving a task a guaranteed slice of 
> the CPU as well as making sure that a task takes no more than a given 
> slice? I.e. making the point of a lower as well as an upper limit of CPU 
> usage.
> 
> > +2. Task scheduling
> > +==================
> > +
> > + The typical -deadline task is composed of a computation phase (instance)
> > + which is activated on a periodic or sporadic fashion. The expected (maximum)
> > + duration of such computation is called the task's runtime; the time interval
> > + by which each instance needs to be completed is called the task's relative
> > + deadline. The task's absolute deadline is dynamically calculated as the
> > + time instant a task (or, more properly) activates plus the relative
> > + deadline.
> 
> activates - released?
> 
> Since real-time papers from different rt-campus around the academia insist 
> on using *slightly* different terminology, perhaps add a short dictionary 
> for some of the more common terms?
> 
> D: relative deadline, typically N ms after release
> d: absolute deadline, the physical time when a given instance of a job 
>    needs to be completed
> R: relative release time, for periodic tasks, this is typically 'every N 
>    ms'
> r: absolute release time
> C: Worst-case execution time
> 
>    ...you get the idea.
> 
> Perhaps too academic?
> 
> > + The EDF[1] algorithm selects the task with the smallest absolute deadline as
> > + the one to be executed first, while the CBS[2,3] ensures that each task runs
> > + for at most its runtime every period, avoiding any interference between
> > + different tasks (bandwidth isolation).
> > + Thanks to this feature, also tasks that do not strictly comply with the
> > + computational model described above can effectively use the new policy.
> > + IOW, there are no limitations on what kind of task can exploit this new
> > + scheduling discipline, even if it must be said that it is particularly
> > + suited for periodic or sporadic tasks that need guarantees on their
> > + timing behavior, e.g., multimedia, streaming, control applications, etc.
> 
> I assume that ties are broken arbitrarily and that a running task is not 
> preempted for another task with equal deadline. Correct?
> 
> This would be a nice point to include in this doc methinks.
> 
> > + References:
> > +  1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogram-
> > +      ming in a hard-real-time environment. Journal of the Association for
> > +      Computing Machinery, 20(1), 1973.
> > +  2 - L. Abeni , G. Buttazzo. Integrating Multimedia Applications in Hard
> > +      Real-Time Systems. Proceedings of the 19th IEEE Real-time Systems
> > +      Symposium, 1998. http://retis.sssup.it/~giorgio/paps/1998/rtss98-cbs.pdf
> > +  3 - L. Abeni. Server Mechanisms for Multimedia Applications. ReTiS Lab
> > +      Technical Report. http://xoomer.virgilio.it/lucabe72/pubs/tr-98-01.ps
> > +
> > +3. Bandwidth management
> > +=======================
> > +
> > + In order for the -deadline scheduling to be effective and useful, it is
> > + important to have some method to keep the allocation of the available CPU
> > + bandwidth to the tasks under control.
> > + This is usually called "admission control" and if it is not performed at all,
> > + no guarantee can be given on the actual scheduling of the -deadline tasks.
> > +
> > + Since when RT-throttling has been introduced each task group has a bandwidth
> > + associated, calculated as a certain amount of runtime over a period.
> > + Moreover, to make it possible to manipulate such bandwidth, readable/writable
> > + controls have been added to both procfs (for system wide settings) and cgroupfs
> > + (for per-group settings).
> > + Therefore, the same interface is being used for controlling the bandwidth
> > + distrubution to -deadline tasks.
> > +
> > + However, more discussion is needed in order to figure out how we want to manage
> > + SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEADLINE
> > + uses (for now) a less sophisticated, but actually very sensible, mechanism to
> > + ensure that a certain utilization cap is not overcome per each root_domain.
> > +
> > + Another main difference between deadline bandwidth management and RT-throttling
> > + is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
> > + and thus we don't need an higher level throttling mechanism to enforce the
> > + desired bandwidth.
> > +
> > +3.1 System wide settings
> > +------------------------
> > +
> > + The system wide settings are configured under the /proc virtual file system.
> > +
> > + For now the -rt knobs are used for dl admission control and the -deadline
> > + runtime is accounted against the -rt runtime. We realise that this isn't
> > + entirely desirable; however, it is better to have a small interface for now,
> > + and be able to change it easily later. The ideal situation (see 5.) is to run
> > + -rt tasks from a -deadline server; in which case the -rt bandwidth is a direct
> > + subset of dl_bw.
> > +
> > + This means that, for a root_domain comprising M CPUs, -deadline tasks
> > + can be created while the sum of their bandwidths stays below:
> > +
> > +   M * (sched_rt_runtime_us / sched_rt_period_us)
> > +
> > + It is also possible to disable this bandwidth management logic, and
> > + be thus free of oversubscribing the system up to any arbitrary level.
> > + This is done by writing -1 in /proc/sys/kernel/sched_rt_runtime_us.
> > +
> > +
> > +3.2 Task interface
> > +------------------
> > +
> > + Specifying a periodic/sporadic task that executes for a given amount of
> > + runtime at each instance, and that is scheduled according to the urgency of
> > + its own timing constraints needs, in general, a way of declaring:
> > +  - a (maximum/typical) instance execution time,
> > +  - a minimum interval between consecutive instances,
> > +  - a time constraint by which each instance must be completed.
> > +
> > + Therefore:
> > +  * a new struct sched_attr, containing all the necessary fields is
> > +    provided;
> > +  * the new scheduling related syscalls that manipulate it, i.e.,
> > +    sched_setattr() and sched_getattr() are implemented.
> > +
> > +
> > +3.3 Default behavior
> > +---------------------
> > +
> > + The default value for SCHED_DEADLINE bandwidth is to have rt_runtime equal to
> > + 95000. With rt_period equal to 1000000, by default, it means that -deadline
>     ^^^^
>     This seems to be 9.5% to me ;)
> 
> > + tasks can use at most 95%, multiplied by the number of CPUs that compose the
> > + root_domain, for each root_domain.
> > +
> > + A -deadline task cannot fork.
> > +
> > +4. Tasks CPU affinity
> > +=====================
> > +
> > + -deadline tasks cannot have an affinity mask smaller that the entire
> > + root_domain they are created on. However, affinities can be specified
> > + through the cpuset facility (Documentation/cgroups/cpusets.txt).
> 
> Does this mean that sched_deadline is a somewhat global implementation? Or 
> rather, at what point in time will sched_deadline take all cpus in a set 
> into consideration and when will it only look at the current CPU? Where is 
> the line drawn between global and fully partitioned?
> 
> Also, how do you account the budget when a resource holder is boosted in 
> order to release a resource? (IIRC, you use BWI, right?)
> 
> > +4.1 SCHED_DEADLINE and cpusets HOWTO
> > +------------------------------------
> > +
> > + An example of a simple configuration (pin a -deadline task to CPU0)
> > + follows (rt-app is used to create a -deadline task).
> > +
> > + mkdir /dev/cpuset
> > + mount -t cgroup -o cpuset cpuset /dev/cpuset
> > + cd /dev/cpuset
> > + mkdir cpu0
> > + echo 0 > cpu0/cpuset.cpus
> > + echo 0 > cpu0/cpuset.mems
> > + echo 1 > cpuset.cpu_exclusive
> > + echo 0 > cpuset.sched_load_balance
> > + echo 1 > cpu0/cpuset.cpu_exclusive
> > + echo 1 > cpu0/cpuset.mem_exclusive
> > + echo $$ > cpu0/tasks
> > + rt-app -t 100000:10000:d:0 -D5 (it is now actually superfluous to specify
> > + task affinity)
> > +
> > +5. Future plans
> > +===============
> > +
> > + Still missing:
> > +
> > +  - refinements to deadline inheritance, especially regarding the possibility
> > +    of retaining bandwidth isolation among non-interacting tasks. This is
> > +    being studied from both theoretical and practical points of view, and
> > +    hopefully we should be able to produce some demonstrative code soon;
> > +  - (c)group based bandwidth management, and maybe scheduling;
> > +  - access control for non-root users (and related security concerns to
> > +    address), which is the best way to allow unprivileged use of the mechanisms
> > +    and how to prevent non-root users "cheat" the system?
> > +
> > + As already discussed, we are planning also to merge this work with the EDF
> > + throttling patches [https://lkml.org/lkml/2010/2/23/239] but we still are in
> > + the preliminary phases of the merge and we really seek feedback that would
> > + help us decide on the direction it should take.
> > diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> > index 0de2482..0dd5e09 100644
> > --- a/kernel/sched/deadline.c
> > +++ b/kernel/sched/deadline.c
> > @@ -351,7 +351,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
> >   * disrupting the schedulability of the system. Otherwise, we should
> >   * refill the runtime and set the deadline a period in the future,
> >   * because keeping the current (absolute) deadline of the task would
> > - * result in breaking guarantees promised to other tasks.
> > + * result in breaking guarantees promised to other tasks (refer to
> > + * Documentation/scheduler/sched-deadline.txt for more informations).
> >   *
> >   * This function returns true if:
> >   *
> > -- 
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Henrik Austad



-- 
Henrik Austad
