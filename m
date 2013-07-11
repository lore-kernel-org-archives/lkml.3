Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab3GKOa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:30:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43278 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3GKO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 90/98] x86, efivars: firmware bug workarounds should be in platform code
Date: Thu, 11 Jul 2013 15:25:00 +0100
Message-Id: <1373552708-15235-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit a6e4d5a03e9e3587e88aba687d8f225f4f04c792 upstream.

Let's not burden ia64 with checks in the common efivars code that we're not
writing too much data to the variable store. That kind of thing is an x86
firmware bug, plain and simple.

efi_query_variable_store() provides platforms with a wrapper in which they can
perform checks and workarounds for EFI variable storage bugs.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/platform/efi/efi.c | 25 +++++++++++++++++++++++++
 drivers/firmware/efivars.c  | 19 ++++---------------
 include/linux/efi.h         |  9 ++++++++-
 3 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 1e40637..8bb9f83 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -964,3 +964,28 @@ u64 efi_mem_attributes(unsigned long phys_addr)
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
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d68ce4b..d7c3540 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -415,24 +415,12 @@ static efi_status_t
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
 
 static ssize_t
@@ -1305,7 +1293,8 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
-	ops.query_variable_info = efi.query_variable_info;
+	ops.query_variable_store = efi_query_variable_store;
+
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 260b2c5..6cf4a63 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -262,6 +262,7 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 					      unsigned long count,
 					      u64 *max_size,
 					      int *reset_type);
+typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
 
 /*
  *  EFI Configuration Table and GUID definitions
@@ -503,8 +504,14 @@ extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #ifdef CONFIG_X86
 extern void efi_free_boot_services(void);
+extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
 #else
 static inline void efi_free_boot_services(void) {}
+
+static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	return EFI_SUCCESS;
+}
 #endif
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
@@ -657,7 +664,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
-	efi_query_variable_info_t *query_variable_info;
+	efi_query_variable_store_t *query_variable_store;
 };
 
 struct efivars {
-- 
1.8.1.2

