Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaL0VIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 16:08:31 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:38248 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaL0VI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 16:08:26 -0500
From: Stefan Agner <stefan@agner.ch>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, stefan@agner.ch,
        Mark Salter <msalter@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <lauraa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC] ARM: early fixmap support for earlycon
Date: Sat, 27 Dec 2014 22:08:11 +0100
Message-Id: <1419714491-28564-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add early fixmap support, initially to support permanent, fixed
mapping support for early console. A temporary, early pte is
created which is migrated to a permanent mapping in paging_init.
This is also needed since the attributs may change as the memory
types are initialized. The 3MiB range of fixmap spans two pte
tables, but currently only one pte is created for early fixmap
support.

Readd FIX_KMAP_BEGIN to the index calculation in highmem.c since
the index for kmap does not start at zero anymore. This reverts
4221e2e6b316 ("ARM: 8031/1: fixmap: remove FIX_KMAP_BEGIN and
FIX_KMAP_END") to some extends.

Cc: Mark Salter <msalter@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <robh@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stefan Agner <stefan@agner.ch>
---
While trying to implement earlycon support on Vybrid SoC, it
turned out that set_fixmap does not support calls at that early
stage. This patch picks up code/ideas from Rob's and Mark's
patches supporting early_ioremap and fixmap support from Rob's
git tree. This patch only adds the necessary bits to extend
fixmap API for earlycon.
https://git.kernel.org/cgit/linux/kernel/git/robh/linux.git/log/?h=arm-fixmap

Also aligned the implementation somewhat how it is done for arm64
in Laura's patch af86e5974d30 ("arm64: Factor out fixmap
initialization from ioremap").

Tested with CONFIG_DEBUG_SET_MODULE_RONX which makes use of fixmap
support too.

 arch/arm/Kconfig              |  3 ++
 arch/arm/include/asm/fixmap.h | 13 +++++++-
 arch/arm/kernel/setup.c       |  3 ++
 arch/arm/mm/highmem.c         |  6 ++--
 arch/arm/mm/mmu.c             | 76 +++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 97d07ed..3a73cca 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -183,6 +183,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_HAS_BANDGAP
 	bool
 
+config FIX_EARLYCON_MEM
+	def_bool y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 0415eae..2d8b12b 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -6,9 +6,13 @@
 #define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
 #include <asm/kmap_types.h>
+#include <asm/pgtable.h>
 
 enum fixed_addresses {
-	FIX_KMAP_BEGIN,
+	FIX_EARLYCON_MEM_BASE,
+	__end_of_permanent_fixed_addresses,
+
+	FIX_KMAP_BEGIN = __end_of_permanent_fixed_addresses,
 	FIX_KMAP_END = FIX_KMAP_BEGIN + (KM_TYPE_NR * NR_CPUS) - 1,
 
 	/* Support writing RO kernel text via kprobes, jump labels, etc. */
@@ -18,7 +22,14 @@ enum fixed_addresses {
 	__end_of_fixed_addresses
 };
 
+#define FIXMAP_PAGE_COMMON	(L_PTE_YOUNG | L_PTE_PRESENT | L_PTE_XN | L_PTE_DIRTY)
+
+#define FIXMAP_PAGE_NORMAL	(FIXMAP_PAGE_COMMON | L_PTE_MT_WRITEBACK)
+#define FIXMAP_PAGE_IO		(FIXMAP_PAGE_COMMON | L_PTE_MT_DEV_SHARED | L_PTE_SHARED)
+#define FIXMAP_PAGE_NOCACHE	FIXMAP_PAGE_IO
+
 void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
+void __init early_fixmap_init(void);
 
 #include <asm-generic/fixmap.h>
 
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index f9c8639..015eade 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -37,6 +37,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/elf.h>
+#include <asm/fixmap.h>
 #include <asm/procinfo.h>
 #include <asm/psci.h>
 #include <asm/sections.h>
@@ -916,6 +917,8 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = cmd_line;
 
+	early_fixmap_init();
+
 	parse_early_param();
 
 	early_paging_init(mdesc, lookup_processor_type(read_cpuid_id()));
diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
index b98895d..c7097f9 100644
--- a/arch/arm/mm/highmem.c
+++ b/arch/arm/mm/highmem.c
@@ -78,7 +78,7 @@ void *kmap_atomic(struct page *page)
 
 	type = kmap_atomic_idx_push();
 
-	idx = type + KM_TYPE_NR * smp_processor_id();
+	idx = FIX_KMAP_BEGIN + type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	/*
@@ -105,7 +105,7 @@ void __kunmap_atomic(void *kvaddr)
 
 	if (kvaddr >= (void *)FIXADDR_START) {
 		type = kmap_atomic_idx();
-		idx = type + KM_TYPE_NR * smp_processor_id();
+		idx = FIX_KMAP_BEGIN + type + KM_TYPE_NR * smp_processor_id();
 
 		if (cache_is_vivt())
 			__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);
@@ -135,7 +135,7 @@ void *kmap_atomic_pfn(unsigned long pfn)
 		return page_address(page);
 
 	type = kmap_atomic_idx_push();
-	idx = type + KM_TYPE_NR * smp_processor_id();
+	idx = FIX_KMAP_BEGIN + type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(get_fixmap_pte(vaddr)));
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index cda7c40..d1f70dd 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -357,6 +357,47 @@ const struct mem_type *get_mem_type(unsigned int type)
 }
 EXPORT_SYMBOL(get_mem_type);
 
+static pte_t *(*pte_offset_fixmap)(pmd_t *dir, unsigned long addr);
+
+static pte_t bm_pte[PTRS_PER_PTE + PTE_HWTABLE_PTRS]
+	__aligned(PTE_HWTABLE_OFF + PTE_HWTABLE_SIZE) __initdata;
+
+static pte_t * __init pte_offset_early_fixmap(pmd_t *dir, unsigned long addr)
+{
+	return &bm_pte[pte_index(addr)];
+}
+
+static pte_t *pte_offset_late_fixmap(pmd_t *dir, unsigned long addr)
+{
+	return pte_offset_kernel(dir, addr);
+}
+
+static inline pmd_t * __init fixmap_pmd(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	pud_t *pud = pud_offset(pgd, addr);
+	pmd_t *pmd = pmd_offset(pud, addr);
+
+	return pmd;
+}
+
+void __init early_fixmap_init(void)
+{
+	pmd_t *pmd;
+
+	/*
+	 * The early fixmap range spans multiple pmds, for which
+	 * we are not preparted:
+	 */
+	BUILD_BUG_ON((__fix_to_virt(__end_of_permanent_fixed_addresses) >> PMD_SHIFT)
+		     != FIXADDR_TOP >> PMD_SHIFT);
+
+	pmd = fixmap_pmd(FIXADDR_TOP);
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
+
+	pte_offset_fixmap = &pte_offset_early_fixmap;
+}
+
 /*
  * To avoid TLB flush broadcasts, this uses local_flush_tlb_kernel_range().
  * As a result, this can only be called with preemption disabled, as under
@@ -365,7 +406,7 @@ EXPORT_SYMBOL(get_mem_type);
 void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
 {
 	unsigned long vaddr = __fix_to_virt(idx);
-	pte_t *pte = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
+	pte_t *pte = pte_offset_fixmap(pmd_off_k(vaddr), vaddr);
 
 	/* Make sure fixmap region does not exceed available allocation. */
 	BUILD_BUG_ON(FIXADDR_START + (__end_of_fixed_addresses * PAGE_SIZE) >
@@ -855,7 +896,7 @@ static void __init create_mapping(struct map_desc *md)
 	}
 
 	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
-	    md->virtual >= PAGE_OFFSET &&
+	    md->virtual >= PAGE_OFFSET && md->virtual < FIXADDR_START &&
 	    (md->virtual < VMALLOC_START || md->virtual >= VMALLOC_END)) {
 		pr_warn("BUG: mapping for 0x%08llx at 0x%08lx out of vmalloc space\n",
 			(long long)__pfn_to_phys((u64)md->pfn), md->virtual);
@@ -1231,7 +1272,7 @@ static void __init devicemaps_init(const struct machine_desc *mdesc)
 
 	early_trap_init(vectors);
 
-	for (addr = VMALLOC_START; addr; addr += PMD_SIZE)
+	for (addr = VMALLOC_START; addr < FIXADDR_START; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
 	/*
@@ -1508,6 +1549,34 @@ void __init early_paging_init(const struct machine_desc *mdesc,
 
 #endif
 
+static void __init early_fixmap_shutdown(void)
+{
+	int i;
+
+	pte_offset_fixmap = &pte_offset_late_fixmap;
+	pmd_clear(fixmap_pmd(fix_to_virt(__end_of_permanent_fixed_addresses - 1)));
+
+	for (i = 0; i < __end_of_permanent_fixed_addresses; i++) {
+		pte_t *pte;
+		struct map_desc map;
+
+		map.virtual = fix_to_virt(i);
+		pte = pte_offset_early_fixmap(pmd_off_k(map.virtual), map.virtual);
+
+		/* Only i/o device mappings are supported ATM */
+		if (pte_none(*pte) ||
+		    (pte_val(*pte) & L_PTE_MT_MASK) != L_PTE_MT_DEV_SHARED)
+			continue;
+
+		map.pfn = pte_pfn(*pte);
+		map.type = MT_DEVICE;
+		map.length = PAGE_SIZE;
+
+		create_mapping(&map);
+	}
+}
+
+
 /*
  * paging_init() sets up the page tables, initialises the zone memory
  * maps, and sets up the zero page, bad page and bad page tables.
@@ -1520,6 +1589,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 	prepare_page_table();
 	map_lowmem();
 	dma_contiguous_remap();
+	early_fixmap_shutdown();
 	devicemaps_init(mdesc);
 	kmap_init();
 	tcm_init();
-- 
2.2.1

