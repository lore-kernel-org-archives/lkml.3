Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3ANHDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:03:06 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48608 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3ANHDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:03:05 -0500
X-AuditID: 9c930197-b7cefae0000002d7-df-50f3ada5a19b
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/22] sched: add power aware scheduling in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	<1357375071-11793-17-git-send-email-alex.shi@intel.com>
Date: Mon, 14 Jan 2013 16:03:01 +0900
In-Reply-To: <1357375071-11793-17-git-send-email-alex.shi@intel.com> (Alex
	Shi's message of "Sat, 5 Jan 2013 16:37:45 +0800")
Message-ID: <87txqknt5m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 Jan 2013 16:37:45 +0800, Alex Shi wrote:
> This patch add power aware scheduling in fork/exec/wake. It try to
> select cpu from the busiest while still has utilization group. That's
> will save power for other groups.
>
> The trade off is adding a power aware statistics collection in group
> seeking. But since the collection just happened in power scheduling
> eligible condition, the worst case of hackbench testing just drops
> about 2% with powersaving/balance policy. No clear change for
> performance policy.
>
> I had tried to use rq load avg utilisation in this balancing, but since
> the utilisation need much time to accumulate itself. It's unfit for any
> burst balancing. So I use nr_running as instant rq utilisation.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
[snip]
> +/*
> + * Try to collect the task running number and capacity of the doamin.
> + */
> +static void get_sd_power_stats(struct sched_domain *sd,
> +		struct task_struct *p, struct sd_lb_stats *sds)
> +{
> +	struct sched_group *group;
> +	struct sg_lb_stats sgs;
> +	int sd_min_delta = INT_MAX;
> +	int cpu = task_cpu(p);
> +
> +	group = sd->groups;
> +	do {
> +		long g_delta;
> +		unsigned long threshold;
> +
> +		if (!cpumask_test_cpu(cpu, sched_group_mask(group)))
> +			continue;

Why?

That means only local group's stat will be accounted for this domain,
right?  Is it your intension?

Thanks,
Namhyung


> +
> +		memset(&sgs, 0, sizeof(sgs));
> +		get_sg_power_stats(group, sd, &sgs);
> +
> +		if (sched_policy == SCHED_POLICY_POWERSAVING)
> +			threshold = sgs.group_weight;
> +		else
> +			threshold = sgs.group_capacity;
> +
> +		g_delta = threshold - sgs.group_utils;
> +
> +		if (g_delta > 0 && g_delta < sd_min_delta) {
> +			sd_min_delta = g_delta;
> +			sds->group_leader = group;
> +		}
> +
> +		sds->sd_utils += sgs.group_utils;
> +		sds->total_pwr += group->sgp->power;
> +	} while  (group = group->next, group != sd->groups);
> +
> +	sds->sd_capacity = DIV_ROUND_CLOSEST(sds->total_pwr,
> +						SCHED_POWER_SCALE);
> +}
