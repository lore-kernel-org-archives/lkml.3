Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3GVJCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:02:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab3GVJCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:02:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.17
Date: Mon, 22 Jul 2013 10:02:12 +0100
Message-Id: <1374483732-9596-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374483732-9596-1-git-send-email-luis.henriques@canonical.com>
References: <1374483732-9596-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/i2c/busses/i2c-piix4 b/Documentation/i2c/busses/i2c-piix4
index 475bb4a..65da157 100644
--- a/Documentation/i2c/busses/i2c-piix4
+++ b/Documentation/i2c/busses/i2c-piix4
@@ -8,7 +8,7 @@ Supported adapters:
     Datasheet: Only available via NDA from ServerWorks
   * ATI IXP200, IXP300, IXP400, SB600, SB700 and SB800 southbridges
     Datasheet: Not publicly available
-  * AMD Hudson-2
+  * AMD Hudson-2, CZ
     Datasheet: Not publicly available
   * Standard Microsystems (SMSC) SLC90E66 (Victory66) southbridge
     Datasheet: Publicly available at the SMSC website http://www.smsc.com
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 912785c..b5576c6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -791,6 +791,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
+	efi_no_storage_paranoia [EFI; X86]
+			Using this parameter you can use more than 50% of
+			your efi variable storage. Use this parameter only if
+			you are really sure that your UEFI does sane gc and
+			fulfills the spec otherwise your board may brick.
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/Makefile b/Makefile
index 058db1d..c94eb01 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .16
+EXTRAVERSION = .17
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 952a5a7..55790a5 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -824,6 +824,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	struct frame_tail __user *tail;
 
 
+	perf_callchain_store(entry, regs->ARM_pc);
 	tail = (struct frame_tail __user *)regs->ARM_fp - 1;
 
 	while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 389bd4f..5c9eccc 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -76,7 +76,7 @@
 #endif
 
 int boot_cpuid = 0;
-int __initdata spinning_secondaries;
+int spinning_secondaries;
 u64 ppc64_pft_size;
 
 /* Pick defaults since we might want to patch instructions
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 75772ae..361810f 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -514,8 +514,9 @@ generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 			     unsigned long *size, mtrr_type *type)
 {
-	unsigned int mask_lo, mask_hi, base_lo, base_hi;
-	unsigned int tmp, hi;
+	u32 mask_lo, mask_hi, base_lo, base_hi;
+	unsigned int hi;
+	u64 tmp, mask;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could be called
@@ -536,18 +537,18 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	rdmsr(MTRRphysBase_MSR(reg), base_lo, base_hi);
 
 	/* Work out the shifted address mask: */
-	tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
-	mask_lo = size_or_mask | tmp;
+	tmp = (u64)mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
+	mask = size_or_mask | tmp;
 
 	/* Expand tmp with high bits to all 1s: */
-	hi = fls(tmp);
+	hi = fls64(tmp);
 	if (hi > 0) {
-		tmp |= ~((1<<(hi - 1)) - 1);
+		tmp |= ~((1ULL<<(hi - 1)) - 1);
 
-		if (tmp != mask_lo) {
+		if (tmp != mask) {
 			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
 			add_taint(TAINT_FIRMWARE_WORKAROUND);
-			mask_lo = tmp;
+			mask = tmp;
 		}
 	}
 
@@ -555,8 +556,8 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	 * This works correctly if size is a power of two, i.e. a
 	 * contiguous range:
 	 */
-	*size = -mask_lo;
-	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
+	*size = -mask;
+	*base = (u64)base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
 	*type = base_lo & 0xff;
 
 out_put_cpu:
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6b96110..87f918e 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -305,7 +305,8 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 		return -EINVAL;
 	}
 
-	if (base & size_or_mask || size & size_or_mask) {
+	if ((base | (base + size - 1)) >>
+	    (boot_cpu_data.x86_phys_bits - PAGE_SHIFT)) {
 		pr_warning("mtrr: base or size exceeds the MTRR width\n");
 		return -EINVAL;
 	}
@@ -583,6 +584,7 @@ static struct syscore_ops mtrr_syscore_ops = {
 
 int __initdata changed_by_mtrr_cleanup;
 
+#define SIZE_OR_MASK_BITS(n)  (~((1ULL << ((n) - PAGE_SHIFT)) - 1))
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
  *
@@ -600,7 +602,7 @@ void __init mtrr_bp_init(void)
 
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
-		size_or_mask = 0xff000000;			/* 36 bits */
+		size_or_mask = SIZE_OR_MASK_BITS(36);
 		size_and_mask = 0x00f00000;
 		phys_addr = 36;
 
@@ -619,7 +621,7 @@ void __init mtrr_bp_init(void)
 			     boot_cpu_data.x86_mask == 0x4))
 				phys_addr = 36;
 
-			size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
+			size_or_mask = SIZE_OR_MASK_BITS(phys_addr);
 			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
 		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
 			   boot_cpu_data.x86 == 6) {
@@ -627,7 +629,7 @@ void __init mtrr_bp_init(void)
 			 * VIA C* family have Intel style MTRRs,
 			 * but don't support PAE
 			 */
-			size_or_mask = 0xfff00000;		/* 32 bits */
+			size_or_mask = SIZE_OR_MASK_BITS(32);
 			size_and_mask = 0;
 			phys_addr = 32;
 		}
@@ -637,21 +639,21 @@ void __init mtrr_bp_init(void)
 			if (cpu_has_k6_mtrr) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
 				mtrr_if = mtrr_ops[X86_VENDOR_AMD];
-				size_or_mask = 0xfff00000;	/* 32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CENTAUR:
 			if (cpu_has_centaur_mcr) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CENTAUR];
-				size_or_mask = 0xfff00000;	/* 32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CYRIX:
 			if (cpu_has_cyrix_arr) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CYRIX];
-				size_or_mask = 0xfff00000;	/* 32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 1e40637..ca4e1ad 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -50,6 +50,13 @@
 
 #define EFI_DEBUG	1
 
+#define EFI_MIN_RESERVE 5120
+
+#define EFI_DUMMY_GUID \
+	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
+
+static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
+
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -102,6 +109,15 @@ static int __init setup_add_efi_memmap(char *arg)
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
 
+static bool efi_no_storage_paranoia;
+
+static int __init setup_storage_paranoia(char *arg)
+{
+	efi_no_storage_paranoia = true;
+	return 0;
+}
+early_param("efi_no_storage_paranoia", setup_storage_paranoia);
+
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
@@ -927,6 +943,13 @@ void __init efi_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
 
 	kfree(new_memmap);
+
+	/* clean DUMMY object */
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+			 EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS,
+			 0, NULL);
 }
 
 /*
@@ -964,3 +987,85 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
+
+/*
+ * Some firmware has serious problems when using more than 50% of the EFI
+ * variable store, i.e. it triggers bugs that can brick machines. Ensure that
+ * we never use more than this safe limit.
+ *
+ * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
+ * store.
+ */
+efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	efi_status_t status;
+	u64 storage_size, remaining_size, max_size;
+
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return 0;
+
+	status = efi.query_variable_info(attributes, &storage_size,
+					 &remaining_size, &max_size);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	/*
+	 * Some firmware implementations refuse to boot if there's insufficient
+	 * space in the variable store. We account for that by refusing the
+	 * write if permitting it would reduce the available space to under
+	 * 5KB. This figure was provided by Samsung, so should be safe.
+	 */
+	if ((remaining_size - size < EFI_MIN_RESERVE) &&
+		!efi_no_storage_paranoia) {
+
+		/*
+		 * Triggering garbage collection may require that the firmware
+		 * generate a real EFI_OUT_OF_RESOURCES error. We can force
+		 * that by attempting to use more space than is available.
+		 */
+		unsigned long dummy_size = remaining_size + 1024;
+		void *dummy = kzalloc(dummy_size, GFP_ATOMIC);
+
+		if (!dummy)
+			return EFI_OUT_OF_RESOURCES;
+
+		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					  EFI_VARIABLE_NON_VOLATILE |
+					  EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					  EFI_VARIABLE_RUNTIME_ACCESS,
+					  dummy_size, dummy);
+
+		if (status == EFI_SUCCESS) {
+			/*
+			 * This should have failed, so if it didn't make sure
+			 * that we delete it...
+			 */
+			efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					 EFI_VARIABLE_NON_VOLATILE |
+					 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					 EFI_VARIABLE_RUNTIME_ACCESS,
+					 0, dummy);
+		}
+
+		kfree(dummy);
+
+		/*
+		 * The runtime code may now have triggered a garbage collection
+		 * run, so check the variable info again
+		 */
+		status = efi.query_variable_info(attributes, &storage_size,
+						 &remaining_size, &max_size);
+
+		if (status != EFI_SUCCESS)
+			return status;
+
+		/*
+		 * There still isn't enough room, so return an error
+		 */
+		if (remaining_size - size < EFI_MIN_RESERVE)
+			return EFI_OUT_OF_RESOURCES;
+	}
+
+	return EFI_SUCCESS;
+}
+EXPORT_SYMBOL_GPL(efi_query_variable_store);
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 054cc01..d50a821 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -36,9 +36,8 @@ static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
 /* snapshots of runstate info */
 static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate_snapshot);
 
-/* unused ns of stolen and blocked time */
+/* unused ns of stolen time */
 static DEFINE_PER_CPU(u64, xen_residual_stolen);
-static DEFINE_PER_CPU(u64, xen_residual_blocked);
 
 /* return an consistent snapshot of 64-bit time/counter value */
 static u64 get64(const u64 *p)
@@ -115,7 +114,7 @@ static void do_stolen_accounting(void)
 {
 	struct vcpu_runstate_info state;
 	struct vcpu_runstate_info *snap;
-	s64 blocked, runnable, offline, stolen;
+	s64 runnable, offline, stolen;
 	cputime_t ticks;
 
 	get_runstate_snapshot(&state);
@@ -125,7 +124,6 @@ static void do_stolen_accounting(void)
 	snap = &__get_cpu_var(xen_runstate_snapshot);
 
 	/* work out how much time the VCPU has not been runn*ing*  */
-	blocked = state.time[RUNSTATE_blocked] - snap->time[RUNSTATE_blocked];
 	runnable = state.time[RUNSTATE_runnable] - snap->time[RUNSTATE_runnable];
 	offline = state.time[RUNSTATE_offline] - snap->time[RUNSTATE_offline];
 
@@ -141,17 +139,6 @@ static void do_stolen_accounting(void)
 	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
 	__this_cpu_write(xen_residual_stolen, stolen);
 	account_steal_ticks(ticks);
-
-	/* Add the appropriate number of ticks of blocked time,
-	   including any left-overs from last time. */
-	blocked += __this_cpu_read(xen_residual_blocked);
-
-	if (blocked < 0)
-		blocked = 0;
-
-	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
-	__this_cpu_write(xen_residual_blocked, blocked);
-	account_idle_ticks(ticks);
 }
 
 /* Get the TSC speed from Xen */
