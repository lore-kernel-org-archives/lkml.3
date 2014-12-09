Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaLIP5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:57:51 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:55707 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaLIP5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:57:49 -0500
Message-ID: <54871BFC.6070001@acm.org>
Date: Tue, 09 Dec 2014 16:57:48 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] blk-mq: Fix a use-after-free
References: <54871BD0.8020305@acm.org>
In-Reply-To: <54871BD0.8020305@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk-mq users are allowed to free the memory request_queue.tag_set
points at after blk_cleanup_queue() has finished but before
blk_release_queue() has started. This can happen e.g. in the SCSI
core. The SCSI core namely embeds the tag_set structure in a SCSI
host structure. The SCSI host structure is freed by
scsi_host_dev_release(). This function is called after
blk_cleanup_queue() finished but can be called before
blk_release_queue().

This means that it is not safe to access request_queue.tag_set from
inside blk_release_queue(). Hence remove the blk_sync_queue() call
from blk_release_queue(). This call is not necessary - outstanding
requests must have finished before blk_release_queue() is
called. Additionally, move the blk_mq_free_queue() call from
blk_release_queue() to blk_cleanup_queue() to avoid that struct
request_queue.tag_set gets accessed after it has been freed.

This patch avoids that the following kernel oops can be triggered
when deleting a SCSI host for which scsi-mq was enabled:

Call Trace:
 [<ffffffff8109a7c4>] lock_acquire+0xc4/0x270
 [<ffffffff814ce111>] mutex_lock_nested+0x61/0x380
 [<ffffffff812575f0>] blk_mq_free_queue+0x30/0x180
 [<ffffffff8124d654>] blk_release_queue+0x84/0xd0
 [<ffffffff8126c29b>] kobject_cleanup+0x7b/0x1a0
 [<ffffffff8126c140>] kobject_put+0x30/0x70
 [<ffffffff81245895>] blk_put_queue+0x15/0x20
 [<ffffffff8125c409>] disk_release+0x99/0xd0
 [<ffffffff8133d056>] device_release+0x36/0xb0
 [<ffffffff8126c29b>] kobject_cleanup+0x7b/0x1a0
 [<ffffffff8126c140>] kobject_put+0x30/0x70
 [<ffffffff8125a78a>] put_disk+0x1a/0x20
 [<ffffffff811d4cb5>] __blkdev_put+0x135/0x1b0
 [<ffffffff811d56a0>] blkdev_put+0x50/0x160
 [<ffffffff81199eb4>] kill_block_super+0x44/0x70
 [<ffffffff8119a2a4>] deactivate_locked_super+0x44/0x60
 [<ffffffff8119a87e>] deactivate_super+0x4e/0x70
 [<ffffffff811b9833>] cleanup_mnt+0x43/0x90
 [<ffffffff811b98d2>] __cleanup_mnt+0x12/0x20
 [<ffffffff8107252c>] task_work_run+0xac/0xe0
 [<ffffffff81002c01>] do_notify_resume+0x61/0xa0
 [<ffffffff814d2c58>] int_signal+0x12/0x17

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robert Elliott <elliott@hp.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: <stable@vger.kernel.org> # v3.13+
---
 block/blk-core.c  |  3 +++
 block/blk-sysfs.c | 12 ++++--------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2e7424b..a681827 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -525,6 +525,9 @@ void blk_cleanup_queue(struct request_queue *q)
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
 	blk_sync_queue(q);
 
+	if (q->mq_ops)
+		blk_mq_free_queue(q);
+
 	spin_lock_irq(lock);
 	if (q->queue_lock != &q->__queue_lock)
 		q->queue_lock = &q->__queue_lock;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1fac434..935ea2a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -492,17 +492,15 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_head)
  *     Currently, its primary task it to free all the &struct request
  *     structures that were allocated to the queue and the queue itself.
  *
- * Caveat:
- *     Hopefully the low level driver will have finished any
- *     outstanding requests first...
+ * Note:
+ *     The low level driver must have finished any outstanding requests first
+ *     via blk_cleanup_queue().
  **/
 static void blk_release_queue(struct kobject *kobj)
 {
 	struct request_queue *q =
 		container_of(kobj, struct request_queue, kobj);
 
-	blk_sync_queue(q);
-
 	blkcg_exit_queue(q);
 
 	if (q->elevator) {
@@ -517,9 +515,7 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
-	if (q->mq_ops)
-		blk_mq_free_queue(q);
-	else
+	if (!q->mq_ops)
 		blk_free_flush_queue(q->fq);
 
 	blk_trace_shutdown(q);
-- 
2.1.2

