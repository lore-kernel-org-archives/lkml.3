Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbaBEUk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:40:59 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48336 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaBEUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 123/213] fix crash in scsi_dispatch_cmd()
Date: Wed, 5 Feb 2014 15:01:18 -0500
Message-ID: <1391630568-49251-124-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1 upstream.

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

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 block/blk-core.c        | 3 +++
 block/blk-exec.c        | 7 +++++++
 drivers/scsi/scsi_lib.c | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 94f274bc9683..2ddcf96c854d 100644
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
index 49557e91f0da..85bd7b445d86 100644
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
index ca8666b19c54..6712297407bb 100644
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
1.8.5.2

