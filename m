Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab3DOPyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:54:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36679 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3DOPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:54:20 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V5 1/2] efi: Pass boot services variable info to runtime code
Date: Mon, 15 Apr 2013 08:53:46 -0700
Message-Id: <1366041227-17710-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
X-cavan-blacklisted-at: zen.spamhaus.org
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 208.54.5.183
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
up to the efi platform code.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/boot/compressed/eboot.c      | 47 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/efi.h            |  7 ++++++
 arch/x86/include/uapi/asm/bootparam.h |  1 +
 arch/x86/platform/efi/efi.c           | 21 ++++++++++++++++
 4 files changed, 76 insertions(+)

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
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c89c245..e844d82 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -69,6 +69,10 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+static u64 efi_var_store_size;
+static u64 efi_var_remaining_size;
+static u64 efi_var_max_var_size;
+
 unsigned long x86_efi_facility;
 
 /*
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
-- 
1.8.1.2

