Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846Ab3DDM1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:27:43 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49829 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759722Ab3DDM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:27:40 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Tom Gundersen <teg@jklm.no>, Mike Waychison <mikew@google.com>
Subject: [PATCH 2/6] efivars: Keep a private global pointer to efivars
Date: Thu,  4 Apr 2013 13:18:51 +0100
Message-Id: <1365077935-6859-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Some machines have an EFI variable interface that does not conform to the UEFI
specification, e.g. CONFIG_GOOGLE_SMI. Add the necessary code and Kconfig glue
so that it's only possible to select one implementation of EFI variable
operations. This allows us to keep a single (file-scope) global pointer 'struct
efivars', which simplifies access. This will hopefully dissuade developers from
accessing the generic operations struct directly in the future, as was done in
the efivarfs and pstore code, thereby allowing future code to work with both
the generic efivar ops and the google SMI ops.

This may seem like a step backwards in terms of modularity, but we don't need
to track more than one 'struct efivars' at one time. There is no
synchronisation done between multiple EFI variable operations, and according to
Mike no one is using both the generic EFI var ops and CONFIG_GOOGLE_SMI. It
also helps to clearly highlight which functions form the core of the efivars
interface - those that require access to __efivars.

Note that because of the Kconfig rules, we don't need to use any kind of
synchronisation primitive in register_efivars() - it's not possible to compile
more than one set of EFI variable operations into the kernel.

Cc: Tom Gundersen <teg@jklm.no>
Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/Kconfig   |    6 +++
 drivers/firmware/efivars.c |   91 +++++++++++++++++++++++++++-----------------
 2 files changed, 63 insertions(+), 34 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 42c759a..96d84ad 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -53,6 +53,12 @@ config EFI_VARS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://linux.dell.com/efibootmgr>
 
