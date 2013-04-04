Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab3DDM1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:27:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49835 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759762Ab3DDM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:27:42 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Tom Gundersen <teg@jklm.no>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Tony Luck <tony.luck@intel.com>, Mike Waychison <mikew@google.com>
Subject: [PATCH 3/6] efivars: efivar_entry API
Date: Thu,  4 Apr 2013 13:18:52 +0100
Message-Id: <1365077935-6859-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

There isn't really a formal interface for dealing with EFI variables or struct
efivar_entry. Historically, this has led to various bits of code directly
accessing the generic EFI variable ops, which inherently ties it to a specific
EFI variable operations instead of indirectly using whatever ops were
registered with register_efivars(). This lead to the efivarfs code only working
with the generic EFI variable ops and not CONFIG_GOOGLE_SMI.

Encapsulate everything that needs to access '__efivars' inside an
efivar_entry_* API and use the new API in the pstore, sysfs and efivarfs code.

Much of the efivars code had to be rewritten to use this new API. For instance,
it is now up to the users of the API to build the initial list of EFI variables
in their efivar_init() callback function. The variable list needs to be passed
to efivar_init() which allows us to keep work arounds for things like
implementation bugs in GetNextVariable() in a central location.

Allowing users of the API to use a callback function to build the list greatly
benefits the efivarfs code which needs to allocate inodes and dentries for
every variable.  It previously did this in a racy way because the code ran
without holding the variable spinlock. Both the sysfs and efivarfs code
maintain their own lists which means the two interfaces can be running
simultaneously without interference, though it should be noted that because no
synchronisation is performed it is very easy to create inconsistencies.
efibootmgr doesn't currently use efivarfs and users are likely to also require
the old sysfs interface, so it makes sense to allow both to be built.

Cc: Tom Gundersen <teg@jklm.no>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efivars.c     | 1789 ++++++++++++++++++++++++----------------
 drivers/firmware/google/gsmi.c |   11 +-
 include/linux/efi.h            |   74 +-
 3 files changed, 1143 insertions(+), 731 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 721d200..a0f5534 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -97,39 +97,14 @@ MODULE_VERSION(EFIVARS_VERSION);
 
 #define DUMP_NAME_LEN 52
 
-/*
- * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
- * not including trailing NUL
- */
-#define GUID_LEN 36
+static LIST_HEAD(efivarfs_list);
+static LIST_HEAD(efivar_sysfs_list);
 
 static bool efivars_pstore_disable =
 	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
 
 module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
 
-/*
- * The maximum size of VariableName + Data = 1024
- * Therefore, it's reasonable to save that much
- * space in each part of the structure,
- * and we use a page for reading/writing.
- */
-
-struct efi_variable {
-	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
-	efi_guid_t    VendorGuid;
-	unsigned long DataSize;
-	__u8          Data[1024];
-	efi_status_t  Status;
-	__u32         Attributes;
-} __attribute__((packed));
-
-struct efivar_entry {
-	struct efi_variable var;
-	struct list_head list;
-	struct kobject kobj;
-};
-
 struct efivar_attribute {
 	struct attribute attr;
 	ssize_t (*show) (struct efivar_entry *entry, char *buf);
@@ -144,6 +119,11 @@ static struct efivars *__efivars;
 	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
 	 EFI_VARIABLE_RUNTIME_ACCESS)
 
+static struct kset *efivars_kset;
+
+static struct bin_attribute *efivars_new_var;
+static struct bin_attribute *efivars_del_var;
+
 #define EFIVAR_ATTR(_name, _mode, _show, _store) \
 struct efivar_attribute efivar_attr_##_name = { \
 	.attr = {.name = __stringify(_name), .mode = _mode}, \
@@ -158,10 +138,7 @@ struct efivar_attribute efivar_attr_##_name = { \
  * Prototype for sysfs creation function
  */
 static int
-efivar_create_sysfs_entry(struct efivars *efivars,
-			  unsigned long variable_name_size,
-			  efi_char16_t *variable_name,
-			  efi_guid_t *vendor_guid);
+efivar_create_sysfs_entry(struct efivar_entry *new_var);
 
 /*
  * Prototype for workqueue functions updating sysfs entry
@@ -346,8 +323,8 @@ static const struct variable_validate variable_validate[] = {
 	{ "", NULL },
 };
 
-static bool
-validate_var(struct efi_variable *var, u8 *data, unsigned long len)
+bool
+efivar_validate(struct efi_variable *var, u8 *data, unsigned long len)
 {
 	int i;
 	u16 *unicode_name = var->VariableName;
@@ -382,47 +359,16 @@ validate_var(struct efi_variable *var, u8 *data, unsigned long len)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(efivar_validate);
 
 static efi_status_t
-get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
-{
-	efi_status_t status;
-
-	var->DataSize = 1024;
-	status = efivars->ops->get_variable(var->VariableName,
-					    &var->VendorGuid,
-					    &var->Attributes,
-					    &var->DataSize,
-					    var->Data);
-	return status;
-}
-
-static efi_status_t
-get_var_data(struct efivars *efivars, struct efi_variable *var)
-{
-	efi_status_t status;
-	unsigned long flags;
-
-	spin_lock_irqsave(&efivars->lock, flags);
-	status = get_var_data_locked(efivars, var);
-	spin_unlock_irqrestore(&efivars->lock, flags);
-
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
-			status);
-	}
-	return status;
-}
-
-static efi_status_t
-check_var_size_locked(struct efivars *efivars, u32 attributes,
-			unsigned long size)
+check_var_size(u32 attributes, unsigned long size)
 {
 	u64 storage_size, remaining_size, max_size;
 	efi_status_t status;
-	const struct efivar_operations *fops = efivars->ops;
+	const struct efivar_operations *fops = __efivars->ops;
 
-	if (!efivars->ops->query_variable_info)
+	if (!fops->query_variable_info)
 		return EFI_UNSUPPORTED;
 
 	status = fops->query_variable_info(attributes, &storage_size,
@@ -438,20 +384,6 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
 	return status;
 }
 
-
-static efi_status_t
-check_var_size(struct efivars *efivars, u32 attributes, unsigned long size)
-{
-	efi_status_t status;
-	unsigned long flags;
-
-	spin_lock_irqsave(&efivars->lock, flags);
-	status = check_var_size_locked(efivars, attributes, size);
-	spin_unlock_irqrestore(&efivars->lock, flags);
-
-	return status;
-}
-
 static ssize_t
 efivar_guid_read(struct efivar_entry *entry, char *buf)
 {
@@ -473,13 +405,12 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
 	char *str = buf;
-	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(__efivars, var);
-	if (status != EFI_SUCCESS)
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
 		return -EIO;
 
 	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
@@ -507,13 +438,12 @@ efivar_size_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
 	char *str = buf;
-	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(__efivars, var);
-	if (status != EFI_SUCCESS)
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
 		return -EIO;
 
 	str += sprintf(str, "0x%lx\n", var->DataSize);
@@ -524,13 +454,12 @@ static ssize_t
 efivar_data_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
-	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(__efivars, var);
-	if (status != EFI_SUCCESS)
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
 		return -EIO;
 
 	memcpy(buf, var->Data, var->DataSize);
@@ -544,8 +473,7 @@ static ssize_t
 efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 {
 	struct efi_variable *new_var, *var = &entry->var;
-	struct efivars *efivars = __efivars;
-	efi_status_t status = EFI_NOT_FOUND;
+	int err;
 
 	if (count != sizeof(struct efi_variable))
 		return -EINVAL;
@@ -567,32 +495,20 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	}
 
 	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    validate_var(new_var, new_var->Data, new_var->DataSize) == false) {
+	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
 
-	spin_lock_irq(&efivars->lock);
-
-	status = check_var_size_locked(efivars, new_var->Attributes,
-	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
-
-	if (status == EFI_SUCCESS || status == EFI_UNSUPPORTED)
-		status = efivars->ops->set_variable(new_var->VariableName,
-						    &new_var->VendorGuid,
-						    new_var->Attributes,
-						    new_var->DataSize,
-						    new_var->Data);
-
-	spin_unlock_irq(&efivars->lock);
+	memcpy(&entry->var, new_var, count);
 
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
+	err = efivar_entry_set(entry, new_var->Attributes,
+			       new_var->DataSize, new_var->Data, false);
+	if (err) {
+		printk(KERN_WARNING "efivars: set_variable() failed: status=%d\n", err);
 		return -EIO;
 	}
 
-	memcpy(&entry->var, new_var, count);
 	return count;
 }
 
@@ -600,16 +516,17 @@ static ssize_t
 efivar_show_raw(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
-	efi_status_t status;
 
 	if (!entry || !buf)
 		return 0;
 
-	status = get_var_data(__efivars, var);
-	if (status != EFI_SUCCESS)
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &entry->var.Attributes,
+			     &entry->var.DataSize, entry->var.Data))
 		return -EIO;
 
 	memcpy(buf, var, sizeof(*var));
+
 	return sizeof(*var);
 }
 
@@ -698,6 +615,9 @@ static int efi_status_to_err(efi_status_t status)
 	int err;
 
 	switch (status) {
+	case EFI_SUCCESS:
+		err = 0;
+		break;
 	case EFI_INVALID_PARAMETER:
 		err = -EINVAL;
 		break;
@@ -714,7 +634,7 @@ static int efi_status_to_err(efi_status_t status)
 		err = -EACCES;
 		break;
 	case EFI_NOT_FOUND:
-		err = -EIO;
+		err = -ENOENT;
 		break;
 	default:
 		err = -EINVAL;
@@ -727,14 +647,12 @@ static ssize_t efivarfs_file_write(struct file *file,
 		const char __user *userbuf, size_t count, loff_t *ppos)
 {
 	struct efivar_entry *var = file->private_data;
-	struct efivars *efivars = __efivars;
-	efi_status_t status;
 	void *data;
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
-	unsigned long newdatasize, varsize;
 	ssize_t bytes = 0;
+	bool set = false;
 
 	if (count < sizeof(attributes))
 		return -EINVAL;
@@ -745,23 +663,6 @@ static ssize_t efivarfs_file_write(struct file *file,
 	if (attributes & ~(EFI_VARIABLE_MASK))
 		return -EINVAL;
 
-	/*
-	 * Ensure that the user can't allocate arbitrarily large
-	 * amounts of memory. Pick a default size of 64K if
-	 * QueryVariableInfo() isn't supported by the firmware.
-	 */
-
-	varsize = datasize + utf16_strsize(var->var.VariableName, 1024);
-	status = check_var_size(efivars, attributes, varsize);
-
-	if (status != EFI_SUCCESS) {
-		if (status != EFI_UNSUPPORTED)
-			return efi_status_to_err(status);
-
-		if (datasize > 65536)
-			return -ENOSPC;
-	}
-
 	data = kmalloc(datasize, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -771,76 +672,24 @@ static ssize_t efivarfs_file_write(struct file *file,
 		goto out;
 	}
 
-	if (validate_var(&var->var, data, datasize) == false) {
-		bytes = -EINVAL;
+	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
+					  data, &set);
+	if (!set && bytes)
 		goto out;
-	}
-
-	/*
-	 * The lock here protects the get_variable call, the conditional
-	 * set_variable call, and removal of the variable from the efivars
-	 * list (in the case of an authenticated delete).
-	 */
-	spin_lock_irq(&efivars->lock);
-
-	/*
-	 * Ensure that the available space hasn't shrunk below the safe level
-	 */
-
-	status = check_var_size_locked(efivars, attributes, varsize);
-
-	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
-		spin_unlock_irq(&efivars->lock);
-		kfree(data);
-
-		return efi_status_to_err(status);
-	}
-
-	status = efivars->ops->set_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    attributes, datasize,
-					    data);
-
-	if (status != EFI_SUCCESS) {
-		spin_unlock_irq(&efivars->lock);
-		kfree(data);
-
-		return efi_status_to_err(status);
-	}
-
-	bytes = count;
 
