Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab3GKO36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:29:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097Ab3GKO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Josh Boyer <jwboyer@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 89/98] efi: be more paranoid about available space when creating variables
Date: Thu, 11 Jul 2013 15:24:59 +0100
Message-Id: <1373552708-15235-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <matthew.garrett@nebula.com>

commit 68d929862e29a8b52a7f2f2f86a0600423b093cd upstream.

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
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ luis: backported to 3.5, based on bwh's backport to 3.2:
  - Drop efivarfs changes and unused check_var_size()
  - Add error codes to include/linux/efi.h, added upstream by
    commit 5d9db883761a ('efi: Add support for a UEFI variable filesystem')
  - Add efi_status_to_err(), added upstream by commit 7253eaba7b17
    ('efivarfs: Return an error if we fail to read a variable')]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firmware/efivars.c | 88 ++++++++++++++++++++++++++++++++++++++++------
 include/linux/efi.h        |  5 +++
 2 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 13f631c..d68ce4b 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -411,6 +411,30 @@ get_var_data(struct efivars *efivars, struct efi_variable *var)
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
 static ssize_t
 efivar_guid_read(struct efivar_entry *entry, char *buf)
 {
@@ -532,11 +556,16 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
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
 
@@ -635,6 +664,36 @@ static struct kobj_type efivar_ktype = {
 	.default_attrs = def_attrs,
 };
 
+static int efi_status_to_err(efi_status_t status)
+{
+	int err;
+
+	switch (status) {
+	case EFI_INVALID_PARAMETER:
+		err = -EINVAL;
+		break;
+	case EFI_OUT_OF_RESOURCES:
+		err = -ENOSPC;
+		break;
+	case EFI_DEVICE_ERROR:
+		err = -EIO;
+		break;
+	case EFI_WRITE_PROTECTED:
+		err = -EROFS;
+		break;
+	case EFI_SECURITY_VIOLATION:
+		err = -EACCES;
+		break;
+	case EFI_NOT_FOUND:
+		err = -ENOENT;
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
 static inline void
 efivar_unregister(struct efivar_entry *var)
 {
@@ -711,7 +770,6 @@ static int efi_pstore_write(enum pstore_type_id type,
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
 	int i, ret = 0;
-	u64 storage_space, remaining_space, max_variable_size;
 	efi_status_t status = EFI_NOT_FOUND;
 	unsigned long flags;
 
@@ -725,11 +783,11 @@ static int efi_pstore_write(enum pstore_type_id type,
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
@@ -864,6 +922,14 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8554af9..260b2c5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -29,7 +29,12 @@
 #define EFI_UNSUPPORTED		( 3 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_BAD_BUFFER_SIZE     ( 4 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_BUFFER_TOO_SMALL	( 5 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_NOT_READY		( 6 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_DEVICE_ERROR	( 7 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_WRITE_PROTECTED	( 8 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_OUT_OF_RESOURCES	( 9 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_NOT_FOUND		(14 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_SECURITY_VIOLATION	(26 | (1UL << (BITS_PER_LONG-1)))
 
 typedef unsigned long efi_status_t;
 typedef u8 efi_bool_t;
-- 
1.8.1.2

