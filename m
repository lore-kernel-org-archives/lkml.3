Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbaD1PWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:22:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11322 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932376AbaD1PWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:22:07 -0400
Date: Mon, 28 Apr 2014 16:22:13 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "rajeev.d.muralidhar@intel.com" <rajeev.d.muralidhar@intel.com>,
        "vishwesh.m.rudramuni@intel.com" <vishwesh.m.rudramuni@intel.com>,
        "nicole.chalhoub@intel.com" <nicole.chalhoub@intel.com>,
        "ajaya.durg@intel.com" <ajaya.durg@intel.com>,
        "harinarayanan.seshadri@intel.com" <harinarayanan.seshadri@intel.com>
Subject: Re: [RFC] A new CPU load metric for power-efficient scheduler: CPU
 ConCurrency
Message-ID: <20140428152213.GD2639@e103034-lin>
References: <20140424193004.GA2467@intel.com>
 <20140425102307.GN2500@e103034-lin>
 <13348109.c4H00groOp@vostro.rjw.lan>
 <20140425145334.GC2639@e103034-lin>
 <20140427200725.GA4771@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427200725.GA4771@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 09:07:25PM +0100, Yuyang Du wrote:
> On Fri, Apr 25, 2014 at 03:53:34PM +0100, Morten Rasmussen wrote:
> > I fully agree. My point was that there is more to task consolidation
> > than just observing the degree of task parallelism. The system topology
> > has a lot to say when deciding whether or not to pack. That was the
> > motivation for proposing to have a power model for the system topology
> > to help making that decision.
> > 
> > We do already have some per-task metric available that may be useful for
> > determining whether a workload is eligible for task packing. The
> > load_avg_contrib gives us an indication of the tasks cpu utilization and
> > we also count task wake-ups. If we tracked task wake-ups over time
> > (right now we only have the sum) we should be able to reason about the
> > number of wake-ups that a task causes. Lots of wake-ups and low
> > load_avg_contrib would indicate the task power is likely to be dominated
> > by the wake-up costs if it is placed on a cpu in a deep idle state.
> > 
> > I fully agree that measuring the workloads while they are running is the
> > way to go. I'm just wondering if the proposed cpu concurrency measure
> > is sufficient to make the task packing decision for all system
> > topologies or if we need something that incorporates more system
> > topology information. If the latter, we may want to roll it all into
> > something like an energy_diff(src_cpu, dst_cpu, task) helper function
> > for use in load-balancing decisions.
> > 
> 
> Thank you.
> 
> After CC, in the consolidation part, we do 1) attach the CPU topology to "help
> making that decision" and to be adaptive beyond our experimental platforms, and
> 2) intercept the current load balance for load and load balancing containment.
> 
> Maybe, the way we consolidate workload differs from previous is:
> 
> 1) we don't do it per task. We only see how many concurrent CPUs needed (on
> average and on prediction at power gated units) for the workload, and simply
> consolidate.

I'm a bit confused, do you have one global CC that tracks the number of
tasks across all runqueues in the system or one for each cpu? There
could be some contention when updating that value on larger systems if
it one global CC. If they are separate, how do you then decide when to
consolidate? 

How do you determine your "f" parameter? How fast is the reaction time?
If you have had a period of consolidation and have a bunch of tasks
waking up at the same time. How long will it be until you spread the
load to all cpus?

> 
> 2) I am not sure it is sufficient either, :). But I can offer another two ways
> of how to interpret CC.
> 
> 2.1) the current work-conserving load balance also uses CC, but instantaneous
> CC (similar to what PeterZ said to Vincent?).

The existing load balancing based on load_avg_contrib factors in task
parallelism implicitly. If you have two tasks runnable at the same time,
one of them will have to wait on the rq resulting in it getting a higher
load_avg_contrib than it would have had if the two tasks became runnable
at different times (no parallelism). The higher load_avg_contrib means
that load balancer is more likely to spread tasks that overlaps in time
similar to what you achieve with CC. But it doesn't do the reverse.

> 
> 2.2) CC vs. CPU utilization. CC is runqueue-length-weighted CPU utilization.
> If we change: "a = sum(concurrency * time) / period" to "a' = sum(1 * time) /
> period". Then a' is just about the CPU utilization. And the way we weight
> runqueue-length is the simplest one (excluding the exponential decays, and you
> may have other ways).

Right. How do you distinguish between having a concurrency of 1 for 100%
of the time and having a concurrency of 2 for 50% of the time. Both
should give an average concurrency of very close to 1 depending on your
exponential decay?

It seems to me that you are loosing some important information by
tracking per cpu and not per task. Also, your load balance behaviour is
very sensitive to the choice of decay factor. We have that issue with
the runqueue load tracking already. It reacts very slowly to load
changes, so it can't really be used for periodic load-balancing
decisions.

> The workloads they (not me) used to evaluate the "Workload Consolidation" is
> 1) 50+ perf/ux benchmarks (almost all of the magazine ones), and 2) ~10 power
> workloads, of course, they are the easiest ones, such as browsing, audio,
> video, recording, imaging, etc.

Can you share how much of the time that the benchmarks actually ran
consolidated vs spread out? IIUC, you consolidate on two cpus which
should be enough for a lot of workloads.

Morten
