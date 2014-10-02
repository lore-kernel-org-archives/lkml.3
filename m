Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaJBUej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:34:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45759 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaJBUei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:34:38 -0400
Date: Thu, 2 Oct 2014 22:34:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
Message-ID: <20141002203428.GI2849@worktop.programming.kicks-ass.net>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
 <CAKfTPtBXP7HQBHL_Z3aAfdsuLP44_0x_e_LmzEw8qVC-2g=M-w@mail.gmail.com>
 <20140925172343.GX23693@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925172343.GX23693@e103034-lin>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:23:43PM +0100, Morten Rasmussen wrote:

> > Why haven't you used arch_scale_freq_capacity which has a similar
> > purpose in scaling the CPU capacity except the additional sched_domain
> > pointer argument ?
> 
> To be honest I'm not happy with introducing another arch-function
> either and I'm happy to change that. It wasn't really clear to me which
> functions that would remain after your cpu_capacity rework patches, so I
> added this one. Now that we have most of the patches for capacity
> scaling and scale-invariant load-tracking on the table I think we have a
> better chance of figuring out which ones are needed and exactly how they
> are supposed to work.
> 
> arch_scale_load_capacity() compensates for both frequency scaling and
> micro-architectural differences, while arch_scale_freq_capacity() only
> for frequency. As long as we can use arch_scale_cpu_capacity() to
> provide the micro-architecture scaling we can just do the scaling in two
> operations rather than one similar to how it is done for capacity in
> update_cpu_capacity(). I can fix that in the next version. It will cost
> an extra function call and multiplication though.
> 
> To make sure that runnable_avg_{sum, period} are still bounded by
> LOAD_AVG_MAX, arch_scale_{cpu,freq}_capacity() must both return a factor
> in the range 0..SCHED_CAPACITY_SCALE.

I would certainly like some words in the Changelog on how and that the
math is still free of overflows. Clearly you've thought about it, so
please feel free to elucidate the rest of us :-)

> > If we take the example of an always running task, its runnable_avg_sum
> > should stay at the LOAD_AVG_MAX value whatever the frequency of the
> > CPU on which it runs. But your change links the max value of
> > runnable_avg_sum with the current frequency of the CPU so an always
> > running task will have a load contribution of 25%
> > your proposed scaling is fine with usage_avg_sum which reflects the
> > effective running time on the CPU but the runnable_avg_sum should be
> > able to reach LOAD_AVG_MAX whatever the current frequency is
> 
> I don't think it makes sense to scale one metric and not the other. You
> will end up with two very different (potentially opposite) views of the
> cpu load/utilization situation in many scenarios. As I see it,
> scale-invariance and load-balancing with scale-invariance present can be
> done in two ways:
> 
> 1. Leave runnable_avg_sum unscaled and scale running_avg_sum.
> se->avg.load_avg_contrib will remain unscaled and so will
> cfs_rq->runnable_load_avg, cfs_rq->blocked_load_avg, and
> weighted_cpuload(). Essentially all the existing load-balancing code
> will continue to use unscaled load. When we want to improve cpu
> utilization and energy-awareness we will have to bypass most of this
> code as it is likely to lead us on the wrong direction since it has a
> potentially wrong view of the cpu load due to the lack of
> scale-invariance.
> 
> 2. Scale both runnable_avg_sum and running_avg_sum. All existing load
> metrics including weighted_cpuload() are scaled and thus more accurate.
> The difference between se->avg.load_avg_contrib and
> se->avg.usage_avg_contrib is the priority scaling and whether or not
> runqueue waiting time is counted. se->avg.load_avg_contrib can only
> reach se->load.weight when running on the fastest cpu at the highest
> frequency, but it is now scale-invariant so we have much better idea
> about how much load we are pulling when load-balancing two cpus running
> at different frequencies. The load-balance code-path still has to be
> audited to see if anything blows up due to the scaling. I haven't
> finished doing that yet. This patch set doesn't include patches to
> address such issues (yet). IMHO, by scaling runnable_avg_sum we can more
> easily make the existing load-balancing code do the right thing.
> 
> For both options we have to go through the existing load-balancing code
> to either change it to use the scale-invariant metric (running_avg_sum)
> when appropriate or to fix bits that don't work properly with a
> scale-invariant runnable_avg_sum and reuse the existing code. I think
> the latter is less intrusive, but I might be wrong.
> 
> Opinions?

/me votes #2, I think the example in the reply is a false one, an always
running task will/should ramp up the cpufreq and get us at full speed
(and yes I'm aware of the case where you're memory bound and raising the
cpu freq isn't going to actually improve performance, but I'm not sure
we want to get/be that smart, esp. at this stage).
