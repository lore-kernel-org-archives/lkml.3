Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab3K0XdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:33:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57871 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186Ab3K0XcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:32:08 -0500
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V5 2/6] Add shared update_fdt() function for ARM/ARM64
Date: Wed, 27 Nov 2013 15:31:51 -0800
Message-Id: <1385595115-21488-3-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both ARM and ARM64 stubs will update the device tree
that they pass to the kernel.  In both cases they
primarily need to add the same UEFI related information,
so the function can be shared.
Create a new FDT related file for this to avoid use
of architecture #ifdefs in efi-stub-helper.c
Change EFI allocation type for memory map to
EFI_RUNTIME_SERVICES_DATA, since we are passing
this buffer to the kernel, or immediately freeing it.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |    9 ++-
 drivers/firmware/efi/fdt.c             |  115 ++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/fdt.c

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index b6bffbf..bc9e37a 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -4,6 +4,7 @@
  * implementation files.
  *
  * Copyright 2011 Intel Corporation; author Matt Fleming
+ * Copyright 2013 Linaro Limited; author Roy Franz
  *
  * This file is part of the Linux kernel, and is made available
  * under the terms of the GNU General Public License version 2.
@@ -63,10 +64,16 @@ again:
 	/*
 	 * Add an additional efi_memory_desc_t because we're doing an
 	 * allocation which may be in a new descriptor region.
+	 * We allocate as EFI_RUNTIME_SERVICES_DATA since this is what
+	 * we want for when we pass the memory map to the kernel.  This
+	 * function is also used to get the memory map for other uses,
+	 * but is always freed by the stub so the allocation type
+	 * doesn't matter.
 	 */
 	*map_size += sizeof(*m);
 	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
-				EFI_LOADER_DATA, *map_size, (void **)&m);
+				EFI_RUNTIME_SERVICES_DATA, *map_size,
+				(void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
new file mode 100644
index 0000000..7f1431b
--- /dev/null
+++ b/drivers/firmware/efi/fdt.c
@@ -0,0 +1,115 @@
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
+	/* Copy definition of linux_banner here.  Since this code is
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
+	/* Set intird address/end in device tree, if present */
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
+	/* Add kernel version banner so stub/kernel match can be
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
-- 
1.7.10.4

