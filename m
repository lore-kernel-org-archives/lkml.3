Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3JCGTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:19:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41562 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3JCGT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:19:27 -0400
Date: Thu, 03 Oct 2013 07:19:26 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 12/17] new helpers: lock_mount_hash/unlock_mount_hash
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcFy-0008CJ-Bw@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


aka br_write_{lock,unlock} of vfsmount_lock.  Inlines in fs/mount.h,
vfsmount_lock extern moved over there as well.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/internal.h  |    4 --
 fs/mount.h     |   13 +++++++
 fs/namespace.c |   96 ++++++++++++++++++++++++++++----------------------------
 fs/pnode.c     |    4 +-
 4 files changed, 63 insertions(+), 54 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 513e0d8..4a11e75 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -9,8 +9,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/lglock.h>
-
 struct super_block;
 struct file_system_type;
 struct linux_binprm;
@@ -62,8 +60,6 @@ extern int sb_prepare_remount_readonly(struct super_block *);
 
 extern void __init mnt_init(void);
 
-extern struct lglock vfsmount_lock;
-
 extern int __mnt_want_write(struct vfsmount *);
 extern int __mnt_want_write_file(struct file *);
 extern void __mnt_drop_write(struct vfsmount *);
diff --git a/fs/mount.h b/fs/mount.h
index 3168dc4..7076f25 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -1,6 +1,7 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/poll.h>
+#include <linux/lglock.h>
 
 struct mnt_namespace {
 	atomic_t		count;
@@ -83,6 +84,18 @@ static inline void get_mnt_ns(struct mnt_namespace *ns)
 	atomic_inc(&ns->count);
 }
 
+extern struct lglock vfsmount_lock;
+
+static inline void lock_mount_hash(void)
+{
+	br_write_lock(&vfsmount_lock);
+}
+
+static inline void unlock_mount_hash(void)
+{
+	br_write_unlock(&vfsmount_lock);
+}
+
 struct proc_mounts {
 	struct seq_file m;
 	struct mnt_namespace *ns;
diff --git a/fs/namespace.c b/fs/namespace.c
index 6985d52..aa6dd93 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -456,7 +456,7 @@ static int mnt_make_readonly(struct mount *mnt)
 {
 	int ret = 0;
 
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	mnt->mnt.mnt_flags |= MNT_WRITE_HOLD;
 	/*
 	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -490,15 +490,15 @@ static int mnt_make_readonly(struct mount *mnt)
 	 */
 	smp_wmb();
 	mnt->mnt.mnt_flags &= ~MNT_WRITE_HOLD;
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 	return ret;
 }
 
 static void __mnt_unmake_readonly(struct mount *mnt)
 {
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	mnt->mnt.mnt_flags &= ~MNT_READONLY;
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 }
 
 int sb_prepare_remount_readonly(struct super_block *sb)
@@ -510,7 +510,7 @@ int sb_prepare_remount_readonly(struct super_block *sb)
 	if (atomic_long_read(&sb->s_remove_count))
 		return -EBUSY;
 
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
 		if (!(mnt->mnt.mnt_flags & MNT_READONLY)) {
 			mnt->mnt.mnt_flags |= MNT_WRITE_HOLD;
@@ -532,7 +532,7 @@ int sb_prepare_remount_readonly(struct super_block *sb)
 		if (mnt->mnt.mnt_flags & MNT_WRITE_HOLD)
 			mnt->mnt.mnt_flags &= ~MNT_WRITE_HOLD;
 	}
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 
 	return err;
 }
