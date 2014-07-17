Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbaGQXt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:49:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55516 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbaGQXt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:49:26 -0400
Date: Thu, 17 Jul 2014 16:49:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rcu: Check for have_rcu_nocb_mask instead of
 rcu_nocb_mask
Message-ID: <20140717234920.GD8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405632611-29872-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405632611-29872-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071723-6688-0000-0000-0000035EB10C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 05:30:11PM -0400, Pranith Kumar wrote:
> Hi Paul,
> 
> This is something similar to what you found yesterday with tick_nohz_full mask.
> 
> --
> Pranith
> 
> If we configure a kernel with CONFIG_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_NONE=y and
> CONFIG_CPUMASK_OFFSTACK=n and do not pass in a rcu_nocb= boot parameter, the
> cpumask rcu_nocb_mask can be garbage instead of NULL.
> 
> Hence this commit replaces checks for rcu_nocb_mask == NULL with a check for
> have_rcu_nocb_mask.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Good catch!  Could you please forward-port this to current rcu/dev?
This now includes the fix you mentioned above, which generates conflicts.

Could you please also fix the use in rcu_is_nocb_cpu()?

And please see the comment below.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index cedb020..15c00b5 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2542,7 +2542,7 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
>  	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
>  	struct rcu_data *rdp_prev = NULL;
> 
> -	if (rcu_nocb_mask == NULL)
> +	if (!have_rcu_nocb_mask)
>  		return;
>  #ifdef CONFIG_NO_HZ_FULL
>  	cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
> @@ -2575,7 +2575,7 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
>  /* Prevent __call_rcu() from enqueuing callbacks on no-CBs CPUs */
>  static bool init_nocb_callback_list(struct rcu_data *rdp)
>  {
> -	if (rcu_nocb_mask == NULL ||
> +	if (have_rcu_nocb_mask == false ||

This should really be "if (!have_rcu_nocb_mask".

Of course, the original should have been "if (!rcu_nocb_mask", but old
habits die hard.  ;-)

>  	    !cpumask_test_cpu(rdp->cpu, rcu_nocb_mask))
>  		return false;
>  	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
> -- 
> 1.9.1
> 

