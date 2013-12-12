Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3LLQSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:18:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:38446 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3LLQSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:18:05 -0500
Message-ID: <52A9E1AC.7070001@windriver.com>
Date: Thu, 12 Dec 2013 11:17:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue implementation
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com> <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com> <20131212111809.GF21999@twins.programming.kicks-ass.net>
In-Reply-To: <20131212111809.GF21999@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-12 06:18 AM, Peter Zijlstra wrote:
> On Wed, Dec 11, 2013 at 08:06:37PM -0500, Paul Gortmaker wrote:
>> +/*
>> + * Event API
>> + */
>> +#define __swait_event(wq, condition)					\
>> +do {									\
>> +	DEFINE_SWAITER(__wait);						\
>> +									\
>> +	for (;;) {							\
>> +		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
>> +		if (condition)						\
>> +			break;						\
>> +		schedule();						\
>> +	}								\
>> +	swait_finish(&wq, &__wait);					\
>> +} while (0)
>> +
>> +#define __swait_event_interruptible(wq, condition, ret)			\
>> +do {									\
>> +	DEFINE_SWAITER(__wait);						\
>> +									\
>> +	for (;;) {							\
>> +		swait_prepare(&wq, &__wait, TASK_INTERRUPTIBLE);	\
>> +		if (condition)						\
>> +			break;						\
>> +		if (signal_pending(current)) {				\
>> +			ret = -ERESTARTSYS;				\
>> +			break;						\
>> +		}							\
>> +		schedule();						\
>> +	}								\
>> +	swait_finish(&wq, &__wait);					\
>> +} while (0)
>> +
>> +#define __swait_event_interruptible_timeout(wq, condition, ret)		\
>> +do {									\
>> +	DEFINE_SWAITER(__wait);						\
>> +									\
>> +	for (;;) {							\
>> +		swait_prepare(&wq, &__wait, TASK_INTERRUPTIBLE);	\
>> +		if (condition)						\
>> +			break;						\
>> +		if (signal_pending(current)) {				\
>> +			ret = -ERESTARTSYS;				\
>> +			break;						\
>> +		}							\
>> +		ret = schedule_timeout(ret);				\
>> +		if (!ret)						\
>> +			break;						\
>> +	}								\
>> +	swait_finish(&wq, &__wait);					\
>> +} while (0)
> 
> Urgh, please have a look at ___wait_event() we just killed all the
> pointless replication for the normal waitqueues, please don't add more
> of it.

Right, I recall seeing that series go by in October ; thanks for
the reminder, I'll clean this up to match what was done in commit
41a1431b178c3b73 and its follow-on commits.

Paul.
--

> 
> 
>> +unsigned int
>> +__swake_up_locked(struct swait_queue_head *head, unsigned int state,
>> +		  unsigned int num)
>> +{
>> +	struct swaiter *curr, *next;
>> +	int woken = 0;
>> +
>> +	list_for_each_entry_safe(curr, next, &head->task_list, node) {
>> +		if (wake_up_state(curr->task, state)) {
>> +			__swait_dequeue(curr);
>> +			/*
>> +			 * The waiting task can free the waiter as
>> +			 * soon as curr->task = NULL is written,
>> +			 * without taking any locks. A memory barrier
>> +			 * is required here to prevent the following
>> +			 * store to curr->task from getting ahead of
>> +			 * the dequeue operation.
>> +			 */
>> +			smp_wmb();
>> +			curr->task = NULL;
>> +			if (++woken == num)
>> +				break;
>> +		}
>> +	}
>> +	return woken;
>> +}
>> +
>> +unsigned int
>> +__swake_up(struct swait_queue_head *head, unsigned int state, unsigned int num)
>> +{
>> +	unsigned long flags;
>> +	int woken;
>> +
>> +	if (!swaitqueue_active(head))
>> +		return 0;
>> +
>> +	raw_spin_lock_irqsave(&head->lock, flags);
>> +	woken = __swake_up_locked(head, state, num);
>> +	raw_spin_unlock_irqrestore(&head->lock, flags);
>> +	return woken;
>> +}
>> +EXPORT_SYMBOL(__swake_up);
> 
> Urgh, fail. Do not put unbounded loops in raw_spin_lock.
> 
> I think I posted a patch a while back to cure this.
> 
> 
