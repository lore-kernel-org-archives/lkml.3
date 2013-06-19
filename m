Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3FSEgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:36:48 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42370 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3FSEgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:36:47 -0400
X-AuditID: 9c93016f-b7b6cae000007078-97-51c1355dd614
Date: Wed, 19 Jun 2013 13:36:50 +0900
From: Minchan Kim <minchan@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dgiani@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 8/8] vrange: Send SIGBUS when user try to access purged
 page
Message-ID: <20130619043650.GB10961@bbox>
References: <1371010971-15647-1-git-send-email-john.stultz@linaro.org>
 <1371010971-15647-9-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371010971-15647-9-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 09:22:51PM -0700, John Stultz wrote:
> From: Minchan Kim <minchan@kernel.org>
> 
> By vrange(2) semantic, user should see SIGBUG if he try to access
> purged page without vrange(...VRANGE_NOVOLATILE).
> 
> This patch implements it.
> 
> XXX: I reused PSE bit for quick prototype without enough considering
> so need time to see what's empty bit and I am surely missing
> many places to handle vrange pte bit. I should investigate all of
> pte handling places, especially pte_none case.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Robert Love <rlove@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Andrea Righi <andrea@betterlinux.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: Mike Hommey <mh@glandium.org>
> Cc: Taras Glek <tglek@mozilla.com>
> Cc: Dhaval Giani <dgiani@mozilla.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: linux-mm@kvack.org <linux-mm@kvack.org>
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> [jstultz: Extended to work with file pages]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  arch/x86/include/asm/pgtable_types.h |  2 ++
>  include/asm-generic/pgtable.h        | 11 +++++++++++
>  include/linux/vrange.h               |  2 ++
>  mm/memory.c                          | 23 +++++++++++++++++++++--
>  mm/vrange.c                          | 35 ++++++++++++++++++++++++++++++++++-
>  5 files changed, 70 insertions(+), 3 deletions(-)
> 

This patch fixes the problem Dhaval reported.

>From e789359cf2ac706e1ebc925f14eb2d7187cd2267 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Tue, 11 Jun 2013 21:22:51 -0700
Subject: [PATCH 2/2] vrange: Send SIGBUS when user try to access purged page

By vrange(2) semantic, user should see SIGBUG if he try to access
purged page without vrange(...VRANGE_NOVOLATILE).

This patch implements it.

XXX: I reused PSE bit for quick prototype without enough considering
so need time to see what's empty bit and I am surely missing
many places to handle vrange pte bit. I should investigate all of
pte handling places, especially pte_none case.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Robert Love <rlove@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mike Hommey <mh@glandium.org>
Cc: Taras Glek <tglek@mozilla.com>
Cc: Dhaval Giani <dgiani@mozilla.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>

Signed-off-by: Minchan Kim <minchan@kernel.org>
[jstultz: Extended to work with file pages]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/x86/include/asm/pgtable_types.h |    2 ++
 include/asm-generic/pgtable.h        |   11 +++++++++++
 include/linux/vrange.h               |    2 ++
 mm/memory.c                          |   23 +++++++++++++++++++++--
 mm/vrange.c                          |   31 +++++++++++++++++++++++++++++++
 5 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index e642300..d7ea6a0 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -64,6 +64,8 @@
 #define _PAGE_FILE	(_AT(pteval_t, 1) << _PAGE_BIT_FILE)
 #define _PAGE_PROTNONE	(_AT(pteval_t, 1) << _PAGE_BIT_PROTNONE)
 
