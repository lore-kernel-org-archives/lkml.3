Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3CaNLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 09:11:31 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:64465 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab3CaNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 09:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3Oq6RMWy=+JtPEt7Kpm83wdyyQfzfKSB2+ji2Mforoaar_8g@mail.gmail.com>
References: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com>
	<5155DE43.4000601@codeaurora.org>
	<CAH3Oq6QA0DCEDc-Yh+k=3bgUH7xzKxHSC1aWSoL4NzaYCZZHbg@mail.gmail.com>
	<20130330100408.GA17995@n2100.arm.linux.org.uk>
	<CAH3Oq6RMWy=+JtPEt7Kpm83wdyyQfzfKSB2+ji2Mforoaar_8g@mail.gmail.com>
Date: Sun, 31 Mar 2013 21:11:25 +0800
Message-ID: <CAH3Oq6T=xjEPnfdG2mP121ifwRAsZpopMKbW8CAi3pHDBZNX5w@mail.gmail.com>
Subject: Re: [PATCH] ARM: timer: Shutdown clock event device when stopping
 local timer
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, kgene.kim@samsung.com,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        john.stultz@linaro.org, tglx@linutronix.de, linus.walleij@linaro.org,
        shawn.guo@linaro.org, rob.herring@calxeda.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/30 Ning Jiang <ning.n.jiang@gmail.com>:
> 2013/3/30 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>> On Sat, Mar 30, 2013 at 05:57:38PM +0800, Ning Jiang wrote:
>>> 2013/3/30 Stephen Boyd <sboyd@codeaurora.org>:
>>> > On 03/29/13 02:24, ning.n.jiang@gmail.com wrote:
>>> >> From: Ning Jiang <ning.n.jiang@gmail.com>
>>> >>
>>> >> Currently there are two problems when we try to stop local timer.
>>> >> First, it calls set_mode function directly so mode state is not
>>> >> updated for the clock event device. Second, it makes the device
>>> >> unused instead of shutdown.
>>> >
>>> > What device is this a problem on? I believe this only matters to drivers
>>> > which enable their timer in their set_next_event() callback? But even
>>> > then, does anything actually happen because the interrupt should have
>>> > been disabled in the local timer stop callback.
>>> >
>>>
>>> Right. Drivers which enable timer in set_next_event() will have this problem.
>>> It will not have functional problem in my case. But my device cannot enter
>>> low power mode with a pending interrupt even if it is disabled.
>>
>> You're not telling us what you have discovered.  How does set_next_event()
>> get called after we've set the mode to UNUSED in the current code?
>
> In the current code we did not set the mode to UNUSED but only call
> set_mode callback function for the clock event device. This normally
> disables current clock event device. The dying CPU eventually will
> switch to idle thread, call tick_nohz_idle_enter(), try to cancel the
> sched_timer and reprogram the next event. Then set_next_event() gets
> called. The call stack will be like:
>
> tick_nohz_idle_enter
>   -> __tick_nohz_idle_enter
>     -> tick_nohz_stop_sched_tick
>       -> hrtimer_cancel
>         -> hrtimer_try_to_cancel
>           -> remove_hrtimer
>             -> __remove_hrtimer
>               -> hrtimer_force_reprogram
>                 -> tick_program_event
>                   -> clockevents_program_event
>                     -> set_next_event
>
> In set_next_event() we'll re-enable and re-program the clock event device.

I think there are two problems here:
1. We should use clockevents_set_mode() instead of calling set_mode
callback directly. This is the issue my patch was trying to fix.
2. We shouldn't program a clock event device for a dying CPU anyway. I
can submit another patch if agreed.
