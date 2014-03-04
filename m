Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaCDUKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbaCDUJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:09:47 -0500
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: [PATCH 5/5] arm64: add early_ioremap support
Date: Tue,  4 Mar 2014 15:08:58 -0500
Message-Id: <1393963738-9210-6-git-send-email-msalter@redhat.com>
In-Reply-To: <1393963738-9210-1-git-send-email-msalter@redhat.com>
References: <1393963738-9210-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for early IO or memory mappings which are needed
before the normal ioremap() is usable. This also adds fixmap
support for permanent fixed mappings such as that used by the
earlyprintk device register region.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/arm64/memory.txt   |  4 +-
 arch/arm64/Kconfig               |  1 +
 arch/arm64/include/asm/Kbuild    |  1 +
 arch/arm64/include/asm/fixmap.h  | 67 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/io.h      |  1 +
 arch/arm64/include/asm/memory.h  |  2 +-
 arch/arm64/kernel/early_printk.c |  8 +++-
 arch/arm64/kernel/head.S         |  9 ++---
 arch/arm64/kernel/setup.c        |  2 +
 arch/arm64/mm/ioremap.c          | 85 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/mmu.c              | 41 -------------------
 11 files changed, 169 insertions(+), 52 deletions(-)
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
index 27bbcfc..da4304a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -16,6 +16,7 @@ config ARM64
 	select DCACHE_WORD_ACCESS
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
+	select GENERIC_EARLY_IOREMAP
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 71c53ec..27e3c6b 100644
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
index 0000000..9c1fb65
--- /dev/null
+++ b/arch/arm64/include/asm/fixmap.h
@@ -0,0 +1,67 @@
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
index 9dc5dc3..e94f945 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -49,7 +49,7 @@
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
 #define MODULES_END		(PAGE_OFFSET)
 #define MODULES_VADDR		(MODULES_END - SZ_64M)
-#define EARLYCON_IOBASE		(MODULES_VADDR - SZ_4M)
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
index 0b281ff..c86bfdf 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -412,7 +412,7 @@ ENDPROC(__calc_phys_offset)
  *   - identity mapping to enable the MMU (low address, TTBR0)
  *   - first few MB of the kernel linear mapping to jump to once the MMU has
  *     been enabled, including the FDT blob (TTBR1)
- *   - UART mapping if CONFIG_EARLY_PRINTK is enabled (TTBR1)
+ *   - pgd entry for fixed mappings (TTBR1)
  */
 __create_page_tables:
 	pgtbl	x25, x26, x24			// idmap_pg_dir and swapper_pg_dir addresses
@@ -465,15 +465,12 @@ __create_page_tables:
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
index 1c66cfb..4d2ac74 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 
+#include <asm/fixmap.h>
 #include <asm/cputype.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
@@ -328,6 +329,7 @@ void __init setup_arch(char **cmdline_p)
 	*cmdline_p = boot_command_line;
 
 	init_mem_pgprot();
+	early_ioremap_init();
 
 	parse_early_param();
 
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 2bb1d58..7ec3283 100644
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
@@ -98,3 +102,84 @@ void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
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
+	pgd_t *pgd;
+	pud_t *pud;
+
+	pgd = pgd_offset_k(addr);
+	BUG_ON(pgd_none(*pgd) || pgd_bad(*pgd));
+
+	pud = pud_offset(pgd, addr);
+	BUG_ON(pud_none(*pud) || pud_bad(*pud));
+
+	return pmd_offset(pud, addr);
+}
+
+static inline pte_t * __init early_ioremap_pte(unsigned long addr)
+{
+	pmd_t *pmd = early_ioremap_pmd(addr);
+
+	BUG_ON(pmd_none(*pmd) || pmd_bad(*pmd));
+
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
index ba259a0..6b7e895 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -260,47 +260,6 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
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
1.8.5.3

