Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab3FQLYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:24:09 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:46226 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756097Ab3FQLYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:24:07 -0400
Date: Mon, 17 Jun 2013 12:23:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: power-efficient scheduling design
Message-ID: <20130617112312.GC22090@arm.com>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <20130614160522.GG32728@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614160522.GG32728@e103034-lin>
Thread-Topic: power-efficient scheduling design
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 05:05:22PM +0100, Morten Rasmussen wrote:
> The intention is that the power scheduler will implement the (unified)
> power policy. It gets the current load of the system from the scheduler.
> Based on this information it will adjust the compute capacity available
> to the scheduler and drive frequency changes such that enough compute
> capacity is available to handle the current load. If the total load can
> be handled by a subset of cpus, it will reduce the capacity of the
> excess cpus to 0 (cpu_power=1). Likewise, if the load increases it will
> increase capacity of one or more idle cpus to allow the scheduler to
> spread the load. The power scheduler has knowledge about the power
> topology and will guide the scheduler to idle the most optimum cpus by
> reducing its capacity. Global idle decision will be handled by the power
> scheduler, so cpuidle can over time be reduced to become just a driver,
> once we have added C-state selection to the power scheduler.
> 
> The scheduler is left to focus on scheduling mechanics and finding the
> best possible load balance on the cpu capacities set by the power
> scheduler. It will share a detailed view of the current load with the
> power scheduler to enable it to make the right capacity adjustments. The
> scheduler will need some optimization to cope better with asymmetric
> compute capacities. We may want to reduce capacity of some cpu to
> increase their idle time while letting others take the majority of the
> load.
...
> I'm aware that the scheduler and power scheduler decisions may be
> inextricably linked so we may decide to merge them. However, I think it
> is worth trying to keep the power scheduling decisions out of the
> scheduler until we have proven it infeasible.

Thanks for posting this, I agree with the proposal. I would like to
emphasise that this is a rather "divide and conquer" approach to
reaching a unified solution. Some of the steps involved (not necessarily
in this order):

1. Introduction of a power scheduler (replacing cpufreq governor) aware
   of the overall load and CPU capacities. It requests CPU frequency
   changes from the low-level cpufreq driver and gives hints to the task
   scheduler about load asymmetry (via cpu_power).
2. More accurate task load tracking (an attempt here -
   https://lkml.org/lkml/2013/4/16/289 - but possibly better accuracy
   using CPU cycles or other arch-specific counters).
3. Load balancer improvements for asymmetric CPU performance levels
   (e.g. frequency scaling).
4. Power scheduler driving the CPU idle decisions (replacing the cpuidle
   governor).
5. Power scheduler increased awareness of the run-queues content
   (number of tasks, individual task loads) and load balancer behaviour,
   feeding extra hints back to the load balancer (e.g. only move tasks
   below/above certain load, trigger a load balance).
6. Performance vs power saving tuning (policies).
7. More specific optimisations based on the CPU topology (big.little,
   turbo boost, etc.)
?. Lots of other things based on testing and community reviews.

Step 5 above will further increase the coupling between load balancer
and power scheduler and we could end up with a unified implementation.
But before then it is simpler to reason in terms of (a) better load
balancing in an asymmetric configuration and (b) CPU capacity needed for
the overall load.

-- 
Catalin
