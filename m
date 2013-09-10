Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3IJJdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:33:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab3IJJdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:33:01 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 26/50] sched: Check current->mm before allocating NUMA faults
Date: Tue, 10 Sep 2013 10:32:06 +0100
Message-Id: <1378805550-29949-27-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378805550-29949-1-git-send-email-mgorman@suse.de>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_numa_placement checks current->mm but after buffers for faults
have already been uselessly allocated. Move the check earlier.

[peterz@infradead.org: Identified the problem]
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 108f357..e259241 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -930,8 +930,6 @@ static void task_numa_placement(struct task_struct *p)
 	int seq, nid, max_nid = -1;
 	unsigned long max_faults = 0;
 
-	if (!p->mm)	/* for example, ksmd faulting in a user's mm */
-		return;
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 	if (p->numa_scan_seq == seq)
 		return;
@@ -998,6 +996,10 @@ void task_numa_fault(int last_nid, int node, int pages, bool migrated)
 	if (!numabalancing_enabled)
 		return;
 
+	/* for example, ksmd faulting in a user's mm */
+	if (!p->mm)
+		return;
+
 	/* For now, do not attempt to detect private/shared accesses */
 	priv = 1;
 
-- 
1.8.1.4

