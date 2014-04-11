Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbaDKRYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:24:20 -0400
Received: from shelob.surriel.com ([74.92.59.67]:48407 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaDKRYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:24:18 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, chegu_vinod@hp.com,
        mgorman@suse.de
Subject: [PATCH 3/3] sched,numa: do not set preferred_node on migration to a second choice node
Date: Fri, 11 Apr 2014 13:00:29 -0400
Message-Id: <1397235629-16328-4-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1397235629-16328-1-git-send-email-riel@redhat.com>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Setting the numa_preferred_node for a task in task_numa_migrate
does nothing on a 2-node system. Either we migrate to the node
that already was our preferred node, or we stay where we were.

On a 4-node system, it can slightly decrease overhead, by not
calling the NUMA code as much. Since every node tends to be
directly connected to every other node, running on the wrong
node for a while does not do much damage.

However, on an 8 node system, there are far more bad nodes
than there are good ones, and pretending that a second choice
is actually the preferred node can greatly delay, or even
prevent, a workload from converging.

The only time we can safely pretend that a second choice
node is the preferred node is when the task is part of a
workload that spans multiple NUMA nodes.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Vinod Chegu <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index babd316..302facf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1301,7 +1301,16 @@ static int task_numa_migrate(struct task_struct *p)
 	if (env.best_cpu == -1)
 		return -EAGAIN;
 
-	sched_setnuma(p, env.dst_nid);
+	/*
+	 * If the task is part of a workload that spans multiple NUMA nodes,
+	 * and is migrating into one of the workload's active nodes, remember
+	 * this node as the task's preferred numa node, so the workload can
+	 * settle down.
+	 * A task that migrated to a second choice node will be better off
+	 * trying for a better one later. Do not set the preferred node here.
+	 */
+	if (p->numa_group && node_isset(env.dst_nid, p->numa_group->active_nodes))
+		sched_setnuma(p, env.dst_nid);
 
 	/*
 	 * Reset the scan period if the task is being rescheduled on an
-- 
1.8.5.3