-	/*
-	 * Writing to the variable may have caused a change in size (which
-	 * could either be an append or an overwrite), or the variable to be
-	 * deleted. Perform a GetVariable() so we can tell what actually
-	 * happened.
-	 */
-	newdatasize = 0;
-	status = efivars->ops->get_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    NULL, &newdatasize,
-					    NULL);
-
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		spin_unlock_irq(&efivars->lock);
+	if (!bytes) {
 		mutex_lock(&inode->i_mutex);
-		i_size_write(inode, newdatasize + sizeof(attributes));
+		i_size_write(inode, datasize + sizeof(attributes));
 		mutex_unlock(&inode->i_mutex);
-
-	} else if (status == EFI_NOT_FOUND) {
-		list_del(&var->list);
-		spin_unlock_irq(&efivars->lock);
-		efivar_unregister(var);
+	} else if (bytes == -ENOENT) {
 		drop_nlink(inode);
 		d_delete(file->f_dentry);
 		dput(file->f_dentry);
-
-	} else {
-		spin_unlock_irq(&efivars->lock);
+	} else
 		pr_warn("efivarfs: inconsistent EFI variable implementation? "
-				"status = %lx\n", status);
-	}
+				"status=%zu\n", bytes);
+
+	bytes = count;
 
 out:
 	kfree(data);
@@ -852,38 +701,25 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 		size_t count, loff_t *ppos)
 {
 	struct efivar_entry *var = file->private_data;
-	struct efivars *efivars = __efivars;
-	efi_status_t status;
 	unsigned long datasize = 0;
 	u32 attributes;
 	void *data;
 	ssize_t size = 0;
+	int err;
 
-	spin_lock_irq(&efivars->lock);
-	status = efivars->ops->get_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    &attributes, &datasize, NULL);
-	spin_unlock_irq(&efivars->lock);
-
-	if (status != EFI_BUFFER_TOO_SMALL)
-		return efi_status_to_err(status);
+	err = efivar_entry_size(var, &datasize);
+	if (err)
+		return err;
 
 	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
 
 	if (!data)
 		return -ENOMEM;
 
-	spin_lock_irq(&efivars->lock);
-	status = efivars->ops->get_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    &attributes, &datasize,
-					    (data + sizeof(attributes)));
-	spin_unlock_irq(&efivars->lock);
-
-	if (status != EFI_SUCCESS) {
-		size = efi_status_to_err(status);
+	size = efivar_entry_get(var, &attributes, &datasize,
+				data + sizeof(attributes));
+	if (size)
 		goto out_free;
-	}
 
 	memcpy(data, &attributes, sizeof(attributes));
 	size = simple_read_from_buffer(userbuf, count, ppos,
@@ -947,17 +783,17 @@ static struct inode *efivarfs_get_inode(struct super_block *sb,
  */
 static bool efivarfs_valid_name(const char *str, int len)
 {
-	static const char dashes[GUID_LEN] = {
+	static const char dashes[EFI_VARIABLE_GUID_LEN] = {
 		[8] = 1, [13] = 1, [18] = 1, [23] = 1
 	};
-	const char *s = str + len - GUID_LEN;
+	const char *s = str + len - EFI_VARIABLE_GUID_LEN;
 	int i;
 
 	/*
 	 * We need a GUID, plus at least one letter for the variable name,
 	 * plus the '-' separator
 	 */
-	if (len < GUID_LEN + 2)
+	if (len < EFI_VARIABLE_GUID_LEN + 2)
 		return false;
 
 	/* GUID must be preceded by a '-' */
@@ -969,7 +805,7 @@ static bool efivarfs_valid_name(const char *str, int len)
 	 *
 	 *	12345678-1234-1234-1234-123456789abc
 	 */
-	for (i = 0; i < GUID_LEN; i++) {
+	for (i = 0; i < EFI_VARIABLE_GUID_LEN; i++) {
 		if (dashes[i]) {
 			if (*s++ != '-')
 				return false;
@@ -1006,7 +842,6 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 			  umode_t mode, bool excl)
 {
 	struct inode *inode;
-	struct efivars *efivars = __efivars;
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
 
@@ -1024,7 +859,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* length of the variable name itself: remove GUID and separator */
-	namelen = dentry->d_name.len - GUID_LEN - 1;
+	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
 
 	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
 			&var->var.VendorGuid);
@@ -1035,17 +870,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	var->var.VariableName[i] = '\0';
 
 	inode->i_private = var;
-	var->kobj.kset = efivars->kset;
-
-	err = kobject_init_and_add(&var->kobj, &efivar_ktype, NULL, "%s",
-			     dentry->d_name.name);
-	if (err)
-		goto out;
 
-	kobject_uevent(&var->kobj, KOBJ_ADD);
-	spin_lock_irq(&efivars->lock);
-	list_add(&var->list, &efivars->list);
-	spin_unlock_irq(&efivars->lock);
+	efivar_entry_add(var, &efivarfs_list);
 	d_instantiate(dentry, inode);
 	dget(dentry);
 out:
@@ -1059,26 +885,13 @@ out:
 static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct efivar_entry *var = dentry->d_inode->i_private;
-	struct efivars *efivars = __efivars;
-	efi_status_t status;
-
-	spin_lock_irq(&efivars->lock);
 
-	status = efivars->ops->set_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    0, 0, NULL);
-
-	if (status == EFI_SUCCESS || status == EFI_NOT_FOUND) {
-		list_del(&var->list);
-		spin_unlock_irq(&efivars->lock);
-		efivar_unregister(var);
-		drop_nlink(dentry->d_inode);
-		dput(dentry);
-		return 0;
-	}
+	if (efivar_entry_delete(var))
+		return -EINVAL;
 
-	spin_unlock_irq(&efivars->lock);
-	return -EINVAL;
+	drop_nlink(dentry->d_inode);
+	dput(dentry);
+	return 0;
 };
 
 /*
@@ -1097,7 +910,7 @@ static int efivarfs_d_compare(const struct dentry *parent, const struct inode *p
 			      unsigned int len, const char *str,
 			      const struct qstr *name)
 {
-	int guid = len - GUID_LEN;
+	int guid = len - EFI_VARIABLE_GUID_LEN;
 
 	if (name->len != len)
 		return 1;
@@ -1107,7 +920,7 @@ static int efivarfs_d_compare(const struct dentry *parent, const struct inode *p
 		return 1;
 
 	/* Case-insensitive compare for the GUID */
-	return strncasecmp(name->name + guid, str + guid, GUID_LEN);
+	return strncasecmp(name->name + guid, str + guid, EFI_VARIABLE_GUID_LEN);
 }
 
 static int efivarfs_d_hash(const struct dentry *dentry,
@@ -1120,7 +933,7 @@ static int efivarfs_d_hash(const struct dentry *dentry,
 	if (!efivarfs_valid_name(s, len))
 		return -EINVAL;
 
-	while (len-- > GUID_LEN)
+	while (len-- > EFI_VARIABLE_GUID_LEN)
 		hash = partial_name_hash(*s++, hash);
 
 	/* GUID is case-insensitive. */
@@ -1166,15 +979,87 @@ static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
 	return ERR_PTR(-ENOMEM);
 }
 
-static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
+static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
+			     unsigned long name_size, void *data)
 {
+	struct super_block *sb = (struct super_block *)data;
+	struct efivar_entry *entry;
 	struct inode *inode = NULL;
-	struct dentry *root;
-	struct efivar_entry *entry, *n;
-	struct efivars *efivars = __efivars;
+	struct dentry *dentry, *root = sb->s_root;
+	unsigned long size = 0;
 	char *name;
+	int len, i;
 	int err = -ENOMEM;
 
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return err;
+
+	memcpy(entry->var.VariableName, name16, name_size);
+	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
+
+	len = utf16_strlen(entry->var.VariableName);
+
+	/* name, plus '-', plus GUID, plus NUL*/
+	name = kmalloc(len + 1 + EFI_VARIABLE_GUID_LEN + 1, GFP_KERNEL);
+	if (!name)
+		goto fail;
+
+	for (i = 0; i < len; i++)
+		name[i] = entry->var.VariableName[i] & 0xFF;
+
+	name[len] = '-';
+
+	efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
+
+	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
+
+	inode = efivarfs_get_inode(sb, root->d_inode, S_IFREG | 0644, 0);
+	if (!inode)
+		goto fail_name;
+
+	dentry = efivarfs_alloc_dentry(root, name);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
+		goto fail_inode;
+	}
+
+	/* copied by the above to local storage in the dentry. */
+	kfree(name);
+
+	efivar_entry_size(entry, &size);
+	efivar_entry_add(entry, &efivarfs_list);
+
+	mutex_lock(&inode->i_mutex);
+	inode->i_private = entry;
+	i_size_write(inode, size + sizeof(entry->var.Attributes));
+	mutex_unlock(&inode->i_mutex);
+	d_add(dentry, inode);
+
+	return 0;
+
+fail_inode:
+	iput(inode);
+fail_name:
+	kfree(name);
+fail:
+	kfree(entry);
+	return err;
+}
+
+static int efivarfs_destroy(struct efivar_entry *entry, void *data)
+{
+	efivar_entry_remove(entry);
+	kfree(entry);
+	return 0;
+}
+
+static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct inode *inode = NULL;
+	struct dentry *root;
+	int err;
+
 	efivarfs_sb = sb;
 
 	sb->s_maxbytes          = MAX_LFS_FILESIZE;
@@ -1195,65 +1080,12 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root)
 		return -ENOMEM;
 
-	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		struct dentry *dentry, *root = efivarfs_sb->s_root;
-		unsigned long size = 0;
-		int len, i;
-
-		inode = NULL;
-
-		len = utf16_strlen(entry->var.VariableName);
-
-		/* name, plus '-', plus GUID, plus NUL*/
-		name = kmalloc(len + 1 + GUID_LEN + 1, GFP_ATOMIC);
-		if (!name)
-			goto fail;
-
-		for (i = 0; i < len; i++)
-			name[i] = entry->var.VariableName[i] & 0xFF;
-
-		name[len] = '-';
-
-		efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
-
-		name[len+GUID_LEN+1] = '\0';
-
-		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
-					  S_IFREG | 0644, 0);
-		if (!inode)
-			goto fail_name;
-
-		dentry = efivarfs_alloc_dentry(root, name);
-		if (IS_ERR(dentry)) {
-			err = PTR_ERR(dentry);
-			goto fail_inode;
-		}
-
-		/* copied by the above to local storage in the dentry. */
-		kfree(name);
-
-		spin_lock_irq(&efivars->lock);
-		efivars->ops->get_variable(entry->var.VariableName,
-					   &entry->var.VendorGuid,
-					   &entry->var.Attributes,
-					   &size,
-					   NULL);
-		spin_unlock_irq(&efivars->lock);
-
-		mutex_lock(&inode->i_mutex);
-		inode->i_private = entry;
-		i_size_write(inode, size + sizeof(entry->var.Attributes));
-		mutex_unlock(&inode->i_mutex);
-		d_add(dentry, inode);
-	}
+	INIT_LIST_HEAD(&efivarfs_list);
 
