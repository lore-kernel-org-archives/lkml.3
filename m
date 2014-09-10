Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaIJOii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:38:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34003 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaIJOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:38:31 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e6-54106264b4e6
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org
Subject: [RFC/PATCH v2 03/10] mm: page_alloc: add kasan hooks on alloc and free
 pathes
Date: Wed, 10 Sep 2014 18:31:20 +0400
Message-id: <1410359487-31938-4-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xq7opSQIhBl8PCVhs+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaPH84UN2iwkP29gtpm0Ut1jZ3cxmsf3ZWyaLlZ0PWC0u
	75rDZnFvzX9Wi8VHbjNbvHs2mdni6qqD7BY/NjxmdRDymL/zI6PHzll32T0WbCr1WLznJZPH
	plWdbB6bPk1i9+h6e4XJ48SM3yweT65MZ/L4+PQWi0ffllWMHp83yXmcaPnCGsAbxWWTkpqT
	WZZapG+XwJXxqO8EU8FK1Yqtsx4xNjA+kuti5OSQEDCROPfhNhuELSZx4d56IJuLQ0hgKaPE
	/NYedpCEkEAfk8SUA7wgNpuAnsS/WdvBGkQEFCQ29z5jBWlgFvjKInH+7w4WkISwQITExZ9v
	WEFsFgFVidVr9oPFeQXcJC72bGGG2CYnsWH3f0YQm1PAXeLUyRVMEJubGCWWXNjEPoGRdwEj
	wypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkJj4soNx8TGrQ4wCHIxKPLyFF/lDhFgTy4or
	cw8xSnAwK4nwNjkIhAjxpiRWVqUW5ccXleakFh9iZOLglGpg5JqSbJNkaSlam/oiJi/WQLh6
	z0lxbm/tFe9msxSfbanaLyvBaX+3IfYgQ5S9X3O35UE+iZdzZ6/p2Pzf/ajhVFmBE5Me9yx0
	uKFtvz1md5RhTNuOprpHm4+JWO2Y27jc853HyqjH89g9XQ9+D+91t34zSXRKpr67mreH162/
	2i9SdtUKn1qhxFKckWioxVxUnAgAjgqVOWcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel address sanitizer hooks to mark allocated page's addresses
as accessible in corresponding shadow region.
Mark freed pages as unaccessible.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/kasan.h |  6 ++++++
 mm/compaction.c       |  2 ++
 mm/kasan/kasan.c      | 14 ++++++++++++++
 mm/kasan/kasan.h      |  1 +
 mm/kasan/report.c     |  7 +++++++
 mm/page_alloc.c       |  3 +++
 6 files changed, 33 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index f957ee9..c5ae971 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -31,6 +31,9 @@ static inline void kasan_disable_local(void)
 void kasan_unpoison_shadow(const void *address, size_t size);
 void kasan_map_shadow(void);
 
+void kasan_alloc_pages(struct page *page, unsigned int order);
+void kasan_free_pages(struct page *page, unsigned int order);
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
@@ -40,6 +43,9 @@ static inline void kasan_disable_local(void) {}
 
 static inline void kasan_map_shadow(void) {}
 
+static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
+static inline void kasan_free_pages(struct page *page, unsigned int order) {}
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff --git a/mm/compaction.c b/mm/compaction.c
index 7d9d92e..a8c5d6d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -16,6 +16,7 @@
 #include <linux/sysfs.h>
 #include <linux/balloon_compaction.h>
 #include <linux/page-isolation.h>
+#include <linux/kasan.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -59,6 +60,7 @@ static void map_pages(struct list_head *list)
 	list_for_each_entry(page, list, lru) {
 		arch_alloc_page(page, 0);
 		kernel_map_pages(page, 1, 1);
+		kasan_alloc_pages(page, 0);
 	}
 }
 
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index 65f8145..ed4e925 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -109,6 +109,20 @@ static __always_inline void check_memory_region(unsigned long addr,
 	kasan_report_error(&info);
 }
 
+void kasan_alloc_pages(struct page *page, unsigned int order)
+{
+	if (likely(!PageHighMem(page)))
+		kasan_unpoison_shadow(page_address(page), PAGE_SIZE << order);
+}
+
+void kasan_free_pages(struct page *page, unsigned int order)
+{
+	if (likely(!PageHighMem(page)))
+		kasan_poison_shadow(page_address(page),
+				PAGE_SIZE << order,
+				KASAN_FREE_PAGE);
+}
+
 void __asan_load1(unsigned long addr)
 {
 	check_memory_region(addr, 1, false);
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 2ea2ed7..227e9c6 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -6,6 +6,7 @@
 #define KASAN_SHADOW_SCALE_SIZE (1UL << KASAN_SHADOW_SCALE_SHIFT)
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
+#define KASAN_FREE_PAGE         0xFF  /* page was freed */
 #define KASAN_SHADOW_GAP        0xF9  /* address belongs to shadow memory */
 
 struct access_info {
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 3bfc8b6..94d79e7 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -57,6 +57,9 @@ static void print_error_description(struct access_info *info)
 	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
 		bug_type = "out of bounds access";
 		break;
+	case KASAN_FREE_PAGE:
+		bug_type = "use after free";
+		break;
 	case KASAN_SHADOW_GAP:
 		bug_type = "wild memory access";
 		break;
@@ -78,6 +81,10 @@ static void print_address_description(struct access_info *info)
 	page = virt_to_head_page((void *)info->access_addr);
 
 	switch (shadow_val) {
+	case KASAN_FREE_PAGE:
+		dump_page(page, "kasan error");
+		dump_stack();
+		break;
 	case KASAN_SHADOW_GAP:
 		pr_err("No metainfo is available for this access.\n");
 		dump_stack();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3935c9a..63c55c9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -61,6 +61,7 @@
 #include <linux/page-debug-flags.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
+#include <linux/kasan.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -753,6 +754,7 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -932,6 +934,7 @@ static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags)
 
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
+	kasan_alloc_pages(page, order);
 
 	if (gfp_flags & __GFP_ZERO)
 		prep_zero_page(page, order, gfp_flags);
-- 
1.8.5.5

