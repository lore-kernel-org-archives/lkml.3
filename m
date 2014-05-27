Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaE0Ooq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:44:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6112 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751250AbaE0Oon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:44:43 -0400
Date: Tue, 27 May 2014 08:44:37 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <sakari.ailus@iki.fi>,
        <rusty@rustcorp.com.au>
Subject: [GIT PULL] virtio_blk fix for 3.15
Message-ID: <20140527144437.GA31504@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-27_04:2014-05-26,2014-05-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.1206036099054e-12 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997600857122248
 urlsuspect_oldscore=0.997600857122248 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997600857122248 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1405270203
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's a start/stop queue race in virtio_blk, which causes stalls and
erratic behaviour for some. I've had this queued up for 3.16 for a
while, but I think we should push it into the current series as well. So
I cherry picked the commit and added a stable marker as well, so it can
propagate down.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

  virtio_blk: fix race between start and stop queue (2014-05-27 08:41:10 -0600)

----------------------------------------------------------------
Ming Lei (1):
      virtio_blk: fix race between start and stop queue

 drivers/block/virtio_blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6d8a87f252de..cb9b1f8326c3 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -144,11 +144,11 @@ static void virtblk_done(struct virtqueue *vq)
 		if (unlikely(virtqueue_is_broken(vq)))
 			break;
 	} while (!virtqueue_enable_cb(vq));
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
+	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -202,8 +202,8 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
 	if (err) {
 		virtqueue_kick(vblk->vq);
-		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		blk_mq_stop_hw_queue(hctx);
+		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		/* Out of mem doesn't actually happen, since we fall back
 		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)

-- 
Jens Axboe