-	return 0;
+	err = efivar_init(efivarfs_callback, (void *)sb, false, &efivarfs_list);
+	if (err)
+		__efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL, NULL);
 
-fail_inode:
-	iput(inode);
-fail_name:
-	kfree(name);
-fail:
 	return err;
 }
 
@@ -1267,6 +1099,9 @@ static void efivarfs_kill_sb(struct super_block *sb)
 {
 	kill_litter_super(sb);
 	efivarfs_sb = NULL;
+
+	/* Remove all entries and destroy */
+	__efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL, NULL);
 }
 
 static struct file_system_type efivarfs_type = {
@@ -1298,80 +1133,84 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
-	struct efivars *efivars = __efivars;
-
-	spin_lock_irq(&efivars->lock);
-	efivars->walk_entry = list_first_entry(&efivars->list,
-					       struct efivar_entry, list);
+	efivar_entry_iter_begin();
+	psi->data = NULL;
 	return 0;
 }
 
 static int efi_pstore_close(struct pstore_info *psi)
 {
-	struct efivars *efivars = __efivars;
-
-	spin_unlock_irq(&efivars->lock);
+	efivar_entry_iter_end();
+	psi->data = NULL;
 	return 0;
 }
 
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       int *count, struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
+struct pstore_read_data {
+	u64 *id;
+	enum pstore_type_id *type;
+	int *count;
+	struct timespec *timespec;
+	char **buf;
+};
+
+static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = __efivars;
+	struct pstore_read_data *cb_data = data;
 	char name[DUMP_NAME_LEN];
 	int i;
 	int cnt;
-	unsigned int part, size;
-	unsigned long time;
-
-	while (&efivars->walk_entry->list != &efivars->list) {
-		if (!efi_guidcmp(efivars->walk_entry->var.VendorGuid,
-				 vendor)) {
-			for (i = 0; i < DUMP_NAME_LEN; i++) {
-				name[i] = efivars->walk_entry->var.VariableName[i];
-			}
-			if (sscanf(name, "dump-type%u-%u-%d-%lu",
-				   type, &part, &cnt, &time) == 4) {
-				*id = part;
-				*count = cnt;
-				timespec->tv_sec = time;
-				timespec->tv_nsec = 0;
-			} else if (sscanf(name, "dump-type%u-%u-%lu",
-				   type, &part, &time) == 3) {
-				/*
-				 * Check if an old format,
-				 * which doesn't support holding
-				 * multiple logs, remains.
-				 */
-				*id = part;
-				*count = 0;
-				timespec->tv_sec = time;
-				timespec->tv_nsec = 0;
-			} else {
-				efivars->walk_entry = list_entry(
-						efivars->walk_entry->list.next,
-						struct efivar_entry, list);
-				continue;
-			}
+	unsigned int part;
+	unsigned long time, size;
 
-			get_var_data_locked(efivars, &efivars->walk_entry->var);
-			size = efivars->walk_entry->var.DataSize;
-			*buf = kmalloc(size, GFP_KERNEL);
-			if (*buf == NULL)
-				return -ENOMEM;
-			memcpy(*buf, efivars->walk_entry->var.Data,
-			       size);
-			efivars->walk_entry = list_entry(
-					efivars->walk_entry->list.next,
-					struct efivar_entry, list);
-			return size;
-		}
-		efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
-						 struct efivar_entry, list);
-	}
-	return 0;
+	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		return 0;
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		name[i] = entry->var.VariableName[i];
+
+	if (sscanf(name, "dump-type%u-%u-%d-%lu",
+		   cb_data->type, &part, &cnt, &time) == 4) {
+		*cb_data->id = part;
+		*cb_data->count = cnt;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+	} else if (sscanf(name, "dump-type%u-%u-%lu",
+			  cb_data->type, &part, &time) == 3) {
+		/*
+		 * Check if an old format,
+		 * which doesn't support holding
+		 * multiple logs, remains.
+		 */
+		*cb_data->id = part;
+		*cb_data->count = 0;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+	} else
+		return 0;
+
+	efivar_entry_size(entry, &size);
+	*cb_data->buf = kmalloc(size, GFP_KERNEL);
+	if (*cb_data->buf == NULL)
+		return -ENOMEM;
+	memcpy(*cb_data->buf, entry->var.Data, size);
+	return size;
+}
+
+static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
+			       int *count, struct timespec *timespec,
+			       char **buf, struct pstore_info *psi)
+{
+	struct pstore_read_data data;
+
+	data.id = id;
+	data.type = type;
+	data.count = count;
+	data.timespec = timespec;
+	data.buf = buf;
+
+	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
+				   (struct efivar_entry **)&psi->data);
 }
 
 static int efi_pstore_write(enum pstore_type_id type,
@@ -1382,36 +1221,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = __efivars;
 	int i, ret = 0;
-	efi_status_t status = EFI_NOT_FOUND;
-	unsigned long flags;
-
-	if (pstore_cannot_block_path(reason)) {
-		/*
-		 * If the lock is taken by another cpu in non-blocking path,
-		 * this driver returns without entering firmware to avoid
-		 * hanging up.
-		 */
-		if (!spin_trylock_irqsave(&efivars->lock, flags))
-			return -EBUSY;
-	} else
-		spin_lock_irqsave(&efivars->lock, flags);
-
-	/*
-	 * Check if there is a space enough to log.
-	 * size: a size of logging data
-	 * DUMP_NAME_LEN * 2: a maximum size of variable name
-	 */
-
-	status = check_var_size_locked(efivars, PSTORE_EFI_ATTRIBUTES,
-					 size + DUMP_NAME_LEN * 2);
-
-	if (status) {
-		spin_unlock_irqrestore(&efivars->lock, flags);
-		*id = part;
-		return -ENOSPC;
-	}
 
 	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
 		get_seconds());
