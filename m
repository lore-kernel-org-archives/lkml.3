Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151Ab3DECSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 22:18:14 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54851 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab3DECSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 22:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130405015327.GA319@kernel.org>
References: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
	<254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
	<5159EC3D.2020501@gmail.com>
	<1364884045.3301.18.camel@slavad-ubuntu>
	<CAMo8Bf+83t3ML_Ctr4V-pVL7Meei=pdOeC5cgtrPJB12tOcGtA@mail.gmail.com>
	<CAMo8BfKgTPO6AJng6zo1my4K_PivC1gJFQmcvy8q=iDYWSO2Pw@mail.gmail.com>
	<20130405015327.GA319@kernel.org>
Date: Fri, 5 Apr 2013 06:18:10 +0400
Message-ID: <CAMo8Bf+ccoU7jccOsxoyPqo2o8HaHhnuiocoNj1j67+S07aq_g@mail.gmail.com>
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

On Fri, Apr 5, 2013 at 5:53 AM, Shaohua Li <shli@kernel.org> wrote:
> On Thu, Apr 04, 2013 at 06:00:18AM +0400, Max Filippov wrote:

[...]

>> the commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 'block: add plug
>> for blkdev_issue_discard'
>> have added merge opportunity for DISCARD requests. When I do
>> mkfs.f2fs on a 5G partition (0xad8000 sectors) it submits two bios,
>> one for 0x7fe000 sectors (0xffc00000 bytes) and another for
>> 0x2da000 sectors (0x5b400000 bytes). Prior to that commit these
>> bios weren't merged into one request. Now the second bio gets
>> merged with the first, but the request's __data_len field is unsigned int
>> and it gets wrapped to 0x5b000000 bytes instead of 0x15b000000
>> in the bio_attempt_back_merge. Later this reduced size is passed to
>> the blk_update_request causing KERN_ERR and not completed
>> request. Reverting this commit fixes mkfs.f2fs for me.
>
> A workaround is setting limits.max_discard_sectors to a smaller value.

I'm not sure:
1) in my case max_discard_sectors is 0x7fe000 (0xffc00000 bytes,
    which still fits into 32 bits) and
2) this parameter will only change size of individual discard requests for
    the discarded range, but as long as these requests are done inside
    the plug they will be merged anyway with an overflow if we try
    to discard more than 4G at once.

> So the question is why __data_len isn't sector based? Since disk is sector
> based, is there any disk finishing IO in byte granularity? Maybe Jens can
> answer.

-- 
Thanks.
-- Max
