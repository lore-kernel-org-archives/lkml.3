Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161239Ab3FTUqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:46:33 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:36549 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422664Ab3FTUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:45:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH 3/4] sched: Conditionally build decaying cpu load stats
Date: Thu, 20 Jun 2013 22:45:40 +0200
Message-Id: <1371761141-25386-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371761141-25386-1-git-send-email-fweisbec@gmail.com>
References: <1371761141-25386-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the decaying cpu load stat indexes used by LB_BIAS
are ignored in full dynticks mode, let's conditionally build
that code to optimize the off case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/proc.c  |   45 ++++++++++++++++++++++++++++-----------------
 kernel/sched/sched.h |    4 ++++
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 030528a..34920e4 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -394,6 +394,7 @@ static void calc_load_account_active(struct rq *this_rq)
 	this_rq->calc_load_update += LOAD_FREQ;
 }
 
+#ifdef CONFIG_NO_HZ_IDLE
 /*
  * End of global load-average stuff
  */
@@ -465,26 +466,13 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
 	return load;
 }
 
-/*
- * Update rq->cpu_load[] statistics. This function is usually called every
- * scheduler tick (TICK_NSEC). With tickless idle this will not be called
- * every tick. We fix it up based on jiffies.
- */
-static void __update_cpu_load(struct rq *this_rq, unsigned long this_load)
+static void update_cpu_load_decayed(struct rq *this_rq, unsigned long this_load,
+				    unsigned long pending_updates)
 {
-	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long pending_updates;
 	int i, scale;
+	unsigned long old_load, new_load;
 
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
-	this_rq->last_load_update_tick = curr_jiffies;
-	this_rq->nr_load_updates++;
-
-	/* Update our load: */
-	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
 	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
-		unsigned long old_load, new_load;
-
 		/* scale is effectively 1 << i now, and >> i divides by scale */
 
 		old_load = this_rq->cpu_load[i];
@@ -500,6 +488,30 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load)
 
 		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
 	}
+}
+#else /* CONFIG_NO_HZ_IDLE */
+static inline void update_cpu_load_decayed(struct rq *this_rq, unsigned long this_load,
+					   unsigned long pending_updates)
+{ }
+#endif
+
+/*
+ * Update rq->cpu_load[] statistics. This function is usually called every
+ * scheduler tick (TICK_NSEC). With tickless idle this will not be called
+ * every tick. We fix it up based on jiffies.
+ */
+static void __update_cpu_load(struct rq *this_rq, unsigned long this_load)
+{
+	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+	unsigned long pending_updates;
+
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	this_rq->last_load_update_tick = curr_jiffies;
+	this_rq->nr_load_updates++;
+
+	/* Update our load: */
+	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
+	update_cpu_load_decayed(this_rq, this_load, pending_updates);
 
 	sched_avg_update(this_rq);
 }
@@ -561,6 +573,5 @@ void update_cpu_load_nohz(void)
 void update_cpu_load_active(struct rq *this_rq)
 {
 	__update_cpu_load(this_rq, this_rq->load.weight);
-
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 029601a..ffa241df 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -410,7 +410,11 @@ struct rq {
 	 * remote CPUs use both these fields when doing load calculation.
 	 */
 	unsigned int nr_running;
+#ifdef CONFIG_NO_HZ_IDLE
 	#define CPU_LOAD_IDX_MAX 5
+#else
+	#define CPU_LOAD_IDX_MAX 1
+#endif
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ_COMMON
-- 
1.7.5.4

