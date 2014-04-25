Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaDYKW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:22:57 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43611 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752649AbaDYKWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:22:53 -0400
Date: Fri, 25 Apr 2014 11:23:07 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
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
Message-ID: <20140425102307.GN2500@e103034-lin>
References: <20140424193004.GA2467@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140424193004.GA2467@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuyang,

On Thu, Apr 24, 2014 at 08:30:05PM +0100, Yuyang Du wrote:
> 1)	Divide continuous time into periods of time, and average task concurrency
> in period, for tolerating the transient bursts:
> a = sum(concurrency * time) / period
> 2)	Exponentially decay past periods, and synthesize them all, for hysteresis
> to load drops or resilience to load rises (let f be decaying factor, and a_x
> the xth period average since period 0):
> s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, …..,+ f^(n-1) * a_1 + f^n * a_0
> 
> We name this load indicator as CPU ConCurrency (CC): task concurrency
> determines how many CPUs are needed to be running concurrently.
> 
> To track CC, we intercept the scheduler in 1) enqueue, 2) dequeue, 3)
> scheduler tick, and 4) enter/exit idle.
> 
> By CC, we implemented a Workload Consolidation patch on two Intel mobile
> platforms (a quad-core composed of two dual-core modules): contain load and load
> balancing in the first dual-core when aggregated CC low, and if not in the
> full quad-core. Results show that we got power savings and no substantial
> performance regression (even gains for some).

The idea you present seems quite similar to the task packing proposals
by Vincent and others that were discussed about a year ago. One of the
main issues related to task packing/consolidation is that it is not
always beneficial.

I have spent some time over the last couple of weeks looking into this
trying to figure out when task consolidation makes sense. The pattern I
have seen is that it makes most sense when the task energy is dominated
by wake-up costs. That is short-running tasks. The actual energy savings
come from a reduced number of wake-ups if the consolidation cpu is busy
enough to be already awake when another task wakes up, and savings by
keeping the consolidation cpu in a shallower idle state and thereby
reducing the wake-up costs. The wake-up cost savings outweighs the
additional leakage in the shallower idle state in some scenarios. All of
this is of course quite platform dependent. Different idle state leakage
power and wake-up costs may change the picture.

I'm therefore quite interested in knowing what sort of test scenarios
you used and the parameters for CC (f and size of the periods). I'm not
convinced (yet) that a cpu load concurrency indicator is sufficient to
make the call when to consolidate tasks. I'm thinking whether we need a
power model to guide the decisions.

Whether you use CC or reintroduce usage_avg as Vincent proposes I
believe the overhead should be roughly the same.

Morten
