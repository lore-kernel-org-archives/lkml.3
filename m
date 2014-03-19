Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbaCSUB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:01:59 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59882 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754487AbaCSUAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:00:09 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 1/5] efivars: Use local variables instead of a pointer dereference
Date: Wed, 19 Mar 2014 19:59:56 +0000
Message-Id: <1395259200-27732-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
References: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

In order to support a compat interface we need to stop passing pointers
to structures around, since the type of structure is going to depend on
whether the current task is a compat task.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/efivars.c | 48 ++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 50ea412a25e6..06ec6ee1c58a 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -197,37 +197,48 @@ static ssize_t
 efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 {
 	struct efi_variable *new_var, *var = &entry->var;
+	efi_char16_t *name;
+	unsigned long size;
+	efi_guid_t vendor;
+	u32 attributes;
+	u8 *data;
 	int err;
 
 	if (count != sizeof(struct efi_variable))
 		return -EINVAL;
 
 	new_var = (struct efi_variable *)buf;
+
+	attributes = new_var->Attributes;
+	vendor = new_var->VendorGuid;
+	name = new_var->VariableName;
+	size = new_var->DataSize;
+	data = new_var->Data;
+
 	/*
 	 * If only updating the variable data, then the name
 	 * and guid should remain the same
 	 */
-	if (memcmp(new_var->VariableName, var->VariableName, sizeof(var->VariableName)) ||
-		efi_guidcmp(new_var->VendorGuid, var->VendorGuid)) {
+	if (memcmp(name, var->VariableName, sizeof(var->VariableName)) ||
+		efi_guidcmp(vendor, var->VendorGuid)) {
 		printk(KERN_ERR "efivars: Cannot edit the wrong variable!\n");
 		return -EINVAL;
 	}
 
-	if ((new_var->DataSize <= 0) || (new_var->Attributes == 0)){
+	if ((size <= 0) || (attributes == 0)){
 		printk(KERN_ERR "efivars: DataSize & Attributes must be valid!\n");
 		return -EINVAL;
 	}
 
-	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
+	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    efivar_validate(new_var, data, size) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
 
 	memcpy(&entry->var, new_var, count);
 
-	err = efivar_entry_set(entry, new_var->Attributes,
-			       new_var->DataSize, new_var->Data, NULL);
+	err = efivar_entry_set(entry, attributes, size, data, NULL);
 	if (err) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%d\n", err);
 		return -EIO;
@@ -328,13 +339,20 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
 	struct efivar_entry *new_entry;
+	unsigned long size;
+	u32 attributes;
+	u8 *data;
 	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
+	attributes = new_var->Attributes;
+	size = new_var->DataSize;
+	data = new_var->Data;
+
+	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    efivar_validate(new_var, data, size) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
@@ -345,8 +363,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 
 	memcpy(&new_entry->var, new_var, sizeof(*new_var));
 
-	err = efivar_entry_set(new_entry, new_var->Attributes, new_var->DataSize,
-			       new_var->Data, &efivar_sysfs_list);
+	err = efivar_entry_set(new_entry, attributes, size,
+			       data, &efivar_sysfs_list);
 	if (err) {
 		if (err == -EEXIST)
 			err = -EINVAL;
@@ -370,14 +388,18 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
 	struct efivar_entry *entry;
+	efi_char16_t *name;
+	efi_guid_t vendor;
 	int err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	name = del_var->VariableName;
+	vendor = del_var->VendorGuid;
+
 	efivar_entry_iter_begin();
-	entry = efivar_entry_find(del_var->VariableName, del_var->VendorGuid,
-				  &efivar_sysfs_list, true);
+	entry = efivar_entry_find(name, vendor, &efivar_sysfs_list, true);
 	if (!entry)
 		err = -EINVAL;
 	else if (__efivar_entry_delete(entry))
-- 
1.8.5.3

