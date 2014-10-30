Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaJaHcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:32:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:52623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbaJaHcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:32:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408960697"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com, dietmar.eggemann@arm.com,
        umgwanakikbuti@gmail.com, Yuyang Du <yuyang.du@intel.com>
Subject: [PATCH 3/3 v6] sched: Remove task and group entity load_avg when they are dead
Date: Fri, 31 Oct 2014 07:32:28 +0800
Message-Id: <1414711948-10475-4-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414711948-10475-1-git-send-email-yuyang.du@intel.com>
References: <1414711948-10475-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When task exits or group is destroyed, the entity's load_avg should be
removed from its parent cfs_rq's load_avg. Otherwise, it will take time
for the parent cfs_rq to decay the dead entity's load_avg to 0, which
is not desired.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f40f974..b52ee68 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4444,6 +4444,11 @@ static void migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 	/* We have migrated, no longer consider this task hot */
 	p->se.exec_start = 0;
 }
+
+static void task_dead_fair(struct task_struct *p)
+{
+	remove_entity_load_avg(&p->se);
+}
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -7520,8 +7525,11 @@ void free_fair_sched_group(struct task_group *tg)
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
-		if (tg->se)
+		if (tg->se) {
+			if (tg->se[i])
+				remove_entity_load_avg(tg->se[i]);
 			kfree(tg->se[i]);
+		}
 	}
 
 	kfree(tg->cfs_rq);
@@ -7707,6 +7715,7 @@ const struct sched_class fair_sched_class = {
 	.rq_offline		= rq_offline_fair,
 
 	.task_waking		= task_waking_fair,
+	.task_dead			= task_dead_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,
-- 
1.7.9.5

