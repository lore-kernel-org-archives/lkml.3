Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3DACFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 22:05:08 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:56471 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab3DACFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 22:05:05 -0400
MIME-Version: 1.0
In-Reply-To: <5158CF79.2060702@linaro.org>
References: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com>
	<5158CF79.2060702@linaro.org>
Date: Mon, 1 Apr 2013 10:05:03 +0800
Message-ID: <CAH3Oq6ThE1RevjWsiWvApi9Z2vvcA9A8utX6LjEWcm=uMPx2jw@mail.gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
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
>
>
> Don't you see a kernel BUG with this patch ?
>
> In the clockevents code, there is:
>
> /**
>  * clockevents_notify - notification about relevant events
>  */
> void clockevents_notify(unsigned long reason, void *arg)
> {
>         ...
>         case CLOCK_EVT_NOTIFY_CPU_DEAD:
>         ...
>                 cpu = *((int *)arg);
>                 list_for_each_entry_safe(dev, tmp, &clockevent_devices,
>                                         list) {
>                        if (cpumask_test_cpu(cpu, dev->cpumask) &&
>                             cpumask_weight(dev->cpumask) == 1 &&
>                             !tick_is_broadcast_device(dev)) {
>                                 BUG_ON(dev->mode !=
>                                         CLOCK_EVT_MODE_UNUSED);
>
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>                                 list_del(&dev->list);
>                         }
>                 }
>                 break;
>         ...
> }
>
> This is called triggered from hrtimer_cpu_notify with the CPU_DEAD event.
>

The clockevents_do_notify() in clockevents_notify() will call
tick_notify() which will call tick_shutdown() in turn. tick_shutdown()
will set clock event device mode to UNUSED. So no panic afterwards.

void clockevents_notify(unsigned long reason, void *arg)
{
        ...
        clockevents_do_notify(reason, arg);

        switch (reason) {
        case CLOCK_EVT_NOTIFY_CPU_DEAD:
                ...
                list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
                        if (cpumask_test_cpu(cpu, dev->cpumask) &&
                            cpumask_weight(dev->cpumask) == 1 &&
                            !tick_is_broadcast_device(dev)) {
                                BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
                                list_del(&dev->list);
                        }
                }
                ....
        }
        raw_spin_unlock_irqrestore(&clockevents_lock, flags);
}
