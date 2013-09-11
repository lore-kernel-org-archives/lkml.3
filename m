Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3IKNWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:22:12 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:38871 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3IKNWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <523001B6.3080506@cn.fujitsu.com>
References: <88.C4.11914.9D4A9225@epcpsbge6.samsung.com>
	<1378774324.2354.103.camel@kjgkr>
	<523001B6.3080506@cn.fujitsu.com>
Date: Wed, 11 Sep 2013 22:22:10 +0900
Message-ID: <CAOtxgycxzG6P1EHK0gvgu3csR0Qz0XC3ANThHdgw3JvchO4JyQ@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH] f2fs: optimize fs_lock for better performance
From: Kim Jaegeuk <jaegeuk.kim@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        =?UTF-8?B?6LCt5aed?= <shu.tan@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

2013/9/11 Gu Zheng <guz.fnst@cn.fujitsu.com>:
> Hi Jaegeuk, Chao,
>
> On 09/10/2013 08:52 AM, Jaegeuk Kim wrote:
>
>> Hi,
>>
>> At first, thank you for the report and please follow the email writing
>> rules. :)
>>
>> Anyway, I agree to the below issue.
>> One thing that I can think of is that we don't need to use the
>> spin_lock, since we don't care about the exact lock number, but just
>> need to get any not-collided number.
>
> IMHO, just moving sbi->next_lock_num++ before mutex_lock(&sbi->fs_lock[next_lock])
> can avoid unbalance issue mostly.
> IMO, the case two or more threads increase sbi->next_lock_num in the same time is
> really very very little. If you think it is not rigorous, change next_lock_num to
> atomic one can fix it.
> What's your opinion?

As your opinion, I think it is enough to replace it with simple
sbi->next_lock_num++.
Thanks,

>
> Regards,
> Gu
>
>>
>> So, how about removing the spin_lock?
>> And how about using a random number?
>
>> Thanks,
>>
>> 2013-09-06 (±Ý), 09:48 +0000, Chao Yu:
>>> Hi Kim:
>>>
>>>      I think there is a performance problem: when all sbi->fs_lock is
>>> holded,
>>>
>>> then all other threads may get the same next_lock value from
>>> sbi->next_lock_num in function mutex_lock_op,
>>>
>>> and wait to get the same lock at position fs_lock[next_lock], it
>>> unbalance the fs_lock usage.
>>>
>>> It may lost performance when we do the multithread test.
>>>
>>>
>>>
>>> Here is the patch to fix this problem:
>>>
>>>
>>>
>>> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
>>>
>>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>>
>>> old mode 100644
>>>
>>> new mode 100755
>>>
>>> index 467d42d..983bb45
>>>
>>> --- a/fs/f2fs/f2fs.h
>>>
>>> +++ b/fs/f2fs/f2fs.h
>>>
>>> @@ -371,6 +371,7 @@ struct f2fs_sb_info {
>>>
>>>         struct mutex fs_lock[NR_GLOBAL_LOCKS];  /* blocking FS
>>> operations */
>>>
>>>         struct mutex node_write;                /* locking node writes
>>> */
>>>
>>>         struct mutex writepages;                /* mutex for
>>> writepages() */
>>>
>>> +       spinlock_t spin_lock;                   /* lock for
>>> next_lock_num */
>>>
>>>         unsigned char next_lock_num;            /* round-robin global
>>> locks */
>>>
>>>         int por_doing;                          /* recovery is doing
>>> or not */
>>>
>>>         int on_build_free_nids;                 /* build_free_nids is
>>> doing */
>>>
>>> @@ -533,15 +534,19 @@ static inline void mutex_unlock_all(struct
>>> f2fs_sb_info *sbi)
>>>
>>>
>>>
>>>  static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
>>>
>>>  {
>>>
>>> -       unsigned char next_lock = sbi->next_lock_num %
>>> NR_GLOBAL_LOCKS;
>>>
>>> +       unsigned char next_lock;
>>>
>>>         int i = 0;
>>>
>>>
>>>
>>>         for (; i < NR_GLOBAL_LOCKS; i++)
>>>
>>>                 if (mutex_trylock(&sbi->fs_lock[i]))
>>>
>>>                         return i;
>>>
>>>
>>>
>>> -       mutex_lock(&sbi->fs_lock[next_lock]);
>>>
>>> +       spin_lock(&sbi->spin_lock);
>>>
>>> +       next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
>>>
>>>         sbi->next_lock_num++;
>>>
>>> +       spin_unlock(&sbi->spin_lock);
>>>
>>> +
>>>
>>> +       mutex_lock(&sbi->fs_lock[next_lock]);
>>>
>>>         return next_lock;
>>>
>>>  }
>>>
>>>
>>>
>>> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>>>
>>> old mode 100644
>>>
>>> new mode 100755
>>>
>>> index 75c7dc3..4f27596
>>>
>>> --- a/fs/f2fs/super.c
>>>
>>> +++ b/fs/f2fs/super.c
>>>
>>> @@ -657,6 +657,7 @@ static int f2fs_fill_super(struct super_block *sb,
>>> void *data, int silent)
>>>
>>>         mutex_init(&sbi->cp_mutex);
>>>
>>>         for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>>>
>>>                 mutex_init(&sbi->fs_lock[i]);
>>>
>>> +       spin_lock_init(&sbi->spin_lock);
>>>
>>>         mutex_init(&sbi->node_write);
>>>
>>>         sbi->por_doing = 0;
>>>
>>>         spin_lock_init(&sbi->stat_lock);
>>>
>>> (END)
>>>
>>>
>>>
>>>
>>>
>>>
>>
>
>
>
> ------------------------------------------------------------------------------
> How ServiceNow helps IT people transform IT departments:
> 1. Consolidate legacy IT systems to a single system of record for IT
> 2. Standardize and globalize service processes across IT
> 3. Implement zero-touch automation to replace manual, redundant tasks
> http://pubads.g.doubleclick.net/gampad/clk?id=51271111&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
