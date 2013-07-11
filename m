Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3GKJrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:47:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab3GKJrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:47:15 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 14/16] sched: Remove check that skips small VMAs
Date: Thu, 11 Jul 2013 10:46:58 +0100
Message-Id: <1373536020-2799-15-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373536020-2799-1-git-send-email-mgorman@suse.de>
References: <1373536020-2799-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_numa_work skips small VMAs. At the time the logic was to reduce the
scanning overhead which was considerable. It is a dubious hack at best.
It would make much more sense to cache where faults have been observed
and only rescan those regions during subsequent PTE scans. Remove this
hack as motivation to do it properly in the future.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3ffe097..45dcf51 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1080,10 +1080,6 @@ void task_numa_work(struct callback_head *work)
 		if (!vma_migratable(vma))
 			continue;
 
-		/* Skip small VMAs. They are not likely to be of relevance */
-		if (vma->vm_end - vma->vm_start < HPAGE_SIZE)
-			continue;
-
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
-- 
1.8.1.4

