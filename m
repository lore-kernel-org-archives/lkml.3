Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3JHQbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:31:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57926 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3JHQbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:31:11 -0400
Date: Tue, 8 Oct 2013 09:30:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] rcusync: Add the CONFIG_PROVE_RCU checks
Message-ID: <20131008163058.GZ5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131008102505.404025673@infradead.org>
 <20131008103830.347463501@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008103830.347463501@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100816-9332-0000-0000-000001B07B3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:25:10PM +0200, Peter Zijlstra wrote:
> From: Oleg Nesterov <oleg@redhat.com>
> 
> It would be nice to validate that the caller of rcu_sync_is_idle()
> holds the corresponding type of RCU read-side lock. Add the new
> rcu_sync_ops->held() method and change rcu_sync_is_idle() to
> WARN() if it returns false.
> 
> This obviously penalizes the readers (fast-path), but only if
> CONFIG_PROVE_RCU.
> 
> Suggested-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Link: http://lkml.kernel.org/r/20131004184633.GA17557@redhat.com
> ---
>  include/linux/rcusync.h |    6 ++++++
>  kernel/rcusync.c        |   21 +++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> --- a/include/linux/rcusync.h
> +++ b/include/linux/rcusync.h
> @@ -17,9 +17,15 @@ struct rcu_sync_struct {
>  	enum rcu_sync_type	gp_type;
>  };
> 
> +extern bool __rcu_sync_is_idle(struct rcu_sync_struct *);
> +
>  static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
>  {
> +#ifdef CONFIG_PROVE_RCU
> +	return __rcu_sync_is_idle(rss);
> +#else
>  	return !rss->gp_state; /* GP_IDLE */
> +#endif
>  }
> 
>  extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
> --- a/kernel/rcusync.c
> +++ b/kernel/rcusync.c
> @@ -1,21 +1,33 @@
>  #include <linux/rcusync.h>
>  #include <linux/sched.h>
> 
> +#ifdef CONFIG_PROVE_RCU
> +#define __INIT_HELD(func)	.held = func,
> +#else
> +#define __INIT_HELD(func)
> +#endif
> +
>  static const struct {
>  	void (*sync)(void);
>  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> +#ifdef CONFIG_PROVE_RCU
> +	int  (*held)(void);
> +#endif
>  } gp_ops[] = {
>  	[RCU_SYNC] = {
>  		.sync = synchronize_rcu,
>  		.call = call_rcu,
> +		__INIT_HELD(rcu_read_lock_held)
>  	},
>  	[RCU_SCHED_SYNC] = {
>  		.sync = synchronize_sched,
>  		.call = call_rcu_sched,
> +		__INIT_HELD(rcu_read_lock_sched_held)
>  	},
>  	[RCU_BH_SYNC] = {
>  		.sync = synchronize_rcu_bh,
>  		.call = call_rcu_bh,
> +		__INIT_HELD(rcu_read_lock_bh_held)
>  	},
>  };
> 
> @@ -24,6 +36,15 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLA
> 
>  #define	rss_lock	gp_wait.lock
> 
> +#ifdef CONFIG_PROVE_RCU
> +bool __rcu_sync_is_idle(struct rcu_sync_struct *rss)
> +{
> +	WARN_ON(!gp_ops[rss->gp_type].held());
> +	return rss->gp_state == GP_IDLE;
> +}
> +EXPORT_SYMBOL_GPL(__rcu_sync_is_idle);
> +#endif
> +
>  void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
>  {
>  	memset(rss, 0, sizeof(*rss));
> 
> 

