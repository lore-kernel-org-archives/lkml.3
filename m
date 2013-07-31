Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab3GaEQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:59 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34980 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab3GaEQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqkDAKOO+FF5LPxHgWdsb2JhbABbvjmDbYEXFw4BARYmKIIkAQEFGg0vIxAIGDE5AxsZiA+4ao5IgSuEGwOMQJI0gwyKUSqBLAEfBA
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 08/11] inode: convert per-sb inode list to a list_lru
Date: Wed, 31 Jul 2013 14:15:47 +1000
Message-Id: <1375244150-27296-9-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The per-superblock inode list and lock is a bottleneck for systems
that cycle inodes in and out of cache concurrently. The global lock
is a limiting factor.

Most of the additions to the sb inode list occur on the CPU that
allocated the inode, and most of the removals occur during evict()
calls as a result of memory reclaim. Both of these events are local
to the node that the inode belongs to, so it maps to the per-node
lists that the list_lru uses.

There are several places where the inode list is walked. These can
be converted easily to use list_lru_walk() to do their work on each
inode on the list.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c         |  75 ++++++++++++---------
 fs/drop_caches.c       |  57 +++++++++++-----
 fs/fs-writeback.c      |   4 +-
 fs/inode.c             | 134 +++++++++++++++++++------------------
 fs/notify/inode_mark.c | 111 +++++++++++++------------------
 fs/quota/dquot.c       | 174 ++++++++++++++++++++++++++++++++-----------------
 fs/super.c             |   9 ++-
 include/linux/fs.h     |   9 ++-
 8 files changed, 327 insertions(+), 246 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index bec0c26..b8ec2bd 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1665,38 +1665,55 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 }
 EXPORT_SYMBOL(__invalidate_device);
 
-void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
-{
-	struct inode *inode, *old_inode = NULL;
+struct bdev_iter {
+	void (*func)(struct block_device *, void *);
+	void *arg;
+	struct inode *toput_inode;
+};
 
-	spin_lock(&blockdev_superblock->s_inode_list_lock);
-	list_for_each_entry(inode, &blockdev_superblock->s_inodes, i_sb_list) {
-		struct address_space *mapping = inode->i_mapping;
+static enum lru_status
+bdev_iter_cb(struct list_head *item, spinlock_t *lock, void *cb_arg)
+{
+	struct bdev_iter *iter = cb_arg;
+	struct inode *inode = container_of(item, struct inode, i_sb_list);
 
-		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
-		    mapping->nrpages == 0) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		__iget(inode);
+	spin_lock(&inode->i_lock);
+	if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
+	    inode->i_mapping->nrpages == 0) {
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&blockdev_superblock->s_inode_list_lock);
-		/*
-		 * We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the
-		 * s_inode_list_lock  We cannot iput the inode now as we can
-		 * be holding the last reference and we cannot iput it under
-		 * s_inode_list_lock. So we keep the reference and iput it
-		 * later.
-		 */
-		iput(old_inode);
-		old_inode = inode;
+		return LRU_SKIP;
+	}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	spin_unlock(lock);
 
-		func(I_BDEV(inode), arg);
+	iput(iter->toput_inode);
+	iter->toput_inode = inode;
 
-		spin_lock(&blockdev_superblock->s_inode_list_lock);
-	}
-	spin_unlock(&blockdev_superblock->s_inode_list_lock);
-	iput(old_inode);
+	iter->func(I_BDEV(inode), iter->arg);
+
+	/*
+	 * Even though we have dropped the lock here, we can return LRU_SKIP as
+	 * we have a reference to the current inode and so it's next pointer is
+	 * guaranteed to be valid even though we dropped the list lock.
+	 */
+	spin_lock(lock);
+	return LRU_SKIP;
+}
+
+/*
+ * iterate_bdevs - run a callback across all block devices
+ */
+void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
+{
+	struct bdev_iter iter = {
+		.func = func,
+		.arg = arg,
+	};
+
+	list_lru_walk(&blockdev_superblock->s_inode_list, bdev_iter_cb, &iter,
+		      ULONG_MAX);
+
+	/* the list walk doesn't release the last inode it sees! */
+	iput(iter.toput_inode);
 }
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index f1be790..048a7d7 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -13,29 +13,50 @@
 /* A global variable is a bit ugly, but it keeps the code simple */
 int sysctl_drop_caches;
 
