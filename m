Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaIMSin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:38:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:65346 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaIMSh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,518,1406617200"; 
   d="scan'208";a="590897164"
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 2/6] x86/efi: use efi_memory_descriptor in convenience functions
Date: Sat, 13 Sep 2014 11:36:12 -0700
Message-Id: <1410633376-8822-3-git-send-email-ricardo.neri-calderon@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than duplicating the code to lookup for the memory descriptor of
a given physical address, use the utility function efi_memory_descriptor.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 26 ++++++--------------------
 drivers/firmware/efi/efi.c  | 36 +++++++++++++++---------------------
 2 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 782d617..d45decf 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -924,36 +924,22 @@ efi_memory_desc_t *efi_memory_descriptor(unsigned long phys_addr)
 u32 efi_mem_type(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
-	if (!efi_enabled(EFI_MEMMAP))
-		return 0;
+	md = efi_memory_descriptor(phys_addr);
+	if (md)
+		return md->type;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->type;
-	}
 	return 0;
 }
 
 u64 efi_mem_attributes(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
-	if (!efi_enabled(EFI_MEMMAP))
-		return 0;
+	md = efi_memory_descriptor(phys_addr);
+	if (md)
+		return md->attribute;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->attribute;
-	}
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 64ecbb5..29c85fe 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -206,29 +206,23 @@ subsys_initcall(efisubsys_init);
  */
 void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
 {
-	struct efi_memory_map *map;
-	void *p;
-	map = efi.memmap;
-	if (!map)
+	efi_memory_desc_t *md;
+
+	md = efi_memory_descriptor(phys_addr);
+
+	if (!md)
 		return NULL;
-	if (WARN_ON(!map->map))
+
+	if (!md->virt_addr)
 		return NULL;
-	for (p = map->map; p < map->map_end; p += map->desc_size) {
-		efi_memory_desc_t *md = p;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
-		u64 end = md->phys_addr + size;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-		if (!md->virt_addr)
-			continue;
-		if (phys_addr >= md->phys_addr && phys_addr < end) {
-			phys_addr += md->virt_addr - md->phys_addr;
-			return (__force void __iomem *)(unsigned long)phys_addr;
-		}
-	}
-	return NULL;
+
+	if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+	    md->type != EFI_BOOT_SERVICES_CODE &&
+	    md->type != EFI_BOOT_SERVICES_DATA)
+		return NULL;
+
+	phys_addr += md->virt_addr - md->phys_addr;
+	return (__force void __iomem *)(unsigned long)phys_addr;
 }
 
 static __initdata efi_config_table_type_t common_tables[] = {
-- 
1.9.1

