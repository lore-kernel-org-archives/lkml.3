Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3I0Nby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:31:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab3I0N2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:46 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 57/63] sched: numa: Take false sharing into account when adapting scan rate
Date: Fri, 27 Sep 2013 14:27:42 +0100
Message-Id: <1380288468-5551-58-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scan rate is altered based on whether shared/private faults dominated.
task_numa_group() may detect false sharing but that information is not
taken into account when adapting the scan rate. Take it into account.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1b0ff1d..3486042 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1381,7 +1381,8 @@ static void double_lock(spinlock_t *l1, spinlock_t *l2)
 	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
 }
 
-static void task_numa_group(struct task_struct *p, int cpupid, int flags)
+static void task_numa_group(struct task_struct *p, int cpupid, int flags,
+			int *priv)
 {
 	struct numa_group *grp, *my_grp;
 	struct task_struct *tsk;
@@ -1447,6 +1448,9 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags)
 	if (flags & TNF_SHARED)
 		join = true;
 
+	/* Update priv based on whether false sharing was detected */
+	*priv = !join;
+
 	if (join && !get_numa_group(grp))
 		join = false;
 
@@ -1545,7 +1549,7 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 	} else {
 		priv = cpupid_match_pid(p, last_cpupid);
 		if (!priv && !(flags & TNF_NO_GROUP))
-			task_numa_group(p, last_cpupid, flags);
+			task_numa_group(p, last_cpupid, flags, &priv);
 	}
 
 	/*
-- 
1.8.1.4

