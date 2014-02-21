Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaBUVbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:31:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbaBUVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:31:15 -0500
Date: Fri, 21 Feb 2014 13:30:43 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6e83125c6b151afa139c8852c099d6d92954fe3b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <20140211151148.GP27965@twins.programming.kicks-ass.net>
References: <20140211151148.GP27965@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Remove idle_balance()
  declaration in sched.h
Git-Commit-ID: 6e83125c6b151afa139c8852c099d6d92954fe3b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e83125c6b151afa139c8852c099d6d92954fe3b
Gitweb:     http://git.kernel.org/tip/6e83125c6b151afa139c8852c099d6d92954fe3b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 11 Feb 2014 16:11:48 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:17 +0100

sched/fair: Remove idle_balance() declaration in sched.h

Remove idle_balance() from the public life; also reduce some #ifdef
clutter by folding the pick_next_task_fair() idle path into
idle_balance().

Cc: mingo@kernel.org
Reported-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140211151148.GP27965@twins.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c  | 47 +++++++++++++++++++++++++++++------------------
 kernel/sched/sched.h |  7 -------
 2 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 280da89..40c758b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2374,13 +2374,13 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
 	}
 }
-#else
+#else /* CONFIG_FAIR_GROUP_SCHED */
 static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 						 int force_update) {}
 static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 						  struct cfs_rq *cfs_rq) {}
 static inline void __update_group_entity_contrib(struct sched_entity *se) {}
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 static inline void __update_task_entity_contrib(struct sched_entity *se)
 {
@@ -2571,6 +2571,8 @@ void idle_exit_fair(struct rq *this_rq)
 	update_rq_runnable_avg(this_rq, 0);
 }
 
+static int idle_balance(struct rq *this_rq);
+
 #else /* CONFIG_SMP */
 
 static inline void update_entity_load_avg(struct sched_entity *se,
@@ -2584,6 +2586,12 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 					   int sleep) {}
 static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
 					      int force_update) {}
+
+static inline int idle_balance(struct rq *rq)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SMP */
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -4677,7 +4685,7 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 	struct sched_entity *se;
 	struct task_struct *p;
 
-again: __maybe_unused
+again:
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (!cfs_rq->nr_running)
 		goto idle;
@@ -4775,18 +4783,8 @@ simple:
 	return p;
 
 idle:
-#ifdef CONFIG_SMP
-	idle_enter_fair(rq);
-	/*
-	 * We must set idle_stamp _before_ calling idle_balance(), such that we
-	 * measure the duration of idle_balance() as idle time.
-	 */
-	rq->idle_stamp = rq_clock(rq);
-	if (idle_balance(rq)) { /* drops rq->lock */
-		rq->idle_stamp = 0;
+	if (idle_balance(rq)) /* drops rq->lock */
 		goto again;
-	}
-#endif
 
 	return NULL;
 }
@@ -6634,7 +6632,7 @@ out:
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-int idle_balance(struct rq *this_rq)
+static int idle_balance(struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
@@ -6642,8 +6640,15 @@ int idle_balance(struct rq *this_rq)
 	u64 curr_cost = 0;
 	int this_cpu = this_rq->cpu;
 
+	idle_enter_fair(this_rq);
+	/*
+	 * We must set idle_stamp _before_ calling idle_balance(), such that we
+	 * measure the duration of idle_balance() as idle time.
+	 */
+	this_rq->idle_stamp = rq_clock(this_rq);
+
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return 0;
+		goto out;
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6692,8 +6697,10 @@ int idle_balance(struct rq *this_rq)
 	 * While browsing the domains, we released the rq lock.
 	 * A task could have be enqueued in the meantime
 	 */
-	if (this_rq->nr_running && !pulled_task)
-		return 1;
+	if (this_rq->nr_running && !pulled_task) {
+		pulled_task = 1;
+		goto out;
+	}
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -6706,6 +6713,10 @@ int idle_balance(struct rq *this_rq)
 	if (curr_cost > this_rq->max_idle_balance_cost)
 		this_rq->max_idle_balance_cost = curr_cost;
 
+out:
+	if (pulled_task)
+		this_rq->idle_stamp = 0;
+
 	return pulled_task;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bf34c2..92018f9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1163,17 +1163,10 @@ extern const struct sched_class idle_sched_class;
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern int idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
-#else	/* CONFIG_SMP */
-
-static inline void idle_balance(int cpu, struct rq *rq)
-{
-}
-
 #endif
 
 extern void sysrq_sched_debug_show(void);
