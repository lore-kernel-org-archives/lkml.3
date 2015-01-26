Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbbAZPMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:12:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:49475 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753133AbbAZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:02 -0500
Message-Id: <20150126151000.033891964@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 08/16 v3] fold debugfs_mknod() into callers
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0008-fold-debugfs_mknod-into-callers.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 68 +++++++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 778c0e32eb51..b765c04eba20 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -69,21 +69,6 @@ static struct inode *debugfs_get_inode(struct super_block *sb, umode_t mode, dev
 	return inode;
 }
 
-/* SMP-safe */
-static int debugfs_mknod(struct dentry *dentry,
-			 umode_t mode, void *data,
-			 const struct file_operations *fops)
-{
-	struct inode *inode;
-
-	inode = debugfs_get_inode(dentry->d_sb, mode, 0, data, fops);
-	if (unlikely(!inode))
-		return -EPERM;
-	d_instantiate(dentry, inode);
-	dget(dentry);
-	return 0;
-}
-
 static inline int debugfs_positive(struct dentry *dentry)
 {
 	return dentry->d_inode && !d_unhashed(dentry);
@@ -339,7 +324,7 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
 				   const struct file_operations *fops)
 {
 	struct dentry *dentry;
-	int error;
+	struct inode *inode;
 
 	if (!(mode & S_IFMT))
 		mode |= S_IFREG;
@@ -349,10 +334,14 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
 	if (IS_ERR(dentry))
 		return NULL;
 
-	error = debugfs_mknod(dentry, mode, data, fops);
-	if (!error)
-		fsnotify_create(dentry->d_parent->d_inode, dentry);
-	return end_creating(dentry, error);
+	inode = debugfs_get_inode(dentry->d_sb, mode, 0, data, fops);
+	if (unlikely(!inode))
+		return end_creating(dentry, -ENOMEM);
+
+	d_instantiate(dentry, inode);
+	dget(dentry);
+	fsnotify_create(dentry->d_parent->d_inode, dentry);
+	return end_creating(dentry, 0);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_file);
 
@@ -377,18 +366,22 @@ EXPORT_SYMBOL_GPL(debugfs_create_file);
 struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 {
 	struct dentry *dentry = start_creating(name, parent);
-	int error;
+	struct inode *inode;
 
 	if (IS_ERR(dentry))
 		return NULL;
 
-	error = debugfs_mknod(dentry, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
-			      NULL, NULL);
-	if (!error) {
-		inc_nlink(dentry->d_parent->d_inode);
-		fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
-	}
-	return end_creating(dentry, error);
+	inode = debugfs_get_inode(dentry->d_sb,
+				  S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+				  0, NULL, NULL);
+	if (unlikely(!inode))
+		return end_creating(dentry, -ENOMEM);
+
+	d_instantiate(dentry, inode);
+	dget(dentry);
+	inc_nlink(dentry->d_parent->d_inode);
+	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
+	return end_creating(dentry, 0);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_dir);
 
@@ -419,25 +412,26 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *target)
 {
 	struct dentry *dentry;
-	char *link;
-	int error;
-
-	link = kstrdup(target, GFP_KERNEL);
+	struct inode *inode;
+	char *link = kstrdup(target, GFP_KERNEL);
 	if (!link)
 		return NULL;
 
 	dentry = start_creating(name, parent);
-
 	if (IS_ERR(dentry)) {
 		kfree(link);
 		return NULL;
 	}
 
-	error = debugfs_mknod(dentry, S_IFLNK | S_IRWXUGO, link, NULL);
-	if (error)
+	inode = debugfs_get_inode(dentry->d_sb, S_IFLNK | S_IRWXUGO, 0,
+				  link, NULL);
+	if (unlikely(!inode)) {
 		kfree(link);
-
-	return end_creating(dentry, error);
+		return end_creating(dentry, -ENOMEM);
+	}
+	d_instantiate(dentry, inode);
+	dget(dentry);
+	return end_creating(dentry, 0);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 
-- 
2.1.4


