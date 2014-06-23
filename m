Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbaFWO4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:56:17 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:13158 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbaFWO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:56:14 -0400
Message-ID: <53A8400A.6080602@hp.com>
Date: Mon, 23 Jun 2014 10:56:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v3] lockdep: restrict the use of recursive read_lock with
 qrwlock
References: <1403292166-35530-1-git-send-email-Waiman.Long@hp.com> <20140623070912.GG19860@laptop.programming.kicks-ass.net>
In-Reply-To: <20140623070912.GG19860@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 03:09 AM, Peter Zijlstra wrote:
> On Fri, Jun 20, 2014 at 03:22:46PM -0400, Waiman Long wrote:
>> v2->v3:
>>   - Add a new read mode (3) for rwlock (used in
>>     lock_acquire_shared_cond_recursive()) to avoid conflict with other
>>     use cases of lock_acquire_shared_recursive().
>>
>> v1->v2:
>>   - Use less conditional&  make it easier to read
>>
>> Unlike the original unfair rwlock implementation, queued rwlock
>> will grant lock according to the chronological sequence of the lock
>> requests except when the lock requester is in the interrupt context.
>> As a result, recursive read_lock calls will hang the process if there
>> is a write_lock call somewhere in between the read_lock calls.
>>
>> This patch updates the lockdep implementation to look for recursive
>> read_lock calls when queued rwlock is being used.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
> So this Changelog really won't do. This vn->vn+1 nonsense should not be
> part of the Changelog proper.

I occasionally saw change log with history, and so thought that it might 
be OK. I will take that out in the next patch.

> Also, you failed to mention what prompted you to write this patch; did
> you find an offending site that now triggers a lockdep warning?

This patch was prompted by a btrfs filesystem hangup problem with 
qrwlock which is readily reproducible. I was trying to figure out if 
that hangup was caused by recursive read_lock which looked likely after 
reading their locking code. It turned out that the cause was more 
complex and recursive read_lock wasn't the only problem. Chris Mason had 
sent a fix to Linus which was included in rc2.

With the lockdep change, I also found another recursive read_lock 
problem in the selinux code.
>
> You also fail to mention that the new read state fits, but exhausts, the
> storage in held_lock::read.
>

Will look into that issue a bit more.

>> ---
>>   2 files changed, 19 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
>> index 008388f..0a53d88 100644
>> --- a/include/linux/lockdep.h
>> +++ b/include/linux/lockdep.h
>> @@ -481,13 +481,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
>>   #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
>>   #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
>>   #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
>> +#define lock_acquire_shared_cond_recursive(l, s, t, n, i)	\
>> +	lock_acquire(l, s, t, 3, 1, n, i)
>>   #define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
>>   #define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
>>   #define spin_release(l, n, i)			lock_release(l, n, i)
>>
>>   #define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
>> -#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
>> +#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_cond_recursive(l, s, t, NULL, i)
> Yeah, no. Only the qrwlock has the new cond_recursive thing.

So you mean put the conditional compilation here around the definition 
of rwlock_acquire_read. I can do that.

>>   #define rwlock_release(l, n, i)			lock_release(l, n, i)
>>
>>   #define seqcount_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
>> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
>> index d24e433..7d90ebc 100644
>> --- a/kernel/locking/lockdep.c
>> +++ b/kernel/locking/lockdep.c
>> @@ -67,6 +67,16 @@ module_param(lock_stat, int, 0644);
>>   #define lock_stat 0
>>   #endif
>>
>> +#ifdef CONFIG_QUEUE_RWLOCK
>> +/*
>> +* Queue rwlock only allows read-after-read recursion of the same lock class
>> +* when the latter read is in an interrupt context.
>> +*/
>> +#define allow_recursive_read	in_interrupt()
>> +#else
>> +#define allow_recursive_read	true
>> +#endif
> That #ifdef is entirely inappropriate, the lockdep implementation should
> not depend on this. Furthermore you now added a new read state with
> variable semantics, that's crap.

I will modify it to explicitly say allowing recursive read only in 
interrupt context so that there is no confusion on what it is for.

-Longman
