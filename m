Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab3BMKYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:24:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39140 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3BMKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:23:29 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: kernel@pengutronix.de, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH RFC 4/5] UBIFS: Add security.* XATTR support for the UBIFS
Date: Wed, 13 Feb 2013 11:23:17 +0100
Message-Id: <1360750998-15191-5-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subodh Nijsure <snijsure@grid-net.com>

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 fs/ubifs/dir.c     |   16 +++++++++++
 fs/ubifs/journal.c |    3 +-
 fs/ubifs/super.c   |    1 +
 fs/ubifs/ubifs.h   |    4 +++
 fs/ubifs/xattr.c   |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 8a57477..6aa31b5 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -280,6 +280,10 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0, 0);
 	if (err)
 		goto out_cancel;
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err)
+		goto out_cancel;
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
@@ -742,6 +746,10 @@ static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		ubifs_err("cannot create directory, error %d", err);
 		goto out_cancel;
 	}
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err)
+		goto out_cancel;
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
@@ -818,6 +826,10 @@ static int ubifs_mknod(struct inode *dir, struct dentry *dentry,
 	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0, 0);
 	if (err)
 		goto out_cancel;
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err)
+		goto out_cancel;
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
@@ -894,6 +906,10 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0, 0);
 	if (err)
 		goto out_cancel;
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err)
+		goto out_cancel;
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 6981d7d..b96718a 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -553,7 +553,8 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 
 	dbg_jnl("ino %lu, dent '%.*s', data len %d in dir ino %lu",
 		inode->i_ino, nm->len, nm->name, ui->data_len, dir->i_ino);
-	ubifs_assert(dir_ui->data_len == 0);
+	if (!xent)
+		ubifs_assert(dir_ui->data_len == 0);
 	ubifs_assert(mutex_is_locked(&dir_ui->ui_mutex));
 
 	dlen = UBIFS_DENT_NODE_SZ + nm->len + 1;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ddc0f6a..8b55c43 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2047,6 +2047,7 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	if (c->max_inode_sz > MAX_LFS_FILESIZE)
 		sb->s_maxbytes = c->max_inode_sz = MAX_LFS_FILESIZE;
 	sb->s_op = &ubifs_super_operations;
+	sb->s_xattr = ubifs_xattr_handlers;
 
 	mutex_lock(&c->umount_mutex);
 	err = mount_ubifs(c);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index d133c27..9b1b6d2 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -36,6 +36,7 @@
 #include <linux/mtd/ubi.h>
 #include <linux/pagemap.h>
 #include <linux/backing-dev.h>
+#include <linux/security.h>
 #include "ubifs-media.h"
 
 /* Version of this UBIFS implementation */
@@ -1454,6 +1455,7 @@ extern spinlock_t ubifs_infos_lock;
 extern atomic_long_t ubifs_clean_zn_cnt;
 extern struct kmem_cache *ubifs_inode_slab;
 extern const struct super_operations ubifs_super_operations;
+extern const struct xattr_handler *ubifs_xattr_handlers[];
 extern const struct address_space_operations ubifs_file_address_operations;
 extern const struct file_operations ubifs_file_operations;
 extern const struct inode_operations ubifs_file_inode_operations;
@@ -1740,6 +1742,8 @@ ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
 		       size_t size);
 ssize_t ubifs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 int ubifs_removexattr(struct dentry *dentry, const char *name);
+int ubifs_init_security(struct inode *dentry, struct inode *inode,
+			const struct qstr *qstr);
 
 /* super.c */
 struct inode *ubifs_iget(struct super_block *sb, unsigned long inum);
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index d496aa4..aa81bd3 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -576,3 +576,82 @@ out_free:
 	kfree(xent);
 	return err;
 }
+
+size_t ubifs_security_listxattr(struct dentry *d, char *list, size_t list_size,
+				const char *name, size_t name_len, int flags)
+{
+	const int prefix_len = XATTR_SECURITY_PREFIX_LEN;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_SECURITY_PREFIX, prefix_len);
+		memcpy(list + prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+
+	return total_len;
+}
+
+int ubifs_security_getxattr(struct dentry *d, const char *name,
+			    void *buffer, size_t size, int flags)
+{
+	return ubifs_getxattr(d, name, buffer, size);
+}
+
+int ubifs_security_setxattr(struct dentry *d, const char *name,
+			    const void *value, size_t size,
+			    int flags, int handler_flags)
+{
+	return ubifs_setxattr(d, name, value, size, flags);
+}
+
+struct xattr_handler ubifs_xattr_security_handler = {
+	.prefix = XATTR_SECURITY_PREFIX,
+	.list   = ubifs_security_listxattr,
+	.get    = ubifs_security_getxattr,
+	.set    = ubifs_security_setxattr,
+};
+
+const struct xattr_handler *ubifs_xattr_handlers[] = {
+	&ubifs_xattr_security_handler,
+	NULL
+};
+
+static int ubifs_initxattrs(struct inode *inode,
+			    const struct xattr *xattr_array, void *fs_info)
+{
+	const struct xattr *xattr;
+	char *name;
+	int err = 0;
+
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
+			       strlen(xattr->name) + 1, GFP_NOFS);
+		if (!name) {
+			err = -ENOMEM;
+			break;
+		}
+		strcpy(name, XATTR_SECURITY_PREFIX);
+		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
+		err = __ubifs_setxattr(inode, name, xattr->value,
+				       xattr->value_len, 0);
+		kfree(name);
+		if (err < 0)
+			break;
+	}
+
+	return err;
+}
+
+int ubifs_init_security(struct inode *dentry, struct inode *inode,
+			const struct qstr *qstr)
+{
+	int err;
+
+	mutex_lock(&inode->i_mutex);
+	err = security_inode_init_security(inode, dentry, qstr,
+					   &ubifs_initxattrs, 0);
+	mutex_unlock(&inode->i_mutex);
+
+	return err;
+}
-- 
1.7.10.4

