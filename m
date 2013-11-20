Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3KTCxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 21:53:13 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:24353 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987Ab3KTCxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 21:53:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQQAKUjjFJ5LGc//2dsb2JhbABZgwc4gnWnbQOPH4VJgRIXdIIlAQEEAScTHCMFCwgDFwEJJQ8FJQMTDhOHewUOwAEXFo9BB4QyA5gRkg6BaoFSKA
Date: Wed, 20 Nov 2013 13:53:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131120025301.GT11434@dastard>
References: <20131119213429.GQ11434@dastard>
 <528BDB97.8090608@kernel.dk>
 <528BE967.9070506@kernel.dk>
 <528BEB6F.8040704@kernel.dk>
 <20131119232308.GS11434@dastard>
 <20131119235937.GC4094@kernel.dk>
 <20131120000858.GD4094@kernel.dk>
 <20131120014425.GA15287@kernel.org>
 <20131120015426.GE4094@kernel.dk>
 <20131120020230.GF4094@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120020230.GF4094@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 07:02:30PM -0700, Jens Axboe wrote:
> On Tue, Nov 19 2013, Jens Axboe wrote:
> > > Looks like a race condition, below works for me, please try.
> > > 
> > > 
> > > Subject: virtio_blk: fix race condition
> > > 
> > > virtqueue_kick() isn't multi-thread safe.
> > > 
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > 
> > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > index 588479d..f353959 100644
> > > --- a/drivers/block/virtio_blk.c
> > > +++ b/drivers/block/virtio_blk.c
> > > @@ -204,10 +204,11 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> > >  		virtqueue_kick(vblk->vq);
> > >  		return BLK_MQ_RQ_QUEUE_BUSY;
> > >  	}
> > > -	spin_unlock_irqrestore(&vblk->vq_lock, flags);
> > >  
> > >  	if (last)
> > >  		virtqueue_kick(vblk->vq);
> > > +	spin_unlock_irqrestore(&vblk->vq_lock, flags);
> > > +
> > >  	return BLK_MQ_RQ_QUEUE_OK;
> > >  }
> > 
> > Just stumbled on that too. You need one more, btw, for the sg failure
> > case:
> > 
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 588479d58f52..6a680d4de7f1 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -199,15 +199,16 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> >  
> >  	spin_lock_irqsave(&vblk->vq_lock, flags);
> >  	if (__virtblk_add_req(vblk->vq, vbr, vbr->sg, num) < 0) {
> > +		virtqueue_kick(vblk->vq);
> >  		spin_unlock_irqrestore(&vblk->vq_lock, flags);
> >  		blk_mq_stop_hw_queue(hctx);
> > -		virtqueue_kick(vblk->vq);
> >  		return BLK_MQ_RQ_QUEUE_BUSY;
> >  	}
> > -	spin_unlock_irqrestore(&vblk->vq_lock, flags);
> >  
> >  	if (last)
> >  		virtqueue_kick(vblk->vq);
> > +
> > +	spin_unlock_irqrestore(&vblk->vq_lock, flags);
> >  	return BLK_MQ_RQ_QUEUE_OK;
> >  }
> 
> Tested successfully here too.

Ah, so it is exactly the problem I suggested it might be. ;)

> Dave, please give it a go, looks like this
> should fix it up for you. Committed here:
> 
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=f02b9ac35a47dff745c7637fbc095f01cc03646e

Testing it now. might take a little while to confirm given it had
taken a few iterations of xfstests before I tripped over it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
