Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3KUDIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:08:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:4405 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906Ab3KUDIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:08:01 -0500
Date: Wed, 20 Nov 2013 22:07:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 09/14] rtmutex: turn the plist into an rb-tree.
Message-ID: <20131120220757.2e9cad94@gandalf.local.home>
In-Reply-To: <1383831828-15501-10-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-10-git-send-email-juri.lelli@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Nov 2013 14:43:43 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> Turn the pi-chains from plist to rb-tree, in the rt_mutex code,
> and provide a proper comparison function for -deadline and
> -priority tasks.
> 
> This is done mainly because:
>  - classical prio field of the plist is just an int, which might
>    not be enough for representing a deadline;
>  - manipulating such a list would become O(nr_deadline_tasks),
>    which might be to much, as the number of -deadline task increases.
> 
> Therefore, an rb-tree is used, and tasks are queued in it according
> to the following logic:
>  - among two -priority (i.e., SCHED_BATCH/OTHER/RR/FIFO) tasks, the
>    one with the higher (lower, actually!) prio wins;
>  - among a -priority and a -deadline task, the latter always wins;
>  - among two -deadline tasks, the one with the earliest deadline
>    wins.
> 
> Queueing and dequeueing functions are changed accordingly, for both
> the list of a task's pi-waiters and the list of tasks blocked on
> a pi-lock.

It will be interesting to see if this affects performance of the -rt
patch, as the pi lists are stressed much more.

Although this looks like it will remove that nasty hack in the -rt
patch where the locks have to call "init_lists()" because plists are
something not initialized easily on static variables.




> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 0dd6aec..4ea7eaa 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -91,10 +91,104 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
>  }
>  #endif
>  
> +static inline int
> +rt_mutex_waiter_less(struct rt_mutex_waiter *left,
> +		     struct rt_mutex_waiter *right)
> +{
> +	if (left->task->prio < right->task->prio)
> +		return 1;
> +
> +	/*
> +	 * If both tasks are dl_task(), we check their deadlines.
> +	 */
> +	if (dl_prio(left->task->prio) && dl_prio(right->task->prio))
> +		return (left->task->dl.deadline < right->task->dl.deadline);

Hmm, actually you only need to check the left task if it has a
dl_prio() or not. If it has a dl_prio, then the only way it could have
not returned with a 1 from the first compare is if the right task also
has a dl_prio().


> +
> +	return 0;
> +}
> +
> +static void
> +rt_mutex_enqueue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
> +{
> +	struct rb_node **link = &lock->waiters.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct rt_mutex_waiter *entry;
> +	int leftmost = 1;
> +
> +	while (*link) {
> +		parent = *link;
> +		entry = rb_entry(parent, struct rt_mutex_waiter, tree_entry);
> +		if (rt_mutex_waiter_less(waiter, entry)) {
> +			link = &parent->rb_left;
> +		} else {
> +			link = &parent->rb_right;
> +			leftmost = 0;
> +		}
> +	}
> +
> +	if (leftmost)
> +		lock->waiters_leftmost = &waiter->tree_entry;
> +
> +	rb_link_node(&waiter->tree_entry, parent, link);
> +	rb_insert_color(&waiter->tree_entry, &lock->waiters);
> +}
> +
> +static void
> +rt_mutex_dequeue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
> +{
> +	if (RB_EMPTY_NODE(&waiter->tree_entry))
> +		return;
> +
> +	if (lock->waiters_leftmost == &waiter->tree_entry)
> +		lock->waiters_leftmost = rb_next(&waiter->tree_entry);
> +
> +	rb_erase(&waiter->tree_entry, &lock->waiters);
> +	RB_CLEAR_NODE(&waiter->tree_entry);
> +}
> +
> +static void
> +rt_mutex_enqueue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
> +{
> +	struct rb_node **link = &task->pi_waiters.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct rt_mutex_waiter *entry;
> +	int leftmost = 1;
> +
> +	while (*link) {
> +		parent = *link;
> +		entry = rb_entry(parent, struct rt_mutex_waiter, pi_tree_entry);
> +		if (rt_mutex_waiter_less(waiter, entry)) {
> +			link = &parent->rb_left;
> +		} else {
> +			link = &parent->rb_right;
> +			leftmost = 0;
> +		}
> +	}
> +
> +	if (leftmost)
> +		task->pi_waiters_leftmost = &waiter->pi_tree_entry;
> +
> +	rb_link_node(&waiter->pi_tree_entry, parent, link);
> +	rb_insert_color(&waiter->pi_tree_entry, &task->pi_waiters);
> +}
> +
> +static void
> +rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
> +{
> +	if (RB_EMPTY_NODE(&waiter->pi_tree_entry))
> +		return;
> +
> +	if (task->pi_waiters_leftmost == &waiter->pi_tree_entry)
> +		task->pi_waiters_leftmost = rb_next(&waiter->pi_tree_entry);
> +
> +	rb_erase(&waiter->pi_tree_entry, &task->pi_waiters);
> +	RB_CLEAR_NODE(&waiter->pi_tree_entry);
> +}
> +
>  /*
> - * Calculate task priority from the waiter list priority
> + * Calculate task priority from the waiter tree priority
>   *
> - * Return task->normal_prio when the waiter list is empty or when
> + * Return task->normal_prio when the waiter tree is empty or when
>   * the waiter is not allowed to do priority boosting
>   */
>  int rt_mutex_getprio(struct task_struct *task)
> @@ -102,7 +196,7 @@ int rt_mutex_getprio(struct task_struct *task)
>  	if (likely(!task_has_pi_waiters(task)))
>  		return task->normal_prio;
>  
> -	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
> +	return min(task_top_pi_waiter(task)->task->prio,
>  		   task->normal_prio);
>  }
>  
> @@ -233,7 +327,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  	 * When deadlock detection is off then we check, if further
>  	 * priority adjustment is necessary.
>  	 */
> -	if (!detect_deadlock && waiter->list_entry.prio == task->prio)
> +	if (!detect_deadlock && waiter->task->prio == task->prio)

This will always be true, as waiter->task == task.

>  		goto out_unlock_pi;
>  
>  	lock = waiter->lock;
> @@ -254,9 +348,9 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  	top_waiter = rt_mutex_top_waiter(lock);
>  
>  	/* Requeue the waiter */
> -	plist_del(&waiter->list_entry, &lock->wait_list);
> -	waiter->list_entry.prio = task->prio;
> -	plist_add(&waiter->list_entry, &lock->wait_list);
> +	rt_mutex_dequeue(lock, waiter);
> +	waiter->task->prio = task->prio;

This is rather pointless, as waiter->task == task.

We need to add a prio to the rt_mutex_waiter structure, because we need
a way to know if the prio changed or not. There's a reason we used the
list_entry.prio and not the task prio.

Then you could substitute all the waiter->task->prio with just
waiter->prio and that should also work.

-- Steve

> +	rt_mutex_enqueue(lock, waiter);
>  
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);

