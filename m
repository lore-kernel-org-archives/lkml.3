Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3KKLeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:34:17 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53895 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3KKLeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:34:07 -0500
MIME-Version: 1.0
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 11 Nov 2013 11:33:45 +0000
X-Google-Sender-Auth: JNNeac86jmK7jWDq2j1_FhyY8DQ
Message-ID: <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>, l.majewski@samsung.com,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

(cross-posting to linux-pm as it was agreed to follow up on this list)

On 18 October 2013 12:52, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> This is the 5th version of the previously named "packing small tasks" patchset.
> "small" has been removed because the patchset doesn't only target small tasks
> anymore.
>
> This patchset takes advantage of the new per-task load tracking that is
> available in the scheduler to pack the tasks in a minimum number of
> CPU/Cluster/Core. The packing mechanism takes into account the power gating
> topology of the CPUs to minimize the number of power domains that need to be
> powered on simultaneously.

As a general comment, it's not clear how this set of patches address
the bigger problem of energy aware scheduling, mainly because we
haven't yet defined _what_ we want from the scheduler, what the
scenarios are, constraints, are we prepared to give up some
performance (speed, latency) for power, how much.

This packing heuristics may work for certain SoCs and workloads but,
for example, there are modern ARM SoCs where the P-state has a much
bigger effect on power and it's more energy-efficient to keep two CPUs
in lower P-state than packing all tasks onto one, even though they may
be gated independently. In such cases _small_ task packing (for some
definition of 'small') would be more useful than general packing but
even this is just heuristics that saves power for particular workloads
without fully defining/addressing the problem.

I would rather start by defining the main goal and working backwards
to an algorithm. We may as well find that task packing based on this
patch set is sufficient but we may also get packing-like behaviour as
a side effect of a broader approach (better energy cost awareness). An
important aspect even in the mobile space is keeping the performance
as close as possible to the standard scheduler while saving a bit more
power. Just trying to reduce the number of non-idle CPUs may not meet
this requirement.


So, IMO, defining the power topology is a good starting point and I
think it's better to separate the patches from the energy saving
algorithms like packing. We need to agree on what information we have
(C-state details, coupling, power gating) and what we can/need to
expose to the scheduler. This can be revisited once we start
implementing/refining the energy awareness.

2nd step is how the _current_ scheduler could use such information
while keeping the current overall system behaviour (how much of
cpuidle we should move into the scheduler).

Question for Peter/Ingo: do you want the scheduler to decide on which
C-state a CPU should be in or we still leave this to a cpuidle
layer/driver?

My understanding from the recent discussions is that the scheduler
should decide directly on the C-state (or rather the deepest C-state
possible since we don't want to duplicate the backend logic for
synchronising CPUs going up or down). This means that the scheduler
needs to know about C-state target residency, wake-up latency (I think
we can leave coupled C-states to the backend, there is some complex
synchronisation which I wouldn't duplicate).

Alternatively (my preferred approach), we get the scheduler to predict
and pass the expected residency and latency requirements down to a
power driver and read back the actual C-states for making task
placement decisions. Some of the menu governor prediction logic could
be turned into a library and used by the scheduler. Basically what
this tries to achieve is better scheduler awareness of the current
C-states decided by a cpuidle/power driver based on the scheduler
constraints.

3rd step is optimising the scheduler for energy saving, taking into
account the information added by the previous steps and possibly
adding some more. This stage however has several sub-steps (that can
be worked on in parallel to the steps above):

a) Define use-cases, typical workloads, acceptance criteria
(performance, latency requirements).

b) Set of benchmarks simulating the scenarios above. I wouldn't bother
with linsched since a power model is never realistic enough. It's
better to run those benchmarks on real hardware and either estimate
the energy based on the C/P states or, depending on SoC, read some
sensors, energy probes. If the scheduler maintainers want to reproduce
the numbers, I'm pretty sure we can ship some boards.

c) Start defining/implementing scheduler algorithm to do optimal task placement.

d) Assess the implementation against benchmarks at (b) *and* other
typical performance benchmarks (whether it's for servers, mobile,
Android etc). At this point we'll most likely go back and refine the
previous steps.

So far we've jumped directly to (c) because we had some scenarios in
mind that needed optimising but those haven't been written down and we
don't have a clear way to assess the impact. There is more here than
simply maximising the idle time. Ideally the scheduler should have an
estimate of the overall energy cost, the cost per task, run-queue, the
energy implications of moving the tasks to another run-queue, possibly
taking the P-state into account (but not 'picking' a P-state).

Anyway, I think we need to address the first steps and think about the
algorithm once we have the bigger picture of what we try to solve.

Thanks.

-- 
Catalin