-static void drop_pagecache_sb(struct super_block *sb, void *unused)
+static enum lru_status
+drop_pagecache_inode(struct list_head *item, spinlock_t *lock, void *cb_arg)
 {
-	struct inode *inode, *toput_inode = NULL;
+	struct inode **toput_inode = cb_arg;
+	struct inode *inode = container_of(item, struct inode, i_sb_list);
 
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    (inode->i_mapping->nrpages == 0)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		__iget(inode);
+	spin_lock(&inode->i_lock);
+	if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+	    (inode->i_mapping->nrpages == 0)) {
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb->s_inode_list_lock);
+		return LRU_SKIP;
+	}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	spin_unlock(lock);
 
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
-		iput(toput_inode);
-		toput_inode = inode;
+	iput(*toput_inode);
+	*toput_inode = inode;
 
-		spin_lock(&sb->s_inode_list_lock);
-	}
-	spin_unlock(&sb->s_inode_list_lock);
+	invalidate_mapping_pages(inode->i_mapping, 0, -1);
+
+	/*
+	 * Even though we have dropped the lock here, we can return LRU_SKIP as
+	 * we have a reference to the current inode and so it's next pointer is
+	 * guaranteed to be valid even though we dropped the list lock.
+	 */
+	spin_lock(lock);
+	return LRU_SKIP;
+}
+
+
+/*
+ * This is a best effort scan, so we don't need to be absolutely sure we hit al
+ * inodes on the superblock. Hence a single pass is sufficient to catch them
+ * all.
+ */
+static void drop_pagecache_sb(struct super_block *sb, void *unused)
+{
+	struct inode *toput_inode = NULL;
+
+	list_lru_walk(&sb->s_inode_list, drop_pagecache_inode, &toput_inode,
+		      ULONG_MAX);
+
+	/* the list walk doesn't release the last inode it sees! */
 	iput(toput_inode);
 }
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7c9bbf0..f2d91de 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1337,9 +1337,9 @@ static void wait_sb_inodes(struct super_block *sb)
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
 		 * removed from s_inodes list while we dropped the
-		 * s_inode_list_lock.  We cannot iput the inode now as we can
+		 * wb.list_lock  We cannot iput the inode now as we can
 		 * be holding the last reference and we cannot iput it under
-		 * s_inode_list_lock. So we keep the reference and iput it
+		 * wb.list_lock So we keep the reference and iput it
 		 * later.
 		 */
 		iput(old_inode);
diff --git a/fs/inode.c b/fs/inode.c
index de62d2b..7eea591 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -27,8 +27,8 @@
  *   inode->i_state, inode->i_hash, __iget()
  * Inode LRU list locks protect:
  *   inode->i_sb->s_inode_lru, inode->i_lru
- * inode->i_sb->s_inode_list_lock protects:
- *   inode->i_sb->s_inodes, inode->i_sb_list
+ * Inode list locks protects:
+ *   inode->i_sb->s_inode_list, inode->i_sb_list
  * bdi->wb.list_lock protects:
  *   bdi->wb.b_{dirty,io,more_io}, inode->i_io_list
  * inode_hash_lock protects:
@@ -36,7 +36,7 @@
  *
  * Lock ordering:
  *
- * inode->i_sb->s_inode_list_lock
+ * Inode list lock
  *   inode->i_lock
  *     Inode LRU list locks
  *
@@ -44,7 +44,7 @@
  *   inode->i_lock
  *
  * inode_hash_lock
- *   inode->i_sb->s_inode_list_lock
+ *   Inode list lock
  *   inode->i_lock
  *
  * iunique_lock
@@ -366,6 +366,7 @@ void inode_init_once(struct inode *inode)
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_io_list);
 	INIT_LIST_HEAD(&inode->i_wb_list);
+	INIT_LIST_HEAD(&inode->i_sb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
 	address_space_init_once(&inode->i_data);
 	i_size_ordered_init(inode);
@@ -431,19 +432,13 @@ static void inode_lru_list_del(struct inode *inode)
  */
 void inode_sb_list_add(struct inode *inode)
 {
-	spin_lock(&inode->i_sb->s_inode_list_lock);
-	list_add(&inode->i_sb_list, &inode->i_sb->s_inodes);
-	spin_unlock(&inode->i_sb->s_inode_list_lock);
+	list_lru_add(&inode->i_sb->s_inode_list, &inode->i_sb_list);
 }
 EXPORT_SYMBOL_GPL(inode_sb_list_add);
 
 static inline void inode_sb_list_del(struct inode *inode)
 {
-	if (!list_empty(&inode->i_sb_list)) {
-		spin_lock(&inode->i_sb->s_inode_list_lock);
-		list_del_init(&inode->i_sb_list);
-		spin_unlock(&inode->i_sb->s_inode_list_lock);
-	}
+	list_lru_del(&inode->i_sb->s_inode_list, &inode->i_sb_list);
 }
 
 static unsigned long hash(struct super_block *sb, unsigned long hashval)
@@ -585,6 +580,48 @@ static void dispose_list(struct list_head *head)
 	}
 }
 
