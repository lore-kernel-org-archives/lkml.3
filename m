Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab3BFE7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:59:16 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:60785 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3BFE7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:59:13 -0500
MIME-Version: 1.0
In-Reply-To: <1360125680.26950.55.camel@kjgkr>
References: <1360074293-8252-1-git-send-email-linkinjeon@gmail.com>
	<1360125680.26950.55.camel@kjgkr>
Date: Wed, 6 Feb 2013 13:59:12 +0900
Message-ID: <CAKYAXd_45Y5H30wGVHZGNn8f=xNpiXBEq2UxfdRWznHrxw7drQ@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix to name f2fs GC task as per partition instead
 of per device
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/6, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
>
> How about this?
>
> 2013-02-05 (화), 23:24 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> After the commit 2184ad190a79ae2b40b5f5db1fbde5c22db6d310, it allowed
>> for naming GC threads based on the device.
>> i.e., if we have F2FS formatted partition in different devices - we will
>> have their GC thread names after the device. But, when we have a case
>> like
>> 2 or more partitions on the same device having F2FS filesystem.
>> In that case we are not able to differentiate between the GC threads.
>> So, to differentiate at all possible levels we can use the major/minor of
>> the device to have unique identification in the name.
>>
>> Before patch:
>> root  9726  0.0  0.0  0  0 ?  S  14:32   0:00 [f2fs_gc-8:48]
>> root  9736  0.0  0.0  0  0 ?  S  14:32   0:00 [f2fs_gc-8:16]
>> root  9892  0.0  0.0  0  0 ?  S  14:33   0:00 [f2fs_gc-8:32]
>> root  9907  0.0  0.0  0  0 ?  S  14:34   0:00 [f2fs_gc-8:32]
>>
>> After Patch:
>> root  16756  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-8:18]
>> root  16765  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-8:19]
>> root  16806  0.0  0.0  0  0 ?  S  14:58   0:00 [f2fs_gc-8:34]
>> root  16817  0.0  0.0  0  0 ?  S  14:58   0:00 [f2fs_gc-8:52]
>>
>
> root  16756  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-sdb1]
> root  16765  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-sdb2]
>
> IMO, it would be better to describe like this.
> We can simply use bdevname(bdev, name), so if no objection, I'll rebase
> this patch with this.
> Please, give me your opinion.
> Thanks,
Hi Jaegeuk.

Although it is good opinion to have user friendly names in the task
list, but we cannot have such names.

Because, even though bdevname() will provide the correct string. But
there is a limitation from the task struct command length.
The Task struct allows for the name to be maximum of ‘16’ characters in length.
char comm[TASK_COMM_LEN];

/* Task command name length */
#define TASK_COMM_LEN 16
So, the task name would be truncated to ‘16’ characters.

In case like for MMC partitions where partition name can be like:
mmcblk0p18, the name would become f2fs_gc-mmcblk0p18 -> this will be
truncate to “f2fs_gc-mmcblk0p”

Let me know your opinion.
Thanks.
>
>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/f2fs/gc.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
>> index 742135a..b0c1f8c 100644
>> --- a/fs/f2fs/gc.c
>> +++ b/fs/f2fs/gc.c
>> @@ -91,6 +91,7 @@ static int gc_thread_func(void *data)
>>  int start_gc_thread(struct f2fs_sb_info *sbi)
>>  {
>>  	struct f2fs_gc_kthread *gc_th;
>> +	dev_t dev = sbi->sb->s_bdev->bd_dev;
>>
>>  	if (!test_opt(sbi, BG_GC))
>>  		return 0;
>> @@ -101,7 +102,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
>>  	sbi->gc_thread = gc_th;
>>  	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
>>  	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
>> -				"f2fs_gc-%s", dev_name(sbi->sb->s_bdi->dev));
>> +				"f2fs_gc-%u:%u", MAJOR(dev), MINOR(dev));
>>  	if (IS_ERR(gc_th->f2fs_gc_task)) {
>>  		kfree(gc_th);
>>  		sbi->gc_thread = NULL;
>
> --
> Jaegeuk Kim
> Samsung
>
