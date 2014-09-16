Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaIPK7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:59:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaIPK6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:58:35 -0400
Date: Tue, 16 Sep 2014 03:57:17 -0700
From: tip-bot for Luca Abeni <tipbot@zytor.com>
Message-ID: <tip-b56bfc6cd13c25264f614320de9183a5dbcab6ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luca.abeni@unitn.it, hpa@zytor.com,
        mingo@kernel.org, henrik@austad.us, torvalds@linux-foundation.org,
        peterz@infradead.org, rdunlap@infradead.org, raistlin@linux.it,
        juri.lelli@arm.com, tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, henrik@austad.us,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, raistlin@linux.it, juri.lelli@arm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1410256636-26171-4-git-send-email-juri.lelli@arm.com>
References: <1410256636-26171-4-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] Documentation/scheduler/sched-deadline.txt:
  Improve and clarify AC bits
Git-Commit-ID: b56bfc6cd13c25264f614320de9183a5dbcab6ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b56bfc6cd13c25264f614320de9183a5dbcab6ca
Gitweb:     http://git.kernel.org/tip/b56bfc6cd13c25264f614320de9183a5dbcab6ca
Author:     Luca Abeni <luca.abeni@unitn.it>
AuthorDate: Tue, 9 Sep 2014 10:57:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 10:23:01 +0200

Documentation/scheduler/sched-deadline.txt: Improve and clarify AC bits

Admission control is of key importance for SCHED_DEADLINE, since
it guarantees system schedulability (or tells us something about
the degree of guarantees we can provide to the user).

This patch improves and clarifies bits and pieces regarding AC,
both for UP and SMP systems.

Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Reviewed-by: Henrik Austad <henrik@austad.us>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410256636-26171-4-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/scheduler/sched-deadline.txt | 99 +++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 17 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index f75d832..0ce5e2c 100644
--- a/Documentation/scheduler/sched-deadline.txt
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -38,16 +38,17 @@ CONTENTS
 ==================
 
  SCHED_DEADLINE uses three parameters, named "runtime", "period", and
- "deadline" to schedule tasks. A SCHED_DEADLINE task is guaranteed to receive
+ "deadline", to schedule tasks. A SCHED_DEADLINE task should receive
  "runtime" microseconds of execution time every "period" microseconds, and
  these "runtime" microseconds are available within "deadline" microseconds
  from the beginning of the period.  In order to implement this behaviour,
  every time the task wakes up, the scheduler computes a "scheduling deadline"
  consistent with the guarantee (using the CBS[2,3] algorithm). Tasks are then
  scheduled using EDF[1] on these scheduling deadlines (the task with the
- earliest scheduling deadline is selected for execution). Notice that this
- guaranteed is respected if a proper "admission control" strategy (see Section
- "4. Bandwidth management") is used.
+ earliest scheduling deadline is selected for execution). Notice that the
+ task actually receives "runtime" time units within "deadline" if a proper
+ "admission control" strategy (see Section "4. Bandwidth management") is used
+ (clearly, if the system is overloaded this guarantee cannot be respected).
 
  Summing up, the CBS[2,3] algorithms assigns scheduling deadlines to tasks so
  that each task runs for at most its runtime every period, avoiding any
@@ -134,6 +135,50 @@ CONTENTS
  A real-time task can be periodic with period P if r_{j+1} = r_j + P, or
  sporadic with minimum inter-arrival time P is r_{j+1} >= r_j + P. Finally,
  d_j = r_j + D, where D is the task's relative deadline.
