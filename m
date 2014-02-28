Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaB1PYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:24:39 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:63823 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaB1PYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140226080732.GF4606@bbox>
References: <1393392195-20743-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20140226080732.GF4606@bbox>
Date: Sat, 1 Mar 2014 00:24:37 +0900
Message-ID: <CAAmzW4M4Oc_WBggASuTq1ijsPyh1q+vtVL9+dpcgNOzwSnkHiA@mail.gmail.com>
Subject: Re: [PATCH v2] zram: support REQ_DISCARD
From: Joonsoo Kim <js1304@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-26 17:07 GMT+09:00 Minchan Kim <minchan@kernel.org>:
> Hi Joonsoo,
>
> On Wed, Feb 26, 2014 at 02:23:15PM +0900, Joonsoo Kim wrote:
>> zram is ram based block device and can be used by backend of filesystem.
>> When filesystem deletes a file, it normally doesn't do anything on data
>> block of that file. It just marks on metadata of that file. This behavior
>> has no problem on disk based block device, but has problems on ram based
>> block device, since we can't free memory used for data block. To overcome
>> this disadvantage, there is REQ_DISCARD functionality. If block device
>> support REQ_DISCARD and filesystem is mounted with discard option,
>> filesystem sends REQ_DISCARD to block device whenever some data blocks are
>> discarded. All we have to do is to handle this request.
>>
>> This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
>> REQ_DISCARD request. With it, we can free memory used by zram if it isn't
>> used.
>>
>> v2: handle unaligned case commented by Jerome
>>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>
>> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
>> index 5ec61be..5364c1e 100644
>> --- a/drivers/block/zram/zram_drv.c
>> +++ b/drivers/block/zram/zram_drv.c
>> @@ -501,6 +501,36 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>>       return ret;
>>  }
>>
>> +static void zram_bio_discard(struct zram *zram, struct bio *bio)
>> +{
>> +     u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>> +     size_t n = bio->bi_iter.bi_size;
>
> Nitpick:
> Please use more meaningful name(ex, len) rather than 'n'.
>

Hello, Minchan.

Will do.

>> +     size_t misalign;
>> +
>> +      * On some arch, logical block (4096) aligned request couldn't be
>> +      * aligned to PAGE_SIZE, since their PAGE_SIZE aren't 4096.
>> +      * Therefore we should handle this misaligned case here.
>> +      */
>> +     misalign = (bio->bi_iter.bi_sector &
>> +                     (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
>> +     if (misalign) {
>> +             if (n < misalign)
>> +                     return;
>> +
>> +             n -= misalign;
>> +             index++;
>> +     }
>> +
>> +     while (n >= PAGE_SIZE) {
>> +             write_lock(&zram->meta->tb_lock);
>> +             zram_free_page(zram, index);
>> +             write_unlock(&zram->meta->tb_lock);
>> +             index++;
>> +             n -= PAGE_SIZE;
>> +     }
>> +}
>> +
>>  static void zram_reset_device(struct zram *zram, bool reset_capacity)
>>  {
>>       size_t index;
>> @@ -618,6 +648,12 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
>>       struct bio_vec bvec;
>>       struct bvec_iter iter;
>>
>> +     if (unlikely(bio->bi_rw & REQ_DISCARD)) {
>> +             zram_bio_discard(zram, bio);
>> +             bio_endio(bio, 0);
>> +             return;
>> +     }
>> +
>>       index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>>       offset = (bio->bi_iter.bi_sector &
>>                 (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
>> @@ -784,6 +820,10 @@ static int create_device(struct zram *zram, int device_id)
>>                                       ZRAM_LOGICAL_BLOCK_SIZE);
>>       blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
>>       blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
>> +     zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
>> +     zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
>> +     zram->disk->queue->limits.discard_zeroes_data = 1;
>
> I don't know what discard_zeroes_data does mean. It seems we should
> make sure zram should return zero pages for discarded block on next
> time but prolblem could happen if you bail out in discard logic
> due to misalign but caller seem to know it was successful?
>
> What happens in this case?
>

This will result in the problem what you think about.
I will change it like as following.

if (PAGE_SIZE == ZRAM_LOGICAL_BLOCK_SIZE)
  zram->disk->queue->limits.discard_zeroes_data = 1;
else
  zram->disk->queue->limits.discard_zeroes_data = 0;

Does It work for you?

Thanks.
