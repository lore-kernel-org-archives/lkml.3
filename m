Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3I0N2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:28:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab3I0N2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:25 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 35/63] sched: numa: Do not trap hinting faults for shared libraries
Date: Fri, 27 Sep 2013 14:27:20 +0100
Message-Id: <1380288468-5551-36-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA hinting faults will not migrate a shared executable page mapped by
multiple processes on the grounds that the data is probably in the CPU
cache already and the page may just bounce between tasks running on multipl
nodes. Even if the migration is avoided, there is still the overhead of
trapping the fault, updating the statistics, making scheduler placement
decisions based on the information etc. If we are never going to migrate
the page, it is overhead for no gain and worse a process may be placed on
a sub-optimal node for shared executable pages. This patch avoids trapping
faults for shared libraries entirely.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1a17e5e..cd90e44 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1231,6 +1231,16 @@ void task_numa_work(struct callback_head *work)
 		if (!vma_migratable(vma) || !vma_policy_mof(p, vma))
 			continue;
 
+		/*
+		 * Shared library pages mapped by multiple processes are not
+		 * migrated as it is expected they are cache replicated. Avoid
+		 * hinting faults in read-only file-backed mappings or the vdso
+		 * as migrating the pages will be of marginal benefit.
+		 */
+		if (!vma->vm_mm ||
+		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ)))
+			continue;
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
-- 
1.8.1.4

