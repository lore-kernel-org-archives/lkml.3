Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab3JPNwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:52:12 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60940 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934479Ab3JPNvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:51:14 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 2/5] efi: Introduce a Runtime Services lock
Date: Wed, 16 Oct 2013 14:50:57 +0100
Message-Id: <1381931460-6999-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Section 7.1 Runtime Services Rules and Restrictions of the UEFI spec
describes how many of the runtime services are not reentrant. We need a
method of prohibiting functions from being called concurrently.

We've managed to get away without requiring a runtime services lock
until now because most of the interactions with EFI involve EFI
variables, and those operations are already serialised with
__efivars->lock.

This change does mean that we can avoid acquiring __efivars->lock where
the only reason we acquired it in the first place was to prevent
concurrent execution of the EFI variable services, e.g.
efivar_entry_size().

The spec makes allowances for accessing the runtime services from NMI
context. In that case we want to avoid grabbing the runtime lock to
ensure we make forward progress, e.g. in efi_pstore_write().

Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/ia64/kernel/efi.c      |  33 +++++++++++++-
 arch/x86/platform/efi/efi.c | 108 ++++++++++++++++++++++++++++++++++++++------
 drivers/firmware/efi/efi.c  |   8 ++++
 drivers/firmware/efi/vars.c |  19 ++------
 include/linux/efi.h         |   2 +
 5 files changed, 139 insertions(+), 31 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index da5b462..cb4f13e 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -56,7 +56,21 @@ extern efi_status_t efi_call_phys (void *, ...);
 static efi_runtime_services_t *runtime;
 static u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;
 
-#define efi_call_virt(f, args...)	(*(f))(args)
+#define efi_call_virt(f, args...)					\
+({									\
+	unsigned long __flags;						\
+	efi_status_t __status;						\
+	bool __nmi = in_nmi();						\
+									\
+	if (!__nmi)							\
+		spin_lock_irqsave(&efi_runtime_lock, __flags);		\
+									\
+	__status = (*(f))(args);					\
+									\
+	if (!__nmi)							\
+		spin_unlock_irqrestore(&efi_runtime_lock, __flags);	\
+	__status;							\
+})
 
 #define STUB_GET_TIME(prefix, adjust_arg)				       \
 static efi_status_t							       \
@@ -192,6 +206,21 @@ prefix##_get_next_high_mono_count (u32 *count)				       \
 	return ret;							       \
 }
 
+#define efi_call_reset_phys	efi_call_phys
+#define efi_call_reset_virt(f, args...)					\
+({									\
+	unsigned long __flags;						\
+	bool __nmi = in_nmi();						\
+									\
+	if (__nmi)							\
+		spin_lock_irqsave(&efi_runtime_lock, __flags);		\
+									\
+	(*f)(args);							\
+									\
+	if (__nmi)							\
+		spin_unlock_irqrestore(&efi_runtime_lock, __flags);	\
+})
+
 #define STUB_RESET_SYSTEM(prefix, adjust_arg)				       \
 static void								       \
 prefix##_reset_system (int reset_type, efi_status_t status,		       \
@@ -204,7 +233,7 @@ prefix##_reset_system (int reset_type, efi_status_t status,		       \
 		adata = adjust_arg(data);				       \
 									       \
 	ia64_save_scratch_fpregs(fr);					       \
-	efi_call_##prefix(						       \
+	efi_call_reset_##prefix(				       \
 		(efi_reset_system_t *) __va(runtime->reset_system),	       \
 		reset_type, status, data_size, adata);			       \
 	/* should not return, but just in case... */			       \
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 1d3372a..8944e2c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -117,7 +117,11 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt2(get_time, tm, tc);
+	spin_unlock(&efi_runtime_lock);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -128,7 +132,11 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt1(set_time, tm);
+	spin_unlock(&efi_runtime_lock);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -141,8 +149,12 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt3(get_wakeup_time,
 				enabled, pending, tm);
+	spin_unlock(&efi_runtime_lock);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -153,8 +165,12 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt2(set_wakeup_time,
 				enabled, tm);
