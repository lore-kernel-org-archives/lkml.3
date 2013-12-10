Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab3LJUos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:44:48 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39460 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3LJUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:44:46 -0500
Message-ID: <52A77D3A.8080407@linaro.org>
Date: Tue, 10 Dec 2013 12:44:42 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
CC: Pawel Moll <pawel.moll@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perf: POSIX CLOCK_PERF to report current time value
References: <1386707259-21725-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1386707259-21725-1-git-send-email-dsahern@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 12:27 PM, David Ahern wrote:
> From: Pawel Moll <pawel.moll@arm.com>
>
> To co-relate user space events with the perf events stream
> a current (as in: "what time(stamp) is it now?") time value
> must be made available.
>
> This patch adds a POSIX clock returning the perf_clock()
> value and accesible from userspace:
>
>     #include <time.h>
>
>     struct timespec ts;
>
>     clock_gettime(CLOCK_PERF, &ts);

As stated earlier on a few occasions, I really don't like exposing the
perf clock directly to userland like this, because the perf clock is not
a well defined time domain. Instead its basically defined as "whatever
sched_clock does". Over the last few years, the behavior of sched_clock
has changed, so I'm not confident it won't change in the future.

I do understand the desire, but to export a poorly defined clockid to
userland has ABI stability concerns for me.  Particularly when the
performance characteristics will make it prone to abuse.

I'd much rather see perf export CLOCK_MONOTONIC_RAW timestamps, since
that clockid is well defined. Even if the underlying clocksource is
different, I suspect the perf clock could interpolate fairly closely to
CLOCK_MONOTONIC_RAW, as it already does similar interpolation on top of
CLOCK_MONOTONIC in some cases.

Other then this, I've said I'd not object other approaches, such as the
ioctl method or the dynamic clockid. These solutions also have the same
ABI stability concern, but the responsibility for that can be kept
outside the timekeeping code, so the perf folks can handle the potential
ABI stability downside. Additionally the few extra steps required to get
to the time stamping method make it less likely to be abused.

Again, I really do understand the need, and I don't mean to be a pain
here, but as a maintainer I have to push back here.

thanks
-john

