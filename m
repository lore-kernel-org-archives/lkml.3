Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaA1XfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:35:06 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58538 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbaA1XdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:33:03 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9] kernfs: implement kernfs_syscall_ops->remount_fs() and ->show_options()
Date: Tue, 28 Jan 2014 18:32:45 -0500
Message-Id: <1390951971-15671-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951971-15671-1-git-send-email-tj@kernel.org>
References: <1390951971-15671-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two super_block related syscall callbacks ->remount_fs() and
->show_options() to kernfs_syscall_ops.  These simply forward the
matching super_operations.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/mount.c      | 23 +++++++++++++++++++++++
 include/linux/kernfs.h |  3 +++
 2 files changed, 26 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 0d6ce89..70cc698 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -19,10 +19,33 @@
 
 struct kmem_cache *kernfs_node_cache;
 
+static int kernfs_sop_remount_fs(struct super_block *sb, int *flags, char *data)
+{
+	struct kernfs_root *root = kernfs_info(sb)->root;
+	struct kernfs_syscall_ops *scops = root->syscall_ops;
+
+	if (scops && scops->remount_fs)
+		return scops->remount_fs(root, flags, data);
+	return 0;
+}
+
+static int kernfs_sop_show_options(struct seq_file *sf, struct dentry *dentry)
+{
+	struct kernfs_root *root = kernfs_root(dentry->d_fsdata);
+	struct kernfs_syscall_ops *scops = root->syscall_ops;
+
+	if (scops && scops->show_options)
+		return scops->show_options(sf, root);
+	return 0;
+}
+
 static const struct super_operations kernfs_sops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= kernfs_evict_inode,
+
+	.remount_fs	= kernfs_sop_remount_fs,
+	.show_options	= kernfs_sop_show_options,
 };
 
 static int kernfs_fill_super(struct super_block *sb)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 5ddc474..5d5b7e9 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -115,6 +115,9 @@ struct kernfs_node {
  * kernfs_node parameter.
  */
 struct kernfs_syscall_ops {
+	int (*remount_fs)(struct kernfs_root *root, int *flags, char *data);
+	int (*show_options)(struct seq_file *sf, struct kernfs_root *root);
+
 	int (*mkdir)(struct kernfs_node *parent, const char *name,
 		     umode_t mode);
 	int (*rmdir)(struct kernfs_node *kn);
-- 
1.8.5.3

