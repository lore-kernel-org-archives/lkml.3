Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3JGKj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:39:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab3JGKaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:30:08 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 28/63] sched: Remove check that skips small VMAs
Date: Mon,  7 Oct 2013 11:29:06 +0100
Message-Id: <1381141781-10992-29-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381141781-10992-1-git-send-email-mgorman@suse.de>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
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
index 9eb384b..fb4fc66 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1127,10 +1127,6 @@ void task_numa_work(struct callback_head *work)
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
1.8.4

