Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbbAHSta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:49:30 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63672 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbbAHStY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:49:24 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: leif.lindholm@linaro.org, roy.franz@linaro.org, matt.fleming@intel.com,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        bp@alien8.de, msalter@redhat.com, geoff.levand@linaro.org,
        dyoung@redhat.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 8/8] arm64/efi: remove idmap manipulations from UEFI code
Date: Thu,  8 Jan 2015 18:48:34 +0000
Message-Id: <1420742914-2404-9-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have moved the call to SetVirtualAddressMap() to the stub,
UEFI has no use for the ID map, so we can drop the code that installs
ID mappings for UEFI memory regions.

Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/efi.h |  2 --
 arch/arm64/include/asm/mmu.h |  2 --
 arch/arm64/kernel/efi.c      | 32 +-------------------------------
 arch/arm64/kernel/setup.c    |  1 -
 arch/arm64/mm/mmu.c          | 12 ------------
 5 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index effef3713c5a..7baf2cc04e1e 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -6,11 +6,9 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
-extern void efi_idmap_init(void);
 extern void efi_virtmap_init(void);
 #else
 #define efi_init()
-#define efi_idmap_init()
 #define efi_virtmap_init()
 #endif
 
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 5fd40c43be80..3d311761e3c2 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -31,8 +31,6 @@ extern void paging_init(void);
 extern void setup_mm_for_reboot(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
-/* create an identity mapping for memory (or io if map_io is true) */
-extern void create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot);
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 4a5d7343dddd..a98415b5979c 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -54,27 +54,6 @@ static int __init is_normal_ram(efi_memory_desc_t *md)
 	return 0;
 }
 
-static void __init efi_setup_idmap(void)
-{
-	struct memblock_region *r;
-	efi_memory_desc_t *md;
-	u64 paddr, npages, size;
-
-	for_each_memblock(memory, r)
-		create_id_mapping(r->base, r->size, 0);
-
-	/* map runtime io spaces */
-	for_each_efi_memory_desc(&memmap, md) {
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) || is_normal_ram(md))
-			continue;
-		paddr = md->phys_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-		create_id_mapping(paddr, size, 1);
-	}
-}
-
 /*
  * Translate a EFI virtual address into a physical address: this is necessary,
  * as some data members of the EFI system table are virtually remapped after
@@ -236,16 +215,6 @@ void __init efi_init(void)
 	reserve_regions();
 }
 
-void __init efi_idmap_init(void)
-{
-	if (!efi_enabled(EFI_BOOT))
-		return;
-
-	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
-	efi_setup_idmap();
-	early_memunmap(memmap.map, memmap.map_end - memmap.map);
-}
-
 /*
  * Enable the UEFI Runtime Services if all prerequisites are in place, i.e.,
  * non-early mapping of the UEFI system table and virtual mappings for all
@@ -386,4 +355,5 @@ void __init efi_virtmap_init(void)
 		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
 	}
 	set_bit(EFI_VIRTMAP, &efi.flags);
+	early_memunmap(memmap.map, memmap.map_end - memmap.map);
 }
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index beac8188fdbd..199d1b7809d7 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -402,7 +402,6 @@ void __init setup_arch(char **cmdline_p)
 	request_standard_resources();
 
 	efi_virtmap_init();
-	efi_idmap_init();
 	early_ioremap_reset();
 
 	unflatten_device_tree();
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 3f3d5aa4a8b1..328638548871 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -271,18 +271,6 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
 			 size, PAGE_KERNEL_EXEC);
 }
 
-void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
-{
-	if ((addr >> PGDIR_SHIFT) >= ARRAY_SIZE(idmap_pg_dir)) {
-		pr_warn("BUG: not creating id mapping for %pa\n", &addr);
-		return;
-	}
-	__create_mapping(&init_mm, &idmap_pg_dir[pgd_index(addr)],
-			 addr, addr, size,
-			 map_io ? __pgprot(PROT_DEVICE_nGnRE)
-				: PAGE_KERNEL_EXEC);
-}
-
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot)
-- 
1.8.3.2

