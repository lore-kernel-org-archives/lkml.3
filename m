Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3FLKXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:23:16 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52233 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752368Ab3FLKXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:23:14 -0400
Date: Wed, 12 Jun 2013 11:20:19 +0100
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
Message-ID: <20130612102019.GA6976@arm.com>
References: <20130530134718.GB32728@e103034-lin>
 <51B221AF.9070906@linux.vnet.ibm.com>
 <20130608112801.GA8120@MacBook-Pro.local>
 <1834293.MlyIaiESPL@vostro.rjw.lan>
 <51B3F99A.4000101@linux.vnet.ibm.com>
 <51B5FE02.7040607@linaro.org>
 <alpine.DEB.2.02.1306111722470.24968@nftneq.ynat.uz>
 <51B7D38A.7050204@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B7D38A.7050204@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Wed, Jun 12, 2013 at 02:48:58AM +0100, Arjan van de Ven wrote:
> On 6/11/2013 5:27 PM, David Lang wrote:
> > Nobody is saying that this sort of thing should be in the fastpath
> > of the scheduler.
> >
> > But if the scheduler has a table that tells it the possible states,
> > and the cost to get from the current state to each of these states
> > (and to get back and/or wake up to full power), then the scheduler
> > can make the decision on what to do, invoke a routine to make the
> > change (and in the meantime, not be fighting the change by trying to
> > schedule processes on a core that's about to be powered off), and
> > then when the change happens, the scheduler will have a new version
> > of the table of possible states and costs
> >
> > This isn't in the fastpath, it's in the rebalancing logic.
> 
> the reality is much more complex unfortunately.
> C and P states hang together tightly, and even C state on one core
> impacts other cores' performance, just like P state selection on one
> core impacts other cores.
> 
> (at least for x86, we should really stop talking as if the OS picks
> the "frequency", that's just not the case anymore)

I agree, the reality is very complex. But we should go back and analyse
what problem we are trying to solve, what each framework is trying to
address.

When viewed separately from the scheduler, cpufreq and cpuidle governors
do the right thing. But they both base their action on the CPU load
(balance) decided by the scheduler and it's the latter that we are
trying to adjust (and we are still debating what the right approach is).

Since such information seems too complex to be moved into the scheduler,
why don't we get cpufreq in charge of restricting the load balancing to
certain CPUs? It already tracks the load/idle time to (gradually) change
the P state. Depending on the governor/policy, it could decide that (for
example) 4 CPUs running at higher power P state are enough, telling the
scheduler to ignore the other CPUs. It won't pick a frequency, but (as
it currently does) adjust it to keep a minimal idle state on those CPUs.
If that's not longer possible (high load), it can remove the restriction
and let the scheduler use the other idle CPUs (cpufreq could even do a
direct a load_balance() call). This is a governor decision and the user
is in control of what governors are used.

Cpuidle I think for now can stay the same, gradually entering deeper
sleep states. It could be later unified with cpufreq if there are any
benefits. In deciding the load balancing restrictions, maybe cpufreq
should be aware of C-state latencies.

Cpufreq would need to get more knowledge of the power topology and
thermal management. It would still be the framework restricting the P
state or changing the load balancing restrictions to let CPUs cool down.
More hooks could be added if needed for better responsiveness (like
entering idle or task wake-up).

With the above, the scheduler will just focus on performance (given the
restrictions imposed by cpufreq) and it only needs to be aware of the
CPU topology from a performance perspective (caches, hyperthreading)
together with the cpu_power parameter for the weighted load.

-- 
Catalin
