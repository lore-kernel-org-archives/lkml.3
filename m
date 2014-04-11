Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbaDKRYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:24:12 -0400
Received: from shelob.surriel.com ([74.92.59.67]:48401 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaDKRYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:24:10 -0400
X-Greylist: delayed 1400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 13:24:10 EDT
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, chegu_vinod@hp.com,
        mgorman@suse.de
Subject: [PATCH 2/3] sched,numa: retry placement more frequently when misplaced
Date: Fri, 11 Apr 2014 13:00:28 -0400
Message-Id: <1397235629-16328-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1397235629-16328-1-git-send-email-riel@redhat.com>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

When tasks have not converged on their preferred nodes yet, we want
to retry fairly often, to make sure we do not migrate a task's memory
to an undesirable location, only to have to move it again later.

This patch reduces the interval at which migration is retried,
when the task's numa_scan_period is small.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Vinod Chegu <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 12de50a..babd316 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1326,12 +1326,15 @@ static int task_numa_migrate(struct task_struct *p)
 /* Attempt to migrate a task to a CPU on the preferred node. */
 static void numa_migrate_preferred(struct task_struct *p)
 {
+	unsigned long interval = HZ;
+
 	/* This task has no NUMA fault statistics yet */
 	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults_memory))
 		return;
 
 	/* Periodically retry migrating the task to the preferred node */
-	p->numa_migrate_retry = jiffies + HZ;
+	interval = min(interval, msecs_to_jiffies(p->numa_scan_period) / 16);
+	p->numa_migrate_retry = jiffies + interval;
 
 	/* Success if task is already running on preferred CPU */
 	if (task_node(p) == p->numa_preferred_nid)
-- 
1.8.5.3

