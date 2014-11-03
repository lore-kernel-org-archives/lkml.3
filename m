Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaKCKx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:53:59 -0500
Received: from mail-bn1bon0073.outbound.protection.outlook.com ([157.56.111.73]:35986
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154AbaKCKxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:53:51 -0500
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v6 07/29] nios2: I/O Mapping
Date: Mon, 3 Nov 2014 18:52:03 +0800
Message-ID: <1415011945-3297-8-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415011945-3297-1-git-send-email-lftan@altera.com>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(22564002)(189002)(99396003)(120916001)(19580395003)(88136002)(50466002)(84676001)(86362001)(2201001)(89996001)(92566001)(92726001)(93916002)(48376002)(46102003)(44976005)(6806004)(19580405001)(21056001)(68736004)(87936001)(47776003)(87286001)(64706001)(20776003)(104166001)(50986999)(50226001)(4396001)(42186005)(102836001)(107046002)(36756003)(106466001)(31966008)(76176999)(229853001)(33646002)(97736003)(77156002)(77096003)(62966003)(95666004)(105596002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB224;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB224;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds several definitions for I/O accessors and ioremap().

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/io.h |  61 +++++++++++++++
 arch/nios2/mm/ioremap.c     | 187 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 248 insertions(+)
 create mode 100644 arch/nios2/include/asm/io.h
 create mode 100644 arch/nios2/mm/ioremap.c

diff --git a/arch/nios2/include/asm/io.h b/arch/nios2/include/asm/io.h
new file mode 100644
index 0000000..13dc22b
--- /dev/null
+++ b/arch/nios2/include/asm/io.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2014 Altera Corporation
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_IO_H
+#define _ASM_NIOS2_IO_H
+
+#include <asm/pgtable-bits.h>
+#include <asm-generic/iomap.h>
+
+/* PCI is not supported in nios2, set this to 0. */
+#define IO_SPACE_LIMIT 0
+
+#define readb_relaxed(addr)	readb(addr)
+#define readw_relaxed(addr)	readw(addr)
+#define readl_relaxed(addr)	readl(addr)
+
+#define writeb_relaxed(x, addr)	writeb(x, addr)
+#define writew_relaxed(x, addr)	writew(x, addr)
+#define writel_relaxed(x, addr)	writel(x, addr)
+
+#include <asm-generic/io.h>
+
+extern void __iomem *__ioremap(unsigned long physaddr, unsigned long size,
+			unsigned long cacheflag);
+extern void __iounmap(void __iomem *addr);
+
+static inline void __iomem *ioremap(unsigned long physaddr, unsigned long size)
+{
+	return __ioremap(physaddr, size, 0);
+}
+
+static inline void __iomem *ioremap_nocache(unsigned long physaddr,
+						unsigned long size)
+{
+	return __ioremap(physaddr, size, 0);
+}
+
+static inline void iounmap(void __iomem *addr)
+{
+	__iounmap(addr);
+}
+
+/* Pages to physical address... */
+# define page_to_phys(page)	virt_to_phys(page_to_virt(page))
+# define page_to_bus(page)	page_to_virt(page)
+
+/* Macros used for converting between virtual and physical mappings. */
+# define phys_to_virt(vaddr)	\
+	((void *)((unsigned long)(vaddr) | CONFIG_NIOS2_KERNEL_REGION_BASE))
+/* Clear top 3 bits */
+# define virt_to_phys(vaddr)	\
+	((unsigned long)((unsigned long)(vaddr) & ~0xE0000000))
+
+#endif /* _ASM_NIOS2_IO_H */
diff --git a/arch/nios2/mm/ioremap.c b/arch/nios2/mm/ioremap.c
new file mode 100644
index 0000000..3a28177
--- /dev/null
+++ b/arch/nios2/mm/ioremap.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+
+static inline void remap_area_pte(pte_t *pte, unsigned long address,
+				unsigned long size, unsigned long phys_addr,
+				unsigned long flags)
+{
+	unsigned long end;
+	unsigned long pfn;
+	pgprot_t pgprot = __pgprot(_PAGE_GLOBAL | _PAGE_PRESENT | _PAGE_READ
+				| _PAGE_WRITE | flags);
+
+	address &= ~PMD_MASK;
+	end = address + size;
+	if (end > PMD_SIZE)
+		end = PMD_SIZE;
+	if (address >= end)
+		BUG();
+	pfn = PFN_DOWN(phys_addr);
+	do {
+		if (!pte_none(*pte)) {
+			pr_err("remap_area_pte: page already exists\n");
+			BUG();
+		}
+		set_pte(pte, pfn_pte(pfn, pgprot));
+		address += PAGE_SIZE;
+		pfn++;
+		pte++;
+	} while (address && (address < end));
+}
+
+static inline int remap_area_pmd(pmd_t *pmd, unsigned long address,
+				unsigned long size, unsigned long phys_addr,
+				unsigned long flags)
+{
+	unsigned long end;
+
+	address &= ~PGDIR_MASK;
+	end = address + size;
+	if (end > PGDIR_SIZE)
+		end = PGDIR_SIZE;
+	phys_addr -= address;
+	if (address >= end)
+		BUG();
+	do {
+		pte_t *pte = pte_alloc_kernel(pmd, address);
+
+		if (!pte)
+			return -ENOMEM;
+		remap_area_pte(pte, address, end - address, address + phys_addr,
+			flags);
+		address = (address + PMD_SIZE) & PMD_MASK;
+		pmd++;
+	} while (address && (address < end));
+	return 0;
+}
+
+static int remap_area_pages(unsigned long address, unsigned long phys_addr,
+				unsigned long size, unsigned long flags)
+{
+	int error;
+	pgd_t *dir;
+	unsigned long end = address + size;
+
+	phys_addr -= address;
+	dir = pgd_offset(&init_mm, address);
+	flush_cache_all();
+	if (address >= end)
+		BUG();
+	do {
+		pud_t *pud;
+		pmd_t *pmd;
+
+		error = -ENOMEM;
+		pud = pud_alloc(&init_mm, dir, address);
+		if (!pud)
+			break;
+		pmd = pmd_alloc(&init_mm, pud, address);
+		if (!pmd)
+			break;
+		if (remap_area_pmd(pmd, address, end - address,
+			phys_addr + address, flags))
+			break;
+		error = 0;
+		address = (address + PGDIR_SIZE) & PGDIR_MASK;
+		dir++;
+	} while (address && (address < end));
+	flush_tlb_all();
+	return error;
+}
+
+#define IS_MAPPABLE_UNCACHEABLE(addr) (addr < 0x20000000UL)
+
+/*
+ * Map some physical address range into the kernel address space.
+ */
+void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
+			unsigned long cacheflag)
+{
+	struct vm_struct *area;
+	unsigned long offset;
+	unsigned long last_addr;
+	void *addr;
+
+	/* Don't allow wraparound or zero size */
+	last_addr = phys_addr + size - 1;
+
+	if (!size || last_addr < phys_addr)
+		return NULL;
+
+	/* Don't allow anybody to remap normal RAM that we're using */
+	if (phys_addr > PHYS_OFFSET && phys_addr < virt_to_phys(high_memory)) {
+		char *t_addr, *t_end;
+		struct page *page;
+
+		t_addr = __va(phys_addr);
+		t_end = t_addr + (size - 1);
+		for (page = virt_to_page(t_addr);
+			page <= virt_to_page(t_end); page++)
+			if (!PageReserved(page))
+				return NULL;
+	}
+
+	/*
+	 * Map uncached objects in the low part of address space to
+	 * CONFIG_NIOS2_IO_REGION_BASE
+	 */
+	if (IS_MAPPABLE_UNCACHEABLE(phys_addr) &&
+	    IS_MAPPABLE_UNCACHEABLE(last_addr) &&
+	    !(cacheflag & _PAGE_CACHED))
+		return (void __iomem *)(CONFIG_NIOS2_IO_REGION_BASE + phys_addr);
+
+	/* Mappings have to be page-aligned */
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
+
+	/* Ok, go for it */
+	area = get_vm_area(size, VM_IOREMAP);
+	if (!area)
+		return NULL;
+	addr = area->addr;
+	if (remap_area_pages((unsigned long) addr, phys_addr, size,
+		cacheflag)) {
+		vunmap(addr);
+		return NULL;
+	}
+	return (void __iomem *) (offset + (char *)addr);
+}
+EXPORT_SYMBOL(__ioremap);
+
+/*
+ * __iounmap unmaps nearly everything, so be careful
+ * it doesn't free currently pointer/page tables anymore but it
+ * wasn't used anyway and might be added later.
+ */
+void __iounmap(void __iomem *addr)
+{
+	struct vm_struct *p;
+
+	if ((unsigned long) addr > CONFIG_NIOS2_IO_REGION_BASE)
+		return;
+
+	p = remove_vm_area((void *) (PAGE_MASK & (unsigned long __force) addr));
+	if (!p)
+		pr_err("iounmap: bad address %p\n", addr);
+	kfree(p);
+}
+EXPORT_SYMBOL(__iounmap);
-- 
1.8.2.1

