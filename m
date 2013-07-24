Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3GXOQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:16:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45782 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150Ab3GXOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bert De Jonghe" <Bert.DeJonghe@amplidata.com>,
        "Jens Axboe" <axboe@kernel.dk>, "Jan Kara" <jack@suse.cz>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.243493672@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [50/85] writeback: Fix periodic writeback after fs mount
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/block_dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -55,17 +55,24 @@ static void bdev_inode_switch_bdi(struct
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

