Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaBXPCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:02:20 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57370 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaBXPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:02:18 -0500
MIME-Version: 1.0
In-Reply-To: <530B4AFB.5060006@redhat.com>
References: <1393221070-21674-1-git-send-email-iamjoonsoo.kim@lge.com>
	<530B4AFB.5060006@redhat.com>
Date: Tue, 25 Feb 2014 00:02:15 +0900
Message-ID: <CAAmzW4OYqVtLOyvMpS7258OXyr07MHzBCTtyurwrZ+fbxNK=bw@mail.gmail.com>
Subject: Re: [PATCH] zram: support REQ_DISCARD
From: Joonsoo Kim <js1304@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-24 22:36 GMT+09:00 Jerome Marchand <jmarchan@redhat.com>:
> On 02/24/2014 06:51 AM, Joonsoo Kim wrote:
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
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> ---
>> This patch is based on master branch of linux-next tree.
>>
>> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
>> index 5ec61be..cff2c0e 100644
>> --- a/drivers/block/zram/zram_drv.c
>> +++ b/drivers/block/zram/zram_drv.c
>> @@ -501,6 +501,20 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>>       return ret;
>>  }
>>
>> +static void zram_bio_discard(struct zram *zram, struct bio *bio)
>> +{
>> +     u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>
> Hi Joonsoo,
>
> If bi_sector is not aligned on a page size, we might end up discarding
> a page that still contain valid data.
>
>

Hello, Jerome.

Is it possible that request isn't aligned on a page size if
logical/physical block size
is PAGE_SIZE? When I tested it, I didn't find any invalid io.
If we meet any misaligned request, it would be filtered by
valid_io_request(). :)

Thanks.
