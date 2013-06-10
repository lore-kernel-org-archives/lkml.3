Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3FJBwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 21:52:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61063 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3FJBwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 21:52:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,833,1363104000"; 
   d="scan'208";a="7511140"
Message-ID: <51B530AE.3020004@cn.fujitsu.com>
Date: Mon, 10 Jun 2013 09:49:34 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-7-git-send-email-alex.shi@intel.com>
In-Reply-To: <1370589652-24549-7-git-send-email-alex.shi@intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 09:50:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 09:50:30,
	Serialize complete at 2013/06/10 09:50:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 03:20 PM, Alex Shi wrote:

> They are the base values in load balance, update them with rq runnable
> load average, then the load balance will consider runnable load avg
> naturally.
> 
> We also try to include the blocked_load_avg as cpu load in balancing,
> but that cause kbuild performance drop 6% on every Intel machine, and
> aim7/oltp drop on some of 4 CPU sockets machines.

Hi Alex,
   Could you explain me why including the blocked_load_avg causes performance drop ?

Thanks,
Gu

> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>


Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  kernel/sched/fair.c |  5 +++--
>  kernel/sched/proc.c | 17 +++++++++++++++--
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 42c7be0..eadd2e7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2962,7 +2962,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
>  {
> -	return cpu_rq(cpu)->load.weight;
> +	return cpu_rq(cpu)->cfs.runnable_load_avg;
>  }
>  
>  /*
> @@ -3007,9 +3007,10 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
>  	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
> +	unsigned long load_avg = rq->cfs.runnable_load_avg;
>  
>  	if (nr_running)
> -		return rq->load.weight / nr_running;
> +		return load_avg / nr_running;
>  
>  	return 0;
>  }
> diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
> index bb3a6a0..ce5cd48 100644
> --- a/kernel/sched/proc.c
> +++ b/kernel/sched/proc.c
> @@ -501,6 +501,18 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  	sched_avg_update(this_rq);
>  }
>  
> +#ifdef CONFIG_SMP
> +unsigned long get_rq_runnable_load(struct rq *rq)
> +{
> +	return rq->cfs.runnable_load_avg;
> +}
> +#else
> +unsigned long get_rq_runnable_load(struct rq *rq)
> +{
> +	return rq->load.weight;
> +}
> +#endif
> +
>  #ifdef CONFIG_NO_HZ_COMMON
>  /*
>   * There is no sane way to deal with nohz on smp when using jiffies because the
> @@ -522,7 +534,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>  	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> -	unsigned long load = this_rq->load.weight;
> +	unsigned long load = get_rq_runnable_load(this_rq);
>  	unsigned long pending_updates;
>  
>  	/*
> @@ -568,11 +580,12 @@ void update_cpu_load_nohz(void)
>   */
>  void update_cpu_load_active(struct rq *this_rq)
>  {
> +	unsigned long load = get_rq_runnable_load(this_rq);
>  	/*
>  	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>  	 */
>  	this_rq->last_load_update_tick = jiffies;
> -	__update_cpu_load(this_rq, this_rq->load.weight, 1);
> +	__update_cpu_load(this_rq, load, 1);
>  
>  	calc_load_account_active(this_rq);
>  }


