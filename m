Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbaGYP1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:27:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56931 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760616AbaGYP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:27:33 -0400
Date: Fri, 25 Jul 2014 08:27:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] rcu: Create a function for rcu_nocb_mask boot
 time setup
Message-ID: <20140725152729.GD11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406248652-17416-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406248652-17416-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072515-1344-0000-0000-0000030ED29A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 08:37:31PM -0400, Pranith Kumar wrote:
> This commit creates a function rcu_bootup_announce_oddness_nocb(), which handles
> allocation of rcu_nocb_mask and setting it according to the kernel configuration
> parameters.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Much better!

One more change called out below.

							Thanx, Paul

> ---
> v2: don't break the print string (comment from paulmck)
> 
>  kernel/rcu/tree_plugin.h | 61 +++++++++++++++++++++++++++---------------------
>  1 file changed, 35 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index c31eb28..520538a 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -47,6 +47,39 @@ static char __initdata nocb_buf[NR_CPUS * 5];
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
> 
>  /*
> + * This is a helper for rcu_bootup_announce_oddness(), which takes care of
> + * setting up rcu_nocb_mask for nocb specific kernel configuration parameters
> + */
> +static void __init rcu_bootup_announce_oddness_nocb(void)
> +{
> +#ifndef CONFIG_RCU_NOCB_CPU_NONE
> +	if (!have_rcu_nocb_mask) {
> +		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
> +		have_rcu_nocb_mask = true;
> +	}
> +#ifdef CONFIG_RCU_NOCB_CPU_ZERO
> +	pr_info("\tOffload RCU callbacks from CPU 0\n");
> +	cpumask_set_cpu(0, rcu_nocb_mask);
> +#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
> +#ifdef CONFIG_RCU_NOCB_CPU_ALL
> +	pr_info("\tOffload RCU callbacks from all CPUs\n");
> +	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
> +#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
> +#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
> +	if (have_rcu_nocb_mask) {
> +		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
> +			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
> +			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
> +				    rcu_nocb_mask);
> +		}
> +		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
> +		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
> +		if (rcu_nocb_poll)
> +			pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
> +	}
> +}
> +
> +/*
>   * Check the RCU kernel configuration parameters and print informative
>   * messages about anything out of the ordinary.  If you like #ifdef, you
>   * will love this function.
> @@ -86,32 +119,8 @@ static void __init rcu_bootup_announce_oddness(void)
>  	if (nr_cpu_ids != NR_CPUS)
>  		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
>  #ifdef CONFIG_RCU_NOCB_CPU

Please also move the above #ifdef into rcu_bootup_announce_oddness_nocb().
The compiler will inline the resulting empty function, and it is cleaner
to have all of the NOCB-related #ifdefs in that function.

> -#ifndef CONFIG_RCU_NOCB_CPU_NONE
> -	if (!have_rcu_nocb_mask) {
> -		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
> -		have_rcu_nocb_mask = true;
> -	}
> -#ifdef CONFIG_RCU_NOCB_CPU_ZERO
> -	pr_info("\tOffload RCU callbacks from CPU 0\n");
> -	cpumask_set_cpu(0, rcu_nocb_mask);
> -#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
> -#ifdef CONFIG_RCU_NOCB_CPU_ALL
> -	pr_info("\tOffload RCU callbacks from all CPUs\n");
> -	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
> -#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
> -#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
> -	if (have_rcu_nocb_mask) {
> -		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
> -			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
> -			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
> -				    rcu_nocb_mask);
> -		}
> -		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
> -		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
> -		if (rcu_nocb_poll)
> -			pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
> -	}
> -#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
> +	rcu_bootup_announce_oddness_nocb();
> +#endif
>  }
> 
>  #ifdef CONFIG_TREE_PREEMPT_RCU
> -- 
> 2.0.1
> 