diff --git a/block/genhd.c b/block/genhd.c
index 60108d9..d815a0f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -518,7 +518,7 @@ static void register_disk(struct gendisk *disk)
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 056571b..b4c046c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -512,7 +512,8 @@ static struct crypto_template *__crypto_lookup_template(const char *name)
 
 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), name);
+	return try_then_request_module(__crypto_lookup_template(name), "%s",
+				       name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);
 
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 762d059..a8af0ba 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -242,12 +242,14 @@ acpi_hw_sleep_dispatch(u8 sleep_state, u8 flags, u32 function_id)
 	    &acpi_sleep_dispatch[function_id];
 
 #if (!ACPI_REDUCED_HARDWARE)
-
 	/*
 	 * If the Hardware Reduced flag is set (from the FADT), we must
-	 * use the extended sleep registers
+	 * use the extended sleep registers (FADT). Note: As per the ACPI
+	 * specification, these extended registers are to be used for HW-reduced
+	 * platforms only. They are not general-purpose replacements for the
+	 * legacy PM register sleep support.
 	 */
-	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
+	if (acpi_gbl_reduced_hardware) {
 		status = sleep_functions->extended_function(sleep_state, flags);
 	} else {
 		/* Legacy sleep */
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index edd842d..9270f35 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -300,6 +300,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x8d64), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x23a3), board_ahci }, /* Coleto Creek AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -316,6 +317,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* AMD */
 	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
+	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
 	/* AMD is using RAID class only for ahci controllers */
 	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 624a948..dd99cbb 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -360,6 +360,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (BayTrail) */
 	{ 0x8086, 0x0F20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
 	{ 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
+	/* SATA Controller IDE (Coleto Creek) */
+	{ 0x8086, 0x23a6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 
 	{ }	/* terminate list */
 };
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index f9eaa82..47a1fb8 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1543,8 +1543,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		u32 fbs = readl(port_mmio + PORT_FBS);
 		int pmp = fbs >> PORT_FBS_DWE_OFFSET;
 
-		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links) &&
-		    ata_link_online(&ap->pmp_link[pmp])) {
+		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links)) {
 			link = &ap->pmp_link[pmp];
 			fbs_need_dec = true;
 		}
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 21b80c5..f63a588 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -389,9 +389,13 @@ static void sata_pmp_quirks(struct ata_port *ap)
 			/* link reports offline after LPM */
 			link->flags |= ATA_LFLAG_NO_LPM;
 
-			/* Class code report is unreliable. */
+			/*
+			 * Class code report is unreliable and SRST times
+			 * out under certain configurations.
+			 */
 			if (link->pmp < 5)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
+				link->flags |= ATA_LFLAG_NO_SRST |
+					       ATA_LFLAG_ASSUME_ATA;
 
 			/* port 5 is for SEMB device and it doesn't like SRST */
 			if (link->pmp == 5)
