Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab3IFJUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:20:47 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46600 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3IFJU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:20:27 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, arnd@arndb.de,
        nico@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 2/2] arm: add early_ioremap support
Date: Fri,  6 Sep 2013 10:19:18 +0100
Message-Id: <1378459158-2145-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378459158-2145-1-git-send-email-leif.lindholm@linaro.org>
References: <1378459158-2145-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for early_ioremap and early_memremap, based
on the existing mechanism in x86. Up to 7 regions of up to 128KB each
can be temporarily mapped in before paging_init, regardless of later
highmem status.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/arm/Kconfig              |    7 ++
 arch/arm/include/asm/fixmap.h |   31 ++++-
 arch/arm/include/asm/io.h     |   17 +++
 arch/arm/kernel/setup.c       |    5 +
 arch/arm/mm/Makefile          |    1 +
 arch/arm/mm/early_ioremap.c   |  271 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/mmu.c             |    4 +
 7 files changed, 334 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mm/early_ioremap.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 43594d5..53a82da 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1805,6 +1805,13 @@ config UACCESS_WITH_MEMCPY
 	  However, if the CPU data cache is using a write-allocate mode,
 	  this option is unlikely to provide any performance gain.
 
+config EARLY_IOREMAP
+	depends on MMU
+	bool "Provide early_ioremap() support for kernel initialization."
+	help
+	  Provides a mechanism for kernel initialisation code to temporarily
+	  map, in a highmem-agnostic way, memory pages in before paging_init().
+
 config SECCOMP
 	bool
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index bbae919..a2a5f50 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_FIXMAP_H
 #define _ASM_FIXMAP_H
 
+#include <linux/bug.h>
+
 /*
  * Nothing too fancy for now.
  *
@@ -20,13 +22,38 @@
 #define FIX_KMAP_BEGIN		0
 #define FIX_KMAP_END		(FIXADDR_SIZE >> PAGE_SHIFT)
 
+/*
+ * 224 temporary boot-time mappings, used by early_ioremap(),
+ * before ioremap() is functional.
+ *
+ * (P)re-using the FIXADDR region, which is used for highmem
+ * later on, and statically aligned to 1MB.
+ */
+#define NR_FIX_BTMAPS		32
+#define FIX_BTMAPS_SLOTS	7
+#define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
+#define FIX_BTMAP_BEGIN		FIX_KMAP_BEGIN
+#define FIX_BTMAP_END		(FIX_KMAP_END - 1)
+
+#define clear_fixmap(idx)			\
+	__set_fixmap(idx, 0, __pgprot(0))
+
 #define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
 #define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
 
 extern void __this_fixmap_does_not_exist(void);
 
-static inline unsigned long fix_to_virt(const unsigned int idx)
+static __always_inline unsigned long fix_to_virt(const unsigned int idx)
 {
+	/*
+	 * this branch gets completely eliminated after inlining,
+	 * except when someone tries to use fixaddr indices in an
+	 * illegal way. (such as mixing up address types or using
+	 * out-of-range indices).
+	 *
+	 * If it doesn't get removed, the linker will complain
+	 * loudly with a reasonably clear error message..
+	 */
 	if (idx >= FIX_KMAP_END)
 		__this_fixmap_does_not_exist();
 	return __fix_to_virt(idx);
@@ -38,4 +65,4 @@ static inline unsigned int virt_to_fix(const unsigned long vaddr)
 	return __virt_to_fix(vaddr);
 }
 
