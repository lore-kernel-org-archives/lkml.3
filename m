Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbaGPMp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:45:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54238 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaGPMpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:45:24 -0400
Date: Wed, 16 Jul 2014 05:45:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] rcu: Use rcu_num_nodes instead of NUM_RCU_NODES
Message-ID: <20140716124515.GQ8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
 <1405463509-2468-3-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405463509-2468-3-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071612-0928-0000-0000-0000036FA218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:31:49PM -0400, Pranith Kumar wrote:
> NUM_RCU_NODES is set at build time and is usually a huge number. We calculate the
> actual number of rcu nodes necessary at boot time based on nr_cpu_ids in
> rcu_init_geometry() and store it in rcu_num_nodes. We should use this variable
> instead of NUM_RCU_NODES.
> 
> This commit changes all such uses of NUM_RCU_NODES to rcu_num_nodes.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/rcu/tree_plugin.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index cedb020..17ccb62 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -46,6 +46,8 @@ static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
>  static char __initdata nocb_buf[NR_CPUS * 5];
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
> 
> +extern int rcu_num_nodes;

This should not be necessary given the existing declaration in
kernel/rcu/tree.c way before the #include of kernel/rcu/tree_plugin.h.

Or did you get a build failure without this?  (And if you did get a build
failure, I would be really curious how that happened!)

So please send an updated patch or tell me how your build managed to fail.

> +
>  /*
>   * Check the RCU kernel configuration parameters and print informative
>   * messages about anything out of the ordinary.  If you like #ifdef, you
> @@ -885,7 +887,7 @@ void synchronize_rcu_expedited(void)
>  	/* Snapshot current state of ->blkd_tasks lists. */
>  	rcu_for_each_leaf_node(rsp, rnp)
>  		sync_rcu_preempt_exp_init(rsp, rnp);
> -	if (NUM_RCU_NODES > 1)
> +	if (rcu_num_nodes > 1)
>  		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
> 
>  	put_online_cpus();
> @@ -1475,7 +1477,7 @@ static void __init rcu_spawn_boost_kthreads(void)
>  	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
>  	rnp = rcu_get_root(rcu_state_p);
>  	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
> -	if (NUM_RCU_NODES > 1) {
> +	if (rcu_num_nodes > 1) {
>  		rcu_for_each_leaf_node(rcu_state_p, rnp)
>  			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
>  	}

For whatever it is worth, the reason that this works is that it is a
perforamnce optimzation and NUM_RCU_NODES is always greater than or
equal to num_rcu_nodes.  Still, your change is a good one.

							Thanx, Paul

