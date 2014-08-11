Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaHKLlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:41:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52609 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaHKLlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:41:06 -0400
Subject: [RFC PATCH V2 15/19] sched: pull all tasks from source grp and no
 balance for prefer_sibling
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
Date: Mon, 11 Aug 2014 17:10:43 +0530
Message-ID: <20140811114033.31956.52263.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-9332-0000-0000-000001A6A4D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

In power balance, we hope some sched groups are fully empty to save
CPU power of them. So, we want to move any tasks from them.

Also in power aware scheduling, we don't want to balance 'prefer_sibling'
groups just because local group has capacity. If the local group has no tasks
at the time, that is the power balance hope so.

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f9b2a21..fd93eaf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6346,6 +6346,21 @@ static inline enum fbq_type fbq_classify_rq(struct rq *rq)
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+#ifdef CONFIG_SCHED_POWER
+static int get_power_policy(struct lb_env *env)
+{
+	if (env->flags & LBF_PERF_BAL)
+		return 0;
+	else
+		return 1;
+}
+#else
+static int get_power_policy(struct lb_env *env)
+{
+	return 0;
+}
+#endif /* CONFIG_SCHED_POWER */
+
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
@@ -6358,6 +6373,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	struct sg_lb_stats tmp_sgs;
 	int load_idx, prefer_sibling = 0;
 	bool overload = false;
+	int powersave = 0;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
@@ -6393,9 +6409,14 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		 * extra check prevents the case where you always pull from the
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
+		 *
+		 * In power aware scheduling, we don't care load weight and
+		 * want not to pull tasks just because local group has capacity.
 		 */
+		powersave = get_power_policy(env);
+
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_free_capacity)
+		    sds->local_stat.group_has_free_capacity && !powersave)
 			sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
@@ -6761,8 +6782,15 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu capacity.
 		 */
+#ifdef CONFIG_SCHED_POWER
+		if (rq->nr_running == 0 ||
+			(!(env->flags & LBF_POWER_BAL) && capacity_factor &&
+				rq->nr_running == 1 && wl > env->imbalance))
+ 			continue;
+#else
 		if (capacity_factor && rq->nr_running == 1 && wl > env->imbalance)
 			continue;
+#endif /* CONFIG_SCHED_POWER */
 
 		/*
 		 * For the load comparisons with the other cpu's, consider
@@ -6848,6 +6876,25 @@ static int should_we_balance(struct lb_env *env)
 	return balance_cpu == env->dst_cpu;
 }
 
+#ifdef CONFIG_SCHED_POWER
+static int is_busiest_eligible(struct rq *rq, struct lb_env *env)
+{
+	if (rq->nr_running > 1 ||
+		(rq->nr_running == 1 && env->flags & LBF_POWER_BAL))
+			return 1;
+	else
+		return 0;
+}
+#else
+static int is_busiest_eligible(struct rq *rq, struct lb_env *env)
+{
+	if (rq->nr_running > 1)
+		return 1;
+	else
+		return 0;
+}
+#endif /* CONFIG_SCHED_POWER */
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
@@ -6911,7 +6958,7 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
-	if (busiest->nr_running > 1) {
+	if (is_busiest_eligible(busiest, &env)) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
 		 * an imbalance but busiest->nr_running <= 1, the group is

