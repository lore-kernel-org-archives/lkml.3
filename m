Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaCFIYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:24:10 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:32826 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCFIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:24:08 -0500
X-Original-SENDERIP: 10.177.222.157
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 6 Mar 2014 17:24:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v2] zram: support REQ_DISCARD
Message-ID: <20140306082410.GB14287@bbox>
References: <1393392195-20743-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140226080732.GF4606@bbox>
 <CAAmzW4M4Oc_WBggASuTq1ijsPyh1q+vtVL9+dpcgNOzwSnkHiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4M4Oc_WBggASuTq1ijsPyh1q+vtVL9+dpcgNOzwSnkHiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 12:24:37AM +0900, Joonsoo Kim wrote:
> 2014-02-26 17:07 GMT+09:00 Minchan Kim <minchan@kernel.org>:
> > Hi Joonsoo,
> >
> > On Wed, Feb 26, 2014 at 02:23:15PM +0900, Joonsoo Kim wrote:
> >> zram is ram based block device and can be used by backend of filesystem.
> >> When filesystem deletes a file, it normally doesn't do anything on data
> >> block of that file. It just marks on metadata of that file. This behavior
> >> has no problem on disk based block device, but has problems on ram based
> >> block device, since we can't free memory used for data block. To overcome
> >> this disadvantage, there is REQ_DISCARD functionality. If block device
> >> support REQ_DISCARD and filesystem is mounted with discard option,
> >> filesystem sends REQ_DISCARD to block device whenever some data blocks are
> >> discarded. All we have to do is to handle this request.
> >>
> >> This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
> >> REQ_DISCARD request. With it, we can free memory used by zram if it isn't
> >> used.
> >>
> >> v2: handle unaligned case commented by Jerome
> >>
> >> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >>
> >> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> >> index 5ec61be..5364c1e 100644
> >> --- a/drivers/block/zram/zram_drv.c
> >> +++ b/drivers/block/zram/zram_drv.c
> >> @@ -501,6 +501,36 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> >>       return ret;
> >>  }
> >>
> >> +static void zram_bio_discard(struct zram *zram, struct bio *bio)
> >> +{
> >> +     u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
> >> +     size_t n = bio->bi_iter.bi_size;
> >
> > Nitpick:
> > Please use more meaningful name(ex, len) rather than 'n'.
> >
> 
> Hello, Minchan.
> 
> Will do.
> 
> >> +     size_t misalign;
> >> +
> >> +      * On some arch, logical block (4096) aligned request couldn't be
> >> +      * aligned to PAGE_SIZE, since their PAGE_SIZE aren't 4096.
> >> +      * Therefore we should handle this misaligned case here.
> >> +      */
> >> +     misalign = (bio->bi_iter.bi_sector &
> >> +                     (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
> >> +     if (misalign) {
> >> +             if (n < misalign)
> >> +                     return;
> >> +
> >> +             n -= misalign;
> >> +             index++;
> >> +     }
> >> +
> >> +     while (n >= PAGE_SIZE) {
> >> +             write_lock(&zram->meta->tb_lock);
> >> +             zram_free_page(zram, index);
> >> +             write_unlock(&zram->meta->tb_lock);
> >> +             index++;
> >> +             n -= PAGE_SIZE;
> >> +     }
> >> +}
> >> +
> >>  static void zram_reset_device(struct zram *zram, bool reset_capacity)
> >>  {
> >>       size_t index;
> >> @@ -618,6 +648,12 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
> >>       struct bio_vec bvec;
> >>       struct bvec_iter iter;
> >>
> >> +     if (unlikely(bio->bi_rw & REQ_DISCARD)) {
> >> +             zram_bio_discard(zram, bio);
> >> +             bio_endio(bio, 0);
> >> +             return;
> >> +     }
> >> +
> >>       index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
> >>       offset = (bio->bi_iter.bi_sector &
> >>                 (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
> >> @@ -784,6 +820,10 @@ static int create_device(struct zram *zram, int device_id)
> >>                                       ZRAM_LOGICAL_BLOCK_SIZE);
> >>       blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
> >>       blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
> >> +     zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
> >> +     zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
> >> +     zram->disk->queue->limits.discard_zeroes_data = 1;
> >
> > I don't know what discard_zeroes_data does mean. It seems we should
> > make sure zram should return zero pages for discarded block on next
> > time but prolblem could happen if you bail out in discard logic
> > due to misalign but caller seem to know it was successful?
> >
> > What happens in this case?
> >
> 
> This will result in the problem what you think about.
> I will change it like as following.
> 
> if (PAGE_SIZE == ZRAM_LOGICAL_BLOCK_SIZE)
>   zram->disk->queue->limits.discard_zeroes_data = 1;
> else
>   zram->disk->queue->limits.discard_zeroes_data = 0;
> 
> Does It work for you?

Yeb, pz, resend.

> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
