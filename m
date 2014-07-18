Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030774AbaGRRvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:51:24 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61201 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030529AbaGRRvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:51:22 -0400
Message-ID: <53C95E97.2020805@linaro.org>
Date: Fri, 18 Jul 2014 10:51:19 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 10:43 AM, Pawel Moll wrote:
> This change is trying to make the sched clock "similar" to the
> monotonic raw one.
>
> The main goal is to provide some kind of unification between time
> flow in kernel and in user space, mainly to achieve correlation
> between perf timestamps and clock_gettime(CLOCK_MONOTONIC_RAW).
> This has been suggested by Ingo and John during the latest
> discussion (of many, we tried custom ioctl, custom clock etc.)
> about this:
>
> http://thread.gmane.org/gmane.linux.kernel/1611683/focus=1612554
>
> For now I focused on the generic sched clock implementation,
> but similar approach can be applied elsewhere.
>
> Initially I just wanted to copy epoch from monotonic to sched
> clock at update_clock(), but this can cause the sched clock
> going backwards in certain corner cases, eg. when the sched
> clock "increases faster" than the monotonic one. I believe
> it's a killer issue, but feel free to ridicule me if I worry
> too much :-)
>
> In the end I tried to employ some basic control theory technique
> to tune the multiplier used to calculate ns from cycles and
> it seems to be be working in my system, with the average error
> in the area of 2-3 clock cycles (I've got both clocks running
> at 24MHz, which gives 41ns resolution).
>
> / # cat /sys/kernel/debug/sched_clock_error
> min error: 0ns
> max error: 200548913ns
> 100 samples moving average error: 117ns
> / # cat /sys/kernel/debug/tracing/trace
> <...>
>           <idle>-0     [000] d.h3  1195.102296: sched_clock_adjust: sched=1195102288457ns, mono=1195102288411ns, error=-46ns, mult_adj=65
>           <idle>-0     [000] d.h3  1195.202290: sched_clock_adjust: sched=1195202282416ns, mono=1195202282485ns, error=69ns, mult_adj=38
>           <idle>-0     [000] d.h3  1195.302286: sched_clock_adjust: sched=1195302278832ns, mono=1195302278861ns, error=29ns, mult_adj=47
>           <idle>-0     [000] d.h3  1195.402278: sched_clock_adjust: sched=1195402271082ns, mono=1195402270872ns, error=-210ns, mult_adj=105
>           <idle>-0     [000] d.h3  1195.502278: sched_clock_adjust: sched=1195502270832ns, mono=1195502270950ns, error=118ns, mult_adj=29
>           <idle>-0     [000] d.h3  1195.602276: sched_clock_adjust: sched=1195602268707ns, mono=1195602268732ns, error=25ns, mult_adj=50
>           <idle>-0     [000] d.h3  1195.702280: sched_clock_adjust: sched=1195702272999ns, mono=1195702272997ns, error=-2ns, mult_adj=55
>           <idle>-0     [000] d.h3  1195.802276: sched_clock_adjust: sched=1195802268749ns, mono=1195802268684ns, error=-65ns, mult_adj=71
>           <idle>-0     [000] d.h3  1195.902272: sched_clock_adjust: sched=1195902265207ns, mono=1195902265223ns, error=16ns, mult_adj=53
>           <idle>-0     [000] d.h3  1196.002276: sched_clock_adjust: sched=1196002269374ns, mono=1196002269283ns, error=-91ns, mult_adj=78
> <...>
>
> This code definitely needs more work and testing (I'm not 100%
> sure if the Kp and Ki I've picked for the proportional and
> integral terms are universal), but for now wanted to see
> if this approach makes any sense whatsoever.
>
> All feedback more than appreciated!

Very cool work! I've not been able to review it carefully, but one good
stress test would be to pick a system where the hardware used for
sched_clock is different from the hardware used for timekeeping.

Probably easily done on x86 hardware that normally uses the TSC, but has
HPET/ACPI PM hardware available. After the system boots, change the
clocksource via:
/sys/devices/system/clocksource/clocksource0/current_clocksource


Although, looking again, this looks like it only works on the "generic"
sched_clock (so ARM/ARM64?)...

thanks
-john

