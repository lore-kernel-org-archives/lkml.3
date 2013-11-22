Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3KVKhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:37:51 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35416 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3KVKht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:37:49 -0500
Message-ID: <528F33F9.9000806@gmail.com>
Date: Fri, 22 Nov 2013 11:37:45 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
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
Subject: Re: [PATCH] rtmutex: Fix compare of waiter prio and task prio
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>	<1383831828-15501-10-git-send-email-juri.lelli@gmail.com> <20131121125212.142f2786@gandalf.local.home>
In-Reply-To: <20131121125212.142f2786@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 06:52 PM, Steven Rostedt wrote:
> The conversion of the rt_mutex from using plist to rbtree eliminated
> the use of the waiter->list_entry.prio, and instead used directly the
> waiter->task->prio.
> 
> The problem with this is that the priority inheritance code relies on
> the prio of the waiter being stored is different from the task's prio.
> The change didn't take into account waiter->task == task, which makes
> the compares of:
> 
> 	if (waiter->task->prio == task->prio)
> 
> rather pointless, since they will always be the same:
> 
> 	task->pi_blocked_on = waiter;
> 	waiter->task = task;
> 
> When deadlock detection is not being used (for internal users of
> rt_mutex_lock(); things other than futex), the code relies on
> the prio associated to the waiter being different than the prio
> associated to the task.
> 
> Another use case where this is critical, is when a task that is
> blocked on an rt_mutex has its priority increased by a separate task.
> Then the compare in rt_mutex_adjust_pi() (called from
> sched_setscheduler()), returns without doing anything. This is because
> it checks if the priority of the task is different than the priority of
> its waiter.
> 
> The simple solution is to add a prio member to the rt_mutex_waiter
> structure that associates the priority to the waiter that is separate
> from the task.
> 
> I created a test program that tests this case:
> 
>   http://rostedt.homelinux.com/code/pi_mutex_test.c
> 
> (too big to include in a change log) I'll work on getting this test
> into other projects like LTP and the kernel (perf test?)
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-rt.git/kernel/rtmutex.c
> ===================================================================
> --- linux-rt.git.orig/kernel/rtmutex.c
> +++ linux-rt.git/kernel/rtmutex.c
> @@ -197,7 +197,7 @@ int rt_mutex_getprio(struct task_struct
>  	if (likely(!task_has_pi_waiters(task)))
>  		return task->normal_prio;
>  
> -	return min(task_top_pi_waiter(task)->task->prio,
> +	return min(task_top_pi_waiter(task)->prio,
>  		   task->normal_prio);
>  }
>  
> @@ -336,7 +336,7 @@ static int rt_mutex_adjust_prio_chain(st
>  	 * When deadlock detection is off then we check, if further
>  	 * priority adjustment is necessary.
>  	 */
> -	if (!detect_deadlock && waiter->task->prio == task->prio)
> +	if (!detect_deadlock && waiter->prio == task->prio)
>  		goto out_unlock_pi;
>  
>  	lock = waiter->lock;
> @@ -358,7 +358,7 @@ static int rt_mutex_adjust_prio_chain(st
>  
>  	/* Requeue the waiter */
>  	rt_mutex_dequeue(lock, waiter);
> -	waiter->task->prio = task->prio;
> +	waiter->prio = task->prio;
>  	rt_mutex_enqueue(lock, waiter);
>  
>  	/* Release the task */
> @@ -456,7 +456,7 @@ static int try_to_take_rt_mutex(struct r
>  	 * 3) it is top waiter
>  	 */
>  	if (rt_mutex_has_waiters(lock)) {
> -		if (task->prio >= rt_mutex_top_waiter(lock)->task->prio) {
> +		if (task->prio >= rt_mutex_top_waiter(lock)->prio) {
>  			if (!waiter || waiter != rt_mutex_top_waiter(lock))
>  				return 0;
>  		}
> @@ -516,7 +516,8 @@ static int task_blocks_on_rt_mutex(struc
>  	__rt_mutex_adjust_prio(task);
>  	waiter->task = task;
>  	waiter->lock = lock;
> -	
> +	waiter->prio = task->prio;
> +
>  	/* Get the top priority waiter on the lock */
>  	if (rt_mutex_has_waiters(lock))
>  		top_waiter = rt_mutex_top_waiter(lock);
> @@ -661,7 +662,7 @@ void rt_mutex_adjust_pi(struct task_stru
>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>  
>  	waiter = task->pi_blocked_on;
> -	if (!waiter || (waiter->task->prio == task->prio &&
> +	if (!waiter || (waiter->prio == task->prio &&
>  			!dl_prio(task->prio))) {
>  		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>  		return;
> Index: linux-rt.git/kernel/rtmutex_common.h
> ===================================================================
> --- linux-rt.git.orig/kernel/rtmutex_common.h
> +++ linux-rt.git/kernel/rtmutex_common.h
> @@ -54,6 +54,7 @@ struct rt_mutex_waiter {
>  	struct pid		*deadlock_task_pid;
>  	struct rt_mutex		*deadlock_lock;
>  #endif
> +	int			prio;
>  };
>  
>  /*
> 

Thanks! But, now that waiters have their own prio, don't we need to
enqueue them using that?

Something like:

    rtmutex: enqueue waiters by their prio

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index a2c8ee8..2e960a2 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -96,13 +96,16 @@ static inline int
 rt_mutex_waiter_less(struct rt_mutex_waiter *left,
                     struct rt_mutex_waiter *right)
 {
-       if (left->task->prio < right->task->prio)
+       if (left->prio < right->prio)
                return 1;
 
        /*
-        * If both tasks are dl_task(), we check their deadlines.
+        * If both waiters have dl_prio(), we check the deadlines of the
+        * associated tasks.
+        * If left waiter has a dl_prio(), and we didn't return 1 above,
+        * then right waiter has a dl_prio() too.
         */
-       if (dl_prio(left->task->prio) && dl_prio(right->task->prio))
+       if (dl_prio(left->prio))
                return (left->task->dl.deadline < right->task->dl.deadline);
 
        return 0;

Thanks,

- Juri
