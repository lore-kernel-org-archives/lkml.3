Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3FELHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:07:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3FELHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:07:06 -0400
Date: Wed, 5 Jun 2013 13:06:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v2 1/3] sched: don't repeat the initialization in
 sched_init()
Message-ID: <20130605110657.GZ8923@twins.programming.kicks-ass.net>
References: <51AD87A8.6080608@linux.vnet.ibm.com>
 <51AD87D0.7020300@linux.vnet.ibm.com>
 <51AEA152.1050609@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AEA152.1050609@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:24:18AM +0800, Michael Wang wrote:
> v2:
> 	Move comments back before init_tg_cfs_entry(). (Thanks for the notify from pjt)
> 
> In sched_init(), there is no need to initialize 'root_task_group.shares' and
> 'root_task_group.cfs_bandwidth' repeatedly.
> 
> CC: Paul Tuner <pjt@google.com>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/core.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..96f69da 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6955,6 +6955,11 @@ void __init sched_init(void)
>  
>  #endif /* CONFIG_CGROUP_SCHED */
>  
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +	root_task_group.shares = ROOT_TASK_GROUP_LOAD;
> +	init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
> +#endif
> +
>  	for_each_possible_cpu(i) {
>  		struct rq *rq;
>  
> @@ -6966,7 +6971,6 @@ void __init sched_init(void)
>  		init_cfs_rq(&rq->cfs);
>  		init_rt_rq(&rq->rt, rq);
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
>  		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
>  		/*
>  		 * How much cpu bandwidth does root_task_group get?
> @@ -6987,7 +6991,6 @@ void __init sched_init(void)
>  		 * We achieve this by letting root_task_group's tasks sit
>  		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
>  		 */
> -		init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
>  		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
>  #endif /* CONFIG_FAIR_GROUP_SCHED */

I would actually like a patch reducing the #ifdef forest there, not
adding to it.

There's no actual harm in doing the initialization mutliple times,
right?
