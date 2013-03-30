Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3C3J5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 05:57:41 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57555 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3C3J5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 05:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <5155DE43.4000601@codeaurora.org>
References: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com>
	<5155DE43.4000601@codeaurora.org>
Date: Sat, 30 Mar 2013 17:57:38 +0800
Message-ID: <CAH3Oq6QA0DCEDc-Yh+k=3bgUH7xzKxHSC1aWSoL4NzaYCZZHbg@mail.gmail.com>
Subject: Re: [PATCH] ARM: timer: Shutdown clock event device when stopping
 local timer
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, davidb@codeaurora.org,
        dwalker@fifo99.com, bryanh@codeaurora.org, john.stultz@linaro.org,
        tglx@linutronix.de, linus.walleij@linaro.org, shawn.guo@linaro.org,
        rob.herring@calxeda.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/30 Stephen Boyd <sboyd@codeaurora.org>:
> On 03/29/13 02:24, ning.n.jiang@gmail.com wrote:
>> From: Ning Jiang <ning.n.jiang@gmail.com>
>>
>> Currently there are two problems when we try to stop local timer.
>> First, it calls set_mode function directly so mode state is not
>> updated for the clock event device. Second, it makes the device
>> unused instead of shutdown.
>
> What device is this a problem on? I believe this only matters to drivers
> which enable their timer in their set_next_event() callback? But even
> then, does anything actually happen because the interrupt should have
> been disabled in the local timer stop callback.
>

Right. Drivers which enable timer in set_next_event() will have this problem.
It will not have functional problem in my case. But my device cannot enter
low power mode with a pending interrupt even if it is disabled.

>>
>> A subtle error will happen because of it. When a cpu is plugged out
>> it will stop the local timer. It will call tick_nohz_idle_enter()
>> in idle thread afterwards. It will cancel the sched timer and try
>> to reprogram the next event. This is wrong since the local timer
>> is supposed to be stopped.
>>
>> The right way to stop the local timer is to shutdown it by calling
>> clockevents_set_mode(). Thus when we try to reprogram the clock
>> event device, it will return directly without doing anything since
>> the clock mode is CLOCK_EVT_MODE_SHUTDOWN.
>
> While this prevents the set_next_event() callback from being called on a
> dying CPU, wouldn't it be better to fix this problem in the core code
> once instead of fixing it many times in each local timer driver? It
> doesn't seem to make much sense to program an event on a CPU that is
> about to die, so why do we do that?
>

Actually, I was trying to fix it in the core code like this, but I
thought it is not
that good and we still need to fix the local timer driver problem even
with this fix.

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index c6d6400..e22e268 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -210,6 +210,9 @@ int clockevents_program_event(struct
clock_event_device *dev, ktime_t expires,
                return -ETIME;
        }

+       if (cpu_is_offline(smp_processor_id()))
+               return 0;
+
        dev->next_event = expires;

        if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)

> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
>
