Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281AbaLKQAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:00:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29013 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934262AbaLKQA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:00:29 -0500
From: Josef Bacik <jbacik@fb.com>
To: <bmaurer@fb.com>, <rkroll@fb.com>, <kernel-team@fb.com>,
        <mingo@redhat.com>, <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <umgwanakikbuti@gmail.com>
Subject: [PATCH] sched/fair: change where we report sched stats V2
Date: Thu, 11 Dec 2014 10:59:55 -0500
Message-ID: <1418313595-14286-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-11_03:2014-12-11,2014-12-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=121.849647738959
 compositescore=0.182402046397986 urlsuspect_oldscore=0.182402046397986
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.182402046397986 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412110158
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The schedule stats currently spit out once the entity is being queued, which
means if we have stack traces enabled we will get the stack trace of the waker,
not of the task being woken.  This makes the backtrace completely useless when
trying to track down latency spikes, as we want to know why we were put to sleep
for as long as we were.

This patch moves the trace_sched_stat* calls to after the task has been put back
on the CPU so that the backtrace we get is the one that put us to sleep.  Mike
Galbraith suggested that I leave the actual stat collection stuff where it is so
that we don't add the scheduler latency to the sleep stats, so I've added 3 new
fields in the scheduler stats to keep track of the last sleep time so that if
any of these are set we know to trigger the trace points.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: left the stat collection the way it was and just moved the
trace_sched_stat* calls to after we are put back on the CPU.

 include/linux/sched.h |  3 +++
 kernel/sched/core.c   | 14 ++++----------
 kernel/sched/fair.c   | 33 ++++++++++++++++++++++++++++-----
 kernel/sched/sched.h  |  1 +
 4 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..f647a09 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1091,13 +1091,16 @@ struct sched_statistics {
 	u64			wait_sum;
 	u64			iowait_count;
 	u64			iowait_sum;
+	u64			last_iowait_time;
 
 	u64			sleep_start;
 	u64			sleep_max;
+	u64			last_sleep_time;
 	s64			sum_sleep_runtime;
 
 	u64			block_start;
 	u64			block_max;
+	u64			last_block_time;
 	u64			exec_max;
 	u64			slice_max;
 
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
index ef2b104..3038524 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2702,6 +2702,29 @@ static inline int idle_balance(struct rq *rq)
 
 #endif /* CONFIG_SMP */
 
+static void task_emit_stats(struct rq *rq)
+{
+#ifdef CONFIG_SCHEDSTATS
+	struct task_struct *tsk = rq->curr;
+	struct sched_entity *se = &tsk->se;
+
+	if (se->statistics.last_sleep_time) {
+		trace_sched_stat_sleep(tsk, se->statistics.last_sleep_time);
+		se->statistics.last_sleep_time = 0;
+	}
+
+	if (se->statistics.last_iowait_time) {
+		trace_sched_stat_iowait(tsk, se->statistics.last_iowait_time);
+		se->statistics.last_iowait_time = 0;
+	}
+
+	if (se->statistics.last_block_time) {
+		trace_sched_stat_blocked(tsk, se->statistics.last_block_time);
+		se->statistics.last_block_time = 0;
+	}
+#endif
+}
+
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 #ifdef CONFIG_SCHEDSTATS
@@ -2721,11 +2744,10 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 		se->statistics.sleep_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
+		se->statistics.last_sleep_time = delta;
 
-		if (tsk) {
+		if (tsk)
 			account_scheduler_latency(tsk, delta >> 10, 1);
-			trace_sched_stat_sleep(tsk, delta);
-		}
 	}
 	if (se->statistics.block_start) {
 		u64 delta = rq_clock(rq_of(cfs_rq)) - se->statistics.block_start;
@@ -2737,16 +2759,16 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 			se->statistics.block_max = delta;
 
 		se->statistics.block_start = 0;
+		se->statistics.last_block_time = delta;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
 			if (tsk->in_iowait) {
 				se->statistics.iowait_sum += delta;
 				se->statistics.iowait_count++;
-				trace_sched_stat_iowait(tsk, delta);
+				se->statistics.last_iowait_time = delta;
 			}
 
-			trace_sched_stat_blocked(tsk, delta);
 
 			/*
 			 * Blocking time is in units of nanosecs, so shift by
@@ -7966,6 +7988,7 @@ const struct sched_class fair_sched_class = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_move_group	= task_move_group_fair,
 #endif
+	.post_schedule_stats	= task_emit_stats,
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

