Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3HLDxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 23:53:46 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50667 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab3HLDxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 23:53:44 -0400
X-AuditID: 9c93017e-b7c76ae000003897-09-52085c4643b4
Date: Mon, 12 Aug 2013 12:53:42 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>, stable@vger.kernel.org
Subject: Re: [PATCH] zram: bug fix: delay lock holding in zram_slot_free_noity
Message-ID: <20130812035342.GC18832@bbox>
References: <1375687114-4001-1-git-send-email-minchan@kernel.org>
 <20130805162634.GA25045@gmail.com>
 <20130809233908.GA30317@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809233908.GA30317@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Fri, Aug 09, 2013 at 04:39:08PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Aug 06, 2013 at 01:26:34AM +0900, Minchan Kim wrote:
> > On Mon, Aug 05, 2013 at 04:18:34PM +0900, Minchan Kim wrote:
> > > I was preparing to promote zram and it was almost done.
> > > Before sending patch, I tried to test and eyebrows went up.
> > > 
> > > [1] introduced down_write in zram_slot_free_notify to prevent race
> > > between zram_slot_free_notify and zram_bvec_[read|write]. The race
> > > could happen if somebody who has right permission to open swap device
> > > is reading swap device while it is used by swap in parallel.
> > > 
> > > However, zram_slot_free_notify is called with holding spin_lock of
> > > swap layer so we shouldn't avoid holing mutex. Otherwise, lockdep
> > > warns it.
> > > 
> > > I guess, best solution is to redesign zram lock scheme totally but
> > > we are on the verge of promoting so it's not desirable to change a lot
> > > critical code and such big change isn't good shape for backporting to
> > > stable trees so I think the simple patch is best at the moment.
> > > 
> > > [1] [57ab0485, zram: use zram->lock to protect zram_free_page()
> > >     in swap free notify path]
> > > 
> > > Cc: Jiang Liu <jiang.liu@huawei.com>
> > > Cc: Nitin Gupta <ngupta@vflare.org>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > ---
> > >  drivers/staging/zram/zram_drv.c |   15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> > > index 7ebf91d..7b574c4 100644
> > > --- a/drivers/staging/zram/zram_drv.c
> > > +++ b/drivers/staging/zram/zram_drv.c
> > > @@ -440,6 +440,13 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> > >  		goto out;
> > >  	}
> > >  
> > > +	/*
> > > +	 * zram_slot_free_notify could miss free so that let's
> > > +	 * double check.
> > > +	 */
> > > +	if (unlikely(meta->table[index].handle))
> > > +		zram_free_page(zram, index);
> > > +
> > >  	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
> > >  			       meta->compress_workmem);
> > >  
> > > @@ -727,7 +734,13 @@ static void zram_slot_free_notify(struct block_device *bdev,
> > >  	struct zram *zram;
> > >  
> > >  	zram = bdev->bd_disk->private_data;
> > > -	down_write(&zram->lock);
> > > +	/*
> > > +	 * The function is called in atomic context so down_write should
> > > +	 * be prohibited. If we couldn't hold a mutex, the free could be
> > > +	 * handled by zram_bvec_write later when same index is overwritten.
> > > +	 */
> > > +	if (!down_write_trylock(&zram->lock))
> > > +		return;
> > >  	zram_free_page(zram, index);
> > >  	up_write(&zram->lock);
> > >  	atomic64_inc(&zram->stats.notify_free);
> > > -- 
> > > 1.7.9.5
> > > 
> > 
> > How about this version?
> 
> I'm guessing you tested it out?  If so, please resend in a format that I
> can apply it in.

Sure, I will post soon.
Thanks!

-- 
Kind regards,
Minchan Kim
