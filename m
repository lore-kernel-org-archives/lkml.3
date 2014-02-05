Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaBERKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:10:12 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37218 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaBERFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:05:23 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org
Cc: patches@linaro.org, Roy Franz <roy.franz@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 09/22] Add shared arm/arm64 EFI stub
Date: Wed,  5 Feb 2014 17:04:00 +0000
Message-Id: <1391619853-10601-10-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roy Franz <roy.franz@linaro.org>

This patch adds the EFI stub entry point that is shared
by the arm/arm64 architectures.  Each arch will implement
the handle_kernel_image() function that handles the arch
specific load address and boot protocol requirements.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/firmware/efi/arm-stub.c |  145 +++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/fdt.c      |   31 +++++++--
 2 files changed, 171 insertions(+), 5 deletions(-)
 create mode 100644 drivers/firmware/efi/arm-stub.c

diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/arm-stub.c
new file mode 100644
index 0000000..aefe963
--- /dev/null
+++ b/drivers/firmware/efi/arm-stub.c
@@ -0,0 +1,145 @@
+/*
+ * EFI stub implementation that is shared by arm and arm64 architectures.
+ * This should be #included by the EFI stub implementation files.
+ *
+ * Copyright (C) 2013,2014 Linaro Limited
+ *     Roy Franz <roy.franz@linaro.org
+ * Copyright (C) 2013 Red Hat, Inc.
+ *     Mark Salter <msalter@redhat.com>
+ *
+ * This file is part of the Linux kernel, and is made available under the
+ * terms of the GNU General Public License version 2.
+ *
+ */
+
+/*
+ * This function handles the architcture specific differences between arm and
+ * arm64 regarding where the kernel image must be loaded and any memory that
+ * must be reserved. On failure it is required to free all
+ * all allocations it has made.
+ */
+static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+					unsigned long *image_addr,
+					unsigned long *image_size,
+					unsigned long *reserve_addr,
+					unsigned long *reserve_size,
+					unsigned long dram_base,
+					efi_loaded_image_t *image);
+/*
+ * EFI entry point for the arm/arm64 EFI stubs.  This is the entrypoint
+ * that is described in the PE/COFF header.  Most of the code is the same
+ * for both archictectures, with the arch-specific code provided in the
+ * handle_kernel_image() function.
+ */
+unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
+			       unsigned long *image_addr)
+{
+	efi_loaded_image_t *image;
+	efi_status_t status;
+	unsigned long image_size = 0;
+	unsigned long dram_base;
+	/* addr/point and size pairs for memory management*/
+	unsigned long initrd_addr;
+	u64 initrd_size = 0;
+	unsigned long fdt_addr;  /* Original DTB */
+	u64 fdt_size = 0;  /* We don't get size from configuration table */
+	char *cmdline_ptr = NULL;
+	int cmdline_size = 0;
+	unsigned long new_fdt_addr;
+	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
+	unsigned long reserve_addr = 0;
+	unsigned long reserve_size = 0;
+
+	/* Check if we were booted by the EFI firmware */
+	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		goto fail;
+
+	pr_efi(sys_table, "Booting Linux Kernel...\n");
+
+	/*
+	 * Get a handle to the loaded image protocol.  This is used to get
+	 * information about the running image, such as size and the command
+	 * line.
+	 */
+	status = efi_call_phys3(sys_table->boottime->handle_protocol,
+				handle, &loaded_image_proto, (void *)&image);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to get loaded image protocol\n");
+		goto fail;
+	}
+
+	dram_base = get_dram_base(sys_table);
+	if (dram_base == EFI_ERROR) {
+		pr_efi_err(sys_table, "Failed to find DRAM base\n");
+		goto fail;
+	}
+	status = handle_kernel_image(sys_table, image_addr, &image_size,
+				     &reserve_addr,
+				     &reserve_size,
+				     dram_base, image);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to relocate kernel\n");
+		goto fail;
+	}
+
+	/*
+	 * Get the command line from EFI, using the LOADED_IMAGE
+	 * protocol. We are going to copy the command line into the
+	 * device tree, so this can be allocated anywhere.
+	 */
+	cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
+						    &cmdline_size);
+	if (!cmdline_ptr) {
+		pr_efi_err(sys_table, "getting command line via LOADED_IMAGE_PROTOCOL\n");
+		goto fail_free_image;
+	}
+
+	/* Load a device tree from the configuration table, if present. */
+	fdt_addr = (uintptr_t)get_fdt(sys_table);
+	if (!fdt_addr) {
+		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
+					      "dtb=",
+					      ~0UL, (unsigned long *)&fdt_addr,
+					      (unsigned long *)&fdt_size);
+
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table, "Failed to load device tree!\n");
+			goto fail_free_cmdline;
+		}
+	}
+
+	status = handle_cmdline_files(sys_table, image, cmdline_ptr,
+				      "initrd=", dram_base + SZ_512M,
+				      (unsigned long *)&initrd_addr,
+				      (unsigned long *)&initrd_size);
+	if (status != EFI_SUCCESS)
+		pr_efi_err(sys_table, "Failed initrd from command line!\n");
+
+	new_fdt_addr = fdt_addr;
+	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
+				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
+				initrd_addr, initrd_size, cmdline_ptr,
+				fdt_addr, fdt_size);
+
+	/*
+	 * If all went well, we need to return the FDT address to the
+	 * calling function so it can be passed to kernel as part of
+	 * the kernel boot protocol.
+	 */
+	if (status == EFI_SUCCESS)
+		return new_fdt_addr;
+
+	pr_efi_err(sys_table, "Failed to update FDT and exit boot services\n");
+
+	efi_free(sys_table, initrd_size, initrd_addr);
+	efi_free(sys_table, fdt_size, fdt_addr);
+
+fail_free_cmdline:
+	efi_free(sys_table, cmdline_size, (unsigned long)cmdline_ptr);
+
+fail_free_image:
+	efi_free(sys_table, image_size, *image_addr);
+	efi_free(sys_table, reserve_size, reserve_addr);
+fail:
+	return EFI_ERROR;
+}
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index a602b0a..4510f97 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/fdt.c
@@ -11,6 +11,7 @@
  */
 
 static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			       unsigned long orig_fdt_size,
 			       void *fdt, int new_fdt_size, char *cmdline_ptr,
 			       u64 initrd_addr, u64 initrd_size,
 			       efi_memory_desc_t *memory_map,
