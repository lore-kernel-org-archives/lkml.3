Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaDDStj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:49:39 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62974 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaDDSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:45:59 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 04/10] arm64: Add function to create identity mappings
Date: Fri,  4 Apr 2014 19:45:07 +0100
Message-Id: <1396637113-22790-5-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

At boot time, before switching to a virtual UEFI memory map, firmware
expects UEFI memory and IO regions to be identity mapped whenever
kernel makes runtime services calls. The existing early boot code
creates an identity map of kernel text/data but this is not sufficient
for UEFI. This patch adds a create_id_mapping() function which reuses
the core code of the existing create_mapping().

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/mmu.h |    2 ++
 arch/arm64/mm/mmu.c          |   65 ++++++++++++++++++++++++++++++------------
 2 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index f600d40..29ed1d8 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -28,5 +28,7 @@ extern void paging_init(void);
 extern void setup_mm_for_reboot(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
+/* create an identity mapping for memory (or io if map_io is true) */
+extern void create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io);
 
 #endif
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6b7e895..357956a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -168,7 +168,8 @@ static void __init *early_alloc(unsigned long sz)
 }
 
 static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
-				  unsigned long end, unsigned long pfn)
+				  unsigned long end, unsigned long pfn,
+				  pgprot_t prot)
 {
 	pte_t *pte;
 
@@ -180,16 +181,28 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
-		set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
+		set_pte(pte, pfn_pte(pfn, prot));
 		pfn++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
 static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
-				  unsigned long end, phys_addr_t phys)
+				  unsigned long end, phys_addr_t phys,
+				  int map_io)
 {
 	pmd_t *pmd;
 	unsigned long next;
+	pmdval_t prot_sect;
+	pgprot_t prot_pte;
+
+	if (map_io) {
+		prot_sect = PMD_TYPE_SECT | PMD_SECT_AF |
+			    PMD_ATTRINDX(MT_DEVICE_nGnRE);
+		prot_pte = __pgprot(PROT_DEVICE_nGnRE);
+	} else {
+		prot_sect = prot_sect_kernel;
+		prot_pte = PAGE_KERNEL_EXEC;
+	}
 
 	/*
 	 * Check for initial section mappings in the pgd/pud and remove them.
@@ -205,7 +218,7 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 		/* try section mapping first */
 		if (((addr | next | phys) & ~SECTION_MASK) == 0) {
 			pmd_t old_pmd =*pmd;
-			set_pmd(pmd, __pmd(phys | prot_sect_kernel));
+			set_pmd(pmd, __pmd(phys | prot_sect));
 			/*
 			 * Check for previous table entries created during
 			 * boot (__create_page_tables) and flush them.
@@ -213,21 +226,23 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 			if (!pmd_none(old_pmd))
 				flush_tlb_all();
 		} else {
-			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys));
+			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
+				       prot_pte);
 		}
 		phys += next - addr;
 	} while (pmd++, addr = next, addr != end);
 }
 
 static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
-				  unsigned long end, unsigned long phys)
+				  unsigned long end, unsigned long phys,
+				  int map_io)
 {
 	pud_t *pud = pud_offset(pgd, addr);
 	unsigned long next;
 
 	do {
 		next = pud_addr_end(addr, end);
-		alloc_init_pmd(pud, addr, next, phys);
+		alloc_init_pmd(pud, addr, next, phys, map_io);
 		phys += next - addr;
 	} while (pud++, addr = next, addr != end);
 }
@@ -236,30 +251,44 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
  * Create the page directory entries and any necessary page tables for the
  * mapping specified by 'md'.
  */
-static void __init create_mapping(phys_addr_t phys, unsigned long virt,
-				  phys_addr_t size)
+static void __init __create_mapping(pgd_t *pgd, phys_addr_t phys,
+				    unsigned long virt, phys_addr_t size,
+				    int map_io)
 {
 	unsigned long addr, length, end, next;
-	pgd_t *pgd;
-
-	if (virt < VMALLOC_START) {
-		pr_warning("BUG: not creating mapping for 0x%016llx at 0x%016lx - outside kernel range\n",
-			   phys, virt);
-		return;
-	}
 
 	addr = virt & PAGE_MASK;
 	length = PAGE_ALIGN(size + (virt & ~PAGE_MASK));
 
-	pgd = pgd_offset_k(addr);
 	end = addr + length;
 	do {
 		next = pgd_addr_end(addr, end);
-		alloc_init_pud(pgd, addr, next, phys);
+		alloc_init_pud(pgd, addr, next, phys, map_io);
 		phys += next - addr;
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void __init create_mapping(phys_addr_t phys, unsigned long virt,
+				  phys_addr_t size)
+{
+	if (virt < VMALLOC_START) {
+		pr_warn("BUG: not creating mapping for 0x%016llx at 0x%016lx - outside kernel range\n",
+			phys, virt);
+		return;
+	}
+	__create_mapping(pgd_offset_k(virt & PAGE_MASK), phys, virt, size, 0);
+}
+
+void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
+{
+	if ((addr >> PGDIR_SHIFT) >= ARRAY_SIZE(idmap_pg_dir)) {
+		pr_warn("BUG: not creating id mapping for 0x%016llx\n", addr);
+		return;
+	}
+	__create_mapping(&idmap_pg_dir[pgd_index(addr)],
+			 addr, addr, size, map_io);
+}
+
 static void __init map_mem(void)
 {
 	struct memblock_region *reg;
-- 
1.7.10.4

