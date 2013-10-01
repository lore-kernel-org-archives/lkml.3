Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3JAQiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:38:08 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45314 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3JAQiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <7570724.v5QLmkRO38@vostro.rjw.lan>
References: <CAF1_xX2=BYkEn3ycM4smREqk-ioGbvu8Ea4or22U-jBdKmDKGA@mail.gmail.com>
	<18917329.YEy4ieURCA@vostro.rjw.lan>
	<CAF1_xX1DO1V-cZyDWsDyrbCfG7uWnPeKP5w0H7Bz=oSpRMXTvQ@mail.gmail.com>
	<7570724.v5QLmkRO38@vostro.rjw.lan>
Date: Tue, 1 Oct 2013 18:38:03 +0200
Message-ID: <CAF1_xX0veXd4AtPR43r50g8Tu4WeP0kVzqPihgSC-NCpW+nwkQ@mail.gmail.com>
Subject: Re: Fwd: [v3.12-rc1] [regression] PM / hibernate: Create memory
 bitmaps after freezing user space
From: Ronald <ronald645@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This could be a coincidence, but I had a disk data corruption in /var
(LVM). Most other partitions are read-only during normal operation. So
I can safely keep testing this kernel. Just mentioning this, in case
you see this happening with other ppl testing this patch as well.

2013/9/30 Rafael J. Wysocki <rjw@rjwysocki.net>:
> On Monday, September 30, 2013 07:45:54 AM Ronald wrote:
>> Yes, works as well. Just survived twe cycles with s2disk. I'm
>> surprised someone else did not report this earlier btw... Because it
>> looks pretty generic (i.e. not specific to a 64bit UP system).
>
> It is a generic bug, actually.  Well, this means the user space driven
> hibernation doesn't receive much testing coverage these days ...
>
> I'll resend the patch with a proper changelog and then push it for v3.12-rc4.
>
> Thanks,
> Rafael
>
>
>> 2013/9/30 Rafael J. Wysocki <rjw@rjwysocki.net>:
>> > On Sunday, September 29, 2013 09:22:45 AM Ronald wrote:
>> >> Attached patch fixes the issue. Both methods function as they did
>> >> before. Thanks for the superfast fix!
>> >
>> > You're welcome, it's not the final one, however.
>> >
>> > Can you please test the one below and report back?
>> >
>> > Rafael
>> >
>> >
>> > ---
>> >  kernel/power/snapshot.c |    5 ++++-
>> >  kernel/power/user.c     |    8 ++++++++
>> >  2 files changed, 12 insertions(+), 1 deletion(-)
>> >
>> > Index: linux-pm/kernel/power/snapshot.c
>> > ===================================================================
>> > --- linux-pm.orig/kernel/power/snapshot.c
>> > +++ linux-pm/kernel/power/snapshot.c
>> > @@ -743,7 +743,10 @@ int create_basic_memory_bitmaps(void)
>> >         struct memory_bitmap *bm1, *bm2;
>> >         int error = 0;
>> >
>> > -       BUG_ON(forbidden_pages_map || free_pages_map);
>> > +       if (forbidden_pages_map && free_pages_map)
>> > +               return 0;
>> > +       else
>> > +               BUG_ON(forbidden_pages_map || free_pages_map);
>> >
>> >         bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
>> >         if (!bm1)
>> > Index: linux-pm/kernel/power/user.c
>> > ===================================================================
>> > --- linux-pm.orig/kernel/power/user.c
>> > +++ linux-pm/kernel/power/user.c
>> > @@ -39,6 +39,7 @@ static struct snapshot_data {
>> >         char frozen;
>> >         char ready;
>> >         char platform_support;
>> > +       bool free_bitmaps;
>> >  } snapshot_state;
>> >
>> >  atomic_t snapshot_device_available = ATOMIC_INIT(1);
>> > @@ -82,6 +83,10 @@ static int snapshot_open(struct inode *i
>> >                 data->swap = -1;
>> >                 data->mode = O_WRONLY;
>> >                 error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
>> > +               if (!error) {
>> > +                       error = create_basic_memory_bitmaps();
>> > +                       data->free_bitmaps = !error;
>> > +               }
>> >                 if (error)
>> >                         pm_notifier_call_chain(PM_POST_RESTORE);
>> >         }
>> > @@ -111,6 +116,8 @@ static int snapshot_release(struct inode
>> >                 pm_restore_gfp_mask();
>> >                 free_basic_memory_bitmaps();
>> >                 thaw_processes();
>> > +       } else if (data->free_bitmaps) {
>> > +               free_basic_memory_bitmaps();
>> >         }
>> >         pm_notifier_call_chain(data->mode == O_RDONLY ?
>> >                         PM_POST_HIBERNATION : PM_POST_RESTORE);
>> > @@ -231,6 +238,7 @@ static long snapshot_ioctl(struct file *
>> >                         break;
>> >                 pm_restore_gfp_mask();
>> >                 free_basic_memory_bitmaps();
>> > +               data->free_bitmaps = false;
>> >                 thaw_processes();
>> >                 data->frozen = 0;
>> >                 break;
>> >
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
