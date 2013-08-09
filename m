Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031721Ab3HIXaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:30:19 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54861 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031651Ab3HIX0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:26:32 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 03/16] Rename memory allocation/free functions
Date: Fri,  9 Aug 2013 16:26:04 -0700
Message-Id: <1376090777-20090-4-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename them to be more similar, as low_free() could be used to free
memory allocated by both high_alloc() and low_alloc().
high_alloc() -> efi_high_alloc()
low_alloc()  -> efi_low_alloc()
low_free()   -> efi_free()

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |   19 ++++++++++---------
 drivers/firmware/efi/efi-stub-helper.c |   14 +++++++-------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 65b6a34..2a4430a 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -457,7 +457,8 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 		return NULL;
 	}
 
-	status = low_alloc(sys_table, 0x4000, 1, (unsigned long *)&boot_params);
+	status = efi_low_alloc(sys_table, 0x4000, 1,
+			       (unsigned long *)&boot_params);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc lowmem for boot params\n");
 		return NULL;
@@ -503,7 +504,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 			options_size++;	/* NUL termination */
 
-			status = low_alloc(sys_table, options_size, 1,
+			status = efi_low_alloc(sys_table, options_size, 1,
 					   &cmdline);
 			if (status != EFI_SUCCESS) {
 				efi_printk(sys_table, "Failed to alloc mem for cmdline\n");
@@ -537,9 +538,9 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	return boot_params;
 fail2:
 	if (options_size)
-		low_free(sys_table, options_size, hdr->cmd_line_ptr);
+		efi_free(sys_table, options_size, hdr->cmd_line_ptr);
 fail:
-	low_free(sys_table, 0x4000, (unsigned long)boot_params);
+	efi_free(sys_table, 0x4000, (unsigned long)boot_params);
 	return NULL;
 }
 
@@ -562,7 +563,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 again:
 	size += sizeof(*mem_map) * 2;
 	_size = size;
-	status = low_alloc(sys_table, size, 1, (unsigned long *)&mem_map);
+	status = efi_low_alloc(sys_table, size, 1, (unsigned long *)&mem_map);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -570,7 +571,7 @@ get_map:
 	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
 				mem_map, &key, &desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		low_free(sys_table, _size, (unsigned long)mem_map);
+		efi_free(sys_table, _size, (unsigned long)mem_map);
 		goto again;
 	}
 
@@ -672,7 +673,7 @@ get_map:
 	return EFI_SUCCESS;
 
 free_mem_map:
-	low_free(sys_table, _size, (unsigned long)mem_map);
+	efi_free(sys_table, _size, (unsigned long)mem_map);
 	return status;
 }
 
@@ -695,7 +696,7 @@ static efi_status_t relocate_kernel(struct setup_header *hdr)
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 				nr_pages, &start);
 	if (status != EFI_SUCCESS) {
-		status = low_alloc(sys_table, hdr->init_size,
+		status = efi_low_alloc(sys_table, hdr->init_size,
 				   hdr->kernel_alignment, &start);
 		if (status != EFI_SUCCESS)
 			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
@@ -743,7 +744,7 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	}
 
 	gdt->size = 0x800;
-	status = low_alloc(sys_table, gdt->size, 8,
+	status = efi_low_alloc(sys_table, gdt->size, 8,
 			   (unsigned long *)&gdt->address);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for gdt\n");
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index bd6c1a2..0218d535 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -86,7 +86,7 @@ fail:
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
-static efi_status_t high_alloc(efi_system_table_t *sys_table_arg,
+static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			       unsigned long size, unsigned long align,
 			       unsigned long *addr, unsigned long max)
 {
@@ -165,8 +165,8 @@ fail:
 /*
  * Allocate at the lowest possible address.
  */
-static efi_status_t low_alloc(efi_system_table_t *sys_table_arg,
-		unsigned long size, unsigned long align,
+static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
+			      unsigned long size, unsigned long align,
 			      unsigned long *addr)
 {
 	unsigned long map_size, desc_size;
@@ -226,7 +226,7 @@ fail:
 	return status;
 }
 
-static void low_free(efi_system_table_t *sys_table_arg, unsigned long size,
+static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 		     unsigned long addr)
 {
 	unsigned long nr_pages;
@@ -407,8 +407,8 @@ grow:
 		 * addresses in memory, so allocate enough memory for
 		 * all the initrd's.
 		 */
-		status = high_alloc(sys_table_arg, initrd_total, 0x1000,
-				   &initrd_addr, hdr->initrd_addr_max);
+		status = efi_high_alloc(sys_table_arg, initrd_total, 0x1000,
+				    &initrd_addr, hdr->initrd_addr_max);
 		if (status != EFI_SUCCESS) {
 			efi_printk(sys_table_arg, "Failed to alloc highmem for initrds\n");
 			goto close_handles;
@@ -456,7 +456,7 @@ grow:
 	return status;
 
 free_initrd_total:
-	low_free(sys_table_arg, initrd_total, initrd_addr);
+	efi_free(sys_table_arg, initrd_total, initrd_addr);
 
 close_handles:
 	for (k = j; k < i; k++)
-- 
1.7.10.4

