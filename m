Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaFJDoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:44:16 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:54154 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbaFJDoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:44:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140609205329.52b8c0d5@gandalf.local.home>
References: <20140609201118.387571774@linutronix.de>
	<20140609202336.248536613@linutronix.de>
	<20140609205329.52b8c0d5@gandalf.local.home>
Date: Mon, 9 Jun 2014 20:44:15 -0700
X-Google-Sender-Auth: 1QgQAdFh9A5DA0GEl4N9ThPwtBY
Message-ID: <CAGQ1y=5JGLfcQzyrOGYmxW3Us6z9MR8qfOw1sxFvYU6g7M0oog@mail.gmail.com>
Subject: Re: [patch V3 4/7] rtmutex: Siplify remove_waiter()
From: Jason Low <jason.low2@hp.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 5:53 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 09 Jun 2014 20:28:08 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> Exit right away, when the removed waiter was not the top prioriy
>> waiter on the lock. Get rid of the extra indent level.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  kernel/locking/rtmutex.c |   26 ++++++++++----------------
>>  1 file changed, 10 insertions(+), 16 deletions(-)
>>
>> Index: tip/kernel/locking/rtmutex.c
>> ===================================================================
>> --- tip.orig/kernel/locking/rtmutex.c
>> +++ tip/kernel/locking/rtmutex.c
>> @@ -780,7 +780,7 @@ static void remove_waiter(struct rt_mute
>>  {
>>       int first = (waiter == rt_mutex_top_waiter(lock));
>>       struct task_struct *owner = rt_mutex_owner(lock);
>> -     struct rt_mutex *next_lock = NULL;
>> +     struct rt_mutex *next_lock;
>>       unsigned long flags;
>>
>>       raw_spin_lock_irqsave(&current->pi_lock, flags);
>> @@ -788,28 +788,22 @@ static void remove_waiter(struct rt_mute
>>       current->pi_blocked_on = NULL;
>>       raw_spin_unlock_irqrestore(&current->pi_lock, flags);
>>
>
> Add comment here, something like...
>
>         /*
>          * Only update priority if this task was the highest priority
>          * task waiting on the lock, and there is an owner to update.
>          */

Would it also make it clearer if we were to change "first" to something
such as "bool is_top_waiter"?

> Rest looks good.
>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Jason Low <jason.low2@hp.com>

> -- Steve
>
>
>> -     if (!owner)
>> +     if (!owner || !first)
>>               return;
>>
>> -     if (first) {
>> +     raw_spin_lock_irqsave(&owner->pi_lock, flags);
>>
>> -             raw_spin_lock_irqsave(&owner->pi_lock, flags);
>> +     rt_mutex_dequeue_pi(owner, waiter);
>>
>> -             rt_mutex_dequeue_pi(owner, waiter);
>> +     if (rt_mutex_has_waiters(lock))
>> +             rt_mutex_enqueue_pi(owner, rt_mutex_top_waiter(lock));
>>
>> -             if (rt_mutex_has_waiters(lock)) {
>> -                     struct rt_mutex_waiter *next;
>> +     __rt_mutex_adjust_prio(owner);
>>
>> -                     next = rt_mutex_top_waiter(lock);
>> -                     rt_mutex_enqueue_pi(owner, next);
>> -             }
>> -             __rt_mutex_adjust_prio(owner);
>> +     /* Store the lock on which owner is blocked or NULL */
>> +     next_lock = task_blocked_on_lock(owner);
>>
>> -             /* Store the lock on which owner is blocked or NULL */
>> -             next_lock = task_blocked_on_lock(owner);
>> -
>> -             raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
>> -     }
>> +     raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
>>
>>       if (!next_lock)
>>               return;
