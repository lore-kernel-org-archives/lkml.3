Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3FQN7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:59:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44721 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3FQN7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:59:31 -0400
Date: Mon, 17 Jun 2013 15:59:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 8/9] sched: consider runnable load average in
 move_tasks
Message-ID: <20130617135909.GY3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-9-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370589652-24549-9-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:20:51PM +0800, Alex Shi wrote:
> Except using runnable load average in background, move_tasks is also
> the key functions in load balance. We need consider the runnable load
> average in it in order to the apple to apple load comparison.
> 
> Morten had caught a div u64 bug on ARM, thanks!
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index eadd2e7..3aa1dc0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4178,11 +4178,14 @@ static int tg_load_down(struct task_group *tg, void *data)
>  	long cpu = (long)data;
>  
>  	if (!tg->parent) {
> -		load = cpu_rq(cpu)->load.weight;
> +		load = cpu_rq(cpu)->avg.load_avg_contrib;
>  	} else {
> +		unsigned long tmp_rla;
> +		tmp_rla = tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
> +
>  		load = tg->parent->cfs_rq[cpu]->h_load;
> -		load *= tg->se[cpu]->load.weight;
> -		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
> +		load *= tg->se[cpu]->avg.load_avg_contrib;
> +		load /= tmp_rla;
>  	}
>  
>  	tg->cfs_rq[cpu]->h_load = load;
> @@ -4208,12 +4211,9 @@ static void update_h_load(long cpu)
>  static unsigned long task_h_load(struct task_struct *p)
>  {
>  	struct cfs_rq *cfs_rq = task_cfs_rq(p);
> -	unsigned long load;
> -
> -	load = p->se.load.weight;
> -	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
>  
> -	return load;
> +	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
> +			cfs_rq->runnable_load_avg + 1);
>  }
>  #else
>  static inline void update_blocked_averages(int cpu)

Should we not also change the !FAIR_GROUP_SCHED version of task_h_load()
for this?
