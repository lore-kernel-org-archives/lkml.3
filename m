Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaFJD7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:59:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11824 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754476AbaFJD7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:59:12 -0400
X-IronPort-AV: E=Sophos;i="4.98,1006,1392134400"; 
   d="scan'208";a="31688387"
Message-ID: <539683A6.7040707@cn.fujitsu.com>
Date: Tue, 10 Jun 2014 12:03:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 5/7] rtmutex: Confine deadlock logic to futex
References: <20140609201118.387571774@linutronix.de>	<20140609202336.338874430@linutronix.de> <20140609205908.521f7eba@gandalf.local.home>
In-Reply-To: <20140609205908.521f7eba@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 08:59 AM, Steven Rostedt wrote:
> On Mon, 09 Jun 2014 20:28:09 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
>   
>> +/*
>> + * Futex variant to allow full deadlock detection.
>> + */
>> +int __rt_mutex_timed_lock(struct rt_mutex *lock,
>> +			  struct hrtimer_sleeper *timeout)
>> +{
>> +	might_sleep();
>> +
>> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
>> +				       rt_mutex_slowlock);
>> +}

This futex variant one is not used until next patch, it should not be
introduced in this patch.

>> +
>>  /**
>>   * rt_mutex_timed_lock - lock a rt_mutex interruptible
>>   *			the timeout structure is provided
>>   *			by the caller
>>   *
>> - * @lock: 		the rt_mutex to be locked
>> + * @lock:		the rt_mutex to be locked
>>   * @timeout:		timeout structure or NULL (no timeout)
>> - * @detect_deadlock:	deadlock detection on/off
>>   *
>>   * Returns:
>> - *  0 		on success
>> - * -EINTR 	when interrupted by a signal
>> + *  0		on success
>> + * -EINTR	when interrupted by a signal
>>   * -ETIMEDOUT	when the timeout expired
>> - * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
>>   */
>>  int
>> -rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout,
>> -		    int detect_deadlock)
>> +rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout)
>>  {
>>  	might_sleep();
>>  
>> -	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
>> -				       detect_deadlock, rt_mutex_slowlock);
>> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
>> +				       rt_mutex_slowlock);
>>  }
>>  EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
>>  
> 
> I must be missing something. What's the difference between the above
> and the futex variant one? They both do the exact same thing:
> 

It will use RT_MUTEX_*FULL*_CHAINWALK for the futex variant one while
rt_mutex_timed_lock() will use RT_MUTEX_*MIN*_CHAINWALK

> 
> int foo(struct rt_mutex *lock, struct hrtimer_sleeper *timeout)
> {
> 	might_sleep();
> 
> 	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timout,
> 				       0, rt_mutex_slowlock);
> }
> 
> 
> ??
> 
> -- Steve
> .
> 

