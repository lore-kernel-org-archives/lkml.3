Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3IVWqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:46:39 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:59978 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3IVWpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:39 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 16/18] Renames in handle_cmdline_files() to complete generalization.
Date: Sun, 22 Sep 2013 15:45:40 -0700
Message-Id: <1379889942-3135-17-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename variables to be not initrd specific, as now the function
loads arbitrary files.  This change is exclusively renames
and comment changes to reflect the generalization.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Acked-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   92 ++++++++++++++++----------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index d2d845f..e2ff076 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -11,7 +11,7 @@
  */
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
-struct initrd {
+struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
 };
@@ -262,10 +262,10 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 
 
 /*
- * Check the cmdline for a LILO-style initrd= arguments.
+ * Check the cmdline for a LILO-style file= arguments.
  *
- * We only support loading an initrd from the same filesystem as the
- * kernel image.
+ * We only support loading a file from the same filesystem as
+ * the kernel image.
  */
 static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 					 efi_loaded_image_t *image,
@@ -274,19 +274,19 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 					 unsigned long *load_addr,
 					 unsigned long *load_size)
 {
-	struct initrd *initrds;
-	unsigned long initrd_addr;
+	struct file_info *files;
+	unsigned long file_addr;
 	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
-	u64 initrd_total;
+	u64 file_size_total;
 	efi_file_io_interface_t *io;
 	efi_file_handle_t *fh;
 	efi_status_t status;
-	int nr_initrds;
+	int nr_files;
 	char *str;
 	int i, j, k;
 
-	initrd_addr = 0;
-	initrd_total = 0;
+	file_addr = 0;
+	file_size_total = 0;
 
 	str = cmd_line;
 
@@ -301,7 +301,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	if (!str || !*str)
 		return EFI_SUCCESS;
 
-	for (nr_initrds = 0; *str; nr_initrds++) {
+	for (nr_files = 0; *str; nr_files++) {
 		str = strstr(str, option_string);
 		if (!str)
 			break;
@@ -316,21 +316,21 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			str++;
 	}
 
-	if (!nr_initrds)
+	if (!nr_files)
 		return EFI_SUCCESS;
 
 	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
 				EFI_LOADER_DATA,
-				nr_initrds * sizeof(*initrds),
-				&initrds);
+				nr_files * sizeof(*files),
+				&files);
 	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to alloc mem for file load\n");
+		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
 		goto fail;
 	}
 
 	str = cmd_line;
-	for (i = 0; i < nr_initrds; i++) {
-		struct initrd *initrd;
+	for (i = 0; i < nr_files; i++) {
+		struct file_info *file;
 		efi_file_handle_t *h;
 		efi_file_info_t *info;
 		efi_char16_t filename_16[256];
@@ -345,7 +345,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 		str += strlen(option_string);
 
-		initrd = &initrds[i];
+		file = &files[i];
 		p = filename_16;
 
 		/* Skip any leading slashes */
@@ -376,13 +376,13 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 					image->device_handle, &fs_proto, &io);
 			if (status != EFI_SUCCESS) {
 				efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
-				goto free_initrds;
+				goto free_files;
 			}
 
 			status = efi_call_phys2(io->open_volume, io, &fh);
 			if (status != EFI_SUCCESS) {
 				efi_printk(sys_table_arg, "Failed to open volume\n");
-				goto free_initrds;
+				goto free_files;
 			}
 		}
 
@@ -395,7 +395,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			goto close_handles;
 		}
 
-		initrd->handle = h;
+		file->handle = h;
 
 		info_sz = 0;
 		status = efi_call_phys4(h->get_info, h, &info_guid,
@@ -429,37 +429,37 @@ grow:
 			goto close_handles;
 		}
 
-		initrd->size = file_sz;
-		initrd_total += file_sz;
+		file->size = file_sz;
+		file_size_total += file_sz;
 	}
 
-	if (initrd_total) {
+	if (file_size_total) {
 		unsigned long addr;
 
 		/*
-		 * Multiple initrd's need to be at consecutive
-		 * addresses in memory, so allocate enough memory for
-		 * all the initrd's.
+		 * Multiple files need to be at consecutive addresses in memory,
+		 * so allocate enough memory for all the files.  This is used
+		 * for loading multiple files.
 		 */
-		status = efi_high_alloc(sys_table_arg, initrd_total, 0x1000,
-				    &initrd_addr, max_addr);
+		status = efi_high_alloc(sys_table_arg, file_size_total, 0x1000,
+				    &file_addr, max_addr);
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to alloc highmem for initrds\n");
+			efi_printk(sys_table_arg, "Failed to alloc highmem for files\n");
 			goto close_handles;
 		}
 
 		/* We've run out of free low memory. */
-		if (initrd_addr > max_addr) {
+		if (file_addr > max_addr) {
 			efi_printk(sys_table_arg, "We've run out of free low memory\n");
 			status = EFI_INVALID_PARAMETER;
-			goto free_initrd_total;
+			goto free_file_total;
 		}
 
-		addr = initrd_addr;
-		for (j = 0; j < nr_initrds; j++) {
+		addr = file_addr;
+		for (j = 0; j < nr_files; j++) {
 			u64 size;
 
-			size = initrds[j].size;
+			size = files[j].size;
 			while (size) {
 				u64 chunksize;
 				if (size > EFI_READ_CHUNK_SIZE)
@@ -467,36 +467,36 @@ grow:
 				else
 					chunksize = size;
 				status = efi_call_phys3(fh->read,
-							initrds[j].handle,
+							files[j].handle,
 							&chunksize, addr);
 				if (status != EFI_SUCCESS) {
 					efi_printk(sys_table_arg, "Failed to read file\n");
-					goto free_initrd_total;
+					goto free_file_total;
 				}
 				addr += chunksize;
 				size -= chunksize;
 			}
 
-			efi_call_phys1(fh->close, initrds[j].handle);
+			efi_call_phys1(fh->close, files[j].handle);
 		}
 
 	}
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, initrds);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
 
-	*load_addr = initrd_addr;
-	*load_size = initrd_total;
+	*load_addr = file_addr;
+	*load_size = file_size_total;
 
 	return status;
 
-free_initrd_total:
-	efi_free(sys_table_arg, initrd_total, initrd_addr);
+free_file_total:
+	efi_free(sys_table_arg, file_size_total, file_addr);
 
 close_handles:
 	for (k = j; k < i; k++)
-		efi_call_phys1(fh->close, initrds[k].handle);
-free_initrds:
-	efi_call_phys1(sys_table_arg->boottime->free_pool, initrds);
+		efi_call_phys1(fh->close, files[k].handle);
+free_files:
+	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
 fail:
 	*load_addr = 0;
 	*load_size = 0;
-- 
1.7.10.4

