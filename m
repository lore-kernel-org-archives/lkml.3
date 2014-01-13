Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaAMPyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:54:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaAMPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:54:42 -0500
Date: Mon, 13 Jan 2014 07:53:57 -0800
From: tip-bot for Harald Gustafsson <tipbot@zytor.com>
Message-ID: <tip-755378a47192a3d1f7c3a8ca6c15c1cf76de0af2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it,
        harald.gustafsson@ericsson.com, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it,
        harald.gustafsson@ericsson.com, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <1383831828-15501-7-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-7-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Add period support for SCHED_DEADLINE tasks
Git-Commit-ID: 755378a47192a3d1f7c3a8ca6c15c1cf76de0af2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:54:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  755378a47192a3d1f7c3a8ca6c15c1cf76de0af2
Gitweb:     http://git.kernel.org/tip/755378a47192a3d1f7c3a8ca6c15c1cf76de0af2
Author:     Harald Gustafsson <harald.gustafsson@ericsson.com>
AuthorDate: Thu, 7 Nov 2013 14:43:40 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:41:09 +0100

sched/deadline: Add period support for SCHED_DEADLINE tasks

Make it possible to specify a period (different or equal than
deadline) for -deadline tasks. Relative deadlines (D_i) are used on
task arrivals to generate new scheduling (absolute) deadlines as "d =
t + D_i", and periods (P_i) to postpone the scheduling deadlines as "d
= d + P_i" when the budget is zero.

This is in general useful to model (and schedule) tasks that have slow
activation rates (long periods), but have to be scheduled soon once
activated (short deadlines).

Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1383831828-15501-7-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h   |  1 +
 kernel/sched/core.c     | 10 ++++++++--
 kernel/sched/deadline.c | 10 +++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cc66f26..158f4c2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1102,6 +1102,7 @@ struct sched_dl_entity {
 	 */
 	u64 dl_runtime;		/* maximum runtime for each instance	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
+	u64 dl_period;		/* separation of two instances (period) */
 
 	/*
 	 * Actual scheduling parameters. Initialized with the values above,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 548cc04..069230b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1723,6 +1723,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	p->dl.dl_runtime = p->dl.runtime = 0;
 	p->dl.dl_deadline = p->dl.deadline = 0;
+	p->dl.dl_period = 0;
 	p->dl.flags = 0;
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -3026,6 +3027,7 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	init_dl_task_timer(dl_se);
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
+	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
 	dl_se->flags = attr->sched_flags;
 	dl_se->dl_throttled = 0;
 	dl_se->dl_new = 1;
@@ -3067,19 +3069,23 @@ __getparam_dl(struct task_struct *p, struct sched_attr *attr)
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
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 21f58d2..3958bc5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -289,7 +289,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += dl_se->dl_deadline;
+		dl_se->deadline += dl_se->dl_period;
 		dl_se->runtime += dl_se->dl_runtime;
 	}
 
@@ -329,9 +329,13 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
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
@@ -355,7 +359,7 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 	 * of anything below microseconds resolution is actually fiction
 	 * (but still we want to give the user that illusion >;).
 	 */
-	left = (dl_se->dl_deadline >> 10) * (dl_se->runtime >> 10);
+	left = (dl_se->dl_period >> 10) * (dl_se->runtime >> 10);
 	right = ((dl_se->deadline - t) >> 10) * (dl_se->dl_runtime >> 10);
 
 	return dl_time_before(right, left);
