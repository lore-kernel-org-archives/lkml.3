Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3IKNPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:15:06 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43792 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3IKNPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <7684984.194071378867007969.JavaMail.weblogic@epml15>
References: <7684984.194071378867007969.JavaMail.weblogic@epml15>
Date: Wed, 11 Sep 2013 22:14:59 +0900
Message-ID: <CAOtxgyd3iDL6PHA4gFkuG6=Rw1Xr8HKnm5vNAfuyu9b-nvfe2g@mail.gmail.com>
Subject: Re: Re: [f2fs-dev][PATCH] f2fs: optimize fs_lock for better performance
From: Kim Jaegeuk <jaegeuk.kim@gmail.com>
To: chao2.yu@samsung.com
Cc: "???" <jaegeuk.kim@samsung.com>,
        =?UTF-8?B?6LCt5aed?= <shu.tan@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013/9/11 Chao Yu <chao2.yu@samsung.com>
>
> Hi Kim,
>
> I did some tests as you mention of using random instead of spin_lock.
> The test model is as following:
> eight threads race to grab one of eight locks for one thousand times,
> and I used four methods to generate lock num:
>
> 1.atomic_add_return(1, &sbi->next_lock_num) % NR_GLOBAL_LOCKS;
> 2.spin_lock(); next_lock_num++ % NR_GLOBAL_LOCKS; spin_unlock();
> 3.ktime_get().tv64 % NR_GLOBAL_LOCKS;
> 4.get_random_bytes(&next_lock, sizeof(unsigned int));
>
> the result indicate that:
> max count of collide continuously: 4 > 3 > 2 = 1
> max-min count of lock is grabbed: 4 > 3 > 2 = 1
> elapsed time of generating: 3 > 2 > 4 > 1
>
> So I think it's better to use atomic_add_return in round-robin method to
> cost less time and reduce collide.
> What's your opinion?

Could you test with sbi->next_lock_num++ only instead of using
atomic_add_return?
IMO, this is just an integer value and still I don't think this value should
be covered by any kind of locks.
Thanks,

>
> thanks
>
> ------- Original Message -------
> Sender : ???<jaegeuk.kim@samsung.com> S5(??)/??/?????????(???)/????
> Date : ÎúêÅ 10, 2013 09:52 (GMT+09:00)
> Title : Re: [f2fs-dev][PATCH] f2fs: optimize fs_lock for better performance
>
> Hi,
>
> At first, thank you for the report and please follow the email writing
> rules. :)
>
> Anyway, I agree to the below issue.
> One thing that I can think of is that we don't need to use the
> spin_lock, since we don't care about the exact lock number, but just
> need to get any not-collided number.
>
> So, how about removing the spin_lock?
> And how about using a random number?
> Thanks,
>
> 2013-09-06 (?), 09:48 +0000, Chao Yu:
> > Hi Kim:
> >
> >      I think there is a performance problem: when all sbi->fs_lock is
> > holded,
> >
> > then all other threads may get the same next_lock value from
> > sbi->next_lock_num in function mutex_lock_op,
> >
> > and wait to get the same lock at position fs_lock[next_lock], it
> > unbalance the fs_lock usage.
> >
> > It may lost performance when we do the multithread test.
> >
> >
> >
> > Here is the patch to fix this problem:
> >
> >
> >
> > Signed-off-by: Yu Chao
> >
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> >
> > old mode 100644
> >
> > new mode 100755
> >
> > index 467d42d..983bb45
> >
> > --- a/fs/f2fs/f2fs.h
> >
> > +++ b/fs/f2fs/f2fs.h
> >
> > @@ -371,6 +371,7 @@ struct f2fs_sb_info {
> >
> >         struct mutex fs_lock[NR_GLOBAL_LOCKS];  /* blocking FS
> > operations */
> >
> >         struct mutex node_write;                /* locking node writes
> > */
> >
> >         struct mutex writepages;                /* mutex for
> > writepages() */
> >
> > +       spinlock_t spin_lock;                   /* lock for
> > next_lock_num */
> >
> >         unsigned char next_lock_num;            /* round-robin global
> > locks */
> >
> >         int por_doing;                          /* recovery is doing
> > or not */
> >
> >         int on_build_free_nids;                 /* build_free_nids is
> > doing */
> >
> > @@ -533,15 +534,19 @@ static inline void mutex_unlock_all(struct
> > f2fs_sb_info *sbi)
> >
> >
> >
> >  static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
> >
> >  {
> >
> > -       unsigned char next_lock = sbi->next_lock_num %
> > NR_GLOBAL_LOCKS;
> >
> > +       unsigned char next_lock;
> >
> >         int i = 0;
> >
> >
> >
> >         for (; i < NR_GLOBAL_LOCKS; i++)
> >
> >                 if (mutex_trylock(&sbi->fs_lock[i]))
> >
> >                         return i;
> >
> >
> >
> > -       mutex_lock(&sbi->fs_lock[next_lock]);
> >
> > +       spin_lock(&sbi->spin_lock);
> >
> > +       next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
> >
> >         sbi->next_lock_num++;
> >
> > +       spin_unlock(&sbi->spin_lock);
> >
> > +
> >
> > +       mutex_lock(&sbi->fs_lock[next_lock]);
> >
> >         return next_lock;
> >
> >  }
> >
> >
> >
> > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> >
> > old mode 100644
> >
> > new mode 100755
> >
> > index 75c7dc3..4f27596
> >
> > --- a/fs/f2fs/super.c
> >
> > +++ b/fs/f2fs/super.c
> >
> > @@ -657,6 +657,7 @@ static int f2fs_fill_super(struct super_block *sb,
> > void *data, int silent)
> >
> >         mutex_init(&sbi->cp_mutex);
> >
> >         for (i = 0; i < NR_GLOBAL_LOCKS; i++)
> >
> >                 mutex_init(&sbi->fs_lock[i]);
> >
> > +       spin_lock_init(&sbi->spin_lock);
> >
> >         mutex_init(&sbi->node_write);
> >
> >         sbi->por_doing = 0;
> >
> >         spin_lock_init(&sbi->stat_lock);
> >
> > (END)
> >
> >
> >
> >
> >
> >
>
> --
> Jaegeuk Kim
> Samsung
