Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3CEG6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:58:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:35644 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3CEG6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:58:39 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-3d-5135979d7aa5
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC/PATCH 3/5] mm: get_user_pages: use NON-MOVABLE pages when
 FOLL_DURABLE flag is set
Date: Tue, 05 Mar 2013 07:57:57 +0100
Message-id: <1362466679-17111-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQd25000DDS7eMLaYs34Nm8XfScfY
	LTbOWM9qcbbpDbvFlysPmSwu75rDZnFvzX9Wi7VH7rJb/D7YyW6x4HgLq8Wyr+/ZHbg9fv+a
	xOjRu/crq8emVZ1sHps+TWL3ODHjN4vH7X+PmT3W/XnF5NG3ZRWjx+dNcgGcUVw2Kak5mWWp
	Rfp2CVwZsx6vYiv4rlvx6O4ZtgbGNtUuRk4OCQETiaXXzjJB2GISF+6tZ+ti5OIQEpjOKPF6
	yV52CKedSWLjsSdgVWwChhJdb7vYQGwRgTCJP43bWEGKmAWOM0n8ubgWKMHBISyQJNG+QhCk
	hkVAVaL9+z6wXl4BD4kXr+eAlUgIKEjMmWQDEuYU8JR4svwjC4gtBFQyb9tnpgmMvAsYGVYx
	iqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfpM6kdjCsbLA4xCnAwKvHwMhw1CRRiTSwrrsw9
	xCjBwawkwitWZxooxJuSWFmVWpQfX1Sak1p8iFGag0VJnJfx1JMAIYH0xJLU7NTUgtQimCwT
	B6dUA6Nuq/pW04f3Ay3ttxrHG1Wpc+Qa8n9ZMX9ru+Dy1Buq+i+UvOc3bT/zhOnenyMt8S6O
	3z+YGfjYffG2vvRLlmmb5vGmyauvvZyQsuroV4Hda5LWy5rv/eGReuX8vetZkefvfsvQuKoy
	t7jj2TFlE08OA42ZCxfFzJJzXhpV8CEzZvoiEYedR3yUWIozEg21mIuKEwFd9qQ8TgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that newly allocated pages, which are faulted in in FOLL_DURABLE
mode comes from non-movalbe pageblocks, to workaround migration failures
with Contiguous Memory Allocator.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/highmem.h |   12 ++++++++++--
 include/linux/mm.h      |    2 ++
 mm/memory.c             |   24 ++++++++++++++++++------
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 7fb31da..cf0b9d8 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -168,7 +168,8 @@ __alloc_zeroed_user_highpage(gfp_t movableflags,
 #endif
 
 /**
- * alloc_zeroed_user_highpage_movable - Allocate a zeroed HIGHMEM page for a VMA that the caller knows can move
+ * alloc_zeroed_user_highpage_movable - Allocate a zeroed HIGHMEM page for
+ *					a VMA that the caller knows can move
  * @vma: The VMA the page is to be allocated for
  * @vaddr: The virtual address the page will be inserted into
  *
@@ -177,11 +178,18 @@ __alloc_zeroed_user_highpage(gfp_t movableflags,
  */
 static inline struct page *
 alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
-					unsigned long vaddr)
+				   unsigned long vaddr)
 {
 	return __alloc_zeroed_user_highpage(__GFP_MOVABLE, vma, vaddr);
 }
 
+static inline struct page *
+alloc_zeroed_user_highpage(gfp_t gfp, struct vm_area_struct *vma,
+			   unsigned long vaddr)
+{
+	return __alloc_zeroed_user_highpage(gfp, vma, vaddr);
+}
+
 static inline void clear_highpage(struct page *page)
 {
 	void *kaddr = kmap_atomic(page);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9806e54..c11f58f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -165,6 +165,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
 #define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
 #define FAULT_FLAG_TRIED	0x40	/* second try */
+#define FAULT_FLAG_NO_CMA	0x80	/* don't use CMA pages */
 
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
@@ -1633,6 +1634,7 @@ static inline struct page *follow_page(struct vm_area_struct *vma,
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
+#define FOLL_DURABLE	0x800	/* get the page reference for a long time */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff --git a/mm/memory.c b/mm/memory.c
index 42dfd8e..2b9c2dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1816,6 +1816,9 @@ long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				int ret;
 				unsigned int fault_flags = 0;
 
+				if (gup_flags & FOLL_DURABLE)
+					fault_flags = FAULT_FLAG_NO_CMA;
+
 				/* For mlock, just skip the stack guard page. */
 				if (foll_flags & FOLL_MLOCK) {
 					if (stack_guard_page(vma, start))
@@ -2495,7 +2498,7 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
  */
 static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
-		spinlock_t *ptl, pte_t orig_pte)
+		spinlock_t *ptl, pte_t orig_pte, unsigned int flags)
 	__releases(ptl)
 {
 	struct page *old_page, *new_page = NULL;
@@ -2505,6 +2508,10 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *dirty_page = NULL;
 	unsigned long mmun_start = 0;	/* For mmu_notifiers */
 	unsigned long mmun_end = 0;	/* For mmu_notifiers */
+	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
+
+	if (IS_ENABLED(CONFIG_CMA) && (flags & FAULT_FLAG_NO_CMA))
+		gfp &= ~__GFP_MOVABLE;
 
 	old_page = vm_normal_page(vma, address, orig_pte);
 	if (!old_page) {
@@ -2668,11 +2675,11 @@ gotten:
 		goto oom;
 
 	if (is_zero_pfn(pte_pfn(orig_pte))) {
-		new_page = alloc_zeroed_user_highpage_movable(vma, address);
+		new_page = alloc_zeroed_user_highpage(gfp, vma, address);
 		if (!new_page)
 			goto oom;
 	} else {
-		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+		new_page = alloc_page_vma(gfp, vma, address);
 		if (!new_page)
 			goto oom;
 		cow_user_page(new_page, old_page, address, vma);
@@ -3032,7 +3039,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	if (flags & FAULT_FLAG_WRITE) {
-		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte);
+		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte, flags);
 		if (ret & VM_FAULT_ERROR)
 			ret &= VM_FAULT_ERROR;
 		goto out;
@@ -3187,6 +3194,11 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct vm_fault vmf;
 	int ret;
 	int page_mkwrite = 0;
+	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
+
+	if (IS_ENABLED(CONFIG_CMA) && (flags & FAULT_FLAG_NO_CMA))
+		gfp &= ~__GFP_MOVABLE;
+
 
 	/*
 	 * If we do COW later, allocate page befor taking lock_page()
@@ -3197,7 +3209,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (unlikely(anon_vma_prepare(vma)))
 			return VM_FAULT_OOM;
 
-		cow_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+		cow_page = alloc_page_vma(gfp, vma, address);
 		if (!cow_page)
 			return VM_FAULT_OOM;
 
@@ -3614,7 +3626,7 @@ int handle_pte_fault(struct mm_struct *mm,
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!pte_write(entry))
 			return do_wp_page(mm, vma, address,
-					pte, pmd, ptl, entry);
+					pte, pmd, ptl, entry, flags);
 		entry = pte_mkdirty(entry);
 	}
 	entry = pte_mkyoung(entry);
-- 
1.7.9.5

