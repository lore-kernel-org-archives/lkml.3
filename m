Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaAOFdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:33:35 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37424 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaAOFdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:33:31 -0500
Message-ID: <52D61DA0.8050206@linux.vnet.ibm.com>
Date: Wed, 15 Jan 2014 13:33:20 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1389758879-19951-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011505-9264-0000-0000-00000547ADCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 12:07 PM, Alex Shi wrote:
> Currently we just try to find least load cpu. If some cpus idled,
> we just pick the first cpu in cpu mask.
> 
> In fact we can get the interrupted idle cpu or the latest idled cpu,
> then we may get the benefit from both latency and power.
> The selected cpu maybe not the best, since other cpu may be interrupted
> during our selecting. But be captious costs too much.

So the idea here is we want to choose the latest idle cpu if we have
multiple idle cpu for choosing, correct?

And I guess that was in order to avoid choosing tickless cpu while there
are un-tickless idle one, is that right?

What confused me is, what about those cpu who just going to recover from
tickless as you mentioned, which means latest idle doesn't mean the best
choice, or even could be the worst (if just two choice, and the longer
tickless one is just going to recover while the latest is going to
tickless).

So what about just check 'ts->tick_stopped' and record one ticking idle
cpu? the cost could be lower than time comparison, we could reduce the
risk may be...(well, not so risky since the logical only works when
system is relaxing with several cpu idle)

Regards,
Michael Wang

> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/fair.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c7395d9..fb52d26 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4167,6 +4167,26 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  			min_load = load;
>  			idlest = i;
>  		}
> +#ifdef CONFIG_NO_HZ_COMMON
> +		/*
> +		 * Coarsely to get the latest idle cpu for shorter latency and
> +		 * possible power benefit.
> +		 */
> +		if (!min_load) {
> +			struct tick_sched *ts = &per_cpu(tick_cpu_sched, i);
> +
> +			s64 latest_wake = 0;
> +			/* idle cpu doing irq */
> +			if (ts->inidle && !ts->idle_active)
> +				idlest = i;
> +			/* the cpu resched */
> +			else if (!ts->inidle)
> +				idlest = i;
> +			/* find latest idle cpu */
> +			else if (ktime_to_us(ts->idle_entrytime) > latest_wake)
> +				idlest = i;
> +		}
> +#endif
>  	}
> 
>  	return idlest;
> 

