Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab3G3KFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:05:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab3G3JcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 002/106] writeback: Fix periodic writeback after fs mount
Date: Tue, 30 Jul 2013 10:30:21 +0100
Message-Id: <1375176725-5825-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a5faeaf9109578e65e1a32e2a3e76c8b47e7dcb6 upstream.

Code in blkdev.c moves a device inode to default_backing_dev_info when
the last reference to the device is put and moves the device inode back
to its bdi when the first reference is acquired. This includes moving to
wb.b_dirty list if the device inode is dirty. The code however doesn't
setup timer to wake corresponding flusher thread and while wb.b_dirty
list is non-empty __mark_inode_dirty() will not set it up either. Thus
periodic writeback is effectively disabled until a sync(2) call which can
lead to unexpected data loss in case of crash or power failure.

Fix the problem by setting up a timer for periodic writeback in case we
add the first dirty inode to wb.b_dirty list in bdev_inode_switch_bdi().

Reported-by: Bert De Jonghe <Bert.DeJonghe@amplidata.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/block_dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1244094..7da78cf 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -57,17 +57,24 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
 	struct backing_dev_info *old = inode->i_data.backing_dev_info;
+	bool wakeup_bdi = false;
 
 	if (unlikely(dst == old))		/* deadlock avoidance */
 		return;
 	bdi_lock_two(&old->wb, &dst->wb);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
-	if (inode->i_state & I_DIRTY)
+	if (inode->i_state & I_DIRTY) {
+		if (bdi_cap_writeback_dirty(dst) && !wb_has_dirty_io(&dst->wb))
+			wakeup_bdi = true;
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	}
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&old->wb.list_lock);
 	spin_unlock(&dst->wb.list_lock);
+
+	if (wakeup_bdi)
+		bdi_wakeup_thread_delayed(dst);
 }
 
 sector_t blkdev_max_block(struct block_device *bdev)
-- 
1.8.3.2

