Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3IQEML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:12:11 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41825 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab3IQEL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:11:57 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 08/17] Generalize relocate_kernel() for use by other architectures.
Date: Mon, 16 Sep 2013 21:11:24 -0700
Message-Id: <1379391093-27948-9-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
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
 arch/x86/boot/compressed/eboot.c       |   12 ++++--
 drivers/firmware/efi/efi-stub-helper.c |   74 ++++++++++++++++++++++----------
 2 files changed, 60 insertions(+), 26 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 5bbba86..7fe2754 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -730,13 +730,19 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 
 	/*
 	 * If the kernel isn't already loaded at the preferred load
-	 * address, relocate it.
+	 * address, relocate it.  Enforce allocation in 32 bit
+	 * addressable space.
 	 */
 	if (hdr->pref_address != hdr->code32_start) {
-		status = relocate_kernel(hdr);
-
+		unsigned long bzimage_addr = hdr->code32_start;
+		status = efi_relocate_kernel(sys_table, &bzimage_addr,
+					     hdr->init_size, hdr->init_size,
+					     hdr->pref_address);
 		if (status != EFI_SUCCESS)
 			goto fail;
+
+		hdr->pref_address = hdr->code32_start;
+		hdr->code32_start = bzimage_addr;
 	}
 
 	status = exit_boot(boot_params, handle);
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 1d5f219..e34040e 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -483,38 +483,66 @@ fail:
 
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
+					unsigned long preferred_addr)
 {
-	unsigned long start, nr_pages;
+	unsigned long cur_image_addr;
+	unsigned long new_addr = 0;
 	efi_status_t status;
+	unsigned long nr_pages;
+	efi_physical_addr_t efi_addr = preferred_addr;
 
-	/*
-	 * The EFI firmware loader could have placed the kernel image
-	 * anywhere in memory, but the kernel has various restrictions
-	 * on the max physical address it can run at. Attempt to move
-	 * the kernel to boot_params.pref_address, or as low as
-	 * possible.
-	 */
-	start = hdr->pref_address;
-	nr_pages = round_up(hdr->init_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	if (!image_addr || !image_size || !alloc_size)
+		return EFI_INVALID_PARAMETER;
+	if (alloc_size < image_size)
+		return EFI_INVALID_PARAMETER;
 
-	status = efi_call_phys4(sys_table->boottime->allocate_pages,
+	cur_image_addr = *image_addr;
+
+	/* The EFI firmware loader could have placed the kernel image
+	 * anywhere in memory, but the kernel has restrictions on the
+	 * anywhere in memory, but the kernel has restrictions on the
+	 * max physical address it can run at.  Some architectures
+	 * also have a prefered address, so first try to relocate
+	 * to the preferred address.
+	 */
+	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-				nr_pages, &start);
+				nr_pages, &efi_addr);
+	new_addr = efi_addr;
+	/* If preferred address allocation failed allocate as low as
+	 * possible. */
 	if (status != EFI_SUCCESS) {
-		status = efi_low_alloc(sys_table, hdr->init_size,
-				   hdr->kernel_alignment, &start);
-		if (status != EFI_SUCCESS)
-			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
+		status = efi_low_alloc(sys_table_arg, alloc_size, 0,
+				       &new_addr);
+	}
+	if (status != EFI_SUCCESS) {
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

