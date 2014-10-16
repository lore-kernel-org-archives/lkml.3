Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaJPNtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:49:23 -0400
Received: from relay.parallels.com ([195.214.232.42]:60025 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaJPNtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:49:22 -0400
Message-ID: <1413467359.19914.2.camel@tkhai>
Subject: [PATCH] sched/fair: Fix race in update_cfs_rq_h_load()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Thu, 16 Oct 2014 17:49:19 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The original idea of cfs_rq::last_h_load_update was to do not
update cfs_rq::h_load more than once a jiffies.

Since task_numa_compare()->task_h_load()->update_cfs_rq_h_load()
makes unlocked update, this may be a reason of race between two
parallel updates, or with remote rq->curr changing.

The patch does not change idea, but it excludes the race. Now we
update cfs_rq::h_load holding rq's lock. This happens in two
places: every jiffie in task_tick_fair(), and in set_curr_task_fair()
when task becomes fair.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/fair.c  |   23 +++++++++++------------
 kernel/sched/sched.h |    1 -
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b78280c..fd2007e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5562,28 +5562,22 @@ static void update_blocked_averages(int cpu)
  * This needs to be done in a top-down fashion because the load of a child
  * group is a fraction of its parents load.
  */
-static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
+static void update_cfs_rq_h_load(struct task_struct *curr)
 {
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct rq *rq = rq_of(cfs_rq);
 	struct sched_entity *se = cfs_rq->tg->se[cpu_of(rq)];
-	unsigned long now = jiffies;
 	unsigned long load;
 
-	if (cfs_rq->last_h_load_update == now)
-		return;
+	lockdep_assert_held(&rq->lock);
 
 	cfs_rq->h_load_next = NULL;
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		cfs_rq->h_load_next = se;
-		if (cfs_rq->last_h_load_update == now)
-			break;
 	}
 
-	if (!se) {
-		cfs_rq->h_load = cfs_rq->runnable_load_avg;
-		cfs_rq->last_h_load_update = now;
-	}
+	cfs_rq->h_load = cfs_rq->runnable_load_avg;
 
 	while ((se = cfs_rq->h_load_next) != NULL) {
 		load = cfs_rq->h_load;
@@ -5591,7 +5585,6 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
 				cfs_rq->runnable_load_avg + 1);
 		cfs_rq = group_cfs_rq(se);
 		cfs_rq->h_load = load;
-		cfs_rq->last_h_load_update = now;
 	}
 }
 
@@ -5599,7 +5592,6 @@ static unsigned long task_h_load(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
-	update_cfs_rq_h_load(cfs_rq);
 	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
 			cfs_rq->runnable_load_avg + 1);
 }
@@ -5608,6 +5600,10 @@ static inline void update_blocked_averages(int cpu)
 {
 }
 
+static void update_cfs_rq_h_load(struct task_struct *curr)
+{
+}
+
 static unsigned long task_h_load(struct task_struct *p)
 {
 	return p->se.avg.load_avg_contrib;
@@ -7509,6 +7505,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		task_tick_numa(rq, curr);
 
 	update_rq_runnable_avg(rq, 1);
+	update_cfs_rq_h_load(curr);
 }
 
 /*
@@ -7662,6 +7659,8 @@ static void set_curr_task_fair(struct rq *rq)
 		/* ensure bandwidth has been allocated on our new cfs_rq */
 		account_cfs_rq_runtime(cfs_rq, 0);
 	}
+
+	update_cfs_rq_h_load(rq->curr);
 }
 
 void init_cfs_rq(struct cfs_rq *cfs_rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6130251..5b23d6c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -361,7 +361,6 @@ struct cfs_rq {
 	 * this group.
 	 */
 	unsigned long h_load;
-	u64 last_h_load_update;
 	struct sched_entity *h_load_next;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 #endif /* CONFIG_SMP */



