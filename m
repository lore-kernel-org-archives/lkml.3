Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbbA2PRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:17:20 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19003 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbbA2PM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:28 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-d7-54ca4d489621
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
        x86@kernel.org, linux-mm@kvack.org
Subject: [PATCH v10 03/17] mm: page_alloc: add kasan hooks on alloc and free
 paths
Date: Thu, 29 Jan 2015 18:11:47 +0300
Message-id: <1422544321-24232-4-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7oevqdCDO79sLLY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0eL5w4fsFhMetrFbrOxuZrPY/uwtk8XKzgesFpd3zWGz
	uLfmP6vF4iO3mS3ePZvMbPFjw2NWBwGP+Ts/MnrsnHWX3WPBplKPxXteMnlsWtXJ5rHp0yR2
	j663V5g8Tsz4zeLx5Mp0Jo+PT2+xePRtWcXo8XmTXABPFJdNSmpOZllqkb5dAlfG0W/rGAuO
	qlV82HqauYHxmXwXIyeHhICJxOdJc1kgbDGJC/fWs4HYQgJLGSVm7ajtYuQCsvuYJM40HQEr
	YhPQk/g3aztYkYiAgsTm3mesIEXMAitYJL5cW8EIkhAWCJFY2zEBrIhFQFXi/sfLTCA2r4Cb
	xMyvc4HiHEDb5CQufIwHCXMKuEv8u/eYCWJZE6PExrPz2CYw8i5gZFjFKJpamlxQnJSea6hX
	nJhbXJqXrpecn7uJERL0X3YwLj5mdYhRgINRiYd35qaTIUKsiWXFlbmHGCU4mJVEeJdangoR
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwKho8yN5hZuO0n6OG/oXe1P2JczYIep9eL72UZmDX5cv
	nlZ9Wvz9jc4nxkpzi8Le+uxW3BGjdOfH35s1bRf7Xf9Jic3uKbKZ7Wdcd+qA9EFrv+yA0413
	Xdk49s5jCFnbUhZ9rSaGd1X8TaFrRdkKlZfkfleE1AmHeMtscxHucWPXvK39Z7XYBCWW4oxE
	Qy3mouJEAMlT5lZYAgAA
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
 mm/kasan/kasan.h      |  2 ++
 mm/kasan/report.c     | 11 +++++++++++
 mm/page_alloc.c       |  3 +++
 6 files changed, 38 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bb72642..ab5131e 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -31,6 +31,9 @@ static inline void kasan_disable_local(void)
 
 void kasan_unpoison_shadow(const void *address, size_t size);
 
+void kasan_alloc_pages(struct page *page, unsigned int order);
+void kasan_free_pages(struct page *page, unsigned int order);
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
@@ -38,6 +41,9 @@ static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
 static inline void kasan_enable_local(void) {}
 static inline void kasan_disable_local(void) {}
 
+static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
+static inline void kasan_free_pages(struct page *page, unsigned int order) {}
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff --git a/mm/compaction.c b/mm/compaction.c
index b68736c..b2d3ef9 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -16,6 +16,7 @@
 #include <linux/sysfs.h>
 #include <linux/balloon_compaction.h>
 #include <linux/page-isolation.h>
+#include <linux/kasan.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -72,6 +73,7 @@ static void map_pages(struct list_head *list)
 	list_for_each_entry(page, list, lru) {
 		arch_alloc_page(page, 0);
 		kernel_map_pages(page, 1, 1);
+		kasan_alloc_pages(page, 0);
 	}
 }
 
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index 895fa5f..ea86458 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -247,6 +247,20 @@ static __always_inline void check_memory_region(unsigned long addr,
 	kasan_report(addr, size, write);
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
 #define DECLARE_ASAN_CHECK(size)				\
 	void __asan_load##size(unsigned long addr)		\
 	{							\
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index da0e53c..0f09fb2 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -6,6 +6,8 @@
 #define KASAN_SHADOW_SCALE_SIZE (1UL << KASAN_SHADOW_SCALE_SHIFT)
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
+#define KASAN_FREE_PAGE         0xFF  /* page was freed */
+
 struct access_info {
 	unsigned long access_addr;
 	unsigned long first_bad_addr;
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 21a9eeb..4e26c68 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -54,6 +54,9 @@ static void print_error_description(struct access_info *info)
 	shadow_val = *(u8 *)kasan_mem_to_shadow(info->first_bad_addr);
 
 	switch (shadow_val) {
+	case KASAN_FREE_PAGE:
+		bug_type = "use after free";
+		break;
 	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
 		bug_type = "out of bounds access";
 		break;
@@ -69,6 +72,14 @@ static void print_error_description(struct access_info *info)
 
 static void print_address_description(struct access_info *info)
 {
+	unsigned long addr = info->access_addr;
+
+	if ((addr >= PAGE_OFFSET) &&
+		(addr < (unsigned long)high_memory)) {
+		struct page *page = virt_to_head_page((void *)addr);
+		dump_page(page, "kasan: bad access detected");
+	}
+
 	dump_stack();
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8d52ab1..31bc2e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -25,6 +25,7 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/kmemcheck.h>
+#include <linux/kasan.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
 #include <linux/pagevec.h>
@@ -787,6 +788,7 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -970,6 +972,7 @@ static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
+	kasan_alloc_pages(page, order);
 
 	if (gfp_flags & __GFP_ZERO)
 		prep_zero_page(page, order, gfp_flags);
-- 
2.2.2

