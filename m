Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3GaEQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:55 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35001 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab3GaEQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwiaBFxcOAQEWJiiCJAEBBScvIxAIGDE5AxsZiA+4ao9zhBsDrFEqgSwk
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 06/11] bdi: add a new writeback list for sync
Date: Wed, 31 Jul 2013 14:15:45 +1000
Message-Id: <1375244150-27296-7-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

wait_sb_inodes() current does a walk of all inodes in the filesystem
to find dirty one to wait on during sync. This is highly
inefficient and wastes a lot of CPU when there are lots of clean
cached inodes that we don't need to wait on.

To avoid this "all inode" walk, we need to track inodes that are
currently under writeback that we need to wait for. We do this by
adding inodes to a writeback list on the bdi when the mapping is
first tagged as having pages under writeback.  wait_sb_inodes() can
then walk this list of "inodes under IO" and wait specifically just
for the inodes that the current sync(2) needs to wait for.

To avoid needing all the realted locking to be safe against
interrupts, Jan Kara suggested that we be lazy about removal from
the writeback list. That is, we don't remove inodes from the
writeback list on IO completion, but do it directly during a
wait_sb_inodes() walk.

This means that the a rare sync(2) call will have some work to do
skipping clean inodes However, in the current problem case of
concurrent sync workloads, concurrent wait_sb_inodes() calls only
walk the very recently dispatched inodes and hence should have very
little work to do.

This also means that we have to remove the inodes from the writeback
list during eviction. Do this in inode_wait_for_writeback() once
all writeback on the inode is complete.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c           | 110 +++++++++++++++++++++++++++++++++++++-------
 fs/inode.c                  |   1 +
 include/linux/backing-dev.h |   3 ++
 include/linux/fs.h          |   1 +
 mm/backing-dev.c            |   1 +
 mm/page-writeback.c         |  14 ++++++
 6 files changed, 114 insertions(+), 16 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b7ac1c2..638f122 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -176,6 +176,34 @@ void inode_wb_list_del(struct inode *inode)
 }
 
 /*
+ * mark an inode as under writeback on the given bdi
+ */
+void bdi_mark_inode_writeback(struct backing_dev_info *bdi, struct inode *inode)
+{
+	WARN_ON_ONCE(bdi != inode_to_bdi(inode));
+	if (list_empty(&inode->i_wb_list)) {
+		spin_lock(&bdi->wb.list_lock);
+		if (list_empty(&inode->i_wb_list))
+			list_add_tail(&inode->i_wb_list, &bdi->wb.b_writeback);
+		spin_unlock(&bdi->wb.list_lock);
+	}
+}
+
+/*
+ * clear an inode as under writeback on the given bdi
+ */
+static void bdi_clear_inode_writeback(struct backing_dev_info *bdi,
+				      struct inode *inode)
+{
+	WARN_ON_ONCE(bdi != inode_to_bdi(inode));
+	if (!list_empty(&inode->i_wb_list)) {
+		spin_lock(&bdi->wb.list_lock);
+		list_del_init(&inode->i_wb_list);
+		spin_unlock(&bdi->wb.list_lock);
+	}
+}
+
+/*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
  *
@@ -330,13 +358,18 @@ static void __inode_wait_for_writeback(struct inode *inode)
 }
 
 /*
- * Wait for writeback on an inode to complete. Caller must have inode pinned.
+ * Wait for writeback on an inode to complete during eviction. Caller must have
+ * inode pinned.
  */
 void inode_wait_for_writeback(struct inode *inode)
 {
+	BUG_ON(!(inode->i_state & I_FREEING));
+
 	spin_lock(&inode->i_lock);
 	__inode_wait_for_writeback(inode);
 	spin_unlock(&inode->i_lock);
+
+	bdi_clear_inode_writeback(inode_to_bdi(inode), inode);
 }
 
 /*
@@ -1218,7 +1251,9 @@ EXPORT_SYMBOL(__mark_inode_dirty);
  */
 static void wait_sb_inodes(struct super_block *sb)
 {
-	struct inode *inode, *old_inode = NULL;
+	struct backing_dev_info *bdi = sb->s_bdi;
+	struct inode *old_inode = NULL;
+	LIST_HEAD(sync_list);
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -1226,28 +1261,59 @@ static void wait_sb_inodes(struct super_block *sb)
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	mutex_lock(&sb->s_sync_lock);
-	spin_lock(&sb->s_inode_list_lock);
-
 	/*
-	 * Data integrity sync. Must wait for all pages under writeback,
-	 * because there may have been pages dirtied before our sync
-	 * call, but which had writeout started before we write it out.
-	 * In which case, the inode may not be on the dirty list, but
-	 * we still have to wait for that writeout.
+	 * Data integrity sync. Must wait for all pages under writeback, because
+	 * there may have been pages dirtied before our sync call, but which had
+	 * writeout started before we write it out.  In which case, the inode
+	 * may not be on the dirty list, but we still have to wait for that
+	 * writeout.
+	 *
+	 * To avoid syncing inodes put under IO after we have started here,
+	 * splice the io list to a temporary list head and walk that. Newly
+	 * dirtied inodes will go onto the primary list so we won't wait for
+	 * them. This is safe to do as we are serialised by the s_sync_lock,
+	 * so we'll complete processing the complete list before the next
+	 * sync operation repeats the splice-and-walk process.
+	 *
+	 * Inodes that have pages under writeback after we've finished the wait
+	 * may or may not be on the primary list. They had pages under put IO
+	 * after we started our wait, so we need to make sure the next sync or
+	 * IO completion treats them correctly, Move them back to the primary
+	 * list and restart the walk.
+	 *
+	 * Inodes that are clean after we have waited for them don't belong on
+	 * any list, so simply remove them from the sync list and move onwards.
 	 */
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	mutex_lock(&sb->s_sync_lock);
+	spin_lock(&bdi->wb.list_lock);
+	list_splice_init(&bdi->wb.b_writeback, &sync_list);
+
+	while (!list_empty(&sync_list)) {
+		struct inode *inode = list_first_entry(&sync_list, struct inode,
+						       i_wb_list);
 		struct address_space *mapping = inode->i_mapping;
 
+		/*
+		 * We are lazy on IO completion and don't remove inodes from the
+		 * list when they are clean. Detect that immediately and skip
+		 * inodes we don't ahve to wait on.
+		 */
+		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
+			list_del_init(&inode->i_wb_list);
+			cond_resched_lock(&bdi->wb.list_lock);
+			continue;
+		}
+
 		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    (mapping->nrpages == 0)) {
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+                        list_move(&inode->i_wb_list, &bdi->wb.b_writeback);
 			spin_unlock(&inode->i_lock);
+			cond_resched_lock(&bdi->wb.list_lock);
 			continue;
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb->s_inode_list_lock);
+		spin_unlock(&bdi->wb.list_lock);
 
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
@@ -1264,9 +1330,21 @@ static void wait_sb_inodes(struct super_block *sb)
 
 		cond_resched();
 
