Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbaGOXbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:31:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934119AbaGOXOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.15 70/84] kernfs: introduce kernfs_pin_sb()
Date: Tue, 15 Jul 2014 16:18:07 -0700
Message-Id: <20140715231715.282104690@linuxfoundation.org>
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

From: Li Zefan <lizefan@huawei.com>

commit 4e26445faad366d67d7723622bf6a60a6f0f5993 upstream.

kernfs_pin_sb() tries to get a refcnt of the superblock.

This will be used by cgroupfs.

v2:
- make kernfs_pin_sb() return the superblock.
- drop kernfs_drop_sb().

tj: Updated the comment a bit.

[ This is a prerequisite for a bugfix. ]
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/mount.c      |   30 ++++++++++++++++++++++++++++++
 include/linux/kernfs.h |    1 +
 2 files changed, 31 insertions(+)

--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -211,6 +211,36 @@ void kernfs_kill_sb(struct super_block *
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
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -304,6 +304,7 @@ struct dentry *kernfs_mount_ns(struct fi
 			       struct kernfs_root *root, unsigned long magic,
 			       bool *new_sb_created, const void *ns);
 void kernfs_kill_sb(struct super_block *sb);
+struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns);
 
 void kernfs_init(void);
 


