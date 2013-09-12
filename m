Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3ILCmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 22:42:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37238 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3ILCl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 22:41:59 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-35-523129f5f604
From: =?UTF-8?B?5L+e6LaF?= <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>, jaegeuk.kim@samsung.com
Cc: shu.tan@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <88.C4.11914.9D4A9225@epcpsbge6.samsung.com>
 <1378774324.2354.103.camel@kjgkr> <523001B6.3080506@cn.fujitsu.com>
In-reply-to: <523001B6.3080506@cn.fujitsu.com>
Subject: RE: [f2fs-dev][PATCH] f2fs: optimize fs_lock for better performance
Date: Thu, 12 Sep 2013 10:40:27 +0800
Message-id: <001001ceaf61$a4ea9a90$eebfcfb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHGGmG1UIdClQlJJ/WiYLzMNbXhgAGqy+RaAe5/xT6ZtbwSAA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jQd2vmoZBBtu2iVo8bz/AbHF9118m
	i0uL3C327D3JYnF51xw2i9aF55kd2Dz+H5zE7LF7wWcmj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq4Me0na8FytYr7K1YxNjBek+5i5OSQEDCRuLbsDzOELSZx4d56ti5GLg4hgemMEs1P
	O6GcH4wSLw8/Zepi5OBgEzCU2PkxGKRBRMBRYuGpnSwgYWaBOokdB1RBwkJA5pJzp5hAbE4B
	PYkDz16C2cICPhK7d9xkBSlnEVCVWHhYHSTMK2Ap0dW2mhHCFpT4MfkeC4jNLKAuMWneImYI
	W1viybsLrBBnKkjsOPuaEeICJ4mee0eg6sUlNh65xTKBUWgWklGzkIyahWTULCQtCxhZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIEx8QzqR2MKxssDjEKcDAq8fB2zDIIEmJNLCuuzD3E
	KMHBrCTCe+sfUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwen
	VAMj51mbxzfjt2vfvtc/zSbz/Rbza6z+Cx/fC6y4aMd/fnVobeWskiN7y1az/n8Yv7D/elpz
	hsScsGNOzct3uKvyH3q0nFHDfK+h9Y8Z1yw69aYnyfllb+kKmRpxXTRmWmudzj3tsqaVLle3
	fbpQZnj35s8UT5dglf3zVdpcLuouebMu8tFdTuWbSizFGYmGWsxFxYkAA4ng6IUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Wednesday, September 11, 2013 1:38 PM
> To: jaegeuk.kim@samsung.com
> Cc: chao2.yu@samsung.com; shu.tan@samsung.com;
> linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev][PATCH] f2fs: optimize fs_lock for better performance
> 
> Hi Jaegeuk, Chao,
> 
> On 09/10/2013 08:52 AM, Jaegeuk Kim wrote:
> 
> > Hi,
> >
> > At first, thank you for the report and please follow the email writing
> > rules. :)
> >
> > Anyway, I agree to the below issue.
> > One thing that I can think of is that we don't need to use the
> > spin_lock, since we don't care about the exact lock number, but just
> > need to get any not-collided number.
> 
> IMHO, just moving sbi->next_lock_num++ before
> mutex_lock(&sbi->fs_lock[next_lock])
> can avoid unbalance issue mostly.
> IMO, the case two or more threads increase sbi->next_lock_num in the same
> time is really very very little. If you think it is not rigorous, change
> next_lock_num to atomic one can fix it.
> What's your opinion?
> 
> Regards,
> Gu

I did the test sbi->next_lock_num++ compare with the atomic one,
And I found performance of them is almost the same under a small number thread racing.
So as your and Kim's opinion, it's enough to use "sbi->next_lock_num++" to fix this issue.

Thanks for the advice.
> 
> >
> > So, how about removing the spin_lock?
> > And how about using a random number?
> 
> > Thanks,
> >
> > 2013-09-06 (금), 09:48 +0000, Chao Yu:
> >> Hi Kim:
> >>
> >>      I think there is a performance problem: when all sbi->fs_lock is
> >> holded,
> >>
> >> then all other threads may get the same next_lock value from
> >> sbi->next_lock_num in function mutex_lock_op,
> >>
> >> and wait to get the same lock at position fs_lock[next_lock], it
> >> unbalance the fs_lock usage.
> >>
> >> It may lost performance when we do the multithread test.
> >>
> >>
> >>
> >> Here is the patch to fix this problem:
> >>
> >>
> >>
> >> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> >>
> >> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> >>
> >> old mode 100644
> >>
> >> new mode 100755
> >>
> >> index 467d42d..983bb45
> >>
> >> --- a/fs/f2fs/f2fs.h
> >>
> >> +++ b/fs/f2fs/f2fs.h
> >>
> >> @@ -371,6 +371,7 @@ struct f2fs_sb_info {
> >>
> >>         struct mutex fs_lock[NR_GLOBAL_LOCKS];  /* blocking FS
> >> operations */
> >>
> >>         struct mutex node_write;                /* locking node
> writes
> >> */
> >>
> >>         struct mutex writepages;                /* mutex for
> >> writepages() */
> >>
> >> +       spinlock_t spin_lock;                   /* lock for
> >> next_lock_num */
> >>
> >>         unsigned char next_lock_num;            /* round-robin
> global
> >> locks */
> >>
> >>         int por_doing;                          /* recovery is doing
> >> or not */
> >>
> >>         int on_build_free_nids;                 /* build_free_nids is
> >> doing */
> >>
> >> @@ -533,15 +534,19 @@ static inline void mutex_unlock_all(struct
> >> f2fs_sb_info *sbi)
> >>
> >>
> >>
> >>  static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
> >>
> >>  {
> >>
> >> -       unsigned char next_lock = sbi->next_lock_num %
> >> NR_GLOBAL_LOCKS;
> >>
> >> +       unsigned char next_lock;
> >>
> >>         int i = 0;
> >>
> >>
> >>
> >>         for (; i < NR_GLOBAL_LOCKS; i++)
> >>
> >>                 if (mutex_trylock(&sbi->fs_lock[i]))
> >>
> >>                         return i;
> >>
> >>
> >>
> >> -       mutex_lock(&sbi->fs_lock[next_lock]);
> >>
> >> +       spin_lock(&sbi->spin_lock);
> >>
> >> +       next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
> >>
> >>         sbi->next_lock_num++;
> >>
> >> +       spin_unlock(&sbi->spin_lock);
> >>
> >> +
> >>
> >> +       mutex_lock(&sbi->fs_lock[next_lock]);
> >>
> >>         return next_lock;
> >>
> >>  }
> >>
> >>
> >>
> >> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> >>
> >> old mode 100644
> >>
> >> new mode 100755
> >>
> >> index 75c7dc3..4f27596
> >>
> >> --- a/fs/f2fs/super.c
> >>
> >> +++ b/fs/f2fs/super.c
> >>
> >> @@ -657,6 +657,7 @@ static int f2fs_fill_super(struct super_block
> >> *sb, void *data, int silent)
> >>
> >>         mutex_init(&sbi->cp_mutex);
> >>
> >>         for (i = 0; i < NR_GLOBAL_LOCKS; i++)
> >>
> >>                 mutex_init(&sbi->fs_lock[i]);
> >>
> >> +       spin_lock_init(&sbi->spin_lock);
> >>
> >>         mutex_init(&sbi->node_write);
> >>
> >>         sbi->por_doing = 0;
> >>
> >>         spin_lock_init(&sbi->stat_lock);
> >>
> >> (END)
> >>
> >>
> >>
> >>
> >>
> >>
> >
> 
> 
> =