-		spin_lock(&sb->s_inode_list_lock);
+                /*
+                 * the inode has been written back now, so check whether we
+                 * still have pages under IO and move it back to the primary
+                 * list if necessary
+                 */
+                spin_lock_irq(&mapping->tree_lock);
+                spin_lock(&bdi->wb.list_lock);
+                if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
+                        WARN_ON(list_empty(&inode->i_wb_list));
+                        list_move(&inode->i_wb_list, &bdi->wb.b_writeback);
+                } else
+			list_del_init(&inode->i_wb_list);
+                spin_unlock_irq(&mapping->tree_lock);
 	}
-	spin_unlock(&sb->s_inode_list_lock);
+	spin_unlock(&bdi->wb.list_lock);
 	iput(old_inode);
 	mutex_unlock(&sb->s_sync_lock);
 }
diff --git a/fs/inode.c b/fs/inode.c
index f8e0f2f..de62d2b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -365,6 +365,7 @@ void inode_init_once(struct inode *inode)
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_io_list);
+	INIT_LIST_HEAD(&inode->i_wb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
 	address_space_init_once(&inode->i_data);
 	i_size_ordered_init(inode);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c388155..45edd8a 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -58,6 +58,7 @@ struct bdi_writeback {
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
+	struct list_head b_writeback;	/* inodes under writeback */
 	spinlock_t list_lock;		/* protects the b_* lists */
 };
 
@@ -125,6 +126,8 @@ void bdi_writeback_workfn(struct work_struct *work);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
 void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
+void bdi_mark_inode_writeback(struct backing_dev_info *bdi,
+			      struct inode *inode);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b99eb39..5bb84b1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -579,6 +579,7 @@ struct inode {
 	struct list_head	i_io_list;	/* backing dev IO list */
 	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
+	struct list_head	i_wb_list;	/* backing dev writeback list */
 	union {
 		struct hlist_head	i_dentry;
 		struct rcu_head		i_rcu;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 024d4ca..b0cc55a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -419,6 +419,7 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
+	INIT_LIST_HEAD(&wb->b_writeback);
 	spin_lock_init(&wb->list_lock);
 	INIT_DELAYED_WORK(&wb->dwork, bdi_writeback_workfn);
 }
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3f0c895..038c893 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2262,11 +2262,25 @@ int test_set_page_writeback(struct page *page)
 		spin_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestSetPageWriteback(page);
 		if (!ret) {
+			bool on_wblist;
+
+			on_wblist = mapping_tagged(mapping,
+						   PAGECACHE_TAG_WRITEBACK);
+
 			radix_tree_tag_set(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi))
 				__inc_bdi_stat(bdi, BDI_WRITEBACK);
+
+			/*
+			 * we can come through here when swapping anonymous
+			 * pages, so we don't necessarily have an inode to
+			 * track for sync. Inodes are remove lazily, so there is
+			 * no equivalent in test_clear_page_writeback().
+			 */
+			if (!on_wblist && mapping->host)
+				bdi_mark_inode_writeback(bdi, mapping->host);
 		}
 		if (!PageDirty(page))
 			radix_tree_tag_clear(&mapping->page_tree,
-- 
1.8.3.2

