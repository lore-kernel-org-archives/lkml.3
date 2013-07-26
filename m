Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab3GZVFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:05:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760038Ab3GZU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bert De Jonghe <Bert.DeJonghe@amplidata.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 28/45] writeback: Fix periodic writeback after fs mount
Date: Fri, 26 Jul 2013 13:57:48 -0700
Message-Id: <20130726205658.015733739@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
References: <20130726205654.896050165@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/block_dev.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -55,13 +55,21 @@ EXPORT_SYMBOL(I_BDEV);
 static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
+	bool wakeup_bdi = false;
+
 	spin_lock(&inode_wb_list_lock);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
-	if (inode->i_state & I_DIRTY)
+	if (inode->i_state & I_DIRTY) {
+		if (bdi_cap_writeback_dirty(dst) && !wb_has_dirty_io(&dst->wb))
+			wakeup_bdi = true;
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	}
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_wb_list_lock);
+
+	if (wakeup_bdi)
+		bdi_wakeup_thread_delayed(dst);
 }
 
 sector_t blkdev_max_block(struct block_device *bdev)