+static enum lru_status
+__evict_inodes_isolate(struct list_head *item, spinlock_t *lock, void *cb_arg,
+		       bool kill_dirty)
+{
+	struct list_head *dispose = cb_arg;
+	struct inode	*inode = container_of(item, struct inode, i_sb_list);
+
+	if (atomic_read(&inode->i_count))
+		return LRU_SKIP;
+
+	spin_lock(&inode->i_lock);
+	if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
+
+	if ((inode->i_state & I_DIRTY) && !kill_dirty) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
+
+	inode->i_state |= I_FREEING;
+	inode_lru_list_del(inode);
+	list_add(&inode->i_lru, dispose);
+
+	list_del_init(&inode->i_sb_list);
+	spin_unlock(&inode->i_lock);
+	return LRU_REMOVED;
+}
+
+static enum lru_status
+evict_inodes_isolate(struct list_head *item, spinlock_t *lock, void *cb_arg)
+{
+	return __evict_inodes_isolate(item, lock, cb_arg, true);
+}
+
+static enum lru_status
+invalidate_inodes_isolate(struct list_head *item, spinlock_t *lock, void *cb_arg)
+{
+	return __evict_inodes_isolate(item, lock, cb_arg, false);
+}
+
 /**
  * evict_inodes	- evict all evictable inodes for a superblock
  * @sb:		superblock to operate on
@@ -596,28 +633,15 @@ static void dispose_list(struct list_head *head)
  */
 void evict_inodes(struct super_block *sb)
 {
-	struct inode *inode, *next;
-	LIST_HEAD(dispose);
-
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
-		if (atomic_read(&inode->i_count))
-			continue;
-
-		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
+	long freed;
 
-		inode->i_state |= I_FREEING;
-		inode_lru_list_del(inode);
-		spin_unlock(&inode->i_lock);
-		list_add(&inode->i_lru, &dispose);
-	}
-	spin_unlock(&sb->s_inode_list_lock);
+	do {
+		LIST_HEAD(dispose);
 
-	dispose_list(&dispose);
+		freed = list_lru_walk(&sb->s_inode_list, evict_inodes_isolate,
+				      &dispose, ULONG_MAX);
+		dispose_list(&dispose);
+	} while (freed > 0);
 }
 
 /**
@@ -632,38 +656,24 @@ void evict_inodes(struct super_block *sb)
  */
 int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 {
-	int busy = 0;
-	struct inode *inode, *next;
-	LIST_HEAD(dispose);
+	list_lru_walk_cb isolate;
+	long freed;
 
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		if (inode->i_state & I_DIRTY && !kill_dirty) {
-			spin_unlock(&inode->i_lock);
-			busy = 1;
-			continue;
-		}
-		if (atomic_read(&inode->i_count)) {
-			spin_unlock(&inode->i_lock);
-			busy = 1;
-			continue;
-		}
+	isolate = kill_dirty ? evict_inodes_isolate :invalidate_inodes_isolate;
 
-		inode->i_state |= I_FREEING;
-		inode_lru_list_del(inode);
-		spin_unlock(&inode->i_lock);
-		list_add(&inode->i_lru, &dispose);
-	}
-	spin_unlock(&sb->s_inode_list_lock);
+	do {
+		LIST_HEAD(dispose);
 
-	dispose_list(&dispose);
+		freed = list_lru_walk(&sb->s_inode_list, isolate,
+				      &dispose, ULONG_MAX);
+		dispose_list(&dispose);
+	} while (freed > 0);
 