@@ -399,20 +403,17 @@ static void sata_pmp_quirks(struct ata_port *ap)
 					       ATA_LFLAG_ASSUME_SEMB;
 		}
 	} else if (vendor == 0x1095 && devid == 0x4723) {
-		/* sil4723 quirks */
-		ata_for_each_link(link, ap, EDGE) {
-			/* link reports offline after LPM */
-			link->flags |= ATA_LFLAG_NO_LPM;
-
-			/* class code report is unreliable */
-			if (link->pmp < 2)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
-
-			/* the config device at port 2 locks up on SRST */
-			if (link->pmp == 2)
-				link->flags |= ATA_LFLAG_NO_SRST |
-					       ATA_LFLAG_ASSUME_ATA;
-		}
+		/*
+		 * sil4723 quirks
+		 *
+		 * Link reports offline after LPM.  Class code report is
+		 * unreliable.  SIMG PMPs never got SRST reliable and the
+		 * config device at port 2 locks up on SRST.
+		 */
+		ata_for_each_link(link, ap, EDGE)
+			link->flags |= ATA_LFLAG_NO_LPM |
+				       ATA_LFLAG_NO_SRST |
+				       ATA_LFLAG_ASSUME_ATA;
 	} else if (vendor == 0x1095 && devid == 0x4726) {
 		/* sil4726 quirks */
 		ata_for_each_link(link, ap, EDGE) {
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7f25e24..35fc569 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -598,8 +598,10 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		if (!nbd->sock)
 			return -EINVAL;
 
+		nbd->disconnect = 1;
+
 		nbd_send_req(nbd, &sreq);
-                return 0;
+		return 0;
 	}
  
 	case NBD_CLEAR_SOCK: {
@@ -629,6 +631,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 				nbd->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
+				nbd->disconnect = 0; /* we're connected now */
 				return 0;
 			} else {
 				fput(file);
@@ -675,7 +678,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 
 		mutex_unlock(&nbd->tx_lock);
 
-		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
+		thread = kthread_create(nbd_thread, nbd, "%s",
+					nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&nbd->tx_lock);
 			return PTR_ERR(thread);
@@ -700,6 +704,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		set_capacity(nbd->disk, 0);
 		if (max_part > 0)
 			ioctl_by_bdev(bdev, BLKRRPART, 0);
+		if (nbd->disconnect) /* user requested, ignore socket errors */
+			return 0;
 		return nbd->harderror;
 	}
 
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index d620b44..8a3aff7 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2882,7 +2882,7 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 	if (lba < 0)
 		return -EINVAL;
 
-	cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
+	cgc->buffer = kzalloc(blocksize, GFP_KERNEL);
 	if (cgc->buffer == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index f5843bc..de4ec1a 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2462,10 +2462,10 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 	struct dma_pl330_chan *pch = to_pchan(chan);
 	unsigned long flags;
 
-	spin_lock_irqsave(&pch->lock, flags);
-
 	tasklet_kill(&pch->task);
 
+	spin_lock_irqsave(&pch->lock, flags);
+
 	pl330_release_channel(pch->pl330_chid);
 	pch->pl330_chid = NULL;
 
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 303bc8e..d7c3540 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -398,10 +398,11 @@ static efi_status_t
 get_var_data(struct efivars *efivars, struct efi_variable *var)
 {
 	efi_status_t status;
+	unsigned long flags;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 	status = get_var_data_locked(efivars, var);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
@@ -410,6 +411,18 @@ get_var_data(struct efivars *efivars, struct efi_variable *var)
 	return status;
 }
 
+static efi_status_t
+check_var_size_locked(struct efivars *efivars, u32 attributes,
+			unsigned long size)
+{
+	const struct efivar_operations *fops = efivars->ops;
+
+	if (!efivars->ops->query_variable_store)
+		return EFI_UNSUPPORTED;
+
+	return fops->query_variable_store(attributes, size);
+}
+
 static ssize_t
 efivar_guid_read(struct efivar_entry *entry, char *buf)
 {
@@ -530,14 +543,19 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
-	status = efivars->ops->set_variable(new_var->VariableName,
-					    &new_var->VendorGuid,
-					    new_var->Attributes,
-					    new_var->DataSize,
-					    new_var->Data);
+	spin_lock_irq(&efivars->lock);
+
+	status = check_var_size_locked(efivars, new_var->Attributes,
+	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
 
-	spin_unlock(&efivars->lock);
+	if (status == EFI_SUCCESS || status == EFI_UNSUPPORTED)
+		status = efivars->ops->set_variable(new_var->VariableName,
+						    &new_var->VendorGuid,
+						    new_var->Attributes,
+						    new_var->DataSize,
+						    new_var->Data);
+
+	spin_unlock_irq(&efivars->lock);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
@@ -634,6 +652,36 @@ static struct kobj_type efivar_ktype = {
 	.default_attrs = def_attrs,
 };
 
+static int efi_status_to_err(efi_status_t status)
+{
+	int err;
+
+	switch (status) {
+	case EFI_INVALID_PARAMETER:
+		err = -EINVAL;
+		break;
+	case EFI_OUT_OF_RESOURCES:
+		err = -ENOSPC;
+		break;
+	case EFI_DEVICE_ERROR:
+		err = -EIO;
+		break;
+	case EFI_WRITE_PROTECTED:
+		err = -EROFS;
+		break;
+	case EFI_SECURITY_VIOLATION:
+		err = -EACCES;
+		break;
+	case EFI_NOT_FOUND:
+		err = -ENOENT;
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
 static inline void
 efivar_unregister(struct efivar_entry *var)
 {
@@ -646,7 +694,7 @@ static int efi_pstore_open(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	efivars->walk_entry = list_first_entry(&efivars->list,
 					       struct efivar_entry, list);
 	return 0;
@@ -656,7 +704,7 @@ static int efi_pstore_close(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	return 0;
 }
 
@@ -710,11 +758,28 @@ static int efi_pstore_write(enum pstore_type_id type,
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
 	int i, ret = 0;
+	efi_status_t status = EFI_NOT_FOUND;
+	unsigned long flags;
 
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
+
+	/*
+	 * Check if there is a space enough to log.
+	 * size: a size of logging data
+	 * DUMP_NAME_LEN * 2: a maximum size of variable name
+	 */
+
+	status = check_var_size_locked(efivars, PSTORE_EFI_ATTRIBUTES,
+					 size + DUMP_NAME_LEN * 2);
+
+	if (status) {
+		spin_unlock_irqrestore(&efivars->lock, flags);
+		*id = part;
+		return -ENOSPC;
+	}
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = stub_name[i];
@@ -752,7 +817,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (found)
 		efivar_unregister(found);
@@ -823,7 +888,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -841,10 +906,18 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 
+	status = check_var_size_locked(efivars, new_var->Attributes,
+	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+
+	if (status && status != EFI_UNSUPPORTED) {
+		spin_unlock_irq(&efivars->lock);
+		return efi_status_to_err(status);
+	}
+
 	/* now *really* create the variable via EFI */
 	status = efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
@@ -855,10 +928,10 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
@@ -886,7 +959,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -904,7 +977,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (!found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 	/* force the Attributes/DataSize to 0 to ensure deletion */
@@ -920,12 +993,12 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
 	list_del(&search_efivar->list);
 	/* We need to release this lock before unregistering. */
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	efivar_unregister(search_efivar);
 
 	/* It's dead Jim.... */
@@ -1033,9 +1106,9 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	kfree(short_name);
 	short_name = NULL;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	return 0;
 }
@@ -1104,9 +1177,9 @@ void unregister_efivars(struct efivars *efivars)
 	struct efivar_entry *entry, *n;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		spin_lock(&efivars->lock);
+		spin_lock_irq(&efivars->lock);
 		list_del(&entry->list);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		efivar_unregister(entry);
 	}
 	if (efivars->new_var)
@@ -1220,6 +1293,8 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
+	ops.query_variable_store = efi_query_variable_store;
+
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index aa2fa4d..01cc01b 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -200,7 +200,8 @@ struct mga_device {
 		atomic_t validate_sequence;
 	} ttm;
 
-	u32 reg_1e24; /* SE model number */
+	/* SE model number stored in reg 0x1e24 */
+	u32 unique_rev_id;
 };
 
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_main.c b/drivers/gpu/drm/mgag200/mgag200_main.c
index 636a81c..3663a11 100644
--- a/drivers/gpu/drm/mgag200/mgag200_main.c
+++ b/drivers/gpu/drm/mgag200/mgag200_main.c
@@ -190,7 +190,7 @@ static int mgag200_device_init(struct drm_device *dev,
 
 	/* stash G200 SE model number for later use */
 	if (IS_G200_SE(mdev))
-		mdev->reg_1e24 = RREG32(0x1e24);
+		mdev->unique_rev_id = RREG32(0x1e24);
 
 	ret = mga_vram_init(mdev);
 	if (ret) {
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 4e48f91..f780f2c 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1016,7 +1016,7 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 
 
 	if (IS_G200_SE(mdev)) {
-		if (mdev->reg_1e24 >= 0x02) {
+		if (mdev->unique_rev_id >= 0x02) {
 			u8 hi_pri_lvl;
 			u32 bpp;
 			u32 mb;
@@ -1046,7 +1046,7 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 			WREG8(MGAREG_CRTCEXT_DATA, hi_pri_lvl);
 		} else {
 			WREG8(MGAREG_CRTCEXT_INDEX, 0x06);
-			if (mdev->reg_1e24 >= 0x01)
+			if (mdev->unique_rev_id >= 0x01)
 				WREG8(MGAREG_CRTCEXT_DATA, 0x03);
 			else
 				WREG8(MGAREG_CRTCEXT_DATA, 0x04);
@@ -1420,10 +1420,82 @@ static int mga_vga_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
+static uint32_t mga_vga_calculate_mode_bandwidth(struct drm_display_mode *mode,
+							int bits_per_pixel)
+{
+	uint32_t total_area, divisor;
+	int64_t active_area, pixels_per_second, bandwidth;
+	uint64_t bytes_per_pixel = (bits_per_pixel + 7) / 8;
+
+	divisor = 1024;
+
+	if (!mode->htotal || !mode->vtotal || !mode->clock)
+		return 0;
+
+	active_area = mode->hdisplay * mode->vdisplay;
+	total_area = mode->htotal * mode->vtotal;
+
+	pixels_per_second = active_area * mode->clock * 1000;
+	do_div(pixels_per_second, total_area);
+
+	bandwidth = pixels_per_second * bytes_per_pixel * 100;
+	do_div(bandwidth, divisor);
+
+	return (uint32_t)(bandwidth);
+}
+
+#define MODE_BANDWIDTH	MODE_BAD
+
 static int mga_vga_mode_valid(struct drm_connector *connector,
 				 struct drm_display_mode *mode)
 {
-	/* FIXME: Add bandwidth and g200se limitations */
+	struct drm_device *dev = connector->dev;
+	struct mga_device *mdev = (struct mga_device*)dev->dev_private;
+	struct mga_fbdev *mfbdev = mdev->mfbdev;
+	struct drm_fb_helper *fb_helper = &mfbdev->helper;
+	struct drm_fb_helper_connector *fb_helper_conn = NULL;
+	int bpp = 32;
+	int i = 0;
+
+	if (IS_G200_SE(mdev)) {
+		if (mdev->unique_rev_id == 0x01) {
+			if (mode->hdisplay > 1600)
+				return MODE_VIRTUAL_X;
+			if (mode->vdisplay > 1200)
+				return MODE_VIRTUAL_Y;
+			if (mga_vga_calculate_mode_bandwidth(mode, bpp)
+				> (24400 * 1024))
+				return MODE_BANDWIDTH;
+		} else if (mdev->unique_rev_id >= 0x02) {
+			if (mode->hdisplay > 1920)
+				return MODE_VIRTUAL_X;
+			if (mode->vdisplay > 1200)
+				return MODE_VIRTUAL_Y;
+			if (mga_vga_calculate_mode_bandwidth(mode, bpp)
+				> (30100 * 1024))
+				return MODE_BANDWIDTH;
+		}
+	} else if (mdev->type == G200_WB) {
+		if (mode->hdisplay > 1280)
+			return MODE_VIRTUAL_X;
+		if (mode->vdisplay > 1024)
+			return MODE_VIRTUAL_Y;
+		if (mga_vga_calculate_mode_bandwidth(mode,
+			bpp > (31877 * 1024)))
+			return MODE_BANDWIDTH;
+	} else if (mdev->type == G200_EV &&
+		(mga_vga_calculate_mode_bandwidth(mode, bpp)
+			> (32700 * 1024))) {
+		return MODE_BANDWIDTH;
+	} else if (mode->type == G200_EH &&
+		(mga_vga_calculate_mode_bandwidth(mode, bpp)
+			> (37500 * 1024))) {
+		return MODE_BANDWIDTH;
+	} else if (mode->type == G200_ER &&
+		(mga_vga_calculate_mode_bandwidth(mode,
+			bpp) > (55000 * 1024))) {
+		return MODE_BANDWIDTH;
+	}
 
 	if (mode->crtc_hdisplay > 2048 || mode->crtc_hsync_start > 4096 ||
 	    mode->crtc_hsync_end > 4096 || mode->crtc_htotal > 4096 ||
@@ -1432,6 +1504,25 @@ static int mga_vga_mode_valid(struct drm_connector *connector,
 		return MODE_BAD;
 	}
 
+	/* Validate the mode input by the user */
+	for (i = 0; i < fb_helper->connector_count; i++) {
+		if (fb_helper->connector_info[i]->connector == connector) {
+			/* Found the helper for this connector */
+			fb_helper_conn = fb_helper->connector_info[i];
+			if (fb_helper_conn->cmdline_mode.specified) {
+				if (fb_helper_conn->cmdline_mode.bpp_specified) {
+					bpp = fb_helper_conn->cmdline_mode.bpp;
+				}
+			}
+		}
+	}
+
+	if ((mode->hdisplay * mode->vdisplay * (bpp/8)) > mdev->mc.vram_size) {
+		if (fb_helper_conn)
+			fb_helper_conn->cmdline_mode.specified = false;
+		return MODE_BAD;
+	}
+
 	return MODE_OK;
 }
 
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 9b72abe..f2f2058 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -137,6 +137,7 @@ config I2C_PIIX4
 	    ATI SB700
 	    ATI SB800
 	    AMD Hudson-2
+	    AMD CZ
 	    Serverworks OSB4
 	    Serverworks CSB5
 	    Serverworks CSB6
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index c14d48d..a356974 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -22,7 +22,7 @@
 	Intel PIIX4, 440MX
 	Serverworks OSB4, CSB5, CSB6, HT-1000, HT-1100
 	ATI IXP200, IXP300, IXP400, SB600, SB700, SB800
-	AMD Hudson-2
+	AMD Hudson-2, CZ
 	SMSC Victory66
 
    Note: we assume there can only be one device, with one SMBus interface.
@@ -481,6 +481,7 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x790b) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
 		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d3be586..141c69f 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1309,6 +1309,10 @@ static unsigned long iommu_unmap_page(struct protection_domain *dom,
 
 			/* Large PTE found which maps this address */
 			unmap_size = PTE_PAGE_SIZE(*pte);
+
+			/* Only unmap from the first pte in the page */
+			if ((unmap_size - 1) & bus_addr)
+				break;
 			count      = PAGE_SIZE_PTE_COUNT(unmap_size);
 			for (i = 0; i < count; i++)
 				pte[i] = 0ULL;
@@ -1318,7 +1322,7 @@ static unsigned long iommu_unmap_page(struct protection_domain *dom,
 		unmapped += unmap_size;
 	}
 
-	BUG_ON(!is_power_of_2(unmapped));
+	BUG_ON(unmapped && !is_power_of_2(unmapped));
 
 	return unmapped;
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e76227e..a829557 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3410,7 +3410,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	/* FIXME calc properly */
 	conf->mirrors = kzalloc(sizeof(struct mirror_info)*(mddev->raid_disks +
-							    max(0,mddev->delta_disks)),
+							    max(0,-mddev->delta_disks)),
 				GFP_KERNEL);
 	if (!conf->mirrors)
 		goto out;
@@ -3551,7 +3551,7 @@ static int run(struct mddev *mddev)
 		    conf->geo.far_offset == 0)
 			goto out_free_conf;
 		if (conf->prev.far_copies != 1 &&
-		    conf->geo.far_offset == 0)
+		    conf->prev.far_offset == 0)
 			goto out_free_conf;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index dfb0441..535c2b1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3578,7 +3578,7 @@ static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah,
 static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 {
 	int chain;
-	u32 regval;
+	u32 regval, value;
 	u32 ant_div_ctl1;
 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
 			AR_PHY_SWITCH_CHAIN_0,
@@ -3586,7 +3586,11 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 			AR_PHY_SWITCH_CHAIN_2,
 	};
 
-	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
+	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
+		ath9k_hw_cfg_output(ah, AR9300_EXT_LNA_CTL_GPIO_AR9485,
+				    AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED);
+
+	value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
 
 	if (AR_SREV_9462(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 7268a48..230f869 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -339,6 +339,8 @@
 
 #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
 
+#define AR9300_EXT_LNA_CTL_GPIO_AR9485 9
+
 /*
  * AGC Field Definitions
  */
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index bbd249d..c39f47c 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -369,7 +369,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	struct ieee80211_channel *c = chan->chan;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 
-	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
 		ath_dbg(common, CALIBRATE,
 			"NF did not complete in calibration window\n");
@@ -384,12 +383,10 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		ath_dbg(common, CALIBRATE,
 			"noise floor failed detected; detected %d, threshold %d\n",
 			nf, nfThresh);
-		chan->channelFlags |= CHANNEL_CW_INT;
 	}
 
 	if (!caldata) {
 		chan->noisefloor = nf;
-		ah->noise = ath9k_hw_getchan_noise(ah, chan);
 		return false;
 	}
 
@@ -410,7 +407,8 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 	int i, j;
 
 	ah->caldata->channel = chan->channel;
-	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
+	ah->caldata->channelFlags = chan->channelFlags;
+	ah->caldata->chanmode = chan->chanmode;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6333166..a1ef2c9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1773,10 +1773,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		ath9k_hw_getnf(ah, ah->curchan);
 
 	ah->caldata = caldata;
-	if (caldata &&
-	    (chan->channel != caldata->channel ||
-	     (chan->channelFlags & ~CHANNEL_CW_INT) !=
-	     (caldata->channelFlags & ~CHANNEL_CW_INT))) {
+	if (caldata && (chan->channel != caldata->channel ||
+			chan->channelFlags != caldata->channelFlags ||
+			chan->chanmode != caldata->chanmode)) {
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ec2835b..d2fc9f1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -317,7 +317,6 @@ enum ath9k_int {
 	ATH9K_INT_NOCARD = 0xffffffff
 };
 
-#define CHANNEL_CW_INT    0x00002
 #define CHANNEL_CCK       0x00020
 #define CHANNEL_OFDM      0x00040
 #define CHANNEL_2GHZ      0x00080
@@ -355,6 +354,7 @@ enum ath9k_int {
 struct ath9k_hw_cal_data {
 	u16 channel;
 	u32 channelFlags;
+	u32 chanmode;
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e8da084..278ce3d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1624,13 +1624,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_update_survey_stats(sc);
 		spin_unlock_irqrestore(&common->cc_lock, flags);
 
-		/*
-		 * Preserve the current channel values, before updating
-		 * the same channel
-		 */
-		if (ah->curchan && (old_pos == pos))
-			ath9k_hw_getnf(ah, ah->curchan);
-
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
 					  curchan, conf->channel_type);
 
diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 3876c7e..af40211 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -28,7 +28,7 @@ config B43
 
 config B43_BCMA
 	bool "Support for BCMA bus"
-	depends on B43 && BCMA
+	depends on B43 && (BCMA = y || BCMA = B43)
 	default y
 
 config B43_BCMA_EXTRA
@@ -39,7 +39,7 @@ config B43_BCMA_EXTRA
 
 config B43_SSB
 	bool
-	depends on B43 && SSB
+	depends on B43 && (SSB = y || SSB = B43)
 	default y
 
 # Auto-select SSB PCI-HOST support, if possible
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index a1fb025..844d0f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -439,6 +439,9 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 	spin_unlock_bh(&txq->lock);
+
+	/* just in case - this queue may have been stopped */
+	iwl_wake_queue(trans, txq);
 }
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6d0c1ec..1c60904 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4655,8 +4655,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
-			info[i].default_power1 = default_power1[i];
-			info[i].default_power2 = default_power2[i];
+			info[i].default_power1 = default_power1[i - 14];
+			info[i].default_power2 = default_power2[i - 14];
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 02ba3cf..65cee5d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2822,7 +2822,8 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i - 14]);
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ceb1c4f..55f1886 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2167,7 +2167,8 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i - 14]);
 		}
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index 506b9a0..4763426 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -104,7 +104,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 			tx_agc[RF90_PATH_A] = 0x10101010;
 			tx_agc[RF90_PATH_B] = 0x10101010;
 		} else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
-			   TXHIGHPWRLEVEL_LEVEL1) {
+			   TXHIGHPWRLEVEL_LEVEL2) {
 			tx_agc[RF90_PATH_A] = 0x00000000;
 			tx_agc[RF90_PATH_B] = 0x00000000;
 		} else{
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index b450931..5212ad2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -358,6 +358,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
 	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
 	{RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
 	{RTL_USB_DEVICE(0x20f4, 0x624d, rtl92cu_hal_cfg)}, /*TRENDNet*/
+	{RTL_USB_DEVICE(0x2357, 0x0100, rtl92cu_hal_cfg)}, /*TP-Link WN8200ND*/
 	{RTL_USB_DEVICE(0x7392, 0x7822, rtl92cu_hal_cfg)}, /*Edimax -Edimax*/
 	{}
 };
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9319aa1..96273e3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1625,8 +1625,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	bridge->dev.release = pci_release_bus_bridge_dev;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
 	error = device_register(&bridge->dev);
-	if (error)
-		goto bridge_dev_reg_err;
+	if (error) {
+		put_device(&bridge->dev);
+		goto err_out;
+	}
 	b->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(b->bridge);
 	pci_set_bus_of_node(b);
@@ -1679,8 +1681,6 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 class_dev_reg_err:
 	put_device(&bridge->dev);
 	device_unregister(&bridge->dev);
-bridge_dev_reg_err:
-	kfree(bridge);
 err_out:
 	kfree(b);
 	return NULL;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 777e56f..4d0fe7d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1062,6 +1062,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SATA_IDE, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x7900, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, 0x7900, quirk_amd_ide_mode);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 9694c1e..fc50168 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -100,9 +100,9 @@ static int at91_cf_get_status(struct pcmcia_socket *s, u_int *sp)
 		int vcc	= gpio_is_valid(cf->board->vcc_pin);
 
 		*sp = SS_DETECT | SS_3VCARD;
-		if (!rdy || gpio_get_value(rdy))
+		if (!rdy || gpio_get_value(cf->board->irq_pin))
 			*sp |= SS_READY;
-		if (!vcc || gpio_get_value(vcc))
+		if (!vcc || gpio_get_value(cf->board->vcc_pin))
 			*sp |= SS_POWERON;
 	} else
 		*sp = 0;
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 86935ec..d101f91 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -371,7 +371,7 @@ static void uevent_notify(struct charger_manager *cm, const char *event)
 	strncpy(env_str, event, UEVENT_BUF_SIZE);
 	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
 
-	dev_info(cm->dev, event);
+	dev_info(cm->dev, "%s", event);
 }
 
 /**
diff --git a/drivers/rtc/rtc-rv3029c2.c b/drivers/rtc/rtc-rv3029c2.c
index 0fbe57b..21d63d1 100644
--- a/drivers/rtc/rtc-rv3029c2.c
+++ b/drivers/rtc/rtc-rv3029c2.c
@@ -310,7 +310,7 @@ static int rv3029c2_rtc_i2c_set_alarm(struct i2c_client *client,
 		dev_dbg(&client->dev, "alarm IRQ armed\n");
 	} else {
 		/* disable AIE irq */
-		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 1);
+		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 0);
 		if (ret)
 			return ret;
 
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 4f1b10b..3743ac9 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -3,7 +3,7 @@
  *
  * Module interface and handling of zfcp data structures.
  *
- * Copyright IBM Corporation 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 /*
@@ -23,6 +23,7 @@
  *            Christof Schmitt
  *            Martin Petermann
  *            Sven Schuetz
+ *            Steffen Maier
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -415,6 +416,8 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 	adapter->dma_parms.max_segment_size = ZFCP_QDIO_SBALE_LEN;
 	adapter->ccw_device->dev.dma_parms = &adapter->dma_parms;
 
+	adapter->stat_read_buf_num = FSF_STATUS_READS_RECOM;
+
 	if (!zfcp_scsi_adapter_register(adapter))
 		return adapter;
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 2136fc2..961e327 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -3,7 +3,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corporation 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -483,12 +483,8 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 
 	fc_host_port_name(shost) = nsp->fl_wwpn;
 	fc_host_node_name(shost) = nsp->fl_wwnn;
-	fc_host_port_id(shost) = ntoh24(bottom->s_id);
-	fc_host_speed(shost) =
-		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 
-	adapter->hydra_version = bottom->adapter_type;
 	adapter->timer_ticks = bottom->timer_interval & ZFCP_FSF_TIMER_INT_MASK;
 	adapter->stat_read_buf_num = max(bottom->status_read_buf_num,
 					 (u16)FSF_STATUS_READS_RECOM);
@@ -496,6 +492,19 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 	if (fc_host_permanent_port_name(shost) == -1)
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
 
+	zfcp_scsi_set_prot(adapter);
+
+	/* no error return above here, otherwise must fix call chains */
+	/* do not evaluate invalid fields */
+	if (req->qtcb->header.fsf_status == FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE)
+		return 0;
+
+	fc_host_port_id(shost) = ntoh24(bottom->s_id);
+	fc_host_speed(shost) =
+		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
+
+	adapter->hydra_version = bottom->adapter_type;
+
 	switch (bottom->fc_topology) {
 	case FSF_TOPO_P2P:
 		adapter->peer_d_id = ntoh24(bottom->peer_d_id);
@@ -517,8 +526,6 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 		return -EIO;
 	}
 
-	zfcp_scsi_set_prot(adapter);
-
 	return 0;
 }
 
@@ -563,8 +570,14 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		adapter->hydra_version = 0;
 
+		/* avoids adapter shutdown to be able to recognize
+		 * events such as LINK UP */
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+				&adapter->status);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
+		if (zfcp_fsf_exchange_config_evaluate(req))
+			return;
 		break;
 	default:
 		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh3");
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index b79576b..7b35364 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -3,7 +3,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corporation 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -311,8 +311,12 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.proc_name		 = "zfcp",
 	.can_queue		 = 4096,
 	.this_id		 = -1,
-	.sg_tablesize		 = 1, /* adjusted later */
-	.max_sectors		 = 8, /* adjusted later */
+	.sg_tablesize		 = (((QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
+				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) - 2),
+				   /* GCD, adjusted later */
+	.max_sectors		 = (((QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
+				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) - 2) * 8,
+				   /* GCD, adjusted later */
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 	.cmd_per_lun		 = 1,
 	.use_clustering		 = 1,
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 7628206..4de2612 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -101,6 +101,9 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 			struct list_head *entry;
 			int send_it = 0;
 
+			src_writel(dev, MUnit.ODR_C, bellbits);
+			src_readl(dev, MUnit.ODR_C);
+
 			if (dev->sync_fib) {
 				our_interrupt = 1;
 				if (dev->sync_fib->callback)
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 9d5a56c..bf7a9e7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -80,10 +80,6 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
-static int missing_delay[2] = {-1, -1};
-module_param_array(missing_delay, int, NULL, 0);
-MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
-
 static int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
 	"and halt firmware - (default=0)");
@@ -2175,7 +2171,7 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_update_missing_delay - change the missing delay timers
+ * mpt2sas_base_update_missing_delay - change the missing delay timers
  * @ioc: per adapter object
  * @device_missing_delay: amount of time till device is reported missing
  * @io_missing_delay: interval IO is returned when there is a missing device
@@ -2186,8 +2182,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
  * delay, as well as the io missing delay. This should be called at driver
  * load time.
  */
-static void
-_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
+void
+mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
 	u16 device_missing_delay, u8 io_missing_delay)
 {
 	u16 dmd, dmd_new, dmd_orignal;
@@ -4383,10 +4379,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
-	if (missing_delay[0] != -1 && missing_delay[1] != -1)
-		_base_update_missing_delay(ioc, missing_delay[0],
-		    missing_delay[1]);
-
 	return 0;
 
  out_free_resources:
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index b6dd3a5..2fa7282 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1048,6 +1048,9 @@ void mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_ty
 
 void mpt2sas_halt_firmware(struct MPT2SAS_ADAPTER *ioc);
 
+void mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
+	u16 device_missing_delay, u8 io_missing_delay);
+
 int mpt2sas_port_enable(struct MPT2SAS_ADAPTER *ioc);
 
 /* scsih shared API */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 76973e8..4d8bd35 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -101,6 +101,10 @@ static ushort max_sectors = 0xFFFF;
 module_param(max_sectors, ushort, 0);
 MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 32767  default=32767");
 
+static int missing_delay[2] = {-1, -1};
+module_param_array(missing_delay, int, NULL, 0);
+MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPT2SAS_MAX_LUN (16895)
 static int max_lun = MPT2SAS_MAX_LUN;
@@ -3995,11 +3999,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 			else
 				mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 		} else
-/* MPI Revision I (UNIT = 0xA) - removed MPI2_SCSIIO_CONTROL_UNTAGGED */
-/*			mpi_control |= MPI2_SCSIIO_CONTROL_UNTAGGED;
- */
-			mpi_control |= (0x500);
-
+			mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 	} else
 		mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 	/* Make sure Device is not raid volume.
@@ -7088,12 +7088,15 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 	struct _sas_device *sas_device;
 	struct _sas_node *expander_device;
 	static struct _raid_device *raid_device;
+	u8 retry_count;
 	unsigned long flags;
 
 	printk(MPT2SAS_INFO_FMT "scan devices: start\n", ioc->name);
 
 	_scsih_sas_host_refresh(ioc);
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: expanders start\n",
+		ioc->name);
 	/* expanders */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
