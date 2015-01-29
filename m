Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbbA2BHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:07:48 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:40372 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbbA2BHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:07:45 -0500
Date: Thu, 29 Jan 2015 02:30:28 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: split up mm_struct to separate header file
Message-ID: <20150129003028.GA17519@node.dhcp.inet.fi>
References: <1422451064-109023-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1422451064-109023-3-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422451064-109023-3-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 03:17:42PM +0200, Kirill A. Shutemov wrote:
> We want to use __PAGETABLE_PMD_FOLDED in mm_struct to drop nr_pmds if
> pmd is folded. __PAGETABLE_PMD_FOLDED is defined in <asm/pgtable.h>, but
> <asm/pgtable.h> itself wants <linux/mm_types.h> for struct page
> definition.
> 
> This patch move mm_struct definition into separate header file in order
> to fix circular header dependencies.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Guenter, below is update for the patch. It doesn't fix all the issues, but
you should see an improvement. I'll continue with this tomorrow.

BTW, any idea where I can get hexagon cross compiler?

>From 8bb23d8b6b4b81485294966193a262f918a0a195 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Wed, 28 Jan 2015 13:30:24 +0200
Subject: [PATCH] mm: split up mm_struct to separate header file

We want to use __PAGETABLE_PMD_FOLDED in mm_struct to drop nr_pmds if
pmd is folded. __PAGETABLE_PMD_FOLDED is defined in <asm/pgtable.h>, but
<asm/pgtable.h> itself wants <linux/mm_types.h> for struct page
definition.

This patch move mm_struct definition into separate header file in order
to fix circular header dependencies.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/arm/include/asm/pgtable-3level.h    |   9 +-
 arch/arm/include/asm/pgtable.h           |   3 -
 arch/arm/kernel/ftrace.c                 |   1 +
 arch/arm/mm/mm.h                         |   1 +
 arch/arm64/kernel/efi.c                  |   1 +
 arch/avr32/include/asm/pgtable.h         |   5 -
 arch/avr32/mm/tlb.c                      |   1 +
 arch/c6x/kernel/dma.c                    |   1 -
 arch/cris/arch-v10/mm/init.c             |   1 +
 arch/cris/include/asm/pgtable.h          |   7 +-
 arch/cris/include/asm/tlbflush.h         |   1 +
 arch/frv/include/asm/pgtable.h           |  33 +----
 arch/frv/mm/pgalloc.c                    |  31 +++++
 arch/ia64/include/asm/pgtable.h          |   8 +-
 arch/ia64/kernel/topology.c              |   1 +
 arch/m68k/include/asm/cacheflush_mm.h    |   1 +
 arch/m68k/include/asm/motorola_pgtable.h |   6 +-
 arch/m68k/include/asm/pgtable_mm.h       |   1 -
 arch/microblaze/include/asm/pgtable.h    |   1 -
 arch/microblaze/kernel/kgdb.c            |   1 +
 arch/powerpc/include/asm/pgtable-ppc32.h |   1 -
 arch/s390/include/asm/pgtable.h          |   1 +
 arch/sparc/include/asm/pgtable_32.h      |   2 +-
 arch/x86/include/asm/mmu_context.h       |   1 +
 arch/x86/include/asm/pgtable.h           |  15 +--
 drivers/iommu/amd_iommu_v2.c             |   1 +
 drivers/macintosh/adb-iop.c              |   1 +
 drivers/staging/android/ion/ion.c        |   1 -
 include/linux/bootmem.h                  |   1 +
 include/linux/mm.h                       |   1 +
 include/linux/mm_struct.h                | 214 ++++++++++++++++++++++++++++++
 include/linux/mm_types.h                 | 218 +------------------------------
 include/linux/mmu_notifier.h             |   1 +
 include/linux/sched.h                    |   1 +
 mm/init-mm.c                             |   1 +
 mm/kmemcheck.c                           |   1 -
 36 files changed, 287 insertions(+), 288 deletions(-)
 create mode 100644 include/linux/mm_struct.h

diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 370684dcc2da..7874de5ab7dd 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -269,7 +269,7 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 	return pmd;
 }
 
-static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
+static inline void __set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
 	BUG_ON(addr >= TASK_SIZE);
@@ -284,9 +284,14 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		pmd_val(pmd) |= PMD_SECT_AP2;
 
 	*pmdp = __pmd(pmd_val(pmd) | PMD_SECT_nG);
