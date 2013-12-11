Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3LKThi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:37:38 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50526 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3LKThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:37:34 -0500
Message-ID: <52A8BEFA.8000005@linaro.org>
Date: Wed, 11 Dec 2013 11:37:30 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perf: POSIX CLOCK_PERF to report current time value
References: <1386707259-21725-1-git-send-email-dsahern@gmail.com> <52A77D3A.8080407@linaro.org> <20131211120750.GD25541@gmail.com>
In-Reply-To: <20131211120750.GD25541@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 04:07 AM, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
>
>> [...]
>>
>> I'd much rather see perf export CLOCK_MONOTONIC_RAW timestamps, 
>> since that clockid is well defined. [...]
> So the problem with that clock is that it does the following for every 
> timestamp:
>
>         cycle_now = clock->read(clock);
>
> ... which is impossibly slow if something like the HPET is used, which 
> is rather common - so this is a non-starter to timestamp perf events 
> with. We use the scheduler clock as a reasonable compromise between 
> scalability and clock globality.
>
> I can see two solutions:
>
> 1)
>
> One approach is what I described in my other reply a few minutes ago: 
> track the flow of GTOD, timestamped with the fast perf timestamps, so 
> that GTOD can be correlated to the perf clock, if user-space so 
> wishes. The correlation is simple so this gets close to the ease of 
> use of being able to timestamp GTOD directly.
>
> (That would be useful for other purposes as well, such as 
> instrumenting GTOD updates.)
>
> 2)
>
> An alternate, rather interesting approach would be to change the 
> scheduler clock offset to be influenced by the above events, so that 
> it quasi-approximates GTOD and emits natural time of day timestamps.
>
> This already happens partially in the sched-clock slow path, 
> kernel/sched/clock.c's sched_clock_local(), it uses scd->tick_gtod 
> timestamps to correlate to the monotonic clock. This could be changed 
> over to use not get_ktime() but getnstimeofday(), to get true TOD 
> timestamps.
>
> The trickier bit is the x86 fast-path, in arch/x86/kernel/tsc.c's 
> native_sched_clock(). That relies on __cycles_2_ns() to transform a 
> CPU cycles timestamp into (boot time offset) nanoseconds. For that it 
> uses the cyc2ns_offset percpu variable. That variable could be updated 
> periodically so that it's TOD offset.
>
> My (strong!) preference would be #2, for the simple reason that it 
> would make perf timestamps instantly usable and tooling wouldn't have 
> to do anything to get true timestamps.

Right. #2 is basically what I was (probably poorly) trying to describe
as my ideal solution, making perf export what is essentially
CLOCK_MONOTONIC_RAW time (using CLOCK_MONOTONIC_RAW is more likely to be
easier to match then CLOCK_REALTIME/getnstimeofday(), since you don't
have to deal with anyone setting the clock, or frequency adjustments
from NTP).

thanks
-john