-	return busy;
+	/*
+	 * if we skipped any inodes because we couldn't isolate them, tell the
+	 * caller there are still active inodes.
+	 */
+	return !!list_lru_count(&sb->s_inode_list);
 }
 
 /*
@@ -866,7 +876,7 @@ EXPORT_SYMBOL(get_next_ino);
  *	@sb: superblock
  *
  *	Allocates a new inode for given superblock.
- *	Inode wont be chained in superblock s_inodes list
+ *	Inode wont be chained in superblock s_inode_list list
  *	This means :
  *	- fs can't be unmount
  *	- quotas, fsnotify, writeback can't work
@@ -900,8 +910,6 @@ struct inode *new_inode(struct super_block *sb)
 {
 	struct inode *inode;
 
-	spin_lock_prefetch(&sb->s_inode_list_lock);
-
 	inode = new_inode_pseudo(sb);
 	if (inode)
 		inode_sb_list_add(inode);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index fac139a..2aef9e5 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -240,82 +240,59 @@ out:
 	return ret;
 }
 
-/**
- * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
- * @sb: superblock being unmounted.
- *
- * Called during unmount with no locks held, so needs to be safe against
- * concurrent modifiers. We temporarily drop sb->s_inode_list_lock and CAN block.
- */
-void fsnotify_unmount_inodes(struct super_block *sb)
+static enum lru_status
+fsnotify_unmount_inode(struct list_head *item, spinlock_t *lock, void *cb_arg)
 {
-	struct inode *inode, *next_i, *need_iput = NULL;
-
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry_safe(inode, next_i, &sb->s_inodes, i_sb_list) {
-		struct inode *need_iput_tmp;
-
-		/*
-		 * We cannot __iget() an inode in state I_FREEING,
-		 * I_WILL_FREE, or I_NEW which is fine because by that point
-		 * the inode cannot have any associated watches.
-		 */
-		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
+	struct inode **toput_inode = cb_arg;
+	struct inode *inode = container_of(item, struct inode, i_sb_list);
 
-		/*
-		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an __iget/iput with MS_ACTIVE clear would actually
-		 * evict all inodes with zero i_count from icache which is
-		 * unnecessarily violent and may in fact be illegal to do.
-		 */
-		if (!atomic_read(&inode->i_count)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-
-		need_iput_tmp = need_iput;
-		need_iput = NULL;
+	/* New or being freed inodes cannot have any associated watches. */
+	spin_lock(&inode->i_lock);
+	if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
 
-		/* In case fsnotify_inode_delete() drops a reference. */
-		if (inode != need_iput_tmp)
-			__iget(inode);
-		else
-			need_iput_tmp = NULL;
+	/* If i_count is zero, the inode cannot have any watches */
+	if (!atomic_read(&inode->i_count)) {
 		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
 
-		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != &sb->s_inodes) &&
-		    atomic_read(&next_i->i_count)) {
-			spin_lock(&next_i->i_lock);
-			if (!(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-				__iget(next_i);
-				need_iput = next_i;
-			}
-			spin_unlock(&next_i->i_lock);
-		}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	spin_unlock(lock);
 
-		/*
-		 * We can safely drop s_inode_list_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.
-		 */
-		spin_unlock(&sb->s_inode_list_lock);
+	iput(*toput_inode);
+	*toput_inode = inode;
 
-		if (need_iput_tmp)
-			iput(need_iput_tmp);
+	/* for each watch, send FS_UNMOUNT and then remove it */
+	fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	fsnotify_inode_delete(inode);
 
-		/* for each watch, send FS_UNMOUNT and then remove it */
-		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	/*
+	 * Even though we have dropped the lock here, we can return LRU_SKIP as
+	 * we have a reference to the current inode and so it's next pointer is
+	 * guaranteed to be valid even though we dropped the list lock.
+	 */
+	spin_lock(lock);
+	return LRU_SKIP;
+}
 
-		fsnotify_inode_delete(inode);
+/**
+ * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
+ * @sb: superblock being unmounted.
+ *
+ * Called during unmount with the sb->s_umount held exclusively and so the inode
+ * list will not grow and so a single pass will catch all inodes.
+ */
+void fsnotify_unmount_inodes(struct super_block *sb)
+{
+	struct inode *toput_inode = NULL;
 
-		iput(inode);
+	list_lru_walk(&sb->s_inode_list, fsnotify_unmount_inode, &toput_inode,
+		      ULONG_MAX);
 
-		spin_lock(&sb->s_inode_list_lock);
-	}
-	spin_unlock(&sb->s_inode_list_lock);
+	/* the list walk doesn't release the last inode it sees! */
+	iput(toput_inode);
 }
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index fe93be2..829d7c8 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -901,55 +901,79 @@ static int dqinit_needed(struct inode *inode, int type)
 	return 0;
 }
 
