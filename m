Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbaELCX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:23:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:8842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524AbaELCW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:22:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="530200855"
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
Subject: [RFC PATCH 08/12 v2] Intercept wakeup/fork/exec load balancing
Date: Mon, 12 May 2014 02:16:57 +0800
Message-Id: <1399832221-8314-9-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
References: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We intercept load balancing to contain the load and load balancing in
the consolidated CPUs according to our consolidating mechanism.

In wakeup load balaning, we do not select idle, if the CC of the wakee
and waker (in this order if SD_WAKE_AFFINE) is capable of handling the
wakee task. And in fork/exec load balancing when finding the sched_group,
we find the consolidated group.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e7153ff..c7a6347 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4365,9 +4365,16 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_domain *sd;
 	struct sched_group *sg;
 	int i = task_cpu(p);
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	int ret;
 
+	ret = workload_consolidation_wakeup(i, target);
+	if (ret < nr_cpu_ids)
+		return ret;
+#else
 	if (idle_cpu(target))
 		return target;
+#endif
 
 	/*
 	 * If the prevous cpu is cache affine and idle, don't be stupid.
@@ -4460,7 +4467,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	}
 
 	while (sd) {
-		struct sched_group *group;
+		struct sched_group *group = NULL;
 		int weight;
 
 		if (!(sd->flags & sd_flag)) {
@@ -4468,6 +4475,12 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 			continue;
 		}
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+		if (sd->flags & SD_WORKLOAD_CONSOLIDATION)
+			group = workload_consolidation_find_group(sd, p, cpu);
+
+		if (!group)
+#endif
 		group = find_idlest_group(sd, p, cpu, sd_flag);
 		if (!group) {
 			sd = sd->child;
-- 
1.7.9.5

