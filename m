Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3FLRHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:07:01 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:48408 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755021Ab3FLRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:06:59 -0400
Date: Wed, 12 Jun 2013 18:04:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Lang <david@lang.hm>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ingo Molnar <mingo@kernel.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: power-efficient scheduling design
Message-ID: <20130612170447.GF31646@arm.com>
References: <20130530134718.GB32728@e103034-lin>
 <51B221AF.9070906@linux.vnet.ibm.com>
 <20130608112801.GA8120@MacBook-Pro.local>
 <1834293.MlyIaiESPL@vostro.rjw.lan>
 <51B3F99A.4000101@linux.vnet.ibm.com>
 <51B5FE02.7040607@linaro.org>
 <alpine.DEB.2.02.1306111722470.24968@nftneq.ynat.uz>
 <51B7D38A.7050204@linux.intel.com>
 <20130612102019.GA6976@arm.com>
 <51B892C4.6090800@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B892C4.6090800@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:24:52PM +0100, Arjan van de Ven wrote:
> >>> This isn't in the fastpath, it's in the rebalancing logic.
> >>
> >> the reality is much more complex unfortunately.
> >> C and P states hang together tightly, and even C state on one core
> >> impacts other cores' performance, just like P state selection on one
> >> core impacts other cores.
> >>
> >> (at least for x86, we should really stop talking as if the OS picks
> >> the "frequency", that's just not the case anymore)
> >
> > I agree, the reality is very complex. But we should go back and analyse
> > what problem we are trying to solve, what each framework is trying to
> > address.
> >
> > When viewed separately from the scheduler, cpufreq and cpuidle governors
> > do the right thing. But they both base their action on the CPU load
> > (balance) decided by the scheduler and it's the latter that we are
> > trying to adjust (and we are still debating what the right approach is).
> >
> > Since such information seems too complex to be moved into the scheduler,
> > why don't we get cpufreq in charge of restricting the load balancing to
> > certain CPUs? It already tracks the load/idle time to (gradually) change
> > the P state. Depending on the governor/policy, it could decide that (for
> 
> (btw in case you missed it, for Intel HW we no longer use cpufreq anymore)

Do you mean the intel_pstate.c code? It indeed doesn't use much of
cpufreq, just setpolicy and it's on its own afterwards. Separating this
from the framework probably has real benefits for the Intel processors
but it would make a unified scheduler/cpufreq/cpuidle solution harder
(just a remark, I don't say it's good or bad, there are many
opinions against the unified solution; ARM could do the same for
configurations like big.LITTLE).

But such driver could still interact with the scheduler to control it's
load balancing. At a quick look (I'm not familiar with this driver), it
tracks the per-CPU load and increases or decreases the P-state (similar
to a cpufreq governor). It could as well track the total load and
(depending on hardware configuration), get some CPUs in lower
performance P-state (or even C-state) and tell the scheduler to avoid
them.

One way to control load-balancing ratio is via something like
arch_scale_freq_power(). We could tweak the scheduler further so that
something like cpu_power==0 means do not schedule anything there.

So my proposal is to move the load-balancing hints (load ratio, avoiding
CPUs etc.) outside the scheduler into drivers like intel_pstate.c or
cpufreq governors. We then focus on getting the best performance out of
the scheduler (like quicker migration) but it would not be concerned
with the power consumption.

> I do agree the scheduler needs to get integrated a bit better, in that it
> has some better knowledge, and to be honest, we likely need to switch from
> giving tasks credit for "time consumed" to giving them credit for something like
> "cycles consumed" or "instructions executed" or a mix thereof.
> So that a task that runs on a slower CPU (for either policy choice reasons or
> due to hardware capabilities), it gets charged less than when it runs fast.

I agree, this would be useful in optimising the scheduler so that it
makes the right task placement/migration decisions (but as I said above,
make the power aspect transparent to the scheduler).

-- 
Catalin
