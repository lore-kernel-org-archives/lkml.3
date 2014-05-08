Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaEHKo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:44:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbaEHKoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:44:23 -0400
Date: Thu, 8 May 2014 03:43:06 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-68d1b02a58f5d9f584c1fb2923ed60ec68cbbd9b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        chegu_vinod@hp.com, mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        chegu_vinod@hp.com, mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1397235629-16328-4-git-send-email-riel@redhat.com>
References: <1397235629-16328-4-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Do not set preferred_node on migration to a second choice node
Git-Commit-ID: 68d1b02a58f5d9f584c1fb2923ed60ec68cbbd9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68d1b02a58f5d9f584c1fb2923ed60ec68cbbd9b
Gitweb:     http://git.kernel.org/tip/68d1b02a58f5d9f584c1fb2923ed60ec68cbbd9b
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 11 Apr 2014 13:00:29 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:47 +0200

sched/numa: Do not set preferred_node on migration to a second choice node

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
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1397235629-16328-4-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ecea8d9..051903f 100644
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
