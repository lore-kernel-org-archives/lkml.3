Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaLJQ3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:29:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36482 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbaLJQ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:29:36 -0500
Date: Wed, 10 Dec 2014 08:29:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] rcu: use {cpu|node}mask pr_cont and seq output
 functions
Message-ID: <20141210162924.GU25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
 <1418226774-30215-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418226774-30215-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121016-8236-0000-0000-000007A68B4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:52:51AM -0500, Tejun Heo wrote:
> Convert the existing user of cpu{mask|list}_scnprintf() and
> node{mask|list}_scnprintf() which use them just to printk or
> seq_printf() the resulting buffer to use the following functions
> instead respectively.
> 
> * For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().
> 
> * For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().
> 
> Because these conversions usually break up a single output function
> call into multiple, the reduction is LOC isn't too big but it removes
> unnecessary complexity and/or arbitrary limit on the length printed.
> 
> This patch is dependent on the previous patch ("bitmap, cpumask,
> nodemask: implement pr_cont variants of formatting functions") which
> is planned to go through -mm.  It'd be the easiest to route this
> together.  If this should go through the subsystem tree, please wait
> till the forementioned patch is merged to mainline.

It should be OK to send this via your tree.

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/rcu/tree_plugin.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 7a72858..a788a6f 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -53,7 +53,6 @@ DEFINE_PER_CPU(char, rcu_cpu_has_work);
>  static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
>  static bool have_rcu_nocb_mask;	    /* Was rcu_nocb_mask allocated? */
>  static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
> -static char __initdata nocb_buf[NR_CPUS * 5];
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
> 
>  /*
> @@ -2377,8 +2376,9 @@ void __init rcu_init_nohz(void)
>  		cpumask_and(rcu_nocb_mask, cpu_possible_mask,
>  			    rcu_nocb_mask);
>  	}
> -	cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
> -	pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
> +	pr_info("\tOffload RCU callbacks from CPUs: ");
> +	cpulist_pr_cont(rcu_nocb_mask);
> +	pr_cont(".\n");
>  	if (rcu_nocb_poll)
>  		pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
> 
> -- 
> 2.1.0
> 

