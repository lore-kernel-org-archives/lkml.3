Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3IWIof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:44:35 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:64634 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3IWIod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:44:33 -0400
Date: Mon, 23 Sep 2013 11:42:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: fix handle_pending_slot_free() and
 zram_reset_device() race
Message-ID: <20130923084259.GA2277@swordfish.datadirectnet.com>
References: <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
 <20130910143416.GC2270@swordfish>
 <20130910145802.GD19256@mwanda>
 <20130910231250.GA2450@swordfish>
 <20130916000217.GA18616@bbox>
 <20130917172445.GA2289@swordfish>
 <20130923042456.GC23940@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923042456.GC23940@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/23/13 13:24), Minchan Kim wrote:
> > On (09/16/13 09:02), Minchan Kim wrote:
> > > Hello Sergey,
> > > 
> > > Sorry for really slow response. I was really busy by internal works
> > > and Thanks for pointing the BUG, Dan, Jerome and Sergey.
> > > I read your threads roughly so I may miss something. If so, sorry
> > > for that. Anyway I will put my opinion.
> > > 
> > > On Wed, Sep 11, 2013 at 02:12:50AM +0300, Sergey Senozhatsky wrote:
> > > > Dan Carpenter noted that handle_pending_slot_free() is racy with
> > > > zram_reset_device(). Take write init_lock in zram_slot_free(), thus
> > > 
> > > Right but "init_lock" is what I really want to remove.
> > > Yes. It's just read-side lock so most of time it doesn't hurt us but it
> > > makes code very complicated and deadlock prone so I'd like to replace
> > > it with RCU. Yeah, It's off topic but just let me put my opinion in
> > > future direction.
> > > 
> > > Abought the bug, how about moving flush_work below down_write(init_lock)?
> > > zram_make_request is already closed by init_lock and we have a rule about
> > > lock ordering as following so I don't see any problem.
> > > 
> > >   init_lock
> > >     zram->lock
> > > 
> > > > preventing any concurrent zram_slot_free(), zram_bvec_rw() or
> > > > zram_reset_device(). This also allows to safely check zram->init_done
> > > > in handle_pending_slot_free().
> > > > 
> > > > Initial intention was to minimze number of handle_pending_slot_free()
> > > > call from zram_bvec_rw(), which were slowing down READ requests due to
> > > > slot_free_lock spin lock. Jerome Marchand suggested to remove
> > > > handle_pending_slot_free() from zram_bvec_rw().
> > > > 
> > > > Link: https://lkml.org/lkml/2013/9/9/172
> > > > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > > > 
> > > > ---
> > > > 
> > > >  drivers/staging/zram/zram_drv.c | 13 +++++--------
> > > >  1 file changed, 5 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> > > > index 91d94b5..7a2d4de 100644
> > > > --- a/drivers/staging/zram/zram_drv.c
> > > > +++ b/drivers/staging/zram/zram_drv.c
> > > > @@ -521,7 +521,8 @@ static void handle_pending_slot_free(struct zram *zram)
> > > >  	while (zram->slot_free_rq) {
> > > >  		free_rq = zram->slot_free_rq;
> > > >  		zram->slot_free_rq = free_rq->next;
> > > > -		zram_free_page(zram, free_rq->index);
> > > > +		if (zram->init_done)
> > > > +			zram_free_page(zram, free_rq->index);
> > > >  		kfree(free_rq);
> > > >  	}
> > > >  	spin_unlock(&zram->slot_free_lock);
> > > > @@ -534,16 +535,13 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> > > >  
> > > >  	if (rw == READ) {
> > > >  		down_read(&zram->lock);
> > > > -		handle_pending_slot_free(zram);
> > > 
> > > Read side is okay but actually I have a nitpick.
> > > If someone poll a block in zram-swap device, he would see a block
> > > has zero value suddenly although there was no I/O.(I don't want to argue
> > > it's sane user or not, anyway) it never happens on real block device and
> > > it never happens on zram-block device. Only it can happen zram-swap device.
> > > And such behavior was there since we introduced swap_slot_free_notify.
> > > (off-topic: I'd like to remove it because it makes tight coupling between
> > > zram and swap and obviously, it was layering violation function)
> > > so now, I don't have strong objection. 
> > > 
> > > The idea is to remove swap_slot_free_notify is to use frontswap when
> > > user want to use zram as swap so zram can be notified when the block
> > > lose the owner but still we should solve the mutex problem in notify
> > > handler.
> > > 
> > > 
> > > >  		ret = zram_bvec_read(zram, bvec, index, offset, bio);
> > > >  		up_read(&zram->lock);
> > > >  	} else {
> > > >  		down_write(&zram->lock);
> > > > -		handle_pending_slot_free(zram);
> > > 
> > > Why did you remove this in write-side?
> > > We can't expect when the work will trigger. It means the work could remove
> > > valid block under the us.
> > > 
> > 
> > 
> > not sure I understand how.
> > zram_slot_free() takes down_write(&zram->init_lock) and zram_make_request() takes
> > down_read(&zram->init_lock), thus zram_slot_free() can not concurrently work with
> > any RW requests. RW requests are under read() lock and zram_slot_free() is under
> > write() lock.
> 
> Let's consider example.
> Swap subsystem asked to zram "A" block free from now by swap_slot_free_notify
> but zram had been pended it without real freeing.
> Swap reused "A" block for new data because "A" block was free but request pended
> for a long time just handled and zram blindly free new data on the "A" block. :(
> That's why we should handle pending free request right before zram-write.
> 
> Another try to optimize the lock overhead is to check the block is pending for free
> right before zram_free_page in write path. If so, we should remove pending reuqest
> from slot_free_rq list to prevent valid block later. But for that case, we need
> more complex data structure to find the block fast and many checking code right
> before zram_free_page so that it would make code rather complicated.
> 
> So, do you have any real workload for us to consider it's really troublesome?
> Otherwise, I'd like to keep the code simple.
> 
> > 
> > > >  		ret = zram_bvec_write(zram, bvec, index, offset);
> > > >  		up_write(&zram->lock);
> > > >  	}
> > > > -
> > > >  	return ret;
> > > >  }
> > > >  
> > > > @@ -750,12 +748,11 @@ error:
> > > >  
> > > >  static void zram_slot_free(struct work_struct *work)
> > > >  {
> > > > -	struct zram *zram;
> > > > +	struct zram *zram = container_of(work, struct zram, free_work);
> > > >  
> > > > -	zram = container_of(work, struct zram, free_work);
> > > > -	down_write(&zram->lock);
> > > > +	down_write(&zram->init_lock);
> > > 
> > > I don't like this.
> > > Primary problem is we should handle it as atomic so that we should use
> > > spinlock instead of mutex. Yeah, /me kicks his ass. From the beginning,
> > > I should solve this problem as that way.
> > > 
> > > The simple solution popped from my mind is that
> > > 
> > > 
> > > diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> > > index 91d94b5..b23bf0e 100644
> > > --- a/drivers/staging/zram/zram_drv.c
> > > +++ b/drivers/staging/zram/zram_drv.c
> > > @@ -534,11 +534,14 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> > >  
> > >  	if (rw == READ) {
> > >  		down_read(&zram->lock);
> > > -		handle_pending_slot_free(zram);
> > >  		ret = zram_bvec_read(zram, bvec, index, offset, bio);
> > >  		up_read(&zram->lock);
> > >  	} else {
> > >  		down_write(&zram->lock);
> > > +		/*
> > > +		 * We should free pending slot. Otherwise it would
> > > +		 * free valid blocks under the us.
> > > +		 */
> > >  		handle_pending_slot_free(zram);
> > >  		ret = zram_bvec_write(zram, bvec, index, offset);
> > >  		up_write(&zram->lock);
> > > @@ -552,7 +555,6 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
> > >  	size_t index;
> > >  	struct zram_meta *meta;
> > >  
> > > -	flush_work(&zram->free_work);
> > >  
> > >  	down_write(&zram->init_lock);
> > >  	if (!zram->init_done) {
> > > @@ -560,6 +562,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
> > >  		return;
> > >  	}
> > >  
> > > +	flush_work(&zram->free_work);
> > >  	meta = zram->meta;
> > >  	zram->init_done = 0;
> > 
> > this one looks ok to me.
> 
> If you don't mind, I'd like to go with this.
> Thanks.

sure, no objections.

	-ss

> 
> > 
> > 	-ss
> > 
> > >  But more ideal way I am thinking now is 
> > > 
> > > 1) replace init_lock with RCU lock
> > > 2) introduce new meta atmoic lock instead of zram->mutex, which is very coarse-grained.
> > > 3) use atmoic lock in notify handler.
> > > 
> > > -- 
> > > Kind regards,
> > > Minchan Kim
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Kind regards,
> Minchan Kim
> 
