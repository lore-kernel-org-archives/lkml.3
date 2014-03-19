Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaCSUAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:00:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59915 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbaCSUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:00:22 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 5/5] efivars: Add compatibility code for compat tasks
Date: Wed, 19 Mar 2014 20:00:00 +0000
Message-Id: <1395259200-27732-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
References: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

It seems people are using 32-bit efibootmgr on top of 64-bit kernels,
which will currently fail horribly when using the efivars interface,
which is the traditional efibootmgr backend (the other being efivarfs).

Since there is no versioning info in the data structure, figure out when
we need to munge the structure data via judicious use of
is_compat_task().

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/efivars.c | 142 +++++++++++++++++++++++++++++++++--------
 1 file changed, 116 insertions(+), 26 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index a44310c6a8ba..463c56545ae8 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -69,6 +69,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/ucs2_string.h>
+#include <linux/compat.h>
 
 #define EFIVARS_VERSION "0.08"
 #define EFIVARS_DATE "2004-May-17"
@@ -86,6 +87,15 @@ static struct kset *efivars_kset;
 static struct bin_attribute *efivars_new_var;
 static struct bin_attribute *efivars_del_var;
 
+struct compat_efi_variable {
+	efi_char16_t  VariableName[EFI_VAR_NAME_LEN/sizeof(efi_char16_t)];
+	efi_guid_t    VendorGuid;
+	__u32         DataSize;
+	__u8          Data[1024];
+	__u32         Status;
+	__u32         Attributes;
+} __packed;
+
 struct efivar_attribute {
 	struct attribute attr;
 	ssize_t (*show) (struct efivar_entry *entry, char *buf);
@@ -218,6 +228,25 @@ sanity_check(struct efi_variable *var, efi_char16_t *name, efi_guid_t vendor,
 	return 0;
 }
 
+static inline bool is_compat(void)
+{
+	if (IS_ENABLED(CONFIG_COMPAT) && is_compat_task())
+		return true;
+
+	return false;
+}
+
+static void
+copy_out_compat(struct efi_variable *dst, struct compat_efi_variable *src)
+{
+	memcpy(dst->VariableName, src->VariableName, EFI_VAR_NAME_LEN);
+	memcpy(dst->Data, src->Data, sizeof(src->Data));
+
+	dst->VendorGuid = src->VendorGuid;
+	dst->DataSize = src->DataSize;
+	dst->Attributes = src->Attributes;
+}
+
 /*
  * We allow each variable to be edited via rewriting the
  * entire efi variable structure.
@@ -233,22 +262,42 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	u8 *data;
 	int err;
 
-	if (count != sizeof(struct efi_variable))
-		return -EINVAL;
+	if (is_compat()) {
+		struct compat_efi_variable *compat;
 
-	new_var = (struct efi_variable *)buf;
+		if (count != sizeof(*compat))
+			return -EINVAL;
 
-	attributes = new_var->Attributes;
-	vendor = new_var->VendorGuid;
-	name = new_var->VariableName;
-	size = new_var->DataSize;
-	data = new_var->Data;
+		compat = (struct compat_efi_variable *)buf;
+		attributes = compat->Attributes;
+		vendor = compat->VendorGuid;
+		name = compat->VariableName;
+		size = compat->DataSize;
+		data = compat->Data;
 
-	err = sanity_check(var, name, vendor, size, attributes, data);
-	if (err)
-		return err;
+		err = sanity_check(var, name, vendor, size, attributes, data);
+		if (err)
+			return err;
+
+		copy_out_compat(&entry->var, compat);
+	} else {
+		if (count != sizeof(struct efi_variable))
+			return -EINVAL;
+
+		new_var = (struct efi_variable *)buf;
 
-	memcpy(&entry->var, new_var, count);
+		attributes = new_var->Attributes;
+		vendor = new_var->VendorGuid;
+		name = new_var->VariableName;
+		size = new_var->DataSize;
+		data = new_var->Data;
+
+		err = sanity_check(var, name, vendor, size, attributes, data);
+		if (err)
+			return err;
+
+		memcpy(&entry->var, new_var, count);
+	}
 
 	err = efivar_entry_set(entry, attributes, size, data, NULL);
 	if (err) {
@@ -263,6 +312,8 @@ static ssize_t
 efivar_show_raw(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
+	struct compat_efi_variable *compat;
+	size_t size;
 
 	if (!entry || !buf)
 		return 0;
@@ -272,9 +323,23 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
 			     &entry->var.DataSize, entry->var.Data))
 		return -EIO;
 
-	memcpy(buf, var, sizeof(*var));
+	if (is_compat()) {
+		compat = (struct compat_efi_variable *)buf;
+
+		size = sizeof(*compat);
+		memcpy(compat->VariableName, var->VariableName,
+			EFI_VAR_NAME_LEN);
+		memcpy(compat->Data, var->Data, sizeof(compat->Data));
+
+		compat->VendorGuid = var->VendorGuid;
+		compat->DataSize = var->DataSize;
+		compat->Attributes = var->Attributes;
+	} else {
+		size = sizeof(*var);
+		memcpy(buf, var, size);
+	}
 
-	return sizeof(*var);
+	return size;
 }
 
 /*
@@ -349,8 +414,10 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
+	struct compat_efi_variable *compat = (struct compat_efi_variable *)buf;
 	struct efi_variable *new_var = (struct efi_variable *)buf;
 	struct efivar_entry *new_entry;
+	bool need_compat = is_compat();
 	efi_char16_t *name;
 	unsigned long size;
 	u32 attributes;
@@ -360,13 +427,23 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (count != sizeof(*new_var))
-		return -EINVAL;
-
-	attributes = new_var->Attributes;
-	name = new_var->VariableName;
-	size = new_var->DataSize;
-	data = new_var->Data;
+	if (need_compat) {
+		if (count != sizeof(*compat))
+			return -EINVAL;
+
+		attributes = compat->Attributes;
+		name = compat->VariableName;
+		size = compat->DataSize;
+		data = compat->Data;
+	} else {
+		if (count != sizeof(*new_var))
+			return -EINVAL;
+
+		attributes = new_var->Attributes;
+		name = new_var->VariableName;
+		size = new_var->DataSize;
+		data = new_var->Data;
+	}
 
 	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
 	    efivar_validate(name, data, size) == false) {
@@ -378,7 +455,10 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (!new_entry)
 		return -ENOMEM;
 
-	memcpy(&new_entry->var, new_var, sizeof(*new_var));
+	if (need_compat)
+		copy_out_compat(&new_entry->var, compat);
+	else
+		memcpy(&new_entry->var, new_var, sizeof(*new_var));
 
 	err = efivar_entry_set(new_entry, attributes, size,
 			       data, &efivar_sysfs_list);
@@ -404,6 +484,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
+	struct compat_efi_variable *compat;
 	struct efivar_entry *entry;
 	efi_char16_t *name;
 	efi_guid_t vendor;
@@ -412,11 +493,20 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (count != sizeof(*del_var))
-		return -EINVAL;
+	if (is_compat()) {
+		if (count != sizeof(*compat))
+			return -EINVAL;
+
+		compat = (struct compat_efi_variable *)buf;
+		name = compat->VariableName;
+		vendor = compat->VendorGuid;
+	} else {
+		if (count != sizeof(*del_var))
+			return -EINVAL;
 
-	name = del_var->VariableName;
-	vendor = del_var->VendorGuid;
+		name = del_var->VariableName;
+		vendor = del_var->VendorGuid;
+	}
 
 	efivar_entry_iter_begin();
 	entry = efivar_entry_find(name, vendor, &efivar_sysfs_list, true);
-- 
1.8.5.3

