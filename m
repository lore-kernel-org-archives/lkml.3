Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaDPCpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:45:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53470 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaDPCot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:44:49 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: [PATCH V5 7/8] sched: remove rq->cpu_load and rq->nr_load_updates
Date: Wed, 16 Apr 2014 10:43:28 +0800
Message-Id: <1397616209-27275-8-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_load is the copy of rq->cfs.runnable_load_avg. And it updated
on time. So we can use the latter directly. Thus saved 2 rq variables:
cpu_load and nr_load_updates.
Then don't need __update_cpu_load(), just keep sched_avg_update().
Thus removed get_rq_runnable_load() which used for update_cpu_load only.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/core.c  |  2 --
 kernel/sched/debug.c |  2 --
 kernel/sched/proc.c  | 55 +++++++++++++---------------------------------------
 kernel/sched/sched.h |  2 --
 4 files changed, 13 insertions(+), 48 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 33fd59b..80118b3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6828,8 +6828,6 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
 #endif
-
-		rq->cpu_load = 0;
 		rq->last_load_update_tick = jiffies;
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 0e48e98..a03186f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -297,12 +297,10 @@ do {									\
 	SEQ_printf(m, "  .%-30s: %lu\n", "load",
 		   rq->load.weight);
 	P(nr_switches);
-	P(nr_load_updates);
 	P(nr_uninterruptible);
 	PN(next_balance);
 	SEQ_printf(m, "  .%-30s: %ld\n", "curr->pid", (long)(task_pid_nr(rq->curr)));
 	PN(clock);
-	P(cpu_load);
 #undef P
 #undef PN
 
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 383c4ba..dd3c2d9 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -8,12 +8,19 @@
 
 #include "sched.h"
 
+#ifdef CONFIG_SMP
 unsigned long this_cpu_load(void)
 {
-	struct rq *this = this_rq();
-	return this->cpu_load;
+	struct rq *rq = this_rq();
+	return rq->cfs.runnable_load_avg;
 }
-
+#else
+unsigned long this_cpu_load(void)
+{
+	struct rq *rq = this_rq();
+	return rq->load.weight;
+}
+#endif
 
 /*
  * Global load-average calculations
@@ -398,34 +405,6 @@ static void calc_load_account_active(struct rq *this_rq)
  * End of global load-average stuff
  */
 
-
-/*
- * Update rq->cpu_load statistics. This function is usually called every
- * scheduler tick (TICK_NSEC). With tickless idle this will not be called
- * every tick. We fix it up based on jiffies.
- */
-static void __update_cpu_load(struct rq *this_rq, unsigned long this_load)
-{
-	this_rq->nr_load_updates++;
-
-	/* Update our load: */
-	this_rq->cpu_load = this_load; /* Fasttrack for idx 0 */
-
-	sched_avg_update(this_rq);
-}
-
-#ifdef CONFIG_SMP
-static inline unsigned long get_rq_runnable_load(struct rq *rq)
-{
-	return rq->cfs.runnable_load_avg;
-}
-#else
-static inline unsigned long get_rq_runnable_load(struct rq *rq)
-{
-	return rq->load.weight;
-}
-#endif
-
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * There is no sane way to deal with nohz on smp when using jiffies because the
@@ -447,17 +426,15 @@ static inline unsigned long get_rq_runnable_load(struct rq *rq)
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = get_rq_runnable_load(this_rq);
 
 	/*
 	 * bail if there's load or we're actually up-to-date.
 	 */
-	if (load || curr_jiffies == this_rq->last_load_update_tick)
+	if (curr_jiffies == this_rq->last_load_update_tick)
 		return;
 
 	this_rq->last_load_update_tick = curr_jiffies;
-
-	__update_cpu_load(this_rq, load);
+	sched_avg_update(this_rq);
 }
 
 /*
@@ -466,7 +443,6 @@ void update_idle_cpu_load(struct rq *this_rq)
 void update_cpu_load_nohz(void)
 {
 	struct rq *this_rq = this_rq();
-
 	update_idle_cpu_load(this_rq);
 }
 #endif /* CONFIG_NO_HZ */
@@ -476,12 +452,7 @@ void update_cpu_load_nohz(void)
  */
 void update_cpu_load_active(struct rq *this_rq)
 {
-	unsigned long load = get_rq_runnable_load(this_rq);
-	/*
-	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
-	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, load);
-
+	sched_avg_update(this_rq);
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1f144e8..f521d8e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -528,7 +528,6 @@ struct rq {
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
 #endif
-	unsigned long cpu_load;
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ_COMMON
 	u64 nohz_stamp;
@@ -541,7 +540,6 @@ struct rq {
 
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
-	unsigned long nr_load_updates;
 	u64 nr_switches;
 
 	struct cfs_rq cfs;
-- 
1.8.3.2

