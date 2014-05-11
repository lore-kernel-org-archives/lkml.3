Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaELCXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:23:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:8857 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538AbaELCXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:23:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="530200873"
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
Subject: [RFC PATCH 11/12 v2] Intercept periodic load balancing
Date: Mon, 12 May 2014 02:17:00 +0800
Message-Id: <1399832221-8314-12-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
References: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We intercept load balancing to contain the load and load balancing in
the consolidated CPUs according to our consolidating mechanism.

In periodic load balancing, we do two things:

1) Skip pulling task to the non-consolidated CPUs.

2) In addition, for consolidated Idle CPU, we aggressively pull tasks from
non-consolidated CPUs.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9bb1304..1c7a3d7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7260,6 +7260,36 @@ static void run_rebalance_domains(struct softirq_action *h)
 	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	struct cpumask *nonshielded = __get_cpu_var(local_cpu_mask);
+	int this_cpu = cpu_of(this_rq);
+
+	/*
+	 * if we encounter shielded cpus here, don't do balance on them
+	 */
+	cpumask_copy(nonshielded, cpu_active_mask);
+
+	rcu_read_lock();
+	workload_consolidation_nonshielded_mask(this_cpu, nonshielded);
+	rcu_read_unlock();
+
+	/*
+	 * aggressively unload the shielded cpus to unshielded cpus
+	 */
+	workload_consolidation_unload(nonshielded);
+
+	if (cpumask_test_cpu(this_cpu, nonshielded)) {
+		rebalance_domains(this_rq, idle);
+
+		/*
+		 * If this cpu has a pending nohz_balance_kick, then do the
+		 * balancing on behalf of the other idle cpus whose ticks are
+		 * stopped.
+		 */
+		cpumask_and(nonshielded, nonshielded, nohz.idle_cpus_mask);
+		nohz_idle_balance(this_rq, idle, nonshielded);
+	}
+#else
 	rebalance_domains(this_rq, idle);
 
 	/*
@@ -7267,7 +7297,8 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	nohz_idle_balance(this_rq, idle);
+	nohz_idle_balance(this_rq, idle, nohz.idle_cpus_mask);
+#endif
 }
 
 /*
-- 
1.7.9.5

