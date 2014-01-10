Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbaAJQcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:32:13 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55157 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbaAJQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:30:34 -0500
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V6 4/8] Add shared FDT related functions for ARM/ARM64
Date: Fri, 10 Jan 2014 08:30:13 -0800
Message-Id: <1389371417-379-5-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both ARM and ARM64 stubs will update the device tree that they pass to
the kernel.  In both cases they primarily need to add the same UEFI
related information, so the function can be shared.  Create a new FDT
related file for this to avoid use of architecture #ifdefs in
efi-stub-helper.c.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/firmware/efi/fdt.c |  225 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 225 insertions(+)
 create mode 100644 drivers/firmware/efi/fdt.c

diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
new file mode 100644
index 0000000..e38f330
--- /dev/null
+++ b/drivers/firmware/efi/fdt.c
@@ -0,0 +1,225 @@
+/*
+ * FDT related Helper functions used by the EFI stub on multiple
+ * architectures. This should be #included by the EFI stub
+ * implementation files.
+ *
+ * Copyright 2013 Linaro Limited; author Roy Franz
+ *
+ * This file is part of the Linux kernel, and is made available
+ * under the terms of the GNU General Public License version 2.
+ *
+ */
+
+struct fdt_region {
+	u64 base;
+	u64 size;
+};
+
+static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			       void *fdt, int new_fdt_size, char *cmdline_ptr,
+			       u64 initrd_addr, u64 initrd_size,
+			       efi_memory_desc_t *memory_map,
+			       unsigned long map_size, unsigned long desc_size,
+			       u32 desc_ver)
+{
+	int node;
+	int status;
+	u32 fdt_val32;
+	u64 fdt_val64;
+
+	/*
+	 * Copy definition of linux_banner here.  Since this code is
+	 * built as part of the decompressor for ARM v7, pulling
+	 * in version.c where linux_banner is defined for the
+	 * kernel brings other kernel dependencies with it.
+	 */
+	const char linux_banner[] =
+	    "Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+	    LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
+
+	status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
+	if (status != 0)
+		goto fdt_set_fail;
+
+	node = fdt_subnode_offset(fdt, 0, "chosen");
+	if (node < 0) {
+		node = fdt_add_subnode(fdt, 0, "chosen");
+		if (node < 0) {
+			status = node; /* node is error code when negative */
+			goto fdt_set_fail;
+		}
+	}
+
+	if ((cmdline_ptr != NULL) && (strlen(cmdline_ptr) > 0)) {
+		status = fdt_setprop(fdt, node, "bootargs", cmdline_ptr,
+				     strlen(cmdline_ptr) + 1);
+		if (status)
+			goto fdt_set_fail;
+	}
+
+	/* Set initrd address/end in device tree, if present */
+	if (initrd_size != 0) {
+		u64 initrd_image_end;
+		u64 initrd_image_start = cpu_to_fdt64(initrd_addr);
+		status = fdt_setprop(fdt, node, "linux,initrd-start",
+				     &initrd_image_start, sizeof(u64));
+		if (status)
+			goto fdt_set_fail;
+		initrd_image_end = cpu_to_fdt64(initrd_addr + initrd_size);
+		status = fdt_setprop(fdt, node, "linux,initrd-end",
+				     &initrd_image_end, sizeof(u64));
+		if (status)
+			goto fdt_set_fail;
+	}
+
+	/* Add FDT entries for EFI runtime services in chosen node. */
+	node = fdt_subnode_offset(fdt, 0, "chosen");
+	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)sys_table);
+	status = fdt_setprop(fdt, node, "linux,uefi-system-table",
+			     &fdt_val64, sizeof(fdt_val64));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)memory_map);
+	status = fdt_setprop(fdt, node, "linux,uefi-mmap-start",
+			     &fdt_val64,  sizeof(fdt_val64));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val32 = cpu_to_fdt32(map_size);
+	status = fdt_setprop(fdt, node, "linux,uefi-mmap-size",
+			     &fdt_val32,  sizeof(fdt_val32));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val32 = cpu_to_fdt32(desc_size);
+	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-size",
+			     &fdt_val32, sizeof(fdt_val32));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val32 = cpu_to_fdt32(desc_ver);
+	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-ver",
+			     &fdt_val32, sizeof(fdt_val32));
+	if (status)
+		goto fdt_set_fail;
+
+	/*
+	 * Add kernel version banner so stub/kernel match can be
+	 * verified.
+	 */
+	status = fdt_setprop_string(fdt, node, "linux,uefi-stub-kern-ver",
+			     linux_banner);
+	if (status)
+		goto fdt_set_fail;
+
+	return EFI_SUCCESS;
+
+fdt_set_fail:
+	if (status == -FDT_ERR_NOSPACE)
+		return EFI_BUFFER_TOO_SMALL;
+
+	return EFI_LOAD_ERROR;
+}
+
+#ifndef EFI_FDT_ALIGN
+#define EFI_FDT_ALIGN EFI_PAGE_SIZE
+#endif
+
+/*
+ * Allocate memory for a new FDT, then add EFI, commandline, and
+ * initrd related fields to the FDT.  This routine increases the
+ * FDT allocation size until the allocated memory is large
+ * enough.  EFI allocations are in EFI_PAGE_SIZE granules,
+ * which are fixed at 4K bytes, so in most cases the first
+ * allocation should succeed.
+ * EFI boot services are exited at the end of this function.
+ * There must be no allocations between the get_memory_map()
+ * call and the exit_boot_services() call, so the exiting of
+ * boot services is very tightly tied to the creation of the FDT
+ * with the final memory map in it.
+ */
+
+efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
+					    void *handle,
+					    unsigned long *new_fdt_addr,
+					    unsigned long max_addr,
+					    u64 initrd_addr, u64 initrd_size,
+					    char *cmdline_ptr,
+					    unsigned long fdt_addr,
+					    unsigned long fdt_size)
+{
+	unsigned long map_size, desc_size;
+	u32 desc_ver;
+	unsigned long mmap_key;
+	efi_memory_desc_t *memory_map;
+	unsigned long new_fdt_size;
+	efi_status_t status;
+
+	/* Estimate size of new FDT, and allocate memory for it. We
+	 * will allocate a bigger buffer if this ends up being too
+	 * small, so a rough guess is OK here.*/
+	new_fdt_size = fdt_size + EFI_PAGE_SIZE;
+	while (1) {
+		status = efi_high_alloc(sys_table, new_fdt_size, EFI_FDT_ALIGN,
+					new_fdt_addr, max_addr);
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table, "Unable to allocate memory for new device tree.\n");
+			goto fail;
+		}
+
+		/* Now that we have done our final memory allocation (and free)
+		 * we can get the memory map key  needed for
+		 * exit_boot_services().
+		 */
+		status = efi_get_memory_map(sys_table, &memory_map, &map_size,
+					    &desc_size, &desc_ver, &mmap_key);
+		if (status != EFI_SUCCESS)
+			goto fail_free_new_fdt;
+
+		status = update_fdt(sys_table,
+				    (void *)fdt_addr, (void *)*new_fdt_addr,
+				    new_fdt_size, cmdline_ptr, initrd_addr,
+				    initrd_size, memory_map, map_size,
+				    desc_size, desc_ver);
+
+		/* Succeeding the first time is the expected case. */
+		if (status == EFI_SUCCESS)
+			break;
+
+		if (status == EFI_BUFFER_TOO_SMALL) {
+			/* We need to allocate more space for the new
+			 * device tree, so free existing buffer that is
+			 * too small.  Also free memory map, as we will need
+			 * to get new one that reflects the free/alloc we do
+			 * on the device tree buffer. */
+			efi_free(sys_table, new_fdt_size, *new_fdt_addr);
+			efi_call_phys1(sys_table->boottime->free_pool,
+				       memory_map);
+			new_fdt_size += EFI_PAGE_SIZE;
+		} else {
+			pr_efi_err(sys_table, "Unable to constuct new device tree.\n");
+			goto fail_free_mmap;
+		}
+	}
+
+	/* Now we are ready to exit_boot_services.*/
+	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
+				handle, mmap_key);
+
+
+	if (status == EFI_SUCCESS)
+		return status;
+
+	pr_efi_err(sys_table, "Exit boot services failed.\n");
+
+fail_free_mmap:
+	efi_call_phys1(sys_table->boottime->free_pool, memory_map);
+
+fail_free_new_fdt:
+	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
+
+fail:
+	return EFI_LOAD_ERROR;
+}
+
-- 
1.7.10.4

