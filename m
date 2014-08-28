Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965752AbaH1KAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:00:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56444 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965571AbaH1KAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:00:32 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        juri.lelli@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] Documentation/scheduler/sched-deadline.txt: improve and clarify AC bits
Date: Thu, 28 Aug 2014 11:00:28 +0100
Message-Id: <1409220029-9002-4-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Aug 2014 10:00:28.0596 (UTC) FILETIME=[E5647740:01CFC2A6]
X-MC-Unique: 114082811003007601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luca Abeni <luca.abeni@unitn.it>

Admission control is of key importance for SCHED_DEADLINE, since it guarantees
system schedulability (or tells us something about the degree of guarantees
we can provide to the user).

This patch improves and clarifies bits and pieces regarding AC, both for UP
and SMP systems.

Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Henrik Austad <henrik@austad.us>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/scheduler/sched-deadline.txt | 89 +++++++++++++++++++++++++-----
 1 file changed, 75 insertions(+), 14 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index 0aff2d5..641395e 100644
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
- closest scheduling deadline is selected for execution). Notice that this
- guaranteed is respected if a proper "admission control" strategy (see Section
- "4. Bandwidth management") is used.
+ closest scheduling deadline is selected for execution). Notice that the
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
+ is smaller than M. When talking about -deadline tasks, this requires to
+ impose that the sum of the ratio between runtime and period for all tasks
+ is smaller than M. Notice that the ratio runtime/period is equivalent to
+ the utilisation of a "traditional" real-time task, and is also often
+ referred to as "bandwidth".
+ The interface used to control the CPU bandwidth that can be allocated
+ to -deadline tasks is similar to the one already used for -rt
  tasks with real-time group scheduling (a.k.a. RT-throttling - see
  Documentation/scheduler/sched-rt-group.txt), and is based on readable/
  writable control files located in procfs (for system wide settings).
@@ -232,8 +285,16 @@ CONTENTS
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
+ Finally, notice that in order not to jeopardize this admission control a
+ -deadline task cannot fork.
 
 5. Tasks CPU affinity
 =====================
-- 
2.0.4


