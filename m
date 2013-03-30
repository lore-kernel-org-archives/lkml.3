Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3C3Ogc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:36:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:7911 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab3C3Og3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:36:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568392"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 20/21] sched: lazy power balance
Date: Sat, 30 Mar 2013 22:35:07 +0800
Message-Id: <1364654108-16307-21-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When active task number in sched domain waves around the power friendly
scheduling creteria, scheduling will thresh between the power friendly
balance and performance balance, bring unnecessary task migration.
The typical benchmark is 'make -j x'.

To remove such issue, introduce a u64 perf_lb_record variable to record
performance load balance history. If there is no performance LB for
continuing 32 times load balancing, or no LB for 8 times max_interval ms,
or only 4 times performance LB in last 64 times load balancing, then we
accept a power friendly LB. Otherwise, give up this time power friendly
LB chance, do nothing.

With this patch, the worst case for power scheduling -- kbuild, gets
similar performance/watts value among different policy.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 68 ++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 226a515..4b9b810 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -906,6 +906,7 @@ struct sched_domain {
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
+	u64	perf_lb_record;	/* performance balance record */
 
 	u64 last_update;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8019106..430904b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4505,6 +4505,60 @@ static inline void update_sd_lb_power_stats(struct lb_env *env,
 	}
 }
 
+#define PERF_LB_HH_MASK		0xffffffff00000000ULL
+#define PERF_LB_LH_MASK		0xffffffffULL
+
+/**
+ * need_perf_balance - Check if the performance load balance needed
+ * in the sched_domain.
+ *
+ * @env: The load balancing environment.
+ * @sds: Variable containing the statistics of the sched_domain
+ */
+static int need_perf_balance(struct lb_env *env, struct sd_lb_stats *sds)
+{
+	env->sd->perf_lb_record <<= 1;
+
+	if (env->flags & LBF_PERF_BAL) {
+		env->sd->perf_lb_record |= 0x1;
+		return 1;
+	}
+
+	/*
+	 * The situation isn't eligible for performance balance. If this_cpu
+	 * is not eligible or the timing is not suitable for lazy powersaving
+	 * balance, we will stop both powersaving and performance balance.
+	 */
+	if (env->flags & LBF_POWER_BAL && sds->this == sds->group_leader
+			&& sds->group_leader != sds->group_min) {
+		int interval;
+
+		/* powersaving balance interval set as 8 * max_interval */
+		interval = msecs_to_jiffies(8 * env->sd->max_interval);
+		if (time_after(jiffies, env->sd->last_balance + interval))
+			env->sd->perf_lb_record = 0;
+
+		/*
+		 * A eligible timing is no performance balance in last 32
+		 * balance and performance balance is no more than 4 times
+		 * in last 64 balance, or no balance in powersaving interval
+		 * time.
+		 */
+		if ((hweight64(env->sd->perf_lb_record & PERF_LB_HH_MASK) <= 4)
+			&& !(env->sd->perf_lb_record & PERF_LB_LH_MASK)) {
+
+			env->imbalance = sds->min_load_per_task;
+			return 0;
+		}
+
+	}
+
+	/* give up this time power balancing, do nothing */
+	env->flags &= ~LBF_POWER_BAL;
+	sds->group_min = NULL;
+	return 0;
+}
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -5124,18 +5178,8 @@ find_busiest_group(struct lb_env *env, int *balance)
 	 */
 	update_sd_lb_stats(env, balance, &sds);
 
-	if (!(env->flags & LBF_POWER_BAL) && !(env->flags & LBF_PERF_BAL))
-		return  NULL;
-
-	if (env->flags & LBF_POWER_BAL) {
-		if (sds.this == sds.group_leader &&
-				sds.group_leader != sds.group_min) {
-			env->imbalance = sds.min_load_per_task;
-			return sds.group_min;
-		}
-		env->flags &= ~LBF_POWER_BAL;
-		return NULL;
-	}
+	if (!need_perf_balance(env, &sds))
+		return sds.group_min;
 
 	/*
 	 * this_cpu is not the appropriate cpu to perform load balancing at
-- 
1.7.12

