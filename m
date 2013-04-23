Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3DWOtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:49:12 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:42871 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3DWOtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:49:11 -0400
MIME-Version: 1.0
In-Reply-To: <1366724561.1930.3.camel@dabdike>
References: <1366722406-2899-1-git-send-email-linkinjeon@gmail.com>
	<1366724561.1930.3.camel@dabdike>
Date: Tue, 23 Apr 2013 18:49:10 +0400
Message-ID: <CAMo8BfJLB7DJVwWaxf7T3XWrs3igzEc=73EpeB1waeh0Ha5vdQ@mail.gmail.com>
Subject: Re: [PATCH] block: fix max discard sectors limit
From: Max Filippov <jcmvbkbc@gmail.com>
To: James Bottomley <jbottomley@parallels.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>, Shaohua Li <shli@kernel.org>,
        Kent Overstreet <koverstreet@google.com>, Tejun Heo <tj@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 5:42 PM, James Bottomley
<jbottomley@parallels.com> wrote:
> On Tue, 2013-04-23 at 22:06 +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> Hey, it's very impolite to send a patch I just gave you as a suggestion
> to fix the issue under your own authorship.
>
> What we need to know is has this been tested ... there's no tested-by
> tags (and there also should really be a reported by).

I can confirm that this patch also fixes the original issue.
Tested-by: Max Filippov <jcmvbkbc@gmail.com>

>> linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
>> commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9
>> (block: add plug for blkdev_issue_discard )
>>
>> For example,
>> 1) DISCARD rq-1 with size size 4GB
>> 2) DISCARD rq-2 with size size 1GB
>>
>> If these 2 discard requests get merged, final request size will be 5GB.
>>
>> In this case, request's __data_len field may overflow as it can store
>> max 4GB(unsigned int).
>>
>> This issue was observed while doing mkfs.f2fs on 5GB SD card:
>> https://lkml.org/lkml/2013/4/1/292
>>
>> Info: sector size = 512
>> Info: total sectors = 11370496 (in 512bytes)
>> Info: zone aligned segment0 blkaddr: 512
>> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
>>
>> mkfs process gets stuck in D state and I see the following in the dmesg:
>>
>> [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
>> [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
>> [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len
>> 1526726656
>> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
>> [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
>> [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
>> [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len
>> 1526726656
>>
>> This patch fixes this issue.
>>
>> Reported-by: Max Filippov <jcmvbkbc@gmail.com>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
>> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>> Cc: Shaohua Li <shli@kernel.org>
>> Cc: Kent Overstreet <koverstreet@google.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  include/linux/blkdev.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 07aa5f6..ff636bd 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -844,7 +844,7 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
>>                                                    unsigned int cmd_flags)
>>  {
>>       if (unlikely(cmd_flags & REQ_DISCARD))
>> -             return q->limits.max_discard_sectors;
>> +             return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
>>
>>       if (unlikely(cmd_flags & REQ_WRITE_SAME))
>>               return q->limits.max_write_same_sectors;

-- 
Thanks.
-- Max