@@ -1419,81 +1229,90 @@ static int efi_pstore_write(enum pstore_type_id type,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
-				   size, psi->buf);
+	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
+				    !pstore_cannot_block_path(reason),
+				    size, psi->buf);
 
-	spin_unlock_irqrestore(&efivars->lock, flags);
-
-	if (reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
+	if (size && !ret && reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
 		schedule_work(&efivar_work);
 
 	*id = part;
 	return ret;
 };
 
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
+struct pstore_erase_data {
+	u64 id;
+	enum pstore_type_id type;
+	int count;
+	struct timespec time;
+	efi_char16_t *name;
+};
+
+/*
+ * Clean up an entry with the same name
+ */
+static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 {
-	char name[DUMP_NAME_LEN];
-	efi_char16_t efi_name[DUMP_NAME_LEN];
-	char name_old[DUMP_NAME_LEN];
-	efi_char16_t efi_name_old[DUMP_NAME_LEN];
+	struct pstore_erase_data *ed = data;
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = __efivars;
-	struct efivar_entry *entry, *found = NULL;
+	efi_char16_t efi_name_old[DUMP_NAME_LEN];
+	efi_char16_t *efi_name = ed->name;
+	unsigned long utf16_len = utf16_strlen(ed->name);
+	char name_old[DUMP_NAME_LEN];
 	int i;
 
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
-		time.tv_sec);
+	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		return 0;
 
-	spin_lock_irq(&efivars->lock);
+	if (utf16_strncmp(entry->var.VariableName,
+			  efi_name, (size_t)utf16_len)) {
+		/*
+		 * Check if an old format, which doesn't support
+		 * holding multiple logs, remains.
+		 */
+		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
+			(unsigned int)ed->id, ed->time.tv_sec);
 
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = name[i];
+		for (i = 0; i < DUMP_NAME_LEN; i++)
+			efi_name_old[i] = name_old[i];
 
-	/*
-	 * Clean up an entry with the same name
-	 */
+		if (utf16_strncmp(entry->var.VariableName, efi_name_old,
+				  utf16_strlen(efi_name_old)))
+			return 0;
+	}
 
-	list_for_each_entry(entry, &efivars->list, list) {
-		get_var_data_locked(efivars, &entry->var);
-
-		if (efi_guidcmp(entry->var.VendorGuid, vendor))
-			continue;
-		if (utf16_strncmp(entry->var.VariableName, efi_name,
-				  utf16_strlen(efi_name))) {
-			/*
-			 * Check if an old format,
-			 * which doesn't support holding
-			 * multiple logs, remains.
-			 */
-			sprintf(name_old, "dump-type%u-%u-%lu", type,
-				(unsigned int)id, time.tv_sec);
+	/* found */
+	__efivar_entry_delete(entry);
+	return 1;
+}
 
-			for (i = 0; i < DUMP_NAME_LEN; i++)
-				efi_name_old[i] = name_old[i];
+static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
+			    struct timespec time, struct pstore_info *psi)
+{
+	struct pstore_erase_data edata;
+	struct efivar_entry *entry;
+	char name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	int found, i;
 
-			if (utf16_strncmp(entry->var.VariableName, efi_name_old,
-					  utf16_strlen(efi_name_old)))
-				continue;
-		}
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
+		time.tv_sec);
 
-		/* found */
-		found = entry;
-		efivars->ops->set_variable(entry->var.VariableName,
-					   &entry->var.VendorGuid,
-					   PSTORE_EFI_ATTRIBUTES,
-					   0, NULL);
-		break;
-	}
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = name[i];
 
-	if (found)
-		list_del(&found->list);
+	edata.id = id;
+	edata.type = type;
+	edata.count = count;
+	edata.time = time;
+	edata.name = efi_name;
 
-	spin_unlock_irq(&efivars->lock);
+	efivar_entry_iter_begin();
+	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
+	efivar_entry_iter_end();
 
 	if (found)
-		efivar_unregister(found);
+		efivar_unregister(entry);
 
 	return 0;
 }
@@ -1508,19 +1327,17 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
-static void efivar_pstore_register(struct efivars *efivars)
+static void efivar_pstore_register(void)
 {
-	efivars->efi_pstore_info = efi_pstore_info;
-	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efivars->efi_pstore_info.buf) {
-		efivars->efi_pstore_info.bufsize = 1024;
-		efivars->efi_pstore_info.data = efivars;
-		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
-		pstore_register(&efivars->efi_pstore_info);
+	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (efi_pstore_info.buf) {
+		efi_pstore_info.bufsize = 1024;
+		spin_lock_init(&efi_pstore_info.buf_lock);
+		pstore_register(&efi_pstore_info);
 	}
 }
 #else
-static void efivar_pstore_register(struct efivars *efivars)
+static void efivar_pstore_register(void)
 {
 	return;
 }
@@ -1531,76 +1348,41 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
-	struct efivars *efivars = __efivars;
-	struct efivar_entry *search_efivar, *n;
-	unsigned long strsize1, strsize2;
-	efi_status_t status = EFI_NOT_FOUND;
-	int found = 0;
+	struct efivar_entry *new_entry;
+	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    validate_var(new_var, new_var->Data, new_var->DataSize) == false) {
+	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
 
-	spin_lock_irq(&efivars->lock);
-
-	/*
-	 * Does this variable already exist?
-	 */
-	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(new_var->VariableName, 1024);
-		if (strsize1 == strsize2 &&
-			!memcmp(&(search_efivar->var.VariableName),
-				new_var->VariableName, strsize1) &&
-			!efi_guidcmp(search_efivar->var.VendorGuid,
-				new_var->VendorGuid)) {
-			found = 1;
-			break;
-		}
-	}
-	if (found) {
-		spin_unlock_irq(&efivars->lock);
-		return -EINVAL;
-	}
+	new_entry = kzalloc(sizeof(*new_entry), GFP_KERNEL);
+	if (!new_entry)
+		return -ENOMEM;
 
-	status = check_var_size_locked(efivars, new_var->Attributes,
-	       new_var->DataSize + utf16_strsize(new_var->VariableName, 1024));
+	memcpy(&new_entry->var, new_var, sizeof(*new_var));
 
-	if (status && status != EFI_UNSUPPORTED) {
-		spin_unlock_irq(&efivars->lock);
-		return efi_status_to_err(status);
+	err = efivar_entry_set(new_entry, new_var->Attributes, new_var->DataSize,
+			       new_var->Data, &efivar_sysfs_list);
+	if (err) {
+		if (err == -EEXIST)
+			err = -EINVAL;
+		goto out;
 	}
 
-	/* now *really* create the variable via EFI */
-	status = efivars->ops->set_variable(new_var->VariableName,
-					    &new_var->VendorGuid,
-					    new_var->Attributes,
-					    new_var->DataSize,
-					    new_var->Data);
-
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
-		spin_unlock_irq(&efivars->lock);
-		return -EIO;
-	}
-	spin_unlock_irq(&efivars->lock);
-
-	/* Create the entry in sysfs.  Locking is not required here */
-	status = efivar_create_sysfs_entry(efivars,
-					   utf16_strsize(new_var->VariableName,
-							 1024),
-					   new_var->VariableName,
-					   &new_var->VendorGuid);
-	if (status) {
-		printk(KERN_WARNING "efivars: variable created, but sysfs entry wasn't.\n");
+	if (efivar_create_sysfs_entry(new_entry)) {
+		printk(KERN_WARNING "efivars: failed to create sysfs entry.\n");
+		kfree(new_entry);
 	}
 	return count;
+
+out:
+	kfree(new_entry);
+	return err;
 }
 
 static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
@@ -1608,70 +1390,40 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
-	struct efivars *efivars = __efivars;
-	struct efivar_entry *search_efivar, *n;
-	unsigned long strsize1, strsize2;
-	efi_status_t status = EFI_NOT_FOUND;
-	int found = 0;
+	struct efivar_entry *entry;
+	int err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock_irq(&efivars->lock);
+	efivar_entry_iter_begin();
+	entry = efivar_entry_find(del_var->VariableName, del_var->VendorGuid,
+				  &efivar_sysfs_list, true);
+	if (!entry)
+		err = -EINVAL;
+	else if (__efivar_entry_delete(entry))
+		err = -EIO;
 
