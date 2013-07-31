Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3GaEQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:51 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34985 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab3GaEQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwiaBFxcOAQEWJiiCJAEBBScvIxAIGDE5AxsZiA+4ao5IgSuEGwOMQJI0gwyKUSqBLAEfBA
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 03/11] inode: convert inode_sb_list_lock to per-sb
Date: Wed, 31 Jul 2013 14:15:42 +1000
Message-Id: <1375244150-27296-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The process of reducing contention on per-superblock inode lists
starts with moving the locking to match the per-superblock inode
list. This takes the global lock out of the picture and reduces the
contention problems to within a single filesystem. This doesn't get
rid of contention as the locks still have global CPU scope, but it
does isolate operations on different superblocks form each other.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c                   | 12 ++++++------
 fs/drop_caches.c                 | 10 ++++++----
 fs/fs-writeback.c                | 12 ++++++------
 fs/inode.c                       | 28 +++++++++++++---------------
 fs/internal.h                    |  1 -
 fs/notify/inode_mark.c           | 20 ++++++++++----------
 fs/quota/dquot.c                 | 16 ++++++++--------
 fs/super.c                       |  3 ++-
 include/linux/fs.h               |  5 ++++-
 include/linux/fsnotify_backend.h |  2 +-
 10 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c7bda5c..c39c0f3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1669,7 +1669,7 @@ void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 {
 	struct inode *inode, *old_inode = NULL;
 
-	spin_lock(&inode_sb_list_lock);
+	spin_lock(&blockdev_superblock->s_inode_list_lock);
 	list_for_each_entry(inode, &blockdev_superblock->s_inodes, i_sb_list) {
 		struct address_space *mapping = inode->i_mapping;
 
@@ -1681,13 +1681,13 @@ void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_sb_list_lock);
+		spin_unlock(&blockdev_superblock->s_inode_list_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
 		 * removed from s_inodes list while we dropped the
-		 * inode_sb_list_lock.  We cannot iput the inode now as we can
+		 * s_inode_list_lock  We cannot iput the inode now as we can
 		 * be holding the last reference and we cannot iput it under
-		 * inode_sb_list_lock. So we keep the reference and iput it
+		 * s_inode_list_lock. So we keep the reference and iput it
 		 * later.
 		 */
 		iput(old_inode);
@@ -1695,8 +1695,8 @@ void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 
 		func(I_BDEV(inode), arg);
 
-		spin_lock(&inode_sb_list_lock);
+		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&blockdev_superblock->s_inode_list_lock);
 	iput(old_inode);
 }
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 9fd702f..f1be790 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -17,7 +17,7 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&inode_sb_list_lock);
+	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
@@ -27,13 +27,15 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_sb_list_lock);
+		spin_unlock(&sb->s_inode_list_lock);
+
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
-		spin_lock(&inode_sb_list_lock);
+
+		spin_lock(&sb->s_inode_list_lock);
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&sb->s_inode_list_lock);
 	iput(toput_inode);
 }
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1d23d9a..ca66dc8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1217,7 +1217,7 @@ static void wait_sb_inodes(struct super_block *sb)
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_sb_list_lock);
+	spin_lock(&sb->s_inode_list_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1237,14 +1237,14 @@ static void wait_sb_inodes(struct super_block *sb)
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_sb_list_lock);
+		spin_unlock(&sb->s_inode_list_lock);
 
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
 		 * removed from s_inodes list while we dropped the
-		 * inode_sb_list_lock.  We cannot iput the inode now as we can
+		 * s_inode_list_lock.  We cannot iput the inode now as we can
 		 * be holding the last reference and we cannot iput it under
-		 * inode_sb_list_lock. So we keep the reference and iput it
+		 * s_inode_list_lock. So we keep the reference and iput it
 		 * later.
 		 */
 		iput(old_inode);
@@ -1254,9 +1254,9 @@ static void wait_sb_inodes(struct super_block *sb)
 
 		cond_resched();
 
-		spin_lock(&inode_sb_list_lock);
+		spin_lock(&sb->s_inode_list_lock);
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&sb->s_inode_list_lock);
 	iput(old_inode);
 }
 
