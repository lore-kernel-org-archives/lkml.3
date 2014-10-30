Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbaJ3NSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:18:34 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:60498 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431AbaJ3NSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:18:32 -0400
Message-ID: <54523AA4.9010307@acm.org>
Date: Thu, 30 Oct 2014 14:18:28 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] blk-mq: Fix a use-after-free
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the tag set structure can be embedded in a structure that
is freed before the last queue put occurs (e.g. the SCSI host
structure), the block layer must not access the tag set after the
SCSI host structure has been freed. This patch avoids that the
following kernel oops is triggered with memory poisoning enabled:

general protection fault: 0000 [#1] SMP
RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
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
Cc: Robert Elliott  <Elliott@hp.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: <stable@vger.kernel.org> # v3.12+
---
 block/blk-core.c  | 3 +++
 block/blk-sysfs.c | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0421b53..93f9152 100644
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
index 1fac434..3ce0da1 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -517,9 +517,7 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
-	if (q->mq_ops)
-		blk_mq_free_queue(q);
-	else
+	if (!q->mq_ops)
 		blk_free_flush_queue(q->fq);
 
 	blk_trace_shutdown(q);
-- 
1.8.4.5

