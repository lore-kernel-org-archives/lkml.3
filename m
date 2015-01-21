Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbbAUQwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:52:33 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37326 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbbAUQwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:12 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-83-54bfd8a92248
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
Subject: [PATCH v9 03/17] mm: page_alloc: add kasan hooks on alloc and free
 paths
Date: Wed, 21 Jan 2015 19:51:31 +0300
Message-id: <1421859105-25253-4-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xq7orb+wPMej4Lmmx7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8Xzhw/ZLSY8bGO3WNndzGax/dlbJouVnQ9YLS7vmsNm
	cW/Nf1aLxUduM1u8ezaZ2eLHhsesDgIe83d+ZPTYOesuu8eCTaUei/e8ZPLYtKqTzWPTp0ns
	Hl1vrzB5nJjxm8XjyZXpTB4fn95i8ejbsorR4/MmuQCeKC6blNSczLLUIn27BK6MCx3dTAUr
	VSs+nTvB2MD4RK6LkZNDQsBEoqP9IzuELSZx4d56ti5GLg4hgaWMEldedrGCJIQE+pgkXvTL
	gthsAnoS/2ZtZwOxRQQUJDb3PmMFaWAWWMEi8eXaCkaQhLBAsMT1W8+Yuxg5OFgEVCXaFoEt
	4BVwk2h/vJMJYpmcxMY7K8Dmcwq4S8w8P5EJYnETo8TnI9vZJjDyLmBkWMUomlqaXFCclJ5r
	qFecmFtcmpeul5yfu4kREvRfdjAuPmZ1iFGAg1GJh7cidH+IEGtiWXFl7iFGCQ5mJRHe+deB
	QrwpiZVVqUX58UWlOanFhxiZODilGhhb/z35OPXwiY7voRc6Np4S7E98Fyv0S85RMJJB+Meu
	DfPmOa5I/PHV4EyoO99xu33mezm/zboWVHVm9ZTHr2aVTr4gdP5G9tI/x2t3+vL9ubjYds2m
	9W2/M0RW7hX4zxRipLLIybie43lpv6rafEnNlZI8M99Hx7gW1H24US11K1DzRVuWkniSEktx
	RqKhFnNRcSIAplJVT1gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel address sanitizer hooks to mark allocated page's addresses
as accessible in corresponding shadow region.
Mark freed pages as inaccessible.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/kasan.h |  7 +++++++
 mm/compaction.c       |  2 ++
 mm/kasan/kasan.c      | 14 ++++++++++++++
 mm/kasan/report.c     | 11 +++++++++++
 mm/page_alloc.c       |  3 +++
 5 files changed, 37 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 063a3f3..a278ccc 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -11,6 +11,7 @@ struct page;
 #define KASAN_SHADOW_SCALE_SHIFT 3
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 
+#define KASAN_FREE_PAGE         0xFF  /* page was freed */
 #define KASAN_SHADOW_GAP        0xF9  /* address belongs to shadow memory */
 
 #include <asm/kasan.h>
@@ -33,6 +34,9 @@ static inline void kasan_disable_local(void)
 
 void kasan_unpoison_shadow(const void *address, size_t size);
 
+void kasan_alloc_pages(struct page *page, unsigned int order);
+void kasan_free_pages(struct page *page, unsigned int order);
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
@@ -40,6 +44,9 @@ static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
 static inline void kasan_enable_local(void) {}
 static inline void kasan_disable_local(void) {}
 
+static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
+static inline void kasan_free_pages(struct page *page, unsigned int order) {}
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff --git a/mm/compaction.c b/mm/compaction.c
index 546e571..12f2c7d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -16,6 +16,7 @@
 #include <linux/sysfs.h>
 #include <linux/balloon_compaction.h>
 #include <linux/page-isolation.h>
+#include <linux/kasan.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -61,6 +62,7 @@ static void map_pages(struct list_head *list)
 	list_for_each_entry(page, list, lru) {
 		arch_alloc_page(page, 0);
 		kernel_map_pages(page, 1, 1);
+		kasan_alloc_pages(page, 0);
 	}
 }
 
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index 740d5b2..efe8105 100644
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
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 62b942a..7983ebb 100644
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
@@ -72,6 +75,14 @@ static void print_error_description(struct access_info *info)
 
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
index 7633c50..3a75171 100644
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
@@ -807,6 +808,7 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -985,6 +987,7 @@ static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags)
 
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
+	kasan_alloc_pages(page, order);
 
 	if (gfp_flags & __GFP_ZERO)
 		prep_zero_page(page, order, gfp_flags);
-- 
2.2.1

