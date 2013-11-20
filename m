Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab3KTCCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 21:02:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55105 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3KTCCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 21:02:32 -0500
Date: Tue, 19 Nov 2013 19:02:30 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Shaohua Li <shli@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131120020230.GF4094@kernel.dk>
References: <20131119212042.GB4094@kernel.dk>
 <20131119213429.GQ11434@dastard>
 <528BDB97.8090608@kernel.dk>
 <528BE967.9070506@kernel.dk>
 <528BEB6F.8040704@kernel.dk>
 <20131119232308.GS11434@dastard>
 <20131119235937.GC4094@kernel.dk>
 <20131120000858.GD4094@kernel.dk>
 <20131120014425.GA15287@kernel.org>
 <20131120015426.GE4094@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120015426.GE4094@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19 2013, Jens Axboe wrote:
> > Looks like a race condition, below works for me, please try.
> > 
> > 
> > Subject: virtio_blk: fix race condition
> > 
> > virtqueue_kick() isn't multi-thread safe.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 588479d..f353959 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -204,10 +204,11 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> >  		virtqueue_kick(vblk->vq);
> >  		return BLK_MQ_RQ_QUEUE_BUSY;
> >  	}
> > -	spin_unlock_irqrestore(&vblk->vq_lock, flags);
> >  
> >  	if (last)
> >  		virtqueue_kick(vblk->vq);
> > +	spin_unlock_irqrestore(&vblk->vq_lock, flags);
> > +
> >  	return BLK_MQ_RQ_QUEUE_OK;
> >  }
> 
> Just stumbled on that too. You need one more, btw, for the sg failure
> case:
> 
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 588479d58f52..6a680d4de7f1 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -199,15 +199,16 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>  
>  	spin_lock_irqsave(&vblk->vq_lock, flags);
>  	if (__virtblk_add_req(vblk->vq, vbr, vbr->sg, num) < 0) {
> +		virtqueue_kick(vblk->vq);
>  		spin_unlock_irqrestore(&vblk->vq_lock, flags);
>  		blk_mq_stop_hw_queue(hctx);
> -		virtqueue_kick(vblk->vq);
>  		return BLK_MQ_RQ_QUEUE_BUSY;
>  	}
> -	spin_unlock_irqrestore(&vblk->vq_lock, flags);
>  
>  	if (last)
>  		virtqueue_kick(vblk->vq);
> +
> +	spin_unlock_irqrestore(&vblk->vq_lock, flags);
>  	return BLK_MQ_RQ_QUEUE_OK;
>  }

Tested successfully here too. Dave, please give it a go, looks like this
should fix it up for you. Committed here:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=f02b9ac35a47dff745c7637fbc095f01cc03646e

and will send it upstream today, so we can avoid having an -rc1 with a
broken virtio-blk.

-- 
Jens Axboe

