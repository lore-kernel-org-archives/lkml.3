Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaBLIVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:21:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50290 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbaBLIOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:09 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Colin Cross" <ccross@android.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.447923745@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 76/79] sched/rt: Fix SCHED_RR across cgroups
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit 454c79999f7eaedcdf4c15c449e43902980cbdf5 upstream.

task_tick_rt() has an optimization to only reschedule SCHED_RR tasks
if they were the only element on their rq.  However, with cgroups
a SCHED_RR task could be the only element on its per-cgroup rq but
still be competing with other SCHED_RR tasks in its parent's
cgroup.  In this case, the SCHED_RR task in the child cgroup would
never yield at the end of its timeslice.  If the child cgroup
rt_runtime_us was the same as the parent cgroup rt_runtime_us,
the task in the parent cgroup would starve completely.

Modify task_tick_rt() to check that the task is the only task on its
rq, and that the each of the scheduling entities of its ancestors
is also the only entity on its rq.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337229266-15798-1-git-send-email-ccross@android.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched_rt.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1772,6 +1772,8 @@ static void watchdog(struct rq *rq, stru
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
+	struct sched_rt_entity *rt_se = &p->rt;
+
 	update_curr_rt(rq);
 
 	watchdog(rq, p);
@@ -1789,12 +1791,15 @@ static void task_tick_rt(struct rq *rq,
 	p->rt.time_slice = DEF_TIMESLICE;
 
 	/*
-	 * Requeue to the end of queue if we are not the only element
-	 * on the queue:
+	 * Requeue to the end of queue if we (and all of our ancestors) are the
+	 * only element on the queue
 	 */
-	if (p->rt.run_list.prev != p->rt.run_list.next) {
-		requeue_task_rt(rq, p, 0);
-		set_tsk_need_resched(p);
+	for_each_sched_rt_entity(rt_se) {
+		if (rt_se->run_list.prev != rt_se->run_list.next) {
+			requeue_task_rt(rq, p, 0);
+			set_tsk_need_resched(p);
+			return;
+		}
 	}
 }
 

