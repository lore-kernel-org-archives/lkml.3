Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3LCIwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:52:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab3LCIwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:12 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 11/15] sched: numa: Skip inaccessible VMAs
Date: Tue,  3 Dec 2013 08:51:58 +0000
Message-Id: <1386060721-3794-12-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386060721-3794-1-git-send-email-mgorman@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inaccessible VMA should not be trapping NUMA hint faults. Skip them.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c70201..40d8ea3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -970,6 +970,13 @@ void task_numa_work(struct callback_head *work)
 		if (!vma_migratable(vma))
 			continue;
 
+		/*
+		 * Skip inaccessible VMAs to avoid any confusion between
+		 * PROT_NONE and NUMA hinting ptes
+		 */
+		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
+			continue;
+
 		/* Skip small VMAs. They are not likely to be of relevance */
 		if (vma->vm_end - vma->vm_start < HPAGE_SIZE)
 			continue;
-- 
1.8.4

