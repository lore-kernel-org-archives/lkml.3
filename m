Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaE3P13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:27:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaE3P12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:27:28 -0400
Date: Fri, 30 May 2014 18:27:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world
 switch
Message-ID: <20140530152749.GB31250@redhat.com>
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 10:49:29AM +0800, Ming Lei wrote:
> Firstly, it isn't necessary to hold lock of vblk->vq_lock
> when notifying hypervisor about queued I/O.
> 
> Secondly, virtqueue_notify() will cause world switch and
> it may take long time on some hypervisors(such as, qemu-arm),
> so it isn't good to hold the lock and block other vCPUs.
> 
> On arm64 quad core VM(qemu-kvm), the patch can increase I/O
> performance a lot with VIRTIO_RING_F_EVENT_IDX enabled:
> 	- without the patch: 14K IOPS
> 	- with the patch: 34K IOPS
> 
> fio script:
> 	[global]
> 	direct=1
> 	bsrange=4k-4k
> 	timeout=10
> 	numjobs=4
> 	ioengine=libaio
> 	iodepth=64
> 
> 	filename=/dev/vdc
> 	group_reporting=1
> 
> 	[f1]
> 	rw=randread
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/block/virtio_blk.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 9f340fa..a6f5424 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -162,6 +162,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>  	unsigned int num;
>  	const bool last = (req->cmd_flags & REQ_END) != 0;
>  	int err;
> +	bool notify = false;
>  
>  	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>  
> @@ -214,10 +215,12 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>  		return BLK_MQ_RQ_QUEUE_ERROR;
>  	}
>  
> -	if (last)
> -		virtqueue_kick(vblk->vq);
> -
> +	if (last && virtqueue_kick_prepare(vblk->vq))
> +		notify = true;
>  	spin_unlock_irqrestore(&vblk->vq_lock, flags);
> +
> +	if (notify)
> +		virtqueue_notify(vblk->vq);
>  	return BLK_MQ_RQ_QUEUE_OK;
>  }
>  
> -- 
> 1.7.9.5