@@ -7102,6 +7105,13 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from expander scan: "
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		handle = le16_to_cpu(expander_pg0.DevHandle);
 		spin_lock_irqsave(&ioc->sas_node_lock, flags);
 		expander_device = mpt2sas_scsih_expander_find_by_sas_address(
@@ -7110,13 +7120,26 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		if (expander_device)
 			_scsih_refresh_expander_links(ioc, expander_device,
 			    handle);
-		else
+		else {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding expander: "
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(expander_pg0.SASAddress));
 			_scsih_expander_add(ioc, handle);
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding expander: "
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(expander_pg0.SASAddress));
+		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: expanders complete\n",
+		ioc->name);
+
 	if (!ioc->ir_firmware)
 		goto skip_to_sas;
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices phys disk start\n", ioc->name);
 	/* phys disk */
 	phys_disk_num = 0xFF;
 	while (!(mpt2sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
@@ -7126,6 +7149,13 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from phys disk scan:"
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		phys_disk_num = pd_pg0.PhysDiskNum;
 		handle = le16_to_cpu(pd_pg0.DevHandle);
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
@@ -7137,17 +7167,46 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
 		    handle) != 0)
 			continue;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+			MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from phys disk scan "
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle,
 		    &sas_address)) {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding phys disk: "
+				" handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt2sas_transport_update_links(ioc, sas_address,
 			    handle, sas_device_pg0.PhyNum,
 			    MPI2_SAS_NEG_LINK_RATE_1_5);
 			set_bit(handle, ioc->pd_handles);