-#endif
+#endif /* _ASM_FIXMAP_H */
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d070741..35499d9 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 #include <asm/memory.h>
+#include <asm/pgtable.h>
 #include <asm-generic/pci_iomap.h>
 
 /*
@@ -397,5 +398,21 @@ extern int devmem_is_allowed(unsigned long pfn);
 extern void register_isa_ports(unsigned int mmio, unsigned int io,
 			       unsigned int io_shift);
 
+/*
+ * early_ioremap() and early_iounmap() are for temporary early boot-time
+ * mappings, before the real ioremap() is functional.
+ * A boot-time mapping is currently limited to at most 16 pages.
+ *
+ * This is all squashed by paging_init().
+ */
+extern void early_ioremap_init(void);
+extern void early_ioremap_reset(void);
+extern void __iomem *early_remap(resource_size_t phys_addr,
+				 unsigned long size, u32 prot);
+#define early_ioremap(x, y) early_remap(x, y, L_PTE_MT_DEV_NONSHARED)
+#define early_memremap(x, y) early_remap(x, y, L_PTE_MT_UNCACHED)
+
+extern void early_iounmap(void __iomem *addr, unsigned long size);
+
 #endif	/* __KERNEL__ */
 #endif	/* __ASM_ARM_IO_H */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index afc2489..ce913ea 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -36,6 +36,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/elf.h>
+#include <asm/io.h>
 #include <asm/procinfo.h>
 #include <asm/psci.h>
 #include <asm/sections.h>
@@ -877,6 +878,10 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+#ifdef CONFIG_EARLY_IOREMAP
+	early_ioremap_init();
+#endif
+
 	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
 	sanity_check_meminfo();
 	arm_memblock_init(&meminfo, mdesc);
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index ecfe6e5..fea855e 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -15,6 +15,7 @@ endif
 obj-$(CONFIG_MODULES)		+= proc-syms.o
 
 obj-$(CONFIG_ALIGNMENT_TRAP)	+= alignment.o
+obj-$(CONFIG_EARLY_IOREMAP)	+= early_ioremap.o
 obj-$(CONFIG_HIGHMEM)		+= highmem.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 
