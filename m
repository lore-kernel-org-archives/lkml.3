Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaF3OTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:19:12 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38140 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaF3OTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:19:10 -0400
Date: Mon, 30 Jun 2014 10:19:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 2/3] kernfs: introduce kernfs_pin_sb()
Message-ID: <20140630141906.GB14807@htj.dyndns.org>
References: <53B0DE66.5080100@huawei.com>
 <53B0DE84.40206@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B0DE84.40206@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to cgroup/for-3.16-fixes with minor updates.  Thanks.
------ 8< ------
>From 4e26445faad366d67d7723622bf6a60a6f0f5993 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Mon, 30 Jun 2014 11:50:28 +0800
Subject: [PATCH 2/3] kernfs: introduce kernfs_pin_sb()

kernfs_pin_sb() tries to get a refcnt of the superblock.

This will be used by cgroupfs.

v2:
- make kernfs_pin_sb() return the superblock.
- drop kernfs_drop_sb().

tj: Updated the comment a bit.

[ This is a prerequisite for a bugfix. ]
Cc: <stable@vger.kernel.org> # 3.15
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/mount.c      | 30 ++++++++++++++++++++++++++++++
 include/linux/kernfs.h |  1 +
 2 files changed, 31 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index d171b98..f973ae9 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -211,6 +211,36 @@ void kernfs_kill_sb(struct super_block *sb)
 	kernfs_put(root_kn);
 }
 
+/**
+ * kernfs_pin_sb: try to pin the superblock associated with a kernfs_root
+ * @kernfs_root: the kernfs_root in question
+ * @ns: the namespace tag
+ *
+ * Pin the superblock so the superblock won't be destroyed in subsequent
+ * operations.  This can be used to block ->kill_sb() which may be useful
+ * for kernfs users which dynamically manage superblocks.
+ *
+ * Returns NULL if there's no superblock associated to this kernfs_root, or
+ * -EINVAL if the superblock is being freed.
+ */
+struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns)
+{
+	struct kernfs_super_info *info;
+	struct super_block *sb = NULL;
+
+	mutex_lock(&kernfs_mutex);
+	list_for_each_entry(info, &root->supers, node) {
+		if (info->ns == ns) {
+			sb = info->sb;
+			if (!atomic_inc_not_zero(&info->sb->s_active))
+				sb = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	mutex_unlock(&kernfs_mutex);
+	return sb;
+}
+
 void __init kernfs_init(void)
 {
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 17aa1cc..20f4935 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -304,6 +304,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 			       struct kernfs_root *root, unsigned long magic,
 			       bool *new_sb_created, const void *ns);
 void kernfs_kill_sb(struct super_block *sb);
+struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns);
 
 void kernfs_init(void);
 
-- 
1.9.3