-/* This routine is guarded by dqonoff_mutex mutex */
-static void add_dquot_ref(struct super_block *sb, int type)
+static enum lru_status
+add_dquot_ref_type(struct list_head *item, spinlock_t *lock, void *cb_arg,
+		int type)
 {
-	struct inode *inode, *old_inode = NULL;
-#ifdef CONFIG_QUOTA_DEBUG
-	int reserved = 0;
-#endif
+	struct inode **toput_inode = cb_arg;
+	struct inode *inode = container_of(item, struct inode, i_sb_list);
 
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    !atomic_read(&inode->i_writecount) ||
-		    !dqinit_needed(inode, type)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		__iget(inode);
+	spin_lock(&inode->i_lock);
+	if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+	    !atomic_read(&inode->i_writecount) ||
+	    !dqinit_needed(inode, type)) {
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb->s_inode_list_lock);
-
-#ifdef CONFIG_QUOTA_DEBUG
-		if (unlikely(inode_get_rsv_space(inode) > 0))
-			reserved = 1;
-#endif
-		iput(old_inode);
-		__dquot_initialize(inode, type);
-
-		/*
-		 * We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the
-		 * s_inode_list_lock. We cannot iput the inode now as we can be
-		 * holding the last reference and we cannot iput it under
-		 * s_inode_list_lock. So we keep the reference and iput it
-		 * later.
-		 */
-		old_inode = inode;
-		spin_lock(&sb->s_inode_list_lock);
+		return LRU_SKIP;
 	}
-	spin_unlock(&sb->s_inode_list_lock);
-	iput(old_inode);
+
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	spin_unlock(lock);
 
 #ifdef CONFIG_QUOTA_DEBUG
-	if (reserved) {
+	if (unlikely(inode_get_rsv_space(inode) > 0))
 		quota_error(sb, "Writes happened before quota was turned on "
 			"thus quota information is probably inconsistent. "
 			"Please run quotacheck(8)");
-	}
 #endif
