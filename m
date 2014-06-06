Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaFFQ2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:28:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:41593 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbaFFQ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:28:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,990,1392192000"; 
   d="scan'208";a="552928426"
Date: Fri, 6 Jun 2014 09:27:44 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140606092744.23b9da4b@ultegra>
In-Reply-To: <20140606003520.GB22261@intel.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
	<20140604160230.GS29593@e103034-lin>
	<20140604172712.GJ13930@laptop.programming.kicks-ass.net>
	<2484761.vkWavnsDx3@vostro.rjw.lan>
	<20140605065205.GA3213@twins.programming.kicks-ass.net>
	<539086B3.2010804@gmail.com>
	<20140605202930.GA15484@intel.com>
	<20140606080543.GR6758@twins.programming.kicks-ass.net>
	<20140606003520.GB22261@intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 08:35:21 +0800
Yuyang Du <yuyang.du@intel.com> wrote:

> On Fri, Jun 06, 2014 at 10:05:43AM +0200, Peter Zijlstra wrote:
> > On Fri, Jun 06, 2014 at 04:29:30AM +0800, Yuyang Du wrote:
> > > On Thu, Jun 05, 2014 at 08:03:15AM -0700, Dirk Brandewie wrote:
> > > > 
> > > > You can request a P state per core but the package does
> > > > coordination at a package level for the P state that will be
> > > > used based on all requests. This is due to the fact that most
> > > > SKUs have a single VR and PLL. So the highest P state wins.
> > > > When a core goes idle it loses it's vote for the current
> > > > package P state and that cores clock it turned off.
> > > > 
> > > 
> > > You need to differentiate Turbo and non-Turbo. The highest P
> > > state wins? Not really.
> > 
> > *sigh* and here we go again.. someone please, write something
> > coherent and have all intel people sign off on it and stop saying
> > different things.
> > 
> > > Actually, silicon supports indepdent non-Turbo pstate, but just
> > > not enabled.
> > 
> > Then it doesn't exist, so no point in mentioning it.
> > 
> 
> Well, things actually get more complicated. Not-enabled is for Core.
> For Atom Baytrail, each core indeed can operate on difference
> frequency. I am not sure for Xeon, :)
> 
> > > For Turbo, it basically depends on power budget of both core and
> > > gfx (because they share) for each core to get which Turbo point.
> > 
> > And RAPL controls can give preference of which gfx/core gets most,
> > right?
> >
> 
There are two controls can influence gfx and core power budge sharing:
1. set power limit on each RAPL domain
2. turbo power budge sharing
#2 is not implemented yet. default to CPU take all.

> 
> > > > intel_pstate tries to keep the core P state as low as possible
> > > > to satisfy the given load, so when various cores go idle the
> > > > package P state can be as low as possible.  The big power win
> > > > is a core going idle.
> > > > 
> > > 
> > > In terms of prediction, it is definitely can't be 100% right. But
> > > the performance of most workloads does scale with pstate
> > > (frequency), may not be linearly. So it is to some point
> > > predictable FWIW. And this is all governors and Intel_pstate's
> > > basic assumption.
> > 
> > So frequency isn't _that_ interesting, voltage is. And while
> > predictability it might be their assumption, is it actually true? I
> > mean, there's really nothing else except to assume that, if its not
> > you can't do anything at all, so you _have_ to assume this.
> > 
> > But again, is the assumption true? Or just happy thoughts in an
> > attempt to do something.
> 
> Voltage is combined with frequency, roughly, voltage is proportional
> to freuquecy, so roughly, power is proportionaly to voltage^3. You
> can't say which is more important, or there is no reason to raise
> voltage without raising frequency.
> 
> If only one word to say: true of false, it is true. Because given any
> fixed workload, I can't see why performance would be worse if
> frequency is higher.
> 
> The reality as opposed to the assumption is in two-fold:
> 1) if workload is CPU bound, performance scales with frequency
> absolutely. if workload is memory bound, it does not scale. But from
> kernel, we don't know whether it is CPU bound or not (or it is hard
> to know). uArch statistics can model that. 2) the workload is not
> fixed in real-time, changing all the time.
> 
> But still, the assumption is a must or no guilty, because we adjust
> frequency continuously, for example, if the workload is fixed, and if
> the performance does not scale with freq we stop increasing
> frequency. So a good frequency governor or driver should and can
> continuously pursue "good" frequency with the changing workload.
> Therefore, in the long term, we will be better off.
> 

[Jacob Pan]
