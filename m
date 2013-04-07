Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309Ab3DGCV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 22:21:29 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:58075 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185Ab3DGCV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 22:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130407015846.GA2232@kernel.org>
References: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
	<254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
	<5159EC3D.2020501@gmail.com>
	<1364884045.3301.18.camel@slavad-ubuntu>
	<CAMo8Bf+83t3ML_Ctr4V-pVL7Meei=pdOeC5cgtrPJB12tOcGtA@mail.gmail.com>
	<CAMo8BfKgTPO6AJng6zo1my4K_PivC1gJFQmcvy8q=iDYWSO2Pw@mail.gmail.com>
	<20130405015327.GA319@kernel.org>
	<CAMo8Bf+ccoU7jccOsxoyPqo2o8HaHhnuiocoNj1j67+S07aq_g@mail.gmail.com>
	<20130407015846.GA2232@kernel.org>
Date: Sun, 7 Apr 2013 06:21:27 +0400
Message-ID: <CAMo8BfKK+YYVKccGyymA40xJ8G=BVrJQS7Gz6RM1hnmef=YuBA@mail.gmail.com>
Subject: Re: mkfs.f2fs gets stuck with "blk_update_request: bio idx 0 >= vcnt
 0" on 3.8
From: Max Filippov <jcmvbkbc@gmail.com>
To: Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, slava@dubeyko.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 5:58 AM, Shaohua Li <shli@kernel.org> wrote:
> On Fri, Apr 05, 2013 at 06:18:10AM +0400, Max Filippov wrote:
>> On Fri, Apr 5, 2013 at 5:53 AM, Shaohua Li <shli@kernel.org> wrote:
>> > On Thu, Apr 04, 2013 at 06:00:18AM +0400, Max Filippov wrote:
>>
>> [...]
>>
>> >> the commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 'block: add plug
>> >> for blkdev_issue_discard'
>> >> have added merge opportunity for DISCARD requests. When I do
>> >> mkfs.f2fs on a 5G partition (0xad8000 sectors) it submits two bios,
>> >> one for 0x7fe000 sectors (0xffc00000 bytes) and another for
>> >> 0x2da000 sectors (0x5b400000 bytes). Prior to that commit these
>> >> bios weren't merged into one request. Now the second bio gets
>> >> merged with the first, but the request's __data_len field is unsigned int
>> >> and it gets wrapped to 0x5b000000 bytes instead of 0x15b000000
>> >> in the bio_attempt_back_merge. Later this reduced size is passed to
>> >> the blk_update_request causing KERN_ERR and not completed
>> >> request. Reverting this commit fixes mkfs.f2fs for me.
>> >
>> > A workaround is setting limits.max_discard_sectors to a smaller value.
>>
>> I'm not sure:
>> 1) in my case max_discard_sectors is 0x7fe000 (0xffc00000 bytes,
>>     which still fits into 32 bits) and
>> 2) this parameter will only change size of individual discard requests for
>>     the discarded range, but as long as these requests are done inside
>>     the plug they will be merged anyway with an overflow if we try
>>     to discard more than 4G at once.
>
> No, merge in plug list checks max_discard_sectors. Please see
> ll_back_merge_fn() in bio_attempt_back_merge(). Merge in unplug checks
> max_discard_sectors too. I didn't see any chance a merge doesn't check
> max_discard_sectors. Can you post a blktrace when the discard ioctl runs and
> double check if max_discard_sectors is really 0x7fe000?

Ok, max_discard_sectors is a bit ambiguous here.
There's a variable inside blkdev_issue_discard called max_discard_sectors,
I looked at it and it was 0x7fe000. But the q->limits.max_discard_sectors
is initialized to 0xffffffff in the mmc_queue_setup_discard. The following
change fixes the original issue too:

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index aaed768..0753986 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1920,7 +1920,7 @@ unsigned int mmc_calc_max_discard(struct mmc_card *card)
        unsigned int max_discard, max_trim;

        if (!host->max_discard_to)
-               return UINT_MAX;
+               return UINT_MAX >> 9;

        /*
         * Without erase_group_def set, MMC erase timeout depends on clock


-- 
Thanks.
-- Max
