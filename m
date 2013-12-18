Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3LRVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:24:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3LRVOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.12 093/118] vfs: split out vfs_getattr_nosec
Date: Wed, 18 Dec 2013 13:12:10 -0800
Message-Id: <20131218211222.087008177@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit b7a6ec52dd4eced4a9bcda9ca85b3c8af84d3c90 upstream.

The filehandle lookup code wants this version of getattr.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/stat.c          |   31 +++++++++++++++++++++++++------
 include/linux/fs.h |    1 +
 2 files changed, 26 insertions(+), 6 deletions(-)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -37,14 +37,21 @@ void generic_fillattr(struct inode *inod
 
 EXPORT_SYMBOL(generic_fillattr);
 
-int vfs_getattr(struct path *path, struct kstat *stat)
+/**
+ * vfs_getattr_nosec - getattr without security checks
+ * @path: file to get attributes from
+ * @stat: structure to return attributes in
+ *
+ * Get attributes without calling security_inode_getattr.
+ *
+ * Currently the only caller other than vfs_getattr is internal to the
+ * filehandle lookup code, which uses only the inode number and returns
+ * no attributes to any user.  Any other code probably wants
+ * vfs_getattr.
+ */
+int vfs_getattr_nosec(struct path *path, struct kstat *stat)
 {
 	struct inode *inode = path->dentry->d_inode;
-	int retval;
-
-	retval = security_inode_getattr(path->mnt, path->dentry);
-	if (retval)
-		return retval;
 
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(path->mnt, path->dentry, stat);
@@ -53,6 +60,18 @@ int vfs_getattr(struct path *path, struc
 	return 0;
 }
 
+EXPORT_SYMBOL(vfs_getattr_nosec);
+
+int vfs_getattr(struct path *path, struct kstat *stat)
+{
+	int retval;
+
+	retval = security_inode_getattr(path->mnt, path->dentry);
+	if (retval)
+		return retval;
+	return vfs_getattr_nosec(path, stat);
+}
+
 EXPORT_SYMBOL(vfs_getattr);
 
 int vfs_fstat(unsigned int fd, struct kstat *stat)
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2504,6 +2504,7 @@ extern int page_symlink(struct inode *in
 extern const struct inode_operations page_symlink_inode_operations;
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
+int vfs_getattr_nosec(struct path *path, struct kstat *stat);
 extern int vfs_getattr(struct path *, struct kstat *);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);


