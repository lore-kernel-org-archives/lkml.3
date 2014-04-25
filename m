Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaDYMDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:03:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57040 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752788AbaDYMDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:03:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Morten Rasmussen <morten.rasmussen@arm.com>
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
Subject: Re: [RFC] A new CPU load metric for power-efficient scheduler: CPU ConCurrency
Date: Fri, 25 Apr 2014 14:19:46 +0200
Message-ID: <13348109.c4H00groOp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140425102307.GN2500@e103034-lin>
References: <20140424193004.GA2467@intel.com> <20140425102307.GN2500@e103034-lin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 25, 2014 11:23:07 AM Morten Rasmussen wrote:
> Hi Yuyang,
> 
> On Thu, Apr 24, 2014 at 08:30:05PM +0100, Yuyang Du wrote:
> > 1)	Divide continuous time into periods of time, and average task concurrency
> > in period, for tolerating the transient bursts:
> > a = sum(concurrency * time) / period
> > 2)	Exponentially decay past periods, and synthesize them all, for hysteresis
> > to load drops or resilience to load rises (let f be decaying factor, and a_x
> > the xth period average since period 0):
> > s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, …..,+ f^(n-1) * a_1 + f^n * a_0
> > 
> > We name this load indicator as CPU ConCurrency (CC): task concurrency
> > determines how many CPUs are needed to be running concurrently.
> > 
> > To track CC, we intercept the scheduler in 1) enqueue, 2) dequeue, 3)
> > scheduler tick, and 4) enter/exit idle.
> > 
> > By CC, we implemented a Workload Consolidation patch on two Intel mobile
> > platforms (a quad-core composed of two dual-core modules): contain load and load
> > balancing in the first dual-core when aggregated CC low, and if not in the
> > full quad-core. Results show that we got power savings and no substantial
> > performance regression (even gains for some).
> 
> The idea you present seems quite similar to the task packing proposals
> by Vincent and others that were discussed about a year ago. One of the
> main issues related to task packing/consolidation is that it is not
> always beneficial.
> 
> I have spent some time over the last couple of weeks looking into this
> trying to figure out when task consolidation makes sense. The pattern I
> have seen is that it makes most sense when the task energy is dominated
> by wake-up costs. That is short-running tasks. The actual energy savings
> come from a reduced number of wake-ups if the consolidation cpu is busy
> enough to be already awake when another task wakes up, and savings by
> keeping the consolidation cpu in a shallower idle state and thereby
> reducing the wake-up costs. The wake-up cost savings outweighs the
> additional leakage in the shallower idle state in some scenarios. All of
> this is of course quite platform dependent. Different idle state leakage
> power and wake-up costs may change the picture.

The problem, however, is that it usually is not really known in advance
whether or not a given task will be short-running.  There simply is no way
to tell.

The only kinds of information we can possibly use to base decisions on are
(1) things that don't change (or if they change, we know exactly when and
how), such as the system's topology, and (2) information on what happened
in the past.  So, for example, if there's a task that has been running for
some time already and it has behaved in approximately the same way all the
time, it is reasonable to assume that it will behave in this way in the
future.  We need to let it run for a while to collect that information,
though.

Without that kind of information we can only speculate about what's going
to happen and different methods of speculation may lead to better or worse
results in a given situation, but still that's only speculation and the
results are only known after the fact.

In the reverse, if I know the system topology and I have a particular workload,
I know what's going to happen, so I can find a load balancing method that will
be perfect for this particular workload on this particular system.  That's not
the situation the scheduler has to deal with, though, because the workload is
unknown to it until it has been measured.

So in my opinion we need to figure out how to measure workloads while they are
running and then use that information to make load balancing decisions.

In principle, given the system's topology, task packing may lead to better
results for some workloads, but not necessarily for all of them.  So we need
a way to determine (a) whether or not task packing is an option at all in the
given system (that may change over time due to user policy changes etc.) and
if that is the case, then (b) if the current workload is eligible for task
packing.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
