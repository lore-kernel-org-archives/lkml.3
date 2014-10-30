Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161417AbaJ3Wjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:39:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:35961 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161393AbaJ3Wjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:39:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,289,1413270000"; 
   d="scan'208";a="623777740"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3 1/6] sched/rt: cleanup check preempt equal prio
Date: Fri, 31 Oct 2014 06:39:31 +0800
Message-Id: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks if current can be pushed/pulled somewhere else 
in advance to make logic clear, the same behavior as dl class.

- If current can't be migrated, useless to reschedule, let's hope 
  task can move out.
- If task is migratable, so let's not schedule it and see if it 
  can be pushed or pulled somewhere else.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v2 -> v3:
 * cleanup subject/comments
 * align multi-line if() correctly

 kernel/sched/rt.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d024e6c..a0b51aa 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1351,16 +1351,22 @@ out:
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	if (rq->curr->nr_cpus_allowed == 1)
+	/*
+	 * Current can't be migrated, useless to reschedule,
+	 * let's hope p can move out.
+	 */
+	if (rq->curr->nr_cpus_allowed == 1 ||
+	    !cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
 		return;
 
+	/*
+	 * p is migratable, so let's not schedule it and
+	 * see if it is pushed or pulled somewhere else.
+	 */
 	if (p->nr_cpus_allowed != 1
 	    && cpupri_find(&rq->rd->cpupri, p, NULL))
 		return;
 
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
-		return;
-
 	/*
 	 * There appears to be other cpus that can accept
 	 * current and none to run 'p', so lets reschedule
-- 
1.9.1

