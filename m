Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031688Ab3HIX0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:26:40 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62213 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031659Ab3HIX0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:26:34 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 04/16] Add minimum address parameter to efi_low_alloc()
Date: Fri,  9 Aug 2013 16:26:05 -0700
Message-Id: <1376090777-20090-5-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows allocations to be made low in memory while
avoiding allocations at the base of memory.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |   11 ++++++-----
 drivers/firmware/efi/efi-stub-helper.c |    7 +++++--
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2a4430a..f44ef2f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -458,7 +458,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	}
 
 	status = efi_low_alloc(sys_table, 0x4000, 1,
-			       (unsigned long *)&boot_params);
+			       (unsigned long *)&boot_params, 0);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc lowmem for boot params\n");
 		return NULL;
@@ -505,7 +505,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 			options_size++;	/* NUL termination */
 
 			status = efi_low_alloc(sys_table, options_size, 1,
-					   &cmdline);
+					   &cmdline, 0);
 			if (status != EFI_SUCCESS) {
 				efi_printk(sys_table, "Failed to alloc mem for cmdline\n");
 				goto fail;
@@ -563,7 +563,8 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 again:
 	size += sizeof(*mem_map) * 2;
 	_size = size;
-	status = efi_low_alloc(sys_table, size, 1, (unsigned long *)&mem_map);
+	status = efi_low_alloc(sys_table, size, 1,
+			       (unsigned long *)&mem_map, 0);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -697,7 +698,7 @@ static efi_status_t relocate_kernel(struct setup_header *hdr)
 				nr_pages, &start);
 	if (status != EFI_SUCCESS) {
 		status = efi_low_alloc(sys_table, hdr->init_size,
-				   hdr->kernel_alignment, &start);
+				   hdr->kernel_alignment, &start, 0);
 		if (status != EFI_SUCCESS)
 			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
 	}
@@ -745,7 +746,7 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 
 	gdt->size = 0x800;
 	status = efi_low_alloc(sys_table, gdt->size, 8,
-			   (unsigned long *)&gdt->address);
+			   (unsigned long *)&gdt->address, 0);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for gdt\n");
 		goto fail;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 0218d535..40cd16e 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -163,11 +163,11 @@ fail:
 }
 
 /*
- * Allocate at the lowest possible address.
+ * Allocate at the lowest possible address, that is not below min.
  */
 static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			      unsigned long size, unsigned long align,
-			      unsigned long *addr)
+			      unsigned long *addr, unsigned long min)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -204,6 +204,9 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		if (start == 0x0)
 			start += 8;
 
+		if (start < min)
+			start = min;
+
 		start = round_up(start, align);
 		if ((start + size) > end)
 			continue;
-- 
1.7.10.4

