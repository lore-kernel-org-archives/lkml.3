Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422741Ab3LFWYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:24:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161219Ab3LFVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 3.12 76/83] take anon inode allocation to libfs.c
Date: Fri,  6 Dec 2013 13:52:06 -0800
Message-Id: <20131206214647.108545281@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 6987843ff7e836ea65b554905aec34d2fad05c94 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/anon_inodes.c   |   50 ++------------------------------------------------
 fs/libfs.c         |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    1 +
 3 files changed, 46 insertions(+), 48 deletions(-)

--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -24,7 +24,6 @@
 
 static struct vfsmount *anon_inode_mnt __read_mostly;
 static struct inode *anon_inode_inode;
-static const struct file_operations anon_inode_fops;
 
 /*
  * anon_inodefs_dname() is called from d_path().
@@ -39,51 +38,6 @@ static const struct dentry_operations an
 	.d_dname	= anon_inodefs_dname,
 };
 
-/*
- * nop .set_page_dirty method so that people can use .page_mkwrite on
- * anon inodes.
- */
-static int anon_set_page_dirty(struct page *page)
-{
-	return 0;
-};
-
-static const struct address_space_operations anon_aops = {
-	.set_page_dirty = anon_set_page_dirty,
-};
-
-/*
- * A single inode exists for all anon_inode files. Contrary to pipes,
- * anon_inode inodes have no associated per-instance data, so we need
- * only allocate one of them.
- */
-static struct inode *anon_inode_mkinode(struct super_block *s)
-{
-	struct inode *inode = new_inode_pseudo(s);
-
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-
-	inode->i_ino = get_next_ino();
-	inode->i_fop = &anon_inode_fops;
-
-	inode->i_mapping->a_ops = &anon_aops;
-
-	/*
-	 * Mark the inode dirty from the very beginning,
-	 * that way it will never be moved to the dirty
-	 * list because mark_inode_dirty() will think
-	 * that it already _is_ on the dirty list.
-	 */
-	inode->i_state = I_DIRTY;
-	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current_fsuid();
-	inode->i_gid = current_fsgid();
-	inode->i_flags |= S_PRIVATE;
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	return inode;
-}
-
 static struct dentry *anon_inodefs_mount(struct file_system_type *fs_type,
 				int flags, const char *dev_name, void *data)
 {
@@ -92,7 +46,7 @@ static struct dentry *anon_inodefs_mount
 			&anon_inodefs_dentry_operations, ANON_INODE_FS_MAGIC);
 	if (!IS_ERR(root)) {
 		struct super_block *s = root->d_sb;
-		anon_inode_inode = anon_inode_mkinode(s);
+		anon_inode_inode = alloc_anon_inode(s);
 		if (IS_ERR(anon_inode_inode)) {
 			dput(root);
 			deactivate_locked_super(s);
@@ -134,7 +88,7 @@ struct file *anon_inode_getfile_private(
 	if (fops->owner && !try_module_get(fops->owner))
 		return ERR_PTR(-ENOENT);
 
-	inode = anon_inode_mkinode(anon_inode_mnt->mnt_sb);
+	inode = alloc_anon_inode(anon_inode_mnt->mnt_sb);
 	if (IS_ERR(inode)) {
 		file = ERR_PTR(-ENOMEM);
 		goto err_module;
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -993,3 +993,46 @@ EXPORT_SYMBOL_GPL(simple_attr_open);
 EXPORT_SYMBOL_GPL(simple_attr_release);
 EXPORT_SYMBOL_GPL(simple_attr_read);
 EXPORT_SYMBOL_GPL(simple_attr_write);
+
+/*
+ * nop .set_page_dirty method so that people can use .page_mkwrite on
+ * anon inodes.
+ */
+static int anon_set_page_dirty(struct page *page)
+{
+	return 0;
+};
+
+/*
+ * A single inode exists for all anon_inode files. Contrary to pipes,
+ * anon_inode inodes have no associated per-instance data, so we need
+ * only allocate one of them.
+ */
+struct inode *alloc_anon_inode(struct super_block *s)
+{
+	static const struct address_space_operations anon_aops = {
+		.set_page_dirty = anon_set_page_dirty,
+	};
+	struct inode *inode = new_inode_pseudo(s);
+
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_ino = get_next_ino();
+	inode->i_mapping->a_ops = &anon_aops;
+
+	/*
+	 * Mark the inode dirty from the very beginning,
+	 * that way it will never be moved to the dirty
+	 * list because mark_inode_dirty() will think
+	 * that it already _is_ on the dirty list.
+	 */
+	inode->i_state = I_DIRTY;
+	inode->i_mode = S_IRUSR | S_IWUSR;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
+	inode->i_flags |= S_PRIVATE;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	return inode;
+}
+EXPORT_SYMBOL(alloc_anon_inode);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2562,6 +2562,7 @@ extern int simple_write_begin(struct fil
 extern int simple_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata);
+extern struct inode *alloc_anon_inode(struct super_block *);
 
 extern struct dentry *simple_lookup(struct inode *, struct dentry *, unsigned int flags);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);


