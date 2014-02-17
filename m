Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaBQD6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 22:58:30 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:41709 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBQD61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 22:58:27 -0500
Message-ID: <53018813.7030409@huawei.com>
Date: Mon, 17 Feb 2014 11:54:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] sysfs: fix namespace refcnt leak
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I think we have to fix kernfs in order to fix refcnt leak in sysfs
and cgroupfs. This fix is for 3.14, but it creates conflicts for
cgroup-next.

====================

As mount() and kill_sb() is not a one-to-one match, we shoudn't get
ns refcnt unconditionally in sysfs_mount(), and instead we should
get the refcnt only when kernfs_mount() allocated a new superblock.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/kernfs/mount.c      | 7 ++++++-
 fs/sysfs/mount.c       | 5 +++--
 include/linux/kernfs.h | 9 +++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 405279b..53ce420 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -132,6 +132,7 @@ const void *kernfs_super_ns(struct super_block *sb)
  * @flags: mount flags specified for the mount
  * @root: kernfs_root of the hierarchy being mounted
  * @ns: optional namespace tag of the mount
+ * @new: tell the caller if we allocated a new superblock
  *
  * This is to be called from each kernfs user's file_system_type->mount()
  * implementation, which should pass through the specified @fs_type and
@@ -141,12 +142,15 @@ const void *kernfs_super_ns(struct super_block *sb)
  * The return value can be passed to the vfs layer verbatim.
  */
 struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-			       struct kernfs_root *root, const void *ns)
+			       struct kernfs_root *root, const void *ns,
+			       bool *new_sb)
 {
 	struct super_block *sb;
 	struct kernfs_super_info *info;
 	int error;
 
+	*new_sb = false;
+
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return ERR_PTR(-ENOMEM);
@@ -166,6 +170,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 			return ERR_PTR(error);
 		}
 		sb->s_flags |= MS_ACTIVE;
+		*new_sb = true;
 	}
 
 	return dget(sb->s_root);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 5c7fdd9..f5bea79 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -27,6 +27,7 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 {
 	struct dentry *root;
 	void *ns;
+	bool new_sb;
 
 	if (!(flags & MS_KERNMOUNT)) {
 		if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
@@ -37,8 +38,8 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	}
 
 	ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
-	root = kernfs_mount_ns(fs_type, flags, sysfs_root, ns);
-	if (IS_ERR(root))
+	root = kernfs_mount_ns(fs_type, flags, sysfs_root, ns, &new_sb);
+	if (IS_ERR(root) || !new_sb)
 		kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
 	return root;
 }
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 649497a..1b1849f 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -279,7 +279,8 @@ void kernfs_notify(struct kernfs_node *kn);
 
 const void *kernfs_super_ns(struct super_block *sb);
 struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-			       struct kernfs_root *root, const void *ns);
+			       struct kernfs_root *root, const void *ns,
+			       bool *new_sb);
 void kernfs_kill_sb(struct super_block *sb);
 
 void kernfs_init(void);
@@ -372,7 +373,7 @@ static inline const void *kernfs_super_ns(struct super_block *sb)
 
 static inline struct dentry *
 kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-		struct kernfs_root *root, const void *ns)
+		struct kernfs_root *root, const void *ns, bool *new_sb)
 { return ERR_PTR(-ENOSYS); }
 
 static inline void kernfs_kill_sb(struct super_block *sb) { }
@@ -430,9 +431,9 @@ static inline int kernfs_rename(struct kernfs_node *kn,
 
 static inline struct dentry *
 kernfs_mount(struct file_system_type *fs_type, int flags,
-	     struct kernfs_root *root)
+	     struct kernfs_root *root, bool *new_sb)
 {
-	return kernfs_mount_ns(fs_type, flags, root, NULL);
+	return kernfs_mount_ns(fs_type, flags, root, NULL, new_sb);
 }
 
 #endif	/* __LINUX_KERNFS_H */
-- 
1.8.0.2
