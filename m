Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3LPJbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:31:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab3LPJbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:31:43 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
Subject: [PATCH v6 02/14] efi: Use early_memremap and early_memunmap to fix sparse warnings
Date: Mon, 16 Dec 2013 17:30:23 +0800
Message-Id: <1387186235-15972-3-git-send-email-dyoung@redhat.com>
In-Reply-To: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a lot of sparse warnings for early_memremap and early_ioummap
in arch/x86/platform/efi/efi.c and drivers/firmware/efi/efi.c.

early_memremap is for mapping kernel memory instead of io memory, but
the early_memremap returns void __iomem pointer and early_iounmap accepts
__iomem pointer as argument. Sparse checking is not happy with the mismatch.

Also there's several early_ioremap callbacks which need to be changed to
early_memremap because they are actually mapping kernel memory.

Previous patch fixed the early_memremap function to return a normal pointer
instead of __iomem pointer. Also introduced a new function early_memunmap
which accept normal pointer as the argument.

This patch is fixing the sparse warnings as below:
1. use early_memremap instead of early_ioremap
2. use early_memunmap instead of early_iounmap

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 20 ++++++++++----------
 drivers/firmware/efi/efi.c  |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f8ec4da..ef471d5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -456,7 +456,7 @@ void __init efi_unmap_memmap(void)
 {
 	clear_bit(EFI_MEMMAP, &x86_efi_facility);
 	if (memmap.map) {
-		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+		early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
 		memmap.map = NULL;
 	}
 }
@@ -493,7 +493,7 @@ static int __init efi_systab_init(void *phys)
 		efi_system_table_64_t *systab64;
 		u64 tmp = 0;
 
-		systab64 = early_ioremap((unsigned long)phys,
+		systab64 = early_memremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
@@ -524,7 +524,7 @@ static int __init efi_systab_init(void *phys)
 		efi_systab.tables = systab64->tables;
 		tmp |= systab64->tables;
 
-		early_iounmap(systab64, sizeof(*systab64));
+		early_memunmap(systab64, sizeof(*systab64));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");
@@ -534,7 +534,7 @@ static int __init efi_systab_init(void *phys)
 	} else {
 		efi_system_table_32_t *systab32;
 
-		systab32 = early_ioremap((unsigned long)phys,
+		systab32 = early_memremap((unsigned long)phys,
 					 sizeof(*systab32));
 		if (systab32 == NULL) {
 			pr_err("Couldn't map the system table!\n");
@@ -555,7 +555,7 @@ static int __init efi_systab_init(void *phys)
 		efi_systab.nr_tables = systab32->nr_tables;
 		efi_systab.tables = systab32->tables;
 
-		early_iounmap(systab32, sizeof(*systab32));
+		early_memunmap(systab32, sizeof(*systab32));
 	}
 
 	efi.systab = &efi_systab;
@@ -586,7 +586,7 @@ static int __init efi_runtime_init(void)
 	 * address of several of the EFI runtime functions, needed to
 	 * set the firmware into virtual mode.
 	 */
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+	runtime = early_memremap((unsigned long)efi.systab->runtime,
 				sizeof(efi_runtime_services_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
@@ -606,7 +606,7 @@ static int __init efi_runtime_init(void)
 	 * virtual mode.
 	 */
 	efi.get_time = phys_efi_get_time;
-	early_iounmap(runtime, sizeof(efi_runtime_services_t));
+	early_memunmap(runtime, sizeof(efi_runtime_services_t));
 
 	return 0;
 }
@@ -614,7 +614,7 @@ static int __init efi_runtime_init(void)
 static int __init efi_memmap_init(void)
 {
 	/* Map the EFI memory map */
-	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
+	memmap.map = early_memremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
 	if (memmap.map == NULL) {
 		pr_err("Could not map the memory map!\n");
@@ -656,14 +656,14 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
+	c16 = tmp = early_memremap(efi.systab->fw_vendor, 2);
 	if (c16) {
 		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
 		pr_err("Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
+	early_memunmap(tmp, 2);
 
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 2e2fbde..b716a66 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -253,7 +253,7 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
+				early_memunmap(config_tables,
 					       efi.systab->nr_tables * sz);
 				return -EINVAL;
 			}
@@ -269,6 +269,6 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	early_memunmap(config_tables, efi.systab->nr_tables * sz);
 	return 0;
 }
-- 
1.8.3.1

