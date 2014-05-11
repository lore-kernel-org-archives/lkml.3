Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbaELCX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:23:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:8861 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525AbaELCW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:22:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="530200863"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 09/12 v2] Intercept idle balancing
Date: Mon, 12 May 2014 02:16:58 +0800
Message-Id: <1399832221-8314-10-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
References: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We intercept load balancing to contain the load and load balancing in
the consolidated CPUs according to our consolidating mechanism.

In idle balancing, we do two things:

1) Skip pulling task to the idle non-consolidated CPUs.

2) In addition, for consolidated Idle CPU, we aggressively pull tasks from
non-consolidated CPUs.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7a6347..94c7a6a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6655,6 +6655,10 @@ out:
 	return ld_moved;
 }
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
+#endif
+
 /*
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
@@ -6666,6 +6670,9 @@ static int idle_balance(struct rq *this_rq)
 	unsigned long next_balance = jiffies + HZ;
 	u64 curr_cost = 0;
 	int this_cpu = this_rq->cpu;
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	struct cpumask *nonshielded = __get_cpu_var(local_cpu_mask);
+#endif
 
 	idle_enter_fair(this_rq);
 	/*
@@ -6684,6 +6691,19 @@ static int idle_balance(struct rq *this_rq)
 
 	update_blocked_averages(this_cpu);
 	rcu_read_lock();
+
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	cpumask_copy(nonshielded, cpu_active_mask);
+
+	/*
+	 * if we encounter shielded cpus here, don't do balance on them
+	 */
+	workload_consolidation_nonshielded_mask(this_cpu, nonshielded);
+	if (!cpumask_test_cpu(this_cpu, nonshielded))
+		goto unlock;
+	workload_consolidation_unload(nonshielded);
+#endif
+
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int continue_balancing = 1;
@@ -6716,6 +6736,9 @@ static int idle_balance(struct rq *this_rq)
 		if (pulled_task)
 			break;
 	}
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+unlock:
+#endif
 	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
@@ -7709,6 +7732,14 @@ void print_cfs_stats(struct seq_file *m, int cpu)
 __init void init_sched_fair_class(void)
 {
 #ifdef CONFIG_SMP
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	unsigned int i;
+	for_each_possible_cpu(i) {
+		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
+					GFP_KERNEL, cpu_to_node(i));
+	}
+#endif
+
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
 #ifdef CONFIG_NO_HZ_COMMON
-- 
1.7.9.5