+	spin_unlock(&efi_runtime_lock);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -165,17 +181,31 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  unsigned long *data_size,
 					  void *data)
 {
-	return efi_call_virt5(get_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt5(get_variable,
+				name, vendor, attr,
+				data_size, data);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+
+	return status;
 }
 
 static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt3(get_next_variable,
-			      name_size, name, vendor);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt3(get_next_variable,
+				name_size, name, vendor);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+
+	return status;
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -184,9 +214,21 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	return efi_call_virt5(set_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	unsigned long flags;
+	efi_status_t status;
+	bool nmi = in_nmi();
+
+	if (!nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
+
+	status = efi_call_virt5(set_variable,
+				name, vendor, attr,
+				data_size, data);
+
+	if (!nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+
+	return status;
 }
 
 static efi_status_t virt_efi_query_variable_info(u32 attr,
@@ -194,16 +236,35 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 						 u64 *remaining_space,
 						 u64 *max_variable_size)
 {
+	unsigned long flags;
+	efi_status_t status;
+	bool nmi = in_nmi();
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt4(query_variable_info, attr, storage_space,
-			      remaining_space, max_variable_size);
+	if (!nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
+
+	status = efi_call_virt4(query_variable_info, attr, storage_space,
+				remaining_space, max_variable_size);
+
+	if (!nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+
+	return status;
 }
 
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
-	return efi_call_virt1(get_next_high_mono_count, count);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt1(get_next_high_mono_count, count);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+
+	return status;
 }
 
 static void virt_efi_reset_system(int reset_type,
@@ -211,18 +272,30 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
+	unsigned long flags;
+	bool nmi = in_nmi();
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
 	efi_call_virt4(reset_system, reset_type, status,
 		       data_size, data);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 					    unsigned long count,
 					    unsigned long sg_list)
 {
+	unsigned long flags;
+	efi_status_t status;
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt3(update_capsule, capsules, count, sg_list);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt3(update_capsule, capsules, count, sg_list);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+
+	return status;
 }
 
 static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
@@ -230,11 +303,18 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 						u64 *max_size,
 						int *reset_type)
 {
+	unsigned long flags;
+	efi_status_t status;
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt4(query_capsule_caps, capsules, count, max_size,
-			      reset_type);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt4(query_capsule_caps, capsules, count, max_size,
+				reset_type);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+
+	return status;
 }
 
 static efi_status_t __init phys_efi_set_virtual_address_map(
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 2e2fbde..772f559 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -35,6 +35,14 @@ struct efi __read_mostly efi = {
 };
 EXPORT_SYMBOL(efi);
 
+/*
+ * 'efi_runtime_lock' protects against concurrently invoking the EFI
+ * runtime services, many of which are not reentrant.
+ *
+ * You must disable interrupts when acquiring this lock.
+ */
+DEFINE_SPINLOCK(efi_runtime_lock);
+
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 391c67b..ac9a4ea 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -376,7 +376,8 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		return -ENOMEM;
 	}
 
-	spin_lock_irq(&__efivars->lock);
+	if (atomic)
+		spin_lock_irq(&__efivars->lock);
 
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
@@ -391,9 +392,6 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
-			if (!atomic)
-				spin_unlock_irq(&__efivars->lock);
-
 			variable_name_size = var_name_strnsize(variable_name,
 							       variable_name_size);
 
@@ -409,8 +407,6 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 			    variable_is_present(variable_name, &vendor_guid, head)) {
 				dup_variable_bug(variable_name, &vendor_guid,
 						 variable_name_size);
-				if (!atomic)
-					spin_lock_irq(&__efivars->lock);
 
 				status = EFI_NOT_FOUND;
 				break;
@@ -420,9 +416,6 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 			if (err)
 				status = EFI_NOT_FOUND;
 
-			if (!atomic)
-				spin_lock_irq(&__efivars->lock);
-
 			break;
 		case EFI_NOT_FOUND:
 			break;
@@ -435,7 +428,8 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 
 	} while (status != EFI_NOT_FOUND);
 
-	spin_unlock_irq(&__efivars->lock);
+	if (atomic)
+		spin_unlock_irq(&__efivars->lock);
 
 	kfree(variable_name);
 
@@ -702,11 +696,8 @@ int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 
 	*size = 0;
 
-	spin_lock_irq(&__efivars->lock);
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid, NULL, size, NULL);
-	spin_unlock_irq(&__efivars->lock);
-
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
 
@@ -754,11 +745,9 @@ int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	spin_lock_irq(&__efivars->lock);
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
 				   attributes, size, data);
-	spin_unlock_irq(&__efivars->lock);
 
 	return efi_status_to_err(status);
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index bc5687d..153df45 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -812,6 +812,8 @@ struct efi_simple_text_output_protocol {
 
 extern struct list_head efivar_sysfs_list;
 
+extern spinlock_t efi_runtime_lock;
+
 static inline void
 efivar_unregister(struct efivar_entry *var)
 {
-- 
1.8.1.4

