Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaBQVy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:54:58 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38317 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaBQVy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:54:57 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 13:54:43 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/3] rcu: Optimize RCU_FAST_NO_HZ for
 RCU_NOCB_CPU_ALL
Message-ID: <20140217215443.GG7941@thin>
References: <20140217214007.GA6609@linux.vnet.ibm.com>
 <1392673227-7066-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392673227-7066-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392673227-7066-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:40:27PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> If CONFIG_RCU_NOCB_CPU_ALL=y, then no CPU will ever have RCU callbacks
> because these callbacks will instead be handled by the rcuo kthreads.
> However, the current version of RCU_FAST_NO_HZ nevertheless checks for RCU
> callbacks.  This commit therefore creates static inline implementations
> of rcu_prepare_for_idle() and rcu_cleanup_after_idle() that are no-ops
> when CONFIG_RCU_NOCB_CPU_ALL=y.

"creates static inline implementations" isn't quite accurate; they're
static, and in the header, and the compiler is likely to inline the
no-op versions, but they're not actually marked as inline.  The commit
message should just say that it turns the implementations into no-ops.

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcu/tree_plugin.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 820b06aefbee..41afc3fbfb6c 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1658,7 +1658,7 @@ extern int tick_nohz_active;
>   * only if it has been awhile since the last time we did so.  Afterwards,
>   * if there are any callbacks ready for immediate invocation, return true.
>   */
> -static bool rcu_try_advance_all_cbs(void)
> +static bool __maybe_unused rcu_try_advance_all_cbs(void)
>  {
>  	bool cbs_ready = false;
>  	struct rcu_data *rdp;
> @@ -1743,6 +1743,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
>   */
>  static void rcu_prepare_for_idle(int cpu)
>  {
> +#ifndef CONFIG_RCU_NOCB_CPU_ALL
>  	struct rcu_data *rdp;
>  	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
>  	struct rcu_node *rnp;
> @@ -1794,6 +1795,7 @@ static void rcu_prepare_for_idle(int cpu)
>  		rcu_accelerate_cbs(rsp, rnp, rdp);
>  		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
>  	}
> +#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
>  }
>  
>  /*
> @@ -1803,11 +1805,12 @@ static void rcu_prepare_for_idle(int cpu)
>   */
>  static void rcu_cleanup_after_idle(int cpu)
>  {
> -
> +#ifndef CONFIG_RCU_NOCB_CPU_ALL
>  	if (rcu_is_nocb_cpu(cpu))
>  		return;
>  	if (rcu_try_advance_all_cbs())
>  		invoke_rcu_core();
> +#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
>  }
>  
>  /*
> -- 
> 1.8.1.5
> 
