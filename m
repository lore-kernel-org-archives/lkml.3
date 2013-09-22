Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3IVWqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:46:03 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:43724 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab3IVWpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:40 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 17/18] Fix types in EFI calls to match EFI function definitions.
Date: Sun, 22 Sep 2013 15:45:41 -0700
Message-Id: <1379889942-3135-18-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI calls can made directly on ARM, so the function pointers
are directly invoked.  This allows types to be checked at
compile time, so here we ensure that the parameters match
the function signature. The wrappers used by x86 prevent
any type checking.
Correct the type of chunksize to be based on native
width as specified by the EFI_FILE_PROTOCOL read()
function.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index e2ff076..4e4127b 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -322,7 +322,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
 				EFI_LOADER_DATA,
 				nr_files * sizeof(*files),
-				&files);
+				(void **)&files);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
 		goto fail;
@@ -373,7 +373,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			boottime = sys_table_arg->boottime;
 
 			status = efi_call_phys3(boottime->handle_protocol,
-					image->device_handle, &fs_proto, &io);
+					image->device_handle, &fs_proto,
+						(void **)&io);
 			if (status != EFI_SUCCESS) {
 				efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
 				goto free_files;
@@ -407,7 +408,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 grow:
 		status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
-					EFI_LOADER_DATA, info_sz, &info);
+					EFI_LOADER_DATA, info_sz,
+					(void **)&info);
 		if (status != EFI_SUCCESS) {
 			efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
 			goto close_handles;
@@ -457,18 +459,19 @@ grow:
 
 		addr = file_addr;
 		for (j = 0; j < nr_files; j++) {
-			u64 size;
+			unsigned long size;
 
 			size = files[j].size;
 			while (size) {
-				u64 chunksize;
+				unsigned long chunksize;
 				if (size > EFI_READ_CHUNK_SIZE)
 					chunksize = EFI_READ_CHUNK_SIZE;
 				else
 					chunksize = size;
 				status = efi_call_phys3(fh->read,
 							files[j].handle,
-							&chunksize, addr);
+							&chunksize,
+							(void *)addr);
 				if (status != EFI_SUCCESS) {
 					efi_printk(sys_table_arg, "Failed to read file\n");
 					goto free_file_total;
-- 
1.7.10.4

