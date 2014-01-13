Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaAMXiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:38:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64923 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaAMXiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:38:07 -0500
X-AuditID: 9c93016f-b7c41ae000003ec1-c2-52d478dd9c21
Date: Tue, 14 Jan 2014 08:38:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH 6/7] zram: remove workqueue for freeing removed pending
 slot
Message-ID: <20140113233848.GT1992@bbox>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
 <1389611942-15544-7-git-send-email-minchan@kernel.org>
 <20140113194111.GA2322@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113194111.GA2322@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

On Mon, Jan 13, 2014 at 10:42:56PM +0300, Sergey Senozhatsky wrote:
> On (01/13/14 20:19), Minchan Kim wrote:
> > [1] introduced free request pending code to avoid scheduling
> > by mutex under spinlock and it was a mess which made code
> > lenghty and increased overhead.
> > 
> > Now, we don't need zram->lock any more to free slot so
> > this patch reverts it and then, tb_lock should protect it.
> > 
> > [1] a0c516c, zram: don't grab mutex in zram_slot_free_noity
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  drivers/block/zram/zram_drv.c | 54 +++++--------------------------------------
> >  drivers/block/zram/zram_drv.h | 10 --------
> >  2 files changed, 6 insertions(+), 58 deletions(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index 24e6426..f1a3c95 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -522,20 +522,6 @@ out:
> >  	return ret;
> >  }
> >  
> > -static void handle_pending_slot_free(struct zram *zram)
> > -{
> > -	struct zram_slot_free *free_rq;
> > -
> > -	spin_lock(&zram->slot_free_lock);
> > -	while (zram->slot_free_rq) {
> > -		free_rq = zram->slot_free_rq;
> > -		zram->slot_free_rq = free_rq->next;
> > -		zram_free_page(zram, free_rq->index);
> > -		kfree(free_rq);
> > -	}
> > -	spin_unlock(&zram->slot_free_lock);
> > -}
> > -
> >  static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  			int offset, struct bio *bio, int rw)
> >  {
> > @@ -547,7 +533,6 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  		up_read(&zram->lock);
> >  	} else {
> >  		down_write(&zram->lock);
> > -		handle_pending_slot_free(zram);
> >  		ret = zram_bvec_write(zram, bvec, index, offset);
> >  		up_write(&zram->lock);
> >  	}
> > @@ -566,8 +551,6 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
> >  		return;
> >  	}
> >  
> > -	flush_work(&zram->free_work);
> > -
> >  	meta = zram->meta;
> >  	zram->init_done = 0;
> >  
> > @@ -769,40 +752,19 @@ error:
> >  	bio_io_error(bio);
> >  }
> >  
> > -static void zram_slot_free(struct work_struct *work)
> > -{
> > -	struct zram *zram;
> > -
> > -	zram = container_of(work, struct zram, free_work);
> > -	down_write(&zram->lock);
> > -	handle_pending_slot_free(zram);
> > -	up_write(&zram->lock);
> > -}
> > -
> > -static void add_slot_free(struct zram *zram, struct zram_slot_free *free_rq)
> > -{
> > -	spin_lock(&zram->slot_free_lock);
> > -	free_rq->next = zram->slot_free_rq;
> > -	zram->slot_free_rq = free_rq;
> > -	spin_unlock(&zram->slot_free_lock);
> > -}
> > -
> >  static void zram_slot_free_notify(struct block_device *bdev,
> >  				unsigned long index)
> >  {
> >  	struct zram *zram;
> > -	struct zram_slot_free *free_rq;
> > +	struct zram_meta *meta;
> >  
> >  	zram = bdev->bd_disk->private_data;
> > -	atomic64_inc(&zram->stats.notify_free);
> > -
> > -	free_rq = kmalloc(sizeof(struct zram_slot_free), GFP_ATOMIC);
> > -	if (!free_rq)
> > -		return;
> > +	meta = zram->meta;
> >  
> > -	free_rq->index = index;
> > -	add_slot_free(zram, free_rq);
> > -	schedule_work(&zram->free_work);
> > +	write_lock(&meta->tb_lock);
> > +	zram_free_page(zram, index);
> > +	write_unlock(&meta->tb_lock);
> > +	atomic64_inc(&zram->stats.notify_free);
> >  }
> >  
> 
> Hello Minchan,
> I think we need to down_write init_lock in zram_slot_free_notify(),
> and thus can avoid locking meta->tb_lock. otherwise, I think,

zram_slot_free_notify is atomic path so we couldn't hold mutex.

> there is a chance that zram_slot_free_notify() can race with
> device reset, e.g.
> 	
> 	zram_slot_free_notify()			zram_reset_device()
> 						down_write(&zram->init_lock);
> 	meta = zram->meta
> 						zram_meta_free(zram->meta);
> 						zram->meta = NULL;
> 	write_lock(&meta->tb_lock);
> 	[...]
> 	write_unlock(&meta->tb_lock);
> 						[..]
> 						up_write(&zram->init_lock);
> 

Nope. We couldn't reset active device by bdev->bd_holders check
logic in reset_store.


> 	-ss
-- 
Kind regards,
Minchan Kim
