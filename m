Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab3LKMIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:08:00 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:61797 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3LKMH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:07:58 -0500
Date: Wed, 11 Dec 2013 13:07:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20131211120750.GD25541@gmail.com>
References: <1386707259-21725-1-git-send-email-dsahern@gmail.com>
 <52A77D3A.8080407@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A77D3A.8080407@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> [...]
> 
> I'd much rather see perf export CLOCK_MONOTONIC_RAW timestamps, 
> since that clockid is well defined. [...]

So the problem with that clock is that it does the following for every 
timestamp:

        cycle_now = clock->read(clock);

... which is impossibly slow if something like the HPET is used, which 
is rather common - so this is a non-starter to timestamp perf events 
with. We use the scheduler clock as a reasonable compromise between 
scalability and clock globality.

I can see two solutions:

1)

One approach is what I described in my other reply a few minutes ago: 
track the flow of GTOD, timestamped with the fast perf timestamps, so 
that GTOD can be correlated to the perf clock, if user-space so 
wishes. The correlation is simple so this gets close to the ease of 
use of being able to timestamp GTOD directly.

(That would be useful for other purposes as well, such as 
instrumenting GTOD updates.)

2)

An alternate, rather interesting approach would be to change the 
scheduler clock offset to be influenced by the above events, so that 
it quasi-approximates GTOD and emits natural time of day timestamps.

This already happens partially in the sched-clock slow path, 
kernel/sched/clock.c's sched_clock_local(), it uses scd->tick_gtod 
timestamps to correlate to the monotonic clock. This could be changed 
over to use not get_ktime() but getnstimeofday(), to get true TOD 
timestamps.

The trickier bit is the x86 fast-path, in arch/x86/kernel/tsc.c's 
native_sched_clock(). That relies on __cycles_2_ns() to transform a 
CPU cycles timestamp into (boot time offset) nanoseconds. For that it 
uses the cyc2ns_offset percpu variable. That variable could be updated 
periodically so that it's TOD offset.

My (strong!) preference would be #2, for the simple reason that it 
would make perf timestamps instantly usable and tooling wouldn't have 
to do anything to get true timestamps. We could add a new 
PERF_SAMPLE_TIME_OF_DAY feature bit so that user-space can consciously 
request GTOD timestamps. This feature bit could even be arch 
influenced, so that architectures could convert their perf clocks at 
the pace they desire - which tooling can detect and handle safely.

Thoughts?

Thanks,

	Ingo
