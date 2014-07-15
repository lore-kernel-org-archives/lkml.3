Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190AbaGOXbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:31:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934113AbaGOXOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.15 69/84] kernfs: implement kernfs_root->supers list
Date: Tue, 15 Jul 2014 16:18:06 -0700
Message-Id: <20140715231715.252976642@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 7d568a8383bbb9c1f5167781075906acb2bb1550 upstream.

Currently, there's no way to find out which super_blocks are
associated with a given kernfs_root.  Let's implement it - the planned
inotify extension to kernfs_notify() needs it.

Make kernfs_super_info point back to the super_block and chain it at
kernfs_root->supers.

Signed-off-by: Tejun Heo <tj@kernel.org>
[lizf: Backported to 3.15: Adjust context]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c             |    1 +
 fs/kernfs/kernfs-internal.h |    5 +++++
 fs/kernfs/mount.c           |   11 +++++++++++
 include/linux/kernfs.h      |    4 ++++
 4 files changed, 21 insertions(+)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -714,6 +714,7 @@ struct kernfs_root *kernfs_create_root(s
 		return ERR_PTR(-ENOMEM);
 
 	ida_init(&root->ino_ida);
+	INIT_LIST_HEAD(&root->supers);
 
 	kn = __kernfs_new_node(root, "", S_IFDIR | S_IRUGO | S_IXUGO,
 			       KERNFS_DIR);
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -49,6 +49,8 @@ static inline struct kernfs_root *kernfs
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
 
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -68,6 +68,7 @@ static int kernfs_fill_super(struct supe
 	struct inode *inode;
 	struct dentry *root;
 
+	info->sb = sb;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = magic;
@@ -167,12 +168,18 @@ struct dentry *kernfs_mount_ns(struct fi
 		*new_sb_created = !sb->s_root;
 
 	if (!sb->s_root) {
+		struct kernfs_super_info *info = kernfs_info(sb);
+
 		error = kernfs_fill_super(sb, magic);
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
@@ -191,6 +198,10 @@ void kernfs_kill_sb(struct super_block *
 	struct kernfs_super_info *info = kernfs_info(sb);
 	struct kernfs_node *root_kn = sb->s_root->d_fsdata;
 
+	mutex_lock(&kernfs_mutex);
+	list_del(&info->node);
+	mutex_unlock(&kernfs_mutex);
+
 	/*
 	 * Remove the superblock from fs_supers/s_instances
 	 * so we can't find it, before freeing kernfs_super_info.
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -161,6 +161,10 @@ struct kernfs_root {
 	/* private fields, do not use outside kernfs proper */
 	struct ida		ino_ida;
 	struct kernfs_syscall_ops *syscall_ops;
+
+	/* list of kernfs_super_info of this root, protected by kernfs_mutex */
+	struct list_head	supers;
+
 	wait_queue_head_t	deactivate_waitq;
 };
 


