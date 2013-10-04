Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3JDTaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:30:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54371 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab3JDTaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:30:02 -0400
Date: Fri, 4 Oct 2013 21:29:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] rcusync: introduce rcu_sync_struct->exclusive mode
Message-ID: <20131004192944.GU15690@laptop.programming.kicks-ass.net>
References: <20131004184614.GA17536@redhat.com>
 <20131004184640.GA17567@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004184640.GA17567@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 08:46:40PM +0200, Oleg Nesterov wrote:
> Add rcu_sync_struct->exclusive boolean set by rcu_sync_init(),
> it obviously controls the exclusiveness of rcu_sync_enter().
> This is what percpu_down_write() actually wants.
> 
> We turn ->gp_wait into "struct completion gp_comp", it is used
> as a resource counter in "exclusive" mode. Otherwise we only use
> its completion->wait member for wait_event/wake_up_all. We never
> mix the completion/wait_queue_head_t operations.
> 
> Note: it would be more clean to do __complete_locked() under
> ->rss_lock in rcu_sync_exit() in the "else" branch, but we don't
> have this trivial helper.

Something equivalent in available functions would be:

	rss->gp_comp.done++;
	__wake_up_locked_key(&rss->gp_comp.wait, TASK_NORMAL, NULL);


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

I suppose we have a hole before or after cb_state to fit exclusive in.,
now it looks like we're going to create another hole before the *ops
pointer.

> @@ -4,7 +4,7 @@
>  enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
>  enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
>  
> -#define	rss_lock	gp_wait.lock
> +#define	rss_lock	gp_comp.wait.lock

Should we, for convenience, also do:

#define rss_wait	gp_comp.wait

>  #ifdef CONFIG_PROVE_RCU
>  #define __INIT_HELD(func)	.held = func,
> @@ -33,11 +33,13 @@ struct rcu_sync_ops rcu_sync_ops_array[] = {
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
> @@ -56,9 +58,13 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
>  	if (need_sync) {
>  		rss->ops->sync();
>  		rss->gp_state = GP_PASSED;
> -		wake_up_all(&rss->gp_wait);
> +		if (!rss->exclusive)
> +			wake_up_all(&rss->gp_comp.wait);
>  	} else if (need_wait) {
> -		wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
> +		if (!rss->exclusive)
> +			wait_event(rss->gp_comp.wait, rss->gp_state == GP_PASSED);
> +		else
> +			wait_for_completion(&rss->gp_comp);

I'm still not entirely sure why we need the completion; we already have
the gp_count variable and a waitqueue; together those should be able to
implement the condition/semaphore variable, no?

wait_for_completion:

	spin_lock_irq(&rss->rss_lock);
	if (rss->gp_count > 0) {
		__wait_event_locked(rss->gp_wait, (rss->gp_count > 0),
					TASK_UNINTERRUPTIBLE, 1, 0);
	}
	spin_unlock_irq(&rss->rss_lock);


complete:

	bool excl = rss->excl;

	spin_lock_irq(&rss->rss_lock);
	if (!--rss_gp_count) {
		__wake_up_locked_key(&rss->gp_comp.wait, TASK_NORMAL, NULL);
	}
	spin_unlock_irq(&rss->rss_lock);


All we would need would be something like:

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -422,7 +422,7 @@ do {									\
 })
 
 
-#define __wait_event_interruptible_locked(wq, condition, exclusive, irq) \
+#define __wait_event_locked(wq, condition, state, exclusive, irq) 	\
 ({									\
 	int __ret = 0;							\
 	DEFINE_WAIT(__wait);						\
@@ -431,8 +431,8 @@ do {									\
 	do {								\
 		if (likely(list_empty(&__wait.task_list)))		\
 			__add_wait_queue_tail(&(wq), &__wait);		\
-		set_current_state(TASK_INTERRUPTIBLE);			\
-		if (signal_pending(current)) {				\
+		set_current_state(state);				\
+		if (___wait_signal_pending(state)) {			\
 			__ret = -ERESTARTSYS;				\
 			break;						\
 		}							\
@@ -451,6 +451,8 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_interruptible_locked(wq, condition, exclusive, irq)\
+	__wait_event_locked(wq, condition, TASK_INTERRUPTIBLE, exclusive, irq)
 
 /**
  * wait_event_interruptible_locked - sleep until a condition gets true
