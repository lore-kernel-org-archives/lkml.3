Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3EaKTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:19:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41470 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3EaKTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:19:40 -0400
Date: Fri, 31 May 2013 11:19:40 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "riel@redhat.com" <riel@redhat.com>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>
Subject: Re: [patch v7 7/8] sched: consider runnable load average in
 move_tasks
Message-ID: <20130531101940.GC32728@e103034-lin>
References: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
 <1369897324-16646-8-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
In-Reply-To: <1369897324-16646-8-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 31 May 2013 10:19:36.0119 (UTC) FILETIME=[59D41470:01CE5DE8]
X-MC-Unique: 113053111193707001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 08:02:03AM +0100, Alex Shi wrote:
> Except using runnable load average in background, move_tasks is also
> the key functions in load balance. We need consider the runnable load
> average in it in order to the apple to apple load comparison.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index eadd2e7..bb2470a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4178,11 +4178,11 @@ static int tg_load_down(struct task_group *tg, void *data)
>  	long cpu = (long)data;
>  
>  	if (!tg->parent) {
> -		load = cpu_rq(cpu)->load.weight;
> +		load = cpu_rq(cpu)->avg.load_avg_contrib;
>  	} else {
>  		load = tg->parent->cfs_rq[cpu]->h_load;
> -		load *= tg->se[cpu]->load.weight;
> -		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
> +		load *= tg->se[cpu]->avg.load_avg_contrib;
> +		load /= tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;

runnable_load_avg is u64, so you need to use div_u64() similar to how it
is already done in task_h_load() further down in this patch. It doesn't
build on ARM as is.

Fix:
-               load /= tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
+               load = div_u64(load,
				tg->parent->cfs_rq[cpu]->runnable_load_avg + 1);

Morten

>  	}
>  
>  	tg->cfs_rq[cpu]->h_load = load;
> @@ -4210,8 +4210,8 @@ static unsigned long task_h_load(struct task_struct *p)
>  	struct cfs_rq *cfs_rq = task_cfs_rq(p);
>  	unsigned long load;
>  
> -	load = p->se.load.weight;
> -	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
> +	load = p->se.avg.load_avg_contrib;
> +	load = div_u64(load * cfs_rq->h_load, cfs_rq->runnable_load_avg + 1);
>  
>  	return load;
>  }
> -- 
> 1.7.12
> 
> 

