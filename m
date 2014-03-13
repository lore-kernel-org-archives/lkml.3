Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaCMWsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:48:39 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51105 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbaCMWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:48:25 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, catalin.marinas@arm.com,
        matt.fleming@intel.com
Cc: msalter@redhat.com, roy.franz@linaro.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 15/15] efi/arm64: ignore dtb= when UEFI SecureBoot is enabled
Date: Thu, 13 Mar 2014 22:47:08 +0000
Message-Id: <1394750828-16351-16-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Loading unauthenticated FDT blobs directly from storage is a security hazard,
so this should only be allowed when running with UEFI Secure Boot disabled.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/firmware/efi/arm-stub.c        |   23 ++++++++++++++---------
 drivers/firmware/efi/efi-stub-helper.c |   24 ++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/arm-stub.c
index b505fde..733723c 100644
--- a/drivers/firmware/efi/arm-stub.c
+++ b/drivers/firmware/efi/arm-stub.c
@@ -41,7 +41,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	/* addr/point and size pairs for memory management*/
 	unsigned long initrd_addr;
 	u64 initrd_size = 0;
-	unsigned long fdt_addr;  /* Original DTB */
+	unsigned long fdt_addr = 0;  /* Original DTB */
 	u64 fdt_size = 0;  /* We don't get size from configuration table */
 	char *cmdline_ptr = NULL;
 	int cmdline_size = 0;
@@ -93,15 +93,20 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_image;
 	}
 
-	/* Load a device tree from the configuration table, if present. */
-	fdt_addr = (uintptr_t)get_fdt(sys_table);
+	/*
+	 * Unauthenticated device tree data is a security hazard, so
+	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
+	 */
+	if (efi_secureboot_enabled(sys_table))
+		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
+	else
+		handle_cmdline_files(sys_table, image, cmdline_ptr, "dtb=",
+				     ~0UL, (unsigned long *)&fdt_addr,
+				     (unsigned long *)&fdt_size);
 	if (!fdt_addr) {
-		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
-					      "dtb=",
-					      ~0UL, (unsigned long *)&fdt_addr,
-					      (unsigned long *)&fdt_size);
-
-		if (status != EFI_SUCCESS) {
+		/* Look for a device tree configuration table entry. */
+		fdt_addr = (uintptr_t)get_fdt(sys_table);
+		if (!fdt_addr) {
 			pr_efi_err(sys_table, "Failed to load device tree!\n");
 			goto fail_free_cmdline;
 		}
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 4a9986b..f2014f2 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -704,3 +704,27 @@ static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
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

