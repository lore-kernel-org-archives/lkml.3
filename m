Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaGGOA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:00:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47979 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaGGOA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:00:27 -0400
Date: Mon, 7 Jul 2014 15:00:18 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [RFCv2 PATCH 00/23] sched: Energy cost model for energy-aware
 scheduling
Message-ID: <20140707135915.GA4485@e103687>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <20140704165552.GB30016@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140704165552.GB30016@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Jul 2014 14:00:22.0754 (UTC) FILETIME=[CB7FAC20:01CF99EB]
X-MC-Unique: 114070715002500501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Fri, Jul 04, 2014 at 05:55:52PM +0100, Catalin Marinas wrote:
> Hi Morten,
> 
> On Thu, Jul 03, 2014 at 05:25:47PM +0100, Morten Rasmussen wrote:
> > This is an RFC and there are some loose ends that have not been
> > addressed here or in the code yet. The model and its infrastructure is
> > in place in the scheduler and it is being used for load-balancing
> > decisions. It is used for the select_task_rq_fair() path for
> > fork/exec/wake balancing and to guide the selection of the source cpu
> > for periodic or idle balance.
> 
> IMHO, the series is on the right direction for addressing the energy
> aware scheduling (very complex) problem. But I have some high level
> comments below.
> 
> > However, the main ideas and the primary focus of this RFC: The energy
> > model and energy_diff_{load, task, cpu}() are there.
> > 
> > Due to limitation 1, the ARM TC2 platform (2xA15+3xA7) was setup to
> > disable frequency scaling and set frequencies to eliminate the
> > big.LITTLE performance difference. That basically turns TC2 into an SMP
> > platform where a subset of the cpus are less energy-efficient.
> > 
> > Tests using a synthetic workload with seven short running periodic
> > tasks of different size and period, and the sysbench cpu benchmark with
> > five threads gave the following results:
> > 
> > cpu energy*	short tasks	sysbench
> > Mainline	100		100
> > EA		 49		 99
> > 
> > * Note that these energy savings are _not_ representative of what can be
> > achieved on a true SMP platform where all cpus are equally 
> > energy-efficient. There should be benefit for SMP platforms as well, 
> > however, it will be smaller.
> 
> My impression (and I may be wrong) is that you get bigger energy saving
> on a big.LITTLE vs SMP system exactly because of the asymmetry in power
> consumption.

That is correct. As said in the note above, the benefit will be smaller
on SMP systems.

> The algorithm proposed here ends up packing small tasks on
> the little CPUs as they are more energy efficient (which is the correct
> thing to do but I wonder what results you would get with 3xA7 vs
> 2xA7+1xA15).
> 
> For a symmetric system where all CPUs have the same energy model you
> could end up with several small threads balanced equally across the
> system. The only way the scheduler could avoid a CPU is if it somehow
> manages to get into a deeper idle state (and energy_diff_task() would
> show some asymmetry). But this wouldn't happen without the scheduler
> first deciding to leave that CPU idle for longer.

It is a scenario that could happen with the current use of
energy_diff_task() in the wakeup balancing path. Any 'imbalance' might
make some cpus cheaper and hence attract the other tasks, but it is not
guaranteed to happen.

> Could this be addressed by making the scheduler more "proactive" and,
> rather than just looking at the current energy diff, guesstimate what it
> would be if not placing a task at all on the CPU? If for example there
> is no other task running on that CPU, could energy_diff_task() take into
> account the next deeper C-state rather than just the current one? This
> way we may be able to achieve more packing even on fully symmetric
> systems and allow CPUs to go into deeper sleep states.

I think it would be possible to bias the choice of cpu either by
considering potential energy savings by letting some cpus get into a
deeper C-state, or applying a static bias towards some cpus (lower cpuid
for example). Since it is in the wakeup path it must not be too complex
to figure out though.

I haven't seen the problem in reality yet. When I tried the short tasks
test with all cpus using the same energy model I got tasks consolidated
on either of the clusters. The consolidation cluster sometimes changed
during the test.

There is a lot of tuning to be done, that is for sure. We will have to
make similar decisions for the periodic/idle balance path as well.

Thanks,
Morten

