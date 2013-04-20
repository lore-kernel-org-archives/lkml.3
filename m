Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3DTRVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 13:21:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34789 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab3DTRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 13:21:48 -0400
Date: Sat, 20 Apr 2013 10:20:27 -0700
Message-Id: <201304201720.r3KHKRvr007230@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.9
Cc: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Weinberger <richard@nod.at>, Sergey Vlasov <vsu@altlinux.ru>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 20 Apr 2013 10:20:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Three groups of fixes:

1. Make sure we don't execute the early microcode patching if
   family < 6, since it would touch MSRs which don't exist on those
   families, causing crashes.

2. The Xen partial emulation of HyperV can be dealt with more
   gracefully than just disabling the driver.

3. More EFI variable space magic.  In particular, variables hidden
   from runtime code need to be taken into account too.

The following changes since commit 26564600c9e88c6572a5e6ef5ae9121907edfb7f:

  x86/mm: Flush lazy MMU when DEBUG_PAGEALLOC is set (2013-04-12 07:19:19 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to c0a9f451e4e7ecd2ad1a6c27ea5c31d0226bdddf:

  Merge remote-tracking branch 'efi/urgent' into x86/urgent (2013-04-19 17:09:03 -0700)

----------------------------------------------------------------

H. Peter Anvin (2):
      x86, microcode: Verify the family before dispatching microcode patching
      Merge remote-tracking branch 'efi/urgent' into x86/urgent

K. Y. Srinivasan (1):
      x86, hyperv: Handle Xen emulation of Hyper-V more gracefully

Matt Fleming (1):
      x86, efivars: firmware bug workarounds should be in platform code

Matthew Garrett (3):
      Move utf16 functions to kernel core and rename
      efi: Pass boot services variable info to runtime code
      efi: Distinguish between "remaining space" and actually used space

Richard Weinberger (2):
      x86,efi: Check max_size only if it is non-zero.
      x86,efi: Implement efi_no_storage_paranoia parameter

Sergey Vlasov (2):
      x86/Kconfig: Make EFI select UCS2_STRING
      efi: Export efi_query_variable_store() for efivars.ko

 Documentation/kernel-parameters.txt    |   6 ++
 arch/x86/Kconfig                       |   1 +
 arch/x86/boot/compressed/eboot.c       |  47 +++++++++
 arch/x86/include/asm/efi.h             |   7 ++
 arch/x86/include/uapi/asm/bootparam.h  |   1 +
 arch/x86/kernel/cpu/mshyperv.c         |  18 +---
 arch/x86/kernel/microcode_core_early.c |  38 ++++++--
 arch/x86/platform/efi/efi.c            | 168 ++++++++++++++++++++++++++++++++-
 drivers/firmware/Kconfig               |   1 +
 drivers/firmware/efivars.c             |  98 +++++--------------
 include/linux/efi.h                    |   9 +-
 include/linux/ucs2_string.h            |  14 +++
 lib/Kconfig                            |   3 +
 lib/Makefile                           |   2 +
 lib/ucs2_string.c                      |  51 ++++++++++
 15 files changed, 361 insertions(+), 103 deletions(-)
 create mode 100644 include/linux/ucs2_string.h
 create mode 100644 lib/ucs2_string.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..d1cc3a9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -788,6 +788,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..15b5cef 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1549,6 +1549,7 @@ config X86_SMAP
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
+	select UCS2_STRING
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c205035..8615f75 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -251,6 +251,51 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 	*size = len;
 }
 
