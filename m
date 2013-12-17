Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3LQMvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:51:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3LQMqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:46:08 -0500
Message-Id: <20131217123352.914435016@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Dec 2013 13:27:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 05/13] sched: Add period support for -deadline tasks
References: <20131217122720.950475833@infradead.org>
Content-Disposition: inline; filename=0006-sched-Add-period-support-for-deadline-tasks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Gustafsson <harald.gustafsson@ericsson.com>

Make it possible to specify a period (different or equal than
deadline) for -deadline tasks. Relative deadlines (D_i) are used on
task arrivals to generate new scheduling (absolute) deadlines as "d =
t + D_i", and periods (P_i) to postpone the scheduling deadlines as "d
= d + P_i" when the budget is zero.

This is in general useful to model (and schedule) tasks that have slow
activation rates (long periods), but have to be scheduled soon once
activated (short deadlines).

Cc: oleg@redhat.com
Cc: darren@dvhart.com
Cc: paulmck@linux.vnet.ibm.com
Cc: dhaval.giani@gmail.com
Cc: p.faure@akatech.ch
Cc: fchecconi@gmail.com
Cc: fweisbec@gmail.com
Cc: hgu1972@gmail.com
Cc: insop.song@gmail.com
Cc: jkacur@redhat.com
Cc: rostedt@goodmis.org
Cc: johan.eker@ericsson.com
Cc: tglx@linutronix.de
Cc: liming.wang@windriver.com
Cc: tommaso.cucinotta@sssup.it
Cc: luca.abeni@unitn.it
Cc: vincent.guittot@linaro.org
Cc: michael@amarulasolutions.com
Cc: mingo@redhat.com
Cc: bruce.ashfield@windriver.com
Cc: nicola.manica@disi.unitn.it
Cc: claudio@evidence.eu.com
Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h   |    1 +
 kernel/sched/core.c     |   10 ++++++++--
 kernel/sched/deadline.c |   10 +++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1094,6 +1094,7 @@ struct sched_dl_entity {
 	 */
 	u64 dl_runtime;		/* maximum runtime for each instance	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
+	u64 dl_period;		/* separation of two instances (period) */
 
 	/*
 	 * Actual scheduling parameters. Initialized with the values above,
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1722,6 +1722,7 @@ static void __sched_fork(unsigned long c
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	p->dl.dl_runtime = p->dl.runtime = 0;
 	p->dl.dl_deadline = p->dl.deadline = 0;
+	p->dl.dl_period = 0;
 	p->dl.flags = 0;
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -3042,6 +3043,7 @@ __setparam_dl(struct task_struct *p, con
 	init_dl_task_timer(dl_se);
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
+	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
 	dl_se->flags = attr->sched_flags;
 	dl_se->dl_throttled = 0;
 	dl_se->dl_new = 1;
@@ -3055,19 +3057,23 @@ __getparam_dl(struct task_struct *p, str
 	attr->sched_priority = p->rt_priority;
 	attr->sched_runtime = dl_se->dl_runtime;
 	attr->sched_deadline = dl_se->dl_deadline;
+	attr->sched_period = dl_se->dl_period;
 	attr->sched_flags = dl_se->flags;
 }
 
 /*
  * This function validates the new parameters of a -deadline task.
  * We ask for the deadline not being zero, and greater or equal
- * than the runtime.
+ * than the runtime, as well as the period of being zero or
+ * greater than deadline.
  */
 static bool
 __checkparam_dl(const struct sched_attr *attr)
 {
 	return attr && attr->sched_deadline != 0 &&
-	       (s64)(attr->sched_deadline - attr->sched_runtime) >= 0;
+		(attr->sched_period == 0 ||
+		(s64)(attr->sched_period   - attr->sched_deadline) >= 0) &&
+		(s64)(attr->sched_deadline - attr->sched_runtime ) >= 0;
 }
 
 /*
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -289,7 +289,7 @@ static void replenish_dl_entity(struct s
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += dl_se->dl_deadline;
+		dl_se->deadline += dl_se->dl_period;
 		dl_se->runtime += dl_se->dl_runtime;
 	}
 
@@ -329,9 +329,13 @@ static void replenish_dl_entity(struct s
  *
  * This function returns true if:
  *
- *   runtime / (deadline - t) > dl_runtime / dl_deadline ,
+ *   runtime / (deadline - t) > dl_runtime / dl_period ,
  *
  * IOW we can't recycle current parameters.
+ *
+ * Notice that the bandwidth check is done against the period. For
+ * task with deadline equal to period this is the same of using
+ * dl_deadline instead of dl_period in the equation above.
  */
 static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 {
@@ -355,7 +359,7 @@ static bool dl_entity_overflow(struct sc
 	 * of anything below microseconds resolution is actually fiction
 	 * (but still we want to give the user that illusion >;).
 	 */
-	left = (dl_se->dl_deadline >> 10) * (dl_se->runtime >> 10);
+	left = (dl_se->dl_period >> 10) * (dl_se->runtime >> 10);
 	right = ((dl_se->deadline - t) >> 10) * (dl_se->dl_runtime >> 10);
 
 	return dl_time_before(right, left);


