Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab3DDM2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:28:43 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49833 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759756Ab3DDM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:27:40 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, Tom Gundersen <teg@jklm.no>
Subject: [PATCH 5/6] efivarfs: Move to fs/efivarfs
Date: Thu,  4 Apr 2013 13:18:54 +0100
Message-Id: <1365077935-6859-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Now that efivarfs uses the efivar API, move it out of efivars.c and into
fs/efivarfs where it belongs. This move will eventually allow us to enable the
efivarfs code without having to also enable CONFIG_EFI_VARS built, and vice
versa.

Furthermore, things like,

    mount -t efivarfs none /sys/firmware/efi/efivars

will now work if efivarfs is built as a module without requiring the use of
MODULE_ALIAS(), which would have been necessary when the efivarfs code was part
of efivars.c.

Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Tom Gundersen <teg@jklm.no>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 MAINTAINERS                |    9 +
 drivers/firmware/efivars.c |  495 --------------------------------------------
 fs/Kconfig                 |    1 +
 fs/Makefile                |    1 +
 fs/efivarfs/Kconfig        |   12 ++
 fs/efivarfs/Makefile       |    7 +
 fs/efivarfs/file.c         |  111 ++++++++++
 fs/efivarfs/inode.c        |  173 ++++++++++++++++
 fs/efivarfs/internal.h     |   22 ++
 fs/efivarfs/super.c        |  266 ++++++++++++++++++++++++
 10 files changed, 602 insertions(+), 495 deletions(-)
 create mode 100644 fs/efivarfs/Kconfig
 create mode 100644 fs/efivarfs/Makefile
 create mode 100644 fs/efivarfs/file.c
 create mode 100644 fs/efivarfs/inode.c
 create mode 100644 fs/efivarfs/internal.h
 create mode 100644 fs/efivarfs/super.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 9d106da..ed131c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2990,6 +2990,15 @@ F:	arch/x86/platform/efi/*
 F:	drivers/firmware/efivars.c
 F:	include/linux/efi*.h
 
+EFI VARIABLE FILESYSTEM
+M:	Matthew Garrett <matthew.garrett@nebula.com>
+M:	Jeremy Kerr <jk@ozlabs.org>
+M:	Matt Fleming <matt.fleming@intel.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
+L:	linux-efi@vger.kernel.org
+S:	Maintained
+F:	fs/efivarfs/
+
 EFIFB FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 M:	Peter Jones <pjones@redhat.com>
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 949d8d4..f6fd57e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -94,7 +94,6 @@ MODULE_DESCRIPTION("sysfs interface to EFI Variables");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
 
-static LIST_HEAD(efivarfs_list);
 LIST_HEAD(efivar_sysfs_list);
 EXPORT_SYMBOL_GPL(efivar_sysfs_list);
 
@@ -558,12 +557,6 @@ static struct kobj_type efivar_ktype = {
 	.default_attrs = def_attrs,
 };
 
-static int efivarfs_file_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int efi_status_to_err(efi_status_t status)
 {
 	int err;
@@ -597,492 +590,6 @@ static int efi_status_to_err(efi_status_t status)
 	return err;
 }
 
-static ssize_t efivarfs_file_write(struct file *file,
-		const char __user *userbuf, size_t count, loff_t *ppos)
-{
-	struct efivar_entry *var = file->private_data;
-	void *data;
-	u32 attributes;
-	struct inode *inode = file->f_mapping->host;
-	unsigned long datasize = count - sizeof(attributes);
-	ssize_t bytes = 0;
-	bool set = false;
-
-	if (count < sizeof(attributes))
-		return -EINVAL;
-
-	if (copy_from_user(&attributes, userbuf, sizeof(attributes)))
-		return -EFAULT;
-
-	if (attributes & ~(EFI_VARIABLE_MASK))
-		return -EINVAL;
-
-	data = kmalloc(datasize, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
-		bytes = -EFAULT;
-		goto out;
-	}
-
-	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
-					  data, &set);
-	if (!set && bytes)
-		goto out;
-
-	if (!bytes) {
-		mutex_lock(&inode->i_mutex);
-		i_size_write(inode, datasize + sizeof(attributes));
-		mutex_unlock(&inode->i_mutex);
-	} else if (bytes == -ENOENT) {
-		drop_nlink(inode);
-		d_delete(file->f_dentry);
-		dput(file->f_dentry);
-	} else
-		pr_warn("efivarfs: inconsistent EFI variable implementation? "
-				"status=%zu\n", bytes);
-
-	bytes = count;
-
-out:
-	kfree(data);
-
-	return bytes;
-}
-
-static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
-		size_t count, loff_t *ppos)
-{
-	struct efivar_entry *var = file->private_data;
-	unsigned long datasize = 0;
-	u32 attributes;
-	void *data;
-	ssize_t size = 0;
-	int err;
-
-	err = efivar_entry_size(var, &datasize);
-	if (err)
-		return err;
-
-	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
-
-	if (!data)
-		return -ENOMEM;
-
-	size = efivar_entry_get(var, &attributes, &datasize,
-				data + sizeof(attributes));
-	if (size)
-		goto out_free;
-
-	memcpy(data, &attributes, sizeof(attributes));
-	size = simple_read_from_buffer(userbuf, count, ppos,
-				       data, datasize + sizeof(attributes));
-out_free:
-	kfree(data);
-
-	return size;
-}
-
-static void efivarfs_evict_inode(struct inode *inode)
-{
-	clear_inode(inode);
-}
-
-static const struct super_operations efivarfs_ops = {
-	.statfs = simple_statfs,
-	.drop_inode = generic_delete_inode,
-	.evict_inode = efivarfs_evict_inode,
-	.show_options = generic_show_options,
-};
-
-static struct super_block *efivarfs_sb;
-
-static const struct inode_operations efivarfs_dir_inode_operations;
-
-static const struct file_operations efivarfs_file_operations = {
-	.open	= efivarfs_file_open,
-	.read	= efivarfs_file_read,
-	.write	= efivarfs_file_write,
-	.llseek	= no_llseek,
-};
-
-static struct inode *efivarfs_get_inode(struct super_block *sb,
-				const struct inode *dir, int mode, dev_t dev)
-{
-	struct inode *inode = new_inode(sb);
-
-	if (inode) {
-		inode->i_ino = get_next_ino();
-		inode->i_mode = mode;
-		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		switch (mode & S_IFMT) {
-		case S_IFREG:
-			inode->i_fop = &efivarfs_file_operations;
-			break;
-		case S_IFDIR:
-			inode->i_op = &efivarfs_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
-			inc_nlink(inode);
-			break;
-		}
-	}
-	return inode;
-}
-
-/*
- * Return true if 'str' is a valid efivarfs filename of the form,
- *
- *	VariableName-12345678-1234-1234-1234-1234567891bc
- */
-static bool efivarfs_valid_name(const char *str, int len)
-{
-	static const char dashes[EFI_VARIABLE_GUID_LEN] = {
-		[8] = 1, [13] = 1, [18] = 1, [23] = 1
-	};
-	const char *s = str + len - EFI_VARIABLE_GUID_LEN;
-	int i;
-
-	/*
-	 * We need a GUID, plus at least one letter for the variable name,
-	 * plus the '-' separator
-	 */
-	if (len < EFI_VARIABLE_GUID_LEN + 2)
-		return false;
-
-	/* GUID must be preceded by a '-' */
-	if (*(s - 1) != '-')
-		return false;
-
-	/*
-	 * Validate that 's' is of the correct format, e.g.
-	 *
-	 *	12345678-1234-1234-1234-123456789abc
-	 */
-	for (i = 0; i < EFI_VARIABLE_GUID_LEN; i++) {
-		if (dashes[i]) {
-			if (*s++ != '-')
-				return false;
-		} else {
-			if (!isxdigit(*s++))
-				return false;
-		}
-	}
-
-	return true;
-}
-
-static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
-{
-	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
-	guid->b[1] = hex_to_bin(str[4]) << 4 | hex_to_bin(str[5]);
-	guid->b[2] = hex_to_bin(str[2]) << 4 | hex_to_bin(str[3]);
-	guid->b[3] = hex_to_bin(str[0]) << 4 | hex_to_bin(str[1]);
-	guid->b[4] = hex_to_bin(str[11]) << 4 | hex_to_bin(str[12]);
-	guid->b[5] = hex_to_bin(str[9]) << 4 | hex_to_bin(str[10]);
-	guid->b[6] = hex_to_bin(str[16]) << 4 | hex_to_bin(str[17]);
-	guid->b[7] = hex_to_bin(str[14]) << 4 | hex_to_bin(str[15]);
-	guid->b[8] = hex_to_bin(str[19]) << 4 | hex_to_bin(str[20]);
-	guid->b[9] = hex_to_bin(str[21]) << 4 | hex_to_bin(str[22]);
-	guid->b[10] = hex_to_bin(str[24]) << 4 | hex_to_bin(str[25]);
-	guid->b[11] = hex_to_bin(str[26]) << 4 | hex_to_bin(str[27]);
-	guid->b[12] = hex_to_bin(str[28]) << 4 | hex_to_bin(str[29]);
-	guid->b[13] = hex_to_bin(str[30]) << 4 | hex_to_bin(str[31]);
-	guid->b[14] = hex_to_bin(str[32]) << 4 | hex_to_bin(str[33]);
-	guid->b[15] = hex_to_bin(str[34]) << 4 | hex_to_bin(str[35]);
-}
-
-static int efivarfs_create(struct inode *dir, struct dentry *dentry,
-			  umode_t mode, bool excl)
-{
-	struct inode *inode;
-	struct efivar_entry *var;
-	int namelen, i = 0, err = 0;
-
-	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
-		return -EINVAL;
-
-	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
-	if (!inode)
-		return -ENOMEM;
-
-	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
-	if (!var) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	/* length of the variable name itself: remove GUID and separator */
-	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
-
-	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
-			&var->var.VendorGuid);
-
-	for (i = 0; i < namelen; i++)
-		var->var.VariableName[i] = dentry->d_name.name[i];
-
-	var->var.VariableName[i] = '\0';
-
-	inode->i_private = var;
-
-	efivar_entry_add(var, &efivarfs_list);
-	d_instantiate(dentry, inode);
-	dget(dentry);
-out:
-	if (err) {
-		kfree(var);
-		iput(inode);
-	}
-	return err;
-}
-
-static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
-{
-	struct efivar_entry *var = dentry->d_inode->i_private;
-
-	if (efivar_entry_delete(var))
-		return -EINVAL;
-
-	drop_nlink(dentry->d_inode);
-	dput(dentry);
-	return 0;
-};
-
-/*
- * Compare two efivarfs file names.
- *
- * An efivarfs filename is composed of two parts,
- *
- *	1. A case-sensitive variable name
- *	2. A case-insensitive GUID
- *
- * So we need to perform a case-sensitive match on part 1 and a
- * case-insensitive match on part 2.
- */
-static int efivarfs_d_compare(const struct dentry *parent, const struct inode *pinode,
-			      const struct dentry *dentry, const struct inode *inode,
-			      unsigned int len, const char *str,
-			      const struct qstr *name)
-{
-	int guid = len - EFI_VARIABLE_GUID_LEN;
-
-	if (name->len != len)
-		return 1;
-
-	/* Case-sensitive compare for the variable name */
-	if (memcmp(str, name->name, guid))
-		return 1;
-
-	/* Case-insensitive compare for the GUID */
-	return strncasecmp(name->name + guid, str + guid, EFI_VARIABLE_GUID_LEN);
-}
-
-static int efivarfs_d_hash(const struct dentry *dentry,
-			   const struct inode *inode, struct qstr *qstr)
-{
-	unsigned long hash = init_name_hash();
-	const unsigned char *s = qstr->name;
-	unsigned int len = qstr->len;
-
-	if (!efivarfs_valid_name(s, len))
-		return -EINVAL;
-
-	while (len-- > EFI_VARIABLE_GUID_LEN)
-		hash = partial_name_hash(*s++, hash);
-
-	/* GUID is case-insensitive. */
-	while (len--)
-		hash = partial_name_hash(tolower(*s++), hash);
-
-	qstr->hash = end_name_hash(hash);
-	return 0;
-}
-
-/*
- * Retaining negative dentries for an in-memory filesystem just wastes
- * memory and lookup time: arrange for them to be deleted immediately.
- */
-static int efivarfs_delete_dentry(const struct dentry *dentry)
-{
-	return 1;
-}
-
-static struct dentry_operations efivarfs_d_ops = {
-	.d_compare = efivarfs_d_compare,
-	.d_hash = efivarfs_d_hash,
-	.d_delete = efivarfs_delete_dentry,
-};
-
-static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
-{
-	struct dentry *d;
-	struct qstr q;
-	int err;
-
-	q.name = name;
-	q.len = strlen(name);
-
-	err = efivarfs_d_hash(NULL, NULL, &q);
-	if (err)
-		return ERR_PTR(err);
-
-	d = d_alloc(parent, &q);
-	if (d)
-		return d;
-
-	return ERR_PTR(-ENOMEM);
-}
-
-static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
-			     unsigned long name_size, void *data)
-{
-	struct super_block *sb = (struct super_block *)data;
-	struct efivar_entry *entry;
-	struct inode *inode = NULL;
-	struct dentry *dentry, *root = sb->s_root;
-	unsigned long size = 0;
-	char *name;
-	int len, i;
-	int err = -ENOMEM;
-
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		return err;
-
-	memcpy(entry->var.VariableName, name16, name_size);
-	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
-
-	len = utf16_strlen(entry->var.VariableName);
-
-	/* name, plus '-', plus GUID, plus NUL*/
-	name = kmalloc(len + 1 + EFI_VARIABLE_GUID_LEN + 1, GFP_KERNEL);
-	if (!name)
-		goto fail;
-
-	for (i = 0; i < len; i++)
-		name[i] = entry->var.VariableName[i] & 0xFF;
-
-	name[len] = '-';
-
-	efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
-
-	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
-
-	inode = efivarfs_get_inode(sb, root->d_inode, S_IFREG | 0644, 0);
-	if (!inode)
-		goto fail_name;
-
-	dentry = efivarfs_alloc_dentry(root, name);
-	if (IS_ERR(dentry)) {
-		err = PTR_ERR(dentry);
-		goto fail_inode;
-	}
-
-	/* copied by the above to local storage in the dentry. */
-	kfree(name);
-
-	efivar_entry_size(entry, &size);
-	efivar_entry_add(entry, &efivarfs_list);
-
-	mutex_lock(&inode->i_mutex);
-	inode->i_private = entry;
-	i_size_write(inode, size + sizeof(entry->var.Attributes));
-	mutex_unlock(&inode->i_mutex);
-	d_add(dentry, inode);
-
-	return 0;
-
-fail_inode:
-	iput(inode);
-fail_name:
-	kfree(name);
-fail:
-	kfree(entry);
-	return err;
-}
-
-static int efivarfs_destroy(struct efivar_entry *entry, void *data)
-{
-	efivar_entry_remove(entry);
-	kfree(entry);
-	return 0;
-}
-
-static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
-{
-	struct inode *inode = NULL;
-	struct dentry *root;
-	int err;
-
-	efivarfs_sb = sb;
-
-	sb->s_maxbytes          = MAX_LFS_FILESIZE;
-	sb->s_blocksize         = PAGE_CACHE_SIZE;
-	sb->s_blocksize_bits    = PAGE_CACHE_SHIFT;
-	sb->s_magic             = EFIVARFS_MAGIC;
-	sb->s_op                = &efivarfs_ops;
-	sb->s_d_op		= &efivarfs_d_ops;
-	sb->s_time_gran         = 1;
-
-	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
-	if (!inode)
-		return -ENOMEM;
-	inode->i_op = &efivarfs_dir_inode_operations;
-
-	root = d_make_root(inode);
-	sb->s_root = root;
-	if (!root)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&efivarfs_list);
-
-	err = efivar_init(efivarfs_callback, (void *)sb, false, &efivarfs_list);
-	if (err)
-		__efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL, NULL);
-
-	return err;
-}
-
-static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
-				    int flags, const char *dev_name, void *data)
-{
-	return mount_single(fs_type, flags, data, efivarfs_fill_super);
-}
-
-static void efivarfs_kill_sb(struct super_block *sb)
-{
-	kill_litter_super(sb);
-	efivarfs_sb = NULL;
-
-	/* Remove all entries and destroy */
-	__efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL, NULL);
-}
-
-static struct file_system_type efivarfs_type = {
-	.name    = "efivarfs",
-	.mount   = efivarfs_mount,
-	.kill_sb = efivarfs_kill_sb,
-};
-MODULE_ALIAS_FS("efivarfs");
-
-/*
- * Handle negative dentry.
- */
-static struct dentry *efivarfs_lookup(struct inode *dir, struct dentry *dentry,
-				      unsigned int flags)
-{
-	if (dentry->d_name.len > NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
-	d_add(dentry, NULL);
-	return NULL;
-}
-
-static const struct inode_operations efivarfs_dir_inode_operations = {
-	.lookup = efivarfs_lookup,
-	.unlink = efivarfs_unlink,
-	.create = efivarfs_create,
-};
-
 static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -2132,8 +1639,6 @@ int efivars_register(struct efivars *efivars,
 
 	__efivars = efivars;
 
-	register_filesystem(&efivarfs_type);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(efivars_register);
diff --git a/fs/Kconfig b/fs/Kconfig
index 780725a..c229f82 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -211,6 +211,7 @@ source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
 source "fs/f2fs/Kconfig"
+source "fs/efivarfs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index 9d53192..0fde6a3 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -127,3 +127,4 @@ obj-$(CONFIG_F2FS_FS)		+= f2fs/
 obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
+obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
diff --git a/fs/efivarfs/Kconfig b/fs/efivarfs/Kconfig
new file mode 100644
index 0000000..1fb2b7f
--- /dev/null
+++ b/fs/efivarfs/Kconfig
@@ -0,0 +1,12 @@
+config EFIVAR_FS
+	tristate "EFI Variable filesystem"
+	depends on EFI_VARS
+	help
+	  efivarfs is a replacement filesystem for the old EFI
+	  variable support via sysfs, as it doesn't suffer from the
+	  same 1024-byte variable size limit.
+
+	  To compile this file system support as a module, choose M
+	  here. The module will be called efivarfs.
+
+	  If unsure, say N.
diff --git a/fs/efivarfs/Makefile b/fs/efivarfs/Makefile
new file mode 100644
index 0000000..955d478
--- /dev/null
+++ b/fs/efivarfs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the efivarfs filesystem
+#
+
+obj-$(CONFIG_EFIVAR_FS)		+= efivarfs.o
+
+efivarfs-objs			:= inode.o file.o super.o
diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
new file mode 100644
index 0000000..aeb0368
--- /dev/null
+++ b/fs/efivarfs/file.c
@@ -0,0 +1,111 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2012 Jeremy Kerr <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <linux/fs.h>
+
+#include "internal.h"
+
+static int efivarfs_file_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t efivarfs_file_write(struct file *file,
+		const char __user *userbuf, size_t count, loff_t *ppos)
+{
+	struct efivar_entry *var = file->private_data;
+	void *data;
+	u32 attributes;
+	struct inode *inode = file->f_mapping->host;
+	unsigned long datasize = count - sizeof(attributes);
+	ssize_t bytes = 0;
+	bool set = false;
+
+	if (count < sizeof(attributes))
+		return -EINVAL;
+
+	if (copy_from_user(&attributes, userbuf, sizeof(attributes)))
+		return -EFAULT;
+
+	if (attributes & ~(EFI_VARIABLE_MASK))
+		return -EINVAL;
+
+	data = kmalloc(datasize, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
+		bytes = -EFAULT;
+		goto out;
+	}
+
+	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
+					  data, &set);
+	if (!set && bytes)
+		goto out;
+
+	if (bytes == -ENOENT) {
+		drop_nlink(inode);
+		d_delete(file->f_dentry);
+		dput(file->f_dentry);
+	} else {
+		mutex_lock(&inode->i_mutex);
+		i_size_write(inode, datasize + sizeof(attributes));
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	bytes = count;
+
+out:
+	kfree(data);
+
+	return bytes;
+}
+
+static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
+		size_t count, loff_t *ppos)
+{
+	struct efivar_entry *var = file->private_data;
+	unsigned long datasize = 0;
+	u32 attributes;
+	void *data;
+	ssize_t size = 0;
+	int err;
+
+	err = efivar_entry_size(var, &datasize);
+	if (err)
+		return err;
+
+	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+
+	size = efivar_entry_get(var, &attributes, &datasize,
+				data + sizeof(attributes));
+	if (size)
+		goto out_free;
+
+	memcpy(data, &attributes, sizeof(attributes));
+	size = simple_read_from_buffer(userbuf, count, ppos,
+				       data, datasize + sizeof(attributes));
+out_free:
+	kfree(data);
+
+	return size;
+}
+
+const struct file_operations efivarfs_file_operations = {
+	.open	= efivarfs_file_open,
+	.read	= efivarfs_file_read,
+	.write	= efivarfs_file_write,
+	.llseek	= no_llseek,
+};
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
new file mode 100644
index 0000000..640e289
--- /dev/null
+++ b/fs/efivarfs/inode.c
@@ -0,0 +1,173 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2012 Jeremy Kerr <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <linux/fs.h>
+#include <linux/ctype.h>
+
+#include "internal.h"
+
+struct inode *efivarfs_get_inode(struct super_block *sb,
+				const struct inode *dir, int mode, dev_t dev)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (inode) {
+		inode->i_ino = get_next_ino();
+		inode->i_mode = mode;
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		switch (mode & S_IFMT) {
+		case S_IFREG:
+			inode->i_fop = &efivarfs_file_operations;
+			break;
+		case S_IFDIR:
+			inode->i_op = &efivarfs_dir_inode_operations;
+			inode->i_fop = &simple_dir_operations;
+			inc_nlink(inode);
+			break;
+		}
+	}
+	return inode;
+}
+
+/*
+ * Return true if 'str' is a valid efivarfs filename of the form,
+ *
+ *	VariableName-12345678-1234-1234-1234-1234567891bc
+ */
+bool efivarfs_valid_name(const char *str, int len)
+{
+	static const char dashes[EFI_VARIABLE_GUID_LEN] = {
+		[8] = 1, [13] = 1, [18] = 1, [23] = 1
+	};
+	const char *s = str + len - EFI_VARIABLE_GUID_LEN;
+	int i;
+
+	/*
+	 * We need a GUID, plus at least one letter for the variable name,
+	 * plus the '-' separator
+	 */
+	if (len < EFI_VARIABLE_GUID_LEN + 2)
+		return false;
+
+	/* GUID must be preceded by a '-' */
+	if (*(s - 1) != '-')
+		return false;
+
+	/*
+	 * Validate that 's' is of the correct format, e.g.
+	 *
+	 *	12345678-1234-1234-1234-123456789abc
+	 */
+	for (i = 0; i < EFI_VARIABLE_GUID_LEN; i++) {
+		if (dashes[i]) {
+			if (*s++ != '-')
+				return false;
+		} else {
+			if (!isxdigit(*s++))
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
+{
+	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
+	guid->b[1] = hex_to_bin(str[4]) << 4 | hex_to_bin(str[5]);
+	guid->b[2] = hex_to_bin(str[2]) << 4 | hex_to_bin(str[3]);
+	guid->b[3] = hex_to_bin(str[0]) << 4 | hex_to_bin(str[1]);
+	guid->b[4] = hex_to_bin(str[11]) << 4 | hex_to_bin(str[12]);
+	guid->b[5] = hex_to_bin(str[9]) << 4 | hex_to_bin(str[10]);
+	guid->b[6] = hex_to_bin(str[16]) << 4 | hex_to_bin(str[17]);
+	guid->b[7] = hex_to_bin(str[14]) << 4 | hex_to_bin(str[15]);
+	guid->b[8] = hex_to_bin(str[19]) << 4 | hex_to_bin(str[20]);
+	guid->b[9] = hex_to_bin(str[21]) << 4 | hex_to_bin(str[22]);
+	guid->b[10] = hex_to_bin(str[24]) << 4 | hex_to_bin(str[25]);
+	guid->b[11] = hex_to_bin(str[26]) << 4 | hex_to_bin(str[27]);
+	guid->b[12] = hex_to_bin(str[28]) << 4 | hex_to_bin(str[29]);
+	guid->b[13] = hex_to_bin(str[30]) << 4 | hex_to_bin(str[31]);
+	guid->b[14] = hex_to_bin(str[32]) << 4 | hex_to_bin(str[33]);
+	guid->b[15] = hex_to_bin(str[34]) << 4 | hex_to_bin(str[35]);
+}
+
+static int efivarfs_create(struct inode *dir, struct dentry *dentry,
+			  umode_t mode, bool excl)
+{
+	struct inode *inode;
+	struct efivar_entry *var;
+	int namelen, i = 0, err = 0;
+
+	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
+		return -EINVAL;
+
+	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
+	if (!inode)
+		return -ENOMEM;
+
+	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
+	if (!var) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* length of the variable name itself: remove GUID and separator */
+	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
+
+	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
+			&var->var.VendorGuid);
+
+	for (i = 0; i < namelen; i++)
+		var->var.VariableName[i] = dentry->d_name.name[i];
+
+	var->var.VariableName[i] = '\0';
+
+	inode->i_private = var;
+
+	efivar_entry_add(var, &efivarfs_list);
+	d_instantiate(dentry, inode);
+	dget(dentry);
+out:
+	if (err) {
+		kfree(var);
+		iput(inode);
+	}
+	return err;
+}
+
+static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct efivar_entry *var = dentry->d_inode->i_private;
+
+	if (efivar_entry_delete(var))
+		return -EINVAL;
+
+	drop_nlink(dentry->d_inode);
+	dput(dentry);
+	return 0;
+};
+
+/*
+ * Handle negative dentry.
+ */
+static struct dentry *efivarfs_lookup(struct inode *dir, struct dentry *dentry,
+				      unsigned int flags)
+{
+	if (dentry->d_name.len > NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+	d_add(dentry, NULL);
+	return NULL;
+}
+
+const struct inode_operations efivarfs_dir_inode_operations = {
+	.lookup = efivarfs_lookup,
+	.unlink = efivarfs_unlink,
+	.create = efivarfs_create,
+};
diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
new file mode 100644
index 0000000..b5ff16a
--- /dev/null
+++ b/fs/efivarfs/internal.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2012 Jeremy Kerr <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef EFIVAR_FS_INTERNAL_H
+#define EFIVAR_FS_INTERNAL_H
+
+#include <linux/list.h>
+
+extern const struct file_operations efivarfs_file_operations;
+extern const struct inode_operations efivarfs_dir_inode_operations;
+extern bool efivarfs_valid_name(const char *str, int len);
+extern struct inode *efivarfs_get_inode(struct super_block *sb,
+			const struct inode *dir, int mode, dev_t dev);
+
+extern struct list_head efivarfs_list;
+
+#endif /* EFIVAR_FS_INTERNAL_H */
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
new file mode 100644
index 0000000..bfbd425
--- /dev/null
+++ b/fs/efivarfs/super.c
@@ -0,0 +1,266 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2012 Jeremy Kerr <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ctype.h>
+#include <linux/efi.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/pagemap.h>
+
+#include "internal.h"
+
+LIST_HEAD(efivarfs_list);
+
+static void efivarfs_evict_inode(struct inode *inode)
+{
+	clear_inode(inode);
+}
+
+static const struct super_operations efivarfs_ops = {
+	.statfs = simple_statfs,
+	.drop_inode = generic_delete_inode,
+	.evict_inode = efivarfs_evict_inode,
+	.show_options = generic_show_options,
+};
+
+static struct super_block *efivarfs_sb;
+
+/*
+ * Compare two efivarfs file names.
+ *
+ * An efivarfs filename is composed of two parts,
+ *
+ *	1. A case-sensitive variable name
+ *	2. A case-insensitive GUID
+ *
+ * So we need to perform a case-sensitive match on part 1 and a
+ * case-insensitive match on part 2.
+ */
+static int efivarfs_d_compare(const struct dentry *parent, const struct inode *pinode,
+			      const struct dentry *dentry, const struct inode *inode,
+			      unsigned int len, const char *str,
+			      const struct qstr *name)
+{
+	int guid = len - EFI_VARIABLE_GUID_LEN;
+
+	if (name->len != len)
+		return 1;
+
+	/* Case-sensitive compare for the variable name */
+	if (memcmp(str, name->name, guid))
+		return 1;
+
+	/* Case-insensitive compare for the GUID */
+	return strncasecmp(name->name + guid, str + guid, EFI_VARIABLE_GUID_LEN);
+}
+
+static int efivarfs_d_hash(const struct dentry *dentry,
+			   const struct inode *inode, struct qstr *qstr)
+{
+	unsigned long hash = init_name_hash();
+	const unsigned char *s = qstr->name;
+	unsigned int len = qstr->len;
+
+	if (!efivarfs_valid_name(s, len))
+		return -EINVAL;
+
+	while (len-- > EFI_VARIABLE_GUID_LEN)
+		hash = partial_name_hash(*s++, hash);
+
+	/* GUID is case-insensitive. */
+	while (len--)
+		hash = partial_name_hash(tolower(*s++), hash);
+
+	qstr->hash = end_name_hash(hash);
+	return 0;
+}
+
+/*
+ * Retaining negative dentries for an in-memory filesystem just wastes
+ * memory and lookup time: arrange for them to be deleted immediately.
+ */
+static int efivarfs_delete_dentry(const struct dentry *dentry)
+{
+	return 1;
+}
+
+static struct dentry_operations efivarfs_d_ops = {
+	.d_compare = efivarfs_d_compare,
+	.d_hash = efivarfs_d_hash,
+	.d_delete = efivarfs_delete_dentry,
+};
+
+static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
+{
+	struct dentry *d;
+	struct qstr q;
+	int err;
+
+	q.name = name;
+	q.len = strlen(name);
+
+	err = efivarfs_d_hash(NULL, NULL, &q);
+	if (err)
+		return ERR_PTR(err);
+
+	d = d_alloc(parent, &q);
+	if (d)
+		return d;
+
+	return ERR_PTR(-ENOMEM);
+}
+
+static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
+			     unsigned long name_size, void *data)
+{
+	struct super_block *sb = (struct super_block *)data;
+	struct efivar_entry *entry;
+	struct inode *inode = NULL;
+	struct dentry *dentry, *root = sb->s_root;
+	unsigned long size = 0;
+	char *name;
+	int len, i;
+	int err = -ENOMEM;
+
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
+	efivarfs_sb = sb;
+
+	sb->s_maxbytes          = MAX_LFS_FILESIZE;
+	sb->s_blocksize         = PAGE_CACHE_SIZE;
+	sb->s_blocksize_bits    = PAGE_CACHE_SHIFT;
+	sb->s_magic             = EFIVARFS_MAGIC;
+	sb->s_op                = &efivarfs_ops;
+	sb->s_d_op		= &efivarfs_d_ops;
+	sb->s_time_gran         = 1;
+
+	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
+	if (!inode)
+		return -ENOMEM;
+	inode->i_op = &efivarfs_dir_inode_operations;
+
+	root = d_make_root(inode);
+	sb->s_root = root;
+	if (!root)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&efivarfs_list);
+
+	err = efivar_init(efivarfs_callback, (void *)sb, false, &efivarfs_list);
+	if (err)
+		__efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL, NULL);
+
+	return err;
+}
+
+static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
+				    int flags, const char *dev_name, void *data)
+{
+	return mount_single(fs_type, flags, data, efivarfs_fill_super);
+}
+
+static void efivarfs_kill_sb(struct super_block *sb)
+{
+	kill_litter_super(sb);
+	efivarfs_sb = NULL;
+
+	/* Remove all entries and destroy */
+	__efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL, NULL);
+}
+
+static struct file_system_type efivarfs_type = {
+	.name    = "efivarfs",
+	.mount   = efivarfs_mount,
+	.kill_sb = efivarfs_kill_sb,
+};
+
+static __init int efivarfs_init(void)
+{
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return 0;
+
+	if (!efivars_kobject())
+		return 0;
+
+	return register_filesystem(&efivarfs_type);
+}
+
+MODULE_AUTHOR("Matthew Garrett, Jeremy Kerr");
+MODULE_DESCRIPTION("EFI Variable Filesystem");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_FS("efivarfs");
+
+module_init(efivarfs_init);
-- 
1.7.10.4