diff --git a/fs/inode.c b/fs/inode.c
index e315c0a..cd10287 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -27,8 +27,8 @@
  *   inode->i_state, inode->i_hash, __iget()
  * Inode LRU list locks protect:
  *   inode->i_sb->s_inode_lru, inode->i_lru
- * inode_sb_list_lock protects:
- *   sb->s_inodes, inode->i_sb_list
+ * inode->i_sb->s_inode_list_lock protects:
+ *   inode->i_sb->s_inodes, inode->i_sb_list
  * bdi->wb.list_lock protects:
  *   bdi->wb.b_{dirty,io,more_io}, inode->i_wb_list
  * inode_hash_lock protects:
@@ -36,7 +36,7 @@
  *
  * Lock ordering:
  *
- * inode_sb_list_lock
+ * inode->i_sb->s_inode_list_lock
  *   inode->i_lock
  *     Inode LRU list locks
  *
@@ -44,7 +44,7 @@
  *   inode->i_lock
  *
  * inode_hash_lock
- *   inode_sb_list_lock
+ *   inode->i_sb->s_inode_list_lock
  *   inode->i_lock
  *
  * iunique_lock
@@ -56,8 +56,6 @@ static unsigned int i_hash_shift __read_mostly;
 static struct hlist_head *inode_hashtable __read_mostly;
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_hash_lock);
 
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_sb_list_lock);
-
 /*
  * Empty aops. Can be used for the cases where the user does not
  * define any of the address_space operations.
@@ -432,18 +430,18 @@ static void inode_lru_list_del(struct inode *inode)
  */
 void inode_sb_list_add(struct inode *inode)
 {
-	spin_lock(&inode_sb_list_lock);
+	spin_lock(&inode->i_sb->s_inode_list_lock);
 	list_add(&inode->i_sb_list, &inode->i_sb->s_inodes);
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&inode->i_sb->s_inode_list_lock);
 }
 EXPORT_SYMBOL_GPL(inode_sb_list_add);
 
 static inline void inode_sb_list_del(struct inode *inode)
 {
 	if (!list_empty(&inode->i_sb_list)) {
-		spin_lock(&inode_sb_list_lock);
+		spin_lock(&inode->i_sb->s_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
-		spin_unlock(&inode_sb_list_lock);
+		spin_unlock(&inode->i_sb->s_inode_list_lock);
 	}
 }
 
@@ -600,7 +598,7 @@ void evict_inodes(struct super_block *sb)
 	struct inode *inode, *next;
 	LIST_HEAD(dispose);
 
-	spin_lock(&inode_sb_list_lock);
+	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		if (atomic_read(&inode->i_count))
 			continue;
@@ -616,7 +614,7 @@ void evict_inodes(struct super_block *sb)
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&sb->s_inode_list_lock);
 
 	dispose_list(&dispose);
 }
@@ -637,7 +635,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	struct inode *inode, *next;
 	LIST_HEAD(dispose);
 
-	spin_lock(&inode_sb_list_lock);
+	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
@@ -660,7 +658,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&sb->s_inode_list_lock);
 
 	dispose_list(&dispose);
 
@@ -901,7 +899,7 @@ struct inode *new_inode(struct super_block *sb)
 {
 	struct inode *inode;
 
-	spin_lock_prefetch(&inode_sb_list_lock);
+	spin_lock_prefetch(&sb->s_inode_list_lock);
 
 	inode = new_inode_pseudo(sb);
 	if (inode)
diff --git a/fs/internal.h b/fs/internal.h
index 0b0db70..bdc0e86 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -110,7 +110,6 @@ extern int open_check_o_direct(struct file *f);
 /*
  * inode.c
  */
-extern spinlock_t inode_sb_list_lock;
 extern long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan,
 			    int nid);
 extern void inode_add_lru(struct inode *inode);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 74825be..fac139a 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -242,17 +242,17 @@ out:
 
 /**
  * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
- * @list: list of inodes being unmounted (sb->s_inodes)
+ * @sb: superblock being unmounted.
  *
  * Called during unmount with no locks held, so needs to be safe against
- * concurrent modifiers. We temporarily drop inode_sb_list_lock and CAN block.
+ * concurrent modifiers. We temporarily drop sb->s_inode_list_lock and CAN block.
  */
