Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaFDUKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaFDUKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:10:02 -0400
Date: Wed, 4 Jun 2014 16:09:42 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, mingo@kernel.org
Subject: [PATCH] sched,numa: ensure task_numa_migrate checks the preferred
 node
Message-ID: <20140604160942.6969b101@cuia.bos.redhat.com>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first thing task_numa_migrate does is check to see if there is
CPU capacity available on the preferred node, in order to move the
task there.

However, if the preferred node is all busy, we would skip considering
that node for tasks swaps in the subsequent loop. This prevents NUMA
convergence of tasks on busy systems.

However, swapping locations with a task on our preferred nid, when
the preferred nid is busy, is perfectly fine.

The fix is to also look for a CPU on our preferred nid when it is
totally busy.

This changes "perf bench numa mem -p 4 -t 20 -m -0 -P 1000" from
not converging in 15 minutes on my 4 node system, to converging in
10-20 seconds.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: stable@vger.kernel.org
---
This is a safe, simple patch to fix NUMA convergence, which is why
it should go to -stable, IMHO.

 kernel/sched/fair.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e5884d8..824e241 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1425,9 +1425,8 @@ static int task_numa_migrate(struct task_struct *p)
 	groupimp = group_weight(p, env.dst_nid, false) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/* If the preferred nid has capacity, try to use it. */
-	if (env.dst_stats.has_capacity)
-		task_numa_find_cpu(&env, taskimp, groupimp);
+	/* Try to find a spot on the preferred nid. */
+	task_numa_find_cpu(&env, taskimp, groupimp);
 
 	/* No space available on the preferred nid. Look elsewhere. */
 	if (env.best_cpu == -1) {

