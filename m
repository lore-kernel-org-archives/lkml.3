Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3EGFFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:05:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:17122 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab3EGFFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:05:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="237858676"
Message-ID: <51888B9F.1070208@intel.com>
Date: Tue, 07 May 2013 13:05:35 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 1/7] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-2-git-send-email-alex.shi@intel.com> <CAPM31R+4Ar5FFGSgfts76qNiQ5GMpPk7wkuj1fwsFrugVwnLfQ@mail.gmail.com> <51876E92.3010300@intel.com> <CAPM31RLOHcDGJy6bpXeMN90+NpGNkKS=32Wyq5r0LkdGb=SKkQ@mail.gmail.com>
In-Reply-To: <CAPM31RLOHcDGJy6bpXeMN90+NpGNkKS=32Wyq5r0LkdGb=SKkQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:55 PM, Paul Turner wrote:
> On Mon, May 6, 2013 at 1:49 AM, Alex Shi <alex.shi@intel.com> wrote:
>> On 05/06/2013 04:24 PM, Paul Turner wrote:
>>>>>         /*
>>>>>          * CFS Load tracking
>>>>>          * Under CFS, load is tracked on a per-entity basis and aggregated up.
>>>>> @@ -242,8 +236,7 @@ struct cfs_rq {
>>>>>         u64 runnable_load_avg, blocked_load_avg;
>>>>>         atomic64_t decay_counter, removed_load;
>>>>>         u64 last_decay;
>>>>> -#endif /* CONFIG_FAIR_GROUP_SCHED */
>>>>> -/* These always depend on CONFIG_FAIR_GROUP_SCHED */
>>> We should perhaps replace this with a comment that these are only
>>> needed to aggregate the point-wise representation in the
>>> FAIR_GROUP_SCHED case.
>>>
>>
>> Is the comments ok? :)
>>
>> /* runnable related variables only used in FAIR_GROUP_SCHED */
> 
> Perhaps:
> 
>  -/* These always depend on CONFIG_FAIR_GROUP_SCHED */
> #ifdef ...
> +/* Required to track per-cpu representation of a task_group */

here is the changed patch. 
Do you mind to give a ack or review by? :)

---
>From 5a7ba8bd36051039aa8d7288bbb699efc4d9b8be Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Sun, 3 Mar 2013 16:04:36 +0800
Subject: [PATCH 1/7] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"

Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
we can use runnable load variables.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |  7 +------
 kernel/sched/core.c   |  7 +------
 kernel/sched/fair.c   | 13 ++-----------
 kernel/sched/sched.h  | 10 ++--------
 4 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e692a02..9539597 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1161,12 +1161,7 @@ struct sched_entity {
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
index 67d0465..c8db984 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1563,12 +1563,7 @@ static void __sched_fork(struct task_struct *p)
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
index 7a33e59..9c2f726 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1109,8 +1109,7 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3394,12 +3393,6 @@ unlock:
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
@@ -3422,7 +3415,6 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
-#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -6114,9 +6106,8 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-#endif
+
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..9419764 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -227,12 +227,6 @@ struct cfs_rq {
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
@@ -242,9 +236,9 @@ struct cfs_rq {
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

-- 
Thanks
    Alex
