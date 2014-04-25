Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaDYQKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:10:48 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:54977 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaDYQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:10:43 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: matt.fleming@intel.com, catalin.marinas@arm.com, msalter@redhat.com,
        grant.likely@linaro.org, roy.franz@linaro.org,
        ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 10/10] efi/arm64: ignore dtb= when UEFI SecureBoot is enabled
Date: Fri, 25 Apr 2014 17:09:14 +0100
Message-Id: <1398442154-19974-11-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Loading unauthenticated FDT blobs directly from storage is a security hazard,
so this should only be allowed when running with UEFI Secure Boot disabled.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/firmware/efi/arm-stub.c |   39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/arm-stub.c
index 19239a9..41114ce 100644
--- a/drivers/firmware/efi/arm-stub.c
+++ b/drivers/firmware/efi/arm-stub.c
@@ -12,6 +12,30 @@
  *
  */
 
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
+	status = f_getvar((efi_char16_t *)var_name, (efi_guid_t *)&var_guid,
+			  NULL, &size, &val);
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
+
 static efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 				    void *__image, void **__fh)
 {
@@ -144,7 +168,7 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
 	/* addr/point and size pairs for memory management*/
 	unsigned long initrd_addr;
 	u64 initrd_size = 0;
-	unsigned long fdt_addr;  /* Original DTB */
+	unsigned long fdt_addr = 0;  /* Original DTB */
 	u64 fdt_size = 0;  /* We don't get size from configuration table */
 	char *cmdline_ptr = NULL;
 	int cmdline_size = 0;
@@ -196,9 +220,13 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
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
@@ -209,6 +237,9 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
 			goto fail_free_cmdline;
 		}
 	}
+	if (!fdt_addr)
+		/* Look for a device tree configuration table entry. */
+		fdt_addr = (uintptr_t)get_fdt(sys_table);
 
 	status = handle_cmdline_files(sys_table, image, cmdline_ptr,
 				      "initrd=", dram_base + SZ_512M,
-- 
1.7.10.4

