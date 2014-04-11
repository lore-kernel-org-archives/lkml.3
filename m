Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaDKUQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:16:04 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41299 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbaDKUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:15:58 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 3/4] mvolatile: Add purged page detection on setting memory non-volatile
Date: Fri, 11 Apr 2014 13:15:39 -0700
Message-Id: <1397247340-3365-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397247340-3365-1-git-send-email-john.stultz@linaro.org>
References: <1397247340-3365-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of volatile ranges will need to know if memory was discarded.
This patch adds the purged state tracking required to inform userland
when it marks memory as non-volatile that some memory in that range
was purged and needs to be regenerated.

This simplified implementation which uses some of the logic from
Minchan's earlier efforts, so credit to Minchan for his work.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Robert Love <rlove@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Hommey <mh@glandium.org>
Cc: Taras Glek <tglek@mozilla.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Keith Packard <keithp@keithp.com>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/swap.h    |  5 +++
 include/linux/swapops.h | 10 ++++++
 mm/mvolatile.c          | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a90ea95..c372ca7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -55,6 +55,7 @@ enum {
 	 * 1<<MAX_SWPFILES_SHIFT), so to preserve the values insert
 	 * new entries here at the top of the enum, not at the bottom
 	 */
+	SWP_MVOLATILE_PURGED_NR,
 #ifdef CONFIG_MEMORY_FAILURE
 	SWP_HWPOISON_NR,
 #endif
@@ -81,6 +82,10 @@ enum {
 #define SWP_HWPOISON		(MAX_SWAPFILES + SWP_HWPOISON_NR)
 #endif
 
+/*
+ * Purged volatile range pages
+ */
+#define SWP_MVOLATILE_PURGED	(MAX_SWAPFILES + SWP_MVOLATILE_PURGED_NR)
 
 /*
  * Magic header for a swap area. The first part of the union is
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index c0f7526..fe9c026 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -161,6 +161,16 @@ static inline int is_write_migration_entry(swp_entry_t entry)
 
 #endif
 
+static inline swp_entry_t make_purged_entry(void)
+{
+	return swp_entry(SWP_MVOLATILE_PURGED, 0);
+}
+
+static inline int is_purged_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_MVOLATILE_PURGED;
+}
+
 #ifdef CONFIG_MEMORY_FAILURE
 /*
  * Support for hardware poisoned pages
diff --git a/mm/mvolatile.c b/mm/mvolatile.c
index d4d2eed..38c8315 100644
--- a/mm/mvolatile.c
+++ b/mm/mvolatile.c
@@ -12,8 +12,91 @@
 #include <linux/hugetlb.h>
 #include <linux/mmu_notifier.h>
 #include <linux/mm_inline.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 #include "internal.h"
 
+struct mvolatile_walker {
+	struct vm_area_struct *vma;
+	int page_was_purged;
+};
+
+
+/**
+ * mvolatile_check_purged_pte - Checks ptes for purged pages
+ * @pmd: pmd to walk
+ * @addr: starting address
+ * @end: end address
+ * @walk: mm_walk ptr (contains ptr to mvolatile_walker)
+ *
+ * Iterates over the ptes in the pmd checking if they have
+ * purged swap entries.
+ *
+ * Sets the mvolatile_walker.page_was_purged to 1 if any were purged.
+ */
+static int mvolatile_check_purged_pte(pmd_t *pmd, unsigned long addr,
+					unsigned long end, struct mm_walk *walk)
+{
+	struct mvolatile_walker *vw = walk->private;
+	pte_t *pte;
+	spinlock_t *ptl;
+	int ret = 0;
+
+	if (pmd_trans_huge(*pmd))
+		return 0;
+	if (pmd_trans_unstable(pmd))
+		return 0;
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		if (!pte_present(*pte)) {
+			swp_entry_t mvolatile_entry = pte_to_swp_entry(*pte);
+
+			if (unlikely(is_purged_entry(mvolatile_entry))) {
+
+				vw->page_was_purged = 1;
+
+				/* clear the pte swp entry */
+				flush_cache_page(vw->vma, addr, pte_pfn(*pte));
+				ptep_clear_flush(vw->vma, addr, pte);
+			}
+		}
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+
+	return ret;
+}
+
+
+/**
+ * mvolatile_check_purged - Sets up a mm_walk to check for purged pages
+ * @vma: ptr to vma we're starting with
+ * @start: start address to walk
+ * @end: end address of walk
+ *
+ * Sets up and calls wa_page_range() to check for purge pages.
+ *
+ * Returns 1 if pages in the range were purged, 0 otherwise.
+ */
+static int mvolatile_check_purged(struct vm_area_struct *vma,
+					 unsigned long start,
+					 unsigned long end)
+{
+	struct mvolatile_walker vw;
+	struct mm_walk mvolatile_walk = {
+		.pmd_entry = mvolatile_check_purged_pte,
+		.mm = vma->vm_mm,
+		.private = &vw,
+	};
+	vw.page_was_purged = 0;
+	vw.vma = vma;
+
+	walk_page_range(start, end, &mvolatile_walk);
+
+	return vw.page_was_purged;
+
+}
 
 /**
  * do_mvolatile - Marks or clears VMAs in the range (start-end) as VM_VOLATILE
@@ -119,6 +202,9 @@ success:
 		vma = prev->vm_next;
 	}
 out:
+	if (count && (mode == MVOLATILE_NONVOLATILE))
+		*purged = mvolatile_check_purged(vma, orig_start,
+							orig_start+count);
 	up_write(&mm->mmap_sem);
 
 	/* report bytes successfully marked, even if we're exiting on error */
-- 
1.8.3.2

