Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaJ0Tmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:42:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60507 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaJ0Tmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:42:50 -0400
Message-ID: <544EA04F.9080007@arm.com>
Date: Mon, 27 Oct 2014 19:43:11 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "tuukka.tikkanen@linaro.org" <tuukka.tikkanen@linaro.org>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>
Subject: Re: [PATCH RFC 7/7] sched: energy_model: simple cpu frequency scaling
 policy
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org> <1413958051-7103-8-git-send-email-mturquette@linaro.org>
In-Reply-To: <1413958051-7103-8-git-send-email-mturquette@linaro.org>
X-OriginalArrivalTime: 27 Oct 2014 19:42:45.0736 (UTC) FILETIME=[2E55F680:01CFF21E]
X-MC-Unique: 114102719424800301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/14 07:07, Mike Turquette wrote:
> Building on top of the scale invariant capacity patches and earlier

We don't have scale invariant capacity yet but scale invariant
load/utilization.

> patches in this series that prepare CFS for scaling cpu frequency, this
> patch implements a simple, naive ondemand-like cpu frequency scaling
> policy that is driven by enqueue_task_fair and dequeue_tassk_fair. This
> new policy is named "energy_model" as an homage to the on-going work in
> that area. It is NOT an actual energy model.

Maybe it's worth mentioning that you simply take SCHED_CAPACITY_SCALE
and multiply it with the OPP frequency/max frequency of that cpu to get
the capacity at that OPP. You're not using the capacity related energy
values 'struct capacity:cap' from the energy model which would have to
be measured for the particular platform.

[...]

