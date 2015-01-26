Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbbAZPLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:11:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:24103 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753554AbbAZPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:03 -0500
Message-Id: <20150126151000.591122281@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 11/16 v3] new primitive: debugfs_create_automount()
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0011-new-primitive-debugfs_create_automount.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c      | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h |  5 +++++
 2 files changed, 53 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 1219dff8e18f..957c40ce09f6 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -175,6 +175,18 @@ static const struct super_operations debugfs_super_operations = {
 	.show_options	= debugfs_show_options,
 };
 
+static struct vfsmount *debugfs_automount(struct path *path)
+{
+	struct vfsmount *(*f)(void *);
+	f = (struct vfsmount *(*)(void *))path->dentry->d_fsdata;
+	return f(path->dentry->d_inode->i_private);
+}
+
+static const struct dentry_operations debugfs_dops = {
+	.d_delete = always_delete_dentry,
+	.d_automount = debugfs_automount,
+};
+
 static int debug_fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr debug_files[] = {{""}};
@@ -199,6 +211,7 @@ static int debug_fill_super(struct super_block *sb, void *data, int silent)
 		goto fail;
 
 	sb->s_op = &debugfs_super_operations;
+	sb->s_d_op = &debugfs_dops;
 
 	debugfs_apply_options(sb);
 
@@ -368,6 +381,41 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 EXPORT_SYMBOL_GPL(debugfs_create_dir);
 
 /**
+ * debugfs_create_automount - create automount point in the debugfs filesystem
+ * @name: a pointer to a string containing the name of the file to create.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @f: function to be called when pathname resolution steps on that one.
+ * @data: opaque argument to pass to f().
+ *
+ * @f should return what ->d_automount() would.
+ */
+struct dentry *debugfs_create_automount(const char *name,
+					struct dentry *parent,
+					struct vfsmount *(*f)(void *),
+					void *data)
+{
+	struct dentry *dentry = start_creating(name, parent);
+	struct inode *inode;
+
+	if (IS_ERR(dentry))
+		return NULL;
+
+	inode = debugfs_get_inode(dentry->d_sb);
+	if (unlikely(!inode))
+		return failed_creating(dentry);
+
+	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
+	inode->i_flags |= S_AUTOMOUNT;
+	inode->i_private = data;
+	dentry->d_fsdata = (void *)f;
+	d_instantiate(dentry, inode);
+	return end_creating(dentry);
+}
+EXPORT_SYMBOL(debugfs_create_automount);
+
+/**
  * debugfs_create_symlink- create a symbolic link in the debugfs filesystem
  * @name: a pointer to a string containing the name of the symbolic link to
  *        create.
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index da4c4983adbe..ea149a24a1f2 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -56,6 +56,11 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent);
 struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *dest);
 
+struct dentry *debugfs_create_automount(const char *name,
+					struct dentry *parent,
+					struct vfsmount *(*f)(void *),
+					void *data);
+
 void debugfs_remove(struct dentry *dentry);
 void debugfs_remove_recursive(struct dentry *dentry);
 
-- 
2.1.4


