Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaFWPsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:48:33 -0400
Received: from shelob.surriel.com ([74.92.59.67]:54925 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaFWPsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:48:32 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.com, mgorman@suse.de,
        mingo@kernel.org
Subject: [PATCH 6/7] sched,numa: rework best node setting in task_numa_migrate
Date: Mon, 23 Jun 2014 11:41:34 -0400
Message-Id: <1403538095-31256-7-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1403538095-31256-1-git-send-email-riel@redhat.com>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Fix up the best node setting in task_numa_migrate to deal with a task
in a pseudo-interleaved NUMA group, which is already running in the
best location.

Set the task's preferred nid to the current nid, so task migration is
not retried at a high rate.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d525451..ee35576 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1354,10 +1354,6 @@ static int task_numa_migrate(struct task_struct *p)
 		}
 	}
 
-	/* No better CPU than the current one was found. */
-	if (env.best_cpu == -1)
-		return -EAGAIN;
-
 	/*
 	 * If the task is part of a workload that spans multiple NUMA nodes,
 	 * and is migrating into one of the workload's active nodes, remember
@@ -1366,8 +1362,19 @@ static int task_numa_migrate(struct task_struct *p)
 	 * A task that migrated to a second choice node will be better off
 	 * trying for a better one later. Do not set the preferred node here.
 	 */
-	if (p->numa_group && node_isset(env.dst_nid, p->numa_group->active_nodes))
-		sched_setnuma(p, env.dst_nid);
+	if (p->numa_group) {
+		if (env.best_cpu == -1)
+			nid = env.src_nid;
+		else
+			nid = env.dst_nid;
+
+		if (node_isset(nid, p->numa_group->active_nodes))
+			sched_setnuma(p, env.dst_nid);
+	}
+
+	/* No better CPU than the current one was found. */
+	if (env.best_cpu == -1)
+		return -EAGAIN;
 
 	/*
 	 * Reset the scan period if the task is being rescheduled on an
-- 
1.8.5.3

