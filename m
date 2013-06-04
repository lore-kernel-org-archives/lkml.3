Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3FDXF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:05:58 -0400
Received: from 1wt.eu ([62.212.114.60]:35594 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab3FDWmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:53 -0400
Message-Id: <20130604172133.622241742@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable@kernel.org, James Bottomley <JBottomley@Parallels.com>,
        Thomas Bork <tom@eisfair.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 080/184] [SCSI] fix crash in scsi_dispatch_cmd()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

USB surprise removal of sr is triggering an oops in
scsi_dispatch_command().  What seems to be happening is that USB is
hanging on to a queue reference until the last close of the upper
device, so the crash is caused by surprise remove of a mounted CD
followed by attempted unmount.

The problem is that USB doesn't issue its final commands as part of
the SCSI teardown path, but on last close when the block queue is long
gone.  The long term fix is probably to make sr do the teardown in the
same way as sd (so remove all the lower bits on ejection, but keep the
upper disk alive until last close of user space).  However, the
current oops can be simply fixed by not allowing any commands to be
sent to a dead queue.

Cc: stable@kernel.org
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
(cherry picked from commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1)
Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 block/blk-core.c        | 3 +++
 block/blk-exec.c        | 7 +++++++
 drivers/scsi/scsi_lib.c | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 00ac586..4058f46 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -865,6 +865,9 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	struct request *rq;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return NULL;
+
 	BUG_ON(rw != READ && rw != WRITE);
 
 	spin_lock_irq(q->queue_lock);
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 49557e9..85bd7b4 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -50,6 +50,13 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+		rq->errors = -ENXIO;
+		if (rq->end_io)
+			rq->end_io(rq, rq->errors);
+		return;
+	}
+
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
 	WARN_ON(irqs_disabled());
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e28f9b0..933f1c5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -215,6 +215,8 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
+	if (!req)
+		return ret;
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_WAIT))
-- 
1.7.12.2.21.g234cd45.dirty



