Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaHKLuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:50:02 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58678 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaHKLuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:50:00 -0400
Subject: [RFC PATCH V2 18/19] sched: lazy power balance
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:19:34 +0530
Message-ID: <20140811114916.32407.88823.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811114501.32407.61304.stgit@preeti.in.ibm.com>
References: <20140811114501.32407.61304.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-1542-0000-0000-000003E847FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

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
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 include/linux/sched.h |    4 ++-
 kernel/sched/fair.c   |   70 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 009da6a..990b6b9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -938,7 +938,9 @@ struct sched_domain {
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
-
+#ifdef CONFIG_SCHED_POWER
+	u64	perf_lb_record;	/* performance balance record */
+#endif
 	/* idle_balance() stats */
 	u64 max_newidle_lb_cost;
 	unsigned long next_decay_max_lb_cost;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2e64e96..c49ee6c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6743,6 +6743,62 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		return fix_small_imbalance(env, sds);
 }
 
+#ifdef CONFIG_SCHED_POWER
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
+	if (env->flags & LBF_POWER_BAL && sds->local == sds->group_leader
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
+#endif
+
 /******* find_busiest_group() helpers end here *********************/
 
 /**
@@ -6776,18 +6832,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	update_sd_lb_stats(env, &sds);
 
 #ifdef CONFIG_SCHED_POWER
-        if (!(env->flags & LBF_POWER_BAL) && !(env->flags & LBF_PERF_BAL))
-                return  NULL;
- 
-        if (env->flags & LBF_POWER_BAL) {
-                if (sds.this == sds.group_leader &&
-                                sds.group_leader != sds.group_min) {
-                        env->imbalance = sds.min_load_per_task;
-                        return sds.group_min;
-                }
-                env->flags &= ~LBF_POWER_BAL;
-                return NULL;
-        }
+	if (!need_perf_balance(env, &sds))
+		return sds.group_min;
 #endif
 	local = &sds.local_stat;
 	busiest = &sds.busiest_stat;

