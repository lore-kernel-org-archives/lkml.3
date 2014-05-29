Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbaE2H3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:29:06 -0400
Received: from ozlabs.org ([103.22.144.67]:60256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbaE2H2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:28:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/4] Hack: measure stack taken by vring from virtio_blk
Date: Thu, 29 May 2014 16:56:42 +0930
Message-Id: <1401348405-18614-2-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
References: <87oayh6s3s.fsf@rustcorp.com.au>
 <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Results (x86-64, Minchan's .config):

gcc 4.8.2: virtio_blk: stack used = 392
gcc 4.6.4: virtio_blk: stack used = 528

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c   | 11 ++++++++++-
 drivers/virtio/virtio_ring.c | 11 +++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index cb9b1f8326c3..894e290b4bd2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -151,15 +151,19 @@ static void virtblk_done(struct virtqueue *vq)
 	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 }
 
+extern struct task_struct *record_stack;
+extern unsigned long stack_top;
+
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 {
 	struct virtio_blk *vblk = hctx->queue->queuedata;
 	struct virtblk_req *vbr = req->special;
 	unsigned long flags;
 	unsigned int num;
+	unsigned long stack_bottom;
 	const bool last = (req->cmd_flags & REQ_END) != 0;
 	int err;
-
+	
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
 	vbr->req = req;
@@ -199,7 +203,12 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	}
 
 	spin_lock_irqsave(&vblk->vq_lock, flags);
+	record_stack = current;
+	__asm__ __volatile__("movq %%rsp,%0" : "=g" (stack_bottom));
 	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
+	record_stack = NULL;
+
+	printk("virtio_blk: stack used = %lu\n", stack_bottom - stack_top);
 	if (err) {
 		virtqueue_kick(vblk->vq);
 		blk_mq_stop_hw_queue(hctx);
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4d08f45a9c29..f6ad99ffdc40 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -54,6 +54,14 @@
 #define END_USE(vq)
 #endif
 
+extern struct task_struct *record_stack;
+struct task_struct *record_stack;
+EXPORT_SYMBOL(record_stack);
+
+extern unsigned long stack_top;
+unsigned long stack_top;
+EXPORT_SYMBOL(stack_top);
+
 struct vring_virtqueue
 {
 	struct virtqueue vq;
@@ -137,6 +145,9 @@ static inline int vring_add_indirect(struct vring_virtqueue *vq,
 	 */
 	gfp &= ~(__GFP_HIGHMEM | __GFP_HIGH);
 
+	if (record_stack == current)
+		__asm__ __volatile__("movq %%rsp,%0" : "=g" (stack_top));
+
 	desc = kmalloc(total_sg * sizeof(struct vring_desc), gfp);
 	if (!desc)
 		return -ENOMEM;
-- 
1.9.1

