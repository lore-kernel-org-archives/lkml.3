Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3KLRlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:41:55 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51644 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756456Ab3KLRlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:41:49 -0500
Date: Tue, 12 Nov 2013 17:40:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "l.majewski@samsung.com" <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
Message-ID: <20131112174028.GC30177@arm.com>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
 <20131111163630.GD26898@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111163630.GD26898@twins.programming.kicks-ass.net>
Thread-Topic: [RFC][PATCH v5 00/14] sched: packing tasks
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:36:30PM +0000, Peter Zijlstra wrote:
> On Mon, Nov 11, 2013 at 11:33:45AM +0000, Catalin Marinas wrote:
> 
> tl;dr :-) Still trying to wrap my head around how to do that weird
> topology Vincent raised..

Long email, I know, but topology discussion is a good start ;).

To summarise the rest, I don't see full task packing as useful but
rather getting packing as a result of other decisions (like trying to
estimate the cost of task placement and refining the algorithm from
there). There are ARM SoCs where maximising idle time does not always
mean maximising the energy saving even if the cores can be power-gated
individually (unless you have small workload that doesn't increase the
P-state on the packing CPU).

> > Question for Peter/Ingo: do you want the scheduler to decide on which
> > C-state a CPU should be in or we still leave this to a cpuidle
> > layer/driver?
> 
> I think the can leave most of that in a driver; right along with how to
> prod the hardware to actually get into that state.
> 
> I think the most important parts are what is now 'generic' code; stuff
> that guestimates the idle-time and so forth.
> 
> I think the scheduler simply wants to say: we expect to go idle for X
> ns, we want a guaranteed wakeup latency of Y ns -- go do your thing.

Sounds good (and I think the Linaro guys started looking into this).

> I think you also raised the point in that we do want some feedback as to
> the cost of waking up particular cores to better make decisions on which
> to wake. That is indeed so.

It depends on how we end up implementing the energy awareness in the
scheduler but too simple topology (just which CPUs can be power-gated)
is not that useful.

In a very simplistic and ideal world (note the 'ideal' part), we could
estimate the energy cost of a CPU for a period T:

E = sum(P(Cx) * Tx) + sum(wake-up-energy) + sum(P(Ty) * Ty)

  P(Cx): power in C-state x
  wake-up-energy: the cost of waking up from various C-states
  P(Ty): power of running task y (which also depends on the P-state)
  sum(Tx) + sum(Ty) = T

Assuming that we have such information and can predict (based on past
usage) what the task loads will be, together with other
performance/latency constraints, an 'ideal' scheduler would always
choose the correct C/P states and task placements for optimal energy.
However, the reality is different and even so it would be an NP problem.

But we can try to come up with some "guestimates" based on parameters
provided by the SoC (via DT or ACPI tables or just some low-level
driver/arch code). The scheduler does its best according on these
parameters at certain times (task wake-up, idle balance) while the SoC
can still tune the behaviour.

If we roughly estimate the energy cost of a run-queue and the energy
cost of individual tasks on that run-queue (based on their load and
P-state), we could estimate the cost of moving or waking the
task on another CPU (where the task's cost may change depending on
asymmetric configurations or different P-state). We don't even need to
be precise in the energy costs but just some relative numbers so that
the scheduler can favour one CPU or another. If we ignore P-state costs
and only consider C-states and symmetric configurations, we probably get
a behaviour similar to Vincent's task packing patches.

The information we have currently for C-states is target residency and
exit latency. From these I think we can only infer the wake-up energy
cost not how much we save but placing a CPU into that state. So if we
want the scheduler to decide whether to pack or spread (from an energy
cost perspective), we need additional information in the topology.

Alternatively we could have a power driver which dynamically returns
some estimates every time the scheduler asks for them, with a power
driver for each SoC (which is already the case for ARM SoCs).

-- 
Catalin
