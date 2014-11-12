Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaKLIZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:25:12 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49601 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaKLIZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:25:07 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Alexander Nyberg <alexn@dsv.su.se>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH 3/5] mm/debug-pagealloc: make debug-pagealloc boottime configurable
Date: Wed, 12 Nov 2014 17:27:13 +0900
Message-Id: <1415780835-24642-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415780835-24642-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1415780835-24642-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have prepared to avoid using debug-pagealloc in boottime. So
introduce new kernel-parameter to disable debug-pagealloc in boottime,
and makes related functions to be disabled in this case.

Only non-intuitive part is to change of guard page functions. Because
guard page is effective only if debug-pagealloc is enabled, turning off
according to debug-pagealloc is reasonable thing to do.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 arch/powerpc/mm/hash_utils_64.c |    2 +-
 arch/powerpc/mm/pgtable_32.c    |    2 +-
 arch/s390/mm/pageattr.c         |    2 +-
 arch/sparc/mm/init_64.c         |    2 +-
 arch/x86/mm/pageattr.c          |    2 +-
 include/linux/mm.h              |   17 ++++++++++++++++-
 mm/debug-pagealloc.c            |    5 ++++-
 mm/page_alloc.c                 |   16 ++++++++++++++++
 8 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index d5339a3..57b9c23 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -1432,7 +1432,7 @@ static void kernel_unmap_linear_page(unsigned long vaddr, unsigned long lmi)
 			       mmu_kernel_ssize, 0);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long flags, vaddr, lmi;
 	int i;
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index cf11342..b98aac6 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -430,7 +430,7 @@ static int change_page_attr(struct page *page, int numpages, pgprot_t prot)
 }
 
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 3fef3b2..426c9d4 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -120,7 +120,7 @@ static void ipte_range(pte_t *pte, unsigned long address, int nr)
 	}
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long address;
 	int nr, i, j;
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 2d91c62..3ea267c 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1621,7 +1621,7 @@ static void __init kernel_physical_mapping_init(void)
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long phys_start = page_to_pfn(page) << PAGE_SHIFT;
 	unsigned long phys_end = phys_start + (numpages * PAGE_SIZE);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 36de293..4d304e1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1801,7 +1801,7 @@ static int __set_pages_np(struct page *page, int numpages)
 	return __change_page_attr_set_clr(&cpa, 0);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 849a9af..4ee1abb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2055,7 +2055,22 @@ static inline void vm_stat_account(struct mm_struct *mm,
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-extern void kernel_map_pages(struct page *page, int numpages, int enable);
+extern bool _debug_pagealloc_enabled;
+extern void __kernel_map_pages(struct page *page, int numpages, int enable);
+
+static inline bool debug_pagealloc_enabled(void)
+{
+	return _debug_pagealloc_enabled;
+}
+
+static inline void
+kernel_map_pages(struct page *page, int numpages, int enable)
+{
+	if (!debug_pagealloc_enabled())
+		return;
+
+	__kernel_map_pages(page, numpages, enable);
+}
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
diff --git a/mm/debug-pagealloc.c b/mm/debug-pagealloc.c
index ede1b38..4d53002 100644
--- a/mm/debug-pagealloc.c
+++ b/mm/debug-pagealloc.c
@@ -111,8 +111,11 @@ static void unpoison_pages(struct page *page, int n)
 		unpoison_page(page + i);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
+	if (!debug_pagealloc_enabled())
+		return;
+
 	if (enable)
 		unpoison_pages(page, numpages);
 	else
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7534733..4eea173 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -426,15 +426,31 @@ static inline void prep_zero_page(struct page *page, unsigned int order,
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
+bool _debug_pagealloc_enabled __read_mostly = true;
 bool _debug_guardpage_enabled __read_mostly;
 
+static int __init early_disable_debug_pagealloc(char *buf)
+{
+	_debug_pagealloc_enabled = false;
+
+	return 0;
+}
+early_param("disable_debug_pagealloc", early_disable_debug_pagealloc);
+
 static bool need_debug_guardpage(void)
 {
+	/* If we don't use debug_pagealloc, we don't need guard page */
+	if (!debug_pagealloc_enabled())
+		return false;
+
 	return true;
 }
 
 static void init_debug_guardpage(void)
 {
+	if (!debug_pagealloc_enabled())
+		return;
+
 	_debug_guardpage_enabled = true;
 }
 
-- 
1.7.9.5

