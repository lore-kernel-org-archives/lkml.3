Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab3FZFGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:06:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:13007 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab3FZFGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:06:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="260233663"
Message-ID: <51CA76A3.3050207@intel.com>
Date: Wed, 26 Jun 2013 13:05:39 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
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
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com> <1371694737-29336-2-git-send-email-alex.shi@intel.com>
In-Reply-To: <1371694737-29336-2-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 10:18 AM, Alex Shi wrote:
> Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
> we can use runnable load variables.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>

There are 2 more place need to be reverted too, and merged them into the updated patch.
BTW, this patchset was tested by Fengguang's 0day kbuild system.

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f404468..1a14209 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5858,7 +5858,7 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 		se->vruntime -= cfs_rq->min_vruntime;
 	}
 
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	/*
 	* Remove our load from contribution when we leave sched_fair
 	* and ensure we don't carry in an old decay_count if we
@@ -5917,7 +5917,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	atomic64_set(&cfs_rq->decay_counter, 1);
 	atomic64_set(&cfs_rq->removed_load, 0);
 #endif
-- 

---

>From 190a4d0c8fd6325c6141a9d1ae14518e521e4289 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Sun, 3 Mar 2013 16:04:36 +0800
Subject: Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"

Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
we can use runnable load variables.

Also remove 2 CONFIG_FAIR_GROUP_SCHED setting which is not in reverted
patch(introduced in 9ee474f), but also need to revert.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |  7 +------
 kernel/sched/core.c   |  7 +------
 kernel/sched/fair.c   | 17 ++++-------------
 kernel/sched/sched.h  | 10 ++--------
 4 files changed, 8 insertions(+), 33 deletions(-)

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
index 74ff659..d892a9f 100644
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
-- 
1.7.12

