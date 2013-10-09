Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab3JIRb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:31:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3JIRbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:31:24 -0400
Date: Wed, 9 Oct 2013 10:30:43 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-e1dda8a797b59d7ec4b17e393152ec3273a552d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-42-git-send-email-mgorman@suse.de>
References: <1381141781-10992-42-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Fix placement of workloads spread across multiple nodes
Git-Commit-ID: e1dda8a797b59d7ec4b17e393152ec3273a552d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:30:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1dda8a797b59d7ec4b17e393152ec3273a552d5
Gitweb:     http://git.kernel.org/tip/e1dda8a797b59d7ec4b17e393152ec3273a552d5
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:19 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:47:43 +0200

sched/numa: Fix placement of workloads spread across multiple nodes

The load balancer will spread workloads across multiple NUMA nodes,
in order to balance the load on the system. This means that sometimes
a task's preferred node has available capacity, but moving the task
there will not succeed, because that would create too large an imbalance.

In that case, other NUMA nodes need to be considered.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-42-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 09aac90..aa561c8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1104,13 +1104,12 @@ static int task_numa_migrate(struct task_struct *p)
 	imp = task_faults(env.p, env.dst_nid) - faults;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/*
-	 * If the preferred nid has capacity then use it. Otherwise find an
-	 * alternative node with relatively better statistics.
-	 */
-	if (env.dst_stats.has_capacity) {
+	/* If the preferred nid has capacity, try to use it. */
+	if (env.dst_stats.has_capacity)
 		task_numa_find_cpu(&env, imp);
-	} else {
+
+	/* No space available on the preferred nid. Look elsewhere. */
+	if (env.best_cpu == -1) {
 		for_each_online_node(nid) {
 			if (nid == env.src_nid || nid == p->numa_preferred_nid)
 				continue;
