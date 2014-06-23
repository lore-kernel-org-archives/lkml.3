Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaFWPtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:49:23 -0400
Received: from shelob.surriel.com ([74.92.59.67]:54937 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaFWPtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:49:22 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, chegu_vinod@hp.com,
        mgorman@suse.de
Subject: [PATCH 4/7] sched,numa: simplify task_numa_compare
Date: Mon, 23 Jun 2014 11:46:15 -0400
Message-Id: <1403538378-31571-4-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1403538378-31571-1-git-send-email-riel@redhat.com>
References: <1403538378-31571-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

When a task is part of a numa_group, the comparison should always use
the group weight, in order to make workloads converge.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 41b75a6..2eb845c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1154,7 +1154,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	struct task_group *tg;
 	long src_load, dst_load;
 	long load;
-	long imp = (groupimp > 0) ? groupimp : taskimp;
+	long imp = env->p->numa_group ? groupimp : taskimp;
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
@@ -1192,11 +1192,6 @@ static void task_numa_compare(struct task_numa_env *env,
 			 * itself (not part of a group), use the task weight
 			 * instead.
 			 */
-			if (env->p->numa_group)
-				imp = groupimp;
-			else
-				imp = taskimp;
-
 			if (cur->numa_group)
 				imp += group_weight(cur, env->src_nid) -
 				       group_weight(cur, env->dst_nid);
-- 
1.8.5.3

