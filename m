Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3K1Cpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:45:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758619Ab3K1Cp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:45:27 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Landley <rob@landley.net>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH 4/4] arm64: add early_ioremap support
Date: Wed, 27 Nov 2013 21:44:39 -0500
Message-Id: <1385606679-30446-5-git-send-email-msalter@redhat.com>
In-Reply-To: <1385606679-30446-1-git-send-email-msalter@redhat.com>
References: <1385606679-30446-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Rob Landley <rob@landley.net>
CC: linux-arm-kernel@lists.infradead.org
CC: linux-doc@vger.kernel.org
---
 Documentation/arm64/memory.txt   |  4 +--
 arch/arm64/Kconfig               |  1 +
 arch/arm64/include/asm/Kbuild    |  1 +
 arch/arm64/include/asm/fixmap.h  | 68 +++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/io.h      |  1 +
 arch/arm64/include/asm/memory.h  |  1 +
 arch/arm64/kernel/early_printk.c |  8 +++--
 arch/arm64/kernel/head.S         |  9 ++---
 arch/arm64/kernel/setup.c        |  2 ++
 arch/arm64/mm/ioremap.c          | 77 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/mmu.c              | 41 ---------------------
 11 files changed, 162 insertions(+), 51 deletions(-)
 create mode 100644 arch/arm64/include/asm/fixmap.h

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index 5e054bf..953c81e 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -35,7 +35,7 @@ ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
 
 ffffffbe00000000	ffffffbffbbfffff	  ~8GB		[guard, future vmmemap]
 
-ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
+ffffffbffbc00000	ffffffbffbdfffff	   2MB		fixed mappings
 
 ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O space
 
@@ -60,7 +60,7 @@ fffffdfc00000000	fffffdfdffffffff	   8GB		vmemmap
 
 fffffdfe00000000	fffffdfffbbfffff	  ~8GB		[guard, future vmmemap]
 
-fffffdfffbc00000	fffffdfffbdfffff	   2MB		earlyprintk device
+fffffdfffbc00000	fffffdfffbdfffff	   2MB		fixed mappings
 
 fffffdfffbe00000	fffffdfffbe0ffff	  64KB		PCI I/O space
 
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 88c8b6c1..809c1b8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -12,6 +12,7 @@ config ARM64
 	select CLONE_BACKWARDS
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_EARLY_IOREMAP
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 519f89f..b7f99a3 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -10,6 +10,7 @@ generic-y += delay.h
 generic-y += div64.h
 generic-y += dma.h
 generic-y += emergency-restart.h
+generic-y += early_ioremap.h
 generic-y += errno.h
 generic-y += ftrace.h
 generic-y += hw_irq.h
diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
new file mode 100644
index 0000000..a4b193d
--- /dev/null
+++ b/arch/arm64/include/asm/fixmap.h
@@ -0,0 +1,68 @@
+/*
+ * fixmap.h: compile-time virtual memory allocation
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1998 Ingo Molnar
+ * Copyright (C) 2013 Mark Salter <msalter@redhat.com>
+ *
+ * Adapted from arch/x86_64 version.
+ *
+ */
+
+#ifndef _ASM_ARM64_FIXMAP_H
+#define _ASM_ARM64_FIXMAP_H
+
+#ifndef __ASSEMBLY__
+#include <linux/kernel.h>
+#include <asm/page.h>
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process.
+ *
+ * These 'compile-time allocated' memory buffers are
+ * page-sized. Use set_fixmap(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ */
+enum fixed_addresses {
+	FIX_EARLYCON,
+	__end_of_permanent_fixed_addresses,
+
+	/*
+	 * Temporary boot-time mappings, used by early_ioremap(),
+	 * before ioremap() is functional.
+	 */
+#ifdef CONFIG_ARM64_64K_PAGES
+#define NR_FIX_BTMAPS		4
+#else
+#define NR_FIX_BTMAPS		64
+#endif
+#define FIX_BTMAPS_SLOTS	7
+#define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
+
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
+	__end_of_fixed_addresses
+};
+
+#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
+
+#define FIXMAP_PAGE_NORMAL __pgprot(PROT_NORMAL | PTE_PXN | PTE_UXN)
+#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
+
+extern void __early_set_fixmap(enum fixed_addresses idx,
+			       phys_addr_t phys, pgprot_t flags);
+
+#define __set_fixmap __early_set_fixmap
+
+#include <asm-generic/fixmap.h>
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_ARM64_FIXMAP_H */
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 4cc813e..8fb2152 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -27,6 +27,7 @@
 #include <asm/byteorder.h>
 #include <asm/barrier.h>
 #include <asm/pgtable.h>
+#include <asm/early_ioremap.h>
 
 #include <xen/xen.h>
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 3776217..4a6d7ec 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -50,6 +50,7 @@
 #define MODULES_END		(PAGE_OFFSET)
 #define MODULES_VADDR		(MODULES_END - SZ_64M)
 #define EARLYCON_IOBASE		(MODULES_VADDR - SZ_4M)
+#define FIXADDR_TOP		(MODULES_VADDR - SZ_2M - PAGE_SIZE)
 #define TASK_SIZE_64		(UL(1) << VA_BITS)
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/arm64/kernel/early_printk.c b/arch/arm64/kernel/early_printk.c
index fbb6e18..850d9a4 100644
--- a/arch/arm64/kernel/early_printk.c
+++ b/arch/arm64/kernel/early_printk.c
@@ -26,6 +26,8 @@
 #include <linux/amba/serial.h>
 #include <linux/serial_reg.h>
 
+#include <asm/fixmap.h>
+
 static void __iomem *early_base;
 static void (*printch)(char ch);
 
@@ -141,8 +143,10 @@ static int __init setup_early_printk(char *buf)
 	}
 	/* no options parsing yet */
 
-	if (paddr)
-		early_base = early_io_map(paddr, EARLYCON_IOBASE);
+	if (paddr) {
+		set_fixmap_io(FIX_EARLYCON, paddr);
+		early_base = (void __iomem *)fix_to_virt(FIX_EARLYCON);
+	}
 
 	printch = match->printch;
 	early_console = &early_console_dev;
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 7009387..03adf8f 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -411,7 +411,7 @@ ENDPROC(__calc_phys_offset)
  *   - identity mapping to enable the MMU (low address, TTBR0)
  *   - first few MB of the kernel linear mapping to jump to once the MMU has
  *     been enabled, including the FDT blob (TTBR1)
- *   - UART mapping if CONFIG_EARLY_PRINTK is enabled (TTBR1)
+ *   - pgd entry for fixed mappings (TTBR1)
  */
 __create_page_tables:
 	pgtbl	x25, x26, x24			// idmap_pg_dir and swapper_pg_dir addresses
@@ -464,15 +464,12 @@ __create_page_tables:
 	sub	x6, x6, #1			// inclusive range
 	create_block_map x0, x7, x3, x5, x6
 1:
-#ifdef CONFIG_EARLY_PRINTK
 	/*
-	 * Create the pgd entry for the UART mapping. The full mapping is done
-	 * later based earlyprintk kernel parameter.
+	 * Create the pgd entry for the fixed mappings.
 	 */
-	ldr	x5, =EARLYCON_IOBASE		// UART virtual address
+	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
 	add	x0, x26, #2 * PAGE_SIZE		// section table address
 	create_pgd_entry x26, x0, x5, x6, x7
-#endif
 	ret
 ENDPROC(__create_page_tables)
 	.ltorg
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 0bc5e4c..790871a 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 
+#include <asm/fixmap.h>
 #include <asm/cputype.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
@@ -216,6 +217,7 @@ void __init setup_arch(char **cmdline_p)
 
 	*cmdline_p = boot_command_line;
 
+	early_ioremap_init();
 	parse_early_param();
 
 	arm64_memblock_init();
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 2bb1d58..fb338ab 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -25,6 +25,10 @@
 #include <linux/vmalloc.h>
 #include <linux/io.h>
 
