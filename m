Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab3BSIHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:07:50 -0500
Received: from ozlabs.org ([203.10.76.45]:38966 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191Ab3BSICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 03/16] virtio-blk: reorganize virtblk_add_req
Date: Tue, 19 Feb 2013 18:26:21 +1030
Message-Id: <1361260594-601-4-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Right now, both virtblk_add_req and virtblk_add_req_wait call
virtqueue_add_buf.  To prepare for the next patches, abstract the call
to virtqueue_add_buf into a new function __virtblk_add_req, and include
the waiting logic directly in virtblk_add_req.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Asias He <asias@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c |   55 ++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 35 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 8ad21a2..fd8a689 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -100,50 +100,39 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
 	return vbr;
 }
 
-static void virtblk_add_buf_wait(struct virtio_blk *vblk,
-				 struct virtblk_req *vbr,
-				 unsigned long out,
-				 unsigned long in)
+static inline int __virtblk_add_req(struct virtqueue *vq,
+			     struct virtblk_req *vbr,
+			     unsigned long out,
+			     unsigned long in)
 {
+	return virtqueue_add_buf(vq, vbr->sg, out, in, vbr, GFP_ATOMIC);
+}
+
+static void virtblk_add_req(struct virtblk_req *vbr,
+			    unsigned int out, unsigned int in)
+{
+	struct virtio_blk *vblk = vbr->vblk;
 	DEFINE_WAIT(wait);
+	int ret;
 
-	for (;;) {
+	spin_lock_irq(vblk->disk->queue->queue_lock);
+	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr,
+						 out, in)) < 0)) {
 		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
 					  TASK_UNINTERRUPTIBLE);
 
+		spin_unlock_irq(vblk->disk->queue->queue_lock);
+		io_schedule();
 		spin_lock_irq(vblk->disk->queue->queue_lock);
-		if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
-				      GFP_ATOMIC) < 0) {
-			spin_unlock_irq(vblk->disk->queue->queue_lock);
-			io_schedule();
-		} else {
-			virtqueue_kick(vblk->vq);
-			spin_unlock_irq(vblk->disk->queue->queue_lock);
-			break;
-		}
 
+		finish_wait(&vblk->queue_wait, &wait);
 	}
 
-	finish_wait(&vblk->queue_wait, &wait);
-}
-
-static inline void virtblk_add_req(struct virtblk_req *vbr,
-				   unsigned int out, unsigned int in)
-{
-	struct virtio_blk *vblk = vbr->vblk;
-
-	spin_lock_irq(vblk->disk->queue->queue_lock);
-	if (unlikely(virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
-					GFP_ATOMIC) < 0)) {
-		spin_unlock_irq(vblk->disk->queue->queue_lock);
-		virtblk_add_buf_wait(vblk, vbr, out, in);
-		return;
-	}
 	virtqueue_kick(vblk->vq);
 	spin_unlock_irq(vblk->disk->queue->queue_lock);
 }
 
-static int virtblk_bio_send_flush(struct virtblk_req *vbr)
+static void virtblk_bio_send_flush(struct virtblk_req *vbr)
 {
 	unsigned int out = 0, in = 0;
 
@@ -155,11 +144,9 @@ static int virtblk_bio_send_flush(struct virtblk_req *vbr)
 	sg_set_buf(&vbr->sg[out + in++], &vbr->status, sizeof(vbr->status));
 
 	virtblk_add_req(vbr, out, in);
-
-	return 0;
 }
 
-static int virtblk_bio_send_data(struct virtblk_req *vbr)
+static void virtblk_bio_send_data(struct virtblk_req *vbr)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 	unsigned int num, out = 0, in = 0;
@@ -188,8 +175,6 @@ static int virtblk_bio_send_data(struct virtblk_req *vbr)
 	}
 
 	virtblk_add_req(vbr, out, in);
-
-	return 0;
 }
 
 static void virtblk_bio_send_data_work(struct work_struct *work)
-- 
1.7.10.4