-	/*
-	 * Does this variable already exist?
-	 */
-	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(del_var->VariableName, 1024);
-		if (strsize1 == strsize2 &&
-			!memcmp(&(search_efivar->var.VariableName),
-				del_var->VariableName, strsize1) &&
-			!efi_guidcmp(search_efivar->var.VendorGuid,
-				del_var->VendorGuid)) {
-			found = 1;
-			break;
-		}
-	}
-	if (!found) {
-		spin_unlock_irq(&efivars->lock);
-		return -EINVAL;
-	}
-	/* force the Attributes/DataSize to 0 to ensure deletion */
-	del_var->Attributes = 0;
-	del_var->DataSize = 0;
+	efivar_entry_iter_end();
 
-	status = efivars->ops->set_variable(del_var->VariableName,
-					    &del_var->VendorGuid,
-					    del_var->Attributes,
-					    del_var->DataSize,
-					    del_var->Data);
+	if (err)
+		return err;
 
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
-		spin_unlock_irq(&efivars->lock);
-		return -EIO;
-	}
-	list_del(&search_efivar->list);
-	/* We need to release this lock before unregistering. */
-	spin_unlock_irq(&efivars->lock);
-	efivar_unregister(search_efivar);
+	efivar_unregister(entry);
 
 	/* It's dead Jim.... */
 	return count;
 }
 
-static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
+static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor,
+				struct list_head *head)
 {
 	struct efivar_entry *entry, *n;
-	struct efivars *efivars = __efivars;
 	unsigned long strsize1, strsize2;
 	bool found = false;
 
 	strsize1 = utf16_strsize(variable_name, 1024);
-	list_for_each_entry_safe(entry, n, &efivars->list, list) {
+	list_for_each_entry_safe(entry, n, head, list) {
 		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(variable_name, &(entry->var.VariableName),
@@ -1685,6 +1437,20 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
 	return found;
 }
 
+static int efivar_update_sysfs_entry(efi_char16_t *name, efi_guid_t vendor,
+				     unsigned long name_size, void *data)
+{
+	struct efivar_entry *entry = data;
+
+	if (efivar_entry_find(name, vendor, &efivar_sysfs_list, false))
+		return 0;
+
+	memcpy(entry->var.VariableName, name, name_size);
+	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
+
+	return 1;
+}
+
 /*
  * Returns the size of variable_name, in bytes, including the
  * terminating NULL character, or variable_name_size if no NULL
@@ -1712,52 +1478,25 @@ static unsigned long var_name_strnsize(efi_char16_t *variable_name,
 
 static void efivar_update_sysfs_entries(struct work_struct *work)
 {
-	struct efivars *efivars = __efivars;
-	efi_guid_t vendor;
-	efi_char16_t *variable_name;
-	unsigned long variable_name_size = 1024;
-	efi_status_t status = EFI_NOT_FOUND;
-	bool found;
+	struct efivar_entry *entry;
+	int err;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
 
 	/* Add new sysfs entries */
 	while (1) {
-		variable_name = kzalloc(variable_name_size, GFP_KERNEL);
-		if (!variable_name) {
-			pr_err("efivars: Memory allocation failed.\n");
-			return;
-		}
+		memset(entry, 0, sizeof(*entry));
 
-		spin_lock_irq(&efivars->lock);
-		found = false;
-		while (1) {
-			variable_name_size = 1024;
-			status = efivars->ops->get_next_variable(
-							&variable_name_size,
-							variable_name,
-							&vendor);
-			if (status != EFI_SUCCESS) {
-				break;
-			} else {
-				if (!variable_is_present(variable_name,
-				    &vendor)) {
-					found = true;
-					break;
-				}
-			}
-		}
-		spin_unlock_irq(&efivars->lock);
-
-		if (!found) {
-			kfree(variable_name);
+		err = efivar_init(efivar_update_sysfs_entry, entry, true, &efivar_sysfs_list);
+		if (!err)
 			break;
-		} else {
-			variable_name_size = var_name_strnsize(variable_name,
-							       variable_name_size);
-			efivar_create_sysfs_entry(efivars,
-						  variable_name_size,
-						  variable_name, &vendor);
-		}
+
+		efivar_create_sysfs_entry(entry);
 	}
+
+	kfree(entry);
 }
 
 /*
@@ -1804,45 +1543,37 @@ static struct attribute_group efi_subsys_attr_group = {
 
 static struct kobject *efi_kobj;
 
-/*
- * efivar_create_sysfs_entry()
- * Requires:
- *    variable_name_size = number of bytes required to hold
- *                         variable_name (not counting the NULL
- *                         character at the end.
- *    efivars->lock is not held on entry or exit.
+/**
+ * efivar_create_sysfs_entry - create a new entry in sysfs
+ * @new_var: efivar entry to create
+ *
  * Returns 1 on failure, 0 on success
  */
 static int
-efivar_create_sysfs_entry(struct efivars *efivars,
-			  unsigned long variable_name_size,
-			  efi_char16_t *variable_name,
-			  efi_guid_t *vendor_guid)
+efivar_create_sysfs_entry(struct efivar_entry *new_var)
 {
 	int i, short_name_size;
 	char *short_name;
-	struct efivar_entry *new_efivar;
+	unsigned long variable_name_size;
+	efi_char16_t *variable_name;
+
+	variable_name = new_var->var.VariableName;
+	variable_name_size = utf16_strlen(variable_name) * sizeof(efi_char16_t);
 
 	/*
 	 * Length of the variable bytes in ASCII, plus the '-' separator,
 	 * plus the GUID, plus trailing NUL
 	 */
 	short_name_size = variable_name_size / sizeof(efi_char16_t)
-				+ 1 + GUID_LEN + 1;
+				+ 1 + EFI_VARIABLE_GUID_LEN + 1;
 
 	short_name = kzalloc(short_name_size, GFP_KERNEL);
-	new_efivar = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
 
-	if (!short_name || !new_efivar)  {
+	if (!short_name) {
 		kfree(short_name);
-		kfree(new_efivar);
 		return 1;
 	}
 
-	memcpy(new_efivar->var.VariableName, variable_name,
-		variable_name_size);
-	memcpy(&(new_efivar->var.VendorGuid), vendor_guid, sizeof(efi_guid_t));
-
 	/* Convert Unicode to normal chars (assume top bits are 0),
 	   ala UTF-8 */
 	for (i=0; i < (int)(variable_name_size / sizeof(efi_char16_t)); i++) {
@@ -1852,30 +1583,25 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	   private variables from another's.         */
 
 	*(short_name + strlen(short_name)) = '-';
-	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
+	efi_guid_unparse(&new_var->var.VendorGuid,
+			 short_name + strlen(short_name));
 
-	new_efivar->kobj.kset = efivars->kset;
-	i = kobject_init_and_add(&new_efivar->kobj, &efivar_ktype, NULL,
-				 "%s", short_name);
-	if (i) {
-		kfree(short_name);
-		kfree(new_efivar);
-		return 1;
-	}
+	new_var->kobj.kset = efivars_kset;
 
-	kobject_uevent(&new_efivar->kobj, KOBJ_ADD);
+	i = kobject_init_and_add(&new_var->kobj, &efivar_ktype,
+				   NULL, "%s", short_name);
 	kfree(short_name);
-	short_name = NULL;
+	if (i)
+		return 1;
 
-	spin_lock_irq(&efivars->lock);
-	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock_irq(&efivars->lock);
+	kobject_uevent(&new_var->kobj, KOBJ_ADD);
+	efivar_entry_add(new_var, &efivar_sysfs_list);
 
 	return 0;
 }
 
 static int
-create_efivars_bin_attributes(struct efivars *efivars)
+create_efivars_bin_attributes(void)
 {
 	struct bin_attribute *attr;
 	int error;
@@ -1888,8 +1614,7 @@ create_efivars_bin_attributes(struct efivars *efivars)
 	attr->attr.name = "new_var";
 	attr->attr.mode = 0200;
 	attr->write = efivar_create;
-	attr->private = efivars;
-	efivars->new_var = attr;
+	efivars_new_var = attr;
 
 	/* del_var */
 	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
@@ -1900,61 +1625,59 @@ create_efivars_bin_attributes(struct efivars *efivars)
 	attr->attr.name = "del_var";
 	attr->attr.mode = 0200;
 	attr->write = efivar_delete;
-	attr->private = efivars;
-	efivars->del_var = attr;
+	efivars_del_var = attr;
 
-	sysfs_bin_attr_init(efivars->new_var);
-	sysfs_bin_attr_init(efivars->del_var);
+	sysfs_bin_attr_init(efivars_new_var);
+	sysfs_bin_attr_init(efivars_del_var);
 
 	/* Register */
-	error = sysfs_create_bin_file(&efivars->kset->kobj,
-				      efivars->new_var);
+	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_new_var);
 	if (error) {
 		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
 			" due to error %d\n", error);
 		goto out_free;
 	}
-	error = sysfs_create_bin_file(&efivars->kset->kobj,
-				      efivars->del_var);
+
+	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_del_var);
 	if (error) {
 		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
 			" due to error %d\n", error);
-		sysfs_remove_bin_file(&efivars->kset->kobj,
-				      efivars->new_var);
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
 		goto out_free;
 	}
 
 	return 0;
 out_free:
-	kfree(efivars->del_var);
-	efivars->del_var = NULL;
-	kfree(efivars->new_var);
-	efivars->new_var = NULL;
+	kfree(efivars_del_var);
+	efivars_del_var = NULL;
+	kfree(efivars_new_var);
+	efivars_new_var = NULL;
 	return error;
 }
 