-	flush_pmd_entry(pmdp);
 }
 
+#define set_pmd_at(mm, addr, pmdp, pmd)			\
+	do {						\
+		__set_pmd_at(mm, addr, pmdp, pmd)	\
+		flush_pmd_entry(pmdp)			\
+	} while(0)
+
 static inline int has_transparent_hugepage(void)
 {
 	return 1;
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index f40354198bad..bb4ae035e5e3 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -24,9 +24,6 @@
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
 
-
-#include <asm/tlbflush.h>
-
 #ifdef CONFIG_ARM_LPAE
 #include <asm/pgtable-3level.h>
 #else
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 709ee1d6d4df..b6f6c11e67a6 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -21,6 +21,7 @@
 #include <asm/opcodes.h>
 #include <asm/ftrace.h>
 #include <asm/insn.h>
+#include <asm/tlbflush.h>
 
 #ifdef CONFIG_THUMB2_KERNEL
 #define	NOP		0xf85deb04	/* pop.w {lr} */
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index ce727d47275c..b5e764e0d5a8 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -3,6 +3,7 @@
 #include <linux/vmalloc.h>
 
 #include <asm/pgtable.h>
+#include <asm/tlbflush.h>
 
 /* the upper-most page table pointer */
 extern pmd_t *top_pmd;
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b42c7b480e1e..fbf0a6d6f691 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
+#include <linux/mm_struct.h>
 #include <linux/bootmem.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
diff --git a/arch/avr32/include/asm/pgtable.h b/arch/avr32/include/asm/pgtable.h
index 35800664076e..3af39532b25b 100644
--- a/arch/avr32/include/asm/pgtable.h
+++ b/arch/avr32/include/asm/pgtable.h
@@ -10,11 +10,6 @@
 
 #include <asm/addrspace.h>
 
-#ifndef __ASSEMBLY__
-#include <linux/sched.h>
-
-#endif /* !__ASSEMBLY__ */
-
 /*
  * Use two-level page tables just as the i386 (without PAE)
  */
diff --git a/arch/avr32/mm/tlb.c b/arch/avr32/mm/tlb.c
index 0da23109f817..964130f8f89d 100644
--- a/arch/avr32/mm/tlb.c
+++ b/arch/avr32/mm/tlb.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/mm.h>
+#include <linux/sched.h>
 
 #include <asm/mmu_context.h>
 
diff --git a/arch/c6x/kernel/dma.c b/arch/c6x/kernel/dma.c
index ab7b12de144d..5a489f1eabbd 100644
--- a/arch/c6x/kernel/dma.c
+++ b/arch/c6x/kernel/dma.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
-#include <linux/mm_types.h>
 #include <linux/scatterlist.h>
 
 #include <asm/cacheflush.h>
diff --git a/arch/cris/arch-v10/mm/init.c b/arch/cris/arch-v10/mm/init.c
index e7f8066105aa..800faf7f97e7 100644
--- a/arch/cris/arch-v10/mm/init.c
+++ b/arch/cris/arch-v10/mm/init.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/types.h>
diff --git a/arch/cris/include/asm/pgtable.h b/arch/cris/include/asm/pgtable.h
index ceefc314d64d..88fd211af681 100644
--- a/arch/cris/include/asm/pgtable.h
+++ b/arch/cris/include/asm/pgtable.h
@@ -9,7 +9,7 @@
 #include <asm-generic/pgtable-nopmd.h>
 
 #ifndef __ASSEMBLY__
-#include <linux/sched.h>
+#include <linux/mm_types.h>
 #include <asm/mmu.h>
 #endif
 #include <arch/pgtable.h>
@@ -232,10 +232,7 @@ static inline void pmd_set(pmd_t * pmdp, pte_t * ptep)
 #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
 
 /* to find an entry in a page-table-directory */
-static inline pgd_t * pgd_offset(const struct mm_struct *mm, unsigned long address)
-{
-	return mm->pgd + pgd_index(address);
-}
+#define pgd_offset(mm, address) ((mm)->pgd + pgd_index(address))
 
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
diff --git a/arch/cris/include/asm/tlbflush.h b/arch/cris/include/asm/tlbflush.h
index 20697e7ef4f2..149c8aa1d58a 100644
--- a/arch/cris/include/asm/tlbflush.h
+++ b/arch/cris/include/asm/tlbflush.h
@@ -2,6 +2,7 @@
 #define _CRIS_TLBFLUSH_H
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/arch/frv/include/asm/pgtable.h b/arch/frv/include/asm/pgtable.h
index 93bcf2abd1a1..0c1c9ead8510 100644
--- a/arch/frv/include/asm/pgtable.h
+++ b/arch/frv/include/asm/pgtable.h
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-#include <linux/sched.h>
 struct vm_area_struct;
 #endif
 
@@ -477,36 +476,8 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 #define __HAVE_ARCH_PTE_SAME
 #include <asm-generic/pgtable.h>
 
-/*
- * preload information about a newly instantiated PTE into the SCR0/SCR1 PGE cache
- */
-static inline void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
-{
-	struct mm_struct *mm;
-	unsigned long ampr;
-
-	mm = current->mm;
-	if (mm) {
-		pgd_t *pge = pgd_offset(mm, address);
-		pud_t *pue = pud_offset(pge, address);
-		pmd_t *pme = pmd_offset(pue, address);
-
-		ampr = pme->ste[0] & 0xffffff00;
-		ampr |= xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C |
-			xAMPRx_V;
-	} else {
-		address = ULONG_MAX;
-		ampr = 0;
-	}
-
-	asm volatile("movgs %0,scr0\n"
-		     "movgs %0,scr1\n"
-		     "movgs %1,dampr4\n"
-		     "movgs %1,dampr5\n"
-		     :
-		     : "r"(address), "r"(ampr)
-		     );
-}
+void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep);
 
 #ifdef CONFIG_PROC_FS
 extern char *proc_pid_status_frv_cxnr(struct mm_struct *mm, char *buffer);