diff --git a/arch/arm/mm/early_ioremap.c b/arch/arm/mm/early_ioremap.c
new file mode 100644
index 0000000..9bb1339
--- /dev/null
+++ b/arch/arm/mm/early_ioremap.c
@@ -0,0 +1,271 @@
+/*
+ * early_ioremap() support for ARM
+ *
+ * Based on existing support in arch/x86/mm/ioremap.c
+ *
+ * Restrictions: currently only functional before paging_init()
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+
+#include <asm/fixmap.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+#include <asm/mach/map.h>
+
+static int __initdata early_ioremap_debug;
+
+static int __init early_ioremap_debug_setup(char *str)
+{
+	early_ioremap_debug = 1;
+
+	return 0;
+}
+early_param("early_ioremap_debug", early_ioremap_debug_setup);
+
+static pte_t __initdata bm_pte[PTRS_PER_PTE] __aligned(PTRS_PER_PTE * sizeof(pte_t));
+static __initdata int after_paging_init;
+
+static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
+{
+	unsigned int index = pgd_index(addr);
+	pgd_t *pgd = cpu_get_pgd() + index;
+	pud_t *pud = pud_offset(pgd, addr);
+	pmd_t *pmd = pmd_offset(pud, addr);
+
+	return pmd;
+}
+
+static inline pte_t * __init early_ioremap_pte(unsigned long addr)
+{
+	return &bm_pte[pte_index(addr)];
+}
+
+static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
+
+void __init early_ioremap_init(void)
+{
+	pmd_t *pmd;
+	int i;
+	u64 desc;
+
+	if (early_ioremap_debug)
+		pr_info("early_ioremap_init()\n");
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN + NR_FIX_BTMAPS*i);
+		if (early_ioremap_debug)
+			pr_info("  %lu byte slot @ 0x%08x\n",
+				NR_FIX_BTMAPS * PAGE_SIZE, (u32)slot_virt[i]);
+	}
+
+	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
+	desc = *pmd;
+	memset(bm_pte, 0, sizeof(bm_pte));
+
+	pmd_populate_kernel(NULL, pmd, bm_pte);
+	desc = *pmd;
+
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
+		pr_warn("FIX_BTMAP_END:       %lu\n", FIX_BTMAP_END);
+		pr_warn("FIX_BTMAP_BEGIN:     %d\n",  FIX_BTMAP_BEGIN);
+	}
+}
+
+void __init early_ioremap_reset(void)
+{
+	after_paging_init = 1;
+}
+
+static void __init __early_set_fixmap(unsigned long idx,
+				      phys_addr_t phys, pgprot_t flags)
+{
+	unsigned long addr = __fix_to_virt(idx);
+	pte_t *pte;
+	u64 desc;
+
+	if (idx >= FIX_KMAP_END) {
+		BUG();
+		return;
+	}
+	pte = early_ioremap_pte(addr);
+
+	if (pgprot_val(flags))
+		set_pte_at(NULL, 0xfff00000, pte,
+			   pfn_pte(phys >> PAGE_SHIFT, flags));
+	else
+		pte_clear(NULL, addr, pte);
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+	desc = *pte;
+}
+
+static inline void __init early_set_fixmap(unsigned long idx,
+					   phys_addr_t phys, pgprot_t prot)
+{
+	__early_set_fixmap(idx, phys, prot);
+}
+
+static inline void __init early_clear_fixmap(unsigned long idx)
+{
+	__early_set_fixmap(idx, 0, __pgprot(0));
+}
+
+static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
+
+static void __init __iomem *
+__early_remap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
+{
+	unsigned long offset;
+	resource_size_t last_addr;
+	unsigned int nrpages;
+	unsigned long idx;
+	int i, slot;
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
+		pr_info("early_iomap(%08llx, %08lx) not found slot\n",
+			(u64)phys_addr, size);
+		WARN_ON(1);
+		return NULL;
+	}
+
+	if (early_ioremap_debug) {
+		pr_info("early_ioremap(%08llx, %08lx) [%d] => ",
+			(u64)phys_addr, size, slot);
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
+	idx = FIX_BTMAP_BEGIN + slot * NR_FIX_BTMAPS;
+	while (nrpages > 0) {
+		early_set_fixmap(idx, phys_addr, prot);
+		phys_addr += PAGE_SIZE;
+		idx++;
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
+early_remap(resource_size_t phys_addr, unsigned long size, u32 prot)
+{
+	if (after_paging_init) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	/*
+	 * PAGE_KERNEL depends on not-yet-initialised variables.
+	 * We don't care about coherency or executability of early_ioremap
+	 * pages anyway.
+	 */
+	prot |= L_PTE_YOUNG | L_PTE_PRESENT;
+	return __early_remap(phys_addr, size, prot);
+}
+
+
+void __init early_iounmap(void __iomem *addr, unsigned long size)
+{
+	unsigned long virt_addr;
+	unsigned long offset;
+	unsigned int nrpages;
+	unsigned long idx;
+	int i, slot;
+
+	if (after_paging_init) {
+		WARN_ON(1);
+		return;
+	}
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
+		pr_info("early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
+			addr, size, slot, prev_size[slot]);
+		WARN_ON(1);
+		return;
+	}
+
+	if (early_ioremap_debug)
+		pr_info("early_iounmap(%p, %08lx) [%d]\n", addr, size, slot);
+
+	virt_addr = (unsigned long)addr;
+	if (virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)) {
+		WARN_ON(1);
+		return;
+	}
+	offset = virt_addr & ~PAGE_MASK;
+	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
+
+	idx = FIX_BTMAP_BEGIN + slot * NR_FIX_BTMAPS;
+	while (nrpages > 0) {
+		early_clear_fixmap(idx);
+		idx++;
+		--nrpages;
+	}
+	prev_map[slot] = NULL;
+}
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 53cdbd3..f4adb41 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -28,6 +28,7 @@
 #include <asm/highmem.h>
 #include <asm/system_info.h>
 #include <asm/traps.h>
+#include <asm/io.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -1340,4 +1341,7 @@ void __init paging_init(struct machine_desc *mdesc)
 
 	empty_zero_page = virt_to_page(zero_page);
 	__flush_dcache_page(NULL, empty_zero_page);
+#ifdef CONFIG_EARLY_IOREMAP
+	early_ioremap_reset();
+#endif
 }
-- 
1.7.10.4

