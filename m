Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3JAUXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:23:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50783 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751539Ab3JAUXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:23:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ronald <ronald645@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: Fwd: [v3.12-rc1] [regression] PM / hibernate: Create memory bitmaps after freezing user space
Date: Tue, 01 Oct 2013 22:35:11 +0200
Message-ID: <1609889.2pSzhO4Dqr@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAF1_xX0veXd4AtPR43r50g8Tu4WeP0kVzqPihgSC-NCpW+nwkQ@mail.gmail.com>
References: <CAF1_xX2=BYkEn3ycM4smREqk-ioGbvu8Ea4or22U-jBdKmDKGA@mail.gmail.com> <7570724.v5QLmkRO38@vostro.rjw.lan> <CAF1_xX0veXd4AtPR43r50g8Tu4WeP0kVzqPihgSC-NCpW+nwkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 01, 2013 06:38:03 PM Ronald wrote:
> This could be a coincidence, but I had a disk data corruption in /var
> (LVM). Most other partitions are read-only during normal operation. So
> I can safely keep testing this kernel. Just mentioning this, in case
> you see this happening with other ppl testing this patch as well.

If you have a failing resume from hibernation a filesystem is perfectly
possible, unfortunately.

The patch itself should't really cause any corruption to happen.

Thanks,
Rafael


> 2013/9/30 Rafael J. Wysocki <rjw@rjwysocki.net>:
> > On Monday, September 30, 2013 07:45:54 AM Ronald wrote:
> >> Yes, works as well. Just survived twe cycles with s2disk. I'm
> >> surprised someone else did not report this earlier btw... Because it
> >> looks pretty generic (i.e. not specific to a 64bit UP system).
> >
> > It is a generic bug, actually.  Well, this means the user space driven
> > hibernation doesn't receive much testing coverage these days ...
> >
> > I'll resend the patch with a proper changelog and then push it for v3.12-rc4.
> >
> > Thanks,
> > Rafael
> >
> >
> >> 2013/9/30 Rafael J. Wysocki <rjw@rjwysocki.net>:
> >> > On Sunday, September 29, 2013 09:22:45 AM Ronald wrote:
> >> >> Attached patch fixes the issue. Both methods function as they did
> >> >> before. Thanks for the superfast fix!
> >> >
> >> > You're welcome, it's not the final one, however.
> >> >
> >> > Can you please test the one below and report back?
> >> >
> >> > Rafael
> >> >
> >> >
> >> > ---
> >> >  kernel/power/snapshot.c |    5 ++++-
> >> >  kernel/power/user.c     |    8 ++++++++
> >> >  2 files changed, 12 insertions(+), 1 deletion(-)
> >> >
> >> > Index: linux-pm/kernel/power/snapshot.c
> >> > ===================================================================
> >> > --- linux-pm.orig/kernel/power/snapshot.c
> >> > +++ linux-pm/kernel/power/snapshot.c
> >> > @@ -743,7 +743,10 @@ int create_basic_memory_bitmaps(void)
> >> >         struct memory_bitmap *bm1, *bm2;
> >> >         int error = 0;
> >> >
> >> > -       BUG_ON(forbidden_pages_map || free_pages_map);
> >> > +       if (forbidden_pages_map && free_pages_map)
> >> > +               return 0;
> >> > +       else
> >> > +               BUG_ON(forbidden_pages_map || free_pages_map);
> >> >
> >> >         bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
> >> >         if (!bm1)
> >> > Index: linux-pm/kernel/power/user.c
> >> > ===================================================================
> >> > --- linux-pm.orig/kernel/power/user.c
> >> > +++ linux-pm/kernel/power/user.c
> >> > @@ -39,6 +39,7 @@ static struct snapshot_data {
> >> >         char frozen;
> >> >         char ready;
> >> >         char platform_support;
> >> > +       bool free_bitmaps;
> >> >  } snapshot_state;
> >> >
> >> >  atomic_t snapshot_device_available = ATOMIC_INIT(1);
> >> > @@ -82,6 +83,10 @@ static int snapshot_open(struct inode *i
> >> >                 data->swap = -1;
> >> >                 data->mode = O_WRONLY;
> >> >                 error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
> >> > +               if (!error) {
> >> > +                       error = create_basic_memory_bitmaps();
> >> > +                       data->free_bitmaps = !error;
> >> > +               }
> >> >                 if (error)
> >> >                         pm_notifier_call_chain(PM_POST_RESTORE);
> >> >         }
> >> > @@ -111,6 +116,8 @@ static int snapshot_release(struct inode
> >> >                 pm_restore_gfp_mask();
> >> >                 free_basic_memory_bitmaps();
> >> >                 thaw_processes();
> >> > +       } else if (data->free_bitmaps) {
> >> > +               free_basic_memory_bitmaps();
> >> >         }
> >> >         pm_notifier_call_chain(data->mode == O_RDONLY ?
> >> >                         PM_POST_HIBERNATION : PM_POST_RESTORE);
> >> > @@ -231,6 +238,7 @@ static long snapshot_ioctl(struct file *
> >> >                         break;
> >> >                 pm_restore_gfp_mask();
> >> >                 free_basic_memory_bitmaps();
> >> > +               data->free_bitmaps = false;
> >> >                 thaw_processes();
> >> >                 data->frozen = 0;
> >> >                 break;
> >> >
> > --
> > I speak only for myself.
> > Rafael J. Wysocki, Intel Open Source Technology Center.
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
