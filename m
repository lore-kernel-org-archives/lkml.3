Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab3F0BHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:07:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:1499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab3F0BHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,948,1363158000"; 
   d="scan'208";a="336108422"
Message-ID: <51CB904D.7040402@intel.com>
Date: Thu, 27 Jun 2013 09:07:25 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [Resend patch v8 01/13] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com> <1371694737-29336-2-git-send-email-alex.shi@intel.com> <51CA76A3.3050207@intel.com> <20130626203027.GA23254@gmail.com>
In-Reply-To: <20130626203027.GA23254@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 04:30 AM, Ingo Molnar wrote:

> kernel/sched/fair.c:1620:6: error: redefinition of ‘idle_enter_fair’
> In file included from kernel/sched/fair.c:35:0:
> kernel/sched/sched.h:1034:20: note: previous definition of ‘idle_enter_fair’ was here
> kernel/sched/fair.c:1630:6: error: redefinition of ‘idle_exit_fair’
> In file included from kernel/sched/fair.c:35:0:
> kernel/sched/sched.h:1035:20: note: previous definition of ‘idle_exit_fair’ was here
> 
> Thanks,
> 
> 	Ingo
> 

my fault! that also need to be reverted in kerel/sched/sched.h

@@ -1028,17 +1022,8 @@ extern void update_group_power(struct sched_domain *sd, int cpu);
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

now, the patch is here:

---

>From caac05dd984ba52af1d7bde47402ef795f8bc060 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Sun, 3 Mar 2013 16:04:36 +0800
Subject: [PATCH 01/14] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"

Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
we can use runnable load variables.

Also removed 3 extra CONFIG_FAIR_GROUP_SCHED setting in commit 9ee474f
and commit 642dbc39a.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |    7 +------
 kernel/sched/core.c   |    7 +------
 kernel/sched/fair.c   |   17 ++++-------------
 kernel/sched/sched.h  |   19 ++-----------------
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
index 36f85be..b9e7036 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1598,12 +1598,7 @@ static void __sched_fork(struct task_struct *p)
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
index 3ee1c2e..1a14209 100644
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
@@ -3436,12 +3435,6 @@ unlock:
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
@@ -3464,7 +3457,6 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
-#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -5866,7 +5858,7 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 		se->vruntime -= cfs_rq->min_vruntime;
 	}
 
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	/*
 	* Remove our load from contribution when we leave sched_fair
 	* and ensure we don't carry in an old decay_count if we
@@ -5925,7 +5917,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	atomic64_set(&cfs_rq->decay_counter, 1);
 	atomic64_set(&cfs_rq->removed_load, 0);
 #endif
@@ -6167,9 +6159,8 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-#endif
+
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 74ff659..9bc3994 100644
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
@@ -1028,17 +1022,8 @@ extern void update_group_power(struct sched_domain *sd, int cpu);
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
 
-- 
1.7.5.4

