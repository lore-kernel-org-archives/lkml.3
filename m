Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaERXgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 19:36:25 -0400
Received: from ozlabs.org ([103.22.144.67]:33998 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaERXgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 19:36:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] virtio_blk: fix race between start and stop queue
In-Reply-To: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com>
References: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 16 May 2014 11:29:45 +0930
Message-ID: <8761l6lbzi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:
> When there isn't enough vring descriptor for adding to vq,
> blk-mq will be put as stopped state until some of pending
> descriptors are completed & freed.
>
> Unfortunately, the vq's interrupt may come just before
> blk-mq's BLK_MQ_S_STOPPED flag is set, so the blk-mq will
> still be kept as stopped even though lots of descriptors
> are completed and freed in the interrupt handler. The worst
> case is that all pending descriptors are freed in the
> interrupt handler, and the queue is kept as stopped forever.
>
> This patch fixes the problem by starting/stopping blk-mq
> with holding vq_lock.

OK, but why the flag?  Isn't moving the
        blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);

inside the lock sufficient?

Cheers,
Rusty.



>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/block/virtio_blk.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 7a51f06..97f53ac 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -42,6 +42,9 @@ struct virtio_blk
>  	/* enable config space updates */
>  	bool config_enable;
>  
> +	/* if the request queue is stopped, protected by vq_lock */
> +	bool queue_stopped;
> +
>  	/* What host tells us, plus 2 for header & tailer. */
>  	unsigned int sg_elems;
>  
> @@ -147,11 +150,13 @@ static void virtblk_done(struct virtqueue *vq)
>  		if (unlikely(virtqueue_is_broken(vq)))
>  			break;
>  	} while (!virtqueue_enable_cb(vq));
> -	spin_unlock_irqrestore(&vblk->vq_lock, flags);
>  
>  	/* In case queue is stopped waiting for more buffers. */
> -	if (req_done)
> +	if (req_done && vblk->queue_stopped) {
>  		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
> +		vblk->queue_stopped = false;
> +	}
> +	spin_unlock_irqrestore(&vblk->vq_lock, flags);
>  }
>  
>  static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> @@ -205,8 +210,9 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>  	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
>  	if (err) {
>  		virtqueue_kick(vblk->vq);
> -		spin_unlock_irqrestore(&vblk->vq_lock, flags);
>  		blk_mq_stop_hw_queue(hctx);
> +		vblk->queue_stopped = true;
> +		spin_unlock_irqrestore(&vblk->vq_lock, flags);
>  		/* Out of mem doesn't actually happen, since we fall back
>  		 * to direct descriptors */
>  		if (err == -ENOMEM || err == -ENOSPC)
> @@ -598,6 +604,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	vblk->disk->fops = &virtblk_fops;
>  	vblk->disk->driverfs_dev = &vdev->dev;
>  	vblk->index = index;
> +	vblk->queue_stopped = false;
>  
>  	/* configure queue flush support */
>  	virtblk_update_cache_mode(vdev);
> -- 
> 1.7.9.5
