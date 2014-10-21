Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaJUSKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:10:16 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39282 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaJUSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:10:14 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1413914978.30379.14.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 21 Oct 2014 20:09:38 +0200
In-Reply-To: <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 11:00 -0700, John Stultz wrote:
> On Tue, Oct 21, 2014 at 10:14 AM, Bastien Nocera <hadess@hadess.net> wrote:
> > Hey,
> >
> > On Tue, 2014-10-21 at 10:04 -0700, John Stultz wrote:
> >> On Tue, Oct 21, 2014 at 1:49 AM, Bastien Nocera <hadess@hadess.net> wrote:
> >> > Hey,
> >> >
> >> > GNOME has had discussions with kernel developers in the past, and,
> >> > fortunately, in some cases we were able to make headway.
> >> >
> >> > There are however a number of items that we still don't have solutions
> >> > for, items that kernel developers might not realise we'd like to rely
> >> > on, or don't know that we'd make use of if merged.
> >> >
> >> > I've posted this list at:
> >> > https://wiki.gnome.org/BastienNocera/KernelWishlist
> >> >
> >> > Let me know on-list or off-list if you have any comments about those, so
> >> > I can update the list.
> >>
> >> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
> >> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
> >> documentation'
> >>
> >> Can you expand more on the rational for the need here? Is this for UI
> >> for power debugging, or something else?
> >
> > No, it would be used for automating backups, or implementing
> > suspend->hibernation transitions. For example, right before the machine
> > suspends, I would schedule it to wake up in a hour. If I get woken up by
> > the rtc alarm (and not by the user through a lid open), I might:
> > - check that I'm plugged into the AC, it's night, and in the vicinity of
> > the server that handles my backups and so backup the system.
> > - check whether the battery is low, and hibernate the machine (if it
> > supports it, obviously).
> >
> > We cannot do that if we can't make out whether the wake-up came from a
> > user action, or the alarm we set.
> 
> I suspect wakeup type reporting is maybe not the best way to go about
> this, since there may be a number of causes for wakeups and they can
> arrive closely together in different orders, which can result in
> races.
> 
> For instance, if the machine suspends, and sets an alarm to be woken
> up at midnight to do a backup, if the user resumes their laptop at
> 11:59:59, should the backup still proceed at midnight?

No. And I would expect that we would get a wake up type of "power
button" or "lid open" in this case.

>   What happens
> if the user starts to use their machine at 12:00:01?

I would expect the backup to stop and be tried again later.

>   What about if
> the user walked away from their machine at 11:55:01, and the system
> would suspend at 12:00:01, should the backup commence at 12:00:00?

That wouldn't happen because we'd set the wake up time when suspending.

> Thus you probably want to have a "user present" status,

We can do any sort of thing once the laptop is awake. But right now
there's no way to know whether the resume is due to a user action or
not.

>  then use the
> timerfd() ALARM clockids to set any wakeups you'd like, and when they
> trigger (if the system was suspended or not), decide to do your backup
> based the conditionals you had above, using the user-present status in
> a similar way to how you use AC status.
> 
> I'd suggest looking into some of the details on how Android does its
> wakelock logic, as well as the timerfd ALARM clockids, since I think
> this would provide what you need.

It doesn't. There's still a whole class of hardware that isn't always on
as mobile SoCs are, and wakelocks aren't going to help if the kernel
isn't running and we don't know why it started running again.

> My bigger concern here with your use case though, is that you might be
> able to use ALARM timers more commonly, but that for much existing
> hardware, corner cases like programmatic resuming of a laptop while
> its packed in a bag somewhere might have thermal risks.

I'm pretty sure that Windows has done this for years before we did. If
the laptop cannot suspend reliably, then the user would disable it. We
cannot keep designing around broken software.

>   For mobile
> devices this is an expected design point, but for off-the-shelf
> laptops with big fans and exhaust vents, I'm not sure how safe this
> would be, so you may need to constrain this functionality somehow (or
> look to see if a enforced low-power resume is possible).

I think that we won't know whether it's a problem until the point that
somebody actually implements it.

