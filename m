Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaCKSgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:36:00 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:49863 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbaCKSf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:35:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AggOACJXH1NXQz0l/2dsb2JhbABagwaDRr8RAgKBIBd0glMTHCMYgQIkE4d9AdE4jlyEPwSYRAGSLYMuPIEuJA
Date: Tue, 11 Mar 2014 19:37:32 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, davej <davej@redhat.com>
Subject: [PATCH v3] AFFS: mount option to avoid filename truncates
Message-Id: <20140311193732.9bb47b4be693ed64c0cd2c9d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normal behavior for filenames exceeding specific filesystem limits
is to refuse operation.

AFFS standard name length being only 30 characters against 255 for
usual Linux filesystems, original implementation does filename
truncate by default with a define value AFFS_NO_TRUNCATE which can
be enabled but needs module compilation.

This patch adds 'nofilenametruncate' mount option so that user can
easily activate that feature and avoid a lot of problems
(eg overwrite files ...)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/filesystems/affs.txt |  9 ++++++---
 fs/affs/affs.h                     | 20 ++++++++------------
 fs/affs/amigaffs.c                 | 23 +++++++++++++++--------
 fs/affs/namei.c                    | 32 +++++++++++++++++++++++---------
 fs/affs/super.c                    |  6 +++++-
 5 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/Documentation/filesystems/affs.txt b/Documentation/filesystems/affs.txt
index 81ac488..71b63c2 100644
--- a/Documentation/filesystems/affs.txt
+++ b/Documentation/filesystems/affs.txt
@@ -49,6 +49,10 @@ mode=mode	Sets the mode flags to the given (octal) value, regardless
 		This is useful since most of the plain AmigaOS files
 		will map to 600.
 
+nofilenametruncate
+		The file system will return an error when filename exceeds
+		standard maximum filename length (30 characters).
+
 reserved=num	Sets the number of reserved blocks at the start of the
 		partition to num. You should never need this option.
 		Default is 2.
@@ -181,9 +185,8 @@ tested, though several hundred MB have been read and written using
 this fs. For a most up-to-date list of bugs please consult
 fs/affs/Changes.
 
-Filenames are truncated to 30 characters without warning (this
-can be changed by setting the compile-time option AFFS_NO_TRUNCATE
-in include/linux/amigaffs.h).
+By default, filenames are truncated to 30 characters without warning.
+'nofilenametruncate' mount option can change that behavior.
 
 Case is ignored by the affs in filename matching, but Linux shells
 do care about the case. Example (with /wb being an affs mounted fs):
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 3952121..25b23b1 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -5,14 +5,6 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 
-/* AmigaOS allows file names with up to 30 characters length.
- * Names longer than that will be silently truncated. If you
- * want to disallow this, comment out the following #define.
- * Creating filesystem objects with longer names will then
- * result in an error (ENAMETOOLONG).
- */
-/*#define AFFS_NO_TRUNCATE */
-
 /* Ugly macros make the code more pretty. */
 
 #define GET_END_PTR(st,p,sz)		 ((st *)((char *)(p)+((sz)-sizeof(st))))
@@ -28,7 +20,6 @@
 
 #define AFFS_CACHE_SIZE		PAGE_SIZE
 
-#define AFFS_MAX_PREALLOC	32
 #define AFFS_LC_SIZE		(AFFS_CACHE_SIZE/sizeof(u32)/2)
 #define AFFS_AC_SIZE		(AFFS_CACHE_SIZE/sizeof(struct affs_ext_key)/2)
 #define AFFS_AC_MASK		(AFFS_AC_SIZE-1)
@@ -118,6 +109,7 @@ struct affs_sb_info {
 #define SF_OFS		0x0200		/* Old filesystem */
 #define SF_PREFIX	0x0400		/* Buffer for prefix is allocated */
 #define SF_VERBOSE	0x0800		/* Talk about fs when mounting */
+#define SF_NO_TRUNCATE	0x1000		/* Don't truncate filenames */
 
 /* short cut to get to the affs specific sb data */
 static inline struct affs_sb_info *AFFS_SB(struct super_block *sb)
@@ -137,9 +129,13 @@ extern void	affs_fix_checksum(struct super_block *sb, struct buffer_head *bh);
 extern void	secs_to_datestamp(time_t secs, struct affs_date *ds);
 extern umode_t	prot_to_mode(u32 prot);
 extern void	mode_to_prot(struct inode *inode);
-extern void	affs_error(struct super_block *sb, const char *function, const char *fmt, ...);
-extern void	affs_warning(struct super_block *sb, const char *function, const char *fmt, ...);
-extern int	affs_check_name(const unsigned char *name, int len);
+extern void	affs_error(struct super_block *sb, const char *function,
+			   const char *fmt, ...);
+extern void	affs_warning(struct super_block *sb, const char *function,
+			     const char *fmt, ...);
+extern bool	affs_nofilenametruncate(const struct dentry *dentry);
+extern int	affs_check_name(const unsigned char *name, int len,
+				bool notruncate);
 extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
 
 /* bitmap. c */
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index d9a4367..533a322 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -471,20 +471,27 @@ affs_warning(struct super_block *sb, const char *function, const char *fmt, ...)
 		function,ErrorBuffer);
 }
 
+bool
+affs_nofilenametruncate(const struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	return AFFS_SB(inode->i_sb)->s_flags & SF_NO_TRUNCATE;
+
+}
+
 /* Check if the name is valid for a affs object. */
 
 int
