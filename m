Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaA1XdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:33:13 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:57518 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbaA1XdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:33:09 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] kernfs: implement kernfs_node_from_dentry(), kernfs_root_from_sb() and kernfs_rename()
Date: Tue, 28 Jan 2014 18:32:50 -0500
Message-Id: <1390951971-15671-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951971-15671-1-git-send-email-tj@kernel.org>
References: <1390951971-15671-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement helpers to determine node from dentry and root from
super_block.  Also add a kernfs_rename_ns() wrapper which assumes NULL
namespace.  These generally make sense and will be used by cgroup.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 18 ++++++++++++++++++
 fs/kernfs/mount.c      | 14 ++++++++++++++
 include/linux/kernfs.h | 16 ++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 3cff0a2..42a250f 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -350,6 +350,24 @@ const struct dentry_operations kernfs_dops = {
 	.d_release	= kernfs_dop_release,
 };
 
+/**
+ * kernfs_node_from_dentry - determine kernfs_node associated with a dentry
+ * @dentry: the dentry in question
+ *
+ * Return the kernfs_node associated with @dentry.  If @dentry is not a
+ * kernfs one, %NULL is returned.
+ *
+ * While the returned kernfs_node will stay accessible as long as @dentry
+ * is accessible, the returned node can be in any state and the caller is
+ * fully responsible for determining what's accessible.
+ */
+struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry)
+{
+	if (dentry->d_op == &kernfs_dops)
+		return dentry->d_fsdata;
+	return NULL;
+}
+
 static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 					     const char *name, umode_t mode,
 					     unsigned flags)
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 70cc698..e5b28b0 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -48,6 +48,20 @@ static const struct super_operations kernfs_sops = {
 	.show_options	= kernfs_sop_show_options,
 };
 
+/**
+ * kernfs_root_from_sb - determine kernfs_root associated with a super_block
+ * @sb: the super_block in question
+ *
+ * Return the kernfs_root associated with @sb.  If @sb is not a kernfs one,
+ * %NULL is returned.
+ */
+struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
+{
+	if (sb->s_op == &kernfs_sops)
+		return kernfs_info(sb)->root;
+	return NULL;
+}
+
 static int kernfs_fill_super(struct super_block *sb)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 9ca0f09..9c89904 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -234,6 +234,9 @@ struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
 void kernfs_get(struct kernfs_node *kn);
 void kernfs_put(struct kernfs_node *kn);
 
+struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry);
+struct kernfs_root *kernfs_root_from_sb(struct super_block *sb);
+
 struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
 				       unsigned int flags, void *priv);
 void kernfs_destroy_root(struct kernfs_root *root);
@@ -288,6 +291,12 @@ kernfs_find_and_get_ns(struct kernfs_node *parent, const char *name,
 static inline void kernfs_get(struct kernfs_node *kn) { }
 static inline void kernfs_put(struct kernfs_node *kn) { }
 
+static inline struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry)
+{ return NULL; }
+
+static inline struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
+{ return NULL; }
+
 static inline struct kernfs_root *
 kernfs_create_root(struct kernfs_syscall_ops *scops, unsigned int flags,
 		   void *priv)
@@ -388,6 +397,13 @@ static inline int kernfs_remove_by_name(struct kernfs_node *parent,
 	return kernfs_remove_by_name_ns(parent, name, NULL);
 }
 
+static inline int kernfs_rename(struct kernfs_node *kn,
+				struct kernfs_node *new_parent,
+				const char *new_name)
+{
+	return kernfs_rename_ns(kn, new_parent, new_name, NULL);
+}
+
 static inline struct dentry *
 kernfs_mount(struct file_system_type *fs_type, int flags,
 	     struct kernfs_root *root)
-- 
1.8.5.3