-			_scsih_add_device(ioc, handle, 0, 1);
+			retry_count = 0;
+			/* This will retry adding the end device.
+			* _scsih_add_device() will decide on retries and
+			* return "1" when it should be retried
+			*/
+			while (_scsih_add_device(ioc, handle, retry_count++,
+				1)) {
+					ssleep(1);
+			}
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding phys disk: "
+				" handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: phys disk complete\n",
+		ioc->name);
+
+	printk(MPT2SAS_INFO_FMT "\tscan devices: volumes start\n", ioc->name);
 	/* volumes */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
@@ -7156,6 +7215,13 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from volume scan: "
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		handle = le16_to_cpu(volume_pg1.DevHandle);
 		spin_lock_irqsave(&ioc->raid_device_lock, flags);
 		raid_device = _scsih_raid_device_find_by_wwid(ioc,
@@ -7167,18 +7233,38 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    &volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
 		     sizeof(Mpi2RaidVolPage0_t)))
 			continue;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+			MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from volume scan: "
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		if (volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
 		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_ONLINE ||
 		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_DEGRADED) {
 			memset(&element, 0, sizeof(Mpi2EventIrConfigElement_t));
 			element.ReasonCode = MPI2_EVENT_IR_CHANGE_RC_ADDED;
 			element.VolDevHandle = volume_pg1.DevHandle;
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding volume: "
+				" handle (0x%04x)\n", ioc->name,
+				volume_pg1.DevHandle);
 			_scsih_sas_volume_add(ioc, &element);
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding volume: "
+				" handle (0x%04x)\n", ioc->name,
+				volume_pg1.DevHandle);
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: volumes complete\n",
+		ioc->name);
+
  skip_to_sas:
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: end devices start\n",
+		ioc->name);
 	/* sas devices */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply,
@@ -7188,6 +7274,13 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from end device scan:"
+				" ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+				break;
+		}
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
 		if (!(_scsih_is_end_device(
 		    le32_to_cpu(sas_device_pg0.DeviceInfo))))
@@ -7200,12 +7293,31 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 			continue;
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address)) {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding end device: "
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt2sas_transport_update_links(ioc, sas_address, handle,
 			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
-			_scsih_add_device(ioc, handle, 0, 0);
+			retry_count = 0;
+			/* This will retry adding the end device.
+			 * _scsih_add_device() will decide on retries and
+			 * return "1" when it should be retried
+			 */
+			while (_scsih_add_device(ioc, handle, retry_count++,
+				0)) {
+					ssleep(1);
+			}
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding end device: "
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: end devices complete\n",
+		ioc->name);
+
 	printk(MPT2SAS_INFO_FMT "scan devices: complete\n", ioc->name);
 }
 
@@ -7297,7 +7409,9 @@ _firmware_event_work(struct work_struct *work)
 	case MPT2SAS_PORT_ENABLE_COMPLETE:
 		ioc->start_scan = 0;
 
-
+		if (missing_delay[0] != -1 && missing_delay[1] != -1)
+			mpt2sas_base_update_missing_delay(ioc, missing_delay[0],
+				missing_delay[1]);
 
 		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "port enable: complete "
 		    "from worker thread\n", ioc->name));
@@ -8056,7 +8170,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (max_sectors < 64) {
 			shost->max_sectors = 64;
 			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "
-			    "for max_sectors, range is 64 to 8192. Assigning "
+			    "for max_sectors, range is 64 to 32767. Assigning "
 			    "value of 64.\n", ioc->name, max_sectors);
 		} else if (max_sectors > 32767) {
 			shost->max_sectors = 32767;
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index d4ed9eb..caac1b2 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -465,7 +465,7 @@ static int osd_probe(struct device *dev)
 	oud->class_dev.class = &osd_uld_class;
 	oud->class_dev.parent = dev;
 	oud->class_dev.release = __remove;
-	error = dev_set_name(&oud->class_dev, disk->disk_name);
+	error = dev_set_name(&oud->class_dev, "%s", disk->disk_name);
 	if (error) {
 		OSD_ERR("dev_set_name failed => %d\n", error);
 		goto err_put_cdev;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 45518b7..3977faa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -141,7 +141,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
-	const char *temp = "temporary ";
+	static const char temp[] = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index fb7f9fb..1ae0610 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -361,8 +361,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
-		if (is_partial_io(bvec))
-			kfree(uncmem);
 		zram_stat_inc(&zram->stats.pages_zero);
 		zram_set_flag(zram, index, ZRAM_ZERO);
 		ret = 0;
@@ -535,13 +533,20 @@ out:
  */
 static inline int valid_io_request(struct zram *zram, struct bio *bio)
 {
-	if (unlikely(
-		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
-		(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)) ||
-		(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))) {
+	u64 start, end, bound;
+	
+	/* unaligned request */
+	if (unlikely(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
+		return 0;
+	if (unlikely(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
+		return 0;
 
+	start = bio->bi_sector;
+	end = start + (bio->bi_size >> SECTOR_SHIFT);
+	bound = zram->disksize >> SECTOR_SHIFT;
+	/* out of range range */
+	if (unlikely(start >= bound || end >= bound || start > end))
 		return 0;
-	}
 
 	/* I/O request is valid */
 	return 1;
@@ -692,7 +697,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
+	down_write(&zram->lock);
 	zram_free_page(zram, index);
+	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
@@ -703,7 +710,7 @@ static const struct block_device_operations zram_devops = {
 
 static int create_device(struct zram *zram, int device_id)
 {
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
@@ -713,7 +720,6 @@ static int create_device(struct zram *zram, int device_id)
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -723,11 +729,9 @@ static int create_device(struct zram *zram, int device_id)
 	 /* gendisk structure */
 	zram->disk = alloc_disk(1);
 	if (!zram->disk) {
-		blk_cleanup_queue(zram->queue);
 		pr_warning("Error allocating disk structure for device %d\n",
 			device_id);
-		ret = -ENOMEM;
-		goto out;
+		goto out_free_queue;
 	}
 
 	zram->disk->major = zram_major;
@@ -756,11 +760,17 @@ static int create_device(struct zram *zram, int device_id)
 				&zram_disk_attr_group);
 	if (ret < 0) {
 		pr_warning("Error creating sysfs group");
-		goto out;
+		goto out_free_disk;
 	}
 
 	zram->init_done = 0;
+	return 0;
 
+out_free_disk:
+	del_gendisk(zram->disk);
+	put_disk(zram->disk);
+out_free_queue:
+	blk_cleanup_queue(zram->queue);
 out:
 	return ret;
 }
@@ -841,9 +851,11 @@ static void __exit zram_exit(void)
 	for (i = 0; i < num_devices; i++) {
 		zram = &zram_devices[i];
 
+		get_disk(zram->disk);
 		destroy_device(zram);
 		if (zram->init_done)
 			zram_reset_device(zram);
+		put_disk(zram->disk);
 	}
 
 	unregister_blkdev(zram_major, "zram");
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index fbe8ac9..1047e82 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -107,8 +107,9 @@ struct zram {
 	void *compress_buffer;
 	struct table *table;
 	spinlock_t stat64_lock;	/* protect 64-bit stats */
-	struct rw_semaphore lock; /* protect compression buffers and table
-				   * against concurrent read and writes */
+	struct rw_semaphore lock; /* protect compression buffers, table,
+				   * 32bit stat counters against concurrent
+				   * notifications, reads and writes */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index a7f3771..dbe8907 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -186,10 +186,12 @@ static ssize_t mem_used_total_show(struct device *dev,
 	u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
 
+	down_read(&zram->init_lock);
 	if (zram->init_done) {
 		val = zs_get_total_size_bytes(zram->mem_pool) +
 			((u64)(zram->stats.pages_expand) << PAGE_SHIFT);
 	}
+	up_read(&zram->init_lock);
 
 	return sprintf(buf, "%llu\n", val);
 }
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 92c954c..41c1db3 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4159,10 +4159,6 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
 
-	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
-		0x1000, 0x0012,
-		0, 0, pbn_b0_bt_2_115200 },
-
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 		0xA000, 0x1000,
 		0, 0, pbn_b0_1_115200 },
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f67b453..277bb9b 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -511,6 +511,7 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
 /* Caller must hold fsg->lock */
 static void wakeup_thread(struct fsg_common *common)
 {
+	smp_wmb();	/* ensure the write of bh->state is complete */
 	/* Tell the main thread that something has happened */
 	common->thread_wakeup_needed = 1;
 	if (common->thread_task)
@@ -730,6 +731,7 @@ static int sleep_thread(struct fsg_common *common)
 	}
 	__set_current_state(TASK_RUNNING);
 	common->thread_wakeup_needed = 0;
+	smp_rmb();	/* ensure the latest bh->state is visible */
 	return rc;
 }
 
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 0618f25..1ffbbfb 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -369,6 +369,10 @@ static struct xhci_container_ctx *xhci_alloc_container_ctx(struct xhci_hcd *xhci
 		ctx->size += CTX_SIZE(xhci->hcc_params);
 
 	ctx->bytes = dma_pool_alloc(xhci->device_pool, flags, &ctx->dma);
+	if (!ctx->bytes) {
+		kfree(ctx);
+		return NULL;
+	}
 	memset(ctx->bytes, 0, ctx->size);
 	return ctx;
 }
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index df90fe5..93ad67e 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -179,6 +179,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 
 	usb_remove_hcd(hcd);
 	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	kfree(xhci);
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ccd2d11..71ae3ca 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -159,8 +159,6 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED	0x9000
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED	0x9001
 #define NOVATELWIRELESS_PRODUCT_E362		0x9010
-#define NOVATELWIRELESS_PRODUCT_G1		0xA001
-#define NOVATELWIRELESS_PRODUCT_G1_M		0xA002
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
 #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
 
@@ -744,8 +742,6 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC547) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED) },
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G1) },
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G1_M) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) },
 	/* Novatel Ovation MC551 a.k.a. Verizon USB551L */
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC551, 0xff, 0xff, 0xff) },
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 5fd9122..dfa3434 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -37,7 +37,13 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_G1K(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
 	{DEVICE_G1K(0x413c, 0x8172)},	/* Dell Gobi Modem device */
 	{DEVICE_G1K(0x413c, 0x8171)},	/* Dell Gobi QDL device */
-	{DEVICE_G1K(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa001)},	/* Novatel/Verizon USB-1000 */
+	{DEVICE_G1K(0x1410, 0xa002)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa003)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa004)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa005)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa006)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa007)},	/* Novatel Gobi Modem device */
 	{DEVICE_G1K(0x1410, 0xa008)},	/* Novatel Gobi QDL device */
 	{DEVICE_G1K(0x0b05, 0x1776)},	/* Asus Gobi Modem device */
 	{DEVICE_G1K(0x0b05, 0x1774)},	/* Asus Gobi QDL device */
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 5855d17..9d8feac 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -42,6 +42,7 @@
 #include <linux/kd.h>
 #include <linux/slab.h>
 #include <linux/vt_kern.h>
