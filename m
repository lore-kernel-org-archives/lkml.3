Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaDNVp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:45:28 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62083 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbaDNVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:44:13 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, gregkh@linuxfoundation.org,
        serge.hallyn@ubuntu.com, lennart@poettering.net, kay@vrfy.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] kernfs: implement kernfs_root->supers list
Date: Mon, 14 Apr 2014 17:44:04 -0400
Message-Id: <1397511846-2904-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397511846-2904-1-git-send-email-tj@kernel.org>
References: <1397511846-2904-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's no way to find out which super_blocks are
associated with a given kernfs_root.  Let's implement it - the planned
inotify extension to kernfs_notify() needs it.

Make kernfs_super_info point back to the super_block and chain it at
kernfs_root->supers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c             |  1 +
 fs/kernfs/kernfs-internal.h |  5 +++++
 fs/kernfs/mount.c           | 11 +++++++++++
 include/linux/kernfs.h      |  4 ++++
 4 files changed, 21 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 78f3403..43aa979 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -711,6 +711,7 @@ struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
 		return ERR_PTR(-ENOMEM);
 
 	ida_init(&root->ino_ida);
+	INIT_LIST_HEAD(&root->supers);
 
 	kn = __kernfs_new_node(root, "", S_IFDIR | S_IRUGO | S_IXUGO,
 			       KERNFS_DIR);
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 8be13b2..dc84a3e 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -49,6 +49,8 @@ static inline struct kernfs_root *kernfs_root(struct kernfs_node *kn)
  * mount.c
  */
 struct kernfs_super_info {
+	struct super_block	*sb;
+
 	/*
 	 * The root associated with this super_block.  Each super_block is
 	 * identified by the root and ns it's associated with.
@@ -62,6 +64,9 @@ struct kernfs_super_info {
 	 * an array and compare kernfs_node tag against every entry.
 	 */
 	const void		*ns;
+
+	/* anchored at kernfs_root->supers, protected by kernfs_mutex */
+	struct list_head	node;
 };
 #define kernfs_info(SB) ((struct kernfs_super_info *)(SB->s_fs_info))
 
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 6a5f04a..f25a7c0 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -68,6 +68,7 @@ static int kernfs_fill_super(struct super_block *sb)
 	struct inode *inode;
 	struct dentry *root;
 
+	info->sb = sb;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = SYSFS_MAGIC;
@@ -166,12 +167,18 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 		*new_sb_created = !sb->s_root;
 
 	if (!sb->s_root) {
+		struct kernfs_super_info *info = kernfs_info(sb);
+
 		error = kernfs_fill_super(sb);
 		if (error) {
 			deactivate_locked_super(sb);
 			return ERR_PTR(error);
 		}
 		sb->s_flags |= MS_ACTIVE;
+
+		mutex_lock(&kernfs_mutex);
+		list_add(&info->node, &root->supers);
+		mutex_unlock(&kernfs_mutex);
 	}
 
 	return dget(sb->s_root);
@@ -190,6 +197,10 @@ void kernfs_kill_sb(struct super_block *sb)
 	struct kernfs_super_info *info = kernfs_info(sb);
 	struct kernfs_node *root_kn = sb->s_root->d_fsdata;
 
+	mutex_lock(&kernfs_mutex);
+	list_del(&info->node);
+	mutex_unlock(&kernfs_mutex);
+
 	/*
 	 * Remove the superblock from fs_supers/s_instances
 	 * so we can't find it, before freeing kernfs_super_info.
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index b0122dc..589318b 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -144,6 +144,10 @@ struct kernfs_root {
 	/* private fields, do not use outside kernfs proper */
 	struct ida		ino_ida;
 	struct kernfs_syscall_ops *syscall_ops;
+
+	/* list of kernfs_super_info of this root, protected by kernfs_mutex */
+	struct list_head	supers;
+
 	wait_queue_head_t	deactivate_waitq;
 };
 
-- 
1.9.0