+#include <asm/fixmap.h>
+#include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
+
 static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
 				      pgprot_t prot, void *caller)
 {
@@ -98,3 +102,76 @@ void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_cache);
+
+#ifndef CONFIG_ARM64_64K_PAGES
+static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
+#endif
+
+static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	pud_t *pud = pud_offset(pgd, addr);
+	pmd_t *pmd = pmd_offset(pud, addr);
+
+	return pmd;
+}
+
+static inline pte_t * __init early_ioremap_pte(unsigned long addr)
+{
+	pmd_t *pmd = early_ioremap_pmd(addr);
+	return pte_offset_kernel(pmd, addr);
+}
+
+void __init early_ioremap_init(void)
+{
+	pmd_t *pmd;
+
+	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
+#ifndef CONFIG_ARM64_64K_PAGES
+	/* need to populate pmd for 4k pagesize only */
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
+#endif
+	/*
+	 * The boot-ioremap range spans multiple pmds, for which
+	 * we are not prepared:
+	 */
+	BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
+		     != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
+
+	if (pmd != early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END))) {
+		WARN_ON(1);
+		pr_warn("pmd %p != %p\n",
+			pmd, early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END)));
+		pr_warn("fix_to_virt(FIX_BTMAP_BEGIN): %08lx\n",
+			fix_to_virt(FIX_BTMAP_BEGIN));
+		pr_warn("fix_to_virt(FIX_BTMAP_END):   %08lx\n",
+			fix_to_virt(FIX_BTMAP_END));
+
+		pr_warn("FIX_BTMAP_END:       %d\n", FIX_BTMAP_END);
+		pr_warn("FIX_BTMAP_BEGIN:     %d\n",
+			FIX_BTMAP_BEGIN);
+	}
+
+	early_ioremap_setup();
+}
+
+void __init __early_set_fixmap(enum fixed_addresses idx,
+			       phys_addr_t phys, pgprot_t flags)
+{
+	unsigned long addr = __fix_to_virt(idx);
+	pte_t *pte;
+
+	if (idx >= __end_of_fixed_addresses) {
+		BUG();
+		return;
+	}
+
+	pte = early_ioremap_pte(addr);
+
+	if (pgprot_val(flags))
+		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
+	else {
+		pte_clear(&init_mm, addr, pte);
+		flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
+	}
+}
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f557ebb..9849f7f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -252,47 +252,6 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
 	} while (pgd++, addr = next, addr != end);
 }
 
-#ifdef CONFIG_EARLY_PRINTK
-/*
- * Create an early I/O mapping using the pgd/pmd entries already populated
- * in head.S as this function is called too early to allocated any memory. The
- * mapping size is 2MB with 4KB pages or 64KB or 64KB pages.
- */
-void __iomem * __init early_io_map(phys_addr_t phys, unsigned long virt)
-{
-	unsigned long size, mask;
-	bool page64k = IS_ENABLED(CONFIG_ARM64_64K_PAGES);
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	/*
-	 * No early pte entries with !ARM64_64K_PAGES configuration, so using
-	 * sections (pmd).
-	 */
-	size = page64k ? PAGE_SIZE : SECTION_SIZE;
-	mask = ~(size - 1);
-
-	pgd = pgd_offset_k(virt);
-	pud = pud_offset(pgd, virt);
-	if (pud_none(*pud))
-		return NULL;
-	pmd = pmd_offset(pud, virt);
-
-	if (page64k) {
-		if (pmd_none(*pmd))
-			return NULL;
-		pte = pte_offset_kernel(pmd, virt);
-		set_pte(pte, __pte((phys & mask) | PROT_DEVICE_nGnRE));
-	} else {
-		set_pmd(pmd, __pmd((phys & mask) | PROT_SECT_DEVICE_nGnRE));
-	}
-
-	return (void __iomem *)((virt & mask) + (phys & ~mask));
-}
-#endif
-
 static void __init map_mem(void)
 {
 	struct memblock_region *reg;
-- 
1.8.3.1

