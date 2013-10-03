Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3JCWBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:01:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41963 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab3JCWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:01:04 -0400
Date: Thu, 3 Oct 2013 15:00:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131003220057.GY5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131002150518.675931976@infradead.org>
 <20131003164117.GD5790@linux.vnet.ibm.com>
 <20131003184001.GM28601@twins.programming.kicks-ass.net>
 <20131003184719.GA11996@redhat.com>
 <20131003192135.GR5790@linux.vnet.ibm.com>
 <20131003193206.GA17796@redhat.com>
 <20131003193319.GB17796@redhat.com>
 <20131003195026.GT5790@linux.vnet.ibm.com>
 <20131003200002.GA23768@redhat.com>
 <20131003211009.GA4127@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003211009.GA4127@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100322-7182-0000-0000-000008A08D5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:10:09PM +0200, Oleg Nesterov wrote:
> On 10/03, Oleg Nesterov wrote:
> >
> > So unless Peter objects I'll write the changelogs (always nontrivial task),
> > test, and send these 2 patches + "add ops->barr() / rcu_sync_wait_for_cb"
> > tomorrow.
> 
> And, can't resist, probably another patch below (incomplete, needs the
> obvious change in cpu.c and the new trivial __complete_locked() helper).
> 
> Hmm. But when I look at wait_for_completion() I think it is buggy. Will
> try to send the fix tomorrow.
> 
> Oleg.
> 
> rcusync: introduce rcu_sync_struct->exclusive mode
> 
> CHANGELOG.

Should the changelog really be in all caps?  (Sorry, couldn't resist...)

One confusion below (mine), otherwise cannot see any obvious problems
with it.  Not that this should count for much, getting a bit punch-drunk
reviewing this sort of code.  ;-)

							Thanx, Paul

> ---
> 
> diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
> index ab787c1..265875c 100644
> --- a/include/linux/rcusync.h
> +++ b/include/linux/rcusync.h
> @@ -1,8 +1,8 @@
>  #ifndef _LINUX_RCUSYNC_H_
>  #define _LINUX_RCUSYNC_H_
> 
> -#include <linux/wait.h>
>  #include <linux/rcupdate.h>
> +#include <linux/completion.h>
> 
>  struct rcu_sync_ops {
>  	void (*sync)(void);
> @@ -15,11 +15,12 @@ struct rcu_sync_ops {
>  struct rcu_sync_struct {
>  	int			gp_state;
>  	int			gp_count;
> -	wait_queue_head_t	gp_wait;
> +	struct completion	gp_comp;
> 
>  	int			cb_state;
>  	struct rcu_head		cb_head;
> 
> +	bool			exclusive;
>  	struct rcu_sync_ops	*ops;
>  };
> 
> @@ -33,31 +34,33 @@ static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
> 
>  enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
> 
> -extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
> +extern void rcu_sync_init(struct rcu_sync_struct *,
> +				enum rcu_sync_type, bool excl);
>  extern void rcu_sync_enter(struct rcu_sync_struct *);
>  extern void rcu_sync_exit(struct rcu_sync_struct *);
> 
>  extern struct rcu_sync_ops rcu_sync_ops_array[];
> 
> -#define __RCU_SYNC_INITIALIZER(name, type) {				\
> +#define __RCU_SYNC_INITIALIZER(name, type, excl) {			\
>  		.gp_state = 0,						\
>  		.gp_count = 0,						\
> -		.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),	\
> +		.gp_comp = COMPLETION_INITIALIZER(name.gp_comp),	\
>  		.cb_state = 0,						\
> +		.exclusive = excl,					\
>  		.ops = rcu_sync_ops_array + (type),			\
>  	}
> 
> -#define	__DEFINE_RCU_SYNC(name, type)	\
> -	struct rcu_sync_struct name = __RCU_SYNC_INITIALIZER(name, type)
> +#define	__DEFINE_RCU_SYNC(name, type, excl)	\
> +	struct rcu_sync_struct name = __RCU_SYNC_INITIALIZER(name, type, excl)
> 
> -#define DEFINE_RCU_SYNC(name)		\
> -	__DEFINE_RCU_SYNC(name, RCU_SYNC)
> +#define DEFINE_RCU_SYNC(name, excl)		\
> +	__DEFINE_RCU_SYNC(name, RCU_SYNC, excl)
> 
> -#define DEFINE_RCU_SCHED_SYNC(name)	\
> -	__DEFINE_RCU_SYNC(name, RCU_SCHED_SYNC)
> +#define DEFINE_RCU_SCHED_SYNC(name, excl)	\
> +	__DEFINE_RCU_SYNC(name, RCU_SCHED_SYNC, excl)
> 
> -#define DEFINE_RCU_BH_SYNC(name)	\
> -	__DEFINE_RCU_SYNC(name, RCU_BH_SYNC)
> +#define DEFINE_RCU_BH_SYNC(name, excl)		\
> +	__DEFINE_RCU_SYNC(name, RCU_BH_SYNC, excl)
> 
>  #endif /* _LINUX_RCUSYNC_H_ */
> 
> diff --git a/kernel/rcusync.c b/kernel/rcusync.c
> index 21cde9b..d8068df 100644
> --- a/kernel/rcusync.c
> +++ b/kernel/rcusync.c
> @@ -4,7 +4,7 @@
>  enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
>  enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
> 
> -#define	rss_lock	gp_wait.lock
> +#define	rss_lock	gp_comp.wait.lock
> 
>  #ifdef CONFIG_PROVE_RCU
>  #define __INIT_HELD(func)	.held = func,
> @@ -30,11 +30,13 @@ struct rcu_sync_ops rcu_sync_ops_array[] = {
>  	},
>  };
> 
> -void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
> +void rcu_sync_init(struct rcu_sync_struct *rss,
> +			enum rcu_sync_type type, bool excl)
>  {
>  	memset(rss, 0, sizeof(*rss));
> -	init_waitqueue_head(&rss->gp_wait);
> +	init_completion(&rss->gp_comp);
>  	rss->ops = rcu_sync_ops_array + type;
> +	rss->exclusive = excl;
>  }
> 
>  void rcu_sync_enter(struct rcu_sync_struct *rss)
> @@ -53,9 +55,13 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
>  	if (need_sync) {
>  		rss->ops->sync();
>  		rss->gp_state = GP_PASSED;
> -		wake_up_all(&rss->gp_wait);
> +		if (!rss->exclusive)
> +			wake_up_all(&rss->gp_comp.wait);

Not sure about the wake_up_all() on a completion, but if we are exclusive,
don't we need to complete() the completion here?

Oh, I guess gp_comp.wait is exactly a wait_queue_head_t, so I guess
you can do wake_up_all() on it...  And the thing we would wake up
is ourselves, and we are already awake.

Never mind!!!

>  	} else if (need_wait) {
> -		wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
> +		if (!rss->exclusive)
> +			wait_event(rss->gp_comp.wait, rss->gp_state == GP_PASSED);
> +		else
> +			wait_for_completion(&rss->gp_comp);
>  	} else {
>  		/*
>  		 * Possible when there's a pending CB from a rcu_sync_exit().
> @@ -110,6 +116,8 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
>  		} else if (rss->cb_state == CB_PENDING) {
>  			rss->cb_state = CB_REPLAY;
>  		}
> +	} else if (rss->exclusive) {
> +		__complete_locked(&rss->gp_comp);
>  	}
>  	spin_unlock_irq(&rss->rss_lock);
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

