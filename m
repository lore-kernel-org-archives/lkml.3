Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934815AbaJ3VmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:42:20 -0400
Received: from theshire.emacs.cl ([192.155.80.235]:36342 "EHLO
	theshire.emacs.cl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaJ3VmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:42:19 -0400
Message-ID: <1414705328.1821.7.camel@linux-t7sj.site>
Subject: Re: [PATCH] kernel: Refactor task_struct to use numa_faults instead
 of numa_* pointers
From: Davidlohr Bueso <dave@stgolabs.net>
To: Iulia Manda <iulia.manda21@gmail.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@redhat.com,
        peterz@infradead.org, mgorman@suse.de
Date: Thu, 30 Oct 2014 14:42:08 -0700
In-Reply-To: <20141030193817.GA17859@winterfell>
References: <20141030193817.GA17859@winterfell>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 21:38 +0200, Iulia Manda wrote:
> This patch simplifies task_struct by removing the four numa_* pointers
> in the same array and replacing them with the array pointer. By doing this,
> the size of task_struct is reduced.

This is always welcome, but for completeness you should specify by how
much on <insert your favorite arch>. afaict you're removing 3 ulong
pointers.

> A new parameter is added to the task_faults_idx function so that it can return
> an index to the correct offset, corresponding with the old precalculated
> pointers.
> 
> All of the code in sched/ that depended on task_faults_idx and numa_* was
> changed in order to match the new logic.
> 
> Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

With some suggestions below.

> ---
>  include/linux/sched.h |   40 ++++++++++--------
>  kernel/sched/core.c   |    3 +-
>  kernel/sched/debug.c  |    4 +-
>  kernel/sched/fair.c   |  110 +++++++++++++++++++++++++------------------------
>  4 files changed, 82 insertions(+), 75 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5e344bb..bf8c19f 100644
> --- a/include/linux/sched.h
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
> +
>  #ifdef CONFIG_TASK_DELAY_ACCT
>  struct task_delay_info {
>  	spinlock_t	lock;
> @@ -1558,28 +1567,23 @@ struct task_struct {
>  	struct numa_group *numa_group;
>  
>  	/*
> -	 * Exponential decaying average of faults on a per-node basis.
> -	 * Scheduling placement decisions are made based on the these counts.
> -	 * The values remain static for the duration of a PTE scan
> +	 * numa_faults is an array split into four regions:
> +	 * faults_memory, faults_cpu, faults_memory_buffer, faults_cpu_buffer
> +	 * in this precise order.
> +	 *
> +	 * faults_memory: Exponential decaying average of faults on a per-node
> +	 * basis. Scheduling placement decisions are made based on these
> +	 * counts. The values remain static for the duration of a PTE scan.
> +	 * faults_cpu: Track the nodes the process was running on when a NUMA
> +	 * hinting fault was incurred.
> +	 * faults_memory_buffer and faults_cpu_buffer: Record faults per node
> +	 * during the current scan window. When the scan completes, the counts
> +	 * in faults_memory and faults_cpu decay and these values are copied.

How about moving these comments to where you have the enum
numa_faults_stats? And just point to that here.

[...]
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

parenthesis here?

Thanks,
Davidlohr