-void fsnotify_unmount_inodes(struct list_head *list)
+void fsnotify_unmount_inodes(struct super_block *sb)
 {
 	struct inode *inode, *next_i, *need_iput = NULL;
 
-	spin_lock(&inode_sb_list_lock);
-	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry_safe(inode, next_i, &sb->s_inodes, i_sb_list) {
 		struct inode *need_iput_tmp;
 
 		/*
@@ -288,7 +288,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
+		if ((&next_i->i_sb_list != &sb->s_inodes) &&
 		    atomic_read(&next_i->i_count)) {
 			spin_lock(&next_i->i_lock);
 			if (!(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
@@ -299,11 +299,11 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		}
 
 		/*
-		 * We can safely drop inode_sb_list_lock here because we hold
+		 * We can safely drop s_inode_list_lock here because we hold
 		 * references on both inode and next_i.  Also no new inodes
 		 * will be added since the umount has begun.
 		 */
-		spin_unlock(&inode_sb_list_lock);
+		spin_unlock(&sb->s_inode_list_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -315,7 +315,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 		iput(inode);
 
-		spin_lock(&inode_sb_list_lock);
+		spin_lock(&sb->s_inode_list_lock);
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&sb->s_inode_list_lock);
 }
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 017eaea..fe93be2 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -909,7 +909,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 	int reserved = 0;
 #endif
 
-	spin_lock(&inode_sb_list_lock);
+	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
@@ -920,7 +920,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_sb_list_lock);
+		spin_unlock(&sb->s_inode_list_lock);
 
 #ifdef CONFIG_QUOTA_DEBUG
 		if (unlikely(inode_get_rsv_space(inode) > 0))
@@ -932,15 +932,15 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
 		 * removed from s_inodes list while we dropped the
-		 * inode_sb_list_lock We cannot iput the inode now as we can be
+		 * s_inode_list_lock. We cannot iput the inode now as we can be
 		 * holding the last reference and we cannot iput it under
-		 * inode_sb_list_lock. So we keep the reference and iput it
+		 * s_inode_list_lock. So we keep the reference and iput it
 		 * later.
 		 */
 		old_inode = inode;
-		spin_lock(&inode_sb_list_lock);
+		spin_lock(&sb->s_inode_list_lock);
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&sb->s_inode_list_lock);
 	iput(old_inode);
 
 #ifdef CONFIG_QUOTA_DEBUG
@@ -1021,7 +1021,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 	struct inode *inode;
 	int reserved = 0;
 
-	spin_lock(&inode_sb_list_lock);
+	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -1035,7 +1035,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock(&sb->s_inode_list_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
 		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
diff --git a/fs/super.c b/fs/super.c
index 09da975..d4d753e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -201,6 +201,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
+		spin_lock_init(&s->s_inode_list_lock);
 
 		if (list_lru_init(&s->s_dentry_lru))
 			goto err_out;
@@ -441,7 +442,7 @@ void generic_shutdown_super(struct super_block *sb)
 		sync_filesystem(sb);
 		sb->s_flags &= ~MS_ACTIVE;
 
-		fsnotify_unmount_inodes(&sb->s_inodes);
+		fsnotify_unmount_inodes(sb);
 
 		evict_inodes(sb);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 51cf6ed..923b465 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1263,7 +1263,6 @@ struct super_block {
 #endif
 	const struct xattr_handler **s_xattr;
 
-	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
 	struct list_head __percpu *s_files;
@@ -1328,6 +1327,10 @@ struct super_block {
 	 */
 	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
 	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
+
+	/* s_inode_list_lock protects s_inodes */
+	spinlock_t		s_inode_list_lock ____cacheline_aligned_in_smp;
+	struct list_head	s_inodes;	/* all inodes */
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 4b2ee8d..3d58028 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -427,7 +427,7 @@ extern void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group, un
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_get_mark(struct fsnotify_mark *mark);
 extern void fsnotify_put_mark(struct fsnotify_mark *mark);
-extern void fsnotify_unmount_inodes(struct list_head *list);
+extern void fsnotify_unmount_inodes(struct super_block *sb);
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-- 
1.8.3.2

