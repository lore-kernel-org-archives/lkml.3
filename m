Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaEPO5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:57:40 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:59856 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbaEPO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:57:39 -0400
Message-ID: <5376275F.8030709@kernel.dk>
Date: Fri, 16 May 2014 08:57:35 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_blk: fix race between start and stop queue
References: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com> <53762662.2050702@kernel.dk>
In-Reply-To: <53762662.2050702@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------090206030003090204000509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090206030003090204000509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-05-16 08:53, Jens Axboe wrote:
> On 2014-05-15 06:33, Ming Lei wrote:
>> When there isn't enough vring descriptor for adding to vq,
>> blk-mq will be put as stopped state until some of pending
>> descriptors are completed & freed.
>>
>> Unfortunately, the vq's interrupt may come just before
>> blk-mq's BLK_MQ_S_STOPPED flag is set, so the blk-mq will
>> still be kept as stopped even though lots of descriptors
>> are completed and freed in the interrupt handler. The worst
>> case is that all pending descriptors are freed in the
>> interrupt handler, and the queue is kept as stopped forever.
>>
>> This patch fixes the problem by starting/stopping blk-mq
>> with holding vq_lock.
>
> Why not just use blk_mq_start_hw_queues()?

Or, if you want to maintain current heuristics, just move the start and 
stop under the vq_lock. That should prevent the race, as far as I can 
tell. Not sure what that extra queue_stopped would buy you, seems a lot 
cleaner to just maintain this state exclusively in the queue.

-- 
Jens Axboe


--------------090206030003090204000509
Content-Type: text/x-patch;
 name="virtio-blk-start.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="virtio-blk-start.patch"

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7a51f065edcd..2e328231a795 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -147,11 +147,12 @@ static void virtblk_done(struct virtqueue *vq)
 		if (unlikely(virtqueue_is_broken(vq)))
 			break;
 	} while (!virtqueue_enable_cb(vq));
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
+
+	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -205,8 +206,8 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
 	if (err) {
 		virtqueue_kick(vblk->vq);
-		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		blk_mq_stop_hw_queue(hctx);
+		spin_unlock_irqrestore(&vblk->vq_lock, flags);
 		/* Out of mem doesn't actually happen, since we fall back
 		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)

--------------090206030003090204000509--
