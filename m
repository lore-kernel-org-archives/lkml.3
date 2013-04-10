Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936557Ab3DJCmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:42:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42370 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935175Ab3DJCmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:42:12 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 2/3] Revert "x86, efivars: firmware bug workarounds should be in platform code"
Date: Tue,  9 Apr 2013 22:41:56 -0400
Message-Id: <1365561717-12343-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit a6e4d5a03e9e3587e88aba687d8f225f4f04c792. Doing this
workaround properly requires us to work within the variable code.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/platform/efi/efi.c | 25 -------------------------
 drivers/firmware/efivars.c  | 18 +++++++++++++++---
 include/linux/efi.h         |  9 +--------
 3 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 659da48..fdc5074 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1023,28 +1023,3 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
-
-/*
- * Some firmware has serious problems when using more than 50% of the EFI
- * variable store, i.e. it triggers bugs that can brick machines. Ensure that
- * we never use more than this safe limit.
- *
- * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
- * store.
- */
-efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
-{
-	efi_status_t status;
-	u64 storage_size, remaining_size, max_size;
-
-	status = efi.query_variable_info(attributes, &storage_size,
-					 &remaining_size, &max_size);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	if (!storage_size || size > remaining_size || size > max_size ||
-	    (remaining_size - size) < (storage_size / 2))
-		return EFI_OUT_OF_RESOURCES;
-
-	return EFI_SUCCESS;
-}
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 684a118..60e7d8f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -439,12 +439,24 @@ static efi_status_t
 check_var_size_locked(struct efivars *efivars, u32 attributes,
 			unsigned long size)
 {
+	u64 storage_size, remaining_size, max_size;
+	efi_status_t status;
 	const struct efivar_operations *fops = efivars->ops;
 
-	if (!efivars->ops->query_variable_store)
+	if (!efivars->ops->query_variable_info)
 		return EFI_UNSUPPORTED;
 
-	return fops->query_variable_store(attributes, size);
+	status = fops->query_variable_info(attributes, &storage_size,
+					   &remaining_size, &max_size);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (!storage_size || size > remaining_size || size > max_size ||
+	    (remaining_size - size) < (storage_size / 2))
+		return EFI_OUT_OF_RESOURCES;
+
+	return status;
 }
 
 
@@ -2144,7 +2156,7 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
-	ops.query_variable_store = efi_query_variable_store;
+	ops.query_variable_info = efi.query_variable_info;
 
 #ifdef CONFIG_X86
 	boot_used_size = efi_var_store_size - efi_var_remaining_size;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 3d7df3d..9bf2f1f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -333,7 +333,6 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 					      unsigned long count,
 					      u64 *max_size,
 					      int *reset_type);
-typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
 
 /*
  *  EFI Configuration Table and GUID definitions
@@ -576,15 +575,9 @@ extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if pos
 #ifdef CONFIG_X86
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
-extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
 #else
 static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
-
-static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
-{
-	return EFI_SUCCESS;
-}
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern u64 efi_get_iobase (void);
@@ -738,7 +731,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
-	efi_query_variable_store_t *query_variable_store;
+	efi_query_variable_info_t *query_variable_info;
 };
 
 struct efivars {
-- 
1.8.1.2

