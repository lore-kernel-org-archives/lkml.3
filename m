Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaCYWkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:40:46 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:46229 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaCYWko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:40:44 -0400
From: Roy Franz <roy.franz@linaro.org>
To: matt@console-pimps.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org, hpa@zytor.com,
        bp@alien8.de, alan@lxorguk.ukuu.org.uk, mjg59@srcf.ucam.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH] Add efi_early_call() macro
Date: Tue, 25 Mar 2014 15:40:30 -0700
Message-Id: <1395787231-14298-1-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140322110515.GF2815@console-pimps.org>
References: <20140322110515.GF2815@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the efi_early_call() macro to invoke functions in the efi_early
structure. Using a macro for these invocations allows the arm32/arm64
architectures to define the macro differently so that they can directly
invoke the boot services functions that are exposed in the efi_early
structure on x86. Prior to the introduction of the efi_early structure
the efi_call_physN macros were used on all architectures and allowed
for this differentiation.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |    5 +++++
 drivers/firmware/efi/efi-stub-helper.c |   26 +++++++++++++-------------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 5e1ba4f..374de94 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -44,6 +44,11 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 }
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
+/*
+ * Use macro to invoke efi_early->call so that on ARM this macro can
+ * implement a direct call.*
+ */
+#define efi_early_call(...) efi_early->call(efi_early->__VA_ARGS__)
 
 static void efi_printk(efi_system_table_t *, char *);
 static void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index a028287..be58a18 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -53,22 +53,22 @@ again:
 	 * allocation which may be in a new descriptor region.
 	 */
 	*map_size += sizeof(*m);
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+	status = efi_early_call(allocate_pool, EFI_LOADER_DATA,
 				 *map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
 	*desc_size = 0;
 	key = 0;
-	status = efi_early->call(efi_early->get_memory_map, map_size, m,
+	status = efi_early_call(get_memory_map, map_size, m,
 				 &key, desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_early->call(efi_early->free_pool, m);
+		efi_early_call(free_pool, m);
 		goto again;
 	}
 
 	if (status != EFI_SUCCESS)
-		efi_early->call(efi_early->free_pool, m);
+		efi_early_call(free_pool, m);
 
 	if (key_ptr && status == EFI_SUCCESS)
 		*key_ptr = key;
@@ -149,7 +149,7 @@ again:
 	if (!max_addr)
 		status = EFI_NOT_FOUND;
 	else {
-		status = efi_early->call(efi_early->allocate_pages,
+		status = efi_early_call(allocate_pages,
 					 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 					 nr_pages, &max_addr);
 		if (status != EFI_SUCCESS) {
@@ -161,7 +161,7 @@ again:
 		*addr = max_addr;
 	}
 
-	efi_early->call(efi_early->free_pool, map);
+	efi_early_call(free_pool, map);
 fail:
 	return status;
 }
@@ -221,7 +221,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		if ((start + size) > end)
 			continue;
 
-		status = efi_early->call(efi_early->allocate_pages,
+		status = efi_early_call(allocate_pages,
 					 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 					 nr_pages, &start);
 		if (status == EFI_SUCCESS) {
@@ -233,7 +233,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (i == map_size / desc_size)
 		status = EFI_NOT_FOUND;
 
-	efi_early->call(efi_early->free_pool, map);
+	efi_early_call(free_pool, map);
 fail:
 	return status;
 }
@@ -247,7 +247,7 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 		return;
 
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_early->call(efi_early->free_pages, addr, nr_pages);
+	efi_early_call(free_pages, addr, nr_pages);
 }
 
 
@@ -307,7 +307,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	if (!nr_files)
 		return EFI_SUCCESS;
 
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+	status = efi_early_call(allocate_pool, EFI_LOADER_DATA,
 				 nr_files * sizeof(*files), (void **)&files);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
@@ -413,7 +413,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 	}
 
-	efi_early->call(efi_early->free_pool, files);
+	efi_early_call(free_pool, files);
 
 	*load_addr = file_addr;
 	*load_size = file_size_total;
@@ -427,7 +427,7 @@ close_handles:
 	for (k = j; k < i; k++)
 		efi_file_close(fh, files[k].handle);
 free_files:
-	efi_early->call(efi_early->free_pool, files);
+	efi_early_call(free_pool, files);
 fail:
 	*load_addr = 0;
 	*load_size = 0;
@@ -473,7 +473,7 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * as possible while respecting the required alignment.
 	 */
 	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	status = efi_early->call(efi_early->allocate_pages,
+	status = efi_early_call(allocate_pages,
 				 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 				 nr_pages, &efi_addr);
 	new_addr = efi_addr;
-- 
1.7.10.4

