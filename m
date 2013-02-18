Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3BRFIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:08:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:23970 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab3BRFIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:08:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258210182"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 15/15] sched: lazy power balance
Date: Mon, 18 Feb 2013 13:07:42 +0800
Message-Id: <1361164062-20111-16-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
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
similar performance/power value among different policy.

BTW, the lazy balance shows the performance gain when j is up to 32.

On my SNB EP 2 sockets machine with 8 cores * HT: 'make -j x' results:

		powersaving		balance		performance
x = 1    175.603 /417 13          175.220 /416 13        176.073 /407 13
x = 2    192.215 /218 23          194.522 /202 25        217.393 /200 23
x = 4    205.226 /124 39          208.823 /114 42        230.425 /105 41
x = 8    236.369 /71 59           249.005 /65 61         257.661 /62 62
x = 16   283.842 /48 73           307.465 /40 81         309.336 /39 82
x = 32   325.197 /32 96           333.503 /32 93         336.138 /32 92

data explains: 175.603 /417 13
	175.603: avagerage Watts
	417: seconds(compile time)
	13:  scaled performance/power = 1000000 / seconds / watts

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 68 ++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 66b05e1..5051990 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -941,6 +941,7 @@ struct sched_domain {
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
+	u64	perf_lb_record;	/* performance balance record */
 
 	u64 last_update;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3b1e9a6..f6ae655 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4514,6 +4514,60 @@ static inline void update_sd_lb_power_stats(struct lb_env *env,
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
+	if (env->perf_lb) {
+		env->sd->perf_lb_record |= 0x1;
+		return 1;
+	}
+
+	/*
+	 * The situation isn't eligible for performance balance. If this_cpu
+	 * is not eligible or the timing is not suitable for lazy powersaving
+	 * balance, we will stop both powersaving and performance balance.
+	 */
+	if (env->power_lb && sds->this == sds->group_leader
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
+	env->power_lb = 0;
+	sds->group_min = NULL;
+	return 0;
+}
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -5137,18 +5191,8 @@ find_busiest_group(struct lb_env *env, int *balance)
 	 */
 	update_sd_lb_stats(env, balance, &sds);
 
-	if (!env->perf_lb && !env->power_lb)
-		return  NULL;
-
-	if (env->power_lb) {
-		if (sds.this == sds.group_leader &&
-				sds.group_leader != sds.group_min) {
-			env->imbalance = sds.min_load_per_task;
-			return sds.group_min;
-		}
-		env->power_lb = 0;
-		return NULL;
-	}
+	if (!need_perf_balance(env, &sds))
+		return sds.group_min;
 
 	/*
 	 * this_cpu is not the appropriate cpu to perform load balancing at
-- 
1.7.12

