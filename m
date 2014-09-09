Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaIIFNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:13:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:54199 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaIIFNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:13:06 -0400
Date: Mon, 8 Sep 2014 22:13:03 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] f2fs: Remove lock from check_valid_map
Message-ID: <20140909051303.GB24581@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1410059104-9060-1-git-send-email-ying.huang@intel.com>
 <1410061110-31081-1-git-send-email-ying.huang@intel.com>
 <20140908035024.GA13009@jaegeuk-mac02.hsd1.ca.comcast.net>
 <CAC=cRTOdvOp=zBT986SqGXC2+iRxGzSgKdFYzTQjbAamYsGVsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=cRTOdvOp=zBT986SqGXC2+iRxGzSgKdFYzTQjbAamYsGVsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Mon, Sep 08, 2014 at 03:36:35PM +0800, huang ying wrote:
> Hi, Jaegeuk,
> 
> On Mon, Sep 8, 2014 at 11:50 AM, Jaegeuk Kim <jaegeuk@kernel.org> wrote:
> 
> > Hi,
> >
> > On Sun, Sep 07, 2014 at 11:38:30AM +0800, Huang Ying wrote:
> > > Only one bit is read in check_valid_map, holding a lock to do that
> > > doesn't help anything except decreasing performance.
> > >
> > > Signed-off-by: Huang, Ying <ying.huang@intel.com>
> > > ---
> > >
> > > v2: Fixed a build warning.
> > >
> > > ---
> > >  fs/f2fs/gc.c |    3 ---
> > >  1 file changed, 3 deletions(-)
> > >
> > > --- a/fs/f2fs/gc.c
> > > +++ b/fs/f2fs/gc.c
> > > @@ -378,14 +378,11 @@ static void put_gc_inode(struct list_hea
> > >  static int check_valid_map(struct f2fs_sb_info *sbi,
> > >                               unsigned int segno, int offset)
> > >  {
> > > -     struct sit_info *sit_i = SIT_I(sbi);
> > >       struct seg_entry *sentry;
> > >       int ret;
> > >
> > > -     mutex_lock(&sit_i->sentry_lock);
> > >       sentry = get_seg_entry(sbi, segno);
> > >       ret = f2fs_test_bit(offset, sentry->cur_valid_map);
> > > -     mutex_unlock(&sit_i->sentry_lock);
> > >       return ret;
> >
> > The f2fs_test_bit is not atomic, so I'm not sure this is a good approach.
> > How about introducing rw_semaphore?
> >
> 
> IMO, f2fs_test_bit just read a global variable (a byte in cur_valid_map),
> then check its value. The byte may be changed in another CPU concurrently.
> But even protected with a mutex, it can be changed in another CPU
> immediately after mutex_unlock.  So mutex does not help  here.  Here we
> just read a global variable, not read/modify/write, so, we don't need
> atomic too.

Hmm. This is a pretty hard corner case to allow the mutex removal under the
following assumption.

1. All the sit entries are cached in a global array, which means that it never
happens that any sit entry pointers are changed.

2. I agree that f2fs_gc tries to conduct the cleaning with best effort, and
it triggers again when it detects there is something to do more.
So, check_valid_bitmap doesn't need to make a precise decision.

But, what I concern is the consistent policy to use such the mutex.
If we break the rule, it becomes harder to debug potential bugs.

Anyway, have you been facing with such the lock contention?

Thanks,

> 
> Best Regards,
> Huang, Ying
