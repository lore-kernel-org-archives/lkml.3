Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab3ENBWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:22:04 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63050 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab3ENBTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:25 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 15/21] virtio-blk: convert to batch completion
Date: Mon, 13 May 2013 18:18:52 -0700
Message-Id: <1368494338-7069-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/block/virtio_blk.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6472395..49d0ec2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -217,7 +217,8 @@ static void virtblk_bio_send_flush_work(struct work_struct *work)
 	virtblk_bio_send_flush(vbr);
 }
 
-static inline void virtblk_request_done(struct virtblk_req *vbr)
+static inline void virtblk_request_done(struct virtblk_req *vbr,
+					struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 	struct request *req = vbr->req;
@@ -231,11 +232,12 @@ static inline void virtblk_request_done(struct virtblk_req *vbr)
 		req->errors = (error != 0);
 	}
 
-	__blk_end_request_all(req, error);
+	blk_end_request_all_batch(req, error, batch);
 	mempool_free(vbr, vblk->pool);
 }
 
-static inline void virtblk_bio_flush_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_flush_done(struct virtblk_req *vbr,
+					  struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 
@@ -244,12 +246,13 @@ static inline void virtblk_bio_flush_done(struct virtblk_req *vbr)
 		INIT_WORK(&vbr->work, virtblk_bio_send_data_work);
 		queue_work(virtblk_wq, &vbr->work);
 	} else {
-		bio_endio(vbr->bio, virtblk_result(vbr));
+		bio_endio_batch(vbr->bio, virtblk_result(vbr), batch);
 		mempool_free(vbr, vblk->pool);
 	}
 }
 
-static inline void virtblk_bio_data_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_data_done(struct virtblk_req *vbr,
+					 struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 
@@ -259,17 +262,18 @@ static inline void virtblk_bio_data_done(struct virtblk_req *vbr)
 		INIT_WORK(&vbr->work, virtblk_bio_send_flush_work);
 		queue_work(virtblk_wq, &vbr->work);
 	} else {
-		bio_endio(vbr->bio, virtblk_result(vbr));
+		bio_endio_batch(vbr->bio, virtblk_result(vbr), batch);
 		mempool_free(vbr, vblk->pool);
 	}
 }
 
-static inline void virtblk_bio_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_done(struct virtblk_req *vbr,
+				    struct batch_complete *batch)
 {
 	if (unlikely(vbr->flags & VBLK_IS_FLUSH))
-		virtblk_bio_flush_done(vbr);
+		virtblk_bio_flush_done(vbr, batch);
 	else
-		virtblk_bio_data_done(vbr);
+		virtblk_bio_data_done(vbr, batch);
 }
 
 static void virtblk_done(struct virtqueue *vq)
@@ -279,16 +283,19 @@ static void virtblk_done(struct virtqueue *vq)
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	spin_lock_irqsave(vblk->disk->queue->queue_lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
 			if (vbr->bio) {
-				virtblk_bio_done(vbr);
+				virtblk_bio_done(vbr, &batch);
 				bio_done = true;
 			} else {
-				virtblk_request_done(vbr);
+				virtblk_request_done(vbr, &batch);
 				req_done = true;
 			}
 		}
@@ -298,6 +305,8 @@ static void virtblk_done(struct virtqueue *vq)
 		blk_start_queue(vblk->disk->queue);
 	spin_unlock_irqrestore(vblk->disk->queue->queue_lock, flags);
 
+	batch_complete(&batch);
+
 	if (bio_done)
 		wake_up(&vblk->queue_wait);
 }
-- 
1.8.2.1

