Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaJGUPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:15:44 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36956 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbaJGUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:15:41 -0400
From: bsegall@google.com
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, riel@redhat.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com
Subject: Re: [PATCH 4/7] sched: Track group sched_entity usage contributions
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
	<1412684017-16595-5-git-send-email-vincent.guittot@linaro.org>
Date: Tue, 07 Oct 2014 13:15:39 -0700
In-Reply-To: <1412684017-16595-5-git-send-email-vincent.guittot@linaro.org>
	(Vincent Guittot's message of "Tue, 7 Oct 2014 14:13:34 +0200")
Message-ID: <xm26oatnk55g.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Guittot <vincent.guittot@linaro.org> writes:

> From: Morten Rasmussen <morten.rasmussen@arm.com>
>
> Adds usage contribution tracking for group entities. Unlike
> se->avg.load_avg_contrib, se->avg.utilization_avg_contrib for group
> entities is the sum of se->avg.utilization_avg_contrib for all entities on the
> group runqueue. It is _not_ influenced in any way by the task group
> h_load. Hence it is representing the actual cpu usage of the group, not
> its intended load contribution which may differ significantly from the
> utilization on lightly utilized systems.


Just noting that this version also has usage disappear immediately when
a task blocks, although it does what you probably want on migration.

Also, group-ses don't ever use their running_avg_sum so it's kinda a
waste, but I'm not sure it's worth doing anything about.

>
> cc: Paul Turner <pjt@google.com>
> cc: Ben Segall <bsegall@google.com>
>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  kernel/sched/debug.c | 3 +++
>  kernel/sched/fair.c  | 5 +++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index e0fbc0f..efb47ed 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -94,8 +94,10 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
>  	P(se->load.weight);
>  #ifdef CONFIG_SMP
>  	P(se->avg.runnable_avg_sum);
> +	P(se->avg.running_avg_sum);
>  	P(se->avg.avg_period);
>  	P(se->avg.load_avg_contrib);
> +	P(se->avg.utilization_avg_contrib);
>  	P(se->avg.decay_count);
>  #endif
>  #undef PN
> @@ -633,6 +635,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
>  	P(se.avg.running_avg_sum);
>  	P(se.avg.avg_period);
>  	P(se.avg.load_avg_contrib);
> +	P(se.avg.utilization_avg_contrib);
>  	P(se.avg.decay_count);
>  #endif
>  	P(policy);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index d6de526..d3e9067 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2381,6 +2381,8 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
>  		return 0;
>  
>  	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
> +	se->avg.utilization_avg_contrib =
> +			decay_load(se->avg.utilization_avg_contrib, decays);
>  	se->avg.decay_count = 0;
>  
>  	return decays;
> @@ -2525,6 +2527,9 @@ static long __update_entity_utilization_avg_contrib(struct sched_entity *se)
>  
>  	if (entity_is_task(se))
>  		__update_task_entity_utilization(se);
> +	else
> +		se->avg.utilization_avg_contrib =
> +					group_cfs_rq(se)->utilization_load_avg;
>  
>  	return se->avg.utilization_avg_contrib - old_contrib;
>  }
