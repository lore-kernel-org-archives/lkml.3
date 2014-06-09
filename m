Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbaFII77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:59:59 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:29393 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932502AbaFII7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:59:54 -0400
Date: Mon, 9 Jun 2014 09:59:52 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140609085952.GZ29593@e103034-lin>
References: <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
 <20140607232628.GC22261@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140607232628.GC22261@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 12:26:29AM +0100, Yuyang Du wrote:
> On Fri, Jun 06, 2014 at 12:50:36PM +0200, Peter Zijlstra wrote:
> > > Voltage is combined with frequency, roughly, voltage is proportional
> > > to freuquecy, so roughly, power is proportionaly to voltage^3. You
> > 
> > P ~ V^2, last time I checked.
> > 
> > > can't say which is more important, or there is no reason to raise
> > > voltage without raising frequency.
> > 
> > Well, some chips have far fewer voltage steps than freq steps; or,
> > differently put, they have multiple freq steps for a single voltage
> > level.
> > 
> > And since the power (Watts) is proportional to Voltage squared, its the
> > biggest term.
> > 
> > If you have a distinct voltage level for each freq, it all doesn't
> > matter.
> > 
> 
> Ok. I think we understand each other. But one more thing, I said P ~ V^3,
> because P ~ V^2*f and f ~ V, so P ~ V^3. Maybe some frequencies share the same
> voltage, but you can still safely assume V changes with f in general, and it
> will be more and more so, since we do need finer control over power consumption.

Agreed. Voltage typically changes with frequency.

> 
> > Sure, but realize that we must fully understand this governor and
> > integrate it in the scheduler if we're to attain the goal of IPC/watt
> > optimized scheduling behaviour.
> > 
> 
> Attain the goal of IPC/watt optimized?
> 
> I don't see how it can be done like this. As I said, what is unknown for
> prediction is perf scaling *and* changing workload. So the challenge for pstate
> control is in both. But I see more chanllenge in the changing workload than
> in the performance scaling or the resulting IPC impact (if workload is
> fixed).

IMHO, the per-entity load-tracking does a fair job representing the task
compute capacity requirements. Sure it isn't perfect, particularly not
for memory bound tasks, but it is way better than not having any task
history at all, which was the case before.

The story is more or less the same for performance scaling. It is not
taken into account at all in the scheduler at the moment. cpufreq is
actually messing up load-balancing decisions after task load-tracking
was introduced. Adding performance scaling awareness should only make
things better even if predictions are not accurate for all workloads. I
don't see why it shouldn't given the current state of energy-awareness
in the scheduler.

> Currently, all freq governors take CPU utilization (load%) as the indicator
> (target), which can server both: workload and perf scaling.

With a bunch of hacks on top to make it more reactive because the
current cpu utilization metric is not responsive enough to deal with
workload changes. That is at least the case for ondemand and interactive
(in Android).

> As for IPC/watt optimized, I don't see how it can be practical. Too micro to
> be used for the general well-being?

That is why I propose to have a platform specific energy model. You tell
the scheduler enough about your platform that it understands the most
basic power/performance trade-offs of your platform and thereby enable
the scheduler to make better decisions.
