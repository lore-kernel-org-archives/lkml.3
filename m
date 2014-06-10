Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900AbaFJDqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:46:36 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10580 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933775AbaFJDqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:46:35 -0400
X-IronPort-AV: E=Sophos;i="4.98,1006,1392134400"; 
   d="scan'208";a="31687946"
Message-ID: <539680B4.6050908@cn.fujitsu.com>
Date: Tue, 10 Jun 2014 11:51:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 3/7] rtmutex: Document pi chain walk
References: <20140609201118.387571774@linutronix.de>	<20140609202336.158034184@linutronix.de> <20140609204514.4a1e2da7@gandalf.local.home>
In-Reply-To: <20140609204514.4a1e2da7@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 08:45 AM, Steven Rostedt wrote:
> On Mon, 09 Jun 2014 20:28:08 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> Add commentry to document the chain walk and the protection mechanisms
>> and their scope.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  kernel/locking/rtmutex.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>
>> Index: tip/kernel/locking/rtmutex.c
>> ===================================================================
>> --- tip.orig/kernel/locking/rtmutex.c
>> +++ tip/kernel/locking/rtmutex.c
>> @@ -285,6 +285,47 @@ static inline struct rt_mutex *task_bloc
>>   * @top_task:	the current top waiter
>>   *
>>   * Returns 0 or -EDEADLK.
>> + *
>> + * Chain walk basics and protection scope
>> + *
>> + * [A] refcount on task
>> + * [B] task->pi_lock held
>> + * [C] rtmutex->lock held
> 
> A,B, C is rather meaningless, and requires constant looking back up at
> the key. Perhaps [R],[P] and [L]
> 
>  [R] refcount on task (get_task_struct)
>  [P] task->pi_lock held
>  [L] rtmutex->lock held
> 
> 
> That way we can associate R being refcount, P being pi_lock and L being
> lock. Easier to remember.
> 
> 
>> + *
>> + * call()					Protected by
> 
> "call()"?
> 
>> + *	@task					[A]
>> + *	@orig_lock if != NULL			@top_task is blocked on it
>> + *	@next_lock				Unprotected. Cannot be
>> + *						dereferenced. Only used for
>> + *						comparison.
>> + *	@orig_waiter if != NULL			@top_task is blocked on it
>> + *	@top_task				current, or in case of proxy
>> + *						locking protected by calling
>> + *						code
>> + * again:
>> + *	loop_sanity_check();
>> + * retry:
>> + *	lock(task->pi_lock);			[A] acquire [B]
>> + *	waiter = task->pi_blocked_on;		[B]
>> + *	check_exit_conditions();		[B]
>> + *	lock = waiter->lock;			[B]
>> + *	if (!try_lock(lock->wait_lock)) {	[B] try to acquire [C]
>> + *		unlock(task->pi_lock);		drop [B]
>> + *		goto retry;
>> + *	}
>> + *	check_exit_conditions();		[B] + [C]
>> + *	requeue_lock_waiter(lock, waiter);	[B] + [C]
>> + *	unlock(task->pi_lock);			drop [B]
>> + *	drop_task_ref(task);			drop [A]
> 
> Maybe just state "put_task_struct()", less abstractions.
> 
>> + *	check_exit_conditions();		[C]
>> + *	task = owner(lock);			[C]
>> + *	get_task_ref(task);			[C] acquire [A]
> 
> get_task_struct()
> 
> -- Steve
> 
>> + *	lock(task->pi_lock);			[C] acquire [B]
>> + *	requeue_pi_waiter(task, waiters(lock));	[B] + [C]
>> + *	check_exit_conditions();		[B] + [C]
>> + *	unlock(task->pi_lock);			drop [B]
>> + *	unlock(lock->wait_lock);		drop [C]
>> + *	goto again;
>>   */

There are four check_exit_conditions()s with the same name but with different locking.

I don't think it is a good a idea to copy the code to the comment of
the function description, we will need to always keep them coincident forever.

I prefer to comment them in the function body or comment them
in higher level abstraction.

>>  static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>>  				      int deadlock_detect,
>> @@ -326,6 +367,12 @@ static int rt_mutex_adjust_prio_chain(st
>>  
>>  		return -EDEADLK;
>>  	}
>> +
>> +	/*
>> +	 * We are fully preemptible here and only hold the refcount on
>> +	 * @task. So everything can have changed under us since the
>> +	 * caller or our own code below (goto retry) dropped all locks.
>> +	 */
>>   retry:
>>  	/*
>>  	 * Task can not go away as we did a get_task() before !
>> @@ -383,6 +430,11 @@ static int rt_mutex_adjust_prio_chain(st
>>  	if (!detect_deadlock && waiter->prio == task->prio)
>>  		goto out_unlock_pi;
>>  
>> +	/*
>> +	 * We need to trylock here as we are holding task->pi_lock,
>> +	 * which is the reverse lock order versus the other rtmutex
>> +	 * operations.
>> +	 */
>>  	lock = waiter->lock;
>>  	if (!raw_spin_trylock(&lock->wait_lock)) {
>>  		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>>
> 
> .
> 

