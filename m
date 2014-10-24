Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaJXIeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:34:20 -0400
Received: from mail-bn1on0098.outbound.protection.outlook.com ([157.56.110.98]:11298
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932421AbaJXIZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:29 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 11/29] nios2: Cache handling
Date: Fri, 24 Oct 2014 16:24:13 +0800
Message-ID: <1414139071-3818-12-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(22564002)(199003)(76482002)(99396003)(120916001)(77156001)(62966002)(33646002)(102836001)(85306004)(104166001)(47776003)(36756003)(64706001)(20776003)(31966008)(86362001)(50466002)(2201001)(92566001)(48376002)(92726001)(42186005)(50986999)(21056001)(76176999)(87936001)(88136002)(87286001)(44976005)(6806004)(84676001)(89996001)(68736004)(19580405001)(19580395003)(85852003)(229853001)(107046002)(93916002)(106466001)(105596002)(97736003)(95666004)(50226001)(77096002)(46102003)(80022003)(4396001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB213;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB213;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functionality required for cache maintenance.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/cache.h      |  36 +++++
 arch/nios2/include/asm/cacheflush.h |  52 +++++++
 arch/nios2/mm/cacheflush.c          | 270 ++++++++++++++++++++++++++++++++++++
 3 files changed, 358 insertions(+)
 create mode 100644 arch/nios2/include/asm/cache.h
 create mode 100644 arch/nios2/include/asm/cacheflush.h
 create mode 100644 arch/nios2/mm/cacheflush.c

diff --git a/arch/nios2/include/asm/cache.h b/arch/nios2/include/asm/cache.h
new file mode 100644
index 0000000..2293cf5
--- /dev/null
+++ b/arch/nios2/include/asm/cache.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ */
+
+#ifndef _ASM_NIOS2_CACHE_H
+#define _ASM_NIOS2_CACHE_H
+
+#define NIOS2_DCACHE_SIZE	CONFIG_NIOS2_DCACHE_SIZE
+#define NIOS2_ICACHE_SIZE	CONFIG_NIOS2_ICACHE_SIZE
+#define NIOS2_DCACHE_LINE_SIZE	CONFIG_NIOS2_DCACHE_LINE_SIZE
+#define NIOS2_ICACHE_LINE_SHIFT	5
+#define NIOS2_ICACHE_LINE_SIZE	(1 << NIOS2_ICACHE_LINE_SHIFT)
+
+/* bytes per L1 cache line */
+#define L1_CACHE_SHIFT		NIOS2_ICACHE_LINE_SHIFT
+#define L1_CACHE_BYTES		NIOS2_ICACHE_LINE_SIZE
+
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+
+#define __cacheline_aligned
+#define ____cacheline_aligned
+
+#endif
diff --git a/arch/nios2/include/asm/cacheflush.h b/arch/nios2/include/asm/cacheflush.h
new file mode 100644
index 0000000..52abba9
--- /dev/null
+++ b/arch/nios2/include/asm/cacheflush.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2003 Microtronix Datacom Ltd.
+ * Copyright (C) 2000-2002 Greg Ungerer <gerg@snapgear.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_CACHEFLUSH_H
+#define _ASM_NIOS2_CACHEFLUSH_H
+
+#include <linux/mm_types.h>
+
+/*
+ * This flag is used to indicate that the page pointed to by a pte is clean
+ * and does not require cleaning before returning it to the user.
+ */
+#define PG_dcache_clean PG_arch_1
+
+struct mm_struct;
+
+extern void flush_cache_all(void);
+extern void flush_cache_mm(struct mm_struct *mm);
+extern void flush_cache_dup_mm(struct mm_struct *mm);
+extern void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+	unsigned long end);
+extern void flush_cache_page(struct vm_area_struct *vma, unsigned long vmaddr,
+	unsigned long pfn);
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
+extern void flush_dcache_page(struct page *page);
+
+extern void flush_icache_range(unsigned long start, unsigned long end);
+extern void flush_icache_page(struct vm_area_struct *vma, struct page *page);
+
+#define flush_cache_vmap(start, end)		flush_dcache_range(start, end)
+#define flush_cache_vunmap(start, end)		flush_dcache_range(start, end)
+
+extern void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
+				unsigned long user_vaddr,
+				void *dst, void *src, int len);
+extern void copy_from_user_page(struct vm_area_struct *vma, struct page *page,
+				unsigned long user_vaddr,
+				void *dst, void *src, int len);
+
+extern void flush_dcache_range(unsigned long start, unsigned long end);
+extern void invalidate_dcache_range(unsigned long start, unsigned long end);
+
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+
+#endif /* _ASM_NIOS2_CACHEFLUSH_H */
diff --git a/arch/nios2/mm/cacheflush.c b/arch/nios2/mm/cacheflush.c
new file mode 100644
index 0000000..cf06a00
--- /dev/null
+++ b/arch/nios2/mm/cacheflush.c
@@ -0,0 +1,270 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009, Wind River Systems Inc
+ * Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ */
+
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+
+#include <asm/cacheflush.h>
+#include <asm/cpuinfo.h>
+
+static void __flush_dcache(unsigned long start, unsigned long end)
+{
+	unsigned long addr;
+
+	start &= ~(cpuinfo.dcache_line_size - 1);
+	end += (cpuinfo.dcache_line_size - 1);
+	end &= ~(cpuinfo.dcache_line_size - 1);
+
+	if (end > start + cpuinfo.dcache_size)
+		end = start + cpuinfo.dcache_size;
+
+	for (addr = start; addr < end; addr += cpuinfo.dcache_line_size) {
+		__asm__ __volatile__ ("   flushda 0(%0)\n"
+					: /* Outputs */
+					: /* Inputs  */ "r"(addr)
+					/* : No clobber */);
+	}
+}
+
+static void __flush_dcache_all(unsigned long start, unsigned long end)
+{
+	unsigned long addr;
+
+	start &= ~(cpuinfo.dcache_line_size - 1);
+	end += (cpuinfo.dcache_line_size - 1);
+	end &= ~(cpuinfo.dcache_line_size - 1);
+
+	if (end > start + cpuinfo.dcache_size)
+		end = start + cpuinfo.dcache_size;
+
+	for (addr = start; addr < end; addr += cpuinfo.dcache_line_size) {
+		__asm__ __volatile__ ("   flushd 0(%0)\n"
+					: /* Outputs */
+					: /* Inputs  */ "r"(addr)
+					/* : No clobber */);
+	}
+}
+
+static void __invalidate_dcache(unsigned long start, unsigned long end)
+{
+	unsigned long addr;
+
+	start &= ~(cpuinfo.dcache_line_size - 1);
+	end += (cpuinfo.dcache_line_size - 1);
+	end &= ~(cpuinfo.dcache_line_size - 1);
+
+	if (end > start + cpuinfo.dcache_size)
+		end = start + cpuinfo.dcache_size;
+
+	for (addr = start; addr < end; addr += cpuinfo.dcache_line_size) {
+		__asm__ __volatile__ ("   initda 0(%0)\n"
+					: /* Outputs */
+					: /* Inputs  */ "r"(addr)
+					/* : No clobber */);
+	}
+}
+
+static void __flush_icache(unsigned long start, unsigned long end)
+{
+	unsigned long addr;
+
+	start &= ~(cpuinfo.icache_line_size - 1);
+	end += (cpuinfo.icache_line_size - 1);
+	end &= ~(cpuinfo.icache_line_size - 1);
+
+	if (end > start + cpuinfo.icache_size)
+		end = start + cpuinfo.icache_size;
+
+	for (addr = start; addr < end; addr += cpuinfo.icache_line_size) {
+		__asm__ __volatile__ ("   flushi %0\n"
+					: /* Outputs */
+					: /* Inputs  */ "r"(addr)
+					/* : No clobber */);
+	}
+	__asm__ __volatile(" flushp\n");
+}
+
+static void flush_aliases(struct address_space *mapping, struct page *page)
+{
+	struct mm_struct *mm = current->active_mm;
+	struct vm_area_struct *mpnt;
+	pgoff_t pgoff;
+
+	pgoff = page->index;
+
+	flush_dcache_mmap_lock(mapping);
+	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
+		unsigned long offset;
+
+		if (mpnt->vm_mm != mm)
+			continue;
+		if (!(mpnt->vm_flags & VM_MAYSHARE))
+			continue;
+
+		offset = (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
+		flush_cache_page(mpnt, mpnt->vm_start + offset,
+			page_to_pfn(page));
+	}
+	flush_dcache_mmap_unlock(mapping);
+}
+
+void flush_cache_all(void)
+{
+	__flush_dcache_all(0, cpuinfo.dcache_size);
+	__flush_icache(0, cpuinfo.icache_size);
+}
+
+void flush_cache_mm(struct mm_struct *mm)
+{
+	flush_cache_all();
+}
+
+void flush_cache_dup_mm(struct mm_struct *mm)
+{
+	flush_cache_all();
+}
+
+void flush_icache_range(unsigned long start, unsigned long end)
+{
+	__flush_icache(start, end);
+}
+
+void flush_dcache_range(unsigned long start, unsigned long end)
+{
+	__flush_dcache(start, end);
+}
+EXPORT_SYMBOL(flush_dcache_range);
+
+void invalidate_dcache_range(unsigned long start, unsigned long end)
+{
+	__invalidate_dcache(start, end);
+}
+EXPORT_SYMBOL(invalidate_dcache_range);
+
+void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end)
+{
+	__flush_dcache(start, end);
+	if (vma == NULL || (vma->vm_flags & VM_EXEC))
+		__flush_icache(start, end);
+}
+
+void flush_icache_page(struct vm_area_struct *vma, struct page *page)
+{
+	unsigned long start = (unsigned long) page_address(page);
+	unsigned long end = start + PAGE_SIZE;
+
+	__flush_icache(start, end);
+}
+
+void flush_cache_page(struct vm_area_struct *vma, unsigned long vmaddr,
+			unsigned long pfn)
+{
+	unsigned long start = vmaddr;
+	unsigned long end = start + PAGE_SIZE;
+
+	__flush_dcache(start, end);
+	if (vma->vm_flags & VM_EXEC)
+		__flush_icache(start, end);
+}
+
+void flush_dcache_page(struct page *page)
+{
+	struct address_space *mapping;
+
+	/*
+	 * The zero page is never written to, so never has any dirty
+	 * cache lines, and therefore never needs to be flushed.
+	 */
+	if (page == ZERO_PAGE(0))
+		return;
+
+	mapping = page_mapping(page);
+
+	/* Flush this page if there are aliases. */
+	if (mapping && !mapping_mapped(mapping)) {
+		clear_bit(PG_dcache_clean, &page->flags);
+	} else {
+		unsigned long start = (unsigned long)page_address(page);
+		__flush_dcache_all(start, start + PAGE_SIZE);
+		if (mapping)
+			flush_aliases(mapping,  page);
+		set_bit(PG_dcache_clean, &page->flags);
+	}
+}
+EXPORT_SYMBOL(flush_dcache_page);
+
+void update_mmu_cache(struct vm_area_struct *vma,
+		      unsigned long address, pte_t *pte)
+{
+	unsigned long pfn = pte_pfn(*pte);
+	struct page *page;
+
+	if (!pfn_valid(pfn))
+		return;
+
+	/*
+	* The zero page is never written to, so never has any dirty
+	* cache lines, and therefore never needs to be flushed.
+	*/
+	page = pfn_to_page(pfn);
+	if (page == ZERO_PAGE(0))
+		return;
+
+	if (!PageReserved(page) &&
+	     !test_and_set_bit(PG_dcache_clean, &page->flags)) {
+		unsigned long start = page_to_virt(page);
+		struct address_space *mapping;
+
+		__flush_dcache(start, start + PAGE_SIZE);
+
+		mapping = page_mapping(page);
+		if (mapping)
+			flush_aliases(mapping, page);
+	}
+}
+
+void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
+		    struct page *to)
+{
+	__flush_dcache(vaddr, vaddr + PAGE_SIZE);
+	copy_page(vto, vfrom);
+	__flush_dcache((unsigned long)vto, (unsigned long)vto + PAGE_SIZE);
+}
+
+void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
+{
+	__flush_dcache(vaddr, vaddr + PAGE_SIZE);
+	clear_page(addr);
+	__flush_dcache((unsigned long)addr, (unsigned long)addr + PAGE_SIZE);
+}
+
+void copy_from_user_page(struct vm_area_struct *vma, struct page *page,
+			unsigned long user_vaddr,
+			void *dst, void *src, int len)
+{
+	flush_cache_page(vma, user_vaddr, page_to_pfn(page));
+	memcpy(dst, src, len);
+	__flush_dcache((unsigned long)src, (unsigned long)src + len);
+	if (vma->vm_flags & VM_EXEC)
+		__flush_icache((unsigned long)src, (unsigned long)src + len);
+}
+
+void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
+			unsigned long user_vaddr,
+			void *dst, void *src, int len)
+{
+	flush_cache_page(vma, user_vaddr, page_to_pfn(page));
+	memcpy(dst, src, len);
+	__flush_dcache((unsigned long)dst, (unsigned long)dst + len);
+	if (vma->vm_flags & VM_EXEC)
+		__flush_icache((unsigned long)dst, (unsigned long)dst + len);
+}
-- 
1.8.2.1

