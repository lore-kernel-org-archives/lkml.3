Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3GaEQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:06 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34980 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab3GaEQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwz0XDgEBFiYogiQBAQUnLyMQCBgxOQMbGYgPuGqUDgOMQJI4gwiKUSo
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 05/11] inode: rename i_wb_list to i_io_list
Date: Wed, 31 Jul 2013 14:15:44 +1000
Message-Id: <1375244150-27296-6-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There's a small consistency problem between the inode and writeback
naming. Writeback calls the "for IO" inode queues b_io and
b_more_io, but the inode calls these the "writeback list" or
i_wb_list. This makes it hard to an new "under writeback" list to
the inode, or call it an "under IO" list on the bdi because either
way we'll have writeback on IO and IO on writeback and it'll just be
confusing. I'm getting confused just writing this!

So, rename the inode "for IO" list variable to i_io_list so we can
add a new "writeback list" in a subsequent patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c     |  2 +-
 fs/fs-writeback.c  | 18 +++++++++---------
 fs/inode.c         |  6 +++---
 include/linux/fs.h |  2 +-
 mm/backing-dev.c   |  6 +++---
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c39c0f3..bec0c26 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -68,7 +68,7 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 	if (inode->i_state & I_DIRTY) {
 		if (bdi_cap_writeback_dirty(dst) && !wb_has_dirty_io(&dst->wb))
 			wakeup_bdi = true;
-		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+		list_move(&inode->i_io_list, &dst->wb.b_dirty);
 	}
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&old->wb.list_lock);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 56272ec..b7ac1c2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -77,7 +77,7 @@ static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
 
 static inline struct inode *wb_inode(struct list_head *head)
 {
-	return list_entry(head, struct inode, i_wb_list);
+	return list_entry(head, struct inode, i_io_list);
 }
 
 /*
@@ -171,7 +171,7 @@ void inode_wb_list_del(struct inode *inode)
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 
 	spin_lock(&bdi->wb.list_lock);
-	list_del_init(&inode->i_wb_list);
+	list_del_init(&inode->i_io_list);
 	spin_unlock(&bdi->wb.list_lock);
 }
 
@@ -194,7 +194,7 @@ static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
 		if (time_before(inode->dirtied_when, tail->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
-	list_move(&inode->i_wb_list, &wb->b_dirty);
+	list_move(&inode->i_io_list, &wb->b_dirty);
 }
 
 /*
@@ -203,7 +203,7 @@ static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
 static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
 {
 	assert_spin_locked(&wb->list_lock);
-	list_move(&inode->i_wb_list, &wb->b_more_io);
+	list_move(&inode->i_io_list, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -254,7 +254,7 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
 		sb = inode->i_sb;
-		list_move(&inode->i_wb_list, &tmp);
+		list_move(&inode->i_io_list, &tmp);
 		moved++;
 	}
 
@@ -270,7 +270,7 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 		list_for_each_prev_safe(pos, node, &tmp) {
 			inode = wb_inode(pos);
 			if (inode->i_sb == sb)
-				list_move(&inode->i_wb_list, dispatch_queue);
+				list_move(&inode->i_io_list, dispatch_queue);
 		}
 	}
 out:
@@ -418,7 +418,7 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
 		redirty_tail(inode, wb);
 	} else {
 		/* The inode is clean. Remove from writeback lists. */
-		list_del_init(&inode->i_wb_list);
+		list_del_init(&inode->i_io_list);
 	}
 }
 
@@ -528,7 +528,7 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	 * touch it. See comment above for explanation.
 	 */
 	if (!(inode->i_state & I_DIRTY))
-		list_del_init(&inode->i_wb_list);
+		list_del_init(&inode->i_io_list);
 	spin_unlock(&wb->list_lock);
 	inode_sync_complete(inode);
 out:
@@ -1193,7 +1193,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.list_lock);
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
+			list_move(&inode->i_io_list, &bdi->wb.b_dirty);
 			spin_unlock(&bdi->wb.list_lock);
 
 			if (wakeup_bdi)
diff --git a/fs/inode.c b/fs/inode.c
index cd10287..f8e0f2f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -30,7 +30,7 @@
  * inode->i_sb->s_inode_list_lock protects:
  *   inode->i_sb->s_inodes, inode->i_sb_list
  * bdi->wb.list_lock protects:
- *   bdi->wb.b_{dirty,io,more_io}, inode->i_wb_list
+ *   bdi->wb.b_{dirty,io,more_io}, inode->i_io_list
  * inode_hash_lock protects:
  *   inode_hashtable, inode->i_hash
  *
@@ -364,7 +364,7 @@ void inode_init_once(struct inode *inode)
 	memset(inode, 0, sizeof(*inode));
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_devices);
-	INIT_LIST_HEAD(&inode->i_wb_list);
+	INIT_LIST_HEAD(&inode->i_io_list);
 	INIT_LIST_HEAD(&inode->i_lru);
 	address_space_init_once(&inode->i_data);
 	i_size_ordered_init(inode);
@@ -530,7 +530,7 @@ static void evict(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(!list_empty(&inode->i_lru));
 
-	if (!list_empty(&inode->i_wb_list))
+	if (!list_empty(&inode->i_io_list))
 		inode_wb_list_del(inode);
 
 	inode_sb_list_del(inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 971e8be..b99eb39 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -576,7 +576,7 @@ struct inode {
 	unsigned long		dirtied_when;	/* jiffies of first dirtying */
 
 	struct hlist_node	i_hash;
-	struct list_head	i_wb_list;	/* backing dev IO list */
+	struct list_head	i_io_list;	/* backing dev IO list */
 	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
 	union {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index e04454c..024d4ca 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -74,11 +74,11 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 
 	nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&wb->list_lock);
-	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
+	list_for_each_entry(inode, &wb->b_dirty, i_io_list)
 		nr_dirty++;
-	list_for_each_entry(inode, &wb->b_io, i_wb_list)
+	list_for_each_entry(inode, &wb->b_io, i_io_list)
 		nr_io++;
-	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
+	list_for_each_entry(inode, &wb->b_more_io, i_io_list)
 		nr_more_io++;
 	spin_unlock(&wb->list_lock);
 
-- 
1.8.3.2

