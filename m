Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaDPCpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:45:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64480 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaDPCoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:44:55 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: [PATCH V5 8/8] sched: rename update_*_cpu_load
Date: Wed, 16 Apr 2014 10:43:29 +0800
Message-Id: <1397616209-27275-9-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have no cpu_load update, rename the related functions:
s/update_idle_cpu_load/update_idle_rt_avg/
s/update_cpu_load_nohz/update_rt_avg_nohz/
s/update_cpu_load_active/update_avg_load_active/

No functional change.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 include/linux/sched.h    | 2 +-
 kernel/sched/core.c      | 2 +-
 kernel/sched/fair.c      | 2 +-
 kernel/sched/proc.c      | 8 ++++----
 kernel/sched/sched.h     | 4 ++--
 kernel/time/tick-sched.c | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3b08d7b..1e57983 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -178,7 +178,7 @@ extern unsigned long this_cpu_load(void);
 
 
 extern void calc_global_load(unsigned long ticks);
-extern void update_cpu_load_nohz(void);
+extern void update_rt_avg_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 80118b3..8900c8a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2427,7 +2427,7 @@ void scheduler_tick(void)
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
-	update_cpu_load_active(rq);
+	update_avg_load_active(rq);
 	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick();
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cad2b6d..864754f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7013,7 +7013,7 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 
 		raw_spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
-		update_idle_cpu_load(rq);
+		update_idle_rt_avg(rq);
 		raw_spin_unlock_irq(&rq->lock);
 
 		rebalance_domains(rq, CPU_IDLE);
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index dd3c2d9..42b7706 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -423,7 +423,7 @@ static void calc_load_account_active(struct rq *this_rq)
  * Called from nohz_idle_balance() to update the load ratings before doing the
  * idle balance.
  */
-void update_idle_cpu_load(struct rq *this_rq)
+void update_idle_rt_avg(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
 
@@ -440,17 +440,17 @@ void update_idle_cpu_load(struct rq *this_rq)
 /*
  * Called from tick_nohz_idle_exit()
  */
-void update_cpu_load_nohz(void)
+void update_rt_avg_nohz(void)
 {
 	struct rq *this_rq = this_rq();
-	update_idle_cpu_load(this_rq);
+	update_idle_rt_avg(this_rq);
 }
 #endif /* CONFIG_NO_HZ */
 
 /*
  * Called from scheduler_tick()
  */
-void update_cpu_load_active(struct rq *this_rq)
+void update_avg_load_active(struct rq *this_rq)
 {
 	this_rq->last_load_update_tick = jiffies;
 	sched_avg_update(this_rq);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f521d8e..f4fb861 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -21,7 +21,7 @@ extern unsigned long calc_load_update;
 extern atomic_long_t calc_load_tasks;
 
 extern long calc_load_fold_active(struct rq *this_rq);
-extern void update_cpu_load_active(struct rq *this_rq);
+extern void update_avg_load_active(struct rq *this_rq);
 
 /*
  * Helpers for converting nanosecond timing to jiffy resolution
@@ -1209,7 +1209,7 @@ extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
 
 unsigned long to_ratio(u64 period, u64 runtime);
 
-extern void update_idle_cpu_load(struct rq *this_rq);
+extern void update_idle_rt_avg(struct rq *this_rq);
 
 extern void init_task_runnable_average(struct task_struct *p);
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9f8af69..b1a400a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -866,7 +866,7 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 {
 	/* Update jiffies first */
 	tick_do_update_jiffies64(now);
-	update_cpu_load_nohz();
+	update_rt_avg_nohz();
 
 	calc_load_exit_idle();
 	touch_softlockup_watchdog();
-- 
1.8.3.2

