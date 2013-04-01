Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3DAB4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 21:56:53 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:61446 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3DAB4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 21:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <5158C9B8.3070208@linaro.org>
References: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com>
	<5158C9B8.3070208@linaro.org>
Date: Mon, 1 Apr 2013 09:56:50 +0800
Message-ID: <CAH3Oq6SZHjjMDLbYNrgzZazsBXW61Z8_MjCoG7nwYNOe=eerPw@mail.gmail.com>
Subject: Re: [PATCH] ARM: timer: Shutdown clock event device when stopping
 local timer
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, davidb@codeaurora.org,
        dwalker@fifo99.com, bryanh@codeaurora.org, john.stultz@linaro.org,
        tglx@linutronix.de, linus.walleij@linaro.org, shawn.guo@linaro.org,
        rob.herring@calxeda.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1 Daniel Lezcano <daniel.lezcano@linaro.org>:
> On 03/29/2013 10:24 AM, ning.n.jiang@gmail.com wrote:
>> From: Ning Jiang <ning.n.jiang@gmail.com>
>>
>> Currently there are two problems when we try to stop local timer.
>> First, it calls set_mode function directly so mode state is not
>> updated for the clock event device. Second, it makes the device
>> unused instead of shutdown.
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
>>
>> Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
>> ---
>>  arch/arm/kernel/smp_twd.c                |    2 +-
>>  arch/arm/mach-exynos/mct.c               |    2 +-
>>  arch/arm/mach-msm/timer.c                |    2 +-
>>  drivers/clocksource/arm_arch_timer.c     |    2 +-
>>  drivers/clocksource/time-armada-370-xp.c |    2 +-
>>  5 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
>> index 3f25650..c1d4ab4 100644
>> --- a/arch/arm/kernel/smp_twd.c
>> +++ b/arch/arm/kernel/smp_twd.c
>> @@ -92,7 +92,7 @@ static int twd_timer_ack(void)
>>
>>  static void twd_timer_stop(struct clock_event_device *clk)
>>  {
>> -     twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
>> +     clockevents_set_mode(clk, CLOCK_EVT_MODE_SHUTDOWN);
>>       disable_percpu_irq(clk->irq);
>
> Wouldn't be clockevents_shutdown more adequate here ? The next event
> will be also set.

You're right. clockevents_shutdown seems more appropriate here. I'll
submit a revised patch for it.

> --
>  <http://www.linaro.org/> Linaro.org  Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