+#include <linux/sched.h>
 #include <linux/selection.h>
 #include <linux/spinlock.h>
 #include <linux/ioport.h>
@@ -1124,11 +1125,15 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 
 	if (arg) {
 		if (set)
-			for (i = 0; i < cmapsz; i++)
+			for (i = 0; i < cmapsz; i++) {
 				vga_writeb(arg[i], charmap + i);
+				cond_resched();
+			}
 		else
-			for (i = 0; i < cmapsz; i++)
+			for (i = 0; i < cmapsz; i++) {
 				arg[i] = vga_readb(charmap + i);
+				cond_resched();
+			}
 
 		/*
 		 * In 512-character mode, the character map is not contiguous if
@@ -1139,11 +1144,15 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 			charmap += 2 * cmapsz;
 			arg += cmapsz;
 			if (set)
-				for (i = 0; i < cmapsz; i++)
+				for (i = 0; i < cmapsz; i++) {
 					vga_writeb(arg[i], charmap + i);
+					cond_resched();
+				}
 			else
-				for (i = 0; i < cmapsz; i++)
+				for (i = 0; i < cmapsz; i++) {
 					arg[i] = vga_readb(charmap + i);
+					cond_resched();
+				}
 		}
 	}
 
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index a513a54..f2b2ffd 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -323,14 +323,14 @@ UniToupper(register wchar_t uc)
 /*
  * UniStrupr:  Upper case a unicode string
  */
-static inline wchar_t *
-UniStrupr(register wchar_t *upin)
+static inline __le16 *
+UniStrupr(register __le16 *upin)
 {
-	register wchar_t *up;
+	register __le16 *up;
 
 	up = upin;
 	while (*up) {		/* For all characters */
-		*up = UniToupper(*up);
+		*up = cpu_to_le16(UniToupper(le16_to_cpu(*up)));
 		up++;
 	}
 	return upin;		/* Return input pointer */
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 63c460e..6d0c62a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -394,7 +394,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	int rc = 0;
 	int len;
 	char nt_hash[CIFS_NTHASH_SIZE];
-	wchar_t *user;
+	__le16 *user;
 	wchar_t *domain;
 	wchar_t *server;
 
@@ -419,7 +419,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		return rc;
 	}
 
-	/* convert ses->user_name to unicode and uppercase */
+	/* convert ses->user_name to unicode */
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
@@ -429,7 +429,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	}
 
 	if (len) {
-		len = cifs_strtoUTF16((__le16 *)user, ses->user_name, len, nls_cp);
+		len = cifs_strtoUTF16(user, ses->user_name, len, nls_cp);
 		UniStrupr(user);
 	} else {
 		memset(user, '\0', 2);
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 4a84e75..7da1b7e 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -218,7 +218,8 @@ void ext3_evict_inode (struct inode *inode)
 	 */
 	if (inode->i_nlink && ext3_should_journal_data(inode) &&
 	    EXT3_SB(inode->i_sb)->s_journal &&
-	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
+	    inode->i_ino != EXT3_JOURNAL_INO) {
 		tid_t commit_tid = atomic_read(&ei->i_datasync_tid);
 		journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index eeb63df..336256a 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -573,11 +573,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
 					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
 						+((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse (bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext3fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5101df2..177f655 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4783,7 +4783,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		error = ext4_get_inode_loc(inode, &iloc);
 		if (error)
 			return error;
-		physical = iloc.bh->b_blocknr << blockbits;
+		physical = (__u64)iloc.bh->b_blocknr << blockbits;
 		offset = EXT4_GOOD_OLD_INODE_SIZE +
 				EXT4_I(inode)->i_extra_isize;
 		physical += offset;
@@ -4791,7 +4791,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		flags |= FIEMAP_EXTENT_DATA_INLINE;
 		brelse(iloc.bh);
 	} else { /* external block */
-		physical = EXT4_I(inode)->i_file_acl << blockbits;
+		physical = (__u64)EXT4_I(inode)->i_file_acl << blockbits;
 		length = inode->i_sb->s_blocksize;
 	}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 55006fa..8aacdda 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4317,7 +4317,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
 	struct inode *inode;
-	unsigned long delalloc_blocks;
+	unsigned long long delalloc_blocks;
 
 	inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
@@ -4335,7 +4335,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
 				EXT4_I(inode)->i_reserved_data_blocks);
 
-	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
+	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits-9);
 	return 0;
 }
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 20c13eb..43a35db 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -859,11 +859,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 				(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
 					 + ((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse(bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext4fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
diff --git a/fs/hpfs/map.c b/fs/hpfs/map.c
index 4acb19d..803d3da 100644
--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -17,7 +17,8 @@ __le32 *hpfs_map_bitmap(struct super_block *s, unsigned bmp_block,
 			 struct quad_buffer_head *qbh, char *id)
 {
 	secno sec;
-	if (hpfs_sb(s)->sb_chk) if (bmp_block * 16384 > hpfs_sb(s)->sb_fs_size) {
+	unsigned n_bands = (hpfs_sb(s)->sb_fs_size + 0x3fff) >> 14;
+	if (hpfs_sb(s)->sb_chk) if (bmp_block >= n_bands) {
 		hpfs_error(s, "hpfs_map_bitmap called with bad parameter: %08x at %s", bmp_block, id);
 		return NULL;
 	}
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 706a12c..8d250192 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -552,7 +552,13 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	sbi->sb_cp_table = NULL;
 	sbi->sb_c_bitmap = -1;
 	sbi->sb_max_fwd_alloc = 0xffffff;
-	
+
+	if (sbi->sb_fs_size >= 0x80000000) {
+		hpfs_error(s, "invalid size in superblock: %08x",
+			(unsigned)sbi->sb_fs_size);
+		goto bail4;
+	}
+
 	/* Load bitmap directory */
 	if (!(sbi->sb_bmp_dir = hpfs_load_bitmap_directory(s, le32_to_cpu(superblock->bitmaps))))
 		goto bail4;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index dfb0e5b..34cdd6d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1304,6 +1304,7 @@ static int journal_reset(journal_t *journal)
 static void jbd2_write_superblock(journal_t *journal, int write_op)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
+	journal_superblock_t *sb = journal->j_superblock;
 	int ret;
 
 	trace_jbd2_write_superblock(journal, write_op);
@@ -1325,6 +1326,7 @@ static void jbd2_write_superblock(journal_t *journal, int write_op)
 		clear_buffer_write_io_error(bh);
 		set_buffer_uptodate(bh);
 	}
+	jbd2_superblock_csum_set(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
 	ret = submit_bh(write_op, bh);
@@ -1421,7 +1423,6 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n",
 		  journal->j_errno);
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
-	jbd2_superblock_csum_set(journal, sb);
 	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, WRITE_SYNC);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 399e4ee..81203d1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -500,10 +500,10 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
 		   &transaction->t_outstanding_credits);
 	if (atomic_dec_and_test(&transaction->t_updates))
 		wake_up(&journal->j_wait_updates);
+	tid = transaction->t_tid;
 	spin_unlock(&transaction->t_handle_lock);
 
 	jbd_debug(2, "restarting handle %p\n", handle);
-	tid = transaction->t_tid;
 	need_to_start = !tid_geq(journal->j_commit_request, tid);
 	read_unlock(&journal->j_state_lock);
 	if (need_to_start)
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2e3ea30..5b8d944 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6499,6 +6499,16 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
 	}
 
 	new_oi = OCFS2_I(args->new_inode);
+	/*
+	 * Adjust extent record count to reserve space for extended attribute.
+	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
+	 */
+	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	    !(ocfs2_inode_is_fast_symlink(args->new_inode))) {
+		struct ocfs2_extent_list *el = &new_di->id2.i_list;
+		le16_add_cpu(&el->l_count, -(inline_size /
+					sizeof(struct ocfs2_extent_rec)));
+	}
 	spin_lock(&new_oi->ip_lock);
 	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
 	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index eee8b0b..6cf4a63 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -29,7 +29,12 @@
 #define EFI_UNSUPPORTED		( 3 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_BAD_BUFFER_SIZE     ( 4 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_BUFFER_TOO_SMALL	( 5 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_NOT_READY		( 6 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_DEVICE_ERROR	( 7 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_WRITE_PROTECTED	( 8 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_OUT_OF_RESOURCES	( 9 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_NOT_FOUND		(14 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_SECURITY_VIOLATION	(26 | (1UL << (BITS_PER_LONG-1)))
 
 typedef unsigned long efi_status_t;
 typedef u8 efi_bool_t;
@@ -257,6 +262,7 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 					      unsigned long count,
 					      u64 *max_size,
 					      int *reset_type);
+typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
 
 /*
  *  EFI Configuration Table and GUID definitions
@@ -498,8 +504,14 @@ extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #ifdef CONFIG_X86
 extern void efi_free_boot_services(void);
+extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
 #else
 static inline void efi_free_boot_services(void) {}
+
+static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	return EFI_SUCCESS;
+}
 #endif
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
@@ -652,6 +664,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_query_variable_store_t *query_variable_store;
 };
 
 struct efivars {
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index d146ca1..e6fe174 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -68,6 +68,7 @@ struct nbd_device {
 	u64 bytesize;
 	pid_t pid; /* pid of nbd-client, if attached */
 	int xmit_timeout;
+	int disconnect; /* a disconnect has been requested by user */
 };
 
 #endif
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 57c0251..93bae71 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -83,6 +83,22 @@ extern __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 
 extern int ipv6_netfilter_init(void);
 extern void ipv6_netfilter_fini(void);
