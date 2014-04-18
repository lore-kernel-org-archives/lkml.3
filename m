Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaDRMwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:52:13 -0400
Received: from mail-by2on0103.outbound.protection.outlook.com ([207.46.100.103]:56236
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752808AbaDRMm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:42:59 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 11/28] nios2: Cache handling
Date: Fri, 18 Apr 2014 20:26:55 +0800
Message-ID: <1397824031-4892-9-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(22564002)(93916002)(86362001)(575784001)(97736001)(46102001)(4396001)(50466002)(80022001)(76176999)(80976001)(62966002)(81342001)(50226001)(81542001)(48376002)(50986999)(2009001)(87286001)(99396002)(89996001)(88136002)(16796002)(74662001)(31966008)(74502001)(20776003)(47776003)(85852003)(83072002)(76482001)(42186004)(77156001)(84676001)(87936001)(77982001)(92566001)(2201001)(92726001)(83322001)(19580405001)(19580395003)(6806004)(44976005)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB019;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:EDBA7564.2CDA9F41.40F58176.8CE5E048.20554;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functionality required for cache maintenance.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/cache.h      |  36 +++++
 arch/nios2/include/asm/cacheflush.h |  48 +++++++
 arch/nios2/mm/cacheflush.c          | 255 ++++++++++++++++++++++++++++++++++++
 3 files changed, 339 insertions(+)
 create mode 100644 arch/nios2/include/asm/cache.h
 create mode 100644 arch/nios2/include/asm/cacheflush.h
 create mode 100644 arch/nios2/mm/cacheflush.c

diff --git a/arch/nios2/include/asm/cache.h b/arch/nios2/include/asm/cache.h
new file mode 100644
index 0000000..2293cf57e307a6b84e3972c2d27221dda54af500
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
index 0000000..ce2605a8c44de7e33686f9021b2b6736e94455a2
--- /dev/null
+++ b/arch/nios2/include/asm/cacheflush.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2003 Microtronix Datacom Ltd.
+ * Copyright (C) 2000-2002 Greg Ungerer <gerg@snapgear.com>
+ *
+ * Ported from m68knommu.
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
index 0000000..0c4d0d416f8f603f92b66017d100d3388f3d04c1
--- /dev/null
+++ b/arch/nios2/mm/cacheflush.c
@@ -0,0 +1,255 @@
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
+	struct address_space *mapping = page_mapping(page);
+
+	/* Flush this page if there are aliases. */
+	if (mapping) {
+		if (!mapping_mapped(mapping)) {
+			clear_bit(PG_arch_1, &page->flags);
+		} else if (mapping) {
+			unsigned long start = (unsigned long)page_address(page);
+			__flush_dcache(start, start + PAGE_SIZE);
+			flush_aliases(mapping,  page);
+		}
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
+	page = pfn_to_page(pfn);
+
+	if (!PageReserved(page) && !test_bit(PG_arch_1, &page->flags)) {
+		unsigned long start = page_to_virt(page);
+		struct address_space *mapping;
+
+		__flush_dcache(start, start + PAGE_SIZE);
+
+		mapping = page_mapping(page);
+		if (mapping)
+			flush_aliases(mapping, page);
+		set_bit(PG_arch_1, &page->flags);
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
1.8.3.2

