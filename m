Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaL0VTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 16:19:18 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:15268 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbaL0VTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 16:19:16 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsQAJwhn1Rbsnvc/2dsb2JhbABcgwaBKrQcBQEBAQEBAQUBd5c2gQgXAQEBAQF9hDovI4EaN4gwAbU8jz2GA4l0hDAFhSeITYkUgQ2FGIsrIoFFAYIpPTGCQwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Harkes <jaharkes@cs.cmu.edu>,
        Andrew Morton <akpm@linux-foundation.org>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu
Subject: [PATCH 1/1 linux-next] fs/coda/dir.c: forward declaration clean-up
Date: Sat, 27 Dec 2014 22:19:07 +0100
Message-Id: <1419715147-13189-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Move operation structures to avoid forward declarations.
-Fix some checkpatch warnings:

WARNING: Missing a blank line after declarations
+		struct inode *host_inode = file_inode(host_file);
+		mutex_lock(&host_inode->i_mutex);

ERROR: that open brace { should be on the previous line
+const struct dentry_operations coda_dentry_operations =
+{

ERROR: that open brace { should be on the previous line
+const struct inode_operations coda_dir_inode_operations =
+{

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/coda/dir.c | 138 ++++++++++++++++++++++++----------------------------------
 1 file changed, 56 insertions(+), 82 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 86c8938..281ee01 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -28,29 +28,6 @@
 
 #include "coda_int.h"
 
-/* dir inode-ops */
-static int coda_create(struct inode *dir, struct dentry *new, umode_t mode, bool excl);
-static struct dentry *coda_lookup(struct inode *dir, struct dentry *target, unsigned int flags);
-static int coda_link(struct dentry *old_dentry, struct inode *dir_inode, 
-		     struct dentry *entry);
-static int coda_unlink(struct inode *dir_inode, struct dentry *entry);
-static int coda_symlink(struct inode *dir_inode, struct dentry *entry,
-			const char *symname);
-static int coda_mkdir(struct inode *dir_inode, struct dentry *entry, umode_t mode);
-static int coda_rmdir(struct inode *dir_inode, struct dentry *entry);
-static int coda_rename(struct inode *old_inode, struct dentry *old_dentry, 
-                       struct inode *new_inode, struct dentry *new_dentry);
-
-/* dir file-ops */
-static int coda_readdir(struct file *file, struct dir_context *ctx);
-
-/* dentry ops */
-static int coda_dentry_revalidate(struct dentry *de, unsigned int flags);
-static int coda_dentry_delete(const struct dentry *);
-
-/* support routines */
-static int coda_venus_readdir(struct file *, struct dir_context *);
-
 /* same as fs/bad_inode.c */
 static int coda_return_EIO(void)
 {
@@ -58,38 +35,6 @@ static int coda_return_EIO(void)
 }
 #define CODA_EIO_ERROR ((void *) (coda_return_EIO))
 
-const struct dentry_operations coda_dentry_operations =
-{
-	.d_revalidate	= coda_dentry_revalidate,
-	.d_delete	= coda_dentry_delete,
-};
-
-const struct inode_operations coda_dir_inode_operations =
-{
-	.create		= coda_create,
-	.lookup		= coda_lookup,
-	.link		= coda_link,
-	.unlink		= coda_unlink,
-	.symlink	= coda_symlink,
-	.mkdir		= coda_mkdir,
-	.rmdir		= coda_rmdir,
-	.mknod		= CODA_EIO_ERROR,
-	.rename		= coda_rename,
-	.permission	= coda_permission,
-	.getattr	= coda_getattr,
-	.setattr	= coda_setattr,
-};
-
-const struct file_operations coda_dir_operations = {
-	.llseek		= generic_file_llseek,
-	.read		= generic_read_dir,
-	.iterate	= coda_readdir,
-	.open		= coda_open,
-	.release	= coda_release,
-	.fsync		= coda_fsync,
-};
-
-
 /* inode operations for directories */
 /* access routines: lookup, readlink, permission */
 static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, unsigned int flags)
@@ -374,33 +319,6 @@ static int coda_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return error;
 }
 
-
-/* file operations for directories */
-static int coda_readdir(struct file *coda_file, struct dir_context *ctx)
-{
-	struct coda_file_info *cfi;
-	struct file *host_file;
-	int ret;
-
-	cfi = CODA_FTOC(coda_file);
-	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
-	host_file = cfi->cfi_container;
-
-	if (host_file->f_op->iterate) {
-		struct inode *host_inode = file_inode(host_file);
-		mutex_lock(&host_inode->i_mutex);
-		ret = -ENOENT;
-		if (!IS_DEADDIR(host_inode)) {
-			ret = host_file->f_op->iterate(host_file, ctx);
-			file_accessed(host_file);
-		}
-		mutex_unlock(&host_inode->i_mutex);
-		return ret;
-	}
-	/* Venus: we must read Venus dirents from a file */
-	return coda_venus_readdir(coda_file, ctx);
-}
-
 static inline unsigned int CDT2DT(unsigned char cdt)
 {
 	unsigned int dt;
@@ -495,6 +413,33 @@ out:
 	return 0;
 }
 
+/* file operations for directories */
+static int coda_readdir(struct file *coda_file, struct dir_context *ctx)
+{
+	struct coda_file_info *cfi;
+	struct file *host_file;
+	int ret;
+
+	cfi = CODA_FTOC(coda_file);
+	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
+	host_file = cfi->cfi_container;
+
+	if (host_file->f_op->iterate) {
+		struct inode *host_inode = file_inode(host_file);
+
+		mutex_lock(&host_inode->i_mutex);
+		ret = -ENOENT;
+		if (!IS_DEADDIR(host_inode)) {
+			ret = host_file->f_op->iterate(host_file, ctx);
+			file_accessed(host_file);
+		}
+		mutex_unlock(&host_inode->i_mutex);
+		return ret;
+	}
+	/* Venus: we must read Venus dirents from a file */
+	return coda_venus_readdir(coda_file, ctx);
+}
+
 /* called when a cache lookup succeeds */
 static int coda_dentry_revalidate(struct dentry *de, unsigned int flags)
 {
@@ -603,3 +548,32 @@ int coda_revalidate_inode(struct inode *inode)
 	}
 	return 0;
 }
+
+const struct dentry_operations coda_dentry_operations = {
+	.d_revalidate	= coda_dentry_revalidate,
+	.d_delete	= coda_dentry_delete,
+};
+
+const struct inode_operations coda_dir_inode_operations = {
+	.create		= coda_create,
+	.lookup		= coda_lookup,
+	.link		= coda_link,
+	.unlink		= coda_unlink,
+	.symlink	= coda_symlink,
+	.mkdir		= coda_mkdir,
+	.rmdir		= coda_rmdir,
+	.mknod		= CODA_EIO_ERROR,
+	.rename		= coda_rename,
+	.permission	= coda_permission,
+	.getattr	= coda_getattr,
+	.setattr	= coda_setattr,
+};
+
+const struct file_operations coda_dir_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= generic_read_dir,
+	.iterate	= coda_readdir,
+	.open		= coda_open,
+	.release	= coda_release,
+	.fsync		= coda_fsync,
+};
-- 
2.1.0

