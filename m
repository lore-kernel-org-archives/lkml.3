Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937160Ab3DJRqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:46:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53406 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157Ab3DJRqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:46:21 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V4 3/3] efi: Distinguish between "remaining space" and actually used space
Date: Wed, 10 Apr 2013 13:46:07 -0400
Message-Id: <1365615967-27346-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
 <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI implementations distinguish between space that is actively used by a
variable and space that merely hasn't been garbage collected yet. Space
that hasn't yet been garbage collected isn't available for use and so isn't
counted in the remaining_space field returned by QueryVariableInfo().

Combined with commit 68d9298 this can cause problems. Some implementations
don't garbage collect until the remaining space is smaller than the maximum
variable size, and as a result check_var_size() will always fail once more
than 50% of the variable store has been used even if most of that space is
marked as available for garbage collection. The user is unable to create
new variables, and deleting variables doesn't increase the remaining space.

The problem that 68d9298 was attempting to avoid was one where certain
platforms fail if the actively used space is greater than 50% of the
available storage space. We should be able to calculate that by simply
summing the size of each available variable and subtracting that from
the total storage space. With luck this will fix the problem described in
https://bugzilla.kernel.org/show_bug.cgi?id=55471 without permitting
damage to occur to the machines 68d9298 was attempting to fix.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/firmware/efivars.c | 104 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 60e7d8f..33a2be0 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -104,6 +104,13 @@ MODULE_VERSION(EFIVARS_VERSION);
  */
 #define GUID_LEN 36
 
+/*
+ * There's some additional metadata associated with each
+ * variable. Intel's reference implementation is 60 bytes - bump that
+ * to account for potential alignment constraints
+ */
+#define VAR_METADATA_SIZE 64
+
 static bool efivars_pstore_disable =
 	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
 
@@ -405,6 +412,52 @@ validate_var(struct efi_variable *var, u8 *data, unsigned long len)
 }
 
 static efi_status_t
+get_var_size_locked(struct efivars *efivars, struct efi_variable *var)
+{
+	efi_status_t status;
+	void *dummy;
+
+	var->DataSize = 0;
+	status = efivars->ops->get_variable(var->VariableName,
+					    &var->VendorGuid,
+					    &var->Attributes,
+					    &var->DataSize,
+					    var->Data);
+
+	if (status != EFI_BUFFER_TOO_SMALL)
+		return status;
+
+	dummy = kmalloc(var->DataSize, GFP_ATOMIC);
+
+	status = efivars->ops->get_variable(var->VariableName,
+					    &var->VendorGuid,
+					    &var->Attributes,
+					    &var->DataSize,
+					    dummy);
+
+	kfree(dummy);
+
+	return status;
+}
+
+static efi_status_t
+get_var_size(struct efivars *efivars, struct efi_variable *var)
+{
+	efi_status_t status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&efivars->lock, flags);
+	status = get_var_size_locked(efivars, var);
+	spin_unlock_irqrestore(&efivars->lock, flags);
+
+	if (status != EFI_SUCCESS) {
+		printk(KERN_WARNING "efivars: Failed to get var size 0x%lx!\n",
+			status);
+	}
+	return status;
+}
+
+static efi_status_t
 get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
 {
 	efi_status_t status;
@@ -415,6 +468,10 @@ get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
 					    &var->Attributes,
 					    &var->DataSize,
 					    var->Data);
+
+	if (status != EFI_SUCCESS)
+		var->DataSize = 0;
+
 	return status;
 }
 
@@ -440,8 +497,18 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
 			unsigned long size)
 {
 	u64 storage_size, remaining_size, max_size;
+	struct efivar_entry *entry;
+	struct efi_variable *var;
 	efi_status_t status;
 	const struct efivar_operations *fops = efivars->ops;
+	unsigned long active_size = 0;
+
+	/*
+	 * Any writes other than EFI_VARIABLE_NON_VOLATILE will only hit
+	 * RAM, not flash, so ignore them.
+	 */
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return EFI_SUCCESS;
 
 	if (!efivars->ops->query_variable_info)
 		return EFI_UNSUPPORTED;
@@ -452,8 +519,39 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!storage_size || size > remaining_size || size > max_size ||
-	    (remaining_size - size) < (storage_size / 2))
+	list_for_each_entry(entry, &efivars->list, list) {
+		var = &entry->var;
+		status = EFI_SUCCESS;
+
+		if (var->DataSize == 0)
+			status = get_var_size_locked(efivars, var);
+
+		if (status || !(var->Attributes & EFI_VARIABLE_NON_VOLATILE))
+				continue;
+
+		active_size += var->DataSize;
+		active_size += utf16_strsize(var->VariableName, 1024);
+		active_size += VAR_METADATA_SIZE;
+	}
+
+	/*
+	 * Add on the size of any boot services-only variables
+	 */
+	active_size += boot_var_size;
+
+	/*
+	 * Some firmware implementations refuse to boot if there's insufficient
+	 * space in the variable store. We account for that by refusing the
+	 * write if permitting it would reduce the available space to under
+	 * 50%. However, some firmware won't reclaim variable space until
+	 * after the used (not merely the actively used) space drops below
+	 * a threshold. We can approximate that case with the value calculated
+	 * above. If both the firmware and our calculations indicate that the
+	 * available space would drop below 50%, refuse the write.
+	 */
+	if (!storage_size || size > remaining_size ||
+	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
+	     (remaining_size - size < storage_size / 2)))
 		return EFI_OUT_OF_RESOURCES;
 
 	return status;
@@ -2095,7 +2193,7 @@ int register_efivars(struct efivars *efivars,
 	if (boot_used_size) {
 		list_for_each_entry(entry, &efivars->list, list) {
 			var = &entry->var;
-			status = get_var_data(efivars, var);
+			status = get_var_size(efivars, var);
 
 			if (status ||
 			    !(var->Attributes & EFI_VARIABLE_NON_VOLATILE))
-- 
1.8.1.2