+
+	iput(*toput_inode);
+	*toput_inode = inode;
+
+	__dquot_initialize(inode, type);
+
+	/*
+	 * Even though we have dropped the lock here, we can return LRU_SKIP as
+	 * we have a reference to the current inode and so it's next pointer is
+	 * guaranteed to be valid even though we dropped the list lock.
+	 */
+	spin_lock(lock);
+	return LRU_SKIP;
+}
+
+static enum lru_status
+add_dquot_ref_usr(struct list_head *item, spinlock_t *lock, void *cb_arg)
+{
+	return add_dquot_ref_type(item, lock, cb_arg, USRQUOTA);
+}
+
+static enum lru_status
+add_dquot_ref_grp(struct list_head *item, spinlock_t *lock, void *cb_arg)
+{
+	return add_dquot_ref_type(item, lock, cb_arg, GRPQUOTA);
+}
+
+/* add_dquot_ref is protected by the dqonoff_mutex mutex */
+void add_dquot_ref(struct super_block *sb, int type)
+{
+	struct inode *toput_inode = NULL;
+	list_lru_walk_cb isolate;
+
+	switch (type) {
+	case USRQUOTA:
+		isolate = add_dquot_ref_usr;
+		break;
+	case GRPQUOTA:
+		isolate = add_dquot_ref_grp;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+	list_lru_walk(&sb->s_inode_list, isolate, &toput_inode, ULONG_MAX);
+
+	/* the list walk doesn't release the last inode it sees! */
+	iput(toput_inode);
 }
 
 /*
@@ -1015,34 +1039,62 @@ static void put_dquot_list(struct list_head *tofree_head)
 	}
 }
 
-static void remove_dquot_ref(struct super_block *sb, int type,
-		struct list_head *tofree_head)
+static enum lru_status
+remove_dquot_ref_type(struct list_head *item, spinlock_t *lock, void *cb_arg,
+		      int type)
 {
-	struct inode *inode;
-	int reserved = 0;
+	struct list_head *tofree_head = cb_arg;
+	struct inode *inode = container_of(item, struct inode, i_sb_list);
 
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		/*
-		 *  We have to scan also I_NEW inodes because they can already
-		 *  have quota pointer initialized. Luckily, we need to touch
-		 *  only quota pointers and these have separate locking
-		 *  (dqptr_sem).
-		 */
-		if (!IS_NOQUOTA(inode)) {
-			if (unlikely(inode_get_rsv_space(inode) > 0))
-				reserved = 1;
-			remove_inode_dquot_ref(inode, type, tofree_head);
-		}
-	}
-	spin_unlock(&sb->s_inode_list_lock);
+	/*
+	 *  We have to scan also I_NEW inodes because they can already
+	 *  have quota pointer initialized. Luckily, we need to touch
+	 *  only quota pointers and these have separate locking
+	 *  (dqptr_sem).
+	 */
+	if (!IS_NOQUOTA(inode)) {
 #ifdef CONFIG_QUOTA_DEBUG
-	if (reserved) {
-		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
+		if (unlikely(inode_get_rsv_space(inode) > 0)) {
+			printk_ratelimited(KERN_WARNING
+			"VFS (%s): Writes happened after quota"
 			" was disabled thus quota information is probably "
 			"inconsistent. Please run quotacheck(8).\n", sb->s_id);
-	}
+		}
 #endif
+		remove_inode_dquot_ref(inode, type, tofree_head);
+	}
+	return LRU_SKIP;
+}
+
+static enum lru_status
+remove_dquot_ref_usr(struct list_head *item, spinlock_t *lock, void *cb_arg)
+{
+	return remove_dquot_ref_type(item, lock, cb_arg, USRQUOTA);
+}
+
+static enum lru_status
+remove_dquot_ref_grp(struct list_head *item, spinlock_t *lock, void *cb_arg)
+{
+	return remove_dquot_ref_type(item, lock, cb_arg, GRPQUOTA);
+}
+
+static void remove_dquot_ref(struct super_block *sb, int type,
+		struct list_head *tofree_head)
+{
+	list_lru_walk_cb isolate;
+
+	switch (type) {
+	case USRQUOTA:
+		isolate = remove_dquot_ref_usr;
+		break;
+	case GRPQUOTA:
+		isolate = remove_dquot_ref_grp;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+	list_lru_walk(&sb->s_inode_list, isolate, tofree_head, ULONG_MAX);
 }
 
 /* Gather all references from inodes and drop them */
diff --git a/fs/super.c b/fs/super.c
index 7f98fd6..97e2274 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -201,13 +201,13 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		mutex_init(&s->s_sync_lock);
-		INIT_LIST_HEAD(&s->s_inodes);
-		spin_lock_init(&s->s_inode_list_lock);
 
 		if (list_lru_init(&s->s_dentry_lru))
 			goto err_out;
 		if (list_lru_init(&s->s_inode_lru))
 			goto err_out_dentry_lru;
+		if (list_lru_init(&s->s_inode_list))
+			goto err_out_inode_lru;
 
 		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
@@ -249,6 +249,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 out:
 	return s;
 
+err_out_inode_lru:
+	list_lru_destroy(&s->s_inode_lru);
 err_out_dentry_lru:
 	list_lru_destroy(&s->s_dentry_lru);
 err_out:
@@ -332,6 +334,7 @@ void deactivate_locked_super(struct super_block *s)
 		unregister_shrinker(&s->s_shrink);
 		list_lru_destroy(&s->s_dentry_lru);
 		list_lru_destroy(&s->s_inode_lru);
+		list_lru_destroy(&s->s_inode_list);
 
 		put_filesystem(fs);
 		put_super(s);
@@ -450,7 +453,7 @@ void generic_shutdown_super(struct super_block *sb)
 		if (sop->put_super)
 			sop->put_super(sb);
 
-		if (!list_empty(&sb->s_inodes)) {
+		if (list_lru_count(&sb->s_inode_list)) {
 			printk("VFS: Busy inodes after unmount of %s. "
 			   "Self-destruct in 5 seconds.  Have a nice day...\n",
 			   sb->s_id);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bb84b1..28baf4d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1331,9 +1331,12 @@ struct super_block {
 	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
 	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
 
-	/* s_inode_list_lock protects s_inodes */
-	spinlock_t		s_inode_list_lock ____cacheline_aligned_in_smp;
-	struct list_head	s_inodes;	/* all inodes */
+	/*
+	 * the inode list is not strictly used as a LRU, but uses the list_lru
+	 * construct to provide a scalable list implemenation for adding,
+	 * removing and walking the inodes cached in memory.
+	 */
+	struct list_lru		s_inode_list ____cacheline_aligned_in_smp;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.8.3.2

