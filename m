Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3FNGS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:18:57 -0400
Received: from relmlor3.renesas.com ([210.160.252.173]:59743 "EHLO
	relmlor3.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3FNGSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:18:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,863,1363100400";   d="scan'208";a="130724963"
Message-id: <51BAB5CD.2050608@renesas.com>
Date: Fri, 14 Jun 2013 15:18:53 +0900
From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509
 Thunderbird/17.0.6
MIME-version: 1.0
To: prarit@redhat.com
Cc: john.stultz@linaro.org, hiroyuki.yokoyama.vx@renesas.com,
        takashi.yoshii.zj@renesas.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: hrtimer: one more expiry time overflow check in hrtimer_interrupt
References: <51B6D4C4.9080400@renesas.com> <51B867C5.2050007@redhat.com>
In-reply-to: <51B867C5.2050007@redhat.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 6/12/2013 9:21 PM, Prarit Bhargava wrote:
> On 06/11/2013 03:41 AM, Shinya Kuribayashi wrote:
>>   [   27.857330] hrtimer: interrupt took 0 ns
> 
> ^^^ see below ...

This may be because the frequency of our tick timer source in this
system is very slow, it's 32768 Hz.  I think it's not suitable for
the high resolution timer at all, but we had no choice...

And with this patch applied,

> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index cdd5607..bc37552 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1371,6 +1371,8 @@ retry:
>  	tick_program_event(expires_next, 1);
>  	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
>  		    ktime_to_ns(delta));
> +	printk_once(KERN_WARNING "# now=%lld entry_time=%lld\n", ktime_to_ns(now), ktime_to_ns(entry_time));
> +	printk_once(KERN_WARNING "# expires_next=%lld\n", ktime_to_ns(expires_next));
>  }
>  
>  /*

I've got this:

[   22.857849] hrtimer: interrupt took 0 ns
[   22.861755] # now=-4294967273343634023 entry_time=-4294967273343634023
[   22.868286] # expires_next=-4294967273343634023

now == entry_time == expires_next, and delta == 0.

This means:
1) there haven't been no tick interrupts between 'entry_time' and 'now',
2) delta can be zero,
3) expires_next = ktime_add(now, delta) doesn't move expires_next forward.

Ok, it's simply hrtimer is not supposed to work with such a slow timer
source.  However, this issue happens on other shmobile ARM systems with
more faster tick timer source (10--13MHz), see below.

>> @@ -1368,6 +1370,8 @@ retry:
>>  		expires_next = ktime_add_ns(now, 100 * NSEC_PER_MSEC);
>>  	else
>>  		expires_next = ktime_add(now, delta);
>> +	if (expires_next.tv64 < 0)
>> +		expires_next.tv64 = KTIME_MAX;
> 
> Even with this change you will still see the warning below if delta = 0.

Correct.

>>  	tick_program_event(expires_next, 1);
>>  	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
>>  		    ktime_to_ns(delta));
> 
> So I'm not sure that this is the correct thing to do.
> 
> Is this reproducible on any ARM system?  I'll grab an x86_64 box and give it a
> shot there too.  Can you dump the values of now, delta, and expires_next when
> the printk_once triggers?

It's 100% reproducible in our shmobile ARM kernels, v3.4 and v3.10-rc2.
And it doesn't reproduce with v2.6.35-based kernels so far.

Here're logs from Cortex-A15 UP/SMP systems.  They're having ARM
architected tiemrs (the Generic Timers, running at 10--13MHz) using as
clocksource, clockevents, sched_clock, and read_current_timer (udelay)
sources.

-----------------------------------------------------------------------------
machine: R-Mobile APE6 (Cortex-A15 UP system - it's octo-core A15/A7 SoC, but not yet available in mainline)
kernel : v3.10-rc2 mainline
timer  : the Generic Timers (arch/arm/kernel/arch_timer.c) running at 13MHz
-----------------------------------------------------------------------------
|# uname -a
|Linux arm 3.10.0-rc2-00966-gd658f9e #1284 Tue Jun 11 13:36:10 JST 2013 armv7l GNU/Linux
|# cat /proc/timer_list |egrep "Clock Event Device|event_handler"
|Clock Event Device: arch_sys_timer
| event_handler:  hrtimer_interrupt
|# date -s "2038-1-19 3:14:00"
|Tue Jan 19 03:14:00 UTC 2038
|# [  138.942325] ------------[ cut here ]------------
|[  138.946910] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x130/0x148()
|[  138.955315] Modules linked in:
|[  138.958339] CPU: 0 PID: 0 Comm: swapper Tainted: G        W    3.10.0-rc2-00966-gd658f9e #1284
|[...]
|[  139.131970] ---[ end trace f879bec39a6bf85c ]---
|[  139.136521] hrtimer: interrupt took 2385 ns

-----------------------------------------------------------------------------
machine: R-Car H2 (quad-core Cortex-A15 SMP system)
kernel : v3.4-based custom Android kernel
timer  : the Generic Timers (arch/arm/kernel/arch_timer.c) running at 10MHz
-----------------------------------------------------------------------------
|root@renesas:~# date -s "2038-1-19 3:14:00"
|Tue Jan 19 03:14:00 GMT 2038
|root@renesas:~# [   26.458377] ------------[ cut here ]------------
|[   26.472214] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x3c/0x138()
|[...]
|[   26.980342] ---[ end trace 5218f4fd6603f493 ]---
|[   26.994166] hrtimer: interrupt took 1900 ns
|[   27.006687] # now=-4294967269549995552 entry_time=-4294967269549997452
|[   27.026240] # expires_next=-4294967269549993652

I also gave a try on my Ubuntu box, but it seems to work without
printk_once() at the bottome of hrtimer_interrupt() printed, which means
that hrtimer_update_base()-and-retries mechanism works as expected.

$ uname -a
Linux RI106878 3.2.0-45-generic #70-Ubuntu SMP Wed May 29 20:12:06 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

I'd like to see whether this happens on other ARM machines excpet for
shmobile.  Could someone help, please?
--
Shinya Kuribayashi
Renesas Electronics
