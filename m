Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab3IKEa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3IKE3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:05 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=1aplMkhZpAkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=62HwIonDmK4A:10 a=4QwW8FFgAAAA:8 a=VwQbUJbxAAAA:8 a=AS4sGvjE_V16y4d78mEA:9 a=lqSEDRh8CwwA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042858.399733982@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bert De Jonghe <Bert.DeJonghe@amplidata.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: [037/251] writeback: Fix periodic writeback after fs mount
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0037-writeback-Fix-periodic-writeback-after-fs-mount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit a5faeaf9109578e65e1a32e2a3e76c8b47e7dcb6 ]

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
CC: stable@vger.kernel.org # >= 3.0
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/block_dev.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index daaca3d..41f6594 100644
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
1.7.10.4


