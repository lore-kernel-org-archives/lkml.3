Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab3IZNqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:46:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3IZNqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:46:12 -0400
Message-ID: <1380203165.9217.10.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 15:46:05 +0200
In-Reply-To: <20130926095812.GR3081@twins.programming.kicks-ass.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
	 <1380099377.8523.9.camel@marge.simpson.net>
	 <20130926095812.GR3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:M8sleEtUlt7R2EiWqgmYTYrKr74VcpvOhUka1fVghQm
 +K/WAT8Gouq0DO0BUozYWyzAdWk0qFpoUAzv+BUrEtQOCli5Ka
 jBSFH3WQcJyO83uJsOuj4bPkQljcG79HKF5839QiQOKZKeRyEQ
 7c7Rm4lUQHDZKfiA2wyW0MDvlL+dqJtVl+rz0lheaHbHuGMBEM
 YNaLlu4/gCEzZwd55quQ2/e1vs9OKydEkBdytyg4j9Bhl1oxLW
 My9TaqUTCjUAW6o/HU99Vg10Orammf2+e9J4ppWyXwlodfUU0h
 WNijZ+JCnx191FlvJiw6lmDb+y+By5qJiJVLn49bajdxUqz1Yo
 lwZXxi8SXEztrZJRJYUWDaS4DQ87PMvixt8VhGW3Y56dD98kYO
 YH/X7aFSvPkaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 11:58 +0200, Peter Zijlstra wrote: 
> On Wed, Sep 25, 2013 at 10:56:17AM +0200, Mike Galbraith wrote:
> > That will make pipe-test go fugly -> pretty, and help very fast/light
> > localhost network, but eat heavier localhost overlap recovery.  We need
> > a working (and cheap) overlap detector scheme, so we can know when there
> > is enough to be worth going after.
> 
> We used to have an overlap detectoring thing.. It went away though.

Yup.. guilty as charged your honor.

> But see if you can make something like the below work?

It'll have the same, preemption etc., problems as the whacked.  Could
bring that back and have another go at making it actually work, maybe
it'll be good enough to cause more gain than pain.

> You could make it a general overlap thing and try without the sync too I
> suppose.. 
> 
> ---
>  include/linux/sched.h |  3 +++
>  kernel/sched/fair.c   | 25 +++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b5344de..5428016 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -974,6 +974,9 @@ struct sched_entity {
>  	u64			vruntime;
>  	u64			prev_sum_exec_runtime;
>  
> +	u64			last_sync_wakeup;
> +	u64			avg_overlap;
> +
>  	u64			nr_migrations;
>  
>  #ifdef CONFIG_SCHEDSTATS
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2b89cd2..47b0d0f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2913,6 +2913,17 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  	struct sched_entity *se = &p->se;
>  	int task_sleep = flags & DEQUEUE_SLEEP;
>  
> +	if (se->last_sync_wakeup) {
> +		u64 overlap;
> +		s64 diff;
> +	       
> +		overlap = rq->clock - se->last_sync_wakeup;
> +		se->last_sync_wakeup = 0;
> +
> +		diff = overlap - se->avg_overlap;
> +		se->avg_overlap += diff >> 8;
> +	}
> +
>  	for_each_sched_entity(se) {
>  		cfs_rq = cfs_rq_of(se);
>  		dequeue_entity(cfs_rq, se, flags);
> @@ -3429,6 +3440,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  	int want_affine = 0;
>  	int sync = wake_flags & WF_SYNC;
>  
> +	if (sync)
> +		p->se.last_sync_wakeup = sched_clock_cpu(cpu);
> +
>  	if (p->nr_cpus_allowed == 1)
>  		return prev_cpu;
>  
> @@ -3461,6 +3475,17 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
>  			prev_cpu = cpu;
>  
> +		/*
> +		 * Don't bother with select_idle_sibling() in the case of a sync wakeup
> +		 * where we know the only running task will soon go-away. Going
> +		 * through select_idle_sibling will only lead to pointless ping-pong.
> +		 */
> +		if (sync && prev_cpu == cpu && cpu_rq(cpu)->nr_running == 1 &&
> +		    current->se.avg_overlap < 10000) {
> +			new_cpu = cpu;
> +			goto unlock;
> +		}
> +
>  		new_cpu = select_idle_sibling(p, prev_cpu);
>  		goto unlock;
>  	}


