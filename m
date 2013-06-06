Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab3FFJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:25:59 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47958 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804Ab3FFJZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:25:56 -0400
Date: Thu, 6 Jun 2013 10:25:42 +0100
From: Matt Fleming <matt@console-pimps.org>
To: joeyli <jlee@suse.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Fleming, Matt" <matt.fleming@intel.com>, "rja@sgi.com" <rja@sgi.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Message-ID: <20130606092542.GE30420@console-pimps.org>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
 <1370276021.30695.4.camel@linux-s257.site>
 <1370277079.6315.14.camel@x230.lan>
 <1370316933.30695.7.camel@linux-s257.site>
 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
 <1370444007.6315.32.camel@x230.lan>
 <20130605155904.GC30420@console-pimps.org>
 <1370495110.6523.35.camel@linux-s257.site>
 <1370497321.6315.44.camel@x230.lan>
 <1370504426.6523.49.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370504426.6523.49.camel@linux-s257.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun, at 03:40:26PM, joeyli wrote:
> OK, I moved volatile checking to the top of the function.
> New version, version 3 diff result like the following.

Thanks. This is what I've now got queued up.

---

>From 118428bf3b207d9b390a27f32dfef6dc2979078d Mon Sep 17 00:00:00 2001
From: Matthew Garrett <matthew.garrett@nebula.com>
Date: Sat, 1 Jun 2013 16:06:20 -0400
Subject: [PATCH] Modify UEFI anti-bricking code

This patch reworks the UEFI anti-bricking code, including an effective
reversion of cc5a080c and 31ff2f20. It turns out that calling
QueryVariableInfo() from boot services results in some firmware
implementations jumping to physical addresses even after entering virtual
mode, so until we have 1:1 mappings for UEFI runtime space this isn't
going to work so well.

Reverting these gets us back to the situation where we'd refuse to create
variables on some systems because they classify deleted variables as "used"
until the firmware triggers a garbage collection run, which they won't do
until they reach a lower threshold. This results in it being impossible to
install a bootloader, which is unhelpful.

Feedback from Samsung indicates that the firmware doesn't need more than
5KB of storage space for its own purposes, so that seems like a reasonable
threshold. However, there's still no guarantee that a platform will attempt
garbage collection merely because it drops below this threshold. It seems
that this is often only triggered if an attempt to write generates a
genuine EFI_OUT_OF_RESOURCES error. We can force that by attempting to
create a variable larger than the remaining space. This should fail, but if
it somehow succeeds we can then immediately delete it.

I've tested this on the UEFI machines I have available, but I don't have
a Samsung and so can't verify that it avoids the bricking problem.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Lee, Chun-Y <jlee@suse.com> [ dummy variable cleanup ]
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c      |  47 ---------
 arch/x86/include/asm/efi.h            |   7 --
 arch/x86/include/uapi/asm/bootparam.h |   1 -
 arch/x86/platform/efi/efi.c           | 188 ++++++++++++----------------------
 4 files changed, 65 insertions(+), 178 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 35ee62f..c205035 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -251,51 +251,6 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 	*size = len;
 }
 
