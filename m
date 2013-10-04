Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3JDMrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:47:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab3JDMrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:47:40 -0400
From: Mark Salter <msalter@redhat.com>
To: catalin.marinas@arm.com
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: add early_ioremap support
Date: Fri,  4 Oct 2013 08:46:59 -0400
Message-Id: <1380890819-27831-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI runtime support needs to make temporary short term mappings at early
boot time before ioremap is available. This patch adds support for such
early mappings based on "fixmap" support found in a number of other
architectures. This also allows for a number of permanent mappings which
may need to persist beyond paging_init(). This implementation uses the
2MiB of address space currently dedicated to the earlyprintk console
registers. This allows for mapping up to 32 64K pages or 512 4K pages.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 Documentation/arm64/memory.txt   |   2 +-
 arch/arm64/include/asm/fixmap.h  | 117 ++++++++++++++++
 arch/arm64/include/asm/io.h      |   6 +
 arch/arm64/include/asm/memory.h  |   2 +-
 arch/arm64/kernel/early_printk.c |   8 +-
 arch/arm64/kernel/head.S         |   9 +-
 arch/arm64/kernel/setup.c        |   3 +
 arch/arm64/mm/ioremap.c          | 285 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/mmu.c              |  41 ------
 9 files changed, 422 insertions(+), 51 deletions(-)
 create mode 100644 arch/arm64/include/asm/fixmap.h

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index 78a37712..f2bf9e1 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -35,7 +35,7 @@ ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
 
 ffffffbe00000000	ffffffbffbbfffff	  ~8GB		[guard, future vmmemap]
 
-ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
+ffffffbffbc00000	ffffffbffbdfffff	   2MB		fixed mappings
 
 ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O space
 
diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
new file mode 100644
index 0000000..e73b219
--- /dev/null
+++ b/arch/arm64/include/asm/fixmap.h
@@ -0,0 +1,117 @@
+/*
+ * fixmap.h: compile-time virtual memory allocation
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1998 Ingo Molnar
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
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
+	__end_of_fixed_addresses
+};
+
+#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
+#define FIXADDR_BOOT_START	(FIXADDR_TOP - FIXADDR_BOOT_SIZE)
+
+extern void __set_fixmap(enum fixed_addresses idx,
+			 phys_addr_t phys, pgprot_t flags);
+
+#define set_fixmap(idx, phys)				\
+	__set_fixmap(idx, phys, PAGE_KERNEL)
+
+#define set_fixmap_io(idx, phys)				\
+	__set_fixmap(idx, phys, __pgprot(PROT_DEVICE_nGnRE))
+
+#define clear_fixmap(idx)			\
+	__set_fixmap(idx, 0, __pgprot(0))
+
+#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
+
+extern void __this_fixmap_does_not_exist(void);
+
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without translation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static __always_inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	/*
+	 * this branch gets completely eliminated after inlining,
+	 * except when someone tries to use fixaddr indices in an
+	 * illegal way. (such as mixing up address types or using
+	 * out-of-range indices).
+	 *
+	 * If it doesn't get removed, the linker will complain
+	 * loudly with a reasonably clear error message..
+	 */
+	if (idx >= __end_of_fixed_addresses)
+		__this_fixmap_does_not_exist();
+
+	return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
+	return __virt_to_fix(vaddr);
+}
+
+/* Return an pointer with offset calculated */
+static __always_inline unsigned long
+__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
+{
+	__set_fixmap(idx, phys, flags);
+	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
+}
+
+#define set_fixmap_offset(idx, phys)			\
+	__set_fixmap_offset(idx, phys, PAGE_KERNEL)
+
+#define set_fixmap_offset_nocache(idx, phys)			\
+	__set_fixmap_offset(idx, phys, PAGE_KERNEL_NOCACHE)
+
+extern void early_ioremap_init(void);
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_ARM64_FIXMAP_H */
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 1d12f89..c9bac21 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -236,6 +236,12 @@ extern void __iounmap(volatile void __iomem *addr);
 #define ioremap_cached(addr, size)	__ioremap((addr), (size), __pgprot(PROT_NORMAL))
 #define iounmap				__iounmap
 
