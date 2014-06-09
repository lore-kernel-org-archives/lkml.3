Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896AbaFIRaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:30:19 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54934 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755109AbaFIRaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:30:17 -0400
Date: Mon, 9 Jun 2014 18:30:21 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/16 v3] A new CPU load metric for power-efficient
 scheduler: CPU ConCurrency
Message-ID: <20140609173021.GC29593@e103034-lin>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend... The first attempt didn't reach LKML for some reason.

On Fri, May 30, 2014 at 07:35:56AM +0100, Yuyang Du wrote:
> Thanks to CFS’s “model an ideal, precise multi-tasking CPU”, tasks can be seen
> as concurrently running (the tasks in the runqueue). So it is natural to use
> task concurrency as load indicator. Having said that, we do two things:
> 
> 1) Divide continuous time into periods of time, and average task concurrency
> in period, for tolerating the transient bursts:
> a = sum(concurrency * time) / period
> 2) Exponentially decay past periods, and synthesize them all, for hysteresis
> to load drops or resilience to load rises (let f be decaying factor, and a_x
> the xth period average since period 0):
> s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, ..., + f^(n-1) * a_1 + f^n * a_0
> 
> We name this load indicator as CPU ConCurrency (CC): task concurrency
> determines how many CPUs are needed to be running concurrently.
> 
> Another two ways of how to interpret CC:
> 
> 1) the current work-conserving load balance also uses CC, but instantaneous
> CC.
> 
> 2) CC vs. CPU utilization. CC is runqueue-length-weighted CPU utilization. If
> we change: "a = sum(concurrency * time) / period" to "a' = sum(1 * time) /
> period". Then a' is just about the CPU utilization. And the way we weight
> runqueue-length is the simplest one (excluding the exponential decays, and you
> may have other ways).

Isn't a' exactly to the rq runnable_avg_{sum, period} that you remove in
patch 1? In that case it seems more obvious to repurpose them by
multiplying the the contributions to the rq runnable_avg_sum by
nr_running. AFAICT, that should give you the same metric.

On the other hand, I don't see what this new metric gives us that can't
be inferred from the existing load tracking metrics or through slight
modifications of those. It came up recently in a different thread that
the tracked task load is heavily influenced by other tasks running on
the same cpu if they happen to overlap in time. IIUC, that exactly the
information you are after. I think you could implement the same task
packing behaviour based on an unweighted version of
cfs.runnable_load_avg instead, which should be fairly straightforward to
introduce (I think it will become useful for other purposes as well). I
sort of hinted that in that thread already:

https://lkml.org/lkml/2014/6/4/54

> 
> To track CC, we intercept the scheduler in 1) enqueue, 2) dequeue, 3)
> scheduler tick, and 4) enter/exit idle.
> 
> After CC, in the consolidation part, we do 1) attach the CPU topology to be
> adaptive beyond our experimental platforms, and 2) intercept the current load
> balance for load and load balancing containment.
> 
> Currently, CC is per CPU. To consolidate, the formula is based on a heuristic.
> Suppose we have 2 CPUs, their task concurrency over time is ('-' means no
> task, 'x' having tasks):
> 
> 1)
> CPU0: ---xxxx---------- (CC[0])
> CPU1: ---------xxxx---- (CC[1])
> 
> 2)
> CPU0: ---xxxx---------- (CC[0])
> CPU1: ---xxxx---------- (CC[1])
> 
> If we consolidate CPU0 and CPU1, the consolidated CC will be: CC' = CC[0] +
> CC[1] for case 1 and CC'' = (CC[0] + CC[1]) * 2 for case 2. For the cases in
> between case 1 and 2 in terms of how xxx overlaps, the CC should be between
> CC' and CC''.

The potential worst case consolidated CC sum is:

	n * \sum{cpus}^{n} CC[n]

So, the range in which the true consolidated CC lies grows
proportionally to the number of cpus. We can't really say anything about
how things will pan out if we consolidate on fewer cpus. However, if it
turns out to be a bad mix of tasks the task runnable_avg_sum will go up
and if we use cfs.runnable_load_avg as the indication of compute
capacity requirements, we would eventually spread the load again.
Clearly, we don't want an unstable situation, so it might be better to
the consolidation partially and see where things are going.

> So, we uniformly use this condition for consolidation (suppose
> we consolidate m CPUs to n CPUs, m > n):
> 
> (CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=<? (1 * n) * n *
> consolidating_coefficient

Do you have a rationale behind this heuristic? It seems to be more and
more pessimistic about how much load we can put on 'n' cpus as 'm'
increases. Basically trying to factor in some of the error that be in
the consolidated CC. Why the '(1 * n) * n...' and not just 'n * n * con...'?

Overall, IIUC, the aim of this patch set seems quite similar to the
previous proposals for task packing.

Morten