-void unregister_efivars(struct efivars *efivars)
+static int efivars_sysfs_callback(efi_char16_t *name, efi_guid_t vendor,
+				  unsigned long name_size, void *data)
 {
-	struct efivar_entry *entry, *n;
+	struct efivar_entry *entry;
 
-	__efivars = NULL;
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
 
-	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		spin_lock_irq(&efivars->lock);
-		list_del(&entry->list);
-		spin_unlock_irq(&efivars->lock);
-		efivar_unregister(entry);
-	}
-	if (efivars->new_var)
-		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->new_var);
-	if (efivars->del_var)
-		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
-	kfree(efivars->new_var);
-	kfree(efivars->del_var);
-	kobject_put(efivars->kobject);
-	kset_unregister(efivars->kset);
+	memcpy(entry->var.VariableName, name, name_size);
+	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
+
+	efivar_create_sysfs_entry(entry);
+
+	return 0;
+}
+
+static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
+{
+	efivar_entry_remove(entry);
+	efivar_unregister(entry);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(unregister_efivars);
 
 /*
  * Print a warning when duplicate EFI variables are encountered and
@@ -1985,43 +1708,88 @@ static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
 	kfree(s8);
 }
 
-int register_efivars(struct efivars *efivars,
-		     const struct efivar_operations *ops,
-		     struct kobject *parent_kobj)
+static struct kobject *efivars_kobj;
+
+void efivars_sysfs_exit(void)
 {
-	efi_status_t status = EFI_NOT_FOUND;
-	efi_guid_t vendor_guid;
-	efi_char16_t *variable_name;
-	unsigned long variable_name_size = 1024;
-	int error = 0;
+	/* Remove all entries and destroy */
+	__efivar_entry_iter(efivar_sysfs_destroy, &efivar_sysfs_list, NULL, NULL);
 
-	__efivars = efivars;
+	if (efivars_new_var)
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
+	if (efivars_del_var)
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_del_var);
+	kfree(efivars_new_var);
+	kfree(efivars_del_var);
+	kobject_put(efivars_kobj);
+	kset_unregister(efivars_kset);
+}
 
