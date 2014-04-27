Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaD1EMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:12:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:39169 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaD1EMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:12:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,941,1389772800"; 
   d="scan'208";a="502052337"
Date: Mon, 28 Apr 2014 04:07:25 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
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
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, yuyang.du@intel.com
Subject: Re: [RFC] A new CPU load metric for power-efficient scheduler: CPU
 ConCurrency
Message-ID: <20140427200725.GA4771@intel.com>
References: <20140424193004.GA2467@intel.com>
 <20140425102307.GN2500@e103034-lin>
 <13348109.c4H00groOp@vostro.rjw.lan>
 <20140425145334.GC2639@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425145334.GC2639@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 03:53:34PM +0100, Morten Rasmussen wrote:
> I fully agree. My point was that there is more to task consolidation
> than just observing the degree of task parallelism. The system topology
> has a lot to say when deciding whether or not to pack. That was the
> motivation for proposing to have a power model for the system topology
> to help making that decision.
> 
> We do already have some per-task metric available that may be useful for
> determining whether a workload is eligible for task packing. The
> load_avg_contrib gives us an indication of the tasks cpu utilization and
> we also count task wake-ups. If we tracked task wake-ups over time
> (right now we only have the sum) we should be able to reason about the
> number of wake-ups that a task causes. Lots of wake-ups and low
> load_avg_contrib would indicate the task power is likely to be dominated
> by the wake-up costs if it is placed on a cpu in a deep idle state.
> 
> I fully agree that measuring the workloads while they are running is the
> way to go. I'm just wondering if the proposed cpu concurrency measure
> is sufficient to make the task packing decision for all system
> topologies or if we need something that incorporates more system
> topology information. If the latter, we may want to roll it all into
> something like an energy_diff(src_cpu, dst_cpu, task) helper function
> for use in load-balancing decisions.
> 

Thank you.

After CC, in the consolidation part, we do 1) attach the CPU topology to "help
making that decision" and to be adaptive beyond our experimental platforms, and
2) intercept the current load balance for load and load balancing containment.

Maybe, the way we consolidate workload differs from previous is:

1) we don't do it per task. We only see how many concurrent CPUs needed (on
average and on prediction at power gated units) for the workload, and simply
consolidate.

2) I am not sure it is sufficient either, :). But I can offer another two ways
of how to interpret CC.

2.1) the current work-conserving load balance also uses CC, but instantaneous
CC (similar to what PeterZ said to Vincent?).

2.2) CC vs. CPU utilization. CC is runqueue-length-weighted CPU utilization.
If we change: "a = sum(concurrency * time) / period" to "a' = sum(1 * time) /
period". Then a' is just about the CPU utilization. And the way we weight
runqueue-length is the simplest one (excluding the exponential decays, and you
may have other ways).

The workloads they (not me) used to evaluate the "Workload Consolidation" is
1) 50+ perf/ux benchmarks (almost all of the magazine ones), and 2) ~10 power
workloads, of course, they are the easiest ones, such as browsing, audio,
video, recording, imaging, etc.

Thanks,
Yuyang
