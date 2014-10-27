Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaJ0OUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:20:32 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:48240 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaJ0OUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:20:31 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414419579.30379.49.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 27 Oct 2014 15:19:39 +0100
In-Reply-To: <CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	 <1413914978.30379.14.camel@hadess.net>
	 <CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 12:10 -0700, John Stultz wrote:
> On Tue, Oct 21, 2014 at 11:09 AM, Bastien Nocera <hadess@hadess.net> wrote:
> > On Tue, 2014-10-21 at 11:00 -0700, John Stultz wrote:
> >> I suspect wakeup type reporting is maybe not the best way to go about
> >> this, since there may be a number of causes for wakeups and they can
> >> arrive closely together in different orders, which can result in
> >> races.
> >>
> >> For instance, if the machine suspends, and sets an alarm to be woken
> >> up at midnight to do a backup, if the user resumes their laptop at
> >> 11:59:59, should the backup still proceed at midnight?
> >
> > No. And I would expect that we would get a wake up type of "power
> > button" or "lid open" in this case.
> >
> >>   What happens
> >> if the user starts to use their machine at 12:00:01?
> >
> > I would expect the backup to stop and be tried again later.
> 
> What "event" would you be using to trigger stopping the backup?
> 
> 
> >>   What about if
> >> the user walked away from their machine at 11:55:01, and the system
> >> would suspend at 12:00:01, should the backup commence at 12:00:00?
> >
> > That wouldn't happen because we'd set the wake up time when suspending.
> >
> >> Thus you probably want to have a "user present" status,
> >
> > We can do any sort of thing once the laptop is awake. But right now
> > there's no way to know whether the resume is due to a user action or
> > not.
> 
> I'm suggesting its best if you don't care which specific irq brought
> the device out of suspend mode.
> 
> You may want to monitor various events like the lid-open or
> power-button (as well as the timerfd for alarms), and use those for
> your logic, but again, because a number of different irqs might bring
> the system out of suspend and those irqs can possibly occur almost
> simultaneously, which specific one landed first and woke the system is
> really not that useful (and again prone to races).
> 
> Now, I do think knowing which IRQ did bring you out of suspend is
> useful, but mostly for power-debugging when you're trying to optimize
> battery life. But for userland logic, I think its far too prone to
> races.

I also cannot know, from user-space, whether Wake-On-LAN,
Wake-On-Wireless-LAN, or the Wi-Fi card's "network proximity" triggered
coming out of suspend for example.

I can certainly check for the status of the lid, but I wouldn't know
whether a button was pressed to turn the machine back on, as the
firmware would eat that.

To make it short, I don't have a way to know, from user-space, whether
the event that took it out of suspend was programmatic, or user action.
I would add that, even if we said that races can occur, I have no easy
way to know, from user-space, whether the last thing that occurred was
the Wi-Fi card waking the machine up or the power button being pressed.

I'm sure all that information is available inside the kernel, but the
user-space interface for it is lacking.

> >>  then use the
> >> timerfd() ALARM clockids to set any wakeups you'd like, and when they
> >> trigger (if the system was suspended or not), decide to do your backup
> >> based the conditionals you had above, using the user-present status in
> >> a similar way to how you use AC status.
> >>
> >> I'd suggest looking into some of the details on how Android does its
> >> wakelock logic, as well as the timerfd ALARM clockids, since I think
> >> this would provide what you need.
> >
> > It doesn't. There's still a whole class of hardware that isn't always on
> > as mobile SoCs are, and wakelocks aren't going to help if the kernel
> > isn't running and we don't know why it started running again.
> 
> I'm not sure I parsed this properly. Mobile SoCs are quite frequently
> in suspend and not always on. They frequently resume both due to
> wakeup alarms, modem call irqs, and as a result of user-interaction
> like button presses.
> 
> 
> >> My bigger concern here with your use case though, is that you might be
> >> able to use ALARM timers more commonly, but that for much existing
> >> hardware, corner cases like programmatic resuming of a laptop while
> >> its packed in a bag somewhere might have thermal risks.
> >
> > I'm pretty sure that Windows has done this for years before we did. If
> > the laptop cannot suspend reliably, then the user would disable it. We
> > cannot keep designing around broken software.
> 
> Sure. But its not reliably suspending I'm worried about, its
> accidentally resuming in an environment the hardware wasn't designed
> for. Its really more of a hardware design issue. I'm not suggesting
> you don't do it, but I just suspect you'll need to be careful about
> automatically enabling this on older hardware.

It could be opt-in if that's actually a problem.

