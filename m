Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaA0LzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:55:20 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57546 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaA0LzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:55:16 -0500
Date: Mon, 27 Jan 2014 12:53:16 +0100
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
        bruce.ashfield@windriver.com, linux-doc@vger.kernel.org,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140127115316.GA16595@austad.us>
References: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 12:20:15PM +0100, Juri Lelli wrote:
> From: Dario Faggioli <raistlin@linux.it>
>=20
> Add in Documentation/scheduler/ some hints about the design
> choices, the usage and the future possible developments of the
> sched_dl scheduling class and of the SCHED_DEADLINE policy.
>=20
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
>  Documentation/scheduler/sched-deadline.txt |  281 ++++++++++++++++++++++=
++++++
>  kernel/sched/deadline.c                    |    3 +-
>  3 files changed, 285 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/scheduler/sched-deadline.txt
>=20
> diff --git a/Documentation/scheduler/00-INDEX b/Documentation/scheduler/0=
0-INDEX
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
> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/s=
cheduler/sched-deadline.txt
> new file mode 100644
> index 0000000..18adc92
> --- /dev/null
> +++ b/Documentation/scheduler/sched-deadline.txt
> @@ -0,0 +1,281 @@
> +			  Deadline Task Scheduling
> +			  ------------------------
> +
> +CONTENTS
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + 0. WARNING
> + 1. Overview
> + 2. Scheduling algorithm
> + 3. Scheduling Real-Time Tasks
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
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + Fiddling with these settings can result in an unpredictable or even uns=
table
> + system behavior. As for -rt (group) scheduling, it is assumed that root=
 users
> + know what they're doing.
> +
> +
> +1. Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + The SCHED_DEADLINE policy contained inside the sched_dl scheduling clas=
s is
> + basically an implementation of the Earliest Deadline First (EDF) schedu=
ling
> + algorithm, augmented with a mechanism (called Constant Bandwidth Server=
, CBS)
> + that makes it possible to isolate the behavior of tasks between each ot=
her.
> +
> +
> +2. Scheduling algorithm
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + SCHED_DEADLINE uses three parameters, named "runtime", "period", and
> + "deadline" to schedule tasks. A SCHED_DEADLINE task is guaranteed to re=
ceive
> + "runtime" microseconds of execution time every "period" microseconds, a=
nd
> + these "runtime" microseconds are available within "deadline" microsecon=
ds
> + from the beginning of the period.  In order to implement this behaviour,
> + every time the task wakes up, the scheduler computes a "scheduling dead=
line"
> + consistent with the guarantee (using the CBS[2,3] algorithm). Tasks are=
 then
> + scheduled using EDF[1] on these scheduling deadlines (the task with the
> + smallest scheduling deadline is selected for execution). Notice that th=
is
> + guaranteed is respected if a proper "admission control" strategy (see S=
ection
> + "4. Bandwidth management") is used.
> +
> + Summing up, the CBS[2,3] algorithms assigns scheduling deadlines to tas=
ks so
> + that each task runs for at most its runtime every period, avoiding any
> + interference between different tasks (bandwidth isolation), while the E=
DF[1]
> + algorithm selects the task with the smallest scheduling deadline as the=
 one
> + to be executed first.  Thanks to this feature, also tasks that do not
> + strictly comply with the "traditional" real-time task model (see Sectio=
n 3)
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

Current runtime: time spent running _this_ period? or is _remaining_=20
runtime this period? I get the feeling it's the latter.

So, roughly, it is the ration

      remaining_runtime / relative_time_to_deadline=20

which needs to be greater than the assigned CPU bandwidth, and if so, the=
=20
budget should be replensihed?

Shouldn't there be something about not refilling the budget before a new=20
period has started?

> +         scheduling deadline =3D current time + deadline
> +         current runtime =3D runtime
> +
> +    otherwise, the scheduling deadline and the current runtime are
> +    left unchanged;
> +
> +  - When a SCHED_DEADLINE task executes for an amount of time t, its
> +    current runtime is decreased as
> +
> +         current runtime =3D current runtime - t
> +
> +    (technically, the runtime is decreased at every tick, or when the
> +    task is descheduled / preempted);