diff --git a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
index 41907d25ed38..fc18d208030b 100644
--- a/arch/frv/mm/pgalloc.c
+++ b/arch/frv/mm/pgalloc.c
@@ -155,3 +155,34 @@ void check_pgt_cache(void)
 	quicklist_trim(0, pgd_dtor, 25, 16);
 }
 
+/*
+ * preload information about a newly instantiated PTE into the SCR0/SCR1 PGE cache
+ */
+void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep)
+{
+	struct mm_struct *mm;
+	unsigned long ampr;
+
+	mm = current->mm;
+	if (mm) {
+		pgd_t *pge = pgd_offset(mm, address);
+		pud_t *pue = pud_offset(pge, address);
+		pmd_t *pme = pmd_offset(pue, address);
+
+		ampr = pme->ste[0] & 0xffffff00;
+		ampr |= xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C |
+			xAMPRx_V;
+	} else {
+		address = ULONG_MAX;
+		ampr = 0;
+	}
+
+	asm volatile("movgs %0,scr0\n"
+		     "movgs %0,scr1\n"
+		     "movgs %1,dampr4\n"
+		     "movgs %1,dampr5\n"
+		     :
+		     : "r"(address), "r"(ampr)
+		     );
+}
diff --git a/arch/ia64/include/asm/pgtable.h b/arch/ia64/include/asm/pgtable.h
index 7b6f8801df57..66bbf5618631 100644
--- a/arch/ia64/include/asm/pgtable.h
+++ b/arch/ia64/include/asm/pgtable.h
@@ -147,10 +147,8 @@
 
 # ifndef __ASSEMBLY__
 
-#include <linux/sched.h>	/* for mm_struct */
 #include <linux/bitops.h>
 #include <asm/cacheflush.h>
-#include <asm/mmu_context.h>
 
 /*
  * Next come the mappings that determine how mmap() protection bits
@@ -368,11 +366,7 @@ pgd_index (unsigned long address)
 
 /* The offset in the 1-level directory is given by the 3 region bits
    (61..63) and the level-1 bits.  */
-static inline pgd_t*
-pgd_offset (const struct mm_struct *mm, unsigned long address)
-{
-	return mm->pgd + pgd_index(address);
-}
+#define pgd_offset(mm, addr) ((mm)->pgd + pgd_index(addr))
 
 /* In the kernel's mapped region we completely ignore the region number
    (since we know it's in region number 5). */
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index 965ab42fabb0..4009738811f7 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -16,6 +16,7 @@
 #include <linux/cpu.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/node.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff --git a/arch/m68k/include/asm/cacheflush_mm.h b/arch/m68k/include/asm/cacheflush_mm.h
