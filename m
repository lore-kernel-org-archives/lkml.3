Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaA1XdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:33:03 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:60114 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbaA1XdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:33:00 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/9] kernfs: invoke dir_ops while holding active ref of the target node
Date: Tue, 28 Jan 2014 18:32:43 -0500
Message-Id: <1390951971-15671-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951971-15671-1-git-send-email-tj@kernel.org>
References: <1390951971-15671-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_dir_ops are currently being invoked without any active
reference, which makes it tricky for the invoked operations to
determine whether the objects associated those nodes are safe to
access and will remain that way for the duration of such operations.

kernfs already has active_ref mechanism to deal with this which makes
the removal of a given node the synchronization point for gating the
file operations.  There's no reason for dir_ops to be any different.
Update the dir_ops handling so that active_ref is held while the
dir_ops are executing.  This guarantees that while a dir_ops is
executing the target nodes stay alive.

As kernfs_dir_ops doesn't have any in-kernel user at this point, this
doesn't affect anybody.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 33 ++++++++++++++++++++++++++++++---
 include/linux/kernfs.h |  3 ++-
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 8c63ae1..bfbfb48 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -654,22 +654,36 @@ static int kernfs_iop_mkdir(struct inode *dir, struct dentry *dentry,
 {
 	struct kernfs_node *parent = dir->i_private;
 	struct kernfs_dir_ops *kdops = kernfs_root(parent)->dir_ops;
+	int ret;
 
 	if (!kdops || !kdops->mkdir)
 		return -EPERM;
 
-	return kdops->mkdir(parent, dentry->d_name.name, mode);
+	if (!kernfs_get_active(parent))
+		return -ENODEV;
+
+	ret = kdops->mkdir(parent, dentry->d_name.name, mode);
+
+	kernfs_put_active(parent);
+	return ret;
 }
 
 static int kernfs_iop_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct kernfs_node *kn  = dentry->d_fsdata;
 	struct kernfs_dir_ops *kdops = kernfs_root(kn)->dir_ops;
+	int ret;
 
 	if (!kdops || !kdops->rmdir)
 		return -EPERM;
 
-	return kdops->rmdir(kn);
+	if (!kernfs_get_active(kn))
+		return -ENODEV;
+
+	ret = kdops->rmdir(kn);
+
+	kernfs_put_active(kn);
+	return ret;
 }
 
 static int kernfs_iop_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -678,11 +692,24 @@ static int kernfs_iop_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct kernfs_node *kn  = old_dentry->d_fsdata;
 	struct kernfs_node *new_parent = new_dir->i_private;
 	struct kernfs_dir_ops *kdops = kernfs_root(kn)->dir_ops;
+	int ret;
 
 	if (!kdops || !kdops->rename)
 		return -EPERM;
 
-	return kdops->rename(kn, new_parent, new_dentry->d_name.name);
+	if (!kernfs_get_active(kn))
+		return -ENODEV;
+
+	if (!kernfs_get_active(new_parent)) {
+		kernfs_put_active(kn);
+		return -ENODEV;
+	}
+
+	ret = kdops->rename(kn, new_parent, new_dentry->d_name.name);
+
+	kernfs_put_active(new_parent);
+	kernfs_put_active(kn);
+	return ret;
 }
 
 const struct inode_operations kernfs_dir_iops = {
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 02ac334..58a131d 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -111,7 +111,8 @@ struct kernfs_node {
  * kernfs_dir_ops may be specified on kernfs_create_root() to support
  * directory manipulation syscalls.  These optional callbacks are invoked
  * on the matching syscalls and can perform any kernfs operations which
- * don't necessarily have to be the exact operation requested.
+ * don't necessarily have to be the exact operation requested.  An active
+ * reference is held for each kernfs_node parameter.
  */
 struct kernfs_dir_ops {
 	int (*mkdir)(struct kernfs_node *parent, const char *name,
-- 
1.8.5.3