+static efi_status_t setup_efi_vars(struct boot_params *params)
+{
+	struct setup_data *data;
+	struct efi_var_bootdata *efidata;
+	u64 store_size, remaining_size, var_size;
+	efi_status_t status;
+
+	if (!sys_table->runtime->query_variable_info)
+		return EFI_UNSUPPORTED;
+
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
+
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
+
+	status = efi_call_phys4(sys_table->runtime->query_variable_info,
+				EFI_VARIABLE_NON_VOLATILE |
+				EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
+				&remaining_size, &var_size);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+				EFI_LOADER_DATA, sizeof(*efidata), &efidata);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	efidata->data.type = SETUP_EFI_VARS;
+	efidata->data.len = sizeof(struct efi_var_bootdata) -
+		sizeof(struct setup_data);
+	efidata->data.next = 0;
+	efidata->store_size = store_size;
+	efidata->remaining_size = remaining_size;
+	efidata->max_var_size = var_size;
+
+	if (data)
+		data->next = (unsigned long)efidata;
+	else
+		params->hdr.setup_data = (unsigned long)efidata;
+
+}
+
 static efi_status_t setup_efi_pci(struct boot_params *params)
 {
 	efi_pci_io_protocol *pci;
@@ -1157,6 +1202,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 
 	setup_graphics(boot_params);
 
+	setup_efi_vars(boot_params);
+
 	setup_efi_pci(boot_params);
 
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 60c89f3..2fb5d58 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -102,6 +102,13 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 
+struct efi_var_bootdata {
+	struct setup_data data;
+	u64 store_size;
+	u64 remaining_size;
+	u64 max_var_size;
+};
+
 #ifdef CONFIG_EFI
 
 static inline bool efi_is_native(void)
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c15ddaf..0874424 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -6,6 +6,7 @@
 #define SETUP_E820_EXT			1
 #define SETUP_DTB			2
 #define SETUP_PCI			3
+#define SETUP_EFI_VARS			4
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index a7d26d8..8f4be53 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -35,13 +35,6 @@ static bool __init ms_hyperv_platform(void)
 	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return false;
 
-	/*
-	 * Xen emulates Hyper-V to support enlightened Windows.
-	 * Check to see first if we are on a Xen Hypervisor.
-	 */
-	if (xen_cpuid_base())
-		return false;
-
 	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
 	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
 
@@ -82,12 +75,6 @@ static void __init ms_hyperv_init_platform(void)
 
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
-#if IS_ENABLED(CONFIG_HYPERV)
-	/*
-	 * Setup the IDT for hypervisor callback.
-	 */
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
-#endif
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
@@ -103,6 +90,11 @@ static irq_handler_t vmbus_isr;
 
 void hv_register_vmbus_handler(int irq, irq_handler_t handler)
 {
+	/*
+	 * Setup the IDT for hypervisor callback.
+	 */
+	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
+
 	vmbus_irq = irq;
 	vmbus_isr = handler;
 }
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 577db84..833d51d 100644
--- a/arch/x86/kernel/microcode_core_early.c
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -45,9 +45,6 @@ static int __cpuinit x86_vendor(void)
 	u32 eax = 0x00000000;
 	u32 ebx, ecx = 0, edx;
 
-	if (!have_cpuid_p())
-		return X86_VENDOR_UNKNOWN;
-
 	native_cpuid(&eax, &ebx, &ecx, &edx);
 
 	if (CPUID_IS(CPUID_INTEL1, CPUID_INTEL2, CPUID_INTEL3, ebx, ecx, edx))
@@ -59,18 +56,45 @@ static int __cpuinit x86_vendor(void)
 	return X86_VENDOR_UNKNOWN;
 }
 
+static int __cpuinit x86_family(void)
+{
+	u32 eax = 0x00000001;
+	u32 ebx, ecx = 0, edx;
+	int x86;
+
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+
+	x86 = (eax >> 8) & 0xf;
+	if (x86 == 15)
+		x86 += (eax >> 20) & 0xff;
+
+	return x86;
+}
+
 void __init load_ucode_bsp(void)
 {
-	int vendor = x86_vendor();
+	int vendor, x86;
+
+	if (!have_cpuid_p())
+		return;
 
-	if (vendor == X86_VENDOR_INTEL)
+	vendor = x86_vendor();
+	x86 = x86_family();
+
+	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
 		load_ucode_intel_bsp();
 }
 
 void __cpuinit load_ucode_ap(void)
 {
-	int vendor = x86_vendor();
+	int vendor, x86;
+
+	if (!have_cpuid_p())
+		return;
+
+	vendor = x86_vendor();
+	x86 = x86_family();
 
-	if (vendor == X86_VENDOR_INTEL)
+	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
 		load_ucode_intel_ap();
 }
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5f2ecaf..e4a86a6 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -41,6 +41,7 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
+#include <linux/ucs2_string.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -51,6 +52,13 @@
 
 #define EFI_DEBUG	1
 
