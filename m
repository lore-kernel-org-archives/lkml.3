Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaATL0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:26:35 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:32997 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaATL0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:26:33 -0500
Date: Mon, 20 Jan 2014 12:24:42 +0100
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
Message-ID: <20140120112442.GA8907@austad.us>
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2014 at 11:40:40AM +0100, Juri Lelli wrote:
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
> Cc: luca.abeni@unitn.it
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
> ---
>  Documentation/scheduler/00-INDEX           |    2 +
>  Documentation/scheduler/sched-deadline.txt |  189 ++++++++++++++++++++++=
++++++
>  kernel/sched/deadline.c                    |    3 +-
>  3 files changed, 193 insertions(+), 1 deletion(-)
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
> index 0000000..8980de1
> --- /dev/null
> +++ b/Documentation/scheduler/sched-deadline.txt
> @@ -0,0 +1,189 @@
> +			  Deadline Task Scheduling
> +			  ------------------------
> +
> +CONTENTS
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + 0. WARNING
> + 1. Overview
> + 2. Task scheduling
> + 2. The Interface
> + 3. Bandwidth management
> +   3.1 System-wide settings
> +   3.2 Task interface
> +   3.4 Default behavior
> + 4. Tasks CPU affinity
> +   4.1 SCHED_DEADLINE and cpusets HOWTO
> + 5. Future plans
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


Why not something along the lines of giving a task a guaranteed slice of=20
the CPU as well as making sure that a task takes no more than a given=20
slice? I.e. making the point of a lower as well as an upper limit of CPU=20
usage.

> +2. Task scheduling
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + The typical -deadline task is composed of a computation phase (instance)
> + which is activated on a periodic or sporadic fashion. The expected (max=
imum)
> + duration of such computation is called the task's runtime; the time int=
erval
> + by which each instance needs to be completed is called the task's relat=
ive
> + deadline. The task's absolute deadline is dynamically calculated as the
> + time instant a task (or, more properly) activates plus the relative
> + deadline.

activates - released?

Since real-time papers from different rt-campus around the academia insist=
=20
on using *slightly* different terminology, perhaps add a short dictionary=
=20
for some of the more common terms?

D: relative deadline, typically N ms after release
d: absolute deadline, the physical time when a given instance of a job=20
   needs to be completed
R: relative release time, for periodic tasks, this is typically 'every N=20
   ms'
r: absolute release time
C: Worst-case execution time

   ...you get the idea.

Perhaps too academic?

> + The EDF[1] algorithm selects the task with the smallest absolute deadli=
ne as
> + the one to be executed first, while the CBS[2,3] ensures that each task=
 runs
> + for at most its runtime every period, avoiding any interference between
> + different tasks (bandwidth isolation).
> + Thanks to this feature, also tasks that do not strictly comply with the
> + computational model described above can effectively use the new policy.
> + IOW, there are no limitations on what kind of task can exploit this new
> + scheduling discipline, even if it must be said that it is particularly
> + suited for periodic or sporadic tasks that need guarantees on their
> + timing behavior, e.g., multimedia, streaming, control applications, etc.

I assume that ties are broken arbitrarily and that a running task is not=20
preempted for another task with equal deadline. Correct?

This would be a nice point to include in this doc methinks.

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
> +3. Bandwidth management
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
> +3.1 System wide settings
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
> +3.2 Task interface
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
> +3.3 Default behavior
> +---------------------
> +
> + The default value for SCHED_DEADLINE bandwidth is to have rt_runtime eq=
ual to
> + 95000. With rt_period equal to 1000000, by default, it means that -dead=
line
    ^^^^
    This seems to be 9.5% to me ;)

> + tasks can use at most 95%, multiplied by the number of CPUs that compos=
e the
> + root_domain, for each root_domain.
> +
> + A -deadline task cannot fork.
> +
> +4. Tasks CPU affinity
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> + -deadline tasks cannot have an affinity mask smaller that the entire
> + root_domain they are created on. However, affinities can be specified
> + through the cpuset facility (Documentation/cgroups/cpusets.txt).

Does this mean that sched_deadline is a somewhat global implementation? Or=
=20
rather, at what point in time will sched_deadline take all cpus in a set=20
into consideration and when will it only look at the current CPU? Where is=
=20
the line drawn between global and fully partitioned?

Also, how do you account the budget when a resource holder is boosted in=20
order to release a resource? (IIRC, you use BWI, right?)

> +4.1 SCHED_DEADLINE and cpusets HOWTO
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
> +5. Future plans
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
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Henrik Austad

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLdB3oACgkQ6k5VT6v45lnpuACfckAKMe7aWV79TCOIsYhwJuwY
1G0AniEZ3qj+/6nm4Z0kgNgdgrokfPac
=q9fh
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