+
+/*
+ * Hook functions for ipv6 to allow xt_* modules to be built-in even
+ * if IPv6 is a module.
+ */
+struct nf_ipv6_ops {
+	int (*chk_addr)(struct net *net, const struct in6_addr *addr,
+			const struct net_device *dev, int strict);
+};
+
+extern const struct nf_ipv6_ops __rcu *nf_ipv6_ops;
+static inline const struct nf_ipv6_ops *nf_get_ipv6_ops(void)
+{
+	return rcu_dereference(nf_ipv6_ops);
+}
+
 #else /* CONFIG_NETFILTER */
 static inline int ipv6_netfilter_init(void) { return 0; }
 static inline void ipv6_netfilter_fini(void) { return; }
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index f2b801c..91b2a85 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -60,7 +60,7 @@ extern int			addrconf_set_dstaddr(struct net *net,
 
 extern int			ipv6_chk_addr(struct net *net,
 					      const struct in6_addr *addr,
-					      struct net_device *dev,
+					      const struct net_device *dev,
 					      int strict);
 
 #if defined(CONFIG_IPV6_MIP6) || defined(CONFIG_IPV6_MIP6_MODULE)
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5168e37..3b3fa5b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2771,13 +2771,17 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 {
 	LIST_HEAD(pending);
 	struct cgroup *cgrp, *n;
+	struct super_block *sb = ss->root->sb;
 
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't attached */
-	if (cfts && ss->root != &rootnode) {
+	if (cfts && ss->root != &rootnode &&
+	    atomic_inc_not_zero(&sb->s_active)) {
 		list_for_each_entry(cgrp, &ss->root->allcg_list, allcg_node) {
 			dget(cgrp->dentry);
 			list_add_tail(&cgrp->cft_q_node, &pending);
 		}
+	} else {
+		sb = NULL;
 	}
 
 	mutex_unlock(&cgroup_mutex);
@@ -2800,6 +2804,9 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 		dput(cgrp->dentry);
 	}
 
+	if (sb)
+		deactivate_super(sb);
+
 	mutex_unlock(&cgroup_cft_mutex);
 }
 
@@ -3623,6 +3630,23 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
 }
 
 /*
+ * When dput() is called asynchronously, if umount has been done and
+ * then deactivate_super() in cgroup_free_fn() kills the superblock,
+ * there's a small window that vfs will see the root dentry with non-zero
+ * refcnt and trigger BUG().
+ *
+ * That's why we hold a reference before dput() and drop it right after.
+ */
+static void cgroup_dput(struct cgroup *cgrp)
+{
+	struct super_block *sb = cgrp->root->sb;
+
+	atomic_inc(&sb->s_active);
+	dput(cgrp->dentry);
+	deactivate_super(sb);
+}
+
+/*
  * Unregister event and free resources.
  *
  * Gets called from workqueue.
@@ -3637,7 +3661,7 @@ static void cgroup_event_remove(struct work_struct *work)
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
-	dput(cgrp->dentry);
+	cgroup_dput(cgrp);
 }
 
 /*
@@ -3888,12 +3912,8 @@ static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
-	struct dentry *dentry = css->cgroup->dentry;
-	struct super_block *sb = dentry->d_sb;
 
-	atomic_inc(&sb->s_active);
-	dput(dentry);
-	deactivate_super(sb);
+	cgroup_dput(css->cgroup);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b4c6385..a561ed3 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -554,9 +554,9 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 		return 0;
 
 	if (irq_settings_can_request(desc)) {
-		if (desc->action)
-			if (irqflags & desc->action->flags & IRQF_SHARED)
-				canrequest =1;
+		if (!desc->action ||
+		    irqflags & desc->action->flags & IRQF_SHARED)
+			canrequest = 1;
 	}
 	irq_put_desc_unlock(desc, flags);
 	return canrequest;
diff --git a/kernel/printk.c b/kernel/printk.c
index 5758501..e959512 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1330,9 +1330,9 @@ static int console_trylock_for_printk(unsigned int cpu)
 		}
 	}
 	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 239a323..f8961bf 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -400,7 +400,15 @@ void tick_check_oneshot_broadcast(int cpu)
 	if (cpumask_test_cpu(cpu, to_cpumask(tick_broadcast_oneshot_mask))) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
-		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
+		/*
+		 * We might be in the middle of switching over from
+		 * periodic to oneshot. If the CPU has not yet
+		 * switched over, leave the device alone.
+		 */
+		if (td->mode == TICKDEV_MODE_ONESHOT) {
+			clockevents_set_mode(td->evtdev,
+					     CLOCK_EVT_MODE_ONESHOT);
+		}
 	}
 }
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 742912b..fab4c3b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -145,9 +145,11 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
 	/* now that we have rounded, subtract the extra skew again */
 	j -= cpu * 3;
 
-	if (j <= jiffies) /* rounding ate our timeout entirely; */
-		return original;
-	return j;
+	/*
+	 * Make sure j is still in the future. Otherwise return the
+	 * unmodified value.
+	 */
+	return time_is_after_jiffies(j) ? j : original;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0ae8b32..8aba3f9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -672,7 +672,15 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
 	max_data->pid = tsk->pid;
-	max_data->uid = task_uid(tsk);
+	/*
+	 * If tsk == current, then use current_uid(), as that does not use
+	 * RCU. The irq tracer can be called out of RCU scope.
+	 */
+	if (tsk == current)
+		max_data->uid = current_uid();
+	else
+		max_data->uid = task_uid(tsk);
+
 	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
 	max_data->policy = tsk->policy;
 	max_data->rt_priority = tsk->rt_priority;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ed96c7..63e6fa4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5911,6 +5911,10 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		zone->free_area[order].nr_free--;
 		__mod_zone_page_state(zone, NR_FREE_PAGES,
 				      - (1UL << order));
+#ifdef CONFIG_HIGHMEM
+		if (PageHighMem(page))
+			totalhigh_pages -= 1 << order;
+#endif
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index 925ca58..8c93fa8 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -39,6 +39,11 @@ static int should_authenticate(struct ceph_auth_client *ac)
 	return xi->starting;
 }
 
+static int build_request(struct ceph_auth_client *ac, void *buf, void *end)
+{
+	return 0;
+}
+
 /*
  * the generic auth code decode the global_id, and we carry no actual
  * authenticate state, so nothing happens here.
@@ -106,6 +111,7 @@ static const struct ceph_auth_client_ops ceph_auth_none_ops = {
 	.destroy = destroy,
 	.is_authenticated = is_authenticated,
 	.should_authenticate = should_authenticate,
+	.build_request = build_request,
 	.handle_reply = handle_reply,
 	.create_authorizer = ceph_auth_none_create_authorizer,
 	.destroy_authorizer = ceph_auth_none_destroy_authorizer,
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index ba5756d..60d2bba 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -214,8 +214,10 @@ static void ipt_ulog_packet(unsigned int hooknum,
 	put_unaligned(tv.tv_usec, &pm->timestamp_usec);
 	put_unaligned(skb->mark, &pm->mark);
 	pm->hook = hooknum;
-	if (prefix != NULL)
-		strncpy(pm->prefix, prefix, sizeof(pm->prefix));
+	if (prefix != NULL) {
+		strncpy(pm->prefix, prefix, sizeof(pm->prefix) - 1);
+		pm->prefix[sizeof(pm->prefix) - 1] = '\0';
+	}
 	else if (loginfo->prefix[0] != '\0')
 		strncpy(pm->prefix, loginfo->prefix, sizeof(pm->prefix));
 	else
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f67075b..449df3f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1270,7 +1270,7 @@ static int ipv6_count_addresses(struct inet6_dev *idev)
 }
 
 int ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
-		  struct net_device *dev, int strict)
+		  const struct net_device *dev, int strict)
 {
 	struct inet6_ifaddr *ifp;
 	struct hlist_node *node;
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index db31561..e464bef 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -4,6 +4,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/export.h>
+#include <net/addrconf.h>
 #include <net/dst.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
@@ -172,6 +173,10 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 	return csum;
 };
 
+static const struct nf_ipv6_ops ipv6ops = {
+	.chk_addr	= ipv6_chk_addr,
+};
+
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
 	.checksum		= nf_ip6_checksum,
@@ -184,6 +189,7 @@ static const struct nf_afinfo nf_ip6_afinfo = {
 
 int __init ipv6_netfilter_init(void)
 {
+	RCU_INIT_POINTER(nf_ipv6_ops, &ipv6ops);
 	return nf_register_afinfo(&nf_ip6_afinfo);
 }
 
@@ -192,5 +198,6 @@ int __init ipv6_netfilter_init(void)
  */
 void ipv6_netfilter_fini(void)
 {
+	RCU_INIT_POINTER(nf_ipv6_ops, NULL);
 	nf_unregister_afinfo(&nf_ip6_afinfo);
 }
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index e19f365..080356f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -29,6 +29,8 @@ static DEFINE_MUTEX(afinfo_mutex);
 
 const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;
 EXPORT_SYMBOL(nf_afinfo);