@@ -794,9 +794,9 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	mnt->mnt.mnt_sb = root->d_sb;
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 	mnt->mnt_parent = mnt;
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	list_add_tail(&mnt->mnt_instance, &root->d_sb->s_mounts);
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 	return &mnt->mnt;
 }
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
@@ -837,9 +837,9 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	mnt->mnt.mnt_root = dget(root);
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 	mnt->mnt_parent = mnt;
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	list_add_tail(&mnt->mnt_instance, &sb->s_mounts);
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 
 	if ((flag & CL_SLAVE) ||
 	    ((flag & CL_SHARED_TO_SLAVE) && IS_MNT_SHARED(old))) {
@@ -883,28 +883,28 @@ put_again:
 	}
 	br_read_unlock(&vfsmount_lock);
 
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	mnt_add_count(mnt, -1);
 	if (mnt_get_count(mnt)) {
-		br_write_unlock(&vfsmount_lock);
+		unlock_mount_hash();
 		return;
 	}
 #else
 	mnt_add_count(mnt, -1);
 	if (likely(mnt_get_count(mnt)))
 		return;
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 #endif
 	if (unlikely(mnt->mnt_pinned)) {
 		mnt_add_count(mnt, mnt->mnt_pinned + 1);
 		mnt->mnt_pinned = 0;
-		br_write_unlock(&vfsmount_lock);
+		unlock_mount_hash();
 		acct_auto_close_mnt(&mnt->mnt);
 		goto put_again;
 	}
 
 	list_del(&mnt->mnt_instance);
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 
 	/*
 	 * This probably indicates that somebody messed
@@ -945,21 +945,21 @@ EXPORT_SYMBOL(mntget);
 
 void mnt_pin(struct vfsmount *mnt)
 {
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	real_mount(mnt)->mnt_pinned++;
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 }
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *m)
 {
 	struct mount *mnt = real_mount(m);
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	if (mnt->mnt_pinned) {
 		mnt_add_count(mnt, 1);
 		mnt->mnt_pinned--;
 	}
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 }
 EXPORT_SYMBOL(mnt_unpin);
 
@@ -1076,12 +1076,12 @@ int may_umount_tree(struct vfsmount *m)
 	BUG_ON(!m);
 
 	/* write lock needed for mnt_get_count */
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
 		actual_refs += mnt_get_count(p);
 		minimum_refs += 2;
 	}
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 
 	if (actual_refs > minimum_refs)
 		return 0;
@@ -1108,10 +1108,10 @@ int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
 	down_read(&namespace_sem);
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	if (propagate_mount_busy(real_mount(mnt), 2))
 		ret = 0;
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 	up_read(&namespace_sem);
 	return ret;
 }
@@ -1208,12 +1208,12 @@ static int do_umount(struct mount *mnt, int flags)
 		 * probably don't strictly need the lock here if we examined
 		 * all race cases, but it's a slowpath.
 		 */
-		br_write_lock(&vfsmount_lock);
+		lock_mount_hash();
 		if (mnt_get_count(mnt) != 2) {
-			br_write_unlock(&vfsmount_lock);
+			unlock_mount_hash();
 			return -EBUSY;
 		}
-		br_write_unlock(&vfsmount_lock);
+		unlock_mount_hash();
 
 		if (!xchg(&mnt->mnt_expiry_mark, 1))
 			return -EAGAIN;
@@ -1255,7 +1255,7 @@ static int do_umount(struct mount *mnt, int flags)
 	}
 
 	namespace_lock();
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	event++;
 
 	if (!(flags & MNT_DETACH))
@@ -1267,7 +1267,7 @@ static int do_umount(struct mount *mnt, int flags)
 			umount_tree(mnt, 1);
 		retval = 0;
 	}
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 	namespace_unlock();
 	return retval;
 }
@@ -1410,18 +1410,18 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
 			q = clone_mnt(p, p->mnt.mnt_root, flag);
 			if (IS_ERR(q))
 				goto out;
-			br_write_lock(&vfsmount_lock);
+			lock_mount_hash();
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, parent, p->mnt_mp);
-			br_write_unlock(&vfsmount_lock);
+			unlock_mount_hash();
 		}
 	}
 	return res;
 out:
 	if (res) {
-		br_write_lock(&vfsmount_lock);
+		lock_mount_hash();
 		umount_tree(res, 0);
-		br_write_unlock(&vfsmount_lock);
+		unlock_mount_hash();
 	}
 	return q;
 }
