Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3IKD3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:29:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab3IKD3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:29:18 -0400
X-IronPort-AV: E=Sophos;i="4.90,881,1371052800"; 
   d="scan'208";a="8483952"
Message-ID: <522FDFC3.3010200@cn.fujitsu.com>
Date: Wed, 11 Sep 2013 11:13:07 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: chao2.yu@samsung.com, shu.tan@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev][PATCH] f2fs: optimize fs_lock for better performance
References: <88.C4.11914.9D4A9225@epcpsbge6.samsung.com> <1378774324.2354.103.camel@kjgkr>
In-Reply-To: <1378774324.2354.103.camel@kjgkr>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/11 11:15:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/11 11:15:41
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

On 09/10/2013 08:52 AM, Jaegeuk Kim wrote:

> Hi,
> 
> At first, thank you for the report and please follow the email writing
> rules. :)
> 
> Anyway, I agree to the below issue.
> One thing that I can think of is that we don't need to use the
> spin_lock, since we don't care about the exact lock number, but just
> need to get any not-collided number.

Agree, but if all the locks are held, IMO, we need to balance the following
threads to wait for each not-collided number lock, though complete balance is unreachable.

> 
> So, how about removing the spin_lock?

Yeah, in this case, spin_lock is a bit heavy cost. 

> And how about using a random number?

Now NR_GLOBAL_LOCKS is 8, it seems that random can not offer an balance number as we expected.

Regards,
Gu 

> Thanks,
> 
> 2013-09-06 (금), 09:48 +0000, Chao Yu:
>> Hi Kim:
>>
>>      I think there is a performance problem: when all sbi->fs_lock is
>> holded, 
>>
>> then all other threads may get the same next_lock value from
>> sbi->next_lock_num in function mutex_lock_op, 
>>
>> and wait to get the same lock at position fs_lock[next_lock], it
>> unbalance the fs_lock usage. 
>>
>> It may lost performance when we do the multithread test.
>>
>>  
>>
>> Here is the patch to fix this problem:
>>
>>  
>>
>> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
>>
>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>
>> old mode 100644
>>
>> new mode 100755
>>
>> index 467d42d..983bb45
>>
>> --- a/fs/f2fs/f2fs.h
>>
>> +++ b/fs/f2fs/f2fs.h
>>
>> @@ -371,6 +371,7 @@ struct f2fs_sb_info {
>>
>>         struct mutex fs_lock[NR_GLOBAL_LOCKS];  /* blocking FS
>> operations */
>>
>>         struct mutex node_write;                /* locking node writes
>> */
>>
>>         struct mutex writepages;                /* mutex for
>> writepages() */
>>
>> +       spinlock_t spin_lock;                   /* lock for
>> next_lock_num */
>>
>>         unsigned char next_lock_num;            /* round-robin global
>> locks */
>>
>>         int por_doing;                          /* recovery is doing
>> or not */
>>
>>         int on_build_free_nids;                 /* build_free_nids is
>> doing */
>>
>> @@ -533,15 +534,19 @@ static inline void mutex_unlock_all(struct
>> f2fs_sb_info *sbi)
>>
>>  
>>
>>  static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
>>
>>  {
>>
>> -       unsigned char next_lock = sbi->next_lock_num %
>> NR_GLOBAL_LOCKS;
>>
>> +       unsigned char next_lock;
>>
>>         int i = 0;
>>
>>  
>>
>>         for (; i < NR_GLOBAL_LOCKS; i++)
>>
>>                 if (mutex_trylock(&sbi->fs_lock[i]))
>>
>>                         return i;
>>
>>  
>>
>> -       mutex_lock(&sbi->fs_lock[next_lock]);
>>
>> +       spin_lock(&sbi->spin_lock);
>>
>> +       next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
>>
>>         sbi->next_lock_num++;
>>
>> +       spin_unlock(&sbi->spin_lock);
>>
>> +
>>
>> +       mutex_lock(&sbi->fs_lock[next_lock]);
>>
>>         return next_lock;
>>
>>  }
>>
>>  
>>
>> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>>
>> old mode 100644
>>
>> new mode 100755
>>
>> index 75c7dc3..4f27596
>>
>> --- a/fs/f2fs/super.c
>>
>> +++ b/fs/f2fs/super.c
>>
>> @@ -657,6 +657,7 @@ static int f2fs_fill_super(struct super_block *sb,
>> void *data, int silent)
>>
>>         mutex_init(&sbi->cp_mutex);
>>
>>         for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>>
>>                 mutex_init(&sbi->fs_lock[i]);
>>
>> +       spin_lock_init(&sbi->spin_lock);
>>
>>         mutex_init(&sbi->node_write);
>>
>>         sbi->por_doing = 0;
>>
>>         spin_lock_init(&sbi->stat_lock);
>>
>> (END)
>>
>>  
>>
>>
>>
>>
> 


