Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3BCPCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:02:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34583 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973Ab3BCO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:15 -0500
Message-Id: <20130203144653.313760856@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Matt Fleming <matt.fleming@intel.com>,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 105/128] efi: Make efi_enabled a function to query EFI facilities
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 83e68189745ad931c2afd45d8ee3303929233e7f upstream.

Originally 'efi_enabled' indicated whether a kernel was booted from
EFI firmware. Over time its semantics have changed, and it now
indicates whether or not we are booted on an EFI machine with
bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.

The immediate motivation for this patch is the bug report at,

    https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557

which details how running a platform driver on an EFI machine that is
designed to run under BIOS can cause the machine to become
bricked. Also, the following report,

    https://bugzilla.kernel.org/show_bug.cgi?id=47121

details how running said driver can also cause Machine Check
Exceptions. Drivers need a new means of detecting whether they're
running on an EFI machine, as sadly the expression,

    if (!efi_enabled)

hasn't been a sufficient condition for quite some time.

Users actually want to query 'efi_enabled' for different reasons -
what they really want access to is the list of available EFI
facilities.

For instance, the x86 reboot code needs to know whether it can invoke
the ResetSystem() function provided by the EFI runtime services, while
the ACPI OSL code wants to know whether the EFI config tables were
mapped successfully. There are also checks in some of the platform
driver code to simply see if they're running on an EFI machine (which
would make it a bad idea to do BIOS-y things).

This patch is a prereq for the samsung-laptop fix patch.

Cc: David Airlie <airlied@linux.ie>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Peter Jones <pjones@redhat.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Steve Langasek <steve.langasek@canonical.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[bwh: Backported to 3.2:
 - Adjust context (a lot)
 - Add efi_is_native() function from commit 5189c2a7c776
   ('x86: efi: Turn off efi_enabled after setup on mixed fw/kernel')
 - Make efi_init() bail out when booted non-native, as it would previously
   not be called in this case
 - Drop inapplicable changes to start_kernel()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -90,6 +90,7 @@ extern void __iomem *efi_ioremap(unsigne
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
+extern unsigned long x86_efi_facility;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern void efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -603,7 +603,7 @@ static void native_machine_emergency_res
 			break;
 
 		case BOOT_EFI:
-			if (efi_enabled)
+			if (efi_enabled(EFI_RUNTIME_SERVICES))
 				efi.reset_system(reboot_mode ?
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -750,15 +750,16 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-#ifdef CONFIG_X86_32
-		     "EL32",
-#else
-		     "EL64",
-#endif
-	 4)) {
-		efi_enabled = 1;
-		efi_memblock_x86_reserve_range();
+		     "EL32", 4)) {
+		set_bit(EFI_BOOT, &x86_efi_facility);
+	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+		     "EL64", 4)) {
+		set_bit(EFI_BOOT, &x86_efi_facility);
+		set_bit(EFI_64BIT, &x86_efi_facility);
 	}
+
+	if (efi_enabled(EFI_BOOT))
+		efi_memblock_x86_reserve_range();
 #endif
 
 	x86_init.oem.arch_setup();
@@ -831,7 +832,7 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
-	if (efi_enabled)
+	if (efi_enabled(EFI_BOOT))
 		efi_init();
 
 	dmi_scan_machine();
@@ -914,7 +915,7 @@ void __init setup_arch(char **cmdline_p)
 	 * The EFI specification says that boot service code won't be called
 	 * after ExitBootServices(). This is, in fact, a lie.
 	 */
-	if (efi_enabled)
+	if (efi_enabled(EFI_MEMMAP))
 		efi_reserve_boot_services();
 
 	/* preallocate 4k for mptable mpc */
@@ -1048,7 +1049,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+	if (!efi_enabled(EFI_BOOT) || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
 		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -49,9 +49,6 @@
 #define EFI_DEBUG	1
 #define PFX 		"EFI: "
 
-int efi_enabled;
-EXPORT_SYMBOL(efi_enabled);
-
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -70,9 +67,25 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+static inline bool efi_is_native(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
+}
+
+unsigned long x86_efi_facility;
+
+/*
+ * Returns 1 if 'facility' is enabled, 0 otherwise.
+ */
+int efi_enabled(int facility)
+{
+	return test_bit(facility, &x86_efi_facility) != 0;
+}
+EXPORT_SYMBOL(efi_enabled);
+
 static int __init setup_noefi(char *arg)
 {
-	efi_enabled = 0;
+	clear_bit(EFI_BOOT, &x86_efi_facility);
 	return 0;
 }
 early_param("noefi", setup_noefi);
@@ -440,6 +453,9 @@ void __init efi_init(void)
 	int i = 0;
 	void *tmp;
 
+	if (!efi_is_native())
+		return;
+
 #ifdef CONFIG_X86_32
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
 #else
@@ -467,6 +483,8 @@ void __init efi_init(void)
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
+	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
+
 	/*
 	 * Show what we know for posterity
 	 */
@@ -529,6 +547,8 @@ void __init efi_init(void)
 	early_iounmap(config_tables,
 			  efi.systab->nr_tables * sizeof(efi_config_table_t));
 
+	set_bit(EFI_CONFIG_TABLES, &x86_efi_facility);
+
 	/*
 	 * Check out the runtime services table. We need to map
 	 * the runtime services table so that we can grab the physical
@@ -552,6 +572,8 @@ void __init efi_init(void)
 		 * virtual mode.
 		 */
 		efi.get_time = phys_efi_get_time;
+
+		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	} else
 		printk(KERN_ERR "Could not map the EFI runtime service "
 		       "table!\n");
