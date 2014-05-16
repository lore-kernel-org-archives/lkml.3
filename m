Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaEPUos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:44:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16562 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaEPUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:43:35 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, eshelton@pobox.com,
        hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com,
        jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Date: Fri, 16 May 2014 22:41:40 +0200
Message-Id: <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce EFI_DIRECT flag. If it is set this means that Linux
Kernel has direct access to EFI infrastructure. If not then
kernel runs on EFI platform but it has not direct control
on EFI stuff. This functionality is used in Xen dom0.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/kernel/setup.c     |    2 ++
 arch/x86/platform/efi/efi.c |   58 ++++++++++++++++++++++++++++++++-----------
 include/linux/efi.h         |   13 +++++-----
 3 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 09c76d2..f41f648 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -926,9 +926,11 @@ void __init setup_arch(char **cmdline_p)
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL32", 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
+		set_bit(EFI_DIRECT, &efi.flags);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL64", 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
+		set_bit(EFI_DIRECT, &efi.flags);
 		set_bit(EFI_64BIT, &efi.flags);
 	}
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3781dd3..7fcef06 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -352,6 +352,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	struct efi_info *e = &boot_params.efi_info;
 	unsigned long pmap;
 
+	if (!efi_enabled(EFI_DIRECT))
+		return 0;
+
 #ifdef CONFIG_X86_32
 	/* Can't handle data above 4GB at this time */
 	if (e->efi_memmap_hi) {
@@ -457,6 +460,21 @@ void __init efi_free_boot_services(void)
 	efi_unmap_memmap();
 }
 
+static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
+							unsigned long size)
+{
+	if (efi_enabled(EFI_DIRECT))
+		return early_ioremap(phys_addr, size);
+
+	return (__force void __iomem *)phys_addr;
+}
+
+static void __init efi_early_iounmap(void __iomem *addr, unsigned long size)
+{
+	if (efi_enabled(EFI_DIRECT))
+		early_iounmap(addr, size);
+}
+
 static int __init efi_systab_init(void *phys)
 {
 	if (efi_enabled(EFI_64BIT)) {
@@ -469,8 +487,8 @@ static int __init efi_systab_init(void *phys)
 			if (!data)
 				return -ENOMEM;
 		}
-		systab64 = early_ioremap((unsigned long)phys,
-					 sizeof(*systab64));
+		systab64 = efi_early_ioremap((unsigned long)phys,
+							sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
 			if (data)
@@ -506,7 +524,7 @@ static int __init efi_systab_init(void *phys)
 					   systab64->tables;
 		tmp |= data ? data->tables : systab64->tables;
 
-		early_iounmap(systab64, sizeof(*systab64));
+		efi_early_iounmap(systab64, sizeof(*systab64));
 		if (data)
 			early_iounmap(data, sizeof(*data));
 #ifdef CONFIG_X86_32
@@ -518,8 +536,8 @@ static int __init efi_systab_init(void *phys)
 	} else {
 		efi_system_table_32_t *systab32;
 
-		systab32 = early_ioremap((unsigned long)phys,
-					 sizeof(*systab32));
+		systab32 = efi_early_ioremap((unsigned long)phys,
+							sizeof(*systab32));
 		if (systab32 == NULL) {
 			pr_err("Couldn't map the system table!\n");
 			return -ENOMEM;
@@ -539,7 +557,7 @@ static int __init efi_systab_init(void *phys)
 		efi_systab.nr_tables = systab32->nr_tables;
 		efi_systab.tables = systab32->tables;
 
-		early_iounmap(systab32, sizeof(*systab32));
+		efi_early_iounmap(systab32, sizeof(*systab32));
 	}
 
 	efi.systab = &efi_systab;
@@ -619,13 +637,16 @@ static int __init efi_runtime_init(void)
 	 * address of several of the EFI runtime functions, needed to
 	 * set the firmware into virtual mode.
 	 */
-	if (efi_enabled(EFI_64BIT))
-		rv = efi_runtime_init64();
-	else
-		rv = efi_runtime_init32();
 
-	if (rv)
-		return rv;
+	if (efi_enabled(EFI_DIRECT)) {
+		if (efi_enabled(EFI_64BIT))
+			rv = efi_runtime_init64();
+		else
+			rv = efi_runtime_init32();
+
+		if (rv)
+			return rv;
+	}
 
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
@@ -634,6 +655,9 @@ static int __init efi_runtime_init(void)
 
 static int __init efi_memmap_init(void)
 {
+	if (!efi_enabled(EFI_DIRECT))
+		return 0;
+
 	/* Map the EFI memory map */
 	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
@@ -739,14 +763,14 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
+	c16 = tmp = efi_early_ioremap(efi.systab->fw_vendor, 2);
 	if (c16) {
 		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
 		pr_err("Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
+	efi_early_iounmap(tmp, 2);
 
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
@@ -1187,6 +1211,9 @@ static void __init __efi_enter_virtual_mode(void)
 
 void __init efi_enter_virtual_mode(void)
 {
+	if (!efi_enabled(EFI_DIRECT))
+		return;
+
 	if (efi_setup)
 		kexec_enter_virtual_mode();
 	else
@@ -1219,6 +1246,9 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	efi_memory_desc_t *md;
 	void *p;
 
+	if (!efi_enabled(EFI_MEMMAP))
+		return 0;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6c100ff..4113c4e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -893,12 +893,13 @@ extern int __init efi_setup_pcdp_console(char *);
  * possible, remove EFI-related code altogether.
  */
 #define EFI_BOOT		0	/* Were we booted from EFI? */
-#define EFI_SYSTEM_TABLES	1	/* Can we use EFI system tables? */
-#define EFI_CONFIG_TABLES	2	/* Can we use EFI config tables? */
-#define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
-#define EFI_MEMMAP		4	/* Can we use EFI memory map? */
-#define EFI_64BIT		5	/* Is the firmware 64-bit? */
-#define EFI_ARCH_1		6	/* First arch-specific bit */
+#define EFI_DIRECT		1	/* Can we access EFI directly? */
+#define EFI_SYSTEM_TABLES	2	/* Can we use EFI system tables? */
+#define EFI_CONFIG_TABLES	3	/* Can we use EFI config tables? */
+#define EFI_RUNTIME_SERVICES	4	/* Can we use runtime services? */
+#define EFI_MEMMAP		5	/* Can we use EFI memory map? */
+#define EFI_64BIT		6	/* Is the firmware 64-bit? */
+#define EFI_ARCH_1		7	/* First arch-specific bit */
 
 #ifdef CONFIG_EFI
 /*
-- 
1.7.10.4