-static efi_status_t setup_efi_vars(struct boot_params *params)
-{
-	struct setup_data *data;
-	struct efi_var_bootdata *efidata;
-	u64 store_size, remaining_size, var_size;
-	efi_status_t status;
-
-	if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
-
-	while (data && data->next)
-		data = (struct setup_data *)(unsigned long)data->next;
-
-	status = efi_call_phys4((void *)sys_table->runtime->query_variable_info,
-				EFI_VARIABLE_NON_VOLATILE |
-				EFI_VARIABLE_BOOTSERVICE_ACCESS |
-				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
-				&remaining_size, &var_size);
-
-	if (status != EFI_SUCCESS)
-		return status;
-
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, sizeof(*efidata), &efidata);
-
-	if (status != EFI_SUCCESS)
-		return status;
-
-	efidata->data.type = SETUP_EFI_VARS;
-	efidata->data.len = sizeof(struct efi_var_bootdata) -
-		sizeof(struct setup_data);
-	efidata->data.next = 0;
-	efidata->store_size = store_size;
-	efidata->remaining_size = remaining_size;
-	efidata->max_var_size = var_size;
-
-	if (data)
-		data->next = (unsigned long)efidata;
-	else
-		params->hdr.setup_data = (unsigned long)efidata;
-
-}
-
 static efi_status_t setup_efi_pci(struct boot_params *params)
 {
 	efi_pci_io_protocol *pci;
@@ -1202,8 +1157,6 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 
 	setup_graphics(boot_params);
 
-	setup_efi_vars(boot_params);
-
 	setup_efi_pci(boot_params);
 
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 2fb5d58..60c89f3 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -102,13 +102,6 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 
-struct efi_var_bootdata {
-	struct setup_data data;
-	u64 store_size;
-	u64 remaining_size;
-	u64 max_var_size;
-};
-
 #ifdef CONFIG_EFI
 
 static inline bool efi_is_native(void)
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 0874424..c15ddaf 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -6,7 +6,6 @@
 #define SETUP_E820_EXT			1
 #define SETUP_DTB			2
 #define SETUP_PCI			3
-#define SETUP_EFI_VARS			4
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 82089d8..5ae2eb0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -42,7 +42,6 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
-#include <linux/ucs2_string.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -54,12 +53,12 @@
 
 #define EFI_DEBUG	1
 
-/*
- * There's some additional metadata associated with each
- * variable. Intel's reference implementation is 60 bytes - bump that
- * to account for potential alignment constraints
- */
-#define VAR_METADATA_SIZE 64
+#define EFI_MIN_RESERVE 5120
+
+#define EFI_DUMMY_GUID \
+	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
+
+static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
 
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
@@ -79,13 +78,6 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
-static u64 efi_var_store_size;
-static u64 efi_var_remaining_size;
-static u64 efi_var_max_var_size;
-static u64 boot_used_size;
-static u64 boot_var_size;
-static u64 active_size;
-
 unsigned long x86_efi_facility;
 
 /*
@@ -188,53 +180,8 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	efi_status_t status;
-	static bool finished = false;
-	static u64 var_size;
-
-	status = efi_call_virt3(get_next_variable,
-				name_size, name, vendor);
-
-	if (status == EFI_NOT_FOUND) {
-		finished = true;
-		if (var_size < boot_used_size) {
-			boot_var_size = boot_used_size - var_size;
-			active_size += boot_var_size;
-		} else {
-			printk(KERN_WARNING FW_BUG  "efi: Inconsistent initial sizes\n");
-		}
-	}
-
-	if (boot_used_size && !finished) {
-		unsigned long size = 0;
-		u32 attr;
-		efi_status_t s;
-		void *tmp;
-
-		s = virt_efi_get_variable(name, vendor, &attr, &size, NULL);
-
-		if (s != EFI_BUFFER_TOO_SMALL || !size)
-			return status;
-
-		tmp = kmalloc(size, GFP_ATOMIC);
-
-		if (!tmp)
-			return status;
-
-		s = virt_efi_get_variable(name, vendor, &attr, &size, tmp);
-
-		if (s == EFI_SUCCESS && (attr & EFI_VARIABLE_NON_VOLATILE)) {
-			var_size += size;
-			var_size += ucs2_strsize(name, 1024);
-			active_size += size;
-			active_size += VAR_METADATA_SIZE;
-			active_size += ucs2_strsize(name, 1024);
-		}
-
-		kfree(tmp);
-	}
-
-	return status;
+	return efi_call_virt3(get_next_variable,
+			      name_size, name, vendor);
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -243,34 +190,9 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	efi_status_t status;
-	u32 orig_attr = 0;
-	unsigned long orig_size = 0;
-
-	status = virt_efi_get_variable(name, vendor, &orig_attr, &orig_size,
-				       NULL);
-
-	if (status != EFI_BUFFER_TOO_SMALL)
-		orig_size = 0;
-
-	status = efi_call_virt5(set_variable,
-				name, vendor, attr,
-				data_size, data);
-
-	if (status == EFI_SUCCESS) {
-		if (orig_size) {
-			active_size -= orig_size;
-			active_size -= ucs2_strsize(name, 1024);
-			active_size -= VAR_METADATA_SIZE;
-		}
-		if (data_size) {
-			active_size += data_size;
-			active_size += ucs2_strsize(name, 1024);
-			active_size += VAR_METADATA_SIZE;
-		}
-	}
-
-	return status;
+	return efi_call_virt5(set_variable,
+			      name, vendor, attr,
+			      data_size, data);
 }
 
 static efi_status_t virt_efi_query_variable_info(u32 attr,
@@ -786,9 +708,6 @@ void __init efi_init(void)
 	char vendor[100] = "unknown";
 	int i = 0;
 	void *tmp;
-	struct setup_data *data;
-	struct efi_var_bootdata *efi_var_data;
-	u64 pa_data;
 
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
@@ -806,22 +725,6 @@ void __init efi_init(void)
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*efi_var_data));
-		if (data->type == SETUP_EFI_VARS) {
-			efi_var_data = (struct efi_var_bootdata *)data;
-
-			efi_var_store_size = efi_var_data->store_size;
-			efi_var_remaining_size = efi_var_data->remaining_size;
-			efi_var_max_var_size = efi_var_data->max_var_size;
-		}
-		pa_data = data->next;
-		early_iounmap(data, sizeof(*efi_var_data));
-	}
-
-	boot_used_size = efi_var_store_size - efi_var_remaining_size;
-
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
 	/*
@@ -1085,6 +988,13 @@ void __init efi_enter_virtual_mode(void)
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
@@ -1136,33 +1046,65 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	efi_status_t status;
 	u64 storage_size, remaining_size, max_size;
 
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return 0;
+
 	status = efi.query_variable_info(attributes, &storage_size,
 					 &remaining_size, &max_size);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!max_size && remaining_size > size)
-		printk_once(KERN_ERR FW_BUG "Broken EFI implementation"
-			    " is returning MaxVariableSize=0\n");
 	/*
 	 * Some firmware implementations refuse to boot if there's insufficient
 	 * space in the variable store. We account for that by refusing the
 	 * write if permitting it would reduce the available space to under
-	 * 50%. However, some firmware won't reclaim variable space until
-	 * after the used (not merely the actively used) space drops below
-	 * a threshold. We can approximate that case with the value calculated
-	 * above. If both the firmware and our calculations indicate that the
-	 * available space would drop below 50%, refuse the write.
+	 * 5KB. This figure was provided by Samsung, so should be safe.
 	 */
+	if ((remaining_size - size < EFI_MIN_RESERVE) &&
+		!efi_no_storage_paranoia) {
+
+		/*
+		 * Triggering garbage collection may require that the firmware
+		 * generate a real EFI_OUT_OF_RESOURCES error. We can force
+		 * that by attempting to use more space than is available.
+		 */
+		unsigned long dummy_size = remaining_size + 1024;
+		void *dummy = kmalloc(dummy_size, GFP_ATOMIC);
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
 
-	if (!storage_size || size > remaining_size ||
-	    (max_size && size > max_size))
-		return EFI_OUT_OF_RESOURCES;
+		/*
+		 * The runtime code may now have triggered a garbage collection
+		 * run, so check the variable info again
+		 */
+		status = efi.query_variable_info(attributes, &storage_size,
+						 &remaining_size, &max_size);
 
-	if (!efi_no_storage_paranoia &&
-	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
-	     (remaining_size - size < storage_size / 2)))
-		return EFI_OUT_OF_RESOURCES;
+		if (status != EFI_SUCCESS)
+			return status;
+
+		/*
+		 * There still isn't enough room, so return an error
+		 */
+		if (remaining_size - size < EFI_MIN_RESERVE)
+			return EFI_OUT_OF_RESOURCES;
+	}
 
 	return EFI_SUCCESS;
 }
-- 
1.8.1.4

-- 
Matt Fleming, Intel Open Source Technology Center
