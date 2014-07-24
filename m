Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536AbaGXSUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:20:31 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52545 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391AbaGXSU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:20:26 -0400
Date: Thu, 24 Jul 2014 11:20:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] rcu: Create a function to handle rcu_nocb_mask boot
 time setup
Message-ID: <20140724182020.GR11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406144410-4591-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406144410-4591-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072418-7164-0000-0000-0000035C1592
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 03:40:09PM -0400, Pranith Kumar wrote:
> This commit creates a function rcu_bootup_announce_oddnes_nocb(), which handles
> allocation of rcu_nocb_mask and setting it according to the kernel configuration
> parameters.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Looks good, but needs a bit of help.  The function name needs to be spelled
correctly in the commit log (missing an "s"), and please see below.

Please fix these issues and resend the patch.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 62 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 36 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index c31eb28..730208a 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -47,6 +47,40 @@ static char __initdata nocb_buf[NR_CPUS * 5];
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
> +			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains"
> +					"nonexistent CPUs.\n");

Long strings are an exception to the 80-character rule.  This string
needs to be on one line.  The scripts/checkpatch.pl script should have yelled
at you about this.

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
> @@ -86,32 +120,8 @@ static void __init rcu_bootup_announce_oddness(void)
>  	if (nr_cpu_ids != NR_CPUS)
>  		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
>  #ifdef CONFIG_RCU_NOCB_CPU
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