+extern void __iomem *early_ioremap(resource_size_t phys_addr,
+				   unsigned long size);
+extern void __iomem *early_memremap(resource_size_t phys_addr,
+				    unsigned long size);
+extern void early_iounmap(void __iomem *addr, unsigned long size);
+
 #define PROT_SECT_DEFAULT	(PMD_TYPE_SECT | PMD_SECT_AF)
 #define PROT_SECT_DEVICE_nGnRE	(PROT_SECT_DEFAULT | PTE_PXN | PTE_UXN | PMD_ATTRINDX(MT_DEVICE_nGnRE))
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 20925bc..58e68c7 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -43,7 +43,7 @@
 #define PAGE_OFFSET		UL(0xffffffc000000000)
 #define MODULES_END		(PAGE_OFFSET)
 #define MODULES_VADDR		(MODULES_END - SZ_64M)
-#define EARLYCON_IOBASE		(MODULES_VADDR - SZ_4M)
+#define FIXADDR_TOP		(MODULES_VADDR - SZ_2M - SZ_64K)
 #define VA_BITS			(39)
 #define TASK_SIZE_64		(UL(1) << VA_BITS)
 
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
index f436cfb..2b5fc13 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -484,7 +484,7 @@ ENDPROC(__calc_phys_offset)
  *   - identity mapping to enable the MMU (low address, TTBR0)
  *   - first few MB of the kernel linear mapping to jump to once the MMU has
  *     been enabled, including the FDT blob (TTBR1)
- *   - UART mapping if CONFIG_EARLY_PRINTK is enabled (TTBR1)
+ *   - pgd entry for fixed mappings
  */
 __create_page_tables:
 	pgtbl	x25, x26, x24			// idmap_pg_dir and swapper_pg_dir addresses
@@ -537,15 +537,12 @@ __create_page_tables:
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
index 055cfb8..fb8b27e 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 
+#include <asm/fixmap.h>
 #include <asm/cputype.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
@@ -252,6 +253,8 @@ void __init setup_arch(char **cmdline_p)
 
 	*cmdline_p = boot_command_line;
 
+	early_ioremap_init();
+
 	parse_early_param();
 
 	arm64_memblock_init();
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 1725cd6..8f58f52 100644
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
@@ -82,3 +86,284 @@ void __iounmap(volatile void __iomem *io_addr)
 	vunmap(addr);
 }
 EXPORT_SYMBOL(__iounmap);
