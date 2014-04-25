Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaDYOxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:53:40 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47950 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751334AbaDYOxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:53:36 -0400
Date: Fri, 25 Apr 2014 15:53:34 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yuyang Du <yuyang.du@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>
Subject: Re: [RFC] A new CPU load metric for power-efficient scheduler: CPU
 ConCurrency
Message-ID: <20140425145334.GC2639@e103034-lin>
References: <20140424193004.GA2467@intel.com>
 <20140425102307.GN2500@e103034-lin>
 <13348109.c4H00groOp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13348109.c4H00groOp@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 01:19:46PM +0100, Rafael J. Wysocki wrote:
> On Friday, April 25, 2014 11:23:07 AM Morten Rasmussen wrote:
> > Hi Yuyang,
> > 
> > On Thu, Apr 24, 2014 at 08:30:05PM +0100, Yuyang Du wrote:
> > > 1)	Divide continuous time into periods of time, and average task concurrency
> > > in period, for tolerating the transient bursts:
> > > a = sum(concurrency * time) / period
> > > 2)	Exponentially decay past periods, and synthesize them all, for hysteresis
> > > to load drops or resilience to load rises (let f be decaying factor, and a_x
> > > the xth period average since period 0):
> > > s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, …..,+ f^(n-1) * a_1 + f^n * a_0
> > > 
> > > We name this load indicator as CPU ConCurrency (CC): task concurrency
> > > determines how many CPUs are needed to be running concurrently.
> > > 
> > > To track CC, we intercept the scheduler in 1) enqueue, 2) dequeue, 3)
> > > scheduler tick, and 4) enter/exit idle.
> > > 
> > > By CC, we implemented a Workload Consolidation patch on two Intel mobile
> > > platforms (a quad-core composed of two dual-core modules): contain load and load
> > > balancing in the first dual-core when aggregated CC low, and if not in the
> > > full quad-core. Results show that we got power savings and no substantial
> > > performance regression (even gains for some).
> > 
> > The idea you present seems quite similar to the task packing proposals
> > by Vincent and others that were discussed about a year ago. One of the
> > main issues related to task packing/consolidation is that it is not
> > always beneficial.
> > 
> > I have spent some time over the last couple of weeks looking into this
> > trying to figure out when task consolidation makes sense. The pattern I
> > have seen is that it makes most sense when the task energy is dominated
> > by wake-up costs. That is short-running tasks. The actual energy savings
> > come from a reduced number of wake-ups if the consolidation cpu is busy
> > enough to be already awake when another task wakes up, and savings by
> > keeping the consolidation cpu in a shallower idle state and thereby
> > reducing the wake-up costs. The wake-up cost savings outweighs the
> > additional leakage in the shallower idle state in some scenarios. All of
> > this is of course quite platform dependent. Different idle state leakage
> > power and wake-up costs may change the picture.
> 
> The problem, however, is that it usually is not really known in advance
> whether or not a given task will be short-running.  There simply is no way
> to tell.
> 
> The only kinds of information we can possibly use to base decisions on are
> (1) things that don't change (or if they change, we know exactly when and
> how), such as the system's topology, and (2) information on what happened
> in the past.  So, for example, if there's a task that has been running for
> some time already and it has behaved in approximately the same way all the
> time, it is reasonable to assume that it will behave in this way in the
> future.  We need to let it run for a while to collect that information,
> though.
> 
> Without that kind of information we can only speculate about what's going
> to happen and different methods of speculation may lead to better or worse
> results in a given situation, but still that's only speculation and the
> results are only known after the fact.
> 
> In the reverse, if I know the system topology and I have a particular workload,
> I know what's going to happen, so I can find a load balancing method that will
> be perfect for this particular workload on this particular system.  That's not
> the situation the scheduler has to deal with, though, because the workload is
> unknown to it until it has been measured.
> 
> So in my opinion we need to figure out how to measure workloads while they are
> running and then use that information to make load balancing decisions.
> 
> In principle, given the system's topology, task packing may lead to better
> results for some workloads, but not necessarily for all of them.  So we need
> a way to determine (a) whether or not task packing is an option at all in the
> given system (that may change over time due to user policy changes etc.) and
> if that is the case, then (b) if the current workload is eligible for task
> packing.

I fully agree. My point was that there is more to task consolidation
than just observing the degree of task parallelism. The system topology
has a lot to say when deciding whether or not to pack. That was the
motivation for proposing to have a power model for the system topology
to help making that decision.

We do already have some per-task metric available that may be useful for
determining whether a workload is eligible for task packing. The
load_avg_contrib gives us an indication of the tasks cpu utilization and
we also count task wake-ups. If we tracked task wake-ups over time
(right now we only have the sum) we should be able to reason about the
number of wake-ups that a task causes. Lots of wake-ups and low
load_avg_contrib would indicate the task power is likely to be dominated
by the wake-up costs if it is placed on a cpu in a deep idle state.

I fully agree that measuring the workloads while they are running is the
way to go. I'm just wondering if the proposed cpu concurrency measure
is sufficient to make the task packing decision for all system
topologies or if we need something that incorporates more system
topology information. If the latter, we may want to roll it all into
something like an energy_diff(src_cpu, dst_cpu, task) helper function
for use in load-balancing decisions.

Morten
