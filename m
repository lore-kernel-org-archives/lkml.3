Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaBZOGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:06:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaBZOGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:06:46 -0500
Message-ID: <530DF4EB.90605@redhat.com>
Date: Wed, 26 Feb 2014 15:06:35 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2] zram: support REQ_DISCARD
References: <1393392195-20743-1-git-send-email-iamjoonsoo.kim@lge.com> <20140226131625.GA2217@swordfish.minsk.epam.com> <530DEFA7.5060103@redhat.com> <20140226135741.GB2217@swordfish.minsk.epam.com>
In-Reply-To: <20140226135741.GB2217@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 02:57 PM, Sergey Senozhatsky wrote:
> On (02/26/14 14:44), Jerome Marchand wrote:
>> On 02/26/2014 02:16 PM, Sergey Senozhatsky wrote:
>>> Hello,
>>>
>>> On (02/26/14 14:23), Joonsoo Kim wrote:
>>>> zram is ram based block device and can be used by backend of filesystem.
>>>> When filesystem deletes a file, it normally doesn't do anything on data
>>>> block of that file. It just marks on metadata of that file. This behavior
>>>> has no problem on disk based block device, but has problems on ram based
>>>> block device, since we can't free memory used for data block. To overcome
>>>> this disadvantage, there is REQ_DISCARD functionality. If block device
>>>> support REQ_DISCARD and filesystem is mounted with discard option,
>>>> filesystem sends REQ_DISCARD to block device whenever some data blocks are
>>>> discarded. All we have to do is to handle this request.
>>>>
>>>> This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
>>>> REQ_DISCARD request. With it, we can free memory used by zram if it isn't
>>>> used.
>>>>
>>>> v2: handle unaligned case commented by Jerome
>>>>
>>>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>>>
>>>> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
>>>> index 5ec61be..5364c1e 100644
>>>> --- a/drivers/block/zram/zram_drv.c
>>>> +++ b/drivers/block/zram/zram_drv.c
>>>> @@ -501,6 +501,36 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>>>>  	return ret;
>>>>  }
>>>>  
>>>> +static void zram_bio_discard(struct zram *zram, struct bio *bio)
>>>> +{
>>>> +	u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>>>> +	size_t n = bio->bi_iter.bi_size;
>>>> +	size_t misalign;
>>>> +
>>>> +	/*
>>>> +	 * On some arch, logical block (4096) aligned request couldn't be
>>>> +	 * aligned to PAGE_SIZE, since their PAGE_SIZE aren't 4096.
>>>> +	 * Therefore we should handle this misaligned case here.
>>>> +	 */
>>>> +	misalign = (bio->bi_iter.bi_sector &
>>>> +			(SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
>>>> +	if (misalign) {
>>>> +		if (n < misalign)
>>>> +			return;
>>>> +
>>>> +		n -= misalign;
>>>> +		index++;
>>>> +	}
>>>> +
>>>> +	while (n >= PAGE_SIZE) {
>>>> +		write_lock(&zram->meta->tb_lock);
>>>> +		zram_free_page(zram, index);
>>>> +		write_unlock(&zram->meta->tb_lock);
>>>> +		index++;
>>>> +		n -= PAGE_SIZE;
>>>> +	}
>>>> +}
>>>> +
>>>
>>> a side note, do we need zram_bio_discard() function? I mean, can we handle
>>> discard request in zram_bvec_rw(), where we already know index, etc. (passed
>>> from __zram_make_request())?
>>>
>>
>> We'd still have to make sure not to discard pages that are still partially
>> used, but it might simplify the code: __zram_make_request() already takes
>> care of splitting the request.
>>
>>> for example:
>>>
>>> @@ -510,6 +510,11 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>>>                 ret = zram_bvec_write(zram, bvec, index, offset);
>>>         }
>>>  
>>> +       if (unlikely(bio->bi_rw & REQ_DISCARD)) {
>>
>> +		if (!is_partial_io(bvec) {
>>
>>> +               write_lock(&zram->meta->tb_lock);
>>> +               zram_free_page(zram, index);
>>> +               write_unlock(&zram->meta->tb_lock);
>>
>> +		}
>>
>> Also this code might still call zram_bvec_read() and increase num_reads
>> for discard request: I guess bio_data_dir(bio) == READ == 0 in this case.
>>
>> Btw, why __zram_make_request() has an that rw argument? All the information
>> it needs is passed by the bio argument already. I kind of recollect to have
>> seen a cleanup patch that get rid of it or is it just my imagination?
>>
> 
> it doesn't. cleanup patch 'do not pass rw argument to __zram_make_request()'
> is in linux-next.
> 

You're right. I must be blind since there is an exemple of __zram_make_request()
without this argument just a few line below.

> 	-ss
> 
>> Jerome
>>
>>> +       }
>>>         return ret;
>>>  }
>>>
>>> 	-ss
>>>
>>>>  static void zram_reset_device(struct zram *zram, bool reset_capacity)
>>>>  {
>>>>  	size_t index;
>>>> @@ -618,6 +648,12 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)

I need to open my eyes.

Jerome

>>>>  	struct bio_vec bvec;
>>>>  	struct bvec_iter iter;
>>>>  
>>>> +	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
>>>> +		zram_bio_discard(zram, bio);
>>>> +		bio_endio(bio, 0);
>>>> +		return;
>>>> +	}
>>>> +
>>>>  	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>>>>  	offset = (bio->bi_iter.bi_sector &
>>>>  		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
>>>> @@ -784,6 +820,10 @@ static int create_device(struct zram *zram, int device_id)
>>>>  					ZRAM_LOGICAL_BLOCK_SIZE);
>>>>  	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
>>>>  	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
>>>> +	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
>>>> +	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
>>>> +	zram->disk->queue->limits.discard_zeroes_data = 1;
>>>> +	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
>>>>  
>>>>  	add_disk(zram->disk);
>>>>  
>>>> -- 
>>>> 1.7.9.5
>>>>
>>

