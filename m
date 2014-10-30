Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbaJ3TvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:51:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:55431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbaJ3Tu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:50:59 -0400
Date: Thu, 30 Oct 2014 20:50:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Iulia Manda <iulia.manda21@gmail.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@redhat.com,
        mgorman@suse.de
Subject: Re: [PATCH] kernel: Refactor task_struct to use numa_faults instead
 of numa_* pointers
Message-ID: <20141030195055.GA12706@worktop.programming.kicks-ass.net>
References: <20141030193817.GA17859@winterfell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030193817.GA17859@winterfell>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 09:38:17PM +0200, Iulia Manda wrote:

> +++ b/include/linux/sched.h
> @@ -796,6 +796,15 @@ struct sched_info {
>  };
>  #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
>  
> +#ifdef CONFIG_NUMA_BALANCING
> +enum numa_faults_stats {
> +	NUMA_MEM = 0,
> +	NUMA_CPU,
> +	NUMA_MEMBUF,
> +	NUMA_CPUBUF
> +};
> +#endif

Maybe stick this in kernel/sched/sched.h, I don't think there is need of
this outside of the scheduler.

And please use an existing ifdef wherever possible.

> +++ b/kernel/sched/fair.c
> @@ -895,18 +895,25 @@ pid_t task_numa_group_id(struct task_struct *p)
>  	return p->numa_group ? p->numa_group->gid : 0;
>  }
>  
> -static inline int task_faults_idx(int nid, int priv)
> +/*
> + * The averaged statistics, shared & private, memory & cpu,
> + * occupy the first half of the array. The second half of the
> + * array is for current counters, which are averaged into the
> + * first set by task_numa_placement.
> + */
> +static inline int task_faults_idx(enum numa_faults_stats s, int nid, int priv)
>  {
> -	return NR_NUMA_HINT_FAULT_TYPES * nid + priv;
> +	return s * NR_NUMA_HINT_FAULT_TYPES * nr_node_ids +
> +		NR_NUMA_HINT_FAULT_TYPES * nid + priv;

	return NR_NUMA_HINT_FAULTS_TYPES * (s * nr_node_ids + nid) + priv;

>  }

> @@ -1585,17 +1592,22 @@ static void task_numa_placement(struct task_struct *p)
>  	/* Find the node with the highest number of faults */
>  	for_each_online_node(nid) {

(a)

>  		unsigned long faults = 0, group_faults = 0;
> -		int priv, i;
> +		int priv;
> +		/* Keep track of the offsets in numa_faults array */
> +		int mem_idx, membuf_idx, cpu_idx, cpubuf_idx;

Maybe move the new line on top (a), such that its an inverse xmas tree.


>  			if (p->numa_group) {
> -				/* safe because we can only change our own group */
> -				p->numa_group->faults[i] += diff;
> -				p->numa_group->faults_cpu[i] += f_diff;
> +				/* safe because we can only change our own group

Incorrect multi-line comment style.

> +				 *
> +				 * mem_idx represents the offset for a given
> +				 * nid and priv in a specific region because it
> +				 * is at the beginning of the numa_faults array.
> +				 */
> +				p->numa_group->faults[mem_idx] += diff;
> +				p->numa_group->faults_cpu[mem_idx] += f_diff;
>  				p->numa_group->total_faults += diff;
> -				group_faults += p->numa_group->faults[i];
> +				group_faults += p->numa_group->faults[mem_idx];
>  			}
>  		}
>  

Other than that the patch is surprisingly painless...
