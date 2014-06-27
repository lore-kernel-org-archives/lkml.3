Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaF0HLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:11:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50073 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaF0HLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:11:07 -0400
Message-ID: <53AD18F8.4050501@huawei.com>
Date: Fri, 27 Jun 2014 15:10:48 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 2/3] kernfs: introduce kernfs_pin_sb()
References: <53AD18D0.3090100@huawei.com>
In-Reply-To: <53AD18D0.3090100@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_pin_sb() tries to get a refcnt of the superblock.

This will be used by cgroupfs.

v2:
- make kernfs_pin_sb() return pointer to the superblock.
- drop kernfs_drop_sb().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/kernfs/mount.c      | 27 +++++++++++++++++++++++++++
 include/linux/kernfs.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f25a7c0..616c5c4 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -210,6 +210,33 @@ void kernfs_kill_sb(struct super_block *sb)
 	kernfs_put(root_kn);
 }
 
+/**
+ * kernfs_pin_sb: try to pin the superblock associated with a kernfs_root
+ * @kernfs_root: the kernfs_root in question
+ * @ns: the namespace tag
+ *
+ * Pin the superblock so the superblock won't be destroyed in subsequent
+ * operations. Return NULL if there's no superblock associated to this
+ * kernfs_root, or -EINVAL if the superblock is being freed.
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
index 589318b..9096296 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -287,6 +287,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 			       struct kernfs_root *root, bool *new_sb_created,
 			       const void *ns);
 void kernfs_kill_sb(struct super_block *sb);
+struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns);
 
 void kernfs_init(void);
 
-- 
1.8.0.2

