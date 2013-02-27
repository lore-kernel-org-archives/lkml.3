Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3B0XLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:11:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3B0XLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:11:16 -0500
Date: Wed, 27 Feb 2013 15:09:42 -0800
Message-Id: <201302272309.r1RN9gVp020245@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/efi for v3.9-rc1
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Whitcroft <apw@canonical.com>,
        Chun-Yi Lee <joeyli.kernel@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, Lee@zytor.com,
        Chun-Yi <jlee@suse.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 27 Feb 2013 15:09:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset came in to us late, but it seems fairly innocuous and is
mostly fixes anyway.

The following changes since commit 04c2eee5b9dfcb13f3cd07a5537fb8c785f2751a:

  Merge branch 'x86-efi-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-01-31 17:10:36 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

for you to fetch changes up to 6b59e366e074d3962e04f01efb8acc10a33c0e1e:

  x86, efi: remove duplicate code in setup_arch() by using, efi_is_native() (2013-02-14 10:36:18 +0000)

----------------------------------------------------------------
EFI changes for v3.9-rc1,

 * Improve the initrd handling in the EFI boot stub by allowing
   forward slashes in the pathname - from Chun-Yi Lee.

 * Cleanup code duplication in the EFI mixed kernel/firmware code -
   from Satoru Takeuchi.

 * efivarfs bug fixes for more strict filename validation, with lots
   of input from Al Viro.

----------------------------------------------------------------
Lee, Chun-Yi (1):
      x86, efi: Allow slash in file path of initrd

Matt Fleming (3):
      efivarfs: Use sizeof() instead of magic number
      efivarfs: Validate filenames much more aggressively
      efivarfs: guid part of filenames are case-insensitive

Satoru Takeuchi (1):
      x86, efi: remove duplicate code in setup_arch() by using, efi_is_native()

 arch/x86/boot/compressed/eboot.c |  26 +++++--
 arch/x86/include/asm/efi.h       |   9 ++-
 arch/x86/kernel/setup.c          |   3 +-
 arch/x86/platform/efi/efi.c      |   5 --
 drivers/firmware/efivars.c       | 146 ++++++++++++++++++++++++++++++++++++---
 5 files changed, 166 insertions(+), 23 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f8fa411..c205035 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -19,23 +19,28 @@
 
 static efi_system_table_t *sys_table;
 
+static void efi_char16_printk(efi_char16_t *str)
+{
+	struct efi_simple_text_output_protocol *out;
+
+	out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
+	efi_call_phys2(out->output_string, out, str);
+}
+
 static void efi_printk(char *str)
 {
 	char *s8;
 
 	for (s8 = str; *s8; s8++) {
-		struct efi_simple_text_output_protocol *out;
 		efi_char16_t ch[2] = { 0 };
 
 		ch[0] = *s8;
-		out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
-
 		if (*s8 == '\n') {
 			efi_char16_t nl[2] = { '\r', 0 };
-			efi_call_phys2(out->output_string, out, nl);
+			efi_char16_printk(nl);
 		}
 
-		efi_call_phys2(out->output_string, out, ch);
+		efi_char16_printk(ch);
 	}
 }
 
@@ -709,7 +714,12 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 			if ((u8 *)p >= (u8 *)filename_16 + sizeof(filename_16))
 				break;
 
-			*p++ = *str++;
+			if (*str == '/') {
+				*p++ = '\\';
+				*str++;
+			} else {
+				*p++ = *str++;
+			}
 		}
 
 		*p = '\0';
@@ -737,7 +747,9 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to open initrd file\n");
+			efi_printk("Failed to open initrd file: ");
+			efi_char16_printk(filename_16);
+			efi_printk("\n");
 			goto close_handles;
 		}
 
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 28677c5..60c89f3 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -102,7 +102,14 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 
-#ifndef CONFIG_EFI
+#ifdef CONFIG_EFI
+
+static inline bool efi_is_native(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
+}
+
+#else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
  */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8b24289..1abb796 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1135,8 +1135,7 @@ void __init setup_arch(char **cmdline_p)
 	 * mismatched firmware/kernel archtectures since there is no
 	 * support for runtime services.
 	 */