Aha, there it is. Having it here makes sense, but it does wrapping ones=20
head around this a bit harder than strictly necessary perhaps.

> +  - When the current runtime becomes less or equal than 0, the task is
> +    said to be "throttled" (also known as "depleted" in real-time litera=
ture)
> +    and cannot be scheduled until its scheduling deadline. The "replenis=
hment
> +    time" for this task (see next item) is set to be equal to the current
> +    value of the scheduling deadline;
> +
> +  - When the current time is equal to the replenishment time of a
> +    throttled task, the scheduling deadline and the current runtime are
> +    updated as
> +
> +         scheduling deadline =3D scheduling deadline + period
> +         current runtime =3D current runtime + runtime

ok, this section makes sense now

> +3. Scheduling Real-Time Tasks
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> + * BIG FAT WARNING ******************************************************
> + *
> + * This section contains a (not-thorough) summary on classical deadline
> + * scheduling theory, and how it applies to SCHED_DEADLINE.

"This section should not be considered a complete summary of classical=20
deadline scheduling theroy in any way AT ALL."

(not-thorough sounds a bit strange)

> + * The reader can "safely" skip to Section 4 if only interested in seeing
> + * how the scheduling policy can be used. Anyway, we strongly recommend
> + * to come back here and continue reading (once the urge for testing is
> + * satisfied :P) to be sure of fully understanding all technical details.
> + ************************************************************************
> +
> + There are no limitations on what kind of task can exploit this new
> + scheduling discipline, even if it must be said that it is particularly
> + suited for periodic or sporadic real-time tasks that need guarantees on=
 their
> + timing behavior, e.g., multimedia, streaming, control applications, etc.
> +
> + A typical real-time task is composed of a repetition of computation pha=
ses
> + (task instances, or jobs) which are activated on a periodic or sporadic
> + fashion.
> + Each job J_j (where J_j is the j^th job of the task) is characterised b=
y an
> + arrival time r_j (the time when the job starts), an amount of computati=
on
> + time c_j needed to finish the job, and a job absolute deadline d_j, whi=
ch
> + is the time within which the job should be finished. The maximum execut=
ion
> + time max_j{c_j} is called "Worst Case Execution Time" (WCET) for the ta=
sk.
> + A real-time task can be periodic with period P if r_{j+1} =3D r_j + P, =
or
> + sporadic with minimum inter-arrival time P is r_{j+1} >=3D r_j + P. Fin=
ally,
> + d_j =3D r_j + D, where D is the task's relative deadline.

\o/

Great, thanks!

> + SCHED_DEADLINE can be used to schedule real-time tasks guaranteeing that
> + the jobs' deadlines of a task are respected. In order to do this, a task
> + must be scheduled by setting:
> +
> +  - runtime >=3D WCET
> +  - deadline =3D D
> +  - period <=3D P
> +
> + IOW, if runtime >=3D WCET and if period is >=3D P, then the scheduling =
deadlines
> + and the absolute deadlines (d_j) coincide, so a proper admission control
> + allows to respect the jobs' absolute deadlines for this task (this is w=
hat is
> + called "hard schedulability property" and is an extension of Lemma 1 of=
 [2]).
