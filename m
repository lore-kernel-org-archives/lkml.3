Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbaICJvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:51:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:38986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaICJvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:51:52 -0400
Date: Wed, 3 Sep 2014 11:51:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: luto@amacapital.net, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        mingo@redhat.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, changcheng.liu@intel.com,
        xiaoming.wang@intel.com, souvik.k.chakravarty@intel.com
Subject: Re: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
 idle cpu
Message-ID: <20140903095148.GH4783@worktop.ger.corp.intel.com>
References: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 04:37:30PM +0800, Chuansheng Liu wrote:
> Implementing one new API wake_up_if_idle(), which is used to
> wake up the idle CPU.
> 
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched/core.c   |   16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 857ba40..3f89ac1 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1024,6 +1024,7 @@ struct sched_domain_topology_level {
>  extern struct sched_domain_topology_level *sched_domain_topology;
>  
>  extern void set_sched_topology(struct sched_domain_topology_level *tl);
> +extern void wake_up_if_idle(int cpu);
>  
>  #ifdef CONFIG_SCHED_DEBUG
>  # define SD_INIT_NAME(type)		.name = #type
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1211575..adf104f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1620,6 +1620,22 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  	}
>  }
>  
> +void wake_up_if_idle(int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	unsigned long flags;
> +
> +	if (set_nr_if_polling(rq->idle)) {
> +		trace_sched_wake_idle_without_ipi(cpu);
> +	} else {
> +		raw_spin_lock_irqsave(&rq->lock, flags);
> +		if (rq->curr == rq->idle)

That needs to be is_idle_task(), there might be other 'idle' tasks than
rq->idle :/

> +			smp_send_reschedule(cpu);
> +		/* Else cpu is not in idle, do nothing here */
> +		raw_spin_unlock_irqrestore(&rq->lock, flags);
> +	}
> +}
> +
>  bool cpus_share_cache(int this_cpu, int that_cpu)
>  {
>  	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
> -- 
> 1.7.9.5
> 