+/*
+ * There's some additional metadata associated with each
+ * variable. Intel's reference implementation is 60 bytes - bump that
+ * to account for potential alignment constraints
+ */
+#define VAR_METADATA_SIZE 64
+
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -69,6 +77,13 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+static u64 efi_var_store_size;
+static u64 efi_var_remaining_size;
+static u64 efi_var_max_var_size;
+static u64 boot_used_size;
+static u64 boot_var_size;
+static u64 active_size;
+
 unsigned long x86_efi_facility;
 
 /*
@@ -98,6 +113,15 @@ static int __init setup_add_efi_memmap(char *arg)
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
@@ -162,8 +186,53 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt3(get_next_variable,
-			      name_size, name, vendor);
+	efi_status_t status;
+	static bool finished = false;
+	static u64 var_size;
+
+	status = efi_call_virt3(get_next_variable,
+				name_size, name, vendor);
+
+	if (status == EFI_NOT_FOUND) {
+		finished = true;
+		if (var_size < boot_used_size) {
+			boot_var_size = boot_used_size - var_size;
+			active_size += boot_var_size;
+		} else {
+			printk(KERN_WARNING FW_BUG  "efi: Inconsistent initial sizes\n");
+		}
+	}
+
+	if (boot_used_size && !finished) {
+		unsigned long size;
+		u32 attr;
+		efi_status_t s;
+		void *tmp;
+
+		s = virt_efi_get_variable(name, vendor, &attr, &size, NULL);
+
+		if (s != EFI_BUFFER_TOO_SMALL || !size)
+			return status;
+
+		tmp = kmalloc(size, GFP_ATOMIC);
+
+		if (!tmp)
+			return status;
+
+		s = virt_efi_get_variable(name, vendor, &attr, &size, tmp);
+
+		if (s == EFI_SUCCESS && (attr & EFI_VARIABLE_NON_VOLATILE)) {
+			var_size += size;
+			var_size += ucs2_strsize(name, 1024);
+			active_size += size;
+			active_size += VAR_METADATA_SIZE;
+			active_size += ucs2_strsize(name, 1024);
+		}
+
+		kfree(tmp);
+	}
+
+	return status;
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -172,9 +241,34 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	return efi_call_virt5(set_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	efi_status_t status;
+	u32 orig_attr = 0;
+	unsigned long orig_size = 0;
+
+	status = virt_efi_get_variable(name, vendor, &orig_attr, &orig_size,
+				       NULL);
+
+	if (status != EFI_BUFFER_TOO_SMALL)
+		orig_size = 0;
+
+	status = efi_call_virt5(set_variable,
+				name, vendor, attr,
+				data_size, data);
+
+	if (status == EFI_SUCCESS) {
+		if (orig_size) {
+			active_size -= orig_size;
+			active_size -= ucs2_strsize(name, 1024);
+			active_size -= VAR_METADATA_SIZE;
+		}
+		if (data_size) {
+			active_size += data_size;
+			active_size += ucs2_strsize(name, 1024);
+			active_size += VAR_METADATA_SIZE;
+		}
+	}
+
+	return status;
 }
 
 static efi_status_t virt_efi_query_variable_info(u32 attr,
@@ -682,6 +776,9 @@ void __init efi_init(void)
 	char vendor[100] = "unknown";
 	int i = 0;
 	void *tmp;
+	struct setup_data *data;
+	struct efi_var_bootdata *efi_var_data;
+	u64 pa_data;
 
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
@@ -699,6 +796,22 @@ void __init efi_init(void)
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, sizeof(*efi_var_data));
+		if (data->type == SETUP_EFI_VARS) {
+			efi_var_data = (struct efi_var_bootdata *)data;
+
+			efi_var_store_size = efi_var_data->store_size;
+			efi_var_remaining_size = efi_var_data->remaining_size;
+			efi_var_max_var_size = efi_var_data->max_var_size;
+		}
+		pa_data = data->next;
+		early_iounmap(data, sizeof(*efi_var_data));
+	}
+
+	boot_used_size = efi_var_store_size - efi_var_remaining_size;
+
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
 	/*
@@ -999,3 +1112,48 @@ u64 efi_mem_attributes(unsigned long phys_addr)
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
+	status = efi.query_variable_info(attributes, &storage_size,
+					 &remaining_size, &max_size);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (!max_size && remaining_size > size)
+		printk_once(KERN_ERR FW_BUG "Broken EFI implementation"
+			    " is returning MaxVariableSize=0\n");
+	/*
+	 * Some firmware implementations refuse to boot if there's insufficient
+	 * space in the variable store. We account for that by refusing the
+	 * write if permitting it would reduce the available space to under
+	 * 50%. However, some firmware won't reclaim variable space until
+	 * after the used (not merely the actively used) space drops below
+	 * a threshold. We can approximate that case with the value calculated
+	 * above. If both the firmware and our calculations indicate that the
+	 * available space would drop below 50%, refuse the write.
+	 */
+
+	if (!storage_size || size > remaining_size ||
+	    (max_size && size > max_size))
+		return EFI_OUT_OF_RESOURCES;
+
+	if (!efi_no_storage_paranoia &&
+	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
+	     (remaining_size - size < storage_size / 2)))
+		return EFI_OUT_OF_RESOURCES;
+
+	return EFI_SUCCESS;
+}
+EXPORT_SYMBOL_GPL(efi_query_variable_store);
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 42c759a..3e53200 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -39,6 +39,7 @@ config FIRMWARE_MEMMAP
 config EFI_VARS
 	tristate "EFI Variable Support via sysfs"
 	depends on EFI
