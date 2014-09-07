Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaIGXEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:04:22 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38864 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaIGXES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:04:18 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6/6] bdi: reimplement bdev_inode_switch_bdi()
Date: Mon,  8 Sep 2014 08:04:01 +0900
Message-Id: <1410131041-1881-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410131041-1881-1-git-send-email-tj@kernel.org>
References: <1410131041-1881-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A block_device may be attached to different gendisks and thus
different bdis over time.  bdev_inode_switch_bdi() is used to switch
the associated bdi.  The function assumes that the inode could be
dirty and transfers it between bdis if so.  This is a bit nasty in
that it reaches into bdi internals.

This patch reimplements the function so that it writes out the inode
if dirty.  This is a lot simpler and can be implemented without
exposing bdi internals.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/block_dev.c              | 32 +++++++++++---------------------
 include/linux/backing-dev.h |  1 -
 mm/backing-dev.c            |  2 +-
 3 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index d3251ec..cc8d68a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -50,32 +50,22 @@ inline struct block_device *I_BDEV(struct inode *inode)
 EXPORT_SYMBOL(I_BDEV);
 
 /*
- * Move the inode from its current bdi to a new bdi. If the inode is dirty we
- * need to move it onto the dirty list of @dst so that the inode is always on
- * the right list.
+ * Move the inode from its current bdi to a new bdi.  Make sure the inode
+ * is clean before moving so that it doesn't linger on the old bdi.
  */
 static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
-	struct backing_dev_info *old = inode->i_data.backing_dev_info;
-	bool wakeup_bdi = false;
-
-	if (unlikely(dst == old))		/* deadlock avoidance */
-		return;
-	bdi_lock_two(&old->wb, &dst->wb);
-	spin_lock(&inode->i_lock);
-	inode->i_data.backing_dev_info = dst;
-	if (inode->i_state & I_DIRTY) {
-		if (bdi_cap_writeback_dirty(dst) && !wb_has_dirty_io(&dst->wb))
-			wakeup_bdi = true;
-		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	while (true) {
+		spin_lock(&inode->i_lock);
+		if (!(inode->i_state & I_DIRTY)) {
+			inode->i_data.backing_dev_info = dst;
+			spin_unlock(&inode->i_lock);
+			return;
+		}
+		spin_unlock(&inode->i_lock);
+		WARN_ON_ONCE(write_inode_now(inode, true));
 	}
-	spin_unlock(&inode->i_lock);
-	spin_unlock(&old->wb.list_lock);
-	spin_unlock(&dst->wb.list_lock);
-
-	if (wakeup_bdi)
-		bdi_wakeup_thread_delayed(dst);
 }
 
 /* Kill _all_ buffers and pagecache , dirty or not.. */
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2103a7f..5da6012 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -121,7 +121,6 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi);
 void bdi_writeback_workfn(struct work_struct *work);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
-void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b65fe93..7d63d5e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -40,7 +40,7 @@ LIST_HEAD(bdi_list);
 /* bdi_wq serves all asynchronous writeback tasks */
 struct workqueue_struct *bdi_wq;
 
-void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
+static void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
 {
 	if (wb1 < wb2) {
 		spin_lock(&wb1->list_lock);
-- 
1.9.3

