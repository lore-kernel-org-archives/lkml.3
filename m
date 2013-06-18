Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab3FRTGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:06:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42485 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256Ab3FRTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:06:29 -0400
Date: Tue, 18 Jun 2013 20:06:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: power-efficient scheduling design
Message-ID: <20130618190625.GA9065@MacBook-Pro.local>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <20130614160522.GG32728@e103034-lin>
 <51C07ABC.2080704@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C07ABC.2080704@linux.intel.com>
Thread-Topic: power-efficient scheduling design
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 04:20:28PM +0100, Arjan van de Ven wrote:
> On 6/14/2013 9:05 AM, Morten Rasmussen wrote:
> > Looking at the discussion it seems that people have slightly different
> > views, but most agree that the goal is an integrated scheduling,
> > frequency, and idle policy like you pointed out from the beginning.
> 
> ... except that such a solution does not really work for Intel hardware.

I think it can work (see below).

> The OS does not get to really pick the CPU "frequency" (never mind that
> frequency is not what gets controlled), the hardware picks the frequency.
> The OS can do some level of requests (best to think of this as a percentage
> more than frequency) but what you actually get is more often than not
> what you asked for.

Morten's proposal does not try to "pick" a frequency. The P-state change
is still done gradually based on the load (so we still have an adaptive
loop). The load (total or per-task) can be tracked in an arch-specific
way (using aperf/mperf on x86).

The difference from what intel_pstate.c does now is that it has a view
of the total load (across all CPUs) and the run-queue content. It can
"guide" the load balancer into favouring one or two CPUs and ignoring
the rest (using cpu_power).

If several CPUs have small aperf/mperf ratio, it can decide to use fewer
CPUs at a higher aperf/mperf by telling the load balancer not to use
them (cpu_power = 1). All of this is continuously re-adjusted to cope
with changes in the load and hardware variations like turbo boost.

Similarly, if a CPU has aperf/mperf >= 1, it keeps increasing the
P-state (depending on the policy). Once it got to the highest level,
depending on the number of threads in the run-queue (doesn't make sense
for only one), it can open up other CPUs and let the load balancer use
them.

> You can look in hindsight what kind of performance you got (from some basic
> counters in MSRs), and the scheduler can use that to account backwards to what some process
> got. But to predict what you will get in the future...... that's near impossible
> on any realistic system nowadays (and even more so in the future).

We don't need absolute figures matching load to P-states but we'll
continue with an adaptive system. What we have now is also an adaptive
system but with independent decisions taken by the load balancer and the
P-state driver. The load balancer can even get confused by the cpufreq
decisions and move tasks around unnecessarily. With Morten's proposal we
get the power scheduler to adjust the P-state while giving hints to the
load balancer at the same time (it adjusts both, it doesn't try to
re-adjust itself after the load balancer).

> Treating "frequency" (well "performance) and idle separately is also a false thing to do
> (yes I know in 3.9/3.10 we still do that for Intel hw, but we're working
> on fixing that). They are by no means separate things. One guy's idle state
> is the other guys power budget (and thus performance)!.

I agree.

-- 
Catalin
