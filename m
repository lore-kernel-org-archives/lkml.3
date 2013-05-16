Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3EPFtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:49:36 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53079 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3EPFtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:49:31 -0400
Message-ID: <5194735B.5040005@linux.vnet.ibm.com>
Date: Thu, 16 May 2013 13:49:15 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        tglx@linutronix.de, akpm@linux-foundation.org, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v6 6/8] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <1368199049-2798-7-git-send-email-alex.shi@intel.com> <20130513140625.GA15136@twins.programming.kicks-ass.net> <5191E75C.6030903@intel.com>
In-Reply-To: <5191E75C.6030903@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051605-5490-0000-0000-0000037AAF67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alex

On 05/14/2013 03:27 PM, Alex Shi wrote:
[snip]
>  }
> diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c

This patch seems to be based on 3.10-rc1, while below one

[patch v6 3/8] sched: set initial value of runnable avg for new forked task

is conflict with 3.10-rc1... I think it may need some rebase?

Regards,
Michael Wang


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
> 

