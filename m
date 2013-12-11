Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3LKTN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:13:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3LKTMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:54 -0500
Date: Wed, 11 Dec 2013 19:12:50 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: fix TLB flush race between migration, and
 change_protection_range -fix
Message-ID: <20131211191250.GD11295@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
 <1386690695-27380-12-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1386690695-27380-12-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following build error was reported by the 0-day build checker.

>> arch/arm/mm/context.c:51:18: error: 'tlb_flush_pending' redeclared as different kind of symbol
   include/linux/mm_types.h:477:91: note: previous definition of 'tlb_flush_pending' was here

This patch renames tlb_flush_pending to
mm_tlb_flush_pending. This is a fix for the -mm patch
mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch

Note that when slotted into place that it will cause a conflict with
mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch . The
resolution is to delete the call from huge_memory.c and make sure the
tlb_flush_pending call in mm/migrate.c is renamed appropriately.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/include/asm/pgtable.h | 2 +-
 include/linux/mm_types.h       | 4 ++--
 mm/huge_memory.c               | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 48cab4c..bbc8b12 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -458,7 +458,7 @@ static inline bool pte_accessible(struct mm_struct *mm, pte_t a)
 		return true;
 
 	if ((pte_flags(a) & (_PAGE_PROTNONE | _PAGE_NUMA)) &&
-			tlb_flush_pending(mm))
+			mm_tlb_flush_pending(mm))
 		return true;
 
 	return false;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index c122bb1..e5c49c3 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -474,7 +474,7 @@ static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
  * The barriers below prevent the compiler from re-ordering the instructions
  * around the memory barriers that are already present in the code.
  */
-static inline bool tlb_flush_pending(struct mm_struct *mm)
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 {
 	barrier();
 	return mm->tlb_flush_pending;
@@ -491,7 +491,7 @@ static inline void clear_tlb_flush_pending(struct mm_struct *mm)
 	mm->tlb_flush_pending = false;
 }
 #else
-static inline bool tlb_flush_pending(struct mm_struct *mm)
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 {
 	return false;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e3a5ee2..317a8ff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1380,7 +1380,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * The page_table_lock above provides a memory barrier
 	 * with change_protection_range.
 	 */
-	if (tlb_flush_pending(mm))
+	if (mm_tlb_flush_pending(mm))
 		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
 
 	/*
