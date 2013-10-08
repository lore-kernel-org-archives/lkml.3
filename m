Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3JHQdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:33:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37151 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3JHQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:33:17 -0400
Date: Tue, 8 Oct 2013 09:32:58 -0700
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
Subject: Re: [PATCH 6/6] rcusync: Introduce rcu_sync_dtor()
Message-ID: <20131008163258.GA5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131008102505.404025673@infradead.org>
 <20131008103830.403651548@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008103830.403651548@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100816-9332-0000-0000-000001B07D59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:25:11PM +0200, Peter Zijlstra wrote:
> From: Oleg Nesterov <oleg@redhat.com>
> 
> Add the new rcu_sync_ops->wait() method and the new helper,
> rcu_sync_dtor().
> 
> It is needed if you are going to, say, kfree(rcu_sync_object).
> It simply calls ops->wait() to "flush" the potentially pending
> rcu callback.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Link: http://lkml.kernel.org/r/20131004184636.GA17560@redhat.com
> ---
>  include/linux/rcusync.h |    1 +
>  kernel/rcusync.c        |   22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> --- a/include/linux/rcusync.h
> +++ b/include/linux/rcusync.h
> @@ -31,6 +31,7 @@ static inline bool rcu_sync_is_idle(stru
>  extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
>  extern void rcu_sync_enter(struct rcu_sync_struct *);
>  extern void rcu_sync_exit(struct rcu_sync_struct *);
> +extern void rcu_sync_dtor(struct rcu_sync_struct *);
> 
>  #define __RCU_SYNC_INITIALIZER(name, type) {				\
>  		.gp_state = 0,						\
> --- a/kernel/rcusync.c
> +++ b/kernel/rcusync.c
> @@ -10,6 +10,7 @@
>  static const struct {
>  	void (*sync)(void);
>  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> +	void (*wait)(void);
>  #ifdef CONFIG_PROVE_RCU
>  	int  (*held)(void);
>  #endif
> @@ -17,16 +18,19 @@ static const struct {
>  	[RCU_SYNC] = {
>  		.sync = synchronize_rcu,
>  		.call = call_rcu,
> +		.wait = rcu_barrier,
>  		__INIT_HELD(rcu_read_lock_held)
>  	},
>  	[RCU_SCHED_SYNC] = {
>  		.sync = synchronize_sched,
>  		.call = call_rcu_sched,
> +		.wait = rcu_barrier_sched,
>  		__INIT_HELD(rcu_read_lock_sched_held)
>  	},
>  	[RCU_BH_SYNC] = {
>  		.sync = synchronize_rcu_bh,
>  		.call = call_rcu_bh,
> +		.wait = rcu_barrier_bh,
>  		__INIT_HELD(rcu_read_lock_bh_held)
>  	},
>  };
> @@ -128,3 +132,21 @@ void rcu_sync_exit(struct rcu_sync_struc
>  	}
>  	spin_unlock_irq(&rss->rss_lock);
>  }
> +
> +void rcu_sync_dtor(struct rcu_sync_struct *rss)
> +{
> +	int cb_state;
> +
> +	BUG_ON(rss->gp_count);
> +
> +	spin_lock_irq(&rss->rss_lock);
> +	if (rss->cb_state == CB_REPLAY)
> +		rss->cb_state = CB_PENDING;
> +	cb_state = rss->cb_state;
> +	spin_unlock_irq(&rss->rss_lock);
> +
> +	if (cb_state != CB_IDLE) {
> +		gp_ops[rss->gp_type].wait();
> +		BUG_ON(rss->cb_state != CB_IDLE);
> +	}
> +}
> 
> 

