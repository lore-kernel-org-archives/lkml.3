Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaIMSiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:38:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:60268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaIMSh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,518,1406617200"; 
   d="scan'208";a="590897166"
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 4/6] x86/efi: remove __init attribute from memory mapping functions
Date: Sat, 13 Sep 2014 11:36:14 -0700
Message-Id: <1410633376-8822-5-git-send-email-ricardo.neri-calderon@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though these functions are called at kernel boot, they will
also be used by the page fault handler to fixup access to BOOT_SERVICES_*
regions, which do not have the __init attribute.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 arch/x86/include/asm/efi.h     | 4 ++--
 arch/x86/platform/efi/efi.c    | 2 +-
 arch/x86/platform/efi/efi_32.c | 2 +-
 arch/x86/platform/efi/efi_64.c | 8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 044a2fd..d427a35 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -94,12 +94,12 @@ extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
-extern void __init efi_map_region(efi_memory_desc_t *md);
+extern void efi_map_region(efi_memory_desc_t *md);
 extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
-extern void __init old_map_region(efi_memory_desc_t *md);
+extern void old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
 extern void __init efi_dump_pagetable(void);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2e78083..fd52004 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -547,7 +547,7 @@ void efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
-void __init old_map_region(efi_memory_desc_t *md)
+void old_map_region(efi_memory_desc_t *md)
 {
 	u64 start_pfn, end_pfn, end;
 	unsigned long size;
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 9ee3491..766dcaf 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -47,7 +47,7 @@ int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 }
 void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages) {}
 
-void __init efi_map_region(efi_memory_desc_t *md)
+void efi_map_region(efi_memory_desc_t *md)
 {
 	old_map_region(md);
 }
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 290d397..32434ed 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -199,7 +199,7 @@ void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	kernel_unmap_pages_in_pgd(pgd, pa_memmap, num_pages);
 }
 
-static void __init __map_region(efi_memory_desc_t *md, u64 va)
+static void  __map_region(efi_memory_desc_t *md, u64 va)
 {
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
 	unsigned long pf = 0;
@@ -212,7 +212,7 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 			   md->phys_addr, va);
 }
 
-void __init efi_map_region(efi_memory_desc_t *md)
+void efi_map_region(efi_memory_desc_t *md)
 {
 	unsigned long size = md->num_pages << PAGE_SHIFT;
 	u64 pa = md->phys_addr;
@@ -273,8 +273,8 @@ void __init efi_map_region_fixed(efi_memory_desc_t *md)
 	__map_region(md, md->virt_addr);
 }
 
-void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-				 u32 type, u64 attribute)
+void __iomem *efi_ioremap(unsigned long phys_addr, unsigned long size,
+			  u32 type, u64 attribute)
 {
 	unsigned long last_map_pfn;
 
-- 
1.9.1