+config EFI_VARS_GENERIC_OPS
+	bool
+	depends on EFI
+	depends on !GOOGLE_SMI
+	default y
+
 config EFI_VARS_PSTORE
 	bool "Register efivars backend for pstore"
 	depends on EFI_VARS && PSTORE
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 34c8783..721d200 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -125,7 +125,6 @@ struct efi_variable {
 } __attribute__((packed));
 
 struct efivar_entry {
-	struct efivars *efivars;
 	struct efi_variable var;
 	struct list_head list;
 	struct kobject kobj;
@@ -137,8 +136,8 @@ struct efivar_attribute {
 	ssize_t (*store)(struct efivar_entry *entry, const char *buf, size_t count);
 };
 
-static struct efivars __efivars;
-static struct efivar_operations ops;
+/* Private pointer to registered efivars */
+static struct efivars *__efivars;
 
 #define PSTORE_EFI_ATTRIBUTES \
 	(EFI_VARIABLE_NON_VOLATILE | \
@@ -479,7 +478,7 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
+	status = get_var_data(__efivars, var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
@@ -513,7 +512,7 @@ efivar_size_read(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
+	status = get_var_data(__efivars, var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
@@ -530,7 +529,7 @@ efivar_data_read(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
+	status = get_var_data(__efivars, var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
@@ -545,7 +544,7 @@ static ssize_t
 efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 {
 	struct efi_variable *new_var, *var = &entry->var;
-	struct efivars *efivars = entry->efivars;
+	struct efivars *efivars = __efivars;
 	efi_status_t status = EFI_NOT_FOUND;
 
 	if (count != sizeof(struct efi_variable))
@@ -606,7 +605,7 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return 0;
 
-	status = get_var_data(entry->efivars, var);
+	status = get_var_data(__efivars, var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
@@ -728,7 +727,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 		const char __user *userbuf, size_t count, loff_t *ppos)
 {
 	struct efivar_entry *var = file->private_data;
-	struct efivars *efivars;
+	struct efivars *efivars = __efivars;
 	efi_status_t status;
 	void *data;
 	u32 attributes;
@@ -746,8 +745,6 @@ static ssize_t efivarfs_file_write(struct file *file,
 	if (attributes & ~(EFI_VARIABLE_MASK))
 		return -EINVAL;
 
-	efivars = var->efivars;
-
 	/*
 	 * Ensure that the user can't allocate arbitrarily large
 	 * amounts of memory. Pick a default size of 64K if
@@ -855,7 +852,7 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 		size_t count, loff_t *ppos)
 {
 	struct efivar_entry *var = file->private_data;
-	struct efivars *efivars = var->efivars;
+	struct efivars *efivars = __efivars;
 	efi_status_t status;
 	unsigned long datasize = 0;
 	u32 attributes;
@@ -1009,7 +1006,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 			  umode_t mode, bool excl)
 {
 	struct inode *inode;
-	struct efivars *efivars = &__efivars;
+	struct efivars *efivars = __efivars;
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
 
@@ -1038,7 +1035,6 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	var->var.VariableName[i] = '\0';
 
 	inode->i_private = var;
-	var->efivars = efivars;
 	var->kobj.kset = efivars->kset;
 
 	err = kobject_init_and_add(&var->kobj, &efivar_ktype, NULL, "%s",
@@ -1063,7 +1059,7 @@ out:
 static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct efivar_entry *var = dentry->d_inode->i_private;
-	struct efivars *efivars = var->efivars;
+	struct efivars *efivars = __efivars;
 	efi_status_t status;
 
 	spin_lock_irq(&efivars->lock);
@@ -1175,7 +1171,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode = NULL;
 	struct dentry *root;
 	struct efivar_entry *entry, *n;
-	struct efivars *efivars = &__efivars;
+	struct efivars *efivars = __efivars;
 	char *name;
 	int err = -ENOMEM;
 
@@ -1302,7 +1298,7 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
-	struct efivars *efivars = psi->data;
+	struct efivars *efivars = __efivars;
 
 	spin_lock_irq(&efivars->lock);
 	efivars->walk_entry = list_first_entry(&efivars->list,
@@ -1312,7 +1308,7 @@ static int efi_pstore_open(struct pstore_info *psi)
 
 static int efi_pstore_close(struct pstore_info *psi)
 {
-	struct efivars *efivars = psi->data;
+	struct efivars *efivars = __efivars;
 
 	spin_unlock_irq(&efivars->lock);
 	return 0;
@@ -1323,7 +1319,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       char **buf, struct pstore_info *psi)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = psi->data;
+	struct efivars *efivars = __efivars;
 	char name[DUMP_NAME_LEN];
 	int i;
 	int cnt;
@@ -1386,7 +1382,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = psi->data;
+	struct efivars *efivars = __efivars;
 	int i, ret = 0;
 	efi_status_t status = EFI_NOT_FOUND;
 	unsigned long flags;
@@ -1443,7 +1439,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	char name_old[DUMP_NAME_LEN];
 	efi_char16_t efi_name_old[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = psi->data;
+	struct efivars *efivars = __efivars;
 	struct efivar_entry *entry, *found = NULL;
 	int i;
 
@@ -1535,7 +1531,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
-	struct efivars *efivars = bin_attr->private;
+	struct efivars *efivars = __efivars;
 	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
@@ -1612,7 +1608,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
-	struct efivars *efivars = bin_attr->private;
+	struct efivars *efivars = __efivars;
 	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
@@ -1670,7 +1666,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
 {
 	struct efivar_entry *entry, *n;
-	struct efivars *efivars = &__efivars;
+	struct efivars *efivars = __efivars;
 	unsigned long strsize1, strsize2;
 	bool found = false;
 
@@ -1716,7 +1712,7 @@ static unsigned long var_name_strnsize(efi_char16_t *variable_name,
 
 static void efivar_update_sysfs_entries(struct work_struct *work)
 {
-	struct efivars *efivars = &__efivars;
+	struct efivars *efivars = __efivars;
 	efi_guid_t vendor;
 	efi_char16_t *variable_name;
 	unsigned long variable_name_size = 1024;
@@ -1843,7 +1839,6 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 		return 1;
 	}
 
-	new_efivar->efivars = efivars;
 	memcpy(new_efivar->var.VariableName, variable_name,
 		variable_name_size);
 	memcpy(&(new_efivar->var.VendorGuid), vendor_guid, sizeof(efi_guid_t));
@@ -1942,6 +1937,8 @@ void unregister_efivars(struct efivars *efivars)
 {
 	struct efivar_entry *entry, *n;
 
+	__efivars = NULL;
+
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
 		spin_lock_irq(&efivars->lock);
 		list_del(&entry->list);
@@ -1998,6 +1995,8 @@ int register_efivars(struct efivars *efivars,
 	unsigned long variable_name_size = 1024;
 	int error = 0;
 
+	__efivars = efivars;
+
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
 	if (!variable_name) {
 		printk(KERN_ERR "efivars: Memory allocation failed.\n");
@@ -2085,6 +2084,35 @@ out:
 }
 EXPORT_SYMBOL_GPL(register_efivars);
 
+#ifdef CONFIG_EFI_VARS_GENERIC_OPS
+static struct efivars generic_efivars;
+static struct efivar_operations generic_ops;
+
+int generic_ops_register(void)
+{
+	generic_ops.get_variable = efi.get_variable;
+	generic_ops.set_variable = efi.set_variable;
+	generic_ops.get_next_variable = efi.get_next_variable;
+	generic_ops.query_variable_info = efi.query_variable_info;
+
+	return register_efivars(&generic_efivars, &generic_ops, efi_kobj);
+}
+
+void generic_ops_unregister(void)
+{
+	unregister_efivars(&generic_efivars);
+}
+#else
+static inline int generic_ops_register(void)
+{
+	return 0;
+}
+
+static inline void generic_ops_unregister(void)
+{
+}
+#endif /* CONFIG_EFI_VARS_GENERIC_OPS */
+
 /*
  * For now we register the efi subsystem with the firmware subsystem
  * and the vars subsystem with the efi subsystem.  In the future, it
@@ -2111,12 +2139,7 @@ efivars_init(void)
 		return -ENOMEM;
 	}
 
-	ops.get_variable = efi.get_variable;
-	ops.set_variable = efi.set_variable;
-	ops.get_next_variable = efi.get_next_variable;
-	ops.query_variable_info = efi.query_variable_info;
-
-	error = register_efivars(&__efivars, &ops, efi_kobj);
+	error = generic_ops_register();
 	if (error)
 		goto err_put;
 
@@ -2132,7 +2155,7 @@ efivars_init(void)
 	return 0;
 
 err_unregister:
-	unregister_efivars(&__efivars);
+	generic_ops_unregister();
 err_put:
 	kobject_put(efi_kobj);
 	return error;
@@ -2144,7 +2167,7 @@ efivars_exit(void)
 	cancel_work_sync(&efivar_work);
 
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-		unregister_efivars(&__efivars);
+		generic_ops_unregister();
 		kobject_put(efi_kobj);
 	}
 }
-- 
1.7.10.4

