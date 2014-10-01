Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaJAMGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:06:48 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49048 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJAMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:06:45 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 1/2] efi: Provide a non-blocking SetVariable() operation
Date: Wed,  1 Oct 2014 13:06:39 +0100
Message-Id: <1412165200-32141-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
References: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

There are some circumstances that call for trying to write an EFI
variable in a non-blocking way. One such scenario is when writing pstore
data in efi_pstore_write() via the pstore_dump() kdump callback.

Now that we have an EFI runtime spinlock we need a way of aborting if
there is contention instead of spinning, since when writing pstore data
from the kdump callback, the runtime lock may already be held by the CPU
that's running the callback if we crashed in the middle of an EFI
variable operation.

The situation is sufficiently special that a new EFI variable operation
is warranted.

Introduce ->set_variable_nonblocking() for this use case. It is an
optional EFI backend operation, and need only be implemented by those
backends that usually acquire locks to serialize access to EFI
variables, as is the case for virt_efi_set_variable() where we now grab
the EFI runtime spinlock.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/runtime-wrappers.c | 19 +++++++++++++
 drivers/firmware/efi/vars.c             | 47 +++++++++++++++++++++++++++++++++
 include/linux/efi.h                     |  6 +++++
 3 files changed, 72 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 9694cba665c4..4349206198b2 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -200,6 +200,24 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 	return status;
 }
 
+static efi_status_t
+virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
+				  u32 attr, unsigned long data_size,
+				  void *data)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	if (!spin_trylock_irqsave(&efi_runtime_lock, flags))
+		return EFI_NOT_READY;
+
+	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
+			       data);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
+}
+
+
 static efi_status_t virt_efi_query_variable_info(u32 attr,
 						 u64 *storage_space,
 						 u64 *remaining_space,
@@ -287,6 +305,7 @@ void efi_native_runtime_setup(void)
 	efi.get_variable = virt_efi_get_variable;
 	efi.get_next_variable = virt_efi_get_next_variable;
 	efi.set_variable = virt_efi_set_variable;
+	efi.set_variable_nonblocking = virt_efi_set_variable_nonblocking;
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.query_variable_info = virt_efi_query_variable_info;
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 1fa724f31b0e..fa3c66bdc1e5 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -595,6 +595,39 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 }
 EXPORT_SYMBOL_GPL(efivar_entry_set);
 
+/*
+ * efivar_entry_set_nonblocking - call set_variable_nonblocking()
+ *
+ * This function is guaranteed to not block and is suitable for calling
+ * from crash/panic handlers.
+ *
+ * Crucially, this function will not block if it cannot acquire
+ * __efivars->lock. Instead, it returns -EBUSY.
+ */
+static int
+efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
+			     u32 attributes, unsigned long size, void *data)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	unsigned long flags;
+	efi_status_t status;
+
+	if (!spin_trylock_irqsave(&__efivars->lock, flags))
+		return -EBUSY;
+
+	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
+	if (status != EFI_SUCCESS) {
+		spin_unlock_irqrestore(&__efivars->lock, flags);
+		return -ENOSPC;
+	}
+
+	status = ops->set_variable_nonblocking(name, &vendor, attributes,
+					       size, data);
+
+	spin_unlock_irqrestore(&__efivars->lock, flags);
+	return efi_status_to_err(status);
+}
+
 /**
  * efivar_entry_set_safe - call set_variable() if enough space in firmware
  * @name: buffer containing the variable name
@@ -622,6 +655,20 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 	if (!ops->query_variable_store)
 		return -ENOSYS;
 
+	/*
+	 * If the EFI variable backend provides a non-blocking
+	 * ->set_variable() operation and we're in a context where we
+	 * cannot block, then we need to use it to avoid live-locks,
+	 * since the implication is that the regular ->set_variable()
+	 * will block.
+	 *
+	 * If no ->set_variable_nonblocking() is provided then
+	 * ->set_variable() is assumed to be non-blocking.
+	 */
+	if (!block && ops->set_variable_nonblocking)
+		return efivar_entry_set_nonblocking(name, vendor, attributes,
+						    size, data);
+
 	if (!block) {
 		if (!spin_trylock_irqsave(&__efivars->lock, flags))
 			return -EBUSY;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6e84881d146f..1c70cf5e3301 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -503,6 +503,10 @@ typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char
 typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
 					 u32 attr, unsigned long data_size,
 					 void *data);
+typedef efi_status_t
+efi_set_variable_nonblocking_t(efi_char16_t *name, efi_guid_t *vendor,
+			       u32 attr, unsigned long data_size, void *data);
+
 typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
 typedef void efi_reset_system_t (int reset_type, efi_status_t status,
 				 unsigned long data_size, efi_char16_t *data);
@@ -822,6 +826,7 @@ extern struct efi {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_set_variable_nonblocking_t *set_variable_nonblocking;
 	efi_query_variable_info_t *query_variable_info;
 	efi_update_capsule_t *update_capsule;
 	efi_query_capsule_caps_t *query_capsule_caps;
@@ -1042,6 +1047,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_set_variable_nonblocking_t *set_variable_nonblocking;
 	efi_query_variable_store_t *query_variable_store;
 };
 
-- 
1.9.3

