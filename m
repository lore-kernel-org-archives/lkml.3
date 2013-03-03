Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3CCAkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 19:40:31 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39329 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3CCAka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 19:40:30 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] efi: be more paranoid about available space when creating variables
Date: Sat,  2 Mar 2013 19:40:17 -0500
Message-Id: <1362271217-31747-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:5578:da7b:a9ef:737
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI variables are typically stored in flash. For various reasons, avaiable
space is typically not reclaimed immediately upon the deletion of a
variable - instead, the system will garbage collect during initialisation
after a reboot.

Some systems appear to handle this garbage collection extremely poorly,
failing if more than 50% of the system flash is in use. This can result in
the machine refusing to boot. The safest thing to do for the moment is to
forbid writes if they'd end up using more than half of the storage space.
We can make this more finegrained later if we come up with a method for
identifying the broken machines.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/firmware/efivars.c | 106 +++++++++++++++++++++++++++++++++------------
 1 file changed, 79 insertions(+), 27 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7320bf8..0d50497 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -426,6 +426,44 @@ get_var_data(struct efivars *efivars, struct efi_variable *var)
 	return status;
 }
 
+static efi_status_t
+check_var_size_locked(struct efivars *efivars, u32 attributes,
+			unsigned long size)
+{
+	u64 storage_size, remaining_size, max_size;
+	efi_status_t status;
+	const struct efivar_operations *fops = efivars->ops;
+
+	if (!efivars->ops->query_variable_info)
+		return EFI_UNSUPPORTED;
+
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
+}
+
+
+static efi_status_t
+check_var_size(struct efivars *efivars, u32 attributes, unsigned long size)
+{
+	efi_status_t status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&efivars->lock, flags);
+	status = check_var_size_locked(efivars, attributes, size);
+	spin_unlock_irqrestore(&efivars->lock, flags);
+
+	return status;
+}
+
 static ssize_t
 efivar_guid_read(struct efivar_entry *entry, char *buf)
 {
@@ -547,11 +585,16 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	}
 
 	spin_lock_irq(&efivars->lock);
-	status = efivars->ops->set_variable(new_var->VariableName,
-					    &new_var->VendorGuid,
-					    new_var->Attributes,
-					    new_var->DataSize,
-					    new_var->Data);
+
+	status = check_var_size_locked(efivars, new_var->Attributes,
+	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+
+	if (status == EFI_SUCCESS || status == EFI_UNSUPPORTED)
+		status = efivars->ops->set_variable(new_var->VariableName,
+						    &new_var->VendorGuid,
+						    new_var->Attributes,
+						    new_var->DataSize,
+						    new_var->Data);
 
 	spin_unlock_irq(&efivars->lock);
 
@@ -702,8 +745,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
-	unsigned long newdatasize;
-	u64 storage_size, remaining_size, max_size;
+	unsigned long newdatasize, varsize;
 	ssize_t bytes = 0;
 
 	if (count < sizeof(attributes))
@@ -722,28 +764,18 @@ static ssize_t efivarfs_file_write(struct file *file,
 	 * amounts of memory. Pick a default size of 64K if
 	 * QueryVariableInfo() isn't supported by the firmware.
 	 */
-	spin_lock_irq(&efivars->lock);
 
-	if (!efivars->ops->query_variable_info)
-		status = EFI_UNSUPPORTED;
-	else {
-		const struct efivar_operations *fops = efivars->ops;
-		status = fops->query_variable_info(attributes, &storage_size,
-						   &remaining_size, &max_size);
-	}
-
-	spin_unlock_irq(&efivars->lock);
+	varsize = datasize + utf16_strsize(var->var.VariableName, 1024);
+	status = check_var_size(efivars, attributes, varsize);
 
 	if (status != EFI_SUCCESS) {
 		if (status != EFI_UNSUPPORTED)
 			return efi_status_to_err(status);
 
-		remaining_size = 65536;
+		if (datasize > 65536)
+			return -ENOSPC;
 	}
 
-	if (datasize > remaining_size)
-		return -ENOSPC;
-
 	data = kmalloc(datasize, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -765,6 +797,19 @@ static ssize_t efivarfs_file_write(struct file *file,
 	 */
 	spin_lock_irq(&efivars->lock);
 
+	/*
+	 * Ensure that the available space hasn't shrunk below the safe level
+	 */
+
+	status = check_var_size_locked(efivars, attributes, varsize);
+
+	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
+		spin_unlock_irq(&efivars->lock);
+		kfree(data);
+
+		return efi_status_to_err(status);
+	}
+
 	status = efivars->ops->set_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    attributes, datasize,
@@ -1345,7 +1390,6 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
 	int i, ret = 0;
-	u64 storage_space, remaining_space, max_variable_size;
 	efi_status_t status = EFI_NOT_FOUND;
 	unsigned long flags;
 
@@ -1365,11 +1409,11 @@ static int efi_pstore_write(enum pstore_type_id type,
 	 * size: a size of logging data
 	 * DUMP_NAME_LEN * 2: a maximum size of variable name
 	 */
-	status = efivars->ops->query_variable_info(PSTORE_EFI_ATTRIBUTES,
-						   &storage_space,
-						   &remaining_space,
-						   &max_variable_size);
-	if (status || remaining_space < size + DUMP_NAME_LEN * 2) {
+
+	status = check_var_size_locked(efivars, PSTORE_EFI_ATTRIBUTES,
+					 size + DUMP_NAME_LEN * 2);
+
+	if (status) {
 		spin_unlock_irqrestore(&efivars->lock, flags);
 		*id = part;
 		return -ENOSPC;
@@ -1544,6 +1588,14 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		return -EINVAL;
 	}
 
+	status = check_var_size_locked(efivars, new_var->Attributes,
+	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+
+	if (status && status != EFI_UNSUPPORTED) {
+		spin_unlock_irq(&efivars->lock);
+		return efi_status_to_err(status);
+	}
+
 	/* now *really* create the variable via EFI */
 	status = efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
-- 
1.8.1.2

