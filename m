Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaBXPQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:16:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbaBXPQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:16:26 -0500
Message-ID: <530B621E.9010309@redhat.com>
Date: Mon, 24 Feb 2014 16:15:42 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] zram: support REQ_DISCARD
References: <1393221070-21674-1-git-send-email-iamjoonsoo.kim@lge.com> <530B4AFB.5060006@redhat.com> <CAAmzW4OYqVtLOyvMpS7258OXyr07MHzBCTtyurwrZ+fbxNK=bw@mail.gmail.com>
In-Reply-To: <CAAmzW4OYqVtLOyvMpS7258OXyr07MHzBCTtyurwrZ+fbxNK=bw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 04:02 PM, Joonsoo Kim wrote:
> 2014-02-24 22:36 GMT+09:00 Jerome Marchand <jmarchan@redhat.com>:
>> On 02/24/2014 06:51 AM, Joonsoo Kim wrote:
>>> zram is ram based block device and can be used by backend of filesystem.
>>> When filesystem deletes a file, it normally doesn't do anything on data
>>> block of that file. It just marks on metadata of that file. This behavior
>>> has no problem on disk based block device, but has problems on ram based
>>> block device, since we can't free memory used for data block. To overcome
>>> this disadvantage, there is REQ_DISCARD functionality. If block device
>>> support REQ_DISCARD and filesystem is mounted with discard option,
>>> filesystem sends REQ_DISCARD to block device whenever some data blocks are
>>> discarded. All we have to do is to handle this request.
>>>
>>> This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
>>> REQ_DISCARD request. With it, we can free memory used by zram if it isn't
>>> used.
>>>
>>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>> ---
>>> This patch is based on master branch of linux-next tree.
>>>
>>> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
>>> index 5ec61be..cff2c0e 100644
>>> --- a/drivers/block/zram/zram_drv.c
>>> +++ b/drivers/block/zram/zram_drv.c
>>> @@ -501,6 +501,20 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>>>       return ret;
>>>  }
>>>
>>> +static void zram_bio_discard(struct zram *zram, struct bio *bio)
>>> +{
>>> +     u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>>
>> Hi Joonsoo,
>>
>> If bi_sector is not aligned on a page size, we might end up discarding
>> a page that still contain valid data.
>>
>>
> 
> Hello, Jerome.
> 
> Is it possible that request isn't aligned on a page size if
> logical/physical block size
> is PAGE_SIZE?

Yes, zram has an logical block size of 4k (ZRAM_LOGICAL_BLOCK_SIZE),
while its physical block size, which is a page size, can be bigger.

> When I tested it, I didn't find any invalid io.
> If we meet any misaligned request, it would be filtered by
> valid_io_request(). :)

zram accepts request aligned on logical blocks. So valid_io_request()
wouldn't filter misaligned requests out as long as they are aligned
on logical blocks.
If your system use 4k pages, your tests would never trigger the issue,
but on a system which uses 64k pages, it could.

Jerome

> 
> Thanks.
> 

