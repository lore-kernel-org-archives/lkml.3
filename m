Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3CEG6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:58:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56490 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3CEG6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:58:34 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-c6-513597997cb8
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
Subject: [RFC/PATCH 2/5] mm: get_user_pages: use static inline
Date: Tue, 05 Mar 2013 07:57:56 +0100
Message-id: <1362466679-17111-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jQd2Z000DDe6vVrWYs34Nm8XfScfY
	LTbOWM9qcbbpDbvFlysPmSwu75rDZnFvzX9Wi7VH7rJb/D7YyW6x4HgLq8Wyr+/ZHbg9fv+a
	xOjRu/crq8emVZ1sHps+TWL3ODHjN4vH7X+PmT3W/XnF5NG3ZRWjx+dNcgGcUVw2Kak5mWWp
	Rfp2CVwZu2YvYi/oc6z4uGY1cwPjc+MuRk4OCQETidZvd1kgbDGJC/fWs3UxcnEICUxnlFi1
	4TorhNPOJDH/TwsjSBWbgKFE19suNhBbRCBM4k/jNrAiZoHjTBJ/Lq4FSwgL2Ems7lnLBGKz
	CKhK7Pn8hxXE5hXwkHi/fCtzFyMH0DoFiTmTbEDCnAKeEk+WfwS7QgioZN62z0wTGHkXMDKs
	YhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgO02fSOxhXNVgcYhTgYFTi4WU4ahIoxJpYVlyZ
	e4hRgoNZSYRXrM40UIg3JbGyKrUoP76oNCe1+BCjNAeLkjgv46knAUIC6YklqdmpqQWpRTBZ
	Jg5OqQZG50M2ym06/2dUx0teu7fdcM5uifyVxrP92+4yKpZ7TYno0dKa8KPMyLHqfPP1etOn
	RoaxX+4+MN6p3H1ae1ro7x3TdjLxqEb8Zf7k80XuQ9TRFZ0r/rxecSFo7SbPNp41zav/HK53
	FLMT2qIg+vj+YUv9h4vuZa48dvWAip9kpmt3RquBS7GlEktxRqKhFnNRcSIA2DCQAE8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_user_pages() is already exported function, so get_user_pages()
can be easily inlined to the caller functions.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/mm.h |   74 +++++++++++++++++++++++++++++++++++++++++++++++++---
 mm/memory.c        |   69 ------------------------------------------------
 2 files changed, 70 insertions(+), 73 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7acc9dc..9806e54 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1019,10 +1019,7 @@ long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		      unsigned long start, unsigned long nr_pages,
 		      unsigned int foll_flags, struct page **pages,
 		      struct vm_area_struct **vmas, int *nonblocking);
-long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		    unsigned long start, unsigned long nr_pages,
-		    int write, int force, struct page **pages,
-		    struct vm_area_struct **vmas);
+
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct kvec;
@@ -1642,6 +1639,75 @@ typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
 
+/*
+ * get_user_pages() - pin user pages in memory
+ * @tsk:	the task_struct to use for page fault accounting, or
+ *		NULL if faults are not to be recorded.
+ * @mm:		mm_struct of target mm
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @write:	whether pages will be written to by the caller
+ * @force:	whether to force write access even if user mapping is
+ *		readonly. This will result in the page being COWed even
+ *		in MAP_SHARED mappings. You do not want this.
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long. Or NULL, if caller
+ *		only intends to ensure the pages are faulted in.
+ * @vmas:	array of pointers to vmas corresponding to each page.
+ *		Or NULL if the caller does not require them.
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno. Each page returned must be released
+ * with a put_page() call when it is finished with. vmas will only
+ * remain valid while mmap_sem is held.
+ *
+ * Must be called with mmap_sem held for read or write.
+ *
+ * get_user_pages walks a process's page tables and takes a reference to
+ * each struct page that each user address corresponds to at a given
+ * instant. That is, it takes the page that would be accessed if a user
+ * thread accesses the given user virtual address at that instant.
+ *
+ * This does not guarantee that the page exists in the user mappings when
+ * get_user_pages returns, and there may even be a completely different
+ * page there in some cases (eg. if mmapped pagecache has been invalidated
+ * and subsequently re faulted). However it does guarantee that the page
+ * won't be freed completely. And mostly callers simply care that the page
+ * contains data that was valid *at some point in time*. Typically, an IO
+ * or similar operation cannot guarantee anything stronger anyway because
+ * locks can't be held over the syscall boundary.
+ *
+ * If write=0, the page must not be written to. If the page is written to,
+ * set_page_dirty (or set_page_dirty_lock, as appropriate) must be called
+ * after the page is finished with, and before put_page is called.
+ *
+ * get_user_pages is typically used for fewer-copy IO operations, to get a
+ * handle on the memory by some means other than accesses via the user virtual
+ * addresses. The pages may be submitted for DMA to devices or accessed via
+ * their kernel linear mapping (via the kmap APIs). Care should be taken to
+ * use the correct cache flushing APIs.
+ *
+ * See also get_user_pages_fast, for performance critical applications.
+ */
+static inline long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+			unsigned long start, unsigned long nr_pages, int write,
+			int force, struct page **pages,
+			struct vm_area_struct **vmas)
+{
+	int flags = FOLL_TOUCH;
+
+	if (pages)
+		flags |= FOLL_GET;
+	if (write)
+		flags |= FOLL_WRITE;
+	if (force)
+		flags |= FOLL_FORCE;
+
+	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas,
+				NULL);
+}
+
 #ifdef CONFIG_PROC_FS
 void vm_stat_account(struct mm_struct *, unsigned long, struct file *, long);
 #else
