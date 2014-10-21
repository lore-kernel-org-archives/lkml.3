Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443AbaJUSAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:00:41 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:63403 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399AbaJUSAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <1413911644.30379.12.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
Date: Tue, 21 Oct 2014 11:00:38 -0700
Message-ID: <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: John Stultz <john.stultz@linaro.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 10:14 AM, Bastien Nocera <hadess@hadess.net> wrote:
> Hey,
>
> On Tue, 2014-10-21 at 10:04 -0700, John Stultz wrote:
>> On Tue, Oct 21, 2014 at 1:49 AM, Bastien Nocera <hadess@hadess.net> wrote:
>> > Hey,
>> >
>> > GNOME has had discussions with kernel developers in the past, and,
>> > fortunately, in some cases we were able to make headway.
>> >
>> > There are however a number of items that we still don't have solutions
>> > for, items that kernel developers might not realise we'd like to rely
>> > on, or don't know that we'd make use of if merged.
>> >
>> > I've posted this list at:
>> > https://wiki.gnome.org/BastienNocera/KernelWishlist
>> >
>> > Let me know on-list or off-list if you have any comments about those, so
>> > I can update the list.
>>
>> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
>> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
>> documentation'
>>
>> Can you expand more on the rational for the need here? Is this for UI
>> for power debugging, or something else?
>
> No, it would be used for automating backups, or implementing
> suspend->hibernation transitions. For example, right before the machine
> suspends, I would schedule it to wake up in a hour. If I get woken up by
> the rtc alarm (and not by the user through a lid open), I might:
> - check that I'm plugged into the AC, it's night, and in the vicinity of
> the server that handles my backups and so backup the system.
> - check whether the battery is low, and hibernate the machine (if it
> supports it, obviously).
>
> We cannot do that if we can't make out whether the wake-up came from a
> user action, or the alarm we set.

I suspect wakeup type reporting is maybe not the best way to go about
this, since there may be a number of causes for wakeups and they can
arrive closely together in different orders, which can result in
races.

For instance, if the machine suspends, and sets an alarm to be woken
up at midnight to do a backup, if the user resumes their laptop at
11:59:59, should the backup still proceed at midnight?  What happens
if the user starts to use their machine at 12:00:01?  What about if
the user walked away from their machine at 11:55:01, and the system
would suspend at 12:00:01, should the backup commence at 12:00:00?

Thus you probably want to have a "user present" status, then use the
timerfd() ALARM clockids to set any wakeups you'd like, and when they
trigger (if the system was suspended or not), decide to do your backup
based the conditionals you had above, using the user-present status in
a similar way to how you use AC status.

I'd suggest looking into some of the details on how Android does its
wakelock logic, as well as the timerfd ALARM clockids, since I think
this would provide what you need.

My bigger concern here with your use case though, is that you might be
able to use ALARM timers more commonly, but that for much existing
hardware, corner cases like programmatic resuming of a laptop while
its packed in a bag somewhere might have thermal risks.  For mobile
devices this is an expected design point, but for off-the-shelf
laptops with big fans and exhaust vents, I'm not sure how safe this
would be, so you may need to constrain this functionality somehow (or
look to see if a enforced low-power resume is possible).

thanks
-john
