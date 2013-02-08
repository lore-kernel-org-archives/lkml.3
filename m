Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946280Ab3BHLR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:17:26 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60155 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946228Ab3BHLRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:17:25 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched: fix wrong rq's runnable_avg update with rt task
Date: Fri,  8 Feb 2013 12:11:27 +0100
Message-Id: <1360321887-18251-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a RT task is scheduled on an idle CPU, the update of the rq's load is
not done because CFS's functions are not called. Then, the idle_balance,
which is called just before entering the idle function, updates the
rq's load and makes the assumption that the elapsed time since the last
update, was only running time.

The rq's load of a CPU that only runs a periodic RT task, is close to
LOAD_AVG_MAX whatever the running duration of the RT task is.

A new idle_exit function is called when the prev task is the idle function
so the elapsed time will be accounted as idle time in the rq's load.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c  |    3 +++
 kernel/sched/fair.c  |   10 ++++++++++
 kernel/sched/sched.h |    5 +++++
 3 files changed, 18 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..592e06c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2927,6 +2927,9 @@ need_resched:
 
 	pre_schedule(rq, prev);
 
+	if (unlikely(prev == rq->idle))
+		idle_exit(cpu, rq);
+
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..520fe55 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1562,6 +1562,16 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
+
+/*
+ * Update the rq's load with the elapsed idle time before a task is
+ * scheduled. if the newly scheduled task is not a CFS  task, idle_exit will
+ * be the only way to update the runnable statistic.
+ */
+void idle_exit(int this_cpu, struct rq *this_rq)
+{
+	update_rq_runnable_avg(this_rq, 0);
+}
 #else
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..9707092 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -877,6 +877,7 @@ extern const struct sched_class idle_sched_class;
 
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
+extern void idle_exit(int this_cpu, struct rq *this_rq);
 
 #else	/* CONFIG_SMP */
 
@@ -884,6 +885,10 @@ static inline void idle_balance(int cpu, struct rq *rq)
 {
 }
 
+static inline void idle_exit(int this_cpu, struct rq *this_rq)
+{
+}
+
 #endif
 
 extern void sysrq_sched_debug_show(void);
-- 
1.7.9.5