+const struct nf_ipv6_ops __rcu *nf_ipv6_ops __read_mostly;
+EXPORT_SYMBOL_GPL(nf_ipv6_ops);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo)
 {
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index a54b018c..40f9ad8 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1378,7 +1378,8 @@ ip_vs_in_icmp(struct sk_buff *skb, int *related, unsigned int hooknum)
 
 	/* do the statistics and put it back */
 	ip_vs_in_stats(cp, skb);
-	if (IPPROTO_TCP == cih->protocol || IPPROTO_UDP == cih->protocol)
+	if (IPPROTO_TCP == cih->protocol || IPPROTO_UDP == cih->protocol ||
+	    IPPROTO_SCTP == cih->protocol)
 		offset += 2 * sizeof(__u16);
 	verdict = ip_vs_icmp_xmit(skb, cp, pp, offset, hooknum);
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 72bf32a..526da6e 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2549,6 +2549,7 @@ __ip_vs_get_dest_entries(struct net *net, const struct ip_vs_get_dests *get,
 		struct ip_vs_dest *dest;
 		struct ip_vs_dest_entry entry;
 
+		memset(&entry, 0, sizeof(entry));
 		list_for_each_entry(dest, &svc->destinations, n_list) {
 			if (count >= get->num_dests)
 				break;
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index b2e7310..129188f 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -147,9 +147,12 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(cur, &nfnl_acct_list, head) {
-		if (last && cur != last)
-			continue;
+		if (last) {
+			if (cur != last)
+				continue;
 
+			last = NULL;
+		}
 		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).pid,
 				       cb->nlh->nlmsg_seq,
 				       NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 3e65528..dd6638a 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -216,9 +216,12 @@ ctnl_timeout_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(cur, &cttimeout_list, head) {
-		if (last && cur != last)
-			continue;
+		if (last) {
+			if (cur != last)
+				continue;
 
+			last = NULL;
+		}
 		if (ctnl_timeout_fill_info(skb, NETLINK_CB(cb->skb).pid,
 					   cb->nlh->nlmsg_seq,
 					   NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index ff5f75f..a2e878f 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -727,7 +727,7 @@ static void dump_ipv6_packet(struct sbuff *m,
 	}
 
 	/* Max length: 16 "MARK=0xFFFFFFFF " */
-	if (!recurse && skb->mark)
+	if (recurse && skb->mark)
 		sb_add(m, "MARK=0x%x ", skb->mark);
 }
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 71a266d..cc2b572 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -44,17 +44,22 @@ optlen(const u_int8_t *opt, unsigned int offset)
 
 static int
 tcpmss_mangle_packet(struct sk_buff *skb,
-		     const struct xt_tcpmss_info *info,
+		     const struct xt_action_param *par,
 		     unsigned int in_mtu,
 		     unsigned int tcphoff,
 		     unsigned int minlen)
 {
+	const struct xt_tcpmss_info *info = par->targinfo;
 	struct tcphdr *tcph;
 	unsigned int tcplen, i;
 	__be16 oldval;
 	u16 newmss;
 	u8 *opt;
 
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return XT_CONTINUE;
+
 	if (!skb_make_writable(skb, skb->len))
 		return -1;
 
@@ -124,6 +129,18 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 
 	skb_put(skb, TCPOLEN_MSS);
 
+	/*
+	 * IPv4: RFC 1122 states "If an MSS option is not received at
+	 * connection setup, TCP MUST assume a default send MSS of 536".
+	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
+	 * length IPv6 header of 60, ergo the default MSS value is 1220
+	 * Since no MSS was provided, we must use the default values
+	 */
+	if (par->family == NFPROTO_IPV4)
+		newmss = min(newmss, (u16)536);
+	else
+		newmss = min(newmss, (u16)1220);
+
 	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
 
@@ -181,7 +198,7 @@ tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, par->targinfo,
+	ret = tcpmss_mangle_packet(skb, par,
 				   tcpmss_reverse_mtu(skb, PF_INET),
 				   iph->ihl * 4,
 				   sizeof(*iph) + sizeof(struct tcphdr));
@@ -210,7 +227,7 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, par->targinfo,
+	ret = tcpmss_mangle_packet(skb, par,
 				   tcpmss_reverse_mtu(skb, PF_INET6),
 				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 25fd1c4..b68fa19 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -30,18 +30,31 @@ static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
 
 static unsigned int
 tcpoptstrip_mangle_packet(struct sk_buff *skb,
-			  const struct xt_tcpoptstrip_target_info *info,
+			  const struct xt_action_param *par,
 			  unsigned int tcphoff, unsigned int minlen)
 {
+	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
 	unsigned int optl, i, j;
 	struct tcphdr *tcph;
 	u_int16_t n, o;
 	u_int8_t *opt;
+	int len;
+
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return XT_CONTINUE;
 
 	if (!skb_make_writable(skb, skb->len))
 		return NF_DROP;
 
+	len = skb->len - tcphoff;
+	if (len < (int)sizeof(struct tcphdr))
+		return NF_DROP;
+
 	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	if (tcph->doff * 4 > len)
+		return NF_DROP;
+
 	opt  = (u_int8_t *)tcph;
 
 	/*
@@ -76,7 +89,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 static unsigned int
 tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	return tcpoptstrip_mangle_packet(skb, par->targinfo, ip_hdrlen(skb),
+	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb),
 	       sizeof(struct iphdr) + sizeof(struct tcphdr));
 }
 
@@ -94,7 +107,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	if (tcphoff < 0)
 		return NF_DROP;
 
-	return tcpoptstrip_mangle_packet(skb, par->targinfo, tcphoff,
+	return tcpoptstrip_mangle_packet(skb, par, tcphoff,
 	       sizeof(*ipv6h) + sizeof(struct tcphdr));
 }
 #endif
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index 49c5ff7..68ff29f 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -22,6 +22,7 @@
 #include <net/ip6_fib.h>
 #endif
 
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/xt_addrtype.h>
 #include <linux/netfilter/x_tables.h>
 
@@ -33,12 +34,12 @@ MODULE_ALIAS("ip6t_addrtype");
 
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
-			    const struct in6_addr *addr)
+			    const struct in6_addr *addr, u16 mask)
 {
 	const struct nf_afinfo *afinfo;
 	struct flowi6 flow;
 	struct rt6_info *rt;
-	u32 ret;
+	u32 ret = 0;
 	int route_err;
 
 	memset(&flow, 0, sizeof(flow));
@@ -49,12 +50,19 @@ static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
 	rcu_read_lock();
 
 	afinfo = nf_get_afinfo(NFPROTO_IPV6);
-	if (afinfo != NULL)
+	if (afinfo != NULL) {
+		const struct nf_ipv6_ops *v6ops;
+
+		if (dev && (mask & XT_ADDRTYPE_LOCAL)) {
+			v6ops = nf_get_ipv6_ops();
+			if (v6ops && v6ops->chk_addr(net, addr, dev, true))
+				ret = XT_ADDRTYPE_LOCAL;
+		}
 		route_err = afinfo->route(net, (struct dst_entry **)&rt,
-					flowi6_to_flowi(&flow), !!dev);
-	else
+					  flowi6_to_flowi(&flow), false);
+	} else {
 		route_err = 1;
-
+	}
 	rcu_read_unlock();
 
 	if (route_err)
@@ -62,15 +70,12 @@ static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
 
 	if (rt->rt6i_flags & RTF_REJECT)
 		ret = XT_ADDRTYPE_UNREACHABLE;
-	else
-		ret = 0;
 
-	if (rt->rt6i_flags & RTF_LOCAL)
+	if (dev == NULL && rt->rt6i_flags & RTF_LOCAL)
 		ret |= XT_ADDRTYPE_LOCAL;
 	if (rt->rt6i_flags & RTF_ANYCAST)
 		ret |= XT_ADDRTYPE_ANYCAST;
 
-
 	dst_release(&rt->dst);
 	return ret;
 }
@@ -90,7 +95,7 @@ static bool match_type6(struct net *net, const struct net_device *dev,
 
 	if ((XT_ADDRTYPE_LOCAL | XT_ADDRTYPE_ANYCAST |
 	     XT_ADDRTYPE_UNREACHABLE) & mask)
-		return !!(mask & match_lookup_rt6(net, dev, addr));
+		return !!(mask & match_lookup_rt6(net, dev, addr, mask));
 	return true;
 }
 
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 45e3102..2af1285 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -910,7 +910,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 	per_cvt->assigned = 1;
 	hinfo->nid = per_cvt->cvt_nid;
 
-	snd_hda_codec_write(codec, per_pin->pin_nid, 0,
+	snd_hda_codec_write_cache(codec, per_pin->pin_nid, 0,
 			    AC_VERB_SET_CONNECT_SEL,
 			    mux_idx);
 	snd_hda_spdif_ctls_assign(codec, pin_idx, per_cvt->cvt_nid);
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index dab6256..bff98fb 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1600,7 +1600,6 @@ static int wm8962_put_hp_sw(struct snd_kcontrol *kcontrol,
 			    struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	/* Apply the update (if any) */
@@ -1609,16 +1608,19 @@ static int wm8962_put_hp_sw(struct snd_kcontrol *kcontrol,
 		return 0;
 
 	/* If the left PGA is enabled hit that VU bit... */
-	if (snd_soc_read(codec, WM8962_PWR_MGMT_2) & WM8962_HPOUTL_PGA_ENA)
-		return snd_soc_write(codec, WM8962_HPOUTL_VOLUME,
-				     reg_cache[WM8962_HPOUTL_VOLUME]);
+	ret = snd_soc_read(codec, WM8962_PWR_MGMT_2);
+	if (ret & WM8962_HPOUTL_PGA_ENA) {
+		snd_soc_write(codec, WM8962_HPOUTL_VOLUME,
+			      snd_soc_read(codec, WM8962_HPOUTL_VOLUME));
+		return 1;
+	}
 
 	/* ...otherwise the right.  The VU is stereo. */
-	if (snd_soc_read(codec, WM8962_PWR_MGMT_2) & WM8962_HPOUTR_PGA_ENA)
-		return snd_soc_write(codec, WM8962_HPOUTR_VOLUME,
-				     reg_cache[WM8962_HPOUTR_VOLUME]);
+	if (ret & WM8962_HPOUTR_PGA_ENA)
+		snd_soc_write(codec, WM8962_HPOUTR_VOLUME,
+			      snd_soc_read(codec, WM8962_HPOUTR_VOLUME));
 
-	return 0;
+	return 1;
 }
 
 /* The VU bits for the speakers are in a different register to the mute
@@ -3375,7 +3377,6 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 	int ret;
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
 	struct wm8962_pdata *pdata = dev_get_platdata(codec->dev);
-	u16 *reg_cache = codec->reg_cache;
 	int i, trigger, irq_pol;
 	bool dmicclk, dmicdat;
 
@@ -3433,8 +3434,9 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 
 		/* Put the speakers into mono mode? */
 		if (pdata->spk_mono)
-			reg_cache[WM8962_CLASS_D_CONTROL_2]
-				|= WM8962_SPK_MONO;
+			snd_soc_update_bits(codec, WM8962_CLASS_D_CONTROL_2,
+				WM8962_SPK_MONO_MASK, WM8962_SPK_MONO);
+
 
 		/* Micbias setup, detection enable and detection
 		 * threasholds. */