> The policy implemented in this patch takes the highest cpu utilization
> from policy->cpus and uses that select a frequency target based on the
> same 80%/20% thresholds used as defaults in ondemand. Frequenecy-scaled
> thresholds are pre-computed when energy_model inits. The frequency
> selection is a simple comparison of cpu utilization (as defined in
> Morten's latest RFC) to the threshold values. In the future this logic
> could be replaced with something more sophisticated that uses PELT to
> get a historical overview. Ideas are welcome.

This is what I don't grasp. The se utilization contrib and the cfs_rq
utilization are PELT signals and they provide history information? I
mean comparing the cfs_rq utilization PELT signal with a number from an
energy model, that's essentially EAS.

> 
> Note that the pre-computed thresholds above do not take into account
> micro-architecture differences (SMT or big.LITTLE hardware), only
> frequency invariance.
> 
> Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/cpufreq/Kconfig     |  21 +++
>  include/linux/cpufreq.h     |   3 +
>  kernel/sched/Makefile       |   1 +
>  kernel/sched/energy_model.c | 341 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 366 insertions(+)
>  create mode 100644 kernel/sched/energy_model.c
> 

[...]

> +/**
> + * em_data - per-policy data used by energy_mode
> + * @throttle: bail if current time is less than than ktime_throttle.
> + *                 Derived from THROTTLE_MSEC
> + * @up_threshold:   table of normalized capacity states to determine if cpu
> + *                 should run faster. Derived from UP_THRESHOLD
> + * @down_threshold: table of normalized capacity states to determine if cpu
> + *                 should run slower. Derived from DOWN_THRESHOLD
> + *
> + * struct em_data is the per-policy energy_model-specific data structure. A
> + * per-policy instance of it is created when the energy_model governor receives
> + * the CPUFREQ_GOV_START condition and a pointer to it exists in the gov_data
> + * member of struct cpufreq_policy.
> + *
> + * Readers of this data must call down_read(policy->rwsem). Writers must
> + * call down_write(policy->rwsem).
> + */
> +struct em_data {
> +       /* per-policy throttling */
> +       ktime_t throttle;
> +       unsigned int *up_threshold;
> +       unsigned int *down_threshold;
> +       struct task_struct *task;
> +       atomic_long_t target_freq;
> +       atomic_t need_wake_task;
> +};

On my Chromebook2 (Exynos 5 Octa 5800) I end up with 2 kernel threads
(one for each cluster). There is an 'for_each_online_cpu' in
arch_scale_cpu_freq and I can see that the em data thread is invoked for
both clusters every time. Is this the intended behaviour?

It looks like you achieve the desired behaviour for freq-scaling per
cluster for this system but it's not clear to me how this is done from
the design perspective and what would have to be changed if we want to
run it on a per-cpu frequency scaling system.

Coming back to your question where you should call arch_scale_cpu_freq.
Another issue is for which cpu you should call it? For EAS we want to be
able to either raise the cpu frequency of the busiest cpu or do task
migration away from the busiest cpu. So maybe arch_scale_cpu_freq should
be called later in load_balance when we figured out which one is the
busiest cpu?
This would map nicely to load balance in MC sd level for per-cpu
frequency scaling and in DIE sd level for per-cluster frequency scaling.
But then, where do you hook in to lower the frequency eventually? And
what happens in load-balance for all the other 'sd level <-> per-foo
frequency scaling' combinations?

[...]

> +
> +#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ENERGY_MODEL
> +static
> +#endif
> +struct cpufreq_governor cpufreq_gov_energy_model = {
> +       .name                   = "energy_model",
> +       .governor               = energy_model_setup,
> +       .owner                  = THIS_MODULE,
> +};
> +
> +static int __init energy_model_init(void)
> +{
> +       return cpufreq_register_governor(&cpufreq_gov_energy_model);
> +}
> +

Probably not that important at this stage. I always hit

[    8.601824] ------------[ cut here ]------------
[    8.601869] WARNING: CPU: 6 PID: 3229 at
drivers/cpufreq/cpufreq_governor.c:266 cpufreq_governor_dbs+0x6f4/0x6f8()
[    8.601884] Modules linked in:
[    8.601912] CPU: 6 PID: 3229 Comm: cpufreq-set Not tainted
3.17.0-rc3-00293-g5cf54ebcaea6 #16
[    8.601953] [<c0015224>] (unwind_backtrace) from [<c0011cd4>]
(show_stack+0x18/0x1c)
[    8.601982] [<c0011cd4>] (show_stack) from [<c04c5b28>]
(dump_stack+0x80/0xc0)
[    8.602011] [<c04c5b28>] (dump_stack) from [<c0022fd8>]
(warn_slowpath_common+0x78/0x94)
[    8.602041] [<c0022fd8>] (warn_slowpath_common) from [<c00230a8>]
(warn_slowpath_null+0x24/0x2c)
[    8.602071] [<c00230a8>] (warn_slowpath_null) from [<c03a74c8>]
(cpufreq_governor_dbs+0x6f4/0x6f8)
[    8.602100] [<c03a74c8>] (cpufreq_governor_dbs) from [<c03a1b58>]
(__cpufreq_governor+0x140/0x240)
[    8.602126] [<c03a1b58>] (__cpufreq_governor) from [<c03a31b0>]
(cpufreq_set_policy+0x18c/0x20c)
[    8.602153] [<c03a31b0>] (cpufreq_set_policy) from [<c03a3400>]
(store_scaling_governor+0x78/0xa4)
[    8.602179] [<c03a3400>] (store_scaling_governor) from [<c03a149c>]
(store+0x94/0xc0)
[    8.602207] [<c03a149c>] (store) from [<c015c268>]
(kernfs_fop_write+0xc8/0x188)
[    8.602236] [<c015c268>] (kernfs_fop_write) from [<c00ffc00>]
(vfs_write+0xac/0x1b8)
[    8.602263] [<c00ffc00>] (vfs_write) from [<c010023c>]
(SyS_write+0x48/0x9c)
[    8.602290] [<c010023c>] (SyS_write) from [<c000e600>]
(ret_fast_syscall+0x0/0x30)
[    8.602307] ---[ end trace bedc9e3b94a57ef2 ]---

when I configure CONFIG_CPU_FREQ_DEFAULT_GOV_ENERGY_MODEL=y during
initial system start.

[...]






