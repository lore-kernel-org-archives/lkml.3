Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaAOV7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:59:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41332 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaAOV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 094/166] mm: numa: defer TLB flush for THP migration as long as possible
Date: Wed, 15 Jan 2014 13:51:48 -0800
Message-Id: <1389822780-4729-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit b0943d61b8fa420180f92f64ef67662b4f6cc493 upstream.

THP migration can fail for a variety of reasons.  Avoid flushing the TLB
to deal with THP migration races until the copy is ready to start.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 7 -------
 mm/migrate.c     | 3 +++
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b43f35a..21ca328 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1379,13 +1379,6 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	/*
-	 * The page_table_lock above provides a memory barrier
-	 * with change_protection_range.
-	 */
-	if (mm_tlb_flush_pending(mm))
-		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
-
-	/*
 	 * Migrate the THP to the requested node, returns with page unlocked
 	 * and pmd_numa cleared.
 	 */
diff --git a/mm/migrate.c b/mm/migrate.c
index 8e117b7..8edfa00 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1715,6 +1715,9 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 		goto out_fail;
 	}
 
+	if (mm_tlb_flush_pending(mm))
+		flush_tlb_range(vma, mmun_start, mmun_end);
+
 	/* Prepare a page as a migration target */
 	__set_page_locked(new_page);
 	SetPageSwapBacked(new_page);
-- 
1.8.3.2

