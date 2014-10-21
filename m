Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaJUTKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:10:39 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:49146 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbaJUTKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:10:38 -0400
MIME-Version: 1.0
In-Reply-To: <1413914978.30379.14.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
	<CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	<1413914978.30379.14.camel@hadess.net>
Date: Tue, 21 Oct 2014 12:10:35 -0700
Message-ID: <CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: John Stultz <john.stultz@linaro.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:09 AM, Bastien Nocera <hadess@hadess.net> wrote:
> On Tue, 2014-10-21 at 11:00 -0700, John Stultz wrote:
>> I suspect wakeup type reporting is maybe not the best way to go about
>> this, since there may be a number of causes for wakeups and they can
>> arrive closely together in different orders, which can result in
>> races.
>>
>> For instance, if the machine suspends, and sets an alarm to be woken
>> up at midnight to do a backup, if the user resumes their laptop at
>> 11:59:59, should the backup still proceed at midnight?
>
> No. And I would expect that we would get a wake up type of "power
> button" or "lid open" in this case.
>
>>   What happens
>> if the user starts to use their machine at 12:00:01?
>
> I would expect the backup to stop and be tried again later.

What "event" would you be using to trigger stopping the backup?


>>   What about if
>> the user walked away from their machine at 11:55:01, and the system
>> would suspend at 12:00:01, should the backup commence at 12:00:00?
>
> That wouldn't happen because we'd set the wake up time when suspending.
>
>> Thus you probably want to have a "user present" status,
>
> We can do any sort of thing once the laptop is awake. But right now
> there's no way to know whether the resume is due to a user action or
> not.

I'm suggesting its best if you don't care which specific irq brought
the device out of suspend mode.

You may want to monitor various events like the lid-open or
power-button (as well as the timerfd for alarms), and use those for
your logic, but again, because a number of different irqs might bring
the system out of suspend and those irqs can possibly occur almost
simultaneously, which specific one landed first and woke the system is
really not that useful (and again prone to races).

Now, I do think knowing which IRQ did bring you out of suspend is
useful, but mostly for power-debugging when you're trying to optimize
battery life. But for userland logic, I think its far too prone to
races.


>>  then use the
>> timerfd() ALARM clockids to set any wakeups you'd like, and when they
>> trigger (if the system was suspended or not), decide to do your backup
>> based the conditionals you had above, using the user-present status in
>> a similar way to how you use AC status.
>>
>> I'd suggest looking into some of the details on how Android does its
>> wakelock logic, as well as the timerfd ALARM clockids, since I think
>> this would provide what you need.
>
> It doesn't. There's still a whole class of hardware that isn't always on
> as mobile SoCs are, and wakelocks aren't going to help if the kernel
> isn't running and we don't know why it started running again.

I'm not sure I parsed this properly. Mobile SoCs are quite frequently
in suspend and not always on. They frequently resume both due to
wakeup alarms, modem call irqs, and as a result of user-interaction
like button presses.


>> My bigger concern here with your use case though, is that you might be
>> able to use ALARM timers more commonly, but that for much existing
>> hardware, corner cases like programmatic resuming of a laptop while
>> its packed in a bag somewhere might have thermal risks.
>
> I'm pretty sure that Windows has done this for years before we did. If
> the laptop cannot suspend reliably, then the user would disable it. We
> cannot keep designing around broken software.

Sure. But its not reliably suspending I'm worried about, its
accidentally resuming in an environment the hardware wasn't designed
for. Its really more of a hardware design issue. I'm not suggesting
you don't do it, but I just suspect you'll need to be careful about
automatically enabling this on older hardware.

thanks
-john