@@ -32,7 +33,27 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	    "Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 	    LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
 
-	status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
+	/* Do some checks on provided FDT, if it exists*/
+	if (orig_fdt) {
+		if (fdt_check_header(orig_fdt)) {
+			pr_efi_err(sys_table, "Device Tree header not valid!\n");
+			return EFI_LOAD_ERROR;
+		}
+		/*
+		 * We don't get the size of the FDT if we get if from a
+		 * configuration table.
+		 */
+		if (orig_fdt_size && fdt_totalsize(orig_fdt) > orig_fdt_size) {
+			pr_efi_err(sys_table, "Truncated device tree! foo!\n");
+			return EFI_LOAD_ERROR;
+		}
+	}
+
+	if (orig_fdt)
+		status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
+	else
+		status = fdt_create_empty_tree(fdt, new_fdt_size);
+
 	if (status != 0)
 		goto fdt_set_fail;
 
@@ -180,10 +201,10 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 			goto fail_free_new_fdt;
 
 		status = update_fdt(sys_table,
-				    (void *)fdt_addr, (void *)*new_fdt_addr,
-				    new_fdt_size, cmdline_ptr, initrd_addr,
-				    initrd_size, memory_map, map_size,
-				    desc_size, desc_ver);
+				    (void *)fdt_addr, fdt_size,
+				    (void *)*new_fdt_addr, new_fdt_size,
+				    cmdline_ptr, initrd_addr, initrd_size,
+				    memory_map, map_size, desc_size, desc_ver);
 
 		/* Succeeding the first time is the expected case. */
 		if (status == EFI_SUCCESS)
-- 
1.7.10.4

