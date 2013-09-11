Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3IKNTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:19:18 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40967 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3IKNTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:19:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfvh63mWMq4-eajOZVXqBDW3judq28DYmnrTCdFRM+N8t_S8w@mail.gmail.com>
References: <04.C0.13361.61DDA225@epcpsbge5.samsung.com>
	<1378774750.2354.110.camel@kjgkr>
	<522FE1FF.9010901@cn.fujitsu.com>
	<CAGfvh63mWMq4-eajOZVXqBDW3judq28DYmnrTCdFRM+N8t_S8w@mail.gmail.com>
Date: Wed, 11 Sep 2013 22:19:15 +0900
Message-ID: <CAOtxgyc7QOPERiyWyXO6cSHgvo1d4GxGs4RrCR1NssRcCqi73A@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH] f2fs: optimize fs_lock for better performance
From: Kim Jaegeuk <jaegeuk.kim@gmail.com>
To: Russ Knize <Russ.Knize@motorola.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        =?UTF-8?B?6LCt5aed?= <shu.tan@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russ,

The usage of fs_locks is for the recovery, so it doesn't matter
with stress-testing.
Actually what I've concerned is that we should not grab two or
more fs_locks in the same call path.
Thanks,

2013/9/11 Russ Knize <Russ.Knize@motorola.com>:
> Hi Jaegeuk/Gu,
>
> I've removed the lock and have been stress-testing with SELinux and some
> additional xattr torture for 24+ hours.  I have not encountered any issues
> yet.
>
> My previous suggestion about moving the lock is probably not a good idea
> without some significant code rework (thanks to the f2fs_balance_fs call in
> f2fs_setxattr).
>
> Russ
>
> On Tue, Sep 10, 2013 at 10:22 PM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
>>
>> Hi Jaegeuk,
>> On 09/10/2013 08:59 AM, Jaegeuk Kim wrote:
>>
>> > Hi,
>> >
>> > 2013-09-07 (Åä), 08:00 +0000, Chao Yu:
>> >> Hi Knize,
>> >>
>> >>     Thanks for your reply, I think it's actually meaningless that it's
>> >> being named after "spin_lock",
>> >> it's better to rename this spinlock to "round_robin_lock".
>> >>
>> >>     This patch can only resolve the issue of unbalanced fs_lock usage,
>> >> it can not fix the deadlock issue.
>> >> can we fix deadlock issue through this method:
>> >>
>> >> - vfs_create()
>> >>  - f2fs_create() - takes an fs_lock and save current thread info into
>> >> thread_info[NR_GLOBAL_LOCKS]
>> >>   - f2fs_add_link()
>> >>    - __f2fs_add_link()
>> >>     - init_inode_metadata()
>> >>      - f2fs_init_security()
>> >>       - security_inode_init_security()
>> >>        - f2fs_initxattrs()
>> >>         - f2fs_setxattr() - get fs_lock only if there is no current
>> >> thread info in thread_info
>> >>
>> >> So it keeps one thread can only hold one fs_lock to avoid deadlock.
>> >> Can we use this solution?
>> >
>> > It could be.
>> > But, I think we can avoid to grab the fs_lock at the f2fs_initxattrs()
>>
>> Agree. This fs_lock here is used to protect the xattr from parallel
>> modification,
>> but here is in the initxattrs routine, parallel modification can not
>> happen.
>> And in the normal setxattr routine the inode->i_mutex (vfs layer) is used
>> to
>> avoid parallel modification. So I think this fs_lock is needless.
>> Am I missing something?
>>
>> Regards,
>> Gu
>>
>> > level, since this case only happens when f2fs_initxattrs() is called.
>> > Let's think about ut in more detail.
>> > Thanks,
>> >
>> >>
>> >>
>> >>
>> >> thanks again!
>> >>
>> >>
>> >>
>> >> ------- Original Message -------
>> >>
>> >> Sender : Russ Knize<Russ.Knize@motorola.com>
>> >>
>> >> Date : ÎúêÅ 07, 2013 04:25 (GMT+09:00)
>> >>
>> >> Title : Re: [f2fs-dev] [PATCH] f2fs: optimize fs_lock for better
>> >> performance
>> >>
>> >>
>> >>
>> >> I encountered this same issue recently and solved it in much the same
>> >> way.  Can we rename "spin_lock" to something more meaningful?
>> >>
>> >>
>> >> This race actually exposed a potential deadlock between f2fs_create()
>> >> and f2fs_initxattrs():
>> >>
>> >>
>> >> - vfs_create()
>> >>  - f2fs_create() - takes an fs_lock
>> >>   - f2fs_add_link()
>> >>    - __f2fs_add_link()
>> >>     - init_inode_metadata()
>> >>      - f2fs_init_security()
>> >>       - security_inode_init_security()
>> >>        - f2fs_initxattrs()
>> >>         - f2fs_setxattr() - also takes an fs_lock
>> >>
>> >>
>> >> If another CPU happens to have the same lock that f2fs_setxattr() was
>> >> trying to take because of the race around next_lock_num, we can get
>> >> into a deadlock situation if the two threads are also contending over
>> >> another resource (like bdi).
>> >>
>> >>
>> >> Another scenario is if the above happens while another thread is in
>> >> the middle of grabbing all of the locks via mutex_lock_all().
>> >>  f2fs_create() is holding a lock that mutex_lock_all() is waiting for
>> >> and mutex_lock_all() is holding a lock that f2fs_setxattr() is waiting
>> >> for.
>> >>
>> >>
>> >> Russ
>> >>
>> >>
>> >> On Fri, Sep 6, 2013 at 4:48 AM, Chao Yu <chao2.yu@samsung.com> wrote:
>> >>         Hi Kim:
>> >>
>> >>              I think there is a performance problem: when all
>> >>         sbi->fs_lock is holded,
>> >>
>> >>         then all other threads may get the same next_lock value from
>> >>         sbi->next_lock_num in function mutex_lock_op,
>> >>
>> >>         and wait to get the same lock at position fs_lock[next_lock],
>> >>         it unbalance the fs_lock usage.
>> >>
>> >>         It may lost performance when we do the multithread test.
>> >>
>> >>
>> >>
>> >>         Here is the patch to fix this problem:
>> >>
>> >>
>> >>
>> >>         Signed-off-by: Yu Chao <chao2.yu@samsung.com>
>> >>
>> >>         diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> >>
>> >>         old mode 100644
>> >>
>> >>         new mode 100755
>> >>
>> >>         index 467d42d..983bb45
>> >>
>> >>         --- a/fs/f2fs/f2fs.h
>> >>
>> >>         +++ b/fs/f2fs/f2fs.h
>> >>
>> >>         @@ -371,6 +371,7 @@ struct f2fs_sb_info {
>> >>
>> >>                 struct mutex fs_lock[NR_GLOBAL_LOCKS];  /* blocking FS
>> >>         operations */
>> >>
>> >>                 struct mutex node_write;                /* locking
>> >>         node writes */
>> >>
>> >>                 struct mutex writepages;                /* mutex for
>> >>         writepages() */
>> >>
>> >>         +       spinlock_t spin_lock;                   /* lock for
>> >>         next_lock_num */
>> >>
>> >>                 unsigned char next_lock_num;            /* round-robin
>> >>         global locks */
>> >>
>> >>                 int por_doing;                          /* recovery is
>> >>         doing or not */
>> >>
>> >>                 int on_build_free_nids;                 /*
>> >>         build_free_nids is doing */
>> >>
>> >>         @@ -533,15 +534,19 @@ static inline void
>> >>         mutex_unlock_all(struct f2fs_sb_info *sbi)
>> >>
>> >>
>> >>
>> >>          static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
>> >>
>> >>          {
>> >>
>> >>         -       unsigned char next_lock = sbi->next_lock_num %
>> >>         NR_GLOBAL_LOCKS;
>> >>
>> >>         +       unsigned char next_lock;
>> >>
>> >>                 int i = 0;
>> >>
>> >>
>> >>
>> >>                 for (; i < NR_GLOBAL_LOCKS; i++)
>> >>
>> >>                         if (mutex_trylock(&sbi->fs_lock[i]))
>> >>
>> >>                                 return i;
>> >>
>> >>
>> >>
>> >>         -       mutex_lock(&sbi->fs_lock[next_lock]);
>> >>
>> >>         +       spin_lock(&sbi->spin_lock);
>> >>
>> >>         +       next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
>> >>
>> >>                 sbi->next_lock_num++;
>> >>
>> >>         +       spin_unlock(&sbi->spin_lock);
>> >>
>> >>         +
>> >>
>> >>         +       mutex_lock(&sbi->fs_lock[next_lock]);
>> >>
>> >>                 return next_lock;
>> >>
>> >>          }
>> >>
>> >>
>> >>
>> >>         diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>> >>
>> >>         old mode 100644
>> >>
>> >>         new mode 100755
>> >>
>> >>         index 75c7dc3..4f27596
>> >>
>> >>         --- a/fs/f2fs/super.c
>> >>
>> >>         +++ b/fs/f2fs/super.c
>> >>
>> >>         @@ -657,6 +657,7 @@ static int f2fs_fill_super(struct
>> >>         super_block *sb, void *data, int silent)
>> >>
>> >>                 mutex_init(&sbi->cp_mutex);
>> >>
>> >>                 for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>> >>
>> >>                         mutex_init(&sbi->fs_lock[i]);
>> >>
>> >>         +       spin_lock_init(&sbi->spin_lock);
>> >>
>> >>                 mutex_init(&sbi->node_write);
>> >>
>> >>                 sbi->por_doing = 0;
>> >>
>> >>                 spin_lock_init(&sbi->stat_lock);
>> >>
>> >>         (END)
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >> ------------------------------------------------------------------------------
>> >>         Learn the latest--Visual Studio 2012, SharePoint 2013, SQL
>> >>         2012, more!
>> >>         Discover the easy way to master current and previous Microsoft
>> >>         technologies
>> >>         and advance your career. Get an incredible 1,500+ hours of
>> >>         step-by-step
>> >>         tutorial videos with LearnDevNow. Subscribe today and save!
>> >>
>> >> http://pubads.g.doubleclick.net/gampad/clk?id=58041391&iu=/4140/ostg.clktrk
>> >>         _______________________________________________
>> >>         Linux-f2fs-devel mailing list
>> >>         Linux-f2fs-devel@lists.sourceforge.net
>> >>         https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >
>>
>>
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
>
