Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab3K1T5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:57:51 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:62265 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab3K1Tzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:37 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/34] sysfs, kernfs: make super_blocks bind to different kernfs_roots
Date: Thu, 28 Nov 2013 14:54:42 -0500
Message-Id: <1385668487-10181-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs is being updated to allow multiple sysfs_dirent hierarchies so
that it can also be used by other users.  Currently, sysfs
super_blocks are always attached to one kernfs_root - sysfs_root - and
distinguished only by their namespace tags.

This patch adds sysfs_super_info->root and update
sysfs_fill/test_super() so that super_blocks are identified by the
combination of both the associated kernfs_root and namespace tag.
This allows mounting different kernfs hierarchies.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/mount.c | 10 ++++++----
 fs/sysfs/sysfs.h |  6 ++++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 0b5661b..f143b20 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -37,6 +37,7 @@ struct sysfs_dirent *sysfs_root_sd;
 
 static int sysfs_fill_super(struct super_block *sb)
 {
+	struct sysfs_super_info *info = sysfs_info(sb);
 	struct inode *inode;
 	struct dentry *root;
 
@@ -48,7 +49,7 @@ static int sysfs_fill_super(struct super_block *sb)
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
-	inode = sysfs_get_inode(sb, sysfs_root_sd);
+	inode = sysfs_get_inode(sb, info->root->sd);
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
@@ -61,8 +62,8 @@ static int sysfs_fill_super(struct super_block *sb)
 		pr_debug("%s: could not get root dentry!\n", __func__);
 		return -ENOMEM;
 	}
-	kernfs_get(sysfs_root_sd);
-	root->d_fsdata = sysfs_root_sd;
+	kernfs_get(info->root->sd);
+	root->d_fsdata = info->root->sd;
 	sb->s_root = root;
 	sb->s_d_op = &sysfs_dentry_ops;
 	return 0;
@@ -73,7 +74,7 @@ static int sysfs_test_super(struct super_block *sb, void *data)
 	struct sysfs_super_info *sb_info = sysfs_info(sb);
 	struct sysfs_super_info *info = data;
 
-	return sb_info->ns == info->ns;
+	return sb_info->root == info->root && sb_info->ns == info->ns;
 }
 
 static int sysfs_set_super(struct super_block *sb, void *data)
@@ -110,6 +111,7 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
+	info->root = sysfs_root;
 	info->ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
 
 	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, flags, info);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 2b217ce..93b4b68 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -20,6 +20,12 @@
 
 struct sysfs_super_info {
 	/*
+	 * The root associated with this super_block.  Each super_block is
+	 * identified by the root and ns it's associated with.
+	 */
+	struct kernfs_root	*root;
+
+	/*
 	 * Each sb is associated with one namespace tag, currently the network
 	 * namespace of the task which mounted this sysfs instance.  If multiple
 	 * tags become necessary, make the following an array and compare
-- 
1.8.4.2

