Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3CTPne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:43:34 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59496 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3CTPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <1363737629-16745-2-git-send-email-tj@kernel.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
	<1363737629-16745-2-git-send-email-tj@kernel.org>
Date: Wed, 20 Mar 2013 23:43:30 +0800
Message-ID: <CACvQF53ssw_o4Hbjnp9Z2MZieBO=WhL0Po80jR6NGEjMNGENGA@mail.gmail.com>
Subject: Re: [PATCH 01/10] workqueue: add wq_numa_tbl_len and wq_numa_possible_cpumask[]
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 8:00 AM, Tejun Heo <tj@kernel.org> wrote:
> Unbound workqueues are going to be NUMA-affine.  Add wq_numa_tbl_len
> and wq_numa_possible_cpumask[] in preparation.  The former is the
> highest NUMA node ID + 1 and the latter is masks of possibles CPUs for
> each NUMA node.
>
> This patch only introduces these.  Future patches will make use of
> them.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 775c2f4..9b096e3 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -44,6 +44,7 @@
>  #include <linux/jhash.h>
>  #include <linux/hashtable.h>
>  #include <linux/rculist.h>
> +#include <linux/nodemask.h>
>
>  #include "workqueue_internal.h"
>
> @@ -256,6 +257,11 @@ struct workqueue_struct {
>
>  static struct kmem_cache *pwq_cache;
>
> +static int wq_numa_tbl_len;            /* highest possible NUMA node id + 1 */
> +static cpumask_var_t *wq_numa_possible_cpumask;
> +                                       /* possible CPUs of each node, may
> +                                          be NULL if init failed */
> +
>  static DEFINE_MUTEX(wq_mutex);         /* protects workqueues and pools */
>  static DEFINE_SPINLOCK(pwq_lock);      /* protects pool_workqueues */
>  static DEFINE_SPINLOCK(wq_mayday_lock);        /* protects wq->maydays list */
> @@ -4416,7 +4422,7 @@ out_unlock:
>  static int __init init_workqueues(void)
>  {
>         int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
> -       int i, cpu;
> +       int i, node, cpu;
>
>         /* make sure we have enough bits for OFFQ pool ID */
>         BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
> @@ -4429,6 +4435,33 @@ static int __init init_workqueues(void)
>         cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
>         hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
>
> +       /* determine NUMA pwq table len - highest node id + 1 */
> +       for_each_node(node)
> +               wq_numa_tbl_len = max(wq_numa_tbl_len, node + 1);
> +
> +       /*
> +        * We want masks of possible CPUs of each node which isn't readily
> +        * available.  Build one from cpu_to_node() which should have been
> +        * fully initialized by now.
> +        */
> +       wq_numa_possible_cpumask = kzalloc(wq_numa_tbl_len *
> +                                          sizeof(wq_numa_possible_cpumask[0]),
> +                                          GFP_KERNEL);
> +       BUG_ON(!wq_numa_possible_cpumask);
> +
> +       for_each_node(node)
> +               BUG_ON(!alloc_cpumask_var_node(&wq_numa_possible_cpumask[node],
> +                                              GFP_KERNEL, node));
> +       for_each_possible_cpu(cpu) {
> +               node = cpu_to_node(cpu);
> +               if (WARN_ON(node == NUMA_NO_NODE)) {
> +                       pr_err("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);

since you used WARN_ON(), not BUG_ON(), I think you need to free
allocated memory here.

> +                       wq_numa_possible_cpumask = NULL;
> +                       break;
> +               }
> +               cpumask_set_cpu(cpu, wq_numa_possible_cpumask[node]);
> +       }
> +
>         /* initialize CPU pools */
>         for_each_possible_cpu(cpu) {
>                 struct worker_pool *pool;
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
