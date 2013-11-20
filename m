Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3KTIHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:07:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3KTIHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:07:05 -0500
Date: Wed, 20 Nov 2013 00:07:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131120080702.GB13147@infradead.org>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Note that virtqueue_kick can be split into a virtqueue_prepare_split
that needs the lock, and a virtqueue_notify that doesn't, but it might
not be nessecary to do that optimization right now.

Btw, how much do I need to bribe you to send mails where I don't have 
step over 500 lines of dead quotes to find the actual patch?

