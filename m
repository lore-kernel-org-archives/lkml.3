Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab3E1EPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:15:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52549 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758817Ab3E1Dyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>,
        "Matt Fleming" <matt.fleming@intel.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.492091526@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [76/94] x86, efivars: firmware bug workarounds should be in
 platform code
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -815,3 +815,28 @@ u64 efi_mem_attributes(unsigned long phy
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
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -425,24 +425,12 @@ static efi_status_t
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
@@ -1456,7 +1444,7 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
-	ops.query_variable_info = efi.query_variable_info;
+	ops.query_variable_store = efi_query_variable_store;
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -204,6 +204,7 @@ typedef efi_status_t efi_query_capsule_c
 					      unsigned long count,
 					      u64 *max_size,
 					      int *reset_type);
+typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
 
 /*
  *  EFI Configuration Table and GUID definitions
@@ -331,6 +332,14 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+#ifdef CONFIG_X86
+extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
+#else
+static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	return EFI_SUCCESS;
+}
+#endif
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
@@ -475,7 +484,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
-	efi_query_variable_info_t *query_variable_info;
+	efi_query_variable_store_t *query_variable_store;
 };
 
 struct efivars {