> +
> + References:
> +  1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogra=
m-
> +      ming in a hard-real-time environment. Journal of the Association f=
or
> +      Computing Machinery, 20(1), 1973.
> +  2 - L. Abeni , G. Buttazzo. Integrating Multimedia Applications in Hard
> +      Real-Time Systems. Proceedings of the 19th IEEE Real-time Systems
> +      Symposium, 1998. http://retis.sssup.it/~giorgio/paps/1998/rtss98-c=
bs.pdf
> +  3 - L. Abeni. Server Mechanisms for Multimedia Applications. ReTiS Lab
> +      Technical Report. http://xoomer.virgilio.it/lucabe72/pubs/tr-98-01=
=2Eps
> +
> +4. Bandwidth management
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + In order for the -deadline scheduling to be effective and useful, it is
> + important to have some method to keep the allocation of the available C=
PU
> + bandwidth to the tasks under control.
> + This is usually called "admission control" and if it is not performed a=
t all,
> + no guarantee can be given on the actual scheduling of the -deadline tas=
ks.
> +
> + Since when RT-throttling has been introduced each task group has a band=
width
> + associated, calculated as a certain amount of runtime over a period.
> + Moreover, to make it possible to manipulate such bandwidth, readable/wr=
itable
> + controls have been added to both procfs (for system wide settings) and =
cgroupfs
> + (for per-group settings).
> + Therefore, the same interface is being used for controlling the bandwid=
th
> + distrubution to -deadline tasks.
> +
> + However, more discussion is needed in order to figure out how we want t=
o manage
> + SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEAD=
LINE
> + uses (for now) a less sophisticated, but actually very sensible, mechan=
ism to
> + ensure that a certain utilization cap is not overcome per each root_dom=
ain.
> +
> + Another main difference between deadline bandwidth management and RT-th=
rottling
> + is that -deadline tasks have bandwidth on their own (while -rt ones don=
't!),
> + and thus we don't need an higher level throttling mechanism to enforce =
the
> + desired bandwidth.
> +
> +4.1 System wide settings
> +------------------------
> +
> + The system wide settings are configured under the /proc virtual file sy=
stem.
> +
> + For now the -rt knobs are used for dl admission control and the -deadli=
ne
> + runtime is accounted against the -rt runtime. We realise that this isn't
> + entirely desirable; however, it is better to have a small interface for=
 now,
> + and be able to change it easily later. The ideal situation (see 5.) is =
to run
> + -rt tasks from a -deadline server; in which case the -rt bandwidth is a=
 direct
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
> + runtime at each instance, and that is scheduled according to the urgenc=
y of
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
> + The default value for SCHED_DEADLINE bandwidth is to have rt_runtime eq=
ual to
> + 950000. With rt_period equal to 1000000, by default, it means that -dea=
dline
> + tasks can use at most 95%, multiplied by the number of CPUs that compos=
e the
> + root_domain, for each root_domain.
> +
> + A -deadline task cannot fork.
> +
> +5. Tasks CPU affinity
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> + rt-app -t 100000:10000:d:0 -D5 (it is now actually superfluous to speci=
fy
> + task affinity)
> +
> +6. Future plans
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + Still missing:
> +
> +  - refinements to deadline inheritance, especially regarding the possib=
ility
> +    of retaining bandwidth isolation among non-interacting tasks. This is
> +    being studied from both theoretical and practical points of view, and
> +    hopefully we should be able to produce some demonstrative code soon;
> +  - (c)group based bandwidth management, and maybe scheduling;
> +  - access control for non-root users (and related security concerns to
> +    address), which is the best way to allow unprivileged use of the mec=
hanisms
> +    and how to prevent non-root users "cheat" the system?
> +
> + As already discussed, we are planning also to merge this work with the =
EDF
> + throttling patches [https://lkml.org/lkml/2010/2/23/239] but we still a=
re in
> + the preliminary phases of the merge and we really seek feedback that wo=
uld
> + help us decide on the direction it should take.
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 0de2482..0dd5e09 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -351,7 +351,8 @@ static void replenish_dl_entity(struct sched_dl_entit=
y *dl_se,
>   * disrupting the schedulability of the system. Otherwise, we should
>   * refill the runtime and set the deadline a period in the future,
>   * because keeping the current (absolute) deadline of the task would
> - * result in breaking guarantees promised to other tasks.
> + * result in breaking guarantees promised to other tasks (refer to
> + * Documentation/scheduler/sched-deadline.txt for more informations).
>   *
>   * This function returns true if:
>   *
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Nice! /me is very happy

Reviewed-by: Henrik Austad <henrik@austad.us>

--=20
Henrik Austad

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLmSKwACgkQ6k5VT6v45lmEVACdE+H8NnAywPo0DXolQk6QxTqn
QecAoNM7Gw9jYc3Sh9amvIF5OwtQLDDd
=M55+
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
