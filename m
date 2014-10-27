Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaJ0QuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:50:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52388 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaJ0Qrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:45 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-ec-544e772fec8d
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/12] mm: page_alloc: add kasan hooks on alloc and free
 paths
Date: Mon, 27 Oct 2014 19:46:52 +0300
Message-id: <1414428419-17860-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xa7r65X4hBn/+W1ls+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1ktFh+5zWzx7tlkZourqw6yW/zY8JjVQdhj/s6PjB47Z91l91iwqdRj
	8Z6XTB6bVnWyeWz6NIndo+vtFSaPEzN+s3g8uTKdyePj01ssHu/3XWXz6NuyitHj8yY5jxMt
	X1gD+KK4bFJSczLLUov07RK4Mpaf2stWcEu1YmXPVOYGxh75LkZODgkBE4m9F34zQ9hiEhfu
	rWfrYuTiEBJYyiixZ/NEZginj0liZdcrNpAqNgE9iX+ztoPZIgK6Eque7wLrZhZoZZU4tTUJ
	xBYWCJZY8K4NqIaDg0VAVWLeoxqQMK+Am0TjrHvsEMvkJKbvvcsCYnMKuEv0XJrGArGriVGi
	b8py5gmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihETJlx2Mi49ZHWIU4GBU4uHd
	Mc03RIg1say4MvcQowQHs5II74E0vxAh3pTEyqrUovz4otKc1OJDjEwcnFINjLwnjWcse7Xp
	ivcb3/eXt590TcpYuPjs4aC66btPP+uVaDXcfnnxrfc7qtKd3ibMDL378eHSjD0fBXZW7ak7
	OkV2uqn5JJ19q/4GbTlRbJ7x5EDHu8Rkww9XV7tIPyvs2n9oqfa76G/H7E4HRwlZxQWkJLVx
	uB0pfMbK/JwrTGLFad2PNlNKp1grsRRnJBpqMRcVJwIAdvd9l3ACAAA=
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
index e6e7405..aa529ad 100644
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
index 11fa3f8..2853c92 100644
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
index fa94263..9ae7d0e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -59,6 +59,7 @@
 #include <linux/page-debug-flags.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
+#include <linux/kasan.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -759,6 +760,7 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -945,6 +947,7 @@ static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags)
 
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
+	kasan_alloc_pages(page, order);
 
 	if (gfp_flags & __GFP_ZERO)
 		prep_zero_page(page, order, gfp_flags);
-- 
2.1.2