+ The utilisation of a real-time task is defined as the ratio between its
+ WCET and its period (or minimum inter-arrival time), and represents
+ the fraction of CPU time needed to execute the task.
+
+ If the total utilisation sum_i(WCET_i/P_i) is larger than M (with M equal
+ to the number of CPUs), then the scheduler is unable to respect all the
+ deadlines.
+ Note that total utilisation is defined as the sum of the utilisations
+ WCET_i/P_i over all the real-time tasks in the system. When considering
+ multiple real-time tasks, the parameters of the i-th task are indicated
+ with the "_i" suffix.
+ Moreover, if the total utilisation is larger than M, then we risk starving
+ non- real-time tasks by real-time tasks.
+ If, instead, the total utilisation is smaller than M, then non real-time
+ tasks will not be starved and the system might be able to respect all the
+ deadlines.
+ As a matter of fact, in this case it is possible to provide an upper bound
+ for tardiness (defined as the maximum between 0 and the difference
+ between the finishing time of a job and its absolute deadline).
+ More precisely, it can be proven that using a global EDF scheduler the
+ maximum tardiness of each task is smaller or equal than
+	((M − 1) · WCET_max − WCET_min)/(M − (M − 2) · U_max) + WCET_max
+ where WCET_max = max_i{WCET_i} is the maximum WCET, WCET_min=min_i{WCET_i}
+ is the minimum WCET, and U_max = max_i{WCET_i/P_i} is the maximum utilisation.
+
+ If M=1 (uniprocessor system), or in case of partitioned scheduling (each
+ real-time task is statically assigned to one and only one CPU), it is
+ possible to formally check if all the deadlines are respected.
+ If D_i = P_i for all tasks, then EDF is able to respect all the deadlines
+ of all the tasks executing on a CPU if and only if the total utilisation
+ of the tasks running on such a CPU is smaller or equal than 1.
+ If D_i != P_i for some task, then it is possible to define the density of
+ a task as C_i/min{D_i,T_i}, and EDF is able to respect all the deadlines
+ of all the tasks running on a CPU if the sum sum_i C_i/min{D_i,T_i} of the
+ densities of the tasks running on such a CPU is smaller or equal than 1
+ (notice that this condition is only sufficient, and not necessary).
+
+ On multiprocessor systems with global EDF scheduling (non partitioned
+ systems), a sufficient test for schedulability can not be based on the
+ utilisations (it can be shown that task sets with utilisations slightly
+ larger than 1 can miss deadlines regardless of the number of CPUs M).
+ However, as previously stated, enforcing that the total utilisation is smaller
+ than M is enough to guarantee that non real-time tasks are not starved and
+ that the tardiness of real-time tasks has an upper bound.
 
  SCHED_DEADLINE can be used to schedule real-time tasks guaranteeing that
  the jobs' deadlines of a task are respected. In order to do this, a task
@@ -163,14 +208,22 @@ CONTENTS
 4. Bandwidth management
 =======================
 
- In order for the -deadline scheduling to be effective and useful, it is
- important to have some method to keep the allocation of the available CPU
- bandwidth to the tasks under control. This is usually called "admission
- control" and if it is not performed at all, no guarantee can be given on
- the actual scheduling of the -deadline tasks.
-
- The interface used to control the fraction of CPU bandwidth that can be
- allocated to -deadline tasks is similar to the one already used for -rt
+ As previously mentioned, in order for -deadline scheduling to be
+ effective and useful (that is, to be able to provide "runtime" time units
+ within "deadline"), it is important to have some method to keep the allocation
+ of the available fractions of CPU time to the various tasks under control.
+ This is usually called "admission control" and if it is not performed, then
+ no guarantee can be given on the actual scheduling of the -deadline tasks.
+
+ As already stated in Section 3, a necessary condition to be respected to
+ correctly schedule a set of real-time tasks is that the total utilisation
+ is smaller than M. When talking about -deadline tasks, this requires that
+ the sum of the ratio between runtime and period for all tasks is smaller
+ than M. Notice that the ratio runtime/period is equivalent to the utilisation
+ of a "traditional" real-time task, and is also often referred to as
+ "bandwidth".
+ The interface used to control the CPU bandwidth that can be allocated
+ to -deadline tasks is similar to the one already used for -rt
  tasks with real-time group scheduling (a.k.a. RT-throttling - see
  Documentation/scheduler/sched-rt-group.txt), and is based on readable/
  writable control files located in procfs (for system wide settings).
@@ -182,9 +235,13 @@ CONTENTS
  A main difference between deadline bandwidth management and RT-throttling
  is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
  and thus we don't need a higher level throttling mechanism to enforce the
- desired bandwidth. Therefore, using this simple interface we can put a cap
- on total utilization of -deadline tasks (i.e., \Sum (runtime_i / period_i) <
- global_dl_utilization_cap).
+ desired bandwidth. In other words, this means that interface parameters are
+ only used at admission control time (i.e., when the user calls
+ sched_setattr()). Scheduling is then performed considering actual tasks'
+ parameters, so that CPU bandwidth is allocated to SCHED_DEADLINE tasks
+ respecting their needs in terms of granularity. Therefore, using this simple
+ interface we can put a cap on total utilization of -deadline tasks (i.e.,
+ \Sum (runtime_i / period_i) < global_dl_utilization_cap).
 
 4.1 System wide settings
 ------------------------
@@ -232,8 +289,16 @@ CONTENTS
  950000. With rt_period equal to 1000000, by default, it means that -deadline
  tasks can use at most 95%, multiplied by the number of CPUs that compose the
  root_domain, for each root_domain.
-
- A -deadline task cannot fork.
+ This means that non -deadline tasks will receive at least 5% of the CPU time,
+ and that -deadline tasks will receive their runtime with a guaranteed
+ worst-case delay respect to the "deadline" parameter. If "deadline" = "period"
+ and the cpuset mechanism is used to implement partitioned scheduling (see
+ Section 5), then this simple setting of the bandwidth management is able to
+ deterministically guarantee that -deadline tasks will receive their runtime
+ in a period.
+
+ Finally, notice that in order not to jeopardize the admission control a
+ -deadline task cannot fork.
 
 5. Tasks CPU affinity
 =====================
