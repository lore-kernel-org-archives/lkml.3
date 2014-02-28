Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaB1PUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:20:51 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:44563 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaB1PUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:20:50 -0500
MIME-Version: 1.0
In-Reply-To: <530DF4EB.90605@redhat.com>
References: <1393392195-20743-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20140226131625.GA2217@swordfish.minsk.epam.com>
	<530DEFA7.5060103@redhat.com>
	<20140226135741.GB2217@swordfish.minsk.epam.com>
	<530DF4EB.90605@redhat.com>
Date: Sat, 1 Mar 2014 00:20:48 +0900
Message-ID: <CAAmzW4M=6Y3F4V4GVZ=mM3npPg=Uy5r1R3rYrPFdXQSUx6s3HQ@mail.gmail.com>
Subject: Re: [PATCH v2] zram: support REQ_DISCARD
From: Joonsoo Kim <js1304@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-26 23:06 GMT+09:00 Jerome Marchand <jmarchan@redhat.com>:
> On 02/26/2014 02:57 PM, Sergey Senozhatsky wrote:
>> On (02/26/14 14:44), Jerome Marchand wrote:
>>> On 02/26/2014 02:16 PM, Sergey Senozhatsky wrote:
>>>> Hello,
>>>>
>>>> On (02/26/14 14:23), Joonsoo Kim wrote:
>>>>> zram is ram based block device and can be used by backend of filesystem.
>>>>> When filesystem deletes a file, it normally doesn't do anything on data
>>>>> block of that file. It just marks on metadata of that file. This behavior
>>>>> has no problem on disk based block device, but has problems on ram based
>>>>> block device, since we can't free memory used for data block. To overcome
>>>>> this disadvantage, there is REQ_DISCARD functionality. If block device
>>>>> support REQ_DISCARD and filesystem is mounted with discard option,
>>>>> filesystem sends REQ_DISCARD to block device whenever some data blocks are
>>>>> discarded. All we have to do is to handle this request.
>>>>>
>>>>> This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
>>>>> REQ_DISCARD request. With it, we can free memory used by zram if it isn't
>>>>> used.
>>>>>
>>>>> v2: handle unaligned case commented by Jerome
>>>>>
>>>>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>>>>
>>>>> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
>>>>> index 5ec61be..5364c1e 100644
>>>>> --- a/drivers/block/zram/zram_drv.c
>>>>> +++ b/drivers/block/zram/zram_drv.c
>>>>> @@ -501,6 +501,36 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>>>>>    return ret;
>>>>>  }
>>>>>
>>>>> +static void zram_bio_discard(struct zram *zram, struct bio *bio)
>>>>> +{
>>>>> +  u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>>>>> +  size_t n = bio->bi_iter.bi_size;
>>>>> +  size_t misalign;
>>>>> +
>>>>> +  /*
>>>>> +   * On some arch, logical block (4096) aligned request couldn't be
>>>>> +   * aligned to PAGE_SIZE, since their PAGE_SIZE aren't 4096.
>>>>> +   * Therefore we should handle this misaligned case here.
>>>>> +   */
>>>>> +  misalign = (bio->bi_iter.bi_sector &
>>>>> +                  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
>>>>> +  if (misalign) {
>>>>> +          if (n < misalign)
>>>>> +                  return;
>>>>> +
>>>>> +          n -= misalign;
>>>>> +          index++;
>>>>> +  }
>>>>> +
>>>>> +  while (n >= PAGE_SIZE) {
>>>>> +          write_lock(&zram->meta->tb_lock);
>>>>> +          zram_free_page(zram, index);
>>>>> +          write_unlock(&zram->meta->tb_lock);
>>>>> +          index++;
>>>>> +          n -= PAGE_SIZE;
>>>>> +  }
>>>>> +}
>>>>> +
>>>>
>>>> a side note, do we need zram_bio_discard() function? I mean, can we handle
>>>> discard request in zram_bvec_rw(), where we already know index, etc. (passed
>>>> from __zram_make_request())?
>>>>

Hello, Sergey.
Sorry for late response.

I think that introducing new function is better idea, since
discard_request is significantly
different with rw request. First of all, it doesn't use bvec. So splitting code
in __zram_make_request() would not work properly for it. And
zram_bvec_rw() is bvec handler
and deals with PAGE_SIZE unit request which is not appropriate for
discard request.

But, it is good to use common index, offset, so I will move down position of
zram_bio_discard().

Thanks for comment!
