Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3IVWqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:46:53 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:63091 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab3IVWpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:39 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 15/18] Generalize handle_ramdisks() and rename to handle_cmdline_files().
Date: Sun, 22 Sep 2013 15:45:39 -0700
Message-Id: <1379889942-3135-16-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The handle_cmdline_files now takes the option to handle as a string,
and returns the loaded data through parameters, rather than taking
an x86 specific setup_header structure.  For ARM, this will be used
to load a device tree blob in addition to initrd images.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Acked-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |    9 +++++-
 drivers/firmware/efi/efi-stub-helper.c |   51 +++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8b86772..a5628cd 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -442,6 +442,8 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	u16 *s2;
 	u8 *s1;
 	int i;
+	unsigned long ramdisk_addr;
+	unsigned long ramdisk_size;
 
 	sys_table = _table;
 
@@ -499,9 +501,14 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 	memset(sdt, 0, sizeof(*sdt));
 
-	status = handle_ramdisks(sys_table, image, hdr);
+	status = handle_cmdline_files(sys_table, image,
+				      (char *)(unsigned long)hdr->cmd_line_ptr,
+				      "initrd=", hdr->initrd_addr_max,
+				      &ramdisk_addr, &ramdisk_size);
 	if (status != EFI_SUCCESS)
 		goto fail2;
+	hdr->ramdisk_image = ramdisk_addr;
+	hdr->ramdisk_size = ramdisk_size;
 
 	return boot_params;
 fail2:
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 73cf86b..d2d845f 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -267,9 +267,12 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
  * We only support loading an initrd from the same filesystem as the
  * kernel image.
  */
-static efi_status_t handle_ramdisks(efi_system_table_t *sys_table_arg,
-				    efi_loaded_image_t *image,
-				    struct setup_header *hdr)
+static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
+					 efi_loaded_image_t *image,
+					 char *cmd_line, char *option_string,
+					 unsigned long max_addr,
+					 unsigned long *load_addr,
+					 unsigned long *load_size)
 {
 	struct initrd *initrds;
 	unsigned long initrd_addr;
@@ -285,19 +288,25 @@ static efi_status_t handle_ramdisks(efi_system_table_t *sys_table_arg,
 	initrd_addr = 0;
 	initrd_total = 0;
 
-	str = (char *)(unsigned long)hdr->cmd_line_ptr;
+	str = cmd_line;
 
 	j = 0;			/* See close_handles */
 
+	if (!load_addr || !load_size)
+		return EFI_INVALID_PARAMETER;
+
+	*load_addr = 0;
+	*load_size = 0;
+
 	if (!str || !*str)
 		return EFI_SUCCESS;
 
 	for (nr_initrds = 0; *str; nr_initrds++) {
-		str = strstr(str, "initrd=");
+		str = strstr(str, option_string);
 		if (!str)
 			break;
 
-		str += 7;
+		str += strlen(option_string);
 
 		/* Skip any leading slashes */
 		while (*str == '/' || *str == '\\')
@@ -315,11 +324,11 @@ static efi_status_t handle_ramdisks(efi_system_table_t *sys_table_arg,
 				nr_initrds * sizeof(*initrds),
 				&initrds);
 	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to alloc mem for initrds\n");
+		efi_printk(sys_table_arg, "Failed to alloc mem for file load\n");
 		goto fail;
 	}
 
-	str = (char *)(unsigned long)hdr->cmd_line_ptr;
+	str = cmd_line;
 	for (i = 0; i < nr_initrds; i++) {
 		struct initrd *initrd;
 		efi_file_handle_t *h;
@@ -330,11 +339,11 @@ static efi_status_t handle_ramdisks(efi_system_table_t *sys_table_arg,
 		efi_char16_t *p;
 		u64 file_sz;
 
-		str = strstr(str, "initrd=");
+		str = strstr(str, option_string);
 		if (!str)
 			break;
 
-		str += 7;
+		str += strlen(option_string);
 
 		initrd = &initrds[i];
 		p = filename_16;
@@ -380,7 +389,7 @@ static efi_status_t handle_ramdisks(efi_system_table_t *sys_table_arg,
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to open initrd file: ");
+			efi_printk(sys_table_arg, "Failed to open file: ");
 			efi_char16_printk(sys_table_arg, filename_16);
 			efi_printk(sys_table_arg, "\n");
 			goto close_handles;
@@ -392,7 +401,7 @@ static efi_status_t handle_ramdisks(efi_system_table_t *sys_table_arg,
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, NULL);
 		if (status != EFI_BUFFER_TOO_SMALL) {
-			efi_printk(sys_table_arg, "Failed to get initrd info size\n");
+			efi_printk(sys_table_arg, "Failed to get file info size\n");
 			goto close_handles;
 		}
 
@@ -400,7 +409,7 @@ grow:
 		status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
 					EFI_LOADER_DATA, info_sz, &info);
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to alloc mem for initrd info\n");
+			efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
 			goto close_handles;
 		}
 
@@ -416,7 +425,7 @@ grow:
 		efi_call_phys1(sys_table_arg->boottime->free_pool, info);
 
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to get initrd info\n");
+			efi_printk(sys_table_arg, "Failed to get file info\n");
 			goto close_handles;
 		}
 
@@ -433,14 +442,14 @@ grow:
 		 * all the initrd's.
 		 */
 		status = efi_high_alloc(sys_table_arg, initrd_total, 0x1000,
-				    &initrd_addr, hdr->initrd_addr_max);
+				    &initrd_addr, max_addr);
 		if (status != EFI_SUCCESS) {
 			efi_printk(sys_table_arg, "Failed to alloc highmem for initrds\n");
 			goto close_handles;
 		}
 
 		/* We've run out of free low memory. */
-		if (initrd_addr > hdr->initrd_addr_max) {
+		if (initrd_addr > max_addr) {
 			efi_printk(sys_table_arg, "We've run out of free low memory\n");
 			status = EFI_INVALID_PARAMETER;
 			goto free_initrd_total;
@@ -461,7 +470,7 @@ grow:
 							initrds[j].handle,
 							&chunksize, addr);
 				if (status != EFI_SUCCESS) {
-					efi_printk(sys_table_arg, "Failed to read initrd\n");
+					efi_printk(sys_table_arg, "Failed to read file\n");
 					goto free_initrd_total;
 				}
 				addr += chunksize;
@@ -475,8 +484,8 @@ grow:
 
 	efi_call_phys1(sys_table_arg->boottime->free_pool, initrds);
 
-	hdr->ramdisk_image = initrd_addr;
-	hdr->ramdisk_size = initrd_total;
+	*load_addr = initrd_addr;
+	*load_size = initrd_total;
 
 	return status;
 
@@ -489,8 +498,8 @@ close_handles:
 free_initrds:
 	efi_call_phys1(sys_table_arg->boottime->free_pool, initrds);
 fail:
-	hdr->ramdisk_image = 0;
-	hdr->ramdisk_size = 0;
+	*load_addr = 0;
+	*load_size = 0;
 
 	return status;
 }
-- 
1.7.10.4