+
+static int early_ioremap_debug __initdata;
+
+static int __init early_ioremap_debug_setup(char *str)
+{
+	early_ioremap_debug = 1;
+
+	return 0;
+}
+early_param("early_ioremap_debug", early_ioremap_debug_setup);
+
+static int after_paging_init __initdata;
+#ifndef CONFIG_ARM64_64K_PAGES
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
+#endif
+
+static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
+{
+	pgd_t *pgd = &swapper_pg_dir[pgd_index(addr)];
+	pud_t *pud = pud_offset(pgd, addr);
+	pmd_t *pmd = pmd_offset(pud, addr);
+
+	return pmd;
+}
+
+static inline pte_t * __init early_ioremap_pte(unsigned long addr)
+{
+#ifdef CONFIG_ARM64_64K_PAGES
+	pmd_t *pmd = early_ioremap_pmd(addr);
+	return pte_offset_kernel(pmd, addr);
+#else
+	return &bm_pte[pte_index(addr)];
+#endif
+}
+
+static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
+
+void __init early_ioremap_init(void)
+{
+	pmd_t *pmd;
+	int i;
+
+	if (early_ioremap_debug)
+		pr_info("early_ioremap_init()\n");
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
+
+	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
+#ifndef CONFIG_ARM64_64K_PAGES
+	/* need to populate pmd for 4k pagesize only */
+	memset(bm_pte, 0, sizeof(bm_pte));
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
+#endif
+
+	/*
+	 * The boot-ioremap range spans multiple pmds, for which
+	 * we are not prepared:
+	 */
+#define __FIXADDR_TOP (-PAGE_SIZE)
+	BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
+		     != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
+#undef __FIXADDR_TOP
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
+}
+
+void __init early_ioremap_reset(void)
+{
+	after_paging_init = 1;
+}
+
+void __init __set_fixmap(enum fixed_addresses idx,
+			 phys_addr_t phys, pgprot_t flags)
+{
+	unsigned long addr = __fix_to_virt(idx);
+	pte_t *pte;
+
+	if (idx >= __end_of_fixed_addresses) {
+		BUG();
+		return;
+	}
+	if (after_paging_init) {
+		WARN_ON(1);
+		return;
+	}
+
+	pte = early_ioremap_pte(addr);
+
+	if (pgprot_val(flags))
+		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
+	else
+		pte_clear(&init_mm, addr, pte);
+	flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
+}
+
+void __init early_set_fixmap(enum fixed_addresses idx,
+			     phys_addr_t phys, pgprot_t prot)
+{
+	__set_fixmap(idx, phys, prot);
+}
+
+void __init early_clear_fixmap(enum fixed_addresses idx)
+{
+	__set_fixmap(idx, 0, __pgprot(0));
+}
+
+static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
+
+static int __init check_early_ioremap_leak(void)
+{
+	int count = 0;
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		if (prev_map[i])
+			count++;
+
+	if (!count)
+		return 0;
+	WARN(1, KERN_WARNING
+	       "Debug warning: early ioremap leak of %d areas detected.\n",
+		count);
+	pr_warn("Please boot with early_ioremap_debug and report the dmesg.\n");
+
+	return 1;
+}
+late_initcall(check_early_ioremap_leak);
+
+static void __init __iomem *
+__early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
+{
+	unsigned long offset;
+	resource_size_t last_addr;
+	unsigned int nrpages;
+	enum fixed_addresses idx0, idx;
+	int i, slot;
+
+	WARN_ON(system_state != SYSTEM_BOOTING);
+
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (!prev_map[i]) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		pr_info("%s(%08llx, %08lx) not found slot\n",
+			__func__, (u64)phys_addr, size);
+		WARN_ON(1);
+		return NULL;
+	}
+
+	if (early_ioremap_debug) {
+		pr_info("%s(%08llx, %08lx) [%d] => ",
+			__func__, (u64)phys_addr, size, slot);
+		dump_stack();
+	}
+
+	/* Don't allow wraparound or zero size */
+	last_addr = phys_addr + size - 1;
+	if (!size || last_addr < phys_addr) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	prev_size[slot] = size;
+	/*
+	 * Mappings have to be page-aligned
+	 */
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
+
+	/*
+	 * Mappings have to fit in the FIX_BTMAP area.
+	 */
+	nrpages = size >> PAGE_SHIFT;
+	if (nrpages > NR_FIX_BTMAPS) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	/*
+	 * Ok, go for it..
+	 */
+	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
+	idx = idx0;
+	while (nrpages > 0) {
+		early_set_fixmap(idx, phys_addr, prot);
+		phys_addr += PAGE_SIZE;
+		--idx;
+		--nrpages;
+	}
+	if (early_ioremap_debug)
+		pr_cont("%08lx + %08lx\n", offset, slot_virt[slot]);
+
+	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
+	return prev_map[slot];
+}
+
+/* Remap an IO device */
+void __init __iomem *
+early_ioremap(resource_size_t phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, __pgprot(PROT_DEVICE_nGnRE));
+}
+
+/* Remap memory */
+void __init __iomem *
+early_memremap(resource_size_t phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size,
+			       __pgprot(PROT_NORMAL | PTE_PXN | PTE_UXN));
+}
+
+void __init early_iounmap(void __iomem *addr, unsigned long size)
+{
+	unsigned long virt_addr;
+	unsigned long offset;
+	unsigned int nrpages;
+	enum fixed_addresses idx;
+	int i, slot;
+
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i] == addr) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		pr_info("early_iounmap(%p, %08lx) not found slot\n",
+			addr, size);
+		WARN_ON(1);
+		return;
+	}
+
+	if (prev_size[slot] != size) {
+		pr_info("early_iounmap(%p, %08lx) [%d] size mismatch: %08lx\n",
+			addr, size, slot, prev_size[slot]);
+		WARN_ON(1);
+		return;
+	}
+
+	if (early_ioremap_debug) {
+		pr_info("early_iounmap(%p, %08lx) [%d]\n", addr, size, slot);
+		dump_stack();
+	}
+
+	virt_addr = (unsigned long)addr;
+	if (virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)) {
+		WARN_ON(1);
+		return;
+	}
+	offset = virt_addr & ~PAGE_MASK;
+	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
+
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
+	while (nrpages > 0) {
+		early_clear_fixmap(idx);
+		--idx;
+		--nrpages;
+	}
+	prev_map[slot] = NULL;
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

