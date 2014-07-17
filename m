Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbaGQXkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:40:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49228 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233AbaGQXkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:40:32 -0400
Date: Thu, 17 Jul 2014 16:40:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rcu: Remove redundant checks for
 rcu_scheduler_fully_active
Message-ID: <20140717234027.GC8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405475402-7181-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405475402-7181-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071723-3532-0000-0000-0000033AF44C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 09:50:02PM -0400, Pranith Kumar wrote:
> rcu_scheduler_fully_active is set to true early in the boot process.
> 
> rcu_prepare_kthreads() is called in two locations. Once after setting the above
> flag and the other while hotplugging a CPU from rcu_cpu_notify(). CPU hotplug is
> enabled much later by which time the above flag is already set. Hence checking
> for this flag is redundant in this function.
> 
> The checks in rcu_spawn_one_boost_kthread() and rcu_spawn_all_nocb_kthreads()
> are similarly redundant.
> 
> This commit removes the redundant checks for this flag from the above
> locations.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Good catch!  Queued for 3.18.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 17ccb62..a2113f6 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1341,7 +1341,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
>  	if (&rcu_preempt_state != rsp)
>  		return 0;
> 
> -	if (!rcu_scheduler_fully_active || rnp->qsmaskinit == 0)
> +	if (rnp->qsmaskinit == 0)
>  		return 0;
> 
>  	rsp->boost = 1;
> @@ -1489,8 +1489,7 @@ static void rcu_prepare_kthreads(int cpu)
>  	struct rcu_node *rnp = rdp->mynode;
> 
>  	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
> -	if (rcu_scheduler_fully_active)
> -		(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
> +	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
>  }
> 
>  #else /* #ifdef CONFIG_RCU_BOOST */
> @@ -2509,9 +2508,8 @@ static void rcu_spawn_all_nocb_kthreads(int cpu)
>  {
>  	struct rcu_state *rsp;
> 
> -	if (rcu_scheduler_fully_active)
> -		for_each_rcu_flavor(rsp)
> -			rcu_spawn_one_nocb_kthread(rsp, cpu);
> +	for_each_rcu_flavor(rsp)
> +		rcu_spawn_one_nocb_kthread(rsp, cpu);
>  }
> 
>  /*
> -- 
> 1.9.1
> 