@@ -1443,9 +1443,9 @@ struct vfsmount *collect_mounts(struct path *path)
 void drop_collected_mounts(struct vfsmount *mnt)
 {
 	namespace_lock();
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	umount_tree(real_mount(mnt), 0);
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 	namespace_unlock();
 }
 
@@ -1572,7 +1572,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	if (err)
 		goto out_cleanup_ids;
 
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 
 	if (IS_MNT_SHARED(dest_mnt)) {
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
@@ -1591,7 +1591,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		list_del_init(&child->mnt_hash);
 		commit_tree(child);
 	}
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 
 	return 0;
 
@@ -1693,10 +1693,10 @@ static int do_change_type(struct path *path, int flag)
 			goto out_unlock;
 	}
 
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 
  out_unlock:
 	namespace_unlock();
@@ -1768,9 +1768,9 @@ static int do_loopback(struct path *path, const char *old_name,
 
 	err = graft_tree(mnt, parent, mp);
 	if (err) {
-		br_write_lock(&vfsmount_lock);
+		lock_mount_hash();
 		umount_tree(mnt, 0);
-		br_write_unlock(&vfsmount_lock);
+		unlock_mount_hash();
 	}
 out2:
 	unlock_mount(mp);
@@ -1829,11 +1829,11 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	else
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
-		br_write_lock(&vfsmount_lock);
+		lock_mount_hash();
 		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
 		touch_mnt_namespace(mnt->mnt_ns);
-		br_write_unlock(&vfsmount_lock);
+		unlock_mount_hash();
 	}
 	up_write(&sb->s_umount);
 	return err;
@@ -2093,7 +2093,7 @@ void mark_mounts_for_expiry(struct list_head *mounts)
 		return;
 
 	namespace_lock();
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 
 	/* extract from the expiration list every vfsmount that matches the
 	 * following criteria:
@@ -2112,7 +2112,7 @@ void mark_mounts_for_expiry(struct list_head *mounts)
 		touch_mnt_namespace(mnt->mnt_ns);
 		umount_tree(mnt, 1);
 	}
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 	namespace_unlock();
 }
 
@@ -2662,7 +2662,7 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	if (!is_path_reachable(old_mnt, old.dentry, &new))
 		goto out4;
 	root_mp->m_count++; /* pin it so it won't go away */
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	detach_mnt(new_mnt, &parent_path);
 	detach_mnt(root_mnt, &root_parent);
 	if (root_mnt->mnt.mnt_flags & MNT_LOCKED) {
@@ -2674,7 +2674,7 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	/* mount new_root on / */
 	attach_mnt(new_mnt, real_mount(root_parent.mnt), root_mp);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 	chroot_fs_refs(&root, &new);
 	put_mountpoint(root_mp);
 	error = 0;
@@ -2788,9 +2788,9 @@ void kern_unmount(struct vfsmount *mnt)
 {
 	/* release long term mount so mount point can be released */
 	if (!IS_ERR_OR_NULL(mnt)) {
-		br_write_lock(&vfsmount_lock);
+		lock_mount_hash();
 		real_mount(mnt)->mnt_ns = NULL;
-		br_write_unlock(&vfsmount_lock);
+		unlock_mount_hash();
 		mntput(mnt);
 	}
 }
diff --git a/fs/pnode.c b/fs/pnode.c
index 3cfd48c..58933fd 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -264,12 +264,12 @@ int propagate_mnt(struct mount *dest_mnt, struct mountpoint *dest_mp,
 		prev_src_mnt  = child;
 	}
 out:
-	br_write_lock(&vfsmount_lock);
+	lock_mount_hash();
 	while (!list_empty(&tmp_list)) {
 		child = list_first_entry(&tmp_list, struct mount, mnt_hash);
 		umount_tree(child, 0);
 	}
-	br_write_unlock(&vfsmount_lock);
+	unlock_mount_hash();
 	return ret;
 }
 
-- 
1.7.2.5


