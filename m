Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaGILSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:18:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52164 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaGILKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:22 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-9b-53bd2319408d
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 08/21] mm: page_alloc: add kasan hooks on alloc and
 free pathes
Date: Wed, 09 Jul 2014 15:01:05 +0400
Message-id: <1404903678-8257-9-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7qSynuDDebdk7fY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+PM6z72gja1is9tk9kbGBfIdzFyckgImEi8
	/L+PHcIWk7hwbz1bFyMXh5DAUkaJXQ9+MUI4fUwSC+e/ZQWpYhPQk/g3azsbiC0ioCCxufcZ
	WJxZQEdi47VWJhBbWCBa4v2RfYwgNouAqsSDVRdYQGxeAVeJV7MfsEFsU5BYtnwmWC+ngJtE
	T88CsF4hoJrVn7cxTmDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJAy+7GBcfMzq
	EKMAB6MSD69G7e5gIdbEsuLK3EOMEhzMSiK8tqJ7g4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	VprvSDJaXjZt1/VMTs9LfeXaBYyKL67JaZ5YuFlz9gP7R0vf+n+5Ev7a2PWhwqbnZ/SKjSs9
	4zfLvkw/9POs0MOkGZdOeR1Tn6z9MCz0/os+8VcfNil6bJ8RHVXdZL1HvnR9caJO8PldabXa
	R2VSU9YpPLr/bt7igHlXQnJOehwRnvnzhJxovBJLcUaioRZzUXEiAPZ1MOfhAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel address sanitizer hooks to mark allocated page's addresses
as accessible in corresponding shadow region.
Mark freed pages as unaccessible.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/kasan.h |  6 ++++++
 mm/Makefile           |  2 ++
 mm/kasan/kasan.c      | 18 ++++++++++++++++++
 mm/kasan/kasan.h      |  1 +
 mm/kasan/report.c     |  7 +++++++
 mm/page_alloc.c       |  4 ++++
 6 files changed, 38 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 7efc3eb..4adc0a1 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -17,6 +17,9 @@ void kasan_disable_local(void);
 void kasan_alloc_shadow(void);
 void kasan_init_shadow(void);
 
+void kasan_alloc_pages(struct page *page, unsigned int order);
+void kasan_free_pages(struct page *page, unsigned int order);
+
 #else /* CONFIG_KASAN */
 
 static inline void unpoison_shadow(const void *address, size_t size) {}
@@ -28,6 +31,9 @@ static inline void kasan_disable_local(void) {}
 static inline void kasan_init_shadow(void) {}
 static inline void kasan_alloc_shadow(void) {}
 
+static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
+static inline void kasan_free_pages(struct page *page, unsigned int order) {}
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff --git a/mm/Makefile b/mm/Makefile
index dbe9a22..6a9c3f8 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the linux memory manager.
 #
 
+KASAN_SANITIZE_page_alloc.o := n
+
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= gup.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index e2cd345..109478e 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -177,6 +177,24 @@ void __init kasan_init_shadow(void)
 	}
 }
 
+void kasan_alloc_pages(struct page *page, unsigned int order)
+{
+	if (unlikely(!kasan_initialized))
+		return;
+
+	if (likely(page && !PageHighMem(page)))
+		unpoison_shadow(page_address(page), PAGE_SIZE << order);
+}
+
+void kasan_free_pages(struct page *page, unsigned int order)
+{
+	if (unlikely(!kasan_initialized))
+		return;
+
+	if (likely(!PageHighMem(page)))
+		poison_shadow(page_address(page), PAGE_SIZE << order, KASAN_FREE_PAGE);
+}
+
 void *kasan_memcpy(void *dst, const void *src, size_t len)
 {
 	if (unlikely(len == 0))
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 711ae4f..be9597e 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -5,6 +5,7 @@
 #define KASAN_SHADOW_SCALE_SIZE (1UL << KASAN_SHADOW_SCALE_SHIFT)
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
+#define KASAN_FREE_PAGE         0xFF  /* page was freed */
 #define KASAN_SHADOW_GAP        0xF9  /* address belongs to shadow memory */
 
 struct access_info {
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 2430e05..6ef9e57 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -46,6 +46,9 @@ static void print_error_description(struct access_info *info)
 	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
 		bug_type = "buffer overflow";
 		break;
+	case KASAN_FREE_PAGE:
+		bug_type = "use after free";
+		break;
 	case KASAN_SHADOW_GAP:
 		bug_type = "wild memory access";
 		break;
@@ -67,6 +70,10 @@ static void print_address_description(struct access_info *info)
 	page = virt_to_page(info->access_addr);
 
 	switch (shadow_val) {
+	case KASAN_FREE_PAGE:
+		dump_page(page, "kasan error");
+		dump_stack();
+		break;
 	case KASAN_SHADOW_GAP:
 		pr_err("No metainfo is available for this access.\n");
 		dump_stack();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8c9eeec..67833d1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -61,6 +61,7 @@
 #include <linux/page-debug-flags.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
+#include <linux/kasan.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -747,6 +748,7 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -2807,6 +2809,7 @@ out:
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
+	kasan_alloc_pages(page, order);
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
@@ -6415,6 +6418,7 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 	if (end != outer_end)
 		free_contig_range(end, outer_end - end);
 
+	kasan_alloc_pages(pfn_to_page(start), end - start);
 done:
 	undo_isolate_page_range(pfn_max_align_down(start),
 				pfn_max_align_up(end), migratetype);
-- 
1.8.5.5