+	select UCS2_STRING
 	default n
 	help
 	  If you say Y here, you are able to get EFI (Extensible Firmware
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7acafb8..182ce94 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -80,6 +80,7 @@
 #include <linux/slab.h>
 #include <linux/pstore.h>
 #include <linux/ctype.h>
+#include <linux/ucs2_string.h>
 
 #include <linux/fs.h>
 #include <linux/ramfs.h>
@@ -172,51 +173,6 @@ static void efivar_update_sysfs_entries(struct work_struct *);
 static DECLARE_WORK(efivar_work, efivar_update_sysfs_entries);
 static bool efivar_wq_enabled = true;
 
-/* Return the number of unicode characters in data */
-static unsigned long
-utf16_strnlen(efi_char16_t *s, size_t maxlength)
-{
-	unsigned long length = 0;
-
-	while (*s++ != 0 && length < maxlength)
-		length++;
-	return length;
-}
-
-static inline unsigned long
-utf16_strlen(efi_char16_t *s)
-{
-	return utf16_strnlen(s, ~0UL);
-}
-
-/*
- * Return the number of bytes is the length of this string
- * Note: this is NOT the same as the number of unicode characters
- */
-static inline unsigned long
-utf16_strsize(efi_char16_t *data, unsigned long maxlength)
-{
-	return utf16_strnlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
-}
-
-static inline int
-utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
-{
-	while (1) {
-		if (len == 0)
-			return 0;
-		if (*a < *b)
-			return -1;
-		if (*a > *b)
-			return 1;
-		if (*a == 0) /* implies *b == 0 */
-			return 0;
-		a++;
-		b++;
-		len--;
-	}
-}
-
 static bool
 validate_device_path(struct efi_variable *var, int match, u8 *buffer,
 		     unsigned long len)
@@ -268,7 +224,7 @@ validate_load_option(struct efi_variable *var, int match, u8 *buffer,
 	u16 filepathlength;
 	int i, desclength = 0, namelen;
 
-	namelen = utf16_strnlen(var->VariableName, sizeof(var->VariableName));
+	namelen = ucs2_strnlen(var->VariableName, sizeof(var->VariableName));
 
 	/* Either "Boot" or "Driver" followed by four digits of hex */
 	for (i = match; i < match+4; i++) {
@@ -291,7 +247,7 @@ validate_load_option(struct efi_variable *var, int match, u8 *buffer,
 	 * There's no stored length for the description, so it has to be
 	 * found by hand
 	 */
-	desclength = utf16_strsize((efi_char16_t *)(buffer + 6), len - 6) + 2;
+	desclength = ucs2_strsize((efi_char16_t *)(buffer + 6), len - 6) + 2;
 
 	/* Each boot entry must have a descriptor */
 	if (!desclength)
@@ -436,24 +392,12 @@ static efi_status_t
 check_var_size_locked(struct efivars *efivars, u32 attributes,
 			unsigned long size)
 {
-	u64 storage_size, remaining_size, max_size;
-	efi_status_t status;
 	const struct efivar_operations *fops = efivars->ops;
 
-	if (!efivars->ops->query_variable_info)
+	if (!efivars->ops->query_variable_store)
 		return EFI_UNSUPPORTED;
 
-	status = fops->query_variable_info(attributes, &storage_size,
-					   &remaining_size, &max_size);
-
-	if (status != EFI_SUCCESS)
-		return status;
-
-	if (!storage_size || size > remaining_size || size > max_size ||
-	    (remaining_size - size) < (storage_size / 2))
-		return EFI_OUT_OF_RESOURCES;
-
-	return status;
+	return fops->query_variable_store(attributes, size);
 }
 
 
@@ -593,7 +537,7 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	spin_lock_irq(&efivars->lock);
 
 	status = check_var_size_locked(efivars, new_var->Attributes,
-	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+	       new_var->DataSize + ucs2_strsize(new_var->VariableName, 1024));
 
 	if (status == EFI_SUCCESS || status == EFI_UNSUPPORTED)
 		status = efivars->ops->set_variable(new_var->VariableName,
@@ -771,7 +715,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	 * QueryVariableInfo() isn't supported by the firmware.
 	 */
 
-	varsize = datasize + utf16_strsize(var->var.VariableName, 1024);
+	varsize = datasize + ucs2_strsize(var->var.VariableName, 1024);
 	status = check_var_size(efivars, attributes, varsize);
 
 	if (status != EFI_SUCCESS) {
@@ -1223,7 +1167,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		inode = NULL;
 
-		len = utf16_strlen(entry->var.VariableName);
+		len = ucs2_strlen(entry->var.VariableName);
 
 		/* name, plus '-', plus GUID, plus NUL*/
 		name = kmalloc(len + 1 + GUID_LEN + 1, GFP_ATOMIC);
@@ -1481,8 +1425,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 
 		if (efi_guidcmp(entry->var.VendorGuid, vendor))
 			continue;
-		if (utf16_strncmp(entry->var.VariableName, efi_name,
-				  utf16_strlen(efi_name))) {
+		if (ucs2_strncmp(entry->var.VariableName, efi_name,
+				  ucs2_strlen(efi_name))) {
 			/*
 			 * Check if an old format,
 			 * which doesn't support holding
@@ -1494,8 +1438,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 			for (i = 0; i < DUMP_NAME_LEN; i++)
 				efi_name_old[i] = name_old[i];
 
-			if (utf16_strncmp(entry->var.VariableName, efi_name_old,
-					  utf16_strlen(efi_name_old)))
+			if (ucs2_strncmp(entry->var.VariableName, efi_name_old,
+					  ucs2_strlen(efi_name_old)))
 				continue;
 		}
 
@@ -1573,8 +1517,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	 * Does this variable already exist?
 	 */
 	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(new_var->VariableName, 1024);
+		strsize1 = ucs2_strsize(search_efivar->var.VariableName, 1024);
+		strsize2 = ucs2_strsize(new_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(&(search_efivar->var.VariableName),
 				new_var->VariableName, strsize1) &&
@@ -1590,7 +1534,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	}
 
 	status = check_var_size_locked(efivars, new_var->Attributes,
-	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+	       new_var->DataSize + ucs2_strsize(new_var->VariableName, 1024));
 
 	if (status && status != EFI_UNSUPPORTED) {
 		spin_unlock_irq(&efivars->lock);
@@ -1614,7 +1558,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
-					   utf16_strsize(new_var->VariableName,
+					   ucs2_strsize(new_var->VariableName,
 							 1024),
 					   new_var->VariableName,
 					   &new_var->VendorGuid);
@@ -1644,8 +1588,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	 * Does this variable already exist?
 	 */
 	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(del_var->VariableName, 1024);
+		strsize1 = ucs2_strsize(search_efivar->var.VariableName, 1024);
+		strsize2 = ucs2_strsize(del_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(&(search_efivar->var.VariableName),
 				del_var->VariableName, strsize1) &&
@@ -1691,9 +1635,9 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
 	unsigned long strsize1, strsize2;
 	bool found = false;
 
-	strsize1 = utf16_strsize(variable_name, 1024);
+	strsize1 = ucs2_strsize(variable_name, 1024);
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
+		strsize2 = ucs2_strsize(entry->var.VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(variable_name, &(entry->var.VariableName),
 				strsize2) &&
@@ -2131,7 +2075,7 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
-	ops.query_variable_info = efi.query_variable_info;
+	ops.query_variable_store = efi_query_variable_store;
 
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 9bf2f1f..3d7df3d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -333,6 +333,7 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 					      unsigned long count,
 					      u64 *max_size,
 					      int *reset_type);
+typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
 
 /*
  *  EFI Configuration Table and GUID definitions
@@ -575,9 +576,15 @@ extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if pos
 #ifdef CONFIG_X86
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
+extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
 #else
 static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
+
+static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	return EFI_SUCCESS;
+}
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern u64 efi_get_iobase (void);
@@ -731,7 +738,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
-	efi_query_variable_info_t *query_variable_info;
+	efi_query_variable_store_t *query_variable_store;
 };
 
 struct efivars {
diff --git a/include/linux/ucs2_string.h b/include/linux/ucs2_string.h
new file mode 100644
index 0000000..cbb20af
--- /dev/null
+++ b/include/linux/ucs2_string.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_UCS2_STRING_H_
+#define _LINUX_UCS2_STRING_H_
+
+#include <linux/types.h>	/* for size_t */
+#include <linux/stddef.h>	/* for NULL */
+
+typedef u16 ucs2_char_t;
+
+unsigned long ucs2_strnlen(const ucs2_char_t *s, size_t maxlength);
+unsigned long ucs2_strlen(const ucs2_char_t *s);
+unsigned long ucs2_strsize(const ucs2_char_t *data, unsigned long maxlength);
+int ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len);
+
+#endif /* _LINUX_UCS2_STRING_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 3958dc4..fe01d41 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -404,4 +404,7 @@ config OID_REGISTRY
 	help
 	  Enable fast lookup object identifier registry.
 
+config UCS2_STRING
+        tristate
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index d7946ff..6e2cc56 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -174,3 +174,5 @@ quiet_cmd_build_OID_registry = GEN     $@
       cmd_build_OID_registry = perl $(srctree)/$(src)/build_OID_registry $< $@
 
 clean-files	+= oid_registry_data.c
+
+obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
new file mode 100644
index 0000000..6f500ef
--- /dev/null
+++ b/lib/ucs2_string.c
@@ -0,0 +1,51 @@
+#include <linux/ucs2_string.h>
+#include <linux/module.h>
+
+/* Return the number of unicode characters in data */
+unsigned long
+ucs2_strnlen(const ucs2_char_t *s, size_t maxlength)
+{
+        unsigned long length = 0;
+
+        while (*s++ != 0 && length < maxlength)
+                length++;
+        return length;
+}
+EXPORT_SYMBOL(ucs2_strnlen);
+
+unsigned long
+ucs2_strlen(const ucs2_char_t *s)
+{
+        return ucs2_strnlen(s, ~0UL);
+}
+EXPORT_SYMBOL(ucs2_strlen);
+
+/*
+ * Return the number of bytes is the length of this string
+ * Note: this is NOT the same as the number of unicode characters
+ */
+unsigned long
+ucs2_strsize(const ucs2_char_t *data, unsigned long maxlength)
+{
+        return ucs2_strnlen(data, maxlength/sizeof(ucs2_char_t)) * sizeof(ucs2_char_t);
+}
+EXPORT_SYMBOL(ucs2_strsize);
+
+int
+ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len)
+{
+        while (1) {
+                if (len == 0)
+                        return 0;
+                if (*a < *b)
+                        return -1;
+                if (*a > *b)
+                        return 1;
+                if (*a == 0) /* implies *b == 0 */
+                        return 0;
+                a++;
+                b++;
+                len--;
+        }
+}
+EXPORT_SYMBOL(ucs2_strncmp);
