Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaEEIJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:09:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:46110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbaEEIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="526078785"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 12/12 v1] Intercept RT provocatively
Date: Mon,  5 May 2014 08:02:52 +0800
Message-Id: <1399248172-13871-13-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/rt.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index bd2267a..f8141fb 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1217,6 +1217,9 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 {
 	struct task_struct *curr;
 	struct rq *rq;
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	int do_find = 0;
+#endif
 
 	if (p->nr_cpus_allowed == 1)
 		goto out;
@@ -1230,6 +1233,11 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 	rcu_read_lock();
 	curr = ACCESS_ONCE(rq->curr); /* unlocked access */
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	if (workload_consolidation_cpu_shielded(cpu))
+		do_find = 1;
+#endif
+
 	/*
 	 * If the current task on @p's runqueue is an RT task, then
 	 * try to see if we can wake this RT task up on another
@@ -1252,9 +1260,15 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 	 * This test is optimistic, if we get it wrong the load-balancer
 	 * will have to sort it out.
 	 */
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	if (do_find || (curr && unlikely(rt_task(curr)) &&
+	    (curr->nr_cpus_allowed < 2 ||
+	     curr->prio <= p->prio))) {
+#else
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->nr_cpus_allowed < 2 ||
 	     curr->prio <= p->prio)) {
+#endif
 		int target = find_lowest_rq(p);
 
 		if (target != -1)
@@ -1460,6 +1474,12 @@ static int find_lowest_rq(struct task_struct *task)
 	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
 		return -1; /* No targets found */
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	workload_consolidation_nonshielded_mask(this_cpu, lowest_mask);
+	if (!cpumask_weight(lowest_mask))
+		return -1;
+#endif
+
 	/*
 	 * At this point we have built a mask of cpus representing the
 	 * lowest priority tasks in the system.  Now we want to elect
@@ -1687,6 +1707,11 @@ static int pull_rt_task(struct rq *this_rq)
 	if (likely(!rt_overloaded(this_rq)))
 		return 0;
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	if (workload_consolidation_cpu_shielded(this_cpu))
+		return 0;
+#endif
+
 	/*
 	 * Match the barrier from rt_set_overloaded; this guarantees that if we
 	 * see overloaded we must also see the rto_mask bit.
-- 
1.7.9.5

