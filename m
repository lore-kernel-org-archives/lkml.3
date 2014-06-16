Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaFPRNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:13:41 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:54464 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaFPRNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <20131212141655.238445339@infradead.org>
References: <20131212140835.729222186@infradead.org>
	<20131212141655.238445339@infradead.org>
Date: Mon, 16 Jun 2014 22:43:38 +0530
X-Google-Sender-Auth: yqRqpAVgmqv5PHhzGBm0ISiC1SY
Message-ID: <CAOh2x=mgeozUMGYQubQ4GKPEB6k_TkcV3CSTzNLqjKok-gROQg@mail.gmail.com>
Subject: Re: [PATCH 11/15] x86: Rewrite cyc2ns to avoid the need to disable IRQs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        registosites@hotmail.com, srivatsa@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing Mauro/Rafael/Srivatsa..

On Thu, Dec 12, 2013 at 7:38 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Use a ring-buffer like multi-version object structure which allows
> always having a coherent object; we use this to avoid having to
> disable IRQs while reading sched_clock() and avoids a problem when
> getting an NMI while changing the cyc2ns data.
>
>                         MAINLINE   PRE        POST
>
>     sched_clock_stable: 1          1          1
>     (cold) sched_clock: 329841     331312     257223
>     (cold) local_clock: 301773     310296     309889
>     (warm) sched_clock: 38375      38247      25280
>     (warm) local_clock: 100371     102713     85268
>     (warm) rdtsc:       27340      27289      24247
>     sched_clock_stable: 0          0          0
>     (cold) sched_clock: 382634     372706     301224
>     (cold) local_clock: 396890     399275     399870
>     (warm) sched_clock: 38194      38124      25630
>     (warm) local_clock: 143452     148698     129629
>     (warm) rdtsc:       27345      27365      24307
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/include/asm/timer.h     |   23 +++
>  arch/x86/kernel/cpu/perf_event.c |   14 +-
>  arch/x86/kernel/tsc.c            |  229 ++++++++++++++++++++++++++++++++++-----
>  3 files changed, 236 insertions(+), 30 deletions(-)

Hi Peter,

We have been following a bug around cpufreq changes in 3.14
(https://bugzilla.kernel.org/show_bug.cgi?id=77201) and our tests
narrowed it down to this patch after which things aren't working
as expected.

Mauro (registosites@hotmail.com) have reported that since 3.14
after doing hot-unplug/hotplug of CPU1, cpufreq POSTCHANGE notifications
for every second frequency change hangs his machine ..

Last working tag was: 3.13.8 and it started failing from 3.14 and fails
for latest 3.15 as well..

model name : AMD Turion(tm) 64 X2 Mobile Technology TL-64
CPUFreq driver: powernow-k8 ..
CPUs: Only two CPUs, sharing clock line


We have asked him to do lots of tests as we initially though its
because of some cpufreq changes, but finally we came to the conclusion
that reverting below two commits fixes his issues over 3.14:

20d1c86 sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs
57c67da sched/clock, x86: Move some cyc2ns() code around

(some more commits were reverted as well to revert these two cleanly,
but he still had issues after those reverts and only after reverting these two
his problem got fixed)..

He couldn't do a bisect as it was broken with compilation errors ..

Can you give any pointers, so that he can get it fixed ?

Thanks.

--
Viresh
