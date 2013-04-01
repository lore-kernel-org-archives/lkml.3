Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3DAPOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:14:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47136 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407Ab3DAPOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:14:18 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: ben@decadent.org.uk, jwboyer@redhat.com, linux-efi@vger.kernel.org,
        seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 1/2] efi: Determine how much space is used by boot services-only variables
Date: Mon,  1 Apr 2013 11:13:59 -0400
Message-Id: <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <515150EC.7040203@redhat.com>
References: <515150EC.7040203@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:65f6:6533:2e50:cfd6
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI variables can be flagged as being accessible only within boot services.
This makes it awkward for us to figure out how much space they use at
runtime. In theory we could figure this out by simply comparing the results
from QueryVariableInfo() to the space used by all of our variables, but
that fails if the platform doesn't garbage collect on every boot. Thankfully,
calling QueryVariableInfo() while still inside boot services gives a more
reliable answer. This patch passes that information from the EFI boot stub
up to the efivars code, letting us calculate a reasonably accurate value.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/boot/compressed/eboot.c      | 47 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/efi.h            | 10 ++++++++
 arch/x86/include/uapi/asm/bootparam.h |  1 +
 arch/x86/platform/efi/efi.c           | 21 ++++++++++++++++
 drivers/firmware/efivars.c            | 29 +++++++++++++++++++++
 5 files changed, 108 insertions(+)

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
index 60c89f3..6c3a154 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -93,6 +93,9 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 
 #endif /* CONFIG_X86_32 */
 
+extern u64 efi_var_store_size;
+extern u64 efi_var_remaining_size;
+extern u64 efi_var_max_var_size;
 extern int add_efi_memmap;
 extern unsigned long x86_efi_facility;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
@@ -102,6 +105,13 @@ extern void efi_call_phys_epilog(void);
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
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5f2ecaf..cd2f020 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -71,6 +71,10 @@ static efi_system_table_t efi_systab __initdata;
 
 unsigned long x86_efi_facility;
 
+u64 efi_var_store_size;
+u64 efi_var_remaining_size;
+u64 efi_var_max_var_size;
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -682,6 +686,9 @@ void __init efi_init(void)
 	char vendor[100] = "unknown";
 	int i = 0;
 	void *tmp;
+	struct setup_data *data;
+	struct efi_var_bootdata *efi_var_data;
+	u64 pa_data;
 
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
@@ -699,6 +706,20 @@ void __init efi_init(void)
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
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
 	/*
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7acafb8..60e7d8f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -85,6 +85,7 @@
 #include <linux/ramfs.h>
 #include <linux/pagemap.h>
 
+#include <asm/efi.h>
 #include <asm/uaccess.h>
 
 #define EFIVARS_VERSION "0.08"
@@ -139,6 +140,8 @@ struct efivar_attribute {
 
 static struct efivars __efivars;
 static struct efivar_operations ops;
+static u64 boot_var_size;
+static u64 boot_used_size;
 
 #define PSTORE_EFI_ATTRIBUTES \
 	(EFI_VARIABLE_NON_VOLATILE | \
@@ -2014,6 +2017,9 @@ int register_efivars(struct efivars *efivars,
 	efi_char16_t *variable_name;
 	unsigned long variable_name_size = 1024;
 	int error = 0;
+	struct efivar_entry *entry;
+	struct efi_variable *var;
+	u64 active_size = 0;
 
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
 	if (!variable_name) {
@@ -2086,6 +2092,25 @@ int register_efivars(struct efivars *efivars,
 		}
 	} while (status != EFI_NOT_FOUND);
 
+	if (boot_used_size) {
+		list_for_each_entry(entry, &efivars->list, list) {
+			var = &entry->var;
+			status = get_var_data(efivars, var);
+
+			if (status ||
+			    !(var->Attributes & EFI_VARIABLE_NON_VOLATILE))
+				continue;
+
+			active_size += var->DataSize;
+			active_size += utf16_strsize(var->VariableName, 1024);
+		}
+
+		if (active_size < boot_used_size)
+			boot_var_size = boot_used_size - active_size;
+		else
+			printk(KERN_WARNING FW_BUG  "efivars: Inconsistent initial sizes\n");
+	}
+
 	error = create_efivars_bin_attributes(efivars);
 	if (error)
 		unregister_efivars(efivars);
@@ -2133,6 +2158,10 @@ efivars_init(void)
 	ops.get_next_variable = efi.get_next_variable;
 	ops.query_variable_info = efi.query_variable_info;
 
+#ifdef CONFIG_X86
+	boot_used_size = efi_var_store_size - efi_var_remaining_size;
+#endif
+
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
-- 
1.8.1.2

