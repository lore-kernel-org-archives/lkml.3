Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaE3Ol6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:41:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:55149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959AbaE3Olz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:41:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548947206"
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
Subject: [RFC PATCH 14/16 v3] Intercept idle balancing
Date: Fri, 30 May 2014 14:36:10 +0800
Message-Id: <1401431772-14320-15-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
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
 kernel/sched/fair.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1c9ac08..220773f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6692,6 +6692,22 @@ static int idle_balance(struct rq *this_rq)
 
 	update_blocked_averages(this_cpu);
 	rcu_read_lock();
+
+	sd = top_flag_domain(this_cpu, SD_WORKLOAD_CONSOLIDATION);
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
 		unsigned long interval;
 		int continue_balancing = 1;
@@ -6724,6 +6740,7 @@ static int idle_balance(struct rq *this_rq)
 		if (pulled_task)
 			break;
 	}
+unlock:
 	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
-- 
1.7.9.5

