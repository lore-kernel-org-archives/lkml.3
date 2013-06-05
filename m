Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3FEQA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:00:29 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46637 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab3FEQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:00:27 -0400
Message-ID: <51AF6095.8050701@gmail.com>
Date: Thu, 06 Jun 2013 00:00:21 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] zram: use zram->lock to protect zram_free_page()
 in swap free notify path
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com> <1370361968-8764-3-git-send-email-jiang.liu@huawei.com> <20130605062935.GC8732@blaptop>
In-Reply-To: <20130605062935.GC8732@blaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05 Jun 2013 02:29:35 PM CST, Minchan Kim wrote:
> On Wed, Jun 05, 2013 at 12:06:01AM +0800, Jiang Liu wrote:
>> zram_free_page() is protected by down_write(&zram->lock) when called by
>> zram_bvec_write(), but there's no such protection when called by
>> zram_slot_free_notify(), which may cause wrong states to zram object.
>>
>> There are two possible consequences of this issue:
>> 1) It may cause invalid memory access if we read from a zram device used
>>    as swap device. (Not sure whether it's legal to make read/write
>>    requests to a zram device used as swap device.)
>
> I think it's possible if the permission is allowed so we should take care
> of that. But I'd like to clear your comment about "invalid memory access".
>
> As I read the code, one of the problem we can encounter by race between
> zram_bvec_read and zram_slot_free_notify is BUG_ON(!handle) on zs_map_object
> or pr_err("Decompression failed xxxx) on zram_decompress_page.
> Otherwise, it would be able to access different swap block with
> user request's one.
>
> Could you please expand your vague "invalid memory access"?
Hi Minchan,
     I have no enough time to read all zsmalloc code yet, but I'm 
thinking of this scenario:
a user does a "dd" from a zram device used as swap device.

A possible sequence may be:
Thread 1: zram_bvec_rw()->zram_bvec_read()->zram_decompress_page()

Just before zram_decompress_page() calls zs_map_object().
Thread 2: 
zram_slot_free_notify()->zram_free_page()->zs_free()->free_zspage()->reset_page()/free_page()

Then:
Thread 1: zs_map_object()
                              
->get_zspage_mapping(get_first_page(page), &class_idx, &fg)
                                            ->get_first_page()
                                                        ->return 
page->first_page  /* may be invalid address */

Actually I guess it may cause different invalid memory access, 
depending on the
executing order of thread 1 and thread 2.

Regards!
Gerry
>
>
>> 2) It may cause some fields (bad_compress, good_compress, pages_stored)
>>    in zram->stats wrong if the swap layer makes concurrently call to
>>    zram_slot_free_notify().
>>
>> So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
>> before calling zram_free_page().
>
> OK.
>
> And please add the comment struct zram->lock feild, too.
>
> Thanks.
>
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/staging/zram/zram_drv.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index 5a2f20b..847d207 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -582,7 +582,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
>>  	struct zram *zram;
>>
>>  	zram = bdev->bd_disk->private_data;
>> +	down_write(&zram->lock);
>>  	zram_free_page(zram, index);
>> +	up_write(&zram->lock);
>>  	zram_stat64_inc(zram, &zram->stats.notify_free);
>>  }
>>
>> --
>> 1.8.1.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>


