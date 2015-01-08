Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbbAHStY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:49:24 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:49437 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbbAHStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:49:20 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: leif.lindholm@linaro.org, roy.franz@linaro.org, matt.fleming@intel.com,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        bp@alien8.de, msalter@redhat.com, geoff.levand@linaro.org,
        dyoung@redhat.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 7/8] arm64/efi: remove free_boot_services() and friends
Date: Thu,  8 Jan 2015 18:48:33 +0000
Message-Id: <1420742914-2404-8-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we are calling SetVirtualAddressMap() from the stub, there is no
need to reserve boot-only memory regions, which implies that there is also
no reason to free them again later.

Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi.c | 123 +-----------------------------------------------
 1 file changed, 1 insertion(+), 122 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 755e545144ea..4a5d7343dddd 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -199,9 +199,7 @@ static __init void reserve_regions(void)
 		if (is_normal_ram(md))
 			early_init_dt_add_memory_arch(paddr, size);
 
-		if (is_reserve_region(md) ||
-		    md->type == EFI_BOOT_SERVICES_CODE ||
-		    md->type == EFI_BOOT_SERVICES_DATA) {
+		if (is_reserve_region(md)) {
 			memblock_reserve(paddr, size);
 			if (uefi_debug)
 				pr_cont("*");
@@ -214,123 +212,6 @@ static __init void reserve_regions(void)
 	set_bit(EFI_MEMMAP, &efi.flags);
 }
 
-
-static u64 __init free_one_region(u64 start, u64 end)
-{
-	u64 size = end - start;
-
-	if (uefi_debug)
-		pr_info("  EFI freeing: 0x%012llx-0x%012llx\n",	start, end - 1);
-
-	free_bootmem_late(start, size);
-	return size;
-}
-
-static u64 __init free_region(u64 start, u64 end)
-{
-	u64 map_start, map_end, total = 0;
-
-	if (end <= start)
-		return total;
-
-	map_start = (u64)memmap.phys_map;
-	map_end = PAGE_ALIGN(map_start + (memmap.map_end - memmap.map));
-	map_start &= PAGE_MASK;
-
-	if (start < map_end && end > map_start) {
-		/* region overlaps UEFI memmap */
-		if (start < map_start)
-			total += free_one_region(start, map_start);
-
-		if (map_end < end)
-			total += free_one_region(map_end, end);
-	} else
-		total += free_one_region(start, end);
-
-	return total;
-}
-
-static void __init free_boot_services(void)
-{
-	u64 total_freed = 0;
-	u64 keep_end, free_start, free_end;
-	efi_memory_desc_t *md;
-
-	/*
-	 * If kernel uses larger pages than UEFI, we have to be careful
-	 * not to inadvertantly free memory we want to keep if there is
-	 * overlap at the kernel page size alignment. We do not want to
-	 * free is_reserve_region() memory nor the UEFI memmap itself.
-	 *
-	 * The memory map is sorted, so we keep track of the end of
-	 * any previous region we want to keep, remember any region
-	 * we want to free and defer freeing it until we encounter
-	 * the next region we want to keep. This way, before freeing
-	 * it, we can clip it as needed to avoid freeing memory we
-	 * want to keep for UEFI.
-	 */
-
-	keep_end = 0;
-	free_start = 0;
-
-	for_each_efi_memory_desc(&memmap, md) {
-		u64 paddr, npages, size;
-
-		if (is_reserve_region(md)) {
-			/*
-			 * We don't want to free any memory from this region.
-			 */
-			if (free_start) {
-				/* adjust free_end then free region */
-				if (free_end > md->phys_addr)
-					free_end -= PAGE_SIZE;
-				total_freed += free_region(free_start, free_end);
-				free_start = 0;
-			}
-			keep_end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
-			continue;
-		}
-
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA) {
-			/* no need to free this region */
-			continue;
-		}
-
-		/*
-		 * We want to free memory from this region.
-		 */
-		paddr = md->phys_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-
-		if (free_start) {
-			if (paddr <= free_end)
-				free_end = paddr + size;
-			else {
-				total_freed += free_region(free_start, free_end);
-				free_start = paddr;
-				free_end = paddr + size;
-			}
-		} else {
-			free_start = paddr;
-			free_end = paddr + size;
-		}
-		if (free_start < keep_end) {
-			free_start += PAGE_SIZE;
-			if (free_start >= free_end)
-				free_start = 0;
-		}
-	}
-	if (free_start)
-		total_freed += free_region(free_start, free_end);
-
-	if (total_freed)
-		pr_info("Freed 0x%llx bytes of EFI boot services memory",
-			total_freed);
-}
-
 void __init efi_init(void)
 {
 	struct efi_fdt_params params;
@@ -402,8 +283,6 @@ static int __init arm64_enable_runtime_services(void)
 	}
 	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
-	free_boot_services();
-
 	if (!efi_enabled(EFI_VIRTMAP)) {
 		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
 		return -1;
-- 
1.8.3.2

