Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaFLGch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:32:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:33030 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaFLGcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:32:35 -0400
Message-ID: <5399497C.8080402@huawei.com>
Date: Thu, 12 Jun 2014 14:32:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 4/5] kernfs: introduce kernfs_pin_sb() and kernfs_drop_sb()
References: <53994943.60703@huawei.com>
In-Reply-To: <53994943.60703@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kernfs_pin_sb() tries to get a refcnt of the superblock, while
kernfs_drop_sb() drops this refcnt.

This will be used by cgroupfs.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/kernfs/mount.c      | 45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernfs.h |  3 +++
 2 files changed, 48 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f25a7c0..4f924e0 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -210,6 +210,51 @@ void kernfs_kill_sb(struct super_block *sb)
 	kernfs_put(root_kn);
 }
 
+/**
+ * kernfs_pin_sb: try to pin the superblock associated with a kernfs_root
+ * @kernfs_root: the kernfs_root in question
+ * @ns: the namespace tag
+ *
+ * Pin the superblock so the superblock won't be destroyed in subsequent
+ * operations.
+ */
+bool kernfs_pin_sb(struct kernfs_root *root, const void *ns)
+{
+	struct kernfs_super_info *info;
+	int ret = false;
+
+	mutex_lock(&kernfs_mutex);
+	list_for_each_entry(info, &root->supers, node) {
+		if (info->ns == ns) {
+			ret = atomic_inc_not_zero(&info->sb->s_active);
+			break;
+		}
+	}
+	mutex_unlock(&kernfs_mutex);
+	return ret;
+}
+
+/**
+ * kernfs_drop_sb: drop the refcnt that we got by kernfs_pin_sb()
+ * @root: the kernfs_root in question
+ * @ns: the namespace tag
+ *
+ * This must be paired with kernfs_pin_sb(). It will require sb->u_mount
+ * if the refcnt reaches zero.
+ */
+void kernfs_drop_sb(struct kernfs_root *root, const void *ns)
+{
+	struct kernfs_super_info *info;
+
+	mutex_lock(&kernfs_mutex);
+	list_for_each_entry(info, &root->supers, node) {
+		if (info->ns == ns)
+			break;
+	}
+	mutex_unlock(&kernfs_mutex);
+	deactivate_super(info->sb);
+}
+
 void __init kernfs_init(void)
 {
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 589318b..1958017 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -288,6 +288,9 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 			       const void *ns);
 void kernfs_kill_sb(struct super_block *sb);
 
+bool kernfs_pin_sb(struct kernfs_root *root, const void *ns);
+void kernfs_drop_sb(struct kernfs_root *root, const void *ns);
+
 void kernfs_init(void);
 
 #else	/* CONFIG_KERNFS */
-- 
1.8.0.2

