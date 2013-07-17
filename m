Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132Ab3GQWvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:51:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3GQWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:51:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>, Sergey Vlasov <vsu@altlinux.ru>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 137/145] x86, efivars: firmware bug workarounds should be in platform code
Date: Wed, 17 Jul 2013 15:47:49 -0700
Message-Id: <1374101277-7915-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit a6e4d5a03e9e3587e88aba687d8f225f4f04c792 upstream.
commit 3668011d4ad556224f7c012c1e870a6eaa0e59da upstream.

Let's not burden ia64 with checks in the common efivars code that we're not
writing too much data to the variable store. That kind of thing is an x86
firmware bug, plain and simple.

efi_query_variable_store() provides platforms with a wrapper in which they can
perform checks and workarounds for EFI variable storage bugs.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
[ kamal: backport to 3.8 as prereq for "Modify UEFI anti-bricking code";
  merged 3668011 "efi: Export efi_query_variable_store() for efivars.ko" ]
Cc: Sergey Vlasov <vsu@altlinux.ru>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/platform/efi/efi.c | 26 ++++++++++++++++++++++++++
 drivers/firmware/efivars.c  | 18 +++---------------
 include/linux/efi.h         |  9 ++++++++-
 3 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e2cd38f..ce51ed0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1005,3 +1005,29 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
+
+/*
+ * Some firmware has serious problems when using more than 50% of the EFI
+ * variable store, i.e. it triggers bugs that can brick machines. Ensure that
+ * we never use more than this safe limit.
+ *
+ * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
+ * store.
+ */
+efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	efi_status_t status;
+	u64 storage_size, remaining_size, max_size;
+
+	status = efi.query_variable_info(attributes, &storage_size,
+					 &remaining_size, &max_size);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (!storage_size || size > remaining_size || size > max_size ||
+	    (remaining_size - size) < (storage_size / 2))
+		return EFI_OUT_OF_RESOURCES;
+
+	return EFI_SUCCESS;
+}
+EXPORT_SYMBOL_GPL(efi_query_variable_store);
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index b07cb37..e3e95dd 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -428,24 +428,12 @@ static efi_status_t
 check_var_size_locked(struct efivars *efivars, u32 attributes,
 			unsigned long size)
 {
-	u64 storage_size, remaining_size, max_size;
-	efi_status_t status;
 	const struct efivar_operations *fops = efivars->ops;
 
-	if (!efivars->ops->query_variable_info)
+	if (!efivars->ops->query_variable_store)
 		return EFI_UNSUPPORTED;
 
-	status = fops->query_variable_info(attributes, &storage_size,
-					   &remaining_size, &max_size);
-
-	if (status != EFI_SUCCESS)
-		return status;
-
-	if (!storage_size || size > remaining_size || size > max_size ||
-	    (remaining_size - size) < (storage_size / 2))
-		return EFI_OUT_OF_RESOURCES;
-
-	return status;
+	return fops->query_variable_store(attributes, size);
 }
 
 
@@ -2059,7 +2047,7 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
-	ops.query_variable_info = efi.query_variable_info;
+	ops.query_variable_store = efi_query_variable_store;
 
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7a9498a..fd703f0 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -333,6 +333,7 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 					      unsigned long count,
 					      u64 *max_size,
 					      int *reset_type);
+typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
 
 /*
  *  EFI Configuration Table and GUID definitions
@@ -575,9 +576,15 @@ extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if pos
 #ifdef CONFIG_X86
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
+extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
 #else
 static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
+
+static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	return EFI_SUCCESS;
+}
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern u64 efi_get_iobase (void);
@@ -731,7 +738,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
-	efi_query_variable_info_t *query_variable_info;
+	efi_query_variable_store_t *query_variable_store;
 };
 
 struct efivars {
-- 
1.8.1.2

