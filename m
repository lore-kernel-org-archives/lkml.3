Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbaE3OmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:42:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:55149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbaE3OmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:42:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548947239"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, bsegall@google.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [RFC PATCH 15/16 v3] Intercept periodic nohz idle balancing
Date: Fri, 30 May 2014 14:36:11 +0800
Message-Id: <1401431772-14320-16-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We intercept load balancing to contain the load and load balancing in
the consolidated CPUs according to our consolidating mechanism.

In periodic nohz idle balance, we skip the idle but non-consolidated
CPUs from load balancing.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   57 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 220773f..1b8dd45 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6869,10 +6869,47 @@ static struct {
 
 static inline int find_new_ilb(void)
 {
-	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	int ilb;
 
-	if (ilb < nr_cpu_ids && idle_cpu(ilb))
-		return ilb;
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
+		struct sched_domain *sd;
+		int this_cpu = smp_processor_id();
+
+		rcu_read_lock();
+		sd = top_flag_domain(this_cpu, SD_WORKLOAD_CONSOLIDATION);
+		if (sd) {
+			struct cpumask *nonshielded_cpus = __get_cpu_var(load_balance_mask);
+
+			cpumask_copy(nonshielded_cpus, nohz.idle_cpus_mask);
+
+			wc_nonshielded_mask(this_cpu, sd, nonshielded_cpus);
+			rcu_read_unlock();
+
+			if (cpumask_weight(nonshielded_cpus) < 2)
+				return nr_cpu_ids;
+
+			/*
+			 * get idle load balancer again
+			 */
+			ilb = cpumask_first(nonshielded_cpus);
+
+		    if (ilb < nr_cpu_ids && idle_cpu(ilb))
+				return ilb;
+		}
+		else {
+			rcu_read_unlock();
+			return ilb;
+		}
+	}
 
 	return nr_cpu_ids;
 }
@@ -7109,7 +7146,7 @@ out:
  * In CONFIG_NO_HZ_COMMON case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
-static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle, struct cpumask *mask)
 {
 	int this_cpu = this_rq->cpu;
 	struct rq *rq;
@@ -7119,7 +7156,7 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 	    !test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu)))
 		goto end;
 
-	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
+	for_each_cpu(balance_cpu, mask) {
 		if (balance_cpu == this_cpu || !idle_cpu(balance_cpu))
 			continue;
 
@@ -7167,10 +7204,10 @@ static inline int nohz_kick_needed(struct rq *rq)
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
 
@@ -7213,7 +7250,7 @@ need_kick:
 	return 1;
 }
 #else
-static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle) { }
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle, struct cpumask *mask) { }
 #endif
 
 /*
-- 
1.7.9.5