index fa2c3d681d84..e91674ddf62a 100644
--- a/arch/m68k/include/asm/cacheflush_mm.h
+++ b/arch/m68k/include/asm/cacheflush_mm.h
@@ -2,6 +2,7 @@
 #define _M68K_CACHEFLUSH_H
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #ifdef CONFIG_COLDFIRE
 #include <asm/mcfsim.h>
 #endif
diff --git a/arch/m68k/include/asm/motorola_pgtable.h b/arch/m68k/include/asm/motorola_pgtable.h
index 0085aab80e5a..8074c399a048 100644
--- a/arch/m68k/include/asm/motorola_pgtable.h
+++ b/arch/m68k/include/asm/motorola_pgtable.h
@@ -192,11 +192,7 @@ static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 #define pgd_index(address)     ((address) >> PGDIR_SHIFT)
 
 /* to find an entry in a page-table-directory */
-static inline pgd_t *pgd_offset(const struct mm_struct *mm,
-				unsigned long address)
-{
-	return mm->pgd + pgd_index(address);
-}
+#define pgd_offset(mm, address) ((mm)->pgd + pgd_index(address))
 
 #define swapper_pg_dir kernel_pg_dir
 extern pgd_t kernel_pg_dir[128];
diff --git a/arch/m68k/include/asm/pgtable_mm.h b/arch/m68k/include/asm/pgtable_mm.h
index 28a145bfbb71..575b39fd31a8 100644
--- a/arch/m68k/include/asm/pgtable_mm.h
+++ b/arch/m68k/include/asm/pgtable_mm.h
@@ -7,7 +7,6 @@
 
 #ifndef __ASSEMBLY__
 #include <asm/processor.h>
-#include <linux/sched.h>
 #include <linux/threads.h>
 
 /*
diff --git a/arch/microblaze/include/asm/pgtable.h b/arch/microblaze/include/asm/pgtable.h
index e53b8532353c..101cc7b4440a 100644
--- a/arch/microblaze/include/asm/pgtable.h
+++ b/arch/microblaze/include/asm/pgtable.h
@@ -66,7 +66,6 @@ extern int mem_init_done;
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-#include <linux/sched.h>
 #include <linux/threads.h>
 #include <asm/processor.h>		/* For TASK_SIZE */
 #include <asm/mmu.h>
diff --git a/arch/microblaze/kernel/kgdb.c b/arch/microblaze/kernel/kgdb.c
index 8736af5806ae..89e12562b30d 100644
--- a/arch/microblaze/kernel/kgdb.c
+++ b/arch/microblaze/kernel/kgdb.c
@@ -10,6 +10,7 @@
 #include <linux/kdebug.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <asm/cacheflush.h>
 #include <asm/asm-offsets.h>
 #include <asm/kgdb.h>
diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index cc3e621aa830..32632aa7e1c7 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -4,7 +4,6 @@
 #include <asm-generic/pgtable-nopmd.h>
 
 #ifndef __ASSEMBLY__
-#include <linux/sched.h>
 #include <linux/threads.h>
 #include <asm/io.h>			/* For sub-arch specific PPC_PIN_SIZE */
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index fbb5ee3ae57c..578eb098b1be 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -29,6 +29,7 @@
 #ifndef __ASSEMBLY__
 #include <linux/sched.h>
 #include <linux/mm_types.h>
+#include <linux/mm_struct.h>
 #include <linux/page-flags.h>
 #include <linux/radix-tree.h>
 #include <asm/bug.h>
diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
index f06b36a00a3b..91b963a887b7 100644
--- a/arch/sparc/include/asm/pgtable_32.h
+++ b/arch/sparc/include/asm/pgtable_32.h
@@ -14,7 +14,7 @@
 #include <asm-generic/4level-fixup.h>
 
 #include <linux/spinlock.h>
-#include <linux/swap.h>
+#include <linux/mm_types.h>
 #include <asm/types.h>
 #include <asm/pgtsrmmu.h>
 #include <asm/vaddrs.h>
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 4b75d591eb5e..78a87a30ec50 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/desc.h>
 #include <linux/atomic.h>
 #include <linux/mm_types.h>
+#include <linux/mm_struct.h>
 
 #include <trace/events/tlb.h>
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 9d0ade00923e..594d09d07bb4 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -445,18 +445,9 @@ static inline int pte_present(pte_t a)
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
 }
 
