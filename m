Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaJFQEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:04:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37794 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaJFQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:23 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c5-5432bcd2af5e
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
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org
Subject: [PATCH v4 05/13] mm: page_alloc: add kasan hooks on alloc and free
 paths
Date: Mon, 06 Oct 2014 19:53:59 +0400
Message-id: <1412610847-27671-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xy7qX9hiFGBz7xGSx7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8WW601MFs8fPmS3mPCwjd1i2kZxi5XdzWwW25+9ZbJY
	2fmA1eLyrjlsFvfW/Ge1WHzkNrPFu2eTmS2urjrIbvFjw2NWB2GP+Ts/MnrsnHWX3WPBplKP
	xXteMnlsWtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xeLzfd5XNo2/LKkaPz5vkPE60
	fGEN4IvisklJzcksSy3St0vgymi5IFRwS7Xizvu37A2MPfJdjJwcEgImEu/3z2ODsMUkLtxb
	D2RzcQgJLGWUeDJvCpTTxyRxaNYWFpAqNgE9iX+ztoN1iAgoSGzufcYKUsQsMIVV4t3yXYwg
	CWGBYInTR/cB2RwcLAKqEm8aq0HCvAJuEh/nbmaG2CYnMX3vXbCZnALuEtOuzGSHWNbEKHHo
	yw62CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKERMmXHYyLj1kdYhTgYFTi4Y3Y
	YRgixJpYVlyZe4hRgoNZSYTXfJ5RiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGtWn79NT9Ob3U
	VOd9XP1qwvydH25IyswQUnXdOGXnwsaw30HOYveuGcTI3/zR9b5qk5n0Qp+wrXOcpY8nXbcK
	22X/92BfaaBW594/jRevSC3p+bVp9sfTDDNv1vLpLJpWsZLj0tQpns8Do34rrYwT7SuNEGvP
	vlo5693MH/7Te9eEm7otqtu/XomlOCPRUIu5qDgRADqMcb9wAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel address sanitizer hooks to mark allocated page's addresses
as accessible in corresponding shadow region.
Mark freed pages as inaccessible.

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
index 01c99fe..9714fba 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -30,6 +30,9 @@ static inline void kasan_disable_local(void)
 
 void kasan_unpoison_shadow(const void *address, size_t size);
 
+void kasan_alloc_pages(struct page *page, unsigned int order);
+void kasan_free_pages(struct page *page, unsigned int order);
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
@@ -37,6 +40,9 @@ static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
 static inline void kasan_enable_local(void) {}
 static inline void kasan_disable_local(void) {}
 
+static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
+static inline void kasan_free_pages(struct page *page, unsigned int order) {}
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff --git a/mm/compaction.c b/mm/compaction.c
index edba18a..834f846 100644
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
index 8ce738e..5782082 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -259,6 +259,20 @@ static __always_inline void check_memory_region(unsigned long addr,
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
index 9a9fe9f..ee572c4 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -6,6 +6,7 @@
 #define KASAN_SHADOW_SCALE_SIZE (1UL << KASAN_SHADOW_SCALE_SHIFT)
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
+#define KASAN_FREE_PAGE         0xFF  /* page was freed */
 #define KASAN_SHADOW_GAP        0xF9  /* address belongs to shadow memory */
 
 struct access_info {
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 89a9aa1..707323b 100644
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
@@ -75,6 +78,10 @@ static void print_address_description(struct access_info *info)
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
index 53e10ff..88b5032 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -59,6 +59,7 @@
 #include <linux/page-debug-flags.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
+#include <linux/kasan.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -755,6 +756,7 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -941,6 +943,7 @@ static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags)
 
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
+	kasan_alloc_pages(page, order);
 
 	if (gfp_flags & __GFP_ZERO)
 		prep_zero_page(page, order, gfp_flags);
-- 
2.1.2

