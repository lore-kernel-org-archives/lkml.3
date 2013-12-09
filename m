Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846Ab3LIHKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:10:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760624Ab3LIHJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:09:25 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 12/18] mm: numa: Defer TLB flush for THP migration as long as possible
Date: Mon,  9 Dec 2013 07:09:06 +0000
Message-Id: <1386572952-1191-13-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386572952-1191-1-git-send-email-mgorman@suse.de>
References: <1386572952-1191-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

THP migration can fail for a variety of reasons. Avoid flushing the TLB
to deal with THP migration races until the copy is ready to start.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 7 -------
 mm/migrate.c     | 6 ++++++
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e3a5ee2..e3b6a75 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1377,13 +1377,6 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	/*
-	 * The page_table_lock above provides a memory barrier
-	 * with change_protection_range.
-	 */
-	if (tlb_flush_pending(mm))
-		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
-
-	/*
 	 * Migrate the THP to the requested node, returns with page unlocked
 	 * and pmd_numa cleared.
 	 */
diff --git a/mm/migrate.c b/mm/migrate.c
index cfb4190..5372521 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1759,6 +1759,12 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 		goto out_fail;
 	}
 
+	/* PTL provides a memory barrier with change_protection_range */
+	ptl = pmd_lock(mm, pmd);
+	if (tlb_flush_pending(mm))
+		flush_tlb_range(vma, mmun_start, mmun_end);
+	spin_unlock(ptl);
+
 	/* Prepare a page as a migration target */
 	__set_page_locked(new_page);
 	SetPageSwapBacked(new_page);
-- 
1.8.4