@@ -571,6 +593,8 @@ void __init efi_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+	set_bit(EFI_MEMMAP, &x86_efi_facility);
+
 #ifdef CONFIG_X86_32
 	x86_platform.get_wallclock = efi_get_time;
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
@@ -747,6 +771,7 @@ void __init efi_enter_virtual_mode(void)
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
+	clear_bit(EFI_MEMMAP, &x86_efi_facility);
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
 	kfree(new_memmap);
@@ -760,6 +785,9 @@ u32 efi_mem_type(unsigned long phys_addr
 	efi_memory_desc_t *md;
 	void *p;
 
+	if (!efi_enabled(EFI_MEMMAP))
+		return 0;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -255,7 +255,7 @@ acpi_physical_address __init acpi_os_get
 		return acpi_rsdp;
 #endif
 
-	if (efi_enabled) {
+	if (efi_enabled(EFI_CONFIG_TABLES)) {
 		if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
 			return efi.acpi20;
 		else if (efi.acpi != EFI_INVALID_TABLE_ADDR)
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -432,7 +432,7 @@ void __init dmi_scan_machine(void)
 	char __iomem *p, *q;
 	int rc;
 
-	if (efi_enabled) {
+	if (efi_enabled(EFI_CONFIG_TABLES)) {
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
 			goto error;
 
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1222,7 +1222,7 @@ efivars_init(void)
 	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
 	       EFIVARS_DATE);
 
-	if (!efi_enabled)
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return 0;
 
 	/* For now we'll register the efi directory at /sys/firmware/efi */
@@ -1260,7 +1260,7 @@ err_put:
 static void __exit
 efivars_exit(void)
 {
-	if (efi_enabled) {
+	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
 		unregister_efivars(&__efivars);
 		kobject_put(efi_kobj);
 	}
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -99,7 +99,7 @@ unsigned long __init find_ibft_region(un
 	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
 	 * only use ACPI for this */
 
-	if (!efi_enabled)
+	if (!efi_enabled(EFI_BOOT))
 		find_ibft_in_mem();
 
 	if (ibft_addr) {
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -354,7 +354,8 @@ bool radeon_card_posted(struct radeon_de
 {
 	uint32_t reg;
 
-	if (efi_enabled && rdev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE)
+	if (efi_enabled(EFI_BOOT) &&
+	    rdev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE)
 		return false;
 
 	/* first check CRTCs */
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -255,7 +255,7 @@ static int __init ibm_rtl_init(void) {
 	if (force)
 		pr_warn("module loaded by force\n");
 	/* first ensure that we are running on IBM HW */
-	else if (efi_enabled || !dmi_check_system(ibm_rtl_dmi_table))
+	else if (efi_enabled(EFI_BOOT) || !dmi_check_system(ibm_rtl_dmi_table))
 		return -ENODEV;
 
 	/* Get the address for the Extended BIOS Data Area */
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -459,7 +459,7 @@ static int __devinit isci_pci_probe(stru
 		return -ENOMEM;
 	pci_set_drvdata(pdev, pci_info);
 
-	if (efi_enabled)
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		orom = isci_get_efi_var(pdev);
 
 	if (!orom)
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -364,17 +364,30 @@ extern int __init efi_setup_pcdp_console
 #endif
 
 /*
- * We play games with efi_enabled so that the compiler will, if possible, remove
- * EFI-related code altogether.
+ * We play games with efi_enabled so that the compiler will, if
+ * possible, remove EFI-related code altogether.
  */
+#define EFI_BOOT		0	/* Were we booted from EFI? */
+#define EFI_SYSTEM_TABLES	1	/* Can we use EFI system tables? */
+#define EFI_CONFIG_TABLES	2	/* Can we use EFI config tables? */
+#define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
+#define EFI_MEMMAP		4	/* Can we use EFI memory map? */
+#define EFI_64BIT		5	/* Is the firmware 64-bit? */
+
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-   extern int efi_enabled;
+extern int efi_enabled(int facility);
 # else
-#  define efi_enabled 1
+static inline int efi_enabled(int facility)
+{
+	return 1;
+}
 # endif
 #else
-# define efi_enabled 0
+static inline int efi_enabled(int facility)
+{
+	return 0;
+}
 #endif
 
 /*
--- a/init/main.c
+++ b/init/main.c
@@ -606,7 +606,7 @@ asmlinkage void __init start_kernel(void
 	pidmap_init();
 	anon_vma_init();
 #ifdef CONFIG_X86
-	if (efi_enabled)
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
 #endif
 	thread_info_cache_init();


