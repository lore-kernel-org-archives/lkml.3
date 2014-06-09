Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaFJF1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:27:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:58137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbaFJF1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:27:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1007,1392192000"; 
   d="scan'208";a="554902058"
Date: Tue, 10 Jun 2014 05:23:20 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH 00/16 v3] A new CPU load metric for power-efficient
 scheduler: CPU ConCurrency
Message-ID: <20140609212320.GA5487@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <20140609164848.GB29593@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609164848.GB29593@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 05:48:48PM +0100, Morten Rasmussen wrote:

Thanks, Morten.

> > 2) CC vs. CPU utilization. CC is runqueue-length-weighted CPU utilization. If
> > we change: "a = sum(concurrency * time) / period" to "a' = sum(1 * time) /
> > period". Then a' is just about the CPU utilization. And the way we weight
> > runqueue-length is the simplest one (excluding the exponential decays, and you
> > may have other ways).
> 
> Isn't a' exactly to the rq runnable_avg_{sum, period} that you remove in
> patch 1? In that case it seems more obvious to repurpose them by
> multiplying the the contributions to the rq runnable_avg_sum by
> nr_running. AFAICT, that should give you the same metric.
> 
Yes, essentially it is. Removing it is simply because rq runnable_avg_X is not used.
And yes, by repurposing it, I can get CC, in that sense what I do is replacing it
not just removing it, :)

> On the other hand, I don't see what this new metric gives us that can't
> be inferred from the existing load tracking metrics or through slight
> modifications of those. It came up recently in a different thread that
> the tracked task load is heavily influenced by other tasks running on
> the same cpu if they happen to overlap in time. IIUC, that exactly the
> information you are after. I think you could implement the same task
> packing behaviour based on an unweighted version of
> cfs.runnable_load_avg instead, which should be fairly straightforward to
> introduce (I think it will become useful for other purposes as well). I
> sort of hinted that in that thread already:
> 
> https://lkml.org/lkml/2014/6/4/54
> 

Yes, it seems an unweighted cfs.runnable_load_avg should be similar to what CC is.
I have been thinking about and working on this.

My work in this regard is in the middle. One of my concerns is how sum and period
accrue with time, and how contrib is calculated (for both entity and rq runnable).
Resultingly, the period is "always" around 48000, and it takes sum a long time to
reflect the latest activity (IIUC, you also pointed this out). For balancing, this
might not be a problem, but for consolidating, we need much more sensitivity.

I don't know, but anyway, I will solve this/give a good reason (as is also
required by PeterZ).

> 
> The potential worst case consolidated CC sum is:
> 
> 	n * \sum{cpus}^{n} CC[n]
> 
> So, the range in which the true consolidated CC lies grows
> proportionally to the number of cpus. We can't really say anything about
> how things will pan out if we consolidate on fewer cpus. However, if it
> turns out to be a bad mix of tasks the task runnable_avg_sum will go up
> and if we use cfs.runnable_load_avg as the indication of compute
> capacity requirements, we would eventually spread the load again.
> Clearly, we don't want an unstable situation, so it might be better to
> the consolidation partially and see where things are going.
> 

No. The current load balancing is all done by pulling, and Workload Consolidation
will prevent the pulling when consolidated, that said, the current load
balancing (effectively) can/will not act in the opposite direction of
Workload Consolidation at the same time.

Is that what you are concerned?

> > So, we uniformly use this condition for consolidation (suppose
> > we consolidate m CPUs to n CPUs, m > n):
> > 
> > (CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=<? (1 * n) * n *
> > consolidating_coefficient
> 
> Do you have a rationale behind this heuristic? It seems to be more and
> more pessimistic about how much load we can put on 'n' cpus as 'm'
> increases. Basically trying to factor in some of the error that be in
> the consolidated CC. Why the '(1 * n) * n...' and not just 'n * n * con...'?
> 

The rationale is: the more CPUs, the less likely they are concurrently running
(coscheduled), especially when load is not high and transient (this is when we
want to consolidate). So we go toward more optimistic for large m to small n,
exponentially by log.

> Overall, IIUC, the aim of this patch set seems quite similar to the
> previous proposals for task packing.
> 

Ok. So I did not do a weird thing, that is good, :) and help me do it together
since we all want it.

Thanks,
Yuyang