+#define _PAGE_VRANGE	_PAGE_BIT_PSE
+
 /*
  * _PAGE_NUMA indicates that this page will trigger a numa hinting
  * minor page fault to gather numa placement statistics (see
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index a59ff51..91e8f6f 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -479,6 +479,17 @@ static inline unsigned long my_zero_pfn(unsigned long addr)
 
 #ifdef CONFIG_MMU
 
+static inline pte_t pte_mkvrange(pte_t pte)
+{
+	pte = pte_set_flags(pte, _PAGE_VRANGE);
+	return pte_clear_flags(pte, _PAGE_PRESENT);
+}
+
+static inline int pte_vrange(pte_t pte)
+{
+	return ((pte_flags(pte) | _PAGE_PRESENT) == _PAGE_VRANGE);
+}
+
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
diff --git a/include/linux/vrange.h b/include/linux/vrange.h
index cbb609a..75754d1 100644
--- a/include/linux/vrange.h
+++ b/include/linux/vrange.h
@@ -41,6 +41,8 @@ int discard_vpage(struct page *page);
 bool vrange_address(struct mm_struct *mm, unsigned long start,
 			unsigned long end);
 
+extern bool is_purged_vrange(struct mm_struct *mm, unsigned long address);
+
 #else
 
 static inline void vrange_init(void) {};
diff --git a/mm/memory.c b/mm/memory.c
index 61a262b..cc5c70b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -59,6 +59,7 @@
 #include <linux/gfp.h>
 #include <linux/migrate.h>
 #include <linux/string.h>
+#include <linux/vrange.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -832,7 +833,7 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 
 	/* pte contains position in swap or file, so copy. */
 	if (unlikely(!pte_present(pte))) {
-		if (!pte_file(pte)) {
+		if (!pte_file(pte) && !pte_vrange(pte)) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (swap_duplicate(entry) < 0)
@@ -1172,7 +1173,7 @@ again:
 		if (pte_file(ptent)) {
 			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
 				print_bad_pte(vma, addr, ptent, NULL);
-		} else {
+		} else if (!pte_vrange(ptent)) {
 			swp_entry_t entry = pte_to_swp_entry(ptent);
 
 			if (!non_swap_entry(entry))
@@ -3707,9 +3708,27 @@ int handle_pte_fault(struct mm_struct *mm,
 					return do_linear_fault(mm, vma, address,
 						pte, pmd, flags, entry);
 			}
+anon:
 			return do_anonymous_page(mm, vma, address,
 						 pte, pmd, flags);
 		}
+
+		if (unlikely(pte_vrange(entry))) {
+			if (!is_purged_vrange(mm, address)) {
+				/* zap pte */
+				ptl = pte_lockptr(mm, pmd);
+				spin_lock(ptl);
+				if (unlikely(!pte_same(*pte, entry)))
+					goto unlock;
+				flush_cache_page(vma, address, pte_pfn(*pte));
+				ptep_clear_flush(vma, address, pte);
+				pte_unmap_unlock(pte, ptl);
+				goto anon;
+			}
+
+			return VM_FAULT_SIGBUS;
+		}
+
 		if (pte_file(entry))
 			return do_nonlinear_fault(mm, vma, address,
 					pte, pmd, flags, entry);
diff --git a/mm/vrange.c b/mm/vrange.c
index d57cb38..9cafb01 100644
--- a/mm/vrange.c
+++ b/mm/vrange.c
@@ -521,6 +521,7 @@ int try_to_discard_one(struct vrange_root *vroot, struct page *page,
 			BUG_ON(1);
 	}
 
+	set_pte_at(mm, addr, pte, pte_mkvrange(*pte));
 	pte_unmap_unlock(pte, ptl);
 	mmu_notifier_invalidate_page(mm, addr);
 	ret = 1;
@@ -696,3 +697,33 @@ int discard_vpage(struct page *page)
 	return 0;
 }
 
+bool is_purged_vrange(struct mm_struct *mm, unsigned long address)
+{
+	struct vrange_root *vroot;
+	struct interval_tree_node *node;
+	struct vrange *range;
+	unsigned long vstart_idx;
+	struct vm_area_struct *vma;
+	bool ret = false;
+
+	vma = find_vma(mm, address);
+	if (vma->vm_file && (vma->vm_flags & VM_SHARED)) {
+		vroot = &vma->vm_file->f_mapping->vroot;
+		vstart_idx = vma->vm_pgoff + address - vma->vm_start;
+	} else {
+		vroot = &mm->vroot;
+		vstart_idx = address;
+	}
+
+	vrange_lock(vroot);
+	node = interval_tree_iter_first(&vroot->v_rb, vstart_idx,
+						vstart_idx + PAGE_SIZE - 1);
+	if (node) {
+		range = container_of(node, struct vrange, node);
+		if (range->purged)
+			ret = true;
+	}
+	vrange_unlock(vroot);
+	return ret;
+}
+
-- 
1.7.9.5

-- 
Kind regards,
Minchan Kim
