Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaDDSqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:46:19 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:61451 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaDDSqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:46:08 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v3 10/10] efi/arm64: ignore dtb= when UEFI SecureBoot is enabled
Date: Fri,  4 Apr 2014 19:45:13 +0100
Message-Id: <1396637113-22790-11-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Loading unauthenticated FDT blobs directly from storage is a security hazard,
so this should only be allowed when running with UEFI Secure Boot disabled.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/arm-stub.c        |   15 +++++++++++----
 drivers/firmware/efi/efi-stub-helper.c |   24 ++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/arm-stub.c
index b9b7c00..c8988b2 100644
--- a/drivers/firmware/efi/arm-stub.c
+++ b/drivers/firmware/efi/arm-stub.c
@@ -145,7 +145,7 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
 	/* addr/point and size pairs for memory management*/
 	unsigned long initrd_addr;
 	u64 initrd_size = 0;
-	unsigned long fdt_addr;  /* Original DTB */
+	unsigned long fdt_addr = 0;  /* Original DTB */
 	u64 fdt_size = 0;  /* We don't get size from configuration table */
 	char *cmdline_ptr = NULL;
 	int cmdline_size = 0;
@@ -197,9 +197,13 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_image;
 	}
 
-	/* Load a device tree from the configuration table, if present. */
-	fdt_addr = (uintptr_t)get_fdt(sys_table);
-	if (!fdt_addr) {
+	/*
+	 * Unauthenticated device tree data is a security hazard, so
+	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
+	 */
+	if (efi_secureboot_enabled(sys_table)) {
+		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
+	} else {
 		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
 					      "dtb=",
 					      ~0UL, (unsigned long *)&fdt_addr,
@@ -210,6 +214,9 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
 			goto fail_free_cmdline;
 		}
 	}
+	if (!fdt_addr)
+		/* Look for a device tree configuration table entry. */
+		fdt_addr = (uintptr_t)get_fdt(sys_table);
 
 	status = handle_cmdline_files(sys_table, image, cmdline_ptr,
 				      "initrd=", dram_base + SZ_512M,
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 998b884..8f8b538 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -632,3 +632,27 @@ static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 	*cmd_line_len = options_bytes;
 	return (char *)cmdline_addr;
 }
+
+static int __init efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
+{
+	static efi_guid_t const var_guid __initconst = EFI_GLOBAL_VARIABLE_GUID;
+	static efi_char16_t const var_name[] __initconst = {
+		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
+
+	efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
+	unsigned long size = sizeof(u8);
+	efi_status_t status;
+	u8 val;
+
+	status = efi_call_phys5(f_getvar, (efi_char16_t *)var_name,
+				(efi_guid_t *)&var_guid, NULL, &size, &val);
+
+	switch (status) {
+	case EFI_SUCCESS:
+		return val;
+	case EFI_NOT_FOUND:
+		return 0;
+	default:
+		return 1;
+	}
+}
-- 
1.7.10.4

