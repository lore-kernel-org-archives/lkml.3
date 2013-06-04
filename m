Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab3FDGXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:23:24 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36229 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3FDGXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:23:21 -0400
Message-ID: <51AD87D0.7020300@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 14:23:12 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/3] sched: don't repeat the initialization in sched_init()
References: <51AD87A8.6080608@linux.vnet.ibm.com>
In-Reply-To: <51AD87A8.6080608@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060406-8256-0000-0000-000007C86CE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sched_init(), there is no need to initialize 'root_task_group.shares' and
'root_task_group.cfs_bandwidth' repeatedly.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/core.c |   46 +++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..c0c3716 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6955,6 +6955,31 @@ void __init sched_init(void)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	root_task_group.shares = ROOT_TASK_GROUP_LOAD;
+
+	/*
+	 * How much cpu bandwidth does root_task_group get?
+	 *
+	 * In case of task-groups formed thr' the cgroup filesystem, it
+	 * gets 100% of the cpu resources in the system. This overall
+	 * system cpu resource is divided among the tasks of
+	 * root_task_group and its child task-groups in a fair manner,
+	 * based on each entity's (task or task-group's) weight
+	 * (se->load.weight).
+	 *
+	 * In other words, if root_task_group has 10 tasks of weight
+	 * 1024) and two child groups A0 and A1 (of weight 1024 each),
+	 * then A0's share of the cpu resource is:
+	 *
+	 *	A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
+	 *
+	 * We achieve this by letting root_task_group's tasks sit
+	 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
+	 */
+	init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
+#endif
+
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
@@ -6966,28 +6991,7 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
-		/*
-		 * How much cpu bandwidth does root_task_group get?
-		 *
-		 * In case of task-groups formed thr' the cgroup filesystem, it
-		 * gets 100% of the cpu resources in the system. This overall
-		 * system cpu resource is divided among the tasks of
-		 * root_task_group and its child task-groups in a fair manner,
-		 * based on each entity's (task or task-group's) weight
-		 * (se->load.weight).
-		 *
-		 * In other words, if root_task_group has 10 tasks of weight
-		 * 1024) and two child groups A0 and A1 (of weight 1024 each),
-		 * then A0's share of the cpu resource is:
-		 *
-		 *	A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
-		 *
-		 * We achieve this by letting root_task_group's tasks sit
-		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
-		 */
-		init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
 		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-- 
1.7.4.1

