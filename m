Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3IVWse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:48:34 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36302 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab3IVWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:33 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 08/18] Generalize relocate_kernel() for use by other architectures.
Date: Sun, 22 Sep 2013 15:45:32 -0700
Message-Id: <1379889942-3135-9-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename relocate_kernel() to efi_relocate_kernel(), and take
parameters rather than x86 specific structure.  Add max_addr
argument as for ARM we have some address constraints that we
need to enforce when relocating the kernel.  Add alloc_size
parameter for use by ARM64 which uses an uncompressed kernel,
and needs to allocate space for BSS.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |   10 ++++-
 drivers/firmware/efi/efi-stub-helper.c |   72 ++++++++++++++++++++++----------
 2 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 5bbba86..2e997b6 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -733,10 +733,16 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	 * address, relocate it.
 	 */
 	if (hdr->pref_address != hdr->code32_start) {
-		status = relocate_kernel(hdr);
-
+		unsigned long bzimage_addr = hdr->code32_start;
+		status = efi_relocate_kernel(sys_table, &bzimage_addr,
+					     hdr->init_size, hdr->init_size,
+					     hdr->pref_address,
+					     hdr->kernel_alignment);
 		if (status != EFI_SUCCESS)
 			goto fail;
+
+		hdr->pref_address = hdr->code32_start;
+		hdr->code32_start = bzimage_addr;
 	}
 
 	status = exit_boot(boot_params, handle);
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 1d5f219..9a92129 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -483,38 +483,68 @@ fail:
 
 	return status;
 }
-
-static efi_status_t relocate_kernel(struct setup_header *hdr)
+/* Relocate a kernel image, either compressed or uncompressed.
+ * In the ARM64 case, all kernel images are currently
+ * uncompressed, and as such when we relocate it we need to
+ * allocate additional space for the BSS segment. Any low
+ * memory that this function should avoid needs to be
+ * unavailable in the EFI memory map, as if the preferred
+ * address is not available the lowest available address will
+ * be used.
+ */
+static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
+					unsigned long *image_addr,
+					unsigned long image_size,
+					unsigned long alloc_size,
+					unsigned long preferred_addr,
+					unsigned long alignment)
 {
-	unsigned long start, nr_pages;
+	unsigned long cur_image_addr;
+	unsigned long new_addr = 0;
 	efi_status_t status;
+	unsigned long nr_pages;
+	efi_physical_addr_t efi_addr = preferred_addr;
+
+	if (!image_addr || !image_size || !alloc_size)
+		return EFI_INVALID_PARAMETER;
+	if (alloc_size < image_size)
+		return EFI_INVALID_PARAMETER;
+
+	cur_image_addr = *image_addr;
 
 	/*
 	 * The EFI firmware loader could have placed the kernel image
-	 * anywhere in memory, but the kernel has various restrictions
-	 * on the max physical address it can run at. Attempt to move
-	 * the kernel to boot_params.pref_address, or as low as
-	 * possible.
+	 * anywhere in memory, but the kernel has restrictions on the
+	 * max physical address it can run at.  Some architectures
+	 * also have a prefered address, so first try to relocate
+	 * to the preferred address.  If that fails, allocate as low
+	 * as possible while respecting the required alignment.
 	 */
-	start = hdr->pref_address;
-	nr_pages = round_up(hdr->init_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-
-	status = efi_call_phys4(sys_table->boottime->allocate_pages,
+	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-				nr_pages, &start);
+				nr_pages, &efi_addr);
+	new_addr = efi_addr;
+	/* If preferred address allocation failed allocate as low as
+	 * possible. */
+	if (status != EFI_SUCCESS) {
+		status = efi_low_alloc(sys_table_arg, alloc_size, alignment,
+				       &new_addr);
+	}
 	if (status != EFI_SUCCESS) {
-		status = efi_low_alloc(sys_table, hdr->init_size,
-				   hdr->kernel_alignment, &start);
-		if (status != EFI_SUCCESS)
-			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
+		efi_printk(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
+		return status;
 	}
 
-	if (status == EFI_SUCCESS)
-		memcpy((void *)start, (void *)(unsigned long)hdr->code32_start,
-		       hdr->init_size);
+	/* We know source/dest won't overlap since both memory ranges
+	 * have been allocated by UEFI, so we can safely use memcpy.
+	 */
+	memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
+	/* Zero any extra space we may have allocated for BSS. */
+	memset((void *)(new_addr + image_size), alloc_size - image_size, 0);
 
-	hdr->pref_address = hdr->code32_start;
-	hdr->code32_start = (__u32)start;
+	/* Return the new address of the relocated image. */
+	*image_addr = new_addr;
 
 	return status;
 }
-- 
1.7.10.4

