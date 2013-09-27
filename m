Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3I0N2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:28:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3I0N2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:24 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 34/63] sched: numa: increment numa_migrate_seq when task runs in correct location
Date: Fri, 27 Sep 2013 14:27:19 +0100
Message-Id: <1380288468-5551-35-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

When a task is already running on its preferred node, increment
numa_migrate_seq to indicate that the task is settled if migration is
temporarily disabled, and memory should migrate towards it.

[mgorman@suse.de: Only increment migrate_seq if migration temporarily disabled]
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 00ccc68..1a17e5e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1016,8 +1016,16 @@ static void numa_migrate_preferred(struct task_struct *p)
 {
 	/* Success if task is already running on preferred CPU */
 	p->numa_migrate_retry = 0;
-	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
+	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid) {
+		/*
+		 * If migration is temporarily disabled due to a task migration
+		 * then re-enable it now as the task is running on its
+		 * preferred node and memory should migrate locally
+		 */
+		if (!p->numa_migrate_seq)
+			p->numa_migrate_seq++;
 		return;
+	}
 
 	/* This task has no NUMA fault statistics yet */
 	if (unlikely(p->numa_preferred_nid == -1))
-- 
1.8.1.4

