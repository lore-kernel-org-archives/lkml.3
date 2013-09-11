Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3IKCg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:36:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40463 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3IKCg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:36:56 -0400
X-AuditID: cbfee6a4-b7f956d00000525e-be-522fd7417d08
Date: Wed, 11 Sep 2013 02:36:49 +0000 (GMT)
From: Chao Yu <chao2.yu@samsung.com>
Subject: Re: Re: [f2fs-dev][PATCH] f2fs: optimize fs_lock for better performance
To: =?gb2312?Q?=3F=3F=3F?= <jaegeuk.kim@samsung.com>
Cc: =?gb2312?Q?=CC=B7=E6=AD?= <shu.tan@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>
Reply-to: chao2.yu@samsung.com
MIME-version: 1.0
X-MTR: 20130911023640647@chao2.yu
Msgkey: 20130911023640647@chao2.yu
X-EPLocale: zh_CN.gb2312
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130911023640647@chao2.yu
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=gb2312
MIME-version: 1.0
Message-id: <7684984.194071378867007969.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/tGbqO1/WDDGbvEbO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ+w74FXzRrZj4cSpjA+MNnS5GTg4hAWWJp88esIDYEgImEnt3
	9ELZYhIX7q1n62LkAqqZzyixe8cnJpAEi4CqRNum02A2G5C98DNIESeHsECAREfzXzBbRMBM
	4vGrF8wgzcwCfUwS9+++ZYPYJiex62o3M4jNKyAocXLmE6htihI/519ghYgrSUxf+hVoAQdQ
	XEJi1aVIiBJeiRntT6HK5SSmfV3DDGFLS5yftYER5ujF3x9Dxfkljt3eATWGV+LJ/WCYMbs3
	f2GDsAUkpp45CNWqJtE3dxU7hM0nsWbhWxaYMbtOLWeG6b2/ZS7Y68xAF0/pfsgOYWtJzGv4
	zYTuK14BR4lzvbtZJjDKzUKSmoWkfRaSdmQ1CxhZVjGKphYkFxQnpVeY6BUn5haX5qXrJefn
	bmIER/mzJTsYGy5YH2IU4GBU4uE1UNQPEmJNLCuuzD3EKMHBrCTCO9UJKMSbklhZlVqUH19U
	mpNafIhRmoNFSZz3Wat1oJBAemJJanZqakFqEUyWiYNTqoHRQTNJylSmxVHrSliyyZbb6xdF
	n3f+9ion4cuv8KNPzV6wfS9gZjz/MSy4cdudzJVabo33l535fmCnOsPEySatsoeW53K/kru5
	Zk/J28Nv+XI3f2TnfSu+cuq28D0H9V1rXTdNSDnc0/ntlmHrgscl/vXRE7I3+M5d935OY4np
	nKC+22s6bx91VmIpzkg01GIuKk4EABTUvYPuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8B2b5vw032028

Hi Kim,

I did some tests as you mention of using random instead of spin_lock.
The test model is as following:
eight threads race to grab one of eight locks for one thousand times,
and I used four methods to generate lock num: 

1.atomic_add_return(1, &sbi->next_lock_num) % NR_GLOBAL_LOCKS;
2.spin_lock(); next_lock_num++ % NR_GLOBAL_LOCKS; spin_unlock();
3.ktime_get().tv64 % NR_GLOBAL_LOCKS;
4.get_random_bytes(&next_lock, sizeof(unsigned int));

the result indicate that:
max count of collide continuously: 4 > 3 > 2 = 1
max-min count of lock is grabbed: 4 > 3 > 2 = 1
elapsed time of generating: 3 > 2 > 4 > 1

So I think it's better to use atomic_add_return in round-robin method to
cost less time and reduce collide.
What's your opinion?

thanks

------- Original Message -------
Sender : ???<jaegeuk.kim@samsung.com> S5(??)/??/?????????(???)/????
Date : æ≈‘¬ 10, 2013 09:52 (GMT+09:00)
Title : Re: [f2fs-dev][PATCH] f2fs: optimize fs_lock for better performance

Hi,

At first, thank you for the report and please follow the email writing
rules. :)

Anyway, I agree to the below issue.
One thing that I can think of is that we don't need to use the
spin_lock, since we don't care about the exact lock number, but just
need to get any not-collided number.

So, how about removing the spin_lock?
And how about using a random number?
Thanks,

2013-09-06 (?), 09:48 +0000, Chao Yu:
> Hi Kim:
> 
>      I think there is a performance problem: when all sbi->fs_lock is
> holded, 
> 
> then all other threads may get the same next_lock value from
> sbi->next_lock_num in function mutex_lock_op, 
> 
> and wait to get the same lock at position fs_lock[next_lock], it
> unbalance the fs_lock usage. 
> 
> It may lost performance when we do the multithread test.
> 
>  
> 
> Here is the patch to fix this problem:
> 
>  
> 
> Signed-off-by: Yu Chao 
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> 
> old mode 100644
> 
> new mode 100755
> 
> index 467d42d..983bb45
> 
> --- a/fs/f2fs/f2fs.h
> 
> +++ b/fs/f2fs/f2fs.h
> 
> @@ -371,6 +371,7 @@ struct f2fs_sb_info {
> 
>         struct mutex fs_lock[NR_GLOBAL_LOCKS];  /* blocking FS
> operations */
> 
>         struct mutex node_write;                /* locking node writes
> */
> 
>         struct mutex writepages;                /* mutex for
> writepages() */
> 
> +       spinlock_t spin_lock;                   /* lock for
> next_lock_num */
> 
>         unsigned char next_lock_num;            /* round-robin global
> locks */
> 
>         int por_doing;                          /* recovery is doing
> or not */
> 
>         int on_build_free_nids;                 /* build_free_nids is
> doing */
> 
> @@ -533,15 +534,19 @@ static inline void mutex_unlock_all(struct
> f2fs_sb_info *sbi)
> 
>  
> 
>  static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
> 
>  {
> 
> -       unsigned char next_lock = sbi->next_lock_num %
> NR_GLOBAL_LOCKS;
> 
> +       unsigned char next_lock;
> 
>         int i = 0;
> 
>  
> 
>         for (; i < NR_GLOBAL_LOCKS; i++)
> 
>                 if (mutex_trylock(&sbi->fs_lock[i]))
> 
>                         return i;
> 
>  
> 
> -       mutex_lock(&sbi->fs_lock[next_lock]);
> 
> +       spin_lock(&sbi->spin_lock);
> 
> +       next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
> 
>         sbi->next_lock_num++;
> 
> +       spin_unlock(&sbi->spin_lock);
> 
> +
> 
> +       mutex_lock(&sbi->fs_lock[next_lock]);
> 
>         return next_lock;
> 
>  }
> 
>  
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> 
> old mode 100644
> 
> new mode 100755
> 
> index 75c7dc3..4f27596
> 
> --- a/fs/f2fs/super.c
> 
> +++ b/fs/f2fs/super.c
> 
> @@ -657,6 +657,7 @@ static int f2fs_fill_super(struct super_block *sb,
> void *data, int silent)
> 
>         mutex_init(&sbi->cp_mutex);
> 
>         for (i = 0; i < NR_GLOBAL_LOCKS; i++)
> 
>                 mutex_init(&sbi->fs_lock[i]);
> 
> +       spin_lock_init(&sbi->spin_lock);
> 
>         mutex_init(&sbi->node_write);
> 
>         sbi->por_doing = 0;
> 
>         spin_lock_init(&sbi->stat_lock);
> 
> (END)
> 
>  
> 
> 
> 
> 

-- 
Jaegeuk Kim
SamsungˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
