Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3KCJyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:54:07 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:65144 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3KCJyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:54:04 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 32/39] sysfs, kernfs: introduce sysfs_root_sd
Date: Sun,  3 Nov 2013 04:53:11 -0500
Message-Id: <1383472398-17812-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, it's assumed that there's a single kernfs hierarchy in the
system anchored at sysfs_root which is defined as a global struct.  To
allow other users of kernfs, this will be made dynamic.  Introduce a
new global variable sysfs_root_sd which points to &sysfs_root and
convert all &sysfs_root users.

This patch doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c     | 4 ++--
 fs/sysfs/mount.c   | 8 +++++---
 fs/sysfs/symlink.c | 6 +++---
 fs/sysfs/sysfs.h   | 2 +-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e5c4e71..2fea501 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -68,7 +68,7 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 	if (kobj->parent)
 		parent_sd = kobj->parent->sd;
 	else
-		parent_sd = &sysfs_root;
+		parent_sd = sysfs_root_sd;
 
 	if (!parent_sd)
 		return -ENOENT;
@@ -134,7 +134,7 @@ int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
 
 	BUG_ON(!sd->s_parent);
 	new_parent_sd = new_parent_kobj && new_parent_kobj->sd ?
-		new_parent_kobj->sd : &sysfs_root;
+		new_parent_kobj->sd : sysfs_root_sd;
 
 	return kernfs_rename_ns(sd, new_parent_sd, sd->s_name, new_ns);
 }
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 0c80f03..7cbd1fc 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -32,7 +32,7 @@ static const struct super_operations sysfs_ops = {
 	.evict_inode	= sysfs_evict_inode,
 };
 
-struct sysfs_dirent sysfs_root = {
+static struct sysfs_dirent sysfs_root = {
 	.s_name		= "",
 	.s_count	= ATOMIC_INIT(1),
 	.s_flags	= SYSFS_DIR,
@@ -40,6 +40,8 @@ struct sysfs_dirent sysfs_root = {
 	.s_ino		= 1,
 };
 
+struct sysfs_dirent *sysfs_root_sd = &sysfs_root;
+
 static int sysfs_fill_super(struct super_block *sb)
 {
 	struct inode *inode;
@@ -53,7 +55,7 @@ static int sysfs_fill_super(struct super_block *sb)
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
-	inode = sysfs_get_inode(sb, &sysfs_root);
+	inode = sysfs_get_inode(sb, sysfs_root_sd);
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
@@ -66,7 +68,7 @@ static int sysfs_fill_super(struct super_block *sb)
 		pr_debug("%s: could not get root dentry!\n", __func__);
 		return -ENOMEM;
 	}
-	root->d_fsdata = &sysfs_root;
+	root->d_fsdata = sysfs_root_sd;
 	sb->s_root = root;
 	sb->s_d_op = &sysfs_dentry_ops;
 	return 0;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 1890394..f2f41e2 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -70,7 +70,7 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 	struct sysfs_dirent *parent_sd = NULL;
 
 	if (!kobj)
-		parent_sd = &sysfs_root;
+		parent_sd = sysfs_root_sd;
 	else
 		parent_sd = kobj->sd;
 
@@ -144,7 +144,7 @@ void sysfs_remove_link(struct kobject *kobj, const char *name)
 	struct sysfs_dirent *parent_sd = NULL;
 
 	if (!kobj)
-		parent_sd = &sysfs_root;
+		parent_sd = sysfs_root_sd;
 	else
 		parent_sd = kobj->sd;
 
@@ -170,7 +170,7 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 	int result;
 
 	if (!kobj)
-		parent_sd = &sysfs_root;
+		parent_sd = sysfs_root_sd;
 	else
 		parent_sd = kobj->sd;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ce97907..2b217ce 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -28,7 +28,7 @@ struct sysfs_super_info {
 	const void		*ns;
 };
 #define sysfs_info(SB) ((struct sysfs_super_info *)(SB->s_fs_info))
-extern struct sysfs_dirent sysfs_root;
+extern struct sysfs_dirent *sysfs_root_sd;
 extern struct kmem_cache *sysfs_dir_cachep;
 
 /*
-- 
1.8.3.1