diff --git a/mm/memory.c b/mm/memory.c
index 494526a..42dfd8e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1961,75 +1961,6 @@ int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 	return 0;
 }
 
-/*
- * get_user_pages() - pin user pages in memory
- * @tsk:	the task_struct to use for page fault accounting, or
- *		NULL if faults are not to be recorded.
- * @mm:		mm_struct of target mm
- * @start:	starting user address
- * @nr_pages:	number of pages from start to pin
- * @write:	whether pages will be written to by the caller
- * @force:	whether to force write access even if user mapping is
- *		readonly. This will result in the page being COWed even
- *		in MAP_SHARED mappings. You do not want this.
- * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_pages long. Or NULL, if caller
- *		only intends to ensure the pages are faulted in.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
- *
- * Returns number of pages pinned. This may be fewer than the number
- * requested. If nr_pages is 0 or negative, returns 0. If no pages
- * were pinned, returns -errno. Each page returned must be released
- * with a put_page() call when it is finished with. vmas will only
- * remain valid while mmap_sem is held.
- *
- * Must be called with mmap_sem held for read or write.
- *
- * get_user_pages walks a process's page tables and takes a reference to
- * each struct page that each user address corresponds to at a given
- * instant. That is, it takes the page that would be accessed if a user
- * thread accesses the given user virtual address at that instant.
- *
- * This does not guarantee that the page exists in the user mappings when
- * get_user_pages returns, and there may even be a completely different
- * page there in some cases (eg. if mmapped pagecache has been invalidated
- * and subsequently re faulted). However it does guarantee that the page
- * won't be freed completely. And mostly callers simply care that the page
- * contains data that was valid *at some point in time*. Typically, an IO
- * or similar operation cannot guarantee anything stronger anyway because
- * locks can't be held over the syscall boundary.
- *
- * If write=0, the page must not be written to. If the page is written to,
- * set_page_dirty (or set_page_dirty_lock, as appropriate) must be called
- * after the page is finished with, and before put_page is called.
- *
- * get_user_pages is typically used for fewer-copy IO operations, to get a
- * handle on the memory by some means other than accesses via the user virtual
- * addresses. The pages may be submitted for DMA to devices or accessed via
- * their kernel linear mapping (via the kmap APIs). Care should be taken to
- * use the correct cache flushing APIs.
- *
- * See also get_user_pages_fast, for performance critical applications.
- */
-long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, unsigned long nr_pages, int write,
-		int force, struct page **pages, struct vm_area_struct **vmas)
-{
-	int flags = FOLL_TOUCH;
-
-	if (pages)
-		flags |= FOLL_GET;
-	if (write)
-		flags |= FOLL_WRITE;
-	if (force)
-		flags |= FOLL_FORCE;
-
-	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas,
-				NULL);
-}
-EXPORT_SYMBOL(get_user_pages);
-
 /**
  * get_dump_page() - pin user page in memory while writing it to core dump
  * @addr: user address
-- 
1.7.9.5