-affs_check_name(const unsigned char *name, int len)
+affs_check_name(const unsigned char *name, int len, bool notruncate)
 {
 	int	 i;
 
-	if (len > 30)
-#ifdef AFFS_NO_TRUNCATE
-		return -ENAMETOOLONG;
-#else
-		len = 30;
-#endif
-
+	if (len > 30) {
+		if (notruncate)
+			return -ENAMETOOLONG;
+		else
+			len = 30;
+	}
 	for (i = 0; i < len; i++) {
 		if (name[i] < ' ' || name[i] == ':'
 		    || (name[i] > 0x7e && name[i] < 0xa0))
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index c36cbb4..6dae1cc 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -60,13 +60,13 @@ affs_get_toupper(struct super_block *sb)
  * Note: the dentry argument is the parent dentry.
  */
 static inline int
-__affs_hash_dentry(struct qstr *qstr, toupper_t toupper)
+__affs_hash_dentry(struct qstr *qstr, toupper_t toupper, bool notruncate)
 {
 	const u8 *name = qstr->name;
 	unsigned long hash;
 	int i;
 
-	i = affs_check_name(qstr->name, qstr->len);
+	i = affs_check_name(qstr->name, qstr->len, notruncate);
 	if (i)
 		return i;
 
@@ -82,16 +82,22 @@ __affs_hash_dentry(struct qstr *qstr, toupper_t toupper)
 static int
 affs_hash_dentry(const struct dentry *dentry, struct qstr *qstr)
 {
-	return __affs_hash_dentry(qstr, affs_toupper);
+	return __affs_hash_dentry(qstr, affs_toupper,
+				  affs_nofilenametruncate(dentry));
+
 }
+
 static int
 affs_intl_hash_dentry(const struct dentry *dentry, struct qstr *qstr)
 {
-	return __affs_hash_dentry(qstr, affs_intl_toupper);
+	return __affs_hash_dentry(qstr, affs_intl_toupper,
+				  affs_nofilenametruncate(dentry));
+
 }
 
 static inline int __affs_compare_dentry(unsigned int len,
-		const char *str, const struct qstr *name, toupper_t toupper)
+		const char *str, const struct qstr *name, toupper_t toupper,
+		bool notruncate)
 {
 	const u8 *aname = str;
 	const u8 *bname = name->name;
@@ -101,7 +107,7 @@ static inline int __affs_compare_dentry(unsigned int len,
 	 * must be valid. 'name' must be validated first.
 	 */
 
-	if (affs_check_name(name->name, name->len))
+	if (affs_check_name(name->name, name->len, notruncate))
 		return 1;
 
 	/*
@@ -126,13 +132,18 @@ static int
 affs_compare_dentry(const struct dentry *parent, const struct dentry *dentry,
 		unsigned int len, const char *str, const struct qstr *name)
 {
-	return __affs_compare_dentry(len, str, name, affs_toupper);
+
+	return __affs_compare_dentry(len, str, name, affs_toupper,
+				     affs_nofilenametruncate(parent));
 }
+
 static int
 affs_intl_compare_dentry(const struct dentry *parent, const struct dentry *dentry,
 		unsigned int len, const char *str, const struct qstr *name)
 {
-	return __affs_compare_dentry(len, str, name, affs_intl_toupper);
+	return __affs_compare_dentry(len, str, name, affs_intl_toupper,
+				     affs_nofilenametruncate(parent));
+
 }
 
 /*
@@ -411,7 +422,10 @@ affs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		 (u32)old_dir->i_ino, (int)old_dentry->d_name.len, old_dentry->d_name.name,
 		 (u32)new_dir->i_ino, (int)new_dentry->d_name.len, new_dentry->d_name.name);
 
-	retval = affs_check_name(new_dentry->d_name.name,new_dentry->d_name.len);
+	retval = affs_check_name(new_dentry->d_name.name,
+				 new_dentry->d_name.len,
+				 affs_nofilenametruncate(old_dentry));
+
 	if (retval)
 		return retval;
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index d098731..4c27c7e 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -163,7 +163,7 @@ static const struct super_operations affs_sops = {
 };
 
 enum {
-	Opt_bs, Opt_mode, Opt_mufs, Opt_prefix, Opt_protect,
+	Opt_bs, Opt_mode, Opt_mufs, Opt_notruncate, Opt_prefix, Opt_protect,
 	Opt_reserved, Opt_root, Opt_setgid, Opt_setuid,
 	Opt_verbose, Opt_volume, Opt_ignore, Opt_err,
 };
@@ -172,6 +172,7 @@ static const match_table_t tokens = {
 	{Opt_bs, "bs=%u"},
 	{Opt_mode, "mode=%o"},
 	{Opt_mufs, "mufs"},
+	{Opt_notruncate, "nofilenametruncate"},
 	{Opt_prefix, "prefix=%s"},
 	{Opt_protect, "protect"},
 	{Opt_reserved, "reserved=%u"},
@@ -233,6 +234,9 @@ parse_options(char *options, kuid_t *uid, kgid_t *gid, int *mode, int *reserved,
 		case Opt_mufs:
 			*mount_opts |= SF_MUFS;
 			break;
+		case Opt_notruncate:
+			*mount_opts |= SF_NO_TRUNCATE;
+			break;
 		case Opt_prefix:
 			*prefix = match_strdup(&args[0]);
 			if (!*prefix)
-- 
1.8.1.4

