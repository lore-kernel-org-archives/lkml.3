Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaFYIkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:40:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:15864 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbaFYIka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:40:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="449717530"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [RFC PATCH 7/9 v4] Implement Workload Consolidation in idle_balance
Date: Wed, 25 Jun 2014 08:36:06 +0800
Message-Id: <1403656568-32445-8-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
References: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Skip pulling task to the idle non-consolidated CPUs.

2) In addition, for consolidated Idle CPU, we aggressively pull tasks from
   non-consolidated CPUs.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 008cbc9..bf65fde 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2608,6 +2608,9 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 static inline void update_cpu_concurrency(struct rq *rq);
 static struct sched_group *wc_find_group(struct sched_domain *sd,
 	struct task_struct *p, int this_cpu);
+static void wc_unload(struct cpumask *nonshielded, struct sched_domain *sd);
+static void wc_nonshielded_mask(int cpu, struct sched_domain *sd,
+	struct cpumask *mask);
 static int cpu_cc_capable(int cpu);
 
 /*
@@ -6808,6 +6811,22 @@ static int idle_balance(struct rq *this_rq)
 
 	update_blocked_averages(this_cpu);
 	rcu_read_lock();
+
+	sd = per_cpu(sd_wc, this_cpu);
+	if (sd) {
+		struct cpumask *nonshielded_cpus = __get_cpu_var(load_balance_mask);
+
+		cpumask_copy(nonshielded_cpus, cpu_active_mask);
+
+		/*
+		 * if we encounter shielded cpus here, don't do balance on them
+		 */
+		wc_nonshielded_mask(this_cpu, sd, nonshielded_cpus);
+		if (!cpumask_test_cpu(this_cpu, nonshielded_cpus))
+			goto unlock;
+		wc_unload(nonshielded_cpus, sd);
+	}
+
 	for_each_domain(this_cpu, sd) {
 		int continue_balancing = 1;
 		u64 t0, domain_cost;
@@ -6843,6 +6862,7 @@ static int idle_balance(struct rq *this_rq)
 		if (pulled_task || this_rq->nr_running > 0)
 			break;
 	}
+unlock:
 	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
-- 
1.7.9.5

