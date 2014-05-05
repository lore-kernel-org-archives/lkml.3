Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaEEIKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:10:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:46110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380AbaEEIJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="526078766"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 11/12 v1] Intercept periodic load balance
Date: Mon,  5 May 2014 08:02:51 +0800
Message-Id: <1399248172-13871-12-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 374c86b..6cbf6c5 100644
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
+	 * if we encounter shadowded cpus here, don't do balance on them
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

