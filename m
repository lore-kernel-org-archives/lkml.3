Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaJXIgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:36:25 -0400
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:60889
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755743AbaJXIZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:21 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 09/29] nios2: Page table management
Date: Fri, 24 Oct 2014 16:24:11 +0800
Message-ID: <1414139071-3818-10-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(50466002)(48376002)(76176999)(50986999)(92726001)(86362001)(93916002)(2201001)(92566001)(97736003)(120916001)(99396003)(106466001)(102836001)(62966002)(77156001)(36756003)(50226001)(42186005)(85306004)(21056001)(4396001)(77096002)(104166001)(31966008)(87936001)(87286001)(88136002)(85852003)(89996001)(107046002)(64706001)(20776003)(46102003)(95666004)(229853001)(105596002)(47776003)(19580395003)(84676001)(44976005)(6806004)(68736004)(33646002)(19580405001)(76482002)(80022003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB222;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB222;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for page table management.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/pgalloc.h      |  86 ++++++++++
 arch/nios2/include/asm/pgtable-bits.h |  35 ++++
 arch/nios2/include/asm/pgtable.h      | 305 ++++++++++++++++++++++++++++++++++
 arch/nios2/mm/pgtable.c               |  73 ++++++++
 4 files changed, 499 insertions(+)
 create mode 100644 arch/nios2/include/asm/pgalloc.h
 create mode 100644 arch/nios2/include/asm/pgtable-bits.h
 create mode 100644 arch/nios2/include/asm/pgtable.h
 create mode 100644 arch/nios2/mm/pgtable.c

diff --git a/arch/nios2/include/asm/pgalloc.h b/arch/nios2/include/asm/pgalloc.h
new file mode 100644
index 0000000..6e2985e
--- /dev/null
+++ b/arch/nios2/include/asm/pgalloc.h
@@ -0,0 +1,86 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1994 - 2001, 2003 by Ralf Baechle
+ * Copyright (C) 1999, 2000, 2001 Silicon Graphics, Inc.
+ */
+
+#ifndef _ASM_NIOS2_PGALLOC_H
+#define _ASM_NIOS2_PGALLOC_H
+
+#include <linux/mm.h>
+
+static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
+	pte_t *pte)
+{
+	set_pmd(pmd, __pmd((unsigned long)pte));
+}
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+	pgtable_t pte)
+{
+	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
+}
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+/*
+ * Initialize a new pmd table with invalid pointers.
+ */
+extern void pmd_init(unsigned long page, unsigned long pagetable);
+
+extern pgd_t *pgd_alloc(struct mm_struct *mm);
+
+static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	free_pages((unsigned long)pgd, PGD_ORDER);
+}
+
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+	unsigned long address)
+{
+	pte_t *pte;
+
+	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO,
+					PTE_ORDER);
+
+	return pte;
+}
+
+static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
+	unsigned long address)
+{
+	struct page *pte;
+
+	pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
+	if (pte) {
+		if (!pgtable_page_ctor(pte)) {
+			__free_page(pte);
+			return NULL;
+		}
+		clear_highpage(pte);
+	}
+	return pte;
+}
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	free_pages((unsigned long)pte, PTE_ORDER);
+}
+
+static inline void pte_free(struct mm_struct *mm, struct page *pte)
+{
+	pgtable_page_dtor(pte);
+	__free_pages(pte, PTE_ORDER);
+}
+
+#define __pte_free_tlb(tlb, pte, addr)				\
+	do {							\
+		pgtable_page_dtor(pte);				\
+		tlb_remove_page((tlb), (pte));			\
+	} while (0)
+
+#define check_pgt_cache()	do { } while (0)
+
+#endif /* _ASM_NIOS2_PGALLOC_H */
diff --git a/arch/nios2/include/asm/pgtable-bits.h b/arch/nios2/include/asm/pgtable-bits.h
new file mode 100644
index 0000000..ce9e706
--- /dev/null
+++ b/arch/nios2/include/asm/pgtable-bits.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_PGTABLE_BITS_H
+#define _ASM_NIOS2_PGTABLE_BITS_H
+
+/*
+ * These are actual hardware defined protection bits in the tlbacc register
+ * which looks like this:
+ *
+ * 31 30 ... 26 25 24 23 22 21 20 19 18 ...  1  0
+ * ignored........  C  R  W  X  G PFN............
+ */
+#define _PAGE_GLOBAL	(1<<20)
+#define _PAGE_EXEC	(1<<21)
+#define _PAGE_WRITE	(1<<22)
+#define _PAGE_READ	(1<<23)
+#define _PAGE_CACHED	(1<<24)	/* C: data access cacheable */
+
+/*
+ * Software defined bits. They are ignored by the hardware and always read back
+ * as zero, but can be written as non-zero.
+ */
+#define _PAGE_PRESENT	(1<<25)	/* PTE contains a translation */
+#define _PAGE_ACCESSED	(1<<26)	/* page referenced */
+#define _PAGE_DIRTY	(1<<27)	/* dirty page */
+#define _PAGE_FILE	(1<<28)	/* PTE used for file mapping or swap */
+
+#endif /* _ASM_NIOS2_PGTABLE_BITS_H */
diff --git a/arch/nios2/include/asm/pgtable.h b/arch/nios2/include/asm/pgtable.h
new file mode 100644
index 0000000..ec85481
--- /dev/null
+++ b/arch/nios2/include/asm/pgtable.h
@@ -0,0 +1,305 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ *
+ * Based on asm/pgtable-32.h from mips which is:
+ *
+ * Copyright (C) 1994, 95, 96, 97, 98, 99, 2000, 2003 Ralf Baechle
+ * Copyright (C) 1999, 2000, 2001 Silicon Graphics, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_PGTABLE_H
+#define _ASM_NIOS2_PGTABLE_H
+
+#include <linux/io.h>
+#include <linux/bug.h>
+#include <asm/page.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+
+#include <asm/pgtable-bits.h>
+#include <asm-generic/pgtable-nopmd.h>
+
+#define FIRST_USER_ADDRESS	0
+
+#define VMALLOC_START		CONFIG_NIOS2_KERNEL_MMU_REGION_BASE
+#define VMALLOC_END		(CONFIG_NIOS2_KERNEL_REGION_BASE - 1)
+
+struct mm_struct;
+
+/* Helper macro */
+#define MKP(x, w, r) __pgprot(_PAGE_PRESENT | _PAGE_CACHED |		\
+				((x) ? _PAGE_EXEC : 0) |		\
+				((r) ? _PAGE_READ : 0) |		\
+				((w) ? _PAGE_WRITE : 0))
+/*
+ * These are the macros that generic kernel code needs
+ * (to populate protection_map[])
+ */
+
+/* Remove W bit on private pages for COW support */
+#define __P000	MKP(0, 0, 0)
+#define __P001	MKP(0, 0, 1)
+#define __P010	MKP(0, 0, 0)	/* COW */
+#define __P011	MKP(0, 0, 1)	/* COW */
+#define __P100	MKP(1, 0, 0)
+#define __P101	MKP(1, 0, 1)
+#define __P110	MKP(1, 0, 0)	/* COW */
+#define __P111	MKP(1, 0, 1)	/* COW */
+
+/* Shared pages can have exact HW mapping */
+#define __S000	MKP(0, 0, 0)
+#define __S001	MKP(0, 0, 1)
+#define __S010	MKP(0, 1, 0)
+#define __S011	MKP(0, 1, 1)
+#define __S100	MKP(1, 0, 0)
+#define __S101	MKP(1, 0, 1)
+#define __S110	MKP(1, 1, 0)
+#define __S111	MKP(1, 1, 1)
+
+/* Used all over the kernel */
+#define PAGE_KERNEL __pgprot(_PAGE_PRESENT | _PAGE_CACHED | _PAGE_READ | \
+			     _PAGE_WRITE | _PAGE_EXEC | _PAGE_GLOBAL)
+
+#define PAGE_COPY MKP(0, 0, 1)
+
+#define PGD_ORDER	0
+#define PTE_ORDER	0
+
+#define PTRS_PER_PGD	((PAGE_SIZE << PGD_ORDER) / sizeof(pgd_t))
+#define PTRS_PER_PTE	((PAGE_SIZE << PTE_ORDER) / sizeof(pte_t))
+
+#define USER_PTRS_PER_PGD	\
+	(CONFIG_NIOS2_KERNEL_MMU_REGION_BASE / PGDIR_SIZE)
+
+#define PGDIR_SHIFT	22
+#define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
+#define PGDIR_MASK	(~(PGDIR_SIZE-1))
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
+#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
+
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
+extern pte_t invalid_pte_table[PAGE_SIZE/sizeof(pte_t)];
+
+/*
+ * (pmds are folded into puds so this doesn't get actually called,
+ * but the define is needed for a generic inline function.)
+ */
+static inline void set_pmd(pmd_t *pmdptr, pmd_t pmdval)
+{
+	pmdptr->pud.pgd.pgd = pmdval.pud.pgd.pgd;
+}
+
+/* to find an entry in a page-table-directory */
+#define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+#define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
+
+static inline int pte_write(pte_t pte)		\
+	{ return pte_val(pte) & _PAGE_WRITE; }
+static inline int pte_dirty(pte_t pte)		\
+	{ return pte_val(pte) & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)		\
+	{ return pte_val(pte) & _PAGE_ACCESSED; }
+static inline int pte_file(pte_t pte)		\
+	{ return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte)	{ return 0; }
+
+#define pgprot_noncached pgprot_noncached
+
+static inline pgprot_t pgprot_noncached(pgprot_t _prot)
+{
+	unsigned long prot = pgprot_val(_prot);
+
+	prot &= ~_PAGE_CACHED;
+
+	return __pgprot(prot);
+}
+
+static inline int pte_none(pte_t pte)
+{
+	return !(pte_val(pte) & ~(_PAGE_GLOBAL|0xf));
+}
+
+static inline int pte_present(pte_t pte)	\
+	{ return pte_val(pte) & _PAGE_PRESENT; }
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_WRITE;
+	return pte;
+}
+
+static inline pte_t pte_mkclean(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_DIRTY;
+	return pte;
+}
+
+static inline pte_t pte_mkold(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_ACCESSED;
+	return pte;
+}
+
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_WRITE;
+	return pte;
+}
+
+static inline pte_t pte_mkdirty(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_DIRTY;
+	return pte;
+}
+
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
+
+static inline pte_t pte_mkyoung(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_ACCESSED;
+	return pte;
+}
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	const unsigned long mask = _PAGE_READ | _PAGE_WRITE | _PAGE_EXEC;
+	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
+	return pte;
+}
+
+static inline int pmd_present(pmd_t pmd)
+{
+	return (pmd_val(pmd) != (unsigned long) invalid_pte_table)
+			&& (pmd_val(pmd) != 0UL);
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	pmd_val(*pmdp) = (unsigned long) invalid_pte_table;
+}
+
+#define pte_pfn(pte)		(pte_val(pte) & 0xfffff)
+#define pfn_pte(pfn, prot)	(__pte(pfn | pgprot_val(prot)))
+#define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
+
+/*
+ * Store a linux PTE into the linux page table.
+ */
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+	*ptep = pteval;
+}
+
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval)
+{
+	unsigned long paddr = page_to_virt(pte_page(pteval));
+	flush_dcache_range(paddr, paddr + PAGE_SIZE);
+	set_pte(ptep, pteval);
+}
+
+static inline int pmd_none(pmd_t pmd)
+{
+	return (pmd_val(pmd) ==
+		(unsigned long) invalid_pte_table) || (pmd_val(pmd) == 0UL);
+}
+
+#define pmd_bad(pmd)	(pmd_val(pmd) & ~PAGE_MASK)
+
+static inline void pte_clear(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep)
+{
+	pte_t null;
+
+	pte_val(null) = (addr >> PAGE_SHIFT) & 0xf;
+
+	set_pte_at(mm, addr, ptep, null);
+	flush_tlb_one(addr);
+}
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+#define mk_pte(page, prot)	(pfn_pte(page_to_pfn(page), prot))
+
+#define pte_unmap(pte)	do { } while (0)
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+#define pmd_phys(pmd)		virt_to_phys((void *)pmd_val(pmd))
+#define pmd_page(pmd)		(pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
+#define pmd_page_vaddr(pmd)	pmd_val(pmd)
+
+#define pte_offset_map(dir, addr)			\
+	((pte_t *) page_address(pmd_page(*dir)) +	\
+	 (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
+
+/* to find an entry in a kernel page-table-directory */
+#define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
+
+/* Get the address to the PTE for a vaddr in specfic directory */
+#define pte_offset_kernel(dir, addr)			\
+	((pte_t *) pmd_page_vaddr(*(dir)) +		\
+	 (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
+
+#define pte_ERROR(e) \
+	pr_err("%s:%d: bad pte %08lx.\n", \
+		__FILE__, __LINE__, pte_val(e))
+#define pgd_ERROR(e) \
+	pr_err("%s:%d: bad pgd %08lx.\n", \
+		__FILE__, __LINE__, pgd_val(e))
+
+/*
+ * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte)
+ * && !pte_file(pte)):
+ *
+ * 31 30 29 28 27 26 25 24 23 22 21 20 19 18 ...  1  0
+ *  0  0  0  0 type.  0  0  0  0  0  0 offset.........
+ *
+ * This gives us up to 2**2 = 4 swap files and 2**20 * 4K = 4G per swap file.
+ *
+ * Note that the offset field is always non-zero, thus !pte_none(pte) is always
+ * true.
+ */
+#define __swp_type(swp)		(((swp).val >> 26) & 0x3)
+#define __swp_offset(swp)	((swp).val & 0xfffff)
+#define __swp_entry(type, off)	((swp_entry_t) { (((type) & 0x3) << 26) \
+						 | ((off) & 0xfffff) })
+#define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
+#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
+
+/* Encode and decode a nonlinear file mapping entry */
+#define PTE_FILE_MAX_BITS	25
+#define pte_to_pgoff(pte)	(pte_val(pte) & 0x1ffffff)
+#define pgoff_to_pte(off)	__pte(((off) & 0x1ffffff) | _PAGE_FILE)
+
+#define kern_addr_valid(addr)		(1)
+
+#include <asm-generic/pgtable.h>
+
+#define pgtable_cache_init()		do { } while (0)
+
+extern void __init paging_init(void);
+extern void __init mmu_init(void);
+
+extern void update_mmu_cache(struct vm_area_struct *vma,
+			     unsigned long address, pte_t *pte);
+
+#endif /* _ASM_NIOS2_PGTABLE_H */
diff --git a/arch/nios2/mm/pgtable.c b/arch/nios2/mm/pgtable.c
new file mode 100644
index 0000000..21e865f
--- /dev/null
+++ b/arch/nios2/mm/pgtable.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright (C) 2009 Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/mm.h>
+#include <linux/sched.h>
+
+#include <asm/pgtable.h>
+#include <asm/cpuinfo.h>
+
+/* pteaddr:
+ *   ptbase | vpn* | zero
+ *   31-22  | 21-2 | 1-0
+ *
+ *   *vpn is preserved on double fault
+ *
+ * tlbacc:
+ *   IG   |*flags| pfn
+ *   31-25|24-20 | 19-0
+ *
+ *   *crwxg
+ *
+ * tlbmisc:
+ *   resv  |way   |rd | we|pid |dbl|bad|perm|d
+ *   31-24 |23-20 |19 | 20|17-4|3  |2  |1   |0
+ *
+ */
+
+/*
+ * Initialize a new pgd / pmd table with invalid pointers.
+ */
+static void pgd_init(pgd_t *pgd)
+{
+	unsigned long *p = (unsigned long *) pgd;
+	int i;
+
+	for (i = 0; i < USER_PTRS_PER_PGD; i += 8) {
+		p[i + 0] = (unsigned long) invalid_pte_table;
+		p[i + 1] = (unsigned long) invalid_pte_table;
+		p[i + 2] = (unsigned long) invalid_pte_table;
+		p[i + 3] = (unsigned long) invalid_pte_table;
+		p[i + 4] = (unsigned long) invalid_pte_table;
+		p[i + 5] = (unsigned long) invalid_pte_table;
+		p[i + 6] = (unsigned long) invalid_pte_table;
+		p[i + 7] = (unsigned long) invalid_pte_table;
+	}
+}
+
+pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *ret, *init;
+	ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+	if (ret) {
+		init = pgd_offset(&init_mm, 0UL);
+		pgd_init(ret);
+		memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
+		       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+	}
+
+	return ret;
+}
+
+void __init pagetable_init(void)
+{
+	/* Initialize the entire pgd.  */
+	pgd_init(swapper_pg_dir);
+	pgd_init(swapper_pg_dir + USER_PTRS_PER_PGD);
+}
-- 
1.8.2.1

