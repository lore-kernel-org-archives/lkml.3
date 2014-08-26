Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaHZFcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:32:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53233 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaHZFcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:32:51 -0400
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Sundar <sunder.svit@gmail.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul McKenney <Paul.McKenney@us.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Juri Lelli <juri.lelli@arm.com>, sched-tools@linaro.org,
        len.brown@intel.com, mark.gross@intel.com, larry.bassel@linaro.org
Subject: Re: [ANNOUNCE] (Resend) Tools to analyse PM and scheduling behaviour
In-Reply-To: <CAMHCuPWeMwjJO+xzmQrZFmEMdx3+yF=zkove8brWX4rQiti50w@mail.gmail.com>
References: <87mwb0fixy.fsf@matterhorn.verdurent.com> <CAMHCuPWeMwjJO+xzmQrZFmEMdx3+yF=zkove8brWX4rQiti50w@mail.gmail.com>
User-Agent: Notmuch/0.18.1+69~gf92342c (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 26 Aug 2014 11:02:52 +0530
Message-ID: <87oav7n7cr.fsf@matterhorn.verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2014 at 07:44 +0530, Sundar <sunder.svit@gmail.com> wrote:
> Hi Amit,
>
> On Tue, Aug 19, 2014 at 11:11 AM, Amit Kucheria
> <amit.kucheria@linaro.org> wrote:
>>
>> We’re soliciting early feedback from community on the direction of idlestat
>
> Nice :)
>
>> Idlestat Details
>> ----------------
>> Idlestat uses FTRACE to capture traces related to C-state and P-state
>> transitions of the CPU and wakeups (IRQ, IPI) on the system and then
>> post-processes the data to print statistics. It is designed to be used
>> non-interactively. Idlestat can deduce the idle time for a cluster as an
>> intersection between the idle times of all the cpus belonging to the same
>> cluster. This data is useful to analyse and optimise scheduling behaviour.
>> The tool will also list how many times the menu governor mis-predicts
>> target residency in a C-state.
>
> We discussed this in the energy aware scheduling workshop this week @
> the Kernel Summit. A few notes:
>
> 1. We need to really understand the co-relation of this tool w.r.t
> actual hardware states.
> It is usually likely that the software "thinks" it is in a low power
> state, but the actual
> hardware might not be. What is the coverage for these kind of cases here.

You are right, it does not represent the actual state of the HW, only
the 'requested' state.

There are various platform-dependent ways to knowing the actual HW
state. Some examples are:
 - Through an external HW signal (e.g. a GPIO that is toggled when clock
 to the CPU is cut off)
 - Measuring power on the power rails and correlating those well-known
 values (CPU ON, retention, OFF) to the traces
 - Reading some register (like MSR on x86)

This is not the main focus of the tool.

> 2. I understand that C/P states are a direct metric of how well the
> workload behaved w.r.t power;
> but I am not sure that relates to a direct measure of how the
> scheduler performed.

Consider the following examples:

*On a given platform*, we see the same benchmark scores with and
without patchset ABC, but including patchset ABC leads to better "power
behaviour" i.e. requests of deeper idle states and/or lower frequencies.

Consider another example where the benchmark score dramatically improves
with patchset XYZ while the idle and frequency requests are marginally
worse (shallower idle, reduced residency or increased frequency requests).

In both cases, it is left to platforms to do real measurements to confirm that
this is indeed the case. The latter example might not even be possible
on some platforms, given some platform constraints e.g. the platform
thermal envelope.

Idlestat is not a replacement for real measurements. It is a tool to
allow maintainers (scheduler, PM) to judge if any further investigation
is needed and request such numbers from people running the code on
various architectures before merging the patches.

> The C/P states
> could be maintained whilst giving away performance or power at the
> expense of additional components
> on the SoC and platform like DDR IOs, fabric states etc.

True.

> Quick Summary of what I discussed with Daniel @ the workshop about idlestat:
>
> 1. There might be usually platform specific tools to get residencies
> for P/C states.
> PowerTop & Turbostat are two that first come to mind. Any specific
> item apart from prediction logic
> that idlestat differs from these two?

First, idlestat is designed to be architecture-independent. It only
depends on what the kernel knows.
Second, it is created with benchmarking in mind - non-interactive and
minimal overhead.
Third, it was designed for maintainers to be able to quickly tell if a
patchset changes OS behaviour dramatically and request deeper
analysis on various architectures.
Fourth, it has the prediction logic which calculates the intersection of
C-state requests by several cpus in a cluster to determine the cluster
state.

On top of this, we have two WIP additions:
 - an experimental "energy model" patch for idlestat that lets a SoC
 vendor provide the cost of various states as input and idlestat will
 output the "energy cost" of a workload.
 - a 'diff mode' to show the diff between two traces

> 2. To me debugging performance or power, C/P states provide the
> direction that something is wrong.
>
> But they still dont tell me "what" is wrong "if" the issue is somehow
> in the kernel as opposed to a more

Correct. At the moment, idlestat can only provide an indication if
something might be wrong.

> easily fixable software code (traceable at hardware/software level for
> best optimizations). How do I
> conclude that my scheduler is the culprit apart from the points where
> it took a decision to select the
> right idle states based on predicted sleep times? In my opinion, that
> would boil down to if the scheduler
> was invoking too much load balancing calls, moving my threads across
> cores too much, data being
> thrashed across caches, cores too much etc.

These would show up as regressions in benchmark results. Fengguang's
excellent benchmark report[1] already captures such "changes". Does it
make sense to recapture that in a tool?

We're open to tracking more metrics if it is felt they are useful.

> I think a tool for scheduler metrics must be based on more inner
> details like the above, finally culminating
> into C/P states. as opposed to C/P states being the metric to be relied.

One of the tenets of energy-aware scheduling is "improving energy
efficiency with little or no performance regression". idlestat tells us
about possible regressions on the energy front and benchmarks should
tell us if we are regressing on performance. Hence the focus on
C/P-states for now.

Regards,
Amit
[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg703826.html
