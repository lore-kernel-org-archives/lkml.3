Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaLISWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:22:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41566 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbaLISW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:22:29 -0500
From: Josef Bacik <jbacik@fb.com>
To: <bmaurer@fb.com>, <rkroll@fb.com>, <kernel-team@fb.com>,
        <mingo@redhat.com>, <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched/fair: change where we report sched stats
Date: Tue, 9 Dec 2014 13:21:55 -0500
Message-ID: <1418149315-30173-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-09_05:2014-12-09,2014-12-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.60902410786912e-14 kscore.compositescore=0
 circleOfTrustscore=23.9891549223058 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412090178
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The schedule stats currently spit out once the entity is being queued, which
means if we have stack traces enabled we will get the stack trace of the waker,
not of the task being woken.  This makes the backtrace completely useless when
trying to track down latency spikes, as we want to know why we were put to sleep
for as long as we were.

This patch moves stat stuff to after the schedule, right as we are waking up,
this way if we have backtraces enabled we will get a useful backtrace.  This
allows us to trace on the sched:sched_stat_blocked/iowait/sleep tracepoints and
limit them based on the duration rather than trace every sched_switch operation
and then post-parse that information looking for our latency problems.

I've tested this in production and it works well, I'd appreciate feedback on
this solution, I'd be happy to re-work it to be more acceptable and test here.
This is an important fix for us and anybody else who wants to do latency
debugging in production at a large scale.  Thanks

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 kernel/sched/core.c  | 14 ++++----------
 kernel/sched/fair.c  | 14 ++++++--------
 kernel/sched/sched.h |  1 +
 3 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 89e7283..e763709 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2277,11 +2277,12 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	tick_nohz_task_switch(current);
 }
 
-#ifdef CONFIG_SMP
-
 /* rq->lock is NOT held, but preemption is disabled */
 static inline void post_schedule(struct rq *rq)
 {
+	if (rq->curr->sched_class->post_schedule_stats)
+		rq->curr->sched_class->post_schedule_stats(rq);
+#ifdef CONFIG_SMP
 	if (rq->post_schedule) {
 		unsigned long flags;
 
@@ -2292,15 +2293,8 @@ static inline void post_schedule(struct rq *rq)
 
 		rq->post_schedule = 0;
 	}
-}
-
-#else
-
-static inline void post_schedule(struct rq *rq)
-{
-}
-
 #endif
+}
 
 /**
  * schedule_tail - first thing a freshly forked thread must call.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ef2b104..84d5804 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2702,13 +2702,12 @@ static inline int idle_balance(struct rq *rq)
 
 #endif /* CONFIG_SMP */
 
-static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void task_update_stats(struct rq *rq)
 {
 #ifdef CONFIG_SCHEDSTATS
-	struct task_struct *tsk = NULL;
-
-	if (entity_is_task(se))
-		tsk = task_of(se);
+	struct task_struct *tsk = rq->curr;
+	struct cfs_rq *cfs_rq = task_cfs_rq(tsk);
+	struct sched_entity *se = &tsk->se;
 
 	if (se->statistics.sleep_start) {
 		u64 delta = rq_clock(rq_of(cfs_rq)) - se->statistics.sleep_start;
@@ -2829,10 +2828,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
-	if (flags & ENQUEUE_WAKEUP) {
+	if (flags & ENQUEUE_WAKEUP)
 		place_entity(cfs_rq, se, 0);
-		enqueue_sleeper(cfs_rq, se);
-	}
 
 	update_stats_enqueue(cfs_rq, se);
 	check_spread(cfs_rq, se);
@@ -7966,6 +7963,7 @@ const struct sched_class fair_sched_class = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_move_group	= task_move_group_fair,
 #endif
+	.post_schedule_stats	= task_update_stats,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 2df8ef0..7c0e977 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1140,6 +1140,7 @@ struct sched_class {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
+	void (*post_schedule_stats) (struct rq *this_rq);
 };
 
 static inline void put_prev_task(struct rq *rq, struct task_struct *prev)
-- 
1.9.3

