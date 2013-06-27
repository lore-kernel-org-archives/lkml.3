Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3F0JCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:02:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3F0JCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:07 -0400
Date: Thu, 27 Jun 2013 02:01:30 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-141965c7494d984b2bf24efd361a3125278869c6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <51CA76A3.3050207@intel.com>
References: <51CA76A3.3050207@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] Revert "sched:
  Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking"
Git-Commit-ID: 141965c7494d984b2bf24efd361a3125278869c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:01:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  141965c7494d984b2bf24efd361a3125278869c6
Gitweb:     http://git.kernel.org/tip/141965c7494d984b2bf24efd361a3125278869c6
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Wed, 26 Jun 2013 13:05:39 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:22 +0200

Revert "sched: Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking"

Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
we can use runnable load variables.

Also remove 2 CONFIG_FAIR_GROUP_SCHED setting which is not in reverted
patch(introduced in 9ee474f), but also need to revert.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51CA76A3.3050207@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  7 +------
 kernel/sched/core.c   |  7 +------
 kernel/sched/fair.c   | 17 ++++-------------
 kernel/sched/sched.h  | 19 ++-----------------
 4 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..0019bef 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -994,12 +994,7 @@ struct sched_entity {
 	struct cfs_rq		*my_q;
 #endif
 
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	/* Per-entity load-tracking */
 	struct sched_avg	avg;
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ceeaf0f..0241b1b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1611,12 +1611,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c0ac2c3..36eadaa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1128,8 +1128,7 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3431,12 +3430,6 @@ unlock:
 }
 
 /*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#ifdef CONFIG_FAIR_GROUP_SCHED
-/*
  * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
  * cfs_rq_of(p) references at time of call are still valid and identify the
  * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
@@ -3459,7 +3452,6 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
-#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -5861,7 +5853,7 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 		se->vruntime -= cfs_rq->min_vruntime;
 	}
 
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	/*
 	* Remove our load from contribution when we leave sched_fair
 	* and ensure we don't carry in an old decay_count if we
@@ -5920,7 +5912,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	atomic64_set(&cfs_rq->decay_counter, 1);
 	atomic64_set(&cfs_rq->removed_load, 0);
 #endif
@@ -6162,9 +6154,8 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-#endif
+
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 029601a..77ce668 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -269,12 +269,6 @@ struct cfs_rq {
 #endif
 
 #ifdef CONFIG_SMP
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	/*
 	 * CFS Load tracking
 	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
@@ -284,9 +278,9 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-/* These always depend on CONFIG_FAIR_GROUP_SCHED */
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	/* Required to track per-cpu representation of a task_group */
 	u32 tg_runnable_contrib;
 	u64 tg_load_contrib;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
@@ -1027,17 +1021,8 @@ extern void update_group_power(struct sched_domain *sd, int cpu);
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
-/*
- * Only depends on SMP, FAIR_GROUP_SCHED may be removed when runnable_avg
- * becomes useful in lb
- */
-#if defined(CONFIG_FAIR_GROUP_SCHED)
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
-#else
-static inline void idle_enter_fair(struct rq *this_rq) {}
-static inline void idle_exit_fair(struct rq *this_rq) {}
-#endif
 
 #else	/* CONFIG_SMP */
 
