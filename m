Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab3D3IPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:15:50 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:62666 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab3D3IPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:15:46 -0400
Date: Tue, 30 Apr 2013 10:15:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.10
Message-ID: <20130430081542.GA21790@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   HEAD: 13f72756da86f155898e2c2022f7b3a106c3742e x86/iommu/dmar: Remove warning for HPET scope type

Misc smaller changes all over the map.

 out-of-topic modifications in x86-mm-for-linus:
 -----------------------------------------------
 drivers/iommu/dmar.c               # 13f7275: x86/iommu/dmar: Remove warning fo

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86/mm/cpa: Cleanup split_large_page() and its callee

Jan Beulich (1):
      x86: Drop always empty .text..page_aligned section

Linn Crosetto (1):
      x86/iommu/dmar: Remove warning for HPET scope type

Martin Bundgaard (1):
      x86/mm/numa: Simplify some bit mangling

Paul Bolle (2):
      x86/mm: Re-enable DEBUG_TLBFLUSH for X86_32
      x86/mm/fixmap: Remove unused FIX_CYCLONE_TIMER

Tang Chen (1):
      x86/mm/hotplug: Put kernel_physical_mapping_remove() declaration in CONFIG_MEMORY_HOTREMOVE

Wang YanQing (1):
      x86/mm/gart: Drop unnecessary check


 arch/x86/Kconfig.debug               | 2 +-
 arch/x86/include/asm/fixmap.h        | 3 ---
 arch/x86/include/asm/pgtable_types.h | 1 -
 arch/x86/kernel/acpi/wakeup_32.S     | 2 +-
 arch/x86/kernel/aperture_64.c        | 2 +-
 arch/x86/kernel/vmlinux.lds.S        | 4 ----
 arch/x86/mm/amdtopology.c            | 3 +--
 arch/x86/mm/init_64.c                | 2 +-
 arch/x86/mm/pageattr.c               | 9 ++++-----
 drivers/iommu/dmar.c                 | 3 ++-
 10 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..16f7383 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -131,7 +131,7 @@ config DOUBLEFAULT
 
 config DEBUG_TLBFLUSH
 	bool "Set upper limit of TLB entries to flush one-by-one"
-	depends on DEBUG_KERNEL && (X86_64 || X86_INVLPG)
+	depends on DEBUG_KERNEL
 	---help---
 
 	X86-only for now.
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index a09c285..83ea2fb 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -107,9 +107,6 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_F00F_BUG
 	FIX_F00F_IDT,	/* Virtual mapping for IDT */
 #endif
-#ifdef CONFIG_X86_CYCLONE_TIMER
-	FIX_CYCLONE_TIMER, /*cyclone timer register*/
-#endif
 #ifdef CONFIG_X86_32
 	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
 	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 567b5d0..e642300 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -351,7 +351,6 @@ static inline void update_page_count(int level, unsigned long pages) { }
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
-extern int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 13ab720..ced4638 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -1,4 +1,4 @@
-	.section .text..page_aligned
+	.text
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index d5fd66f..fd972a3 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -87,7 +87,7 @@ static u32 __init allocate_aperture(void)
 	 */
 	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
 				      aper_size, aper_size);
-	if (!addr || addr + aper_size > GART_MAX_ADDR) {
+	if (!addr) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
 				addr, aper_size>>10);
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 22a1530..10c4f30 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -94,10 +94,6 @@ SECTIONS
 		_text = .;
 		/* bootstrapping code */
 		HEAD_TEXT
-#ifdef CONFIG_X86_32
-		. = ALIGN(PAGE_SIZE);
-		*(.text..page_aligned)
-#endif
 		. = ALIGN(8);
 		_stext = .;
 		TEXT_TEXT
diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
index 5247d01..2ca15b5 100644
--- a/arch/x86/mm/amdtopology.c
+++ b/arch/x86/mm/amdtopology.c
@@ -130,9 +130,8 @@ int __init amd_numa_init(void)
 		}
 
 		limit >>= 16;
-		limit <<= 24;
-		limit |= (1<<24)-1;
 		limit++;
+		limit <<= 24;
 
 		if (limit > end)
 			limit = end;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 474e28f..dafdeb2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1019,6 +1019,7 @@ void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
 	remove_pagetable(start, end, false);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
@@ -1028,7 +1029,6 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true);
 }
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 int __ref arch_remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 091934e..25b1d35 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -542,13 +542,14 @@ out_unlock:
 	return do_split;
 }
 
-int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase)
+static int
+__split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 {
+	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
 	pte_t *tmp;
 	pgprot_t ref_prot;
-	struct page *base = virt_to_page(pbase);
 
 	spin_lock(&pgd_lock);
 	/*
@@ -633,7 +634,6 @@ int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase)
 
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
-	pte_t *pbase;
 	struct page *base;
 
 	if (!debug_pagealloc)
@@ -644,8 +644,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (!base)
 		return -ENOMEM;
 
-	pbase = (pte_t *)page_address(base);
-	if (__split_large_page(kpte, address, pbase))
+	if (__split_large_page(kpte, address, base))
 		__free_page(base);
 
 	return 0;
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index e5cdaf8..b8008f6 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -129,7 +129,8 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
-		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
+		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC &&
+			scope->entry_type != ACPI_DMAR_SCOPE_TYPE_HPET) {
 			pr_warn("Unsupported device scope\n");
 		}
 		start += scope->length;