-	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
-	if (!variable_name) {
-		printk(KERN_ERR "efivars: Memory allocation failed.\n");
-		return -ENOMEM;
-	}
+int efivars_sysfs_init(void)
+{
+	struct kobject *parent_kobj = efivars_kobject();
+	int error = 0;
 
-	spin_lock_init(&efivars->lock);
-	INIT_LIST_HEAD(&efivars->list);
-	efivars->ops = ops;
+	/* No efivars has been registered yet */
+	if (!parent_kobj)
+		return 0;
 
-	efivars->kset = kset_create_and_add("vars", NULL, parent_kobj);
-	if (!efivars->kset) {
+	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
+	       EFIVARS_DATE);
+
+	efivars_kset = kset_create_and_add("vars", NULL, parent_kobj);
+	if (!efivars_kset) {
 		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
-		error = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
-	efivars->kobject = kobject_create_and_add("efivars", parent_kobj);
-	if (!efivars->kobject) {
+	efivars_kobj = kobject_create_and_add("efivars", parent_kobj);
+	if (!efivars_kobj) {
 		pr_err("efivars: Subsystem registration failed.\n");
-		error = -ENOMEM;
-		kset_unregister(efivars->kset);
-		goto out;
+		kset_unregister(efivars_kset);
+		return -ENOMEM;
 	}
 
+	efivar_init(efivars_sysfs_callback, NULL, false, &efivar_sysfs_list);
+
+	error = create_efivars_bin_attributes();
+	if (error)
+		efivars_sysfs_exit();
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(efivars_sysfs_init);
+
+/**
+ * efivar_init - build the initial list of EFI variables
+ * @func: callback function to invoke for every variable
+ * @data: function-specific data to pass to @func
+ * @atomic: do we need to execute the @func-loop atomically?
+ * @head: initialised head of variable list
+ *
+ * Get every EFI variable from the firmware and invoke @func. @func
+ * should call efivar_entry_add() to build the list of variables.
+ *
+ * Returns 0 on success, or a kernel error code on failure.
+ */
+int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
+		void *data, bool atomic, struct list_head *head)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	unsigned long variable_name_size = 1024;
+	efi_char16_t *variable_name;
+	efi_status_t status;
+	efi_guid_t vendor_guid;
+	int err = 0;
+
+	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
+	if (!variable_name) {
+		printk(KERN_ERR "efivars: Memory allocation failed.\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_irq(&__efivars->lock);
+
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
 	 * the variable name and variable data is 1024 bytes.
@@ -2035,6 +1803,9 @@ int register_efivars(struct efivars *efivars,
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
+			if (!atomic)
+				spin_unlock_irq(&__efivars->lock);
+
 			variable_name_size = var_name_strnsize(variable_name,
 							       variable_name_size);
 
@@ -2046,17 +1817,23 @@ int register_efivars(struct efivars *efivars,
 			 * we'll ever see a different variable name,
 			 * and may end up looping here forever.
 			 */
-			if (variable_is_present(variable_name, &vendor_guid)) {
+			if (variable_is_present(variable_name, &vendor_guid, head)) {
 				dup_variable_bug(variable_name, &vendor_guid,
 						 variable_name_size);
+				if (!atomic)
+					spin_lock_irq(&__efivars->lock);
+
 				status = EFI_NOT_FOUND;
 				break;
 			}
 
-			efivar_create_sysfs_entry(efivars,
-						  variable_name_size,
-						  variable_name,
-						  &vendor_guid);
+			err = func(variable_name, vendor_guid, variable_name_size, data);
+			if (err)
+				status = EFI_NOT_FOUND;
+
+			if (!atomic)
+				spin_lock_irq(&__efivars->lock);
+
 			break;
 		case EFI_NOT_FOUND:
 			break;
@@ -2066,23 +1843,583 @@ int register_efivars(struct efivars *efivars,
 			status = EFI_NOT_FOUND;
 			break;
 		}
+
 	} while (status != EFI_NOT_FOUND);
 
-	error = create_efivars_bin_attributes(efivars);
-	if (error)
-		unregister_efivars(efivars);
+	spin_unlock_irq(&__efivars->lock);
+
+	kfree(variable_name);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(efivar_init);
+
+/**
+ * efivar_entry_add - add entry to variable list
+ * @entry: entry to add to list
+ * @head: list head
+ */
+void efivar_entry_add(struct efivar_entry *entry, struct list_head *head)
+{
+	spin_lock_irq(&__efivars->lock);
+	list_add(&entry->list, head);
+	spin_unlock_irq(&__efivars->lock);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_add);
+
+/**
+ * efivar_entry_remove - remove entry from variable list
+ * @entry: entry to remove from list
+ */
+void efivar_entry_remove(struct efivar_entry *entry)
+{
+	spin_lock_irq(&__efivars->lock);
+	list_del(&entry->list);
+	spin_unlock_irq(&__efivars->lock);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_remove);
+
+/*
+ * efivar_entry_list_del_unlock - remove entry from variable list
+ * @entry: entry to remove
+ *
+ * Remove @entry from the variable list and release the list lock.
+ *
+ * NOTE: slightly weird locking semantics here - we expect to be
+ * called with the efivars lock already held, and we release it before
+ * returning. This is because this function is usually called after
+ * set_variable() while the lock is still held.
+ */
+static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
+{
+	WARN_ON(!spin_is_locked(&__efivars->lock));
+
+	list_del(&entry->list);
+	spin_unlock_irq(&__efivars->lock);
+}
+
+/**
+ * __efivar_entry_delete - delete an EFI variable
+ * @entry: entry containing EFI variable to delete
+ *
+ * Delete the variable from the firmware and remove @entry from the
+ * variable list. It is the caller's responsibility to free @entry
+ * once we return.
+ *
+ * This function differs from efivar_entry_delete() because it is
+ * safe to be called from within a efivar_entry_iter_begin() and
+ * efivar_entry_iter_end() region, unlike efivar_entry_delete().
+ *
+ * Returns 0 on success, or a converted EFI status code if
+ * set_variable() fails. If set_variable() fails the entry remains
+ * on the list.
+ */
+int __efivar_entry_delete(struct efivar_entry *entry)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	WARN_ON(!spin_is_locked(&__efivars->lock));
+
+	status = ops->set_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   0, 0, NULL);
+	if (status)
+		return efi_status_to_err(status);
+
+	list_del(&entry->list);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__efivar_entry_delete);
+
+/**
+ * efivar_entry_delete - delete variable and remove entry from list
+ * @entry: entry containing variable to delete
+ *
+ * Delete the variable from the firmware and remove @entry from the
+ * variable list. It is the caller's responsibility to free @entry
+ * once we return.
+ *
+ * Returns 0 on success, or a converted EFI status code if
+ * set_variable() fails.
+ */
+int efivar_entry_delete(struct efivar_entry *entry)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	spin_lock_irq(&__efivars->lock);
+	status = ops->set_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   0, 0, NULL);
+	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND)) {
+		spin_unlock_irq(&__efivars->lock);
+		return efi_status_to_err(status);
+	}
+
+	efivar_entry_list_del_unlock(entry);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivar_entry_delete);
+
+/**
+ * efivar_entry_set - call set_variable()
+ * @entry: entry containing the EFI variable to write
+ * @attributes: variable attributes
+ * @size: size of @data buffer
+ * @data: buffer containing variable data
+ * @head: head of variable list
+ *
+ * Calls set_variable() for an EFI variable. If creating a new EFI
+ * variable, this function is usually followed by efivar_entry_add().
+ *
+ * Before writing the variable, the remaining EFI variable storage
+ * space is checked to ensure there is enough room available.
+ *
+ * If @head is not NULL a lookup is performed to determine whether
+ * the entry is already on the list.
+ *
+ * Returns 0 on success, -EEXIST if a lookup is performed and the entry
+ * already exists on the list, or a converted EFI status code if
+ * set_variable() fails.
+ */
+int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
+		     unsigned long size, void *data, struct list_head *head)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+	efi_char16_t *name = entry->var.VariableName;
+	efi_guid_t vendor = entry->var.VendorGuid;
+
+	spin_lock_irq(&__efivars->lock);
+
+	if (head && efivar_entry_find(name, vendor, head, false)) {
+		spin_unlock_irq(&__efivars->lock);
+		return -EEXIST;
+	}
+
+	status = check_var_size(attributes, size + utf16_strsize(name, 1024));
+	if (status == EFI_SUCCESS || status == EFI_UNSUPPORTED)
+		status = ops->set_variable(name, &vendor,
+					   attributes, size, data);
+
+	spin_unlock_irq(&__efivars->lock);
+
+	return efi_status_to_err(status);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_set);
+
+/**
+ * efivar_entry_set_safe - call set_variable() if enough space in firmware
+ * @name: buffer containing the variable name
+ * @vendor: variable vendor guid
+ * @attributes: variable attributes
+ * @block: can we block in this context?
+ * @size: size of @data buffer
+ * @data: buffer containing variable data
+ *
+ * Ensures there is enough free storage in the firmware for this variable, and
+ * if so, calls set_variable(). If creating a new EFI variable, this function
+ * is usually followed by efivar_entry_add().
+ *
+ * Returns 0 on success, -ENOSPC if the firmware does not have enough
+ * space for set_variable() to succeed, or a converted EFI status code
+ * if set_variable() fails.
+ */
+int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
+			  bool block, unsigned long size, void *data)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	unsigned long flags;
+	efi_status_t status;
+
+	if (!ops->query_variable_info)
+		return -ENOSYS;
+
+	if (!block && !spin_trylock_irqsave(&__efivars->lock, flags))
+		return -EBUSY;
+	else
+		spin_lock_irqsave(&__efivars->lock, flags);
+
+	status = check_var_size(attributes, size + utf16_strsize(name, 1024));
+	if (status != EFI_SUCCESS) {
+		spin_unlock_irqrestore(&__efivars->lock, flags);
+		return -ENOSPC;
+	}
+
+	status = ops->set_variable(name, &vendor, attributes, size, data);
+
+	spin_unlock_irqrestore(&__efivars->lock, flags);
+
+	return efi_status_to_err(status);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_set_safe);
+
+/**
+ * efivar_entry_find - search for an entry
+ * @name: the EFI variable name
+ * @guid: the EFI variable vendor's guid
+ * @head: head of the variable list
+ * @remove: should we remove the entry from the list?
+ *
+ * Search for an entry on the variable list that has the EFI variable
+ * name @name and vendor guid @guid. If an entry is found on the list
+ * and @remove is true, the entry is removed from the list.
+ *
+ * The caller MUST call efivar_entry_iter_begin() and
+ * efivar_entry_iter_end() before and after the invocation of this
+ * function, respectively.
+ *
+ * Returns the entry if found on the list, %NULL otherwise.
+ */
+struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
+				       struct list_head *head, bool remove)
+{
+	struct efivar_entry *entry, *n;
+	int strsize1, strsize2;
+	bool found = false;
+
+	WARN_ON(!spin_is_locked(&__efivars->lock));
+
+	list_for_each_entry_safe(entry, n, head, list) {
+		strsize1 = utf16_strsize(name, 1024);
+		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
+		if (strsize1 == strsize2 &&
+		    !memcmp(name, &(entry->var.VariableName), strsize1) &&
+		    !efi_guidcmp(guid, entry->var.VendorGuid)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return NULL;
+
+	if (remove)
+		list_del(&entry->list);
+
+	return entry;
+}
+EXPORT_SYMBOL_GPL(efivar_entry_find);
+
+/**
+ * efivar_entry_size - obtain the size of a variable
+ * @entry: entry for this variable
+ * @size: location to store the variable's size
+ */
+int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	*size = 0;
+
+	spin_lock_irq(&__efivars->lock);
+	status = ops->get_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid, NULL, size, NULL);
+	spin_unlock_irq(&__efivars->lock);
+
+	if (status != EFI_BUFFER_TOO_SMALL)
+		return efi_status_to_err(status);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivar_entry_size);
+
+/**
+ * efivar_entry_get - call get_variable()
+ * @entry: read data for this variable
+ * @attributes: variable attributes
+ * @size: size of @data buffer
+ * @data: buffer to store variable data
+ */
+int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
+		     unsigned long *size, void *data)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	spin_lock_irq(&__efivars->lock);
+	status = ops->get_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   attributes, size, data);
+	spin_unlock_irq(&__efivars->lock);
+
+	return efi_status_to_err(status);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_get);
+
+/**
+ * efivar_entry_set_get_size - call set_variable() and get new size (atomic)
+ * @entry: entry containing variable to set and get
+ * @attributes: attributes of variable to be written
+ * @size: size of data buffer
+ * @data: buffer containing data to write
+ * @set: did the set_variable() call succeed?
+ *
+ * This is a pretty special (complex) function. See efivarfs_file_write().
+ *
+ * Atomically call set_variable() for @entry and if the call is
+ * successful, return the new size of the variable from get_variable()
+ * in @size. The success of set_variable() is indicated by @set.
+ *
+ * Returns 0 on success, -EINVAL if the variable data is invalid,
+ * -ENOSPC if the firmware does not have enough available space, or a
+ * converted EFI status code if either of set_variable() or
+ * get_variable() fail.
+ *
+ * If the EFI variable does not exist when calling set_variable()
+ * (EFI_NOT_FOUND), @entry is removed from the variable list.
+ */
+int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
+			      unsigned long *size, void *data, bool *set)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_char16_t *name = entry->var.VariableName;
+	efi_guid_t *vendor = &entry->var.VendorGuid;
+	efi_status_t status;
+	int err;
+
+	*set = false;
+
+	if (efivar_validate(&entry->var, data, *size) == false)
+		return -EINVAL;
+
+	/*
+	 * The lock here protects the get_variable call, the conditional
+	 * set_variable call, and removal of the variable from the efivars
+	 * list (in the case of an authenticated delete).
+	 */
+	spin_lock_irq(&__efivars->lock);
+
+	/*
+	 * Ensure that the available space hasn't shrunk below the safe level
+	 */
+	status = check_var_size(attributes, *size + utf16_strsize(name, 1024));
+	if (status != EFI_SUCCESS) {
+		if (status != EFI_UNSUPPORTED) {
+			err = efi_status_to_err(status);
+			goto out;
+		}
+
+		if (*size > 65536) {
+			err = -ENOSPC;
+			goto out;
+		}
+	}
+
+	status = ops->set_variable(name, vendor, attributes, *size, data);
+	if (status != EFI_SUCCESS) {
+		err = efi_status_to_err(status);
+		goto out;
+	}
+
+	*set = true;
+
+	/*
+	 * Writing to the variable may have caused a change in size (which
+	 * could either be an append or an overwrite), or the variable to be
+	 * deleted. Perform a GetVariable() so we can tell what actually
+	 * happened.
+	 */
+	*size = 0;
+	status = ops->get_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   NULL, size, NULL);
+
+	if (status == EFI_NOT_FOUND)
+		efivar_entry_list_del_unlock(entry);
+	else
+		spin_unlock_irq(&__efivars->lock);
+
+	if (status && status != EFI_BUFFER_TOO_SMALL)
+		return efi_status_to_err(status);
+
+	return 0;
+
+out:
+	spin_unlock_irq(&__efivars->lock);
+	return err;
+
+}
+EXPORT_SYMBOL_GPL(efivar_entry_set_get_size);
+
+/**
+ * efivar_entry_iter_begin - begin iterating the variable list
+ *
+ * Lock the variable list to prevent entry insertion and removal until
+ * efivar_entry_iter_end() is called. This function is usually used in
+ * conjunction with __efivar_entry_iter() or efivar_entry_iter().
+ */
+void efivar_entry_iter_begin(void)
+{
+	spin_lock_irq(&__efivars->lock);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
+
+/**
+ * efivar_entry_iter_end - finish iterating the variable list
+ *
+ * Unlock the variable list and allow modifications to the list again.
+ */
+void efivar_entry_iter_end(void)
+{
+	spin_unlock_irq(&__efivars->lock);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_iter_end);
+
+/**
+ * __efivar_entry_iter - iterate over variable list
+ * @func: callback function
+ * @head: head of the variable list
+ * @data: function-specific data to pass to callback
+ * @prev: entry to begin iterating from
+ *
+ * Iterate over the list of EFI variables and call @func with every
+ * entry on the list. It is safe for @func to remove entries in the
+ * list via efivar_entry_delete().
+ *
+ * You MUST call efivar_enter_iter_begin() before this function, and
+ * efivar_entry_iter_end() afterwards.
+ *
+ * It is possible to begin iteration from an arbitrary entry within
+ * the list by passing @prev. @prev is updated on return to point to
+ * the last entry passed to @func. To begin iterating from the
+ * beginning of the list @prev must be %NULL.
+ *
+ * The restrictions for @func are the same as documented for
+ * efivar_entry_iter().
+ */
+int __efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
+			struct list_head *head, void *data,
+			struct efivar_entry **prev)
+{
+	struct efivar_entry *entry, *n;
+	int err = 0;
+
+	if (!prev || !*prev) {
+		list_for_each_entry_safe(entry, n, head, list) {
+			err = func(entry, data);
+			if (err)
+				break;
+		}
+
+		if (prev)
+			*prev = entry;
+
+		return err;
+	}
+
+
+	list_for_each_entry_safe_continue((*prev), n, head, list) {
+		err = func(*prev, data);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(__efivar_entry_iter);
+
+/**
+ * efivar_entry_iter - iterate over variable list
+ * @func: callback function
+ * @head: head of variable list
+ * @data: function-specific data to pass to callback
+ *
+ * Iterate over the list of EFI variables and call @func with every
+ * entry on the list. It is safe for @func to remove entries in the
+ * list via efivar_entry_delete() while iterating.
+ *
+ * Some notes for the callback function:
+ *  - a non-zero return value indicates an error and terminates the loop
+ *  - @func is called from atomic context
+ */
+int efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
+		      struct list_head *head, void *data)
+{
+	int err = 0;
+
+	efivar_entry_iter_begin();
+	err = __efivar_entry_iter(func, head, data, NULL);
+	efivar_entry_iter_end();
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(efivar_entry_iter);
+
+/**
+ * efivars_kobject - get the kobject for the registered efivars
+ *
+ * If efivars_register() has not been called we return NULL,
+ * otherwise return the kobject used at registration time.
+ */
+struct kobject *efivars_kobject(void)
+{
+	if (!__efivars)
+		return NULL;
+
+	return __efivars->kobject;
+}
+EXPORT_SYMBOL_GPL(efivars_kobject);
+
+/**
+ * efivars_register - register an efivars
+ * @efivars: efivars to register
+ * @ops: efivars operations
+ * @kobject: @efivars-specific kobject
+ *
+ * Only a single efivars can be registered at any time.
+ */
+int efivars_register(struct efivars *efivars,
+		     const struct efivar_operations *ops,
+		     struct kobject *kobject)
+{
+	spin_lock_init(&efivars->lock);
+	efivars->ops = ops;
+	efivars->kobject = kobject;
+
+	__efivars = efivars;
 
 	if (!efivars_pstore_disable)
-		efivar_pstore_register(efivars);
+		efivar_pstore_register();
 
 	register_filesystem(&efivarfs_type);
 
-out:
-	kfree(variable_name);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivars_register);
 
-	return error;
+/**
+ * efivars_unregister - unregister an efivars
+ * @efivars: efivars to unregister
+ *
+ * The caller must have already removed every entry from the list,
+ * failure to do so is an error.
+ */
+int efivars_unregister(struct efivars *efivars)
+{
+	int rv;
+
+	if (!__efivars) {
+		printk(KERN_ERR "efivars not registered\n");
+		rv = -EINVAL;
+		goto out;
+	}
+
+	if (__efivars != efivars) {
+		rv = -EINVAL;
+		goto out;
+	}
+
+	__efivars = NULL;
+
+	rv = 0;
+out:
+	return rv;
 }
-EXPORT_SYMBOL_GPL(register_efivars);
+EXPORT_SYMBOL_GPL(efivars_unregister);
 
 #ifdef CONFIG_EFI_VARS_GENERIC_OPS
 static struct efivars generic_efivars;
@@ -2090,17 +2427,28 @@ static struct efivar_operations generic_ops;
 
 int generic_ops_register(void)
 {
+	int error;
+
 	generic_ops.get_variable = efi.get_variable;
 	generic_ops.set_variable = efi.set_variable;
 	generic_ops.get_next_variable = efi.get_next_variable;
 	generic_ops.query_variable_info = efi.query_variable_info;
 
-	return register_efivars(&generic_efivars, &generic_ops, efi_kobj);
+	error = efivars_register(&generic_efivars, &generic_ops, efi_kobj);
+	if (error)
+		return error;
+
+	error = efivars_sysfs_init();
+	if (error)
+		efivars_unregister(&generic_efivars);
+
+	return error;
 }
 
 void generic_ops_unregister(void)
 {
-	unregister_efivars(&generic_efivars);
+	efivars_sysfs_exit();
+	efivars_unregister(&generic_efivars);
 }
 #else
 static inline int generic_ops_register(void)
@@ -2124,15 +2472,12 @@ static inline void generic_ops_unregister(void)
 static int __init
 efivars_init(void)
 {
-	int error = 0;
-
-	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
-	       EFIVARS_DATE);
+	int error;
 
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return 0;
 
-	/* For now we'll register the efi directory at /sys/firmware/efi */
+	/* Register the efi directory at /sys/firmware/efi */
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		printk(KERN_ERR "efivars: Firmware registration failed.\n");
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index c409a75..757b2d9 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -882,12 +882,19 @@ static __init int gsmi_init(void)
 		goto out_remove_bin_file;
 	}
 
-	ret = register_efivars(&efivars, &efivar_ops, gsmi_kobj);
+	ret = efivars_register(&efivars, &efivar_ops, gsmi_kobj);
 	if (ret) {
 		printk(KERN_INFO "gsmi: Failed to register efivars\n");
 		goto out_remove_sysfs_files;
 	}
 
+	ret = efivars_sysfs_init();
+	if (ret) {
+		printk(KERN_INFO "gsmi: Failed to create efivars files\n");
+		efivars_unregister(&efivars);
+		goto out_remove_sysfs_files;
+	}
+
 	register_reboot_notifier(&gsmi_reboot_notifier);
 	register_die_notifier(&gsmi_die_notifier);
 	atomic_notifier_chain_register(&panic_notifier_list,
@@ -919,7 +926,7 @@ static void __exit gsmi_exit(void)
 	unregister_die_notifier(&gsmi_die_notifier);
 	atomic_notifier_chain_unregister(&panic_notifier_list,
 					 &gsmi_panic_notifier);
-	unregister_efivars(&efivars);
+	efivars_unregister(&efivars);
 
 	sysfs_remove_files(gsmi_kobj, gsmi_attrs);
 	sysfs_remove_bin_file(gsmi_kobj, &eventlog_bin_attr);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d1d782a..78fc71d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -663,6 +663,12 @@ static inline int efi_enabled(int facility)
 				EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS | \
 				EFI_VARIABLE_APPEND_WRITE)
 /*
+ * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
+ * not including trailing NUL
+ */
+#define EFI_VARIABLE_GUID_LEN 36
+
+/*
  * The type of search to perform when calling boottime->locate_handle
  */
 #define EFI_LOCATE_ALL_HANDLES			0
@@ -762,19 +768,73 @@ struct efivars {
 	 * which is protected by the BKL, so that path is safe.
 	 */
 	spinlock_t lock;
-	struct list_head list;
 	struct kset *kset;
 	struct kobject *kobject;
-	struct bin_attribute *new_var, *del_var;
 	const struct efivar_operations *ops;
-	struct efivar_entry *walk_entry;
-	struct pstore_info efi_pstore_info;
 };
 
-int register_efivars(struct efivars *efivars,
+/*
+ * The maximum size of VariableName + Data = 1024
+ * Therefore, it's reasonable to save that much
+ * space in each part of the structure,
+ * and we use a page for reading/writing.
+ */
+
+struct efi_variable {
+	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
+	efi_guid_t    VendorGuid;
+	unsigned long DataSize;
+	__u8          Data[1024];
+	efi_status_t  Status;
+	__u32         Attributes;
+} __attribute__((packed));
+
+struct efivar_entry {
+	struct efi_variable var;
+	struct list_head list;
+	struct kobject kobj;
+};
+
+int efivars_register(struct efivars *efivars,
 		     const struct efivar_operations *ops,
-		     struct kobject *parent_kobj);
-void unregister_efivars(struct efivars *efivars);
+		     struct kobject *kobject);
+int efivars_unregister(struct efivars *efivars);
+struct kobject *efivars_kobject(void);
+
+int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
+		void *data, bool atomic, struct list_head *head);
+
+void efivar_entry_add(struct efivar_entry *entry, struct list_head *head);
+void efivar_entry_remove(struct efivar_entry *entry);
+
+int __efivar_entry_delete(struct efivar_entry *entry);
+int efivar_entry_delete(struct efivar_entry *entry);
+
+int efivar_entry_size(struct efivar_entry *entry, unsigned long *size);
+int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
+		     unsigned long *size, void *data);
+int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
+		     unsigned long size, void *data, struct list_head *head);
+int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
+			      unsigned long *size, void *data, bool *set);
+int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
+			  bool block, unsigned long size, void *data);
+
+void efivar_entry_iter_begin(void);
+void efivar_entry_iter_end(void);
+
+int __efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
+			struct list_head *head, void *data,
+			struct efivar_entry **prev);
+int efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
+		      struct list_head *head, void *data);
+
+struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
+				       struct list_head *head, bool remove);
+
+bool efivar_validate(struct efi_variable *var, u8 *data, unsigned long len);
+
+int efivars_sysfs_init(void);
 
 #endif /* CONFIG_EFI_VARS */
 
-- 
1.7.10.4

