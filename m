Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3JHQa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:30:26 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37501 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3JHQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:30:24 -0400
Date: Tue, 8 Oct 2013 09:30:12 -0700
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
Subject: Re: [PATCH 4/6] rcusync: Introduce struct rcu_sync_ops
Message-ID: <20131008163012.GY5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131008102505.404025673@infradead.org>
 <20131008103830.291708447@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008103830.291708447@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100816-3532-0000-0000-000002025BB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:25:09PM +0200, Peter Zijlstra wrote:
> From: Oleg Nesterov <oleg@redhat.com>
> 
> Add the new struct rcu_sync_ops which holds sync/call methods, and
> turn the function pointers in rcu_sync_struct into an array of struct
> rcu_sync_ops.
> 
> This simplifies the "init" helpers, and this way it is simpler to add
> the new methods we need, especially ifdef'ed.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/20131005171746.GA17664@redhat.com

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
> 
> diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
> index 7858491..988ec33 100644
> --- a/include/linux/rcusync.h
> +++ b/include/linux/rcusync.h
> @@ -4,6 +4,8 @@
>  #include <linux/wait.h>
>  #include <linux/rcupdate.h>
> 
> +enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
> +
>  struct rcu_sync_struct {
>  	int			gp_state;
>  	int			gp_count;
> @@ -12,53 +14,37 @@ struct rcu_sync_struct {
>  	int			cb_state;
>  	struct rcu_head		cb_head;
> 
> -	void (*sync)(void);
> -	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> +	enum rcu_sync_type	gp_type;
>  };
> 
> -#define ___RCU_SYNC_INIT(name)						\
> -	.gp_state = 0,							\
> -	.gp_count = 0,							\
> -	.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),		\
> -	.cb_state = 0
> -
> -#define __RCU_SCHED_SYNC_INIT(name) {					\
> -	___RCU_SYNC_INIT(name),						\
> -	.sync = synchronize_sched,					\
> -	.call = call_rcu_sched,						\
> -}
> -
> -#define __RCU_BH_SYNC_INIT(name) {					\
> -	___RCU_SYNC_INIT(name),						\
> -	.sync = synchronize_rcu_bh,					\
> -	.call = call_rcu_bh,						\
> -}
> -
> -#define __RCU_SYNC_INIT(name) {						\
> -	___RCU_SYNC_INIT(name),						\
> -	.sync = synchronize_rcu,					\
> -	.call = call_rcu,						\
> -}
> -
> -#define DEFINE_RCU_SCHED_SYNC(name)					\
> -	struct rcu_sync_struct name = __RCU_SCHED_SYNC_INIT(name)
> -
> -#define DEFINE_RCU_BH_SYNC(name)					\
> -	struct rcu_sync_struct name = __RCU_BH_SYNC_INIT(name)
> -
> -#define DEFINE_RCU_SYNC(name)						\
> -	struct rcu_sync_struct name = __RCU_SYNC_INIT(name)
> -
>  static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
>  {
>  	return !rss->gp_state; /* GP_IDLE */
>  }
> 
> -enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
> -
>  extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
>  extern void rcu_sync_enter(struct rcu_sync_struct *);
>  extern void rcu_sync_exit(struct rcu_sync_struct *);
> 
> +#define __RCU_SYNC_INITIALIZER(name, type) {				\
> +		.gp_state = 0,						\
> +		.gp_count = 0,						\
> +		.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),	\
> +		.cb_state = 0,						\
> +		.gp_type = type,					\
> +	}
> +
> +#define	__DEFINE_RCU_SYNC(name, type)	\
> +	struct rcu_sync_struct name = __RCU_SYNC_INITIALIZER(name, type)
> +
> +#define DEFINE_RCU_SYNC(name)		\
> +	__DEFINE_RCU_SYNC(name, RCU_SYNC)
> +
> +#define DEFINE_RCU_SCHED_SYNC(name)	\
> +	__DEFINE_RCU_SYNC(name, RCU_SCHED_SYNC)
> +
> +#define DEFINE_RCU_BH_SYNC(name)	\
> +	__DEFINE_RCU_SYNC(name, RCU_BH_SYNC)
> +
>  #endif /* _LINUX_RCUSYNC_H_ */
> 
> diff --git a/kernel/rcusync.c b/kernel/rcusync.c
> index f84176a..99051b7 100644
> --- a/kernel/rcusync.c
> +++ b/kernel/rcusync.c
> @@ -1,7 +1,24 @@
> -
>  #include <linux/rcusync.h>
>  #include <linux/sched.h>
> 
> +static const struct {
> +	void (*sync)(void);
> +	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> +} gp_ops[] = {
> +	[RCU_SYNC] = {
> +		.sync = synchronize_rcu,
> +		.call = call_rcu,
> +	},
> +	[RCU_SCHED_SYNC] = {
> +		.sync = synchronize_sched,
> +		.call = call_rcu_sched,
> +	},
> +	[RCU_BH_SYNC] = {
> +		.sync = synchronize_rcu_bh,
> +		.call = call_rcu_bh,
> +	},
> +};
> +
>  enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
>  enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
> 
> @@ -11,23 +28,7 @@ void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
>  {
>  	memset(rss, 0, sizeof(*rss));
>  	init_waitqueue_head(&rss->gp_wait);
> -
> -	switch (type) {
> -	case RCU_SYNC:
> -		rss->sync = synchronize_rcu;
> -		rss->call = call_rcu;
> -		break;
> -
> -	case RCU_SCHED_SYNC:
> -		rss->sync = synchronize_sched;
> -		rss->call = call_rcu_sched;
> -		break;
> -
> -	case RCU_BH_SYNC:
> -		rss->sync = synchronize_rcu_bh;
> -		rss->call = call_rcu_bh;
> -		break;
> -	}
> +	rss->gp_type = type;
>  }
> 
>  void rcu_sync_enter(struct rcu_sync_struct *rss)
> @@ -44,7 +45,7 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
>  	BUG_ON(need_wait && need_sync);
> 
>  	if (need_sync) {
> -		rss->sync();
> +		gp_ops[rss->gp_type].sync();
>  		rss->gp_state = GP_PASSED;
>  		wake_up_all(&rss->gp_wait);
>  	} else if (need_wait) {
> @@ -81,7 +82,7 @@ static void rcu_sync_func(struct rcu_head *rcu)
>  		 * to catch a later GP.
>  		 */
>  		rss->cb_state = CB_PENDING;
> -		rss->call(&rss->cb_head, rcu_sync_func);
> +		gp_ops[rss->gp_type].call(&rss->cb_head, rcu_sync_func);
>  	} else {
>  		/*
>  		 * We're at least a GP after rcu_sync_exit(); eveybody will now
> @@ -99,7 +100,7 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
>  	if (!--rss->gp_count) {
>  		if (rss->cb_state == CB_IDLE) {
>  			rss->cb_state = CB_PENDING;
> -			rss->call(&rss->cb_head, rcu_sync_func);
> +			gp_ops[rss->gp_type].call(&rss->cb_head, rcu_sync_func);
>  		} else if (rss->cb_state == CB_PENDING) {
>  			rss->cb_state = CB_REPLAY;
>  		}
> 
> 
> 

