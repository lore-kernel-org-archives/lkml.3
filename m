Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3I0NmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:42:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab3I0N2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:08 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 16/63] sched: numa: Initialise numa_next_scan properly
Date: Fri, 27 Sep 2013 14:27:01 +0100
Message-Id: <1380288468-5551-17-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scan delay logic and resets are currently initialised to start scanning
immediately instead of delaying properly. Initialise them properly at
fork time and catch when a new mm has been allocated.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/core.c | 4 ++--
 kernel/sched/fair.c | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f307c2c..9d7a33a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1634,8 +1634,8 @@ static void __sched_fork(struct task_struct *p)
 
 #ifdef CONFIG_NUMA_BALANCING
 	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
-		p->mm->numa_next_scan = jiffies;
-		p->mm->numa_next_reset = jiffies;
+		p->mm->numa_next_scan = jiffies + msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
+		p->mm->numa_next_reset = jiffies + msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
 		p->mm->numa_scan_seq = 0;
 	}
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8510633..6edac70 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -900,6 +900,13 @@ void task_numa_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
+	if (!mm->numa_next_reset || !mm->numa_next_scan) {
+		mm->numa_next_scan = now +
+			msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
+		mm->numa_next_reset = now +
+			msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
+	}
+
 	/*
 	 * Reset the scan period if enough time has gone by. Objective is that
 	 * scanning will be reduced if pages are properly placed. As tasks
-- 
1.8.1.4

