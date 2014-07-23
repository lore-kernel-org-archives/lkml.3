Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaGWM17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:27:59 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35817 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaGWM16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:27:58 -0400
Date: Wed, 23 Jul 2014 05:27:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/16] rcu: Remove redundant checks for
 rcu_scheduler_fully_active
Message-ID: <20140723122752.GM11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-15-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406092194-13004-15-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072312-7164-0000-0000-000003539A03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:09:51AM -0400, Pranith Kumar wrote:
> rcu_scheduler_fully_active is set to true early in the boot process.
> 
> The check for this flag is only needed in rcu_prepare_kthreads() as this
> function is called before the above flag is set. All other checks are redundant.
> Hence this commit removes those redundant checks.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

This might actually work, but the checks are cheap, don't happen very often,
and make it much easier to modify the code.  So sorry, but no.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 9a50e1d..541c776 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1341,7 +1341,7 @@ static void rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
>  	if (&rcu_preempt_state != rsp)
>  		return 0;
> 
> -	if (!rcu_scheduler_fully_active || rnp->qsmaskinit == 0)
> +	if (rnp->qsmaskinit == 0)
>  		return 0;
> 
>  	rsp->boost = 1;
> @@ -1486,9 +1486,10 @@ static void rcu_prepare_kthreads(int cpu)
>  	struct rcu_node *rnp = rdp->mynode;
> 
>  	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
> -	if (rcu_scheduler_fully_active)
> -		rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
> +	if (!rcu_scheduler_fully_active)
> +		return;
> 
> +	rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
>  	rcu_spawn_all_nocb_kthreads(cpu);
>  }
> 
> @@ -2508,9 +2509,8 @@ static void rcu_spawn_all_nocb_kthreads(int cpu)
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
> 2.0.0.rc2
> 

