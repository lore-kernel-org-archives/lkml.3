Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3C3Of7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:35:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab3C3Ofi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:35:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568182"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 02/21] sched: set initial value of runnable avg for new forked task
Date: Sat, 30 Mar 2013 22:34:49 +0800
Message-Id: <1364654108-16307-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need initialize the se.avg.{decay_count, load_avg_contrib} for a
new forked task.
Otherwise random values of above variables cause mess when do new task
enqueue:
    enqueue_task_fair
        enqueue_entity
            enqueue_entity_load_avg

and make forking balancing imbalance since incorrect load_avg_contrib.

set avg.decay_count = 0, and avg.load_avg_contrib = se->load.weight to
resolve such issues.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 6 ++++++
 kernel/sched/fair.c | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 54eaaa2..8843cd3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1564,6 +1564,7 @@ static void __sched_fork(struct task_struct *p)
 #ifdef CONFIG_SMP
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
+	p->se.avg.decay_count = 0;
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
@@ -1651,6 +1652,11 @@ void sched_fork(struct task_struct *p)
 		p->sched_reset_on_fork = 0;
 	}
 
+	/* New forked task assumed with full utilization */
+#if defined(CONFIG_SMP)
+	p->se.avg.load_avg_contrib = p->se.load.weight;
+#endif
+
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9c2f726..2881d42 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1508,6 +1508,10 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	 * We track migrations using entity decay_count <= 0, on a wake-up
 	 * migration we use a negative decay count to track the remote decays
 	 * accumulated while sleeping.
+	 *
+	 * When enqueue a new forked task, the se->avg.decay_count == 0, so
+	 * we bypass update_entity_load_avg(), use avg.load_avg_contrib initial
+	 * value: se->load.weight.
 	 */
 	if (unlikely(se->avg.decay_count <= 0)) {
 		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
-- 
1.7.12