-	if (efi_enabled(EFI_BOOT) &&
-	    IS_ENABLED(CONFIG_X86_64) != efi_enabled(EFI_64BIT)) {
+	if (efi_enabled(EFI_BOOT) && !efi_is_native()) {
 		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
 		efi_unmap_memmap();
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 77cf009..e075e47 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -69,11 +69,6 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
-static inline bool efi_is_native(void)
-{
-	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
-}
-
 unsigned long x86_efi_facility;
 
 /*
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index f5596db..8bcb595 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -79,6 +79,7 @@
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/pstore.h>
+#include <linux/ctype.h>
 
 #include <linux/fs.h>
 #include <linux/ramfs.h>
@@ -900,6 +901,48 @@ static struct inode *efivarfs_get_inode(struct super_block *sb,
 	return inode;
 }
 
+/*
+ * Return true if 'str' is a valid efivarfs filename of the form,
+ *
+ *	VariableName-12345678-1234-1234-1234-1234567891bc
+ */
+static bool efivarfs_valid_name(const char *str, int len)
+{
+	static const char dashes[GUID_LEN] = {
+		[8] = 1, [13] = 1, [18] = 1, [23] = 1
+	};
+	const char *s = str + len - GUID_LEN;
+	int i;
+
+	/*
+	 * We need a GUID, plus at least one letter for the variable name,
+	 * plus the '-' separator
+	 */
+	if (len < GUID_LEN + 2)
+		return false;
+
+	/* GUID should be right after the first '-' */
+	if (s - 1 != strchr(str, '-'))
+		return false;
+
+	/*
+	 * Validate that 's' is of the correct format, e.g.
+	 *
+	 *	12345678-1234-1234-1234-123456789abc
+	 */
+	for (i = 0; i < GUID_LEN; i++) {
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
 static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
 {
 	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
@@ -928,11 +971,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
 
-	/*
-	 * We need a GUID, plus at least one letter for the variable name,
-	 * plus the '-' separator
-	 */
-	if (dentry->d_name.len < GUID_LEN + 2)
+	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
 		return -EINVAL;
 
 	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
@@ -1004,6 +1043,84 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 	return -EINVAL;
 };
 
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
+	int guid = len - GUID_LEN;
+
+	if (name->len != len)
+		return 1;
+
+	/* Case-sensitive compare for the variable name */
+	if (memcmp(str, name->name, guid))
+		return 1;
+
+	/* Case-insensitive compare for the GUID */
+	return strncasecmp(name->name + guid, str + guid, GUID_LEN);
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
+	while (len-- > GUID_LEN)
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
+	struct qstr q;
+
+	q.name = name;
+	q.len = strlen(name);
+
+	if (efivarfs_d_hash(NULL, NULL, &q))
+		return NULL;
+
+	return d_alloc(parent, &q);
+}
+
 static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode = NULL;
@@ -1019,6 +1136,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_blocksize_bits    = PAGE_CACHE_SHIFT;
 	sb->s_magic             = EFIVARFS_MAGIC;
 	sb->s_op                = &efivarfs_ops;
+	sb->s_d_op		= &efivarfs_d_ops;
 	sb->s_time_gran         = 1;
 
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
@@ -1059,7 +1177,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 		if (!inode)
 			goto fail_name;
 
-		dentry = d_alloc_name(root, name);
+		dentry = efivarfs_alloc_dentry(root, name);
 		if (!dentry)
 			goto fail_inode;
 
@@ -1076,7 +1194,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		mutex_lock(&inode->i_mutex);
 		inode->i_private = entry;
-		i_size_write(inode, size+4);
+		i_size_write(inode, size + sizeof(entry->var.Attributes));
 		mutex_unlock(&inode->i_mutex);
 		d_add(dentry, inode);
 	}
@@ -1109,8 +1227,20 @@ static struct file_system_type efivarfs_type = {
 	.kill_sb = efivarfs_kill_sb,
 };
 
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
 static const struct inode_operations efivarfs_dir_inode_operations = {
-	.lookup = simple_lookup,
+	.lookup = efivarfs_lookup,
 	.unlink = efivarfs_unlink,
 	.create = efivarfs_create,
 };
