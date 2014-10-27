Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaJ0Pzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:55:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJ0Pz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:55:27 -0400
Date: Mon, 27 Oct 2014 16:55:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org
Subject: Re: [PATCH RFC 6/7] sched: cfs: cpu frequency scaling based on task
 placement
Message-ID: <20141027155511.GN3219@twins.programming.kicks-ass.net>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
 <1413958051-7103-7-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413958051-7103-7-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:07:30PM -0700, Mike Turquette wrote:
> {en,de}queue_task_fair are updated to track which cpus will have changed
> utilization values as function of task queueing. The affected cpus are
> passed on to arch_eval_cpu_freq for further machine-specific processing
> based on a selectable policy.

Yeah, I'm not sure about the arch eval hook, ideally it'd be all
integrated with the energy model.

> arch_scale_cpu_freq is called from run_rebalance_domains as a way to
> kick off the scaling process (via wake_up_process), so as to prevent
> re-entering the {en,de}queue code.

We might want a better name for that :-) dvfs_set_freq() or whatnot, or
maybe preserve the cpufreq_*() namespace, people seen to know that that
is the linux dvfs name.

> All of the call sites in this patch are up for discussion. Does it make
> sense to track which cpus have updated statistics in enqueue_fair_task?

Like I said, I don't think so, we guestimate and approximate everything
anyhow, don't bother trying to be 'perfect' here, its excessively
expensive.

> I chose this because I wanted to gather statistics for all cpus affected
> in the event CONFIG_FAIR_GROUP_SCHED is enabled. As agreed at LPC14 the
> next version of this patch will focus on the simpler case of not using
> scheduler cgroups, which should remove a good chunk of this code,
> including the cpumask stuff.

Yes please, make the cpumask stuff go away :-)

> Also discussed at LPC14 is that fact that load_balance is a very
> interesting place to do this as frequency can be considered in concert
> with task placement. Please put forth any ideas on a sensible way to do
> this.

Ideally it'd be natural fallout of Morten's energy model.

If you take a multi-core energy model, find its bifurcations and map its
solution spaces I suspect there to be a fairly small set of actual
behaviours.

The problem is, nobody seems to have done this yet so we don't know.

Once you've done this, you can try and minimize the model by proving you
retain all behaviour modes, but for now Morten has a rather full
parameter space (not complete though, and the impact of the missing
parameters might or might not be relevant, impossible to prove until we
have the above done).

> Is run_rebalance_domains a logical place to change cpu frequency? What
> other call sites make sense?

For the legacy systems, maybe.

> Even for platforms that can target a cpu frequency without sleeping
> (x86, some ARM platforms with PM microcontrollers) it is currently
> necessary to always kick the frequency target work out into a kthread.
> This is because of the rw_sem usage in the cpufreq core which might
> sleep. Replacing that lock type is probably a good idea.

I think it would be best to start with this, ideally we'd be able to RCU
free the thing such that either holding the rwsem or rcu_read_lock is
sufficient for usage, that way the sleeping muck can grab the rwsem, the
non-sleeping stuff can grab rcu_read_lock.

But I've not looked at the cpufreq stuff at all.