-#define pte_accessible pte_accessible
-static inline bool pte_accessible(struct mm_struct *mm, pte_t a)
-{
-	if (pte_flags(a) & _PAGE_PRESENT)
-		return true;
-
-	if ((pte_flags(a) & _PAGE_PROTNONE) &&
-			mm_tlb_flush_pending(mm))
-		return true;
-
-	return false;
-}
+#define pte_accessible(mm, pte) \
+	(pte_flags(pte) & _PAGE_PRESENT) || \
+	((pte_flags(pte) & _PAGE_PROTNONE) && mm_tlb_flush_pending(mm))
 
 static inline int pte_hidden(pte_t pte)
 {
diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 90f70d0e1141..d49cd95eaf7b 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -19,6 +19,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/amd-iommu.h>
 #include <linux/mm_types.h>
+#include <linux/mm_struct.h>
 #include <linux/profile.h>
 #include <linux/module.h>
 #include <linux/sched.h>
diff --git a/drivers/macintosh/adb-iop.c b/drivers/macintosh/adb-iop.c
index f5f4da3d0b67..8916f1ad5f37 100644
--- a/drivers/macintosh/adb-iop.c
+++ b/drivers/macintosh/adb-iop.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 
 #include <asm/macintosh.h> 
 #include <asm/macints.h> 
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index b8f1c491553e..1cb3c88f6423 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -27,7 +27,6 @@
 #include <linux/miscdevice.h>
 #include <linux/export.h>
 #include <linux/mm.h>
-#include <linux/mm_types.h>
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 0995c2de8162..4d90afe3fbb4 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -7,6 +7,7 @@
 #include <linux/mmzone.h>
 #include <linux/mm_types.h>
 #include <asm/dma.h>
+#include <asm/mmu.h>
 
 /*
  *  simple boot-time physical memory area allocator.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b976d9ffbcd6..543e9723d441 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -14,6 +14,7 @@
 #include <linux/atomic.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/mm_struct.h>
 #include <linux/range.h>
 #include <linux/pfn.h>
 #include <linux/bit_spinlock.h>
diff --git a/include/linux/mm_struct.h b/include/linux/mm_struct.h
new file mode 100644
index 000000000000..0a233c232a39
--- /dev/null
+++ b/include/linux/mm_struct.h
@@ -0,0 +1,214 @@
+#ifndef _LINUX_MM_STRUCT_H
+#define _LINUX_MM_STRUCT_H
+
+#include <linux/auxvec.h>
+#include <linux/rbtree.h>
+#include <linux/rwsem.h>
+#include <linux/types.h>
+#include <linux/uprobes.h>
+
+#include <asm/mmu.h>
+
+struct kioctx_table;
+struct vm_area_struct;
+
+#ifndef AT_VECTOR_SIZE_ARCH
+#define AT_VECTOR_SIZE_ARCH 0
+#endif
+#define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
+
+enum {
+	MM_FILEPAGES,
+	MM_ANONPAGES,
+	MM_SWAPENTS,
+	NR_MM_COUNTERS
+};
+
+#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS && defined(CONFIG_MMU)
+#define SPLIT_RSS_COUNTING
+/* per-thread cached information, */
+struct task_rss_stat {
+	int events;	/* for synchronization threshold */
+	int count[NR_MM_COUNTERS];
+};
+#endif /* USE_SPLIT_PTE_PTLOCKS */
+
+struct mm_rss_stat {
+	atomic_long_t count[NR_MM_COUNTERS];
+};
+
+struct mm_struct {
+	struct vm_area_struct *mmap;		/* list of VMAs */
+	struct rb_root mm_rb;
+	u32 vmacache_seqnum;                   /* per-thread vmacache */
+#ifdef CONFIG_MMU
+	unsigned long (*get_unmapped_area) (struct file *filp,
+				unsigned long addr, unsigned long len,
+				unsigned long pgoff, unsigned long flags);
+#endif
+	unsigned long mmap_base;		/* base of mmap area */
+	unsigned long mmap_legacy_base;         /* base of mmap area in bottom-up allocations */
+	unsigned long task_size;		/* size of task vm space */
+	unsigned long highest_vm_end;		/* highest vma end address */
+	pgd_t * pgd;
+	atomic_t mm_users;			/* How many users with user space? */
+	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
+	atomic_long_t nr_ptes;			/* PTE page table pages */
+	atomic_long_t nr_pmds;			/* PMD page table pages */
+	int map_count;				/* number of VMAs */
+
+	spinlock_t page_table_lock;		/* Protects page tables and some counters */
+	struct rw_semaphore mmap_sem;
+
+	struct list_head mmlist;		/* List of maybe swapped mm's.	These are globally strung
+						 * together off init_mm.mmlist, and are protected
+						 * by mmlist_lock
+						 */
+
+
+	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
+	unsigned long hiwater_vm;	/* High-water virtual memory usage */
+
+	unsigned long total_vm;		/* Total pages mapped */
+	unsigned long locked_vm;	/* Pages that have PG_mlocked set */
+	unsigned long pinned_vm;	/* Refcount permanently increased */
+	unsigned long shared_vm;	/* Shared pages (files) */
+	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
+	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
+	unsigned long def_flags;
+	unsigned long start_code, end_code, start_data, end_data;
+	unsigned long start_brk, brk, start_stack;
+	unsigned long arg_start, arg_end, env_start, env_end;
+
+	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
+
+	/*
+	 * Special counters, in some configurations protected by the
+	 * page_table_lock, in other configurations by being atomic.
+	 */
+	struct mm_rss_stat rss_stat;
+
+	struct linux_binfmt *binfmt;
+
+	cpumask_var_t cpu_vm_mask_var;
+
+	/* Architecture-specific MM context */
+	mm_context_t context;
+
+	unsigned long flags; /* Must use atomic bitops to access the bits */
+
+	struct core_state *core_state; /* coredumping support */
+#ifdef CONFIG_AIO
+	spinlock_t			ioctx_lock;
+	struct kioctx_table __rcu	*ioctx_table;
+#endif
+#ifdef CONFIG_MEMCG
+	/*
+	 * "owner" points to a task that is regarded as the canonical
+	 * user/owner of this mm. All of the following must be true in
+	 * order for it to be changed:
+	 *
+	 * current == mm->owner
+	 * current->mm != mm
+	 * new_owner->mm == mm
+	 * new_owner->alloc_lock is held
+	 */
+	struct task_struct __rcu *owner;
+#endif
+
+	/* store ref to file /proc/<pid>/exe symlink points to */
+	struct file *exe_file;
+#ifdef CONFIG_MMU_NOTIFIER
+	struct mmu_notifier_mm *mmu_notifier_mm;
+#endif
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
+	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
+#endif
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	struct cpumask cpumask_allocation;
+#endif
+#ifdef CONFIG_NUMA_BALANCING
+	/*
+	 * numa_next_scan is the next time that the PTEs will be marked
+	 * pte_numa. NUMA hinting faults will gather statistics and migrate
+	 * pages to new nodes if necessary.
+	 */
+	unsigned long numa_next_scan;
+
+	/* Restart point for scanning and setting pte_numa */
+	unsigned long numa_scan_offset;
+
+	/* numa_scan_seq prevents two threads setting pte_numa */
+	int numa_scan_seq;
+#endif
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+	/*
+	 * An operation with batched TLB flushing is going on. Anything that
+	 * can move process memory needs to flush the TLB when moving a
+	 * PROT_NONE or PROT_NUMA mapped page.
+	 */
+	bool tlb_flush_pending;
+#endif
+	struct uprobes_state uprobes_state;
+#ifdef CONFIG_X86_INTEL_MPX
+	/* address of the bounds directory */
+	void __user *bd_addr;
+#endif
+};
+
+static inline void mm_init_cpumask(struct mm_struct *mm)
+{
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	mm->cpu_vm_mask_var = &mm->cpumask_allocation;
+#endif
+	cpumask_clear(mm->cpu_vm_mask_var);
+}
+
+/* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
+static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
+{
+	return mm->cpu_vm_mask_var;
+}
+
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+/*
+ * Memory barriers to keep this state in sync are graciously provided by
+ * the page table locks, outside of which no page table modifications happen.
+ * The barriers below prevent the compiler from re-ordering the instructions
+ * around the memory barriers that are already present in the code.
+ */
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+{
+	barrier();
+	return mm->tlb_flush_pending;
+}
+static inline void set_tlb_flush_pending(struct mm_struct *mm)
+{
+	mm->tlb_flush_pending = true;
+
+	/*
+	 * Guarantee that the tlb_flush_pending store does not leak into the
+	 * critical section updating the page tables
+	 */
+	smp_mb__before_spinlock();
+}
+/* Clearing is done after a TLB flush, which also provides a barrier. */
+static inline void clear_tlb_flush_pending(struct mm_struct *mm)
+{
+	barrier();
+	mm->tlb_flush_pending = false;
+}
+#else
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+{
+	return false;
+}
+static inline void set_tlb_flush_pending(struct mm_struct *mm)
+{
+}
+static inline void clear_tlb_flush_pending(struct mm_struct *mm)
+{
+}
+#endif
+
+#endif
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5dfdd5ed5254..80797b1c1e26 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1,24 +1,16 @@
 #ifndef _LINUX_MM_TYPES_H
 #define _LINUX_MM_TYPES_H
 
-#include <linux/auxvec.h>
-#include <linux/types.h>
-#include <linux/threads.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/rbtree.h>
-#include <linux/rwsem.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
-#include <linux/uprobes.h>
+#include <linux/list.h>
 #include <linux/page-flags-layout.h>
-#include <asm/page.h>
-#include <asm/mmu.h>
+#include <linux/rbtree.h>
+#include <linux/spinlock.h>
+#include <linux/threads.h>
+#include <linux/types.h>
 
-#ifndef AT_VECTOR_SIZE_ARCH
-#define AT_VECTOR_SIZE_ARCH 0
-#endif
-#define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
+#include <asm/page.h>
 
 struct address_space;
 struct mem_cgroup;
@@ -326,203 +318,7 @@ struct core_state {
 	struct completion startup;
 };
 
-enum {
-	MM_FILEPAGES,
-	MM_ANONPAGES,
-	MM_SWAPENTS,
-	NR_MM_COUNTERS
-};
-
-#if USE_SPLIT_PTE_PTLOCKS && defined(CONFIG_MMU)
-#define SPLIT_RSS_COUNTING
-/* per-thread cached information, */
-struct task_rss_stat {
-	int events;	/* for synchronization threshold */
-	int count[NR_MM_COUNTERS];
-};
-#endif /* USE_SPLIT_PTE_PTLOCKS */
-
-struct mm_rss_stat {
-	atomic_long_t count[NR_MM_COUNTERS];
-};
-
-struct kioctx_table;
-struct mm_struct {
-	struct vm_area_struct *mmap;		/* list of VMAs */
-	struct rb_root mm_rb;
-	u32 vmacache_seqnum;                   /* per-thread vmacache */
-#ifdef CONFIG_MMU
-	unsigned long (*get_unmapped_area) (struct file *filp,
-				unsigned long addr, unsigned long len,
-				unsigned long pgoff, unsigned long flags);
-#endif
-	unsigned long mmap_base;		/* base of mmap area */
-	unsigned long mmap_legacy_base;         /* base of mmap area in bottom-up allocations */
-	unsigned long task_size;		/* size of task vm space */
-	unsigned long highest_vm_end;		/* highest vma end address */
-	pgd_t * pgd;
-	atomic_t mm_users;			/* How many users with user space? */
-	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
-	atomic_long_t nr_ptes;			/* PTE page table pages */
-	atomic_long_t nr_pmds;			/* PMD page table pages */
-	int map_count;				/* number of VMAs */
-
-	spinlock_t page_table_lock;		/* Protects page tables and some counters */
-	struct rw_semaphore mmap_sem;
-
-	struct list_head mmlist;		/* List of maybe swapped mm's.	These are globally strung
-						 * together off init_mm.mmlist, and are protected
-						 * by mmlist_lock
-						 */
-
-
-	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
-	unsigned long hiwater_vm;	/* High-water virtual memory usage */
-
-	unsigned long total_vm;		/* Total pages mapped */
-	unsigned long locked_vm;	/* Pages that have PG_mlocked set */
-	unsigned long pinned_vm;	/* Refcount permanently increased */
-	unsigned long shared_vm;	/* Shared pages (files) */
-	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
-	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
-	unsigned long def_flags;
-	unsigned long start_code, end_code, start_data, end_data;
-	unsigned long start_brk, brk, start_stack;
-	unsigned long arg_start, arg_end, env_start, env_end;
-
-	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
-
-	/*
-	 * Special counters, in some configurations protected by the
-	 * page_table_lock, in other configurations by being atomic.
-	 */
-	struct mm_rss_stat rss_stat;
-
-	struct linux_binfmt *binfmt;
-
-	cpumask_var_t cpu_vm_mask_var;
-
-	/* Architecture-specific MM context */
-	mm_context_t context;
-
-	unsigned long flags; /* Must use atomic bitops to access the bits */
-
-	struct core_state *core_state; /* coredumping support */
-#ifdef CONFIG_AIO
-	spinlock_t			ioctx_lock;
-	struct kioctx_table __rcu	*ioctx_table;
-#endif
-#ifdef CONFIG_MEMCG
-	/*
-	 * "owner" points to a task that is regarded as the canonical
-	 * user/owner of this mm. All of the following must be true in
-	 * order for it to be changed:
-	 *
-	 * current == mm->owner
-	 * current->mm != mm
-	 * new_owner->mm == mm
-	 * new_owner->alloc_lock is held
-	 */
-	struct task_struct __rcu *owner;
-#endif
-
-	/* store ref to file /proc/<pid>/exe symlink points to */
-	struct file *exe_file;
-#ifdef CONFIG_MMU_NOTIFIER
-	struct mmu_notifier_mm *mmu_notifier_mm;
-#endif
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
-	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
-#endif
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	struct cpumask cpumask_allocation;
-#endif
-#ifdef CONFIG_NUMA_BALANCING
-	/*
-	 * numa_next_scan is the next time that the PTEs will be marked
-	 * pte_numa. NUMA hinting faults will gather statistics and migrate
-	 * pages to new nodes if necessary.
-	 */
-	unsigned long numa_next_scan;
-
-	/* Restart point for scanning and setting pte_numa */
-	unsigned long numa_scan_offset;
-
-	/* numa_scan_seq prevents two threads setting pte_numa */
-	int numa_scan_seq;
-#endif
-#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
-	/*
-	 * An operation with batched TLB flushing is going on. Anything that
-	 * can move process memory needs to flush the TLB when moving a
-	 * PROT_NONE or PROT_NUMA mapped page.
-	 */
-	bool tlb_flush_pending;
-#endif
-	struct uprobes_state uprobes_state;
-#ifdef CONFIG_X86_INTEL_MPX
-	/* address of the bounds directory */
-	void __user *bd_addr;
-#endif
-};
-
-static inline void mm_init_cpumask(struct mm_struct *mm)
-{
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	mm->cpu_vm_mask_var = &mm->cpumask_allocation;
-#endif
-	cpumask_clear(mm->cpu_vm_mask_var);
-}
-
-/* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
-static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
-{
-	return mm->cpu_vm_mask_var;
-}
-
-#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
-/*
- * Memory barriers to keep this state in sync are graciously provided by
- * the page table locks, outside of which no page table modifications happen.
- * The barriers below prevent the compiler from re-ordering the instructions
- * around the memory barriers that are already present in the code.
- */
-static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
-{
-	barrier();
-	return mm->tlb_flush_pending;
-}
-static inline void set_tlb_flush_pending(struct mm_struct *mm)
-{
-	mm->tlb_flush_pending = true;
-
-	/*
-	 * Guarantee that the tlb_flush_pending store does not leak into the
-	 * critical section updating the page tables
-	 */
-	smp_mb__before_spinlock();
-}
-/* Clearing is done after a TLB flush, which also provides a barrier. */
-static inline void clear_tlb_flush_pending(struct mm_struct *mm)
-{
-	barrier();
-	mm->tlb_flush_pending = false;
-}
-#else
-static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
-{
-	return false;
-}
-static inline void set_tlb_flush_pending(struct mm_struct *mm)
-{
-}
-static inline void clear_tlb_flush_pending(struct mm_struct *mm)
-{
-}
-#endif
-
-struct vm_special_mapping
-{
+struct vm_special_mapping {
 	const char *name;
 	struct page **pages;
 };
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 95243d28a0ee..779e32567e6d 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/mm_types.h>
+#include <linux/mm_struct.h>
 #include <linux/srcu.h>
 
 struct mmu_notifier;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 22ee0d5d7f8c..99001775ffa0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -25,6 +25,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
+#include <linux/mm_struct.h>
 #include <linux/preempt_mask.h>
 
 #include <asm/page.h>
diff --git a/mm/init-mm.c b/mm/init-mm.c
index a56a851908d2..310ae8c7d9c6 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -1,4 +1,5 @@
 #include <linux/mm_types.h>
+#include <linux/mm_struct.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/spinlock.h>
diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
index cab58bb592d8..c40d065013d2 100644
--- a/mm/kmemcheck.c
+++ b/mm/kmemcheck.c
@@ -1,5 +1,4 @@
 #include <linux/gfp.h>
-#include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include "slab.h"
-- 
2.2.2

-- 
 Kirill A. Shutemov
