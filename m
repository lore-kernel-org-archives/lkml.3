Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbaEEIK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:10:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:46110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbaEEIJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="526078744"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 10/12 v1] Intercept periodic nohz idle balance
Date: Mon,  5 May 2014 08:02:50 +0800
Message-Id: <1399248172-13871-11-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d921c20..374c86b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6867,10 +6867,46 @@ static struct {
 
 static inline int find_new_ilb(void)
 {
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	struct cpumask *nonshielded = __get_cpu_var(local_cpu_mask);
+	int ilb, weight;
+	int this_cpu = smp_processor_id();
+
+	/*
+	 * Optimize for the case when we have no idle CPUs or only one
+	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
+	 */
+	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
+		return nr_cpu_ids;
+
+	ilb = cpumask_first(nohz.idle_cpus_mask);
+
+	if (ilb < nr_cpu_ids && idle_cpu(ilb)) {
+
+		cpumask_copy(nonshielded, nohz.idle_cpus_mask);
+
+		rcu_read_lock();
+		workload_consolidation_nonshielded_mask(this_cpu, nonshielded);
+		rcu_read_unlock();
+
+		weight = cpumask_weight(nonshielded);
+
+		if (weight < 2)
+			return nr_cpu_ids;
+
+		/*
+		 * get idle load balancer again
+		 */
+		ilb = cpumask_first(nonshielded);
+	    if (ilb < nr_cpu_ids && idle_cpu(ilb))
+			return ilb;
+	}
+#else
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
 
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
+#endif
 
 	return nr_cpu_ids;
 }
@@ -7107,7 +7143,7 @@ out:
  * In CONFIG_NO_HZ_COMMON case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
-static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle, struct cpumask *mask)
 {
 	int this_cpu = this_rq->cpu;
 	struct rq *rq;
@@ -7117,7 +7153,7 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 	    !test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu)))
 		goto end;
 
-	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
+	for_each_cpu(balance_cpu, mask) {
 		if (balance_cpu == this_cpu || !idle_cpu(balance_cpu))
 			continue;
 
@@ -7165,10 +7201,10 @@ static inline int nohz_kick_needed(struct rq *rq)
 	if (unlikely(rq->idle_balance))
 		return 0;
 
-       /*
-	* We may be recently in ticked or tickless idle mode. At the first
-	* busy tick after returning from idle, we will update the busy stats.
-	*/
+	/*
+	 * We may be recently in ticked or tickless idle mode. At the first
+	 * busy tick after returning from idle, we will update the busy stats.
+	 */
 	set_cpu_sd_state_busy();
 	nohz_balance_exit_idle(cpu);
 
@@ -7211,7 +7247,7 @@ need_kick:
 	return 1;
 }
 #else
-static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle) { }
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle, struct cpumask *mask) { }
 #endif
 
 /*
-- 
1.7.9.5

