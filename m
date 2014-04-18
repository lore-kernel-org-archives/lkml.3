Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaDRBqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:46:14 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:29461 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDRBqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:46:11 -0400
Message-ID: <535083DC.2040406@hp.com>
Date: Thu, 17 Apr 2014 21:46:04 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 06/19] qspinlock: prolong the stay in the pending bit
 path
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <1397747051-15401-7-git-send-email-Waiman.Long@hp.com> <20140417163640.GT11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140417163640.GT11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 12:36 PM, Peter Zijlstra wrote:
> On Thu, Apr 17, 2014 at 11:03:58AM -0400, Waiman Long wrote:
>> There is a problem in the current trylock_pending() function.  When the
>> lock is free, but the pending bit holder hasn't grabbed the lock&
>> cleared the pending bit yet, the trylock_pending() function will fail.
> I remember seeing some of this..
>
>> It can be seen that the queue spinlock is slower than the ticket
>> spinlock when there are 2 or 3 contending tasks. In all the other case,
>> the queue spinlock is either equal or faster than the ticket spinlock.
> So with my code I get:
>
>          qspinlock	   ticket
>
> local:  2: 8741.853010     2: 8812.042460
> remote: 2: 8549.731795     2: 8709.005695
>
> And that is without this optimization.
>
> Also note that I don't have this cmpxchg loop anymore.

It is a matter of timing. If the contending task enters the pending bit 
code path at the right time, it will be able to get pending bit and 
wait. If it enters at the wrong time, it will bail out and use the 
queuing code path. The patch is just to enlarge the timing windows so 
that it won't bail out so easily.

 From my own testing, using xchg(), for example, will be a bit faster 
than cmpxchg(). The downside of that is that I can guarantee strict 
ordering between a pending bit waiter and a queue waiter. So I need to 
use cmpxchg to set the lock. This didn't slow thing down that much when 
I tested it on a Westmere-EX box, but I saw significant slowdown in 
IvyBridge-EX. That is why I trade the use of xchg() with cmpxchg() at 
the expense of a bit of slowdown in the pending bit code path.

>>   kernel/locking/qspinlock.c |   32 ++++++++++++++++++++++++++++++--
>>   1 files changed, 30 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
>> index 55601b4..497da24 100644
>> --- a/kernel/locking/qspinlock.c
>> +++ b/kernel/locking/qspinlock.c
>> @@ -216,6 +216,7 @@ xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
>>   static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
>>   {
>>   	u32 old, new, val = *pval;
>> +	int retry = 1;
>>
>>   	/*
>>   	 * trylock || pending
>> @@ -225,11 +226,38 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
>>   	 */
>>   	for (;;) {
>>   		/*
>> -		 * If we observe any contention; queue.
>> +		 * If we observe that the queue is not empty,
>> +		 * return and be queued.
>>   		 */
>> -		if (val&  ~_Q_LOCKED_MASK)
>> +		if (val&  _Q_TAIL_MASK)
>>   			return 0;
>>
>> +		if ((val&  _Q_LOCKED_PENDING_MASK) ==
>> +		    (_Q_LOCKED_VAL|_Q_PENDING_VAL)) {
>> +			/*
>> +			 * If both the lock and pending bits are set, we wait
>> +			 * a while to see if that either bit will be cleared.
>> +			 * If that is no change, we return and be queued.
>> +			 */
>> +			if (!retry)
>> +				return 0;
>> +			retry--;
>> +			cpu_relax();
>> +			cpu_relax();
>> +			*pval = val = atomic_read(&lock->val);
>> +			continue;
> Since you gave up optimizing the _Q_PENDING_BITS != 8 case why bother
> with this? The switch from _Q_PENDING_VAL to _Q_LOCKED_VAL is atomic by
> virtue of your (endian challenged) clear_pending_set_locked().

The code is just to extend the timing window a bit more to include cases 
where the lock holder is about to release the lock. It applies to both 
cases. However, it is not strictly necessary and I can take it out.

BTW, I didn't test out your atomic_test_and_set() change. Did it provide 
a noticeable performance benefit when compared with cmpxchg()?

>> +		} else if ((val&  _Q_LOCKED_PENDING_MASK) == _Q_PENDING_VAL) {
>> +			/*
>> +			 * Pending bit is set, but not the lock bit.
>> +			 * Assuming that the pending bit holder is going to
>> +			 * set the lock bit and clear the pending bit soon,
>> +			 * it is better to wait than to exit at this point.
>> +			 */
>> +			cpu_relax();
>> +			*pval = val = atomic_read(&lock->val);
>> +			continue;
>> +		}
>> +
>>   		new = _Q_LOCKED_VAL;
>>   		if (val == new)
>>   			new |= _Q_PENDING_VAL;
> Wouldn't something like:
>
> 	while (atomic_read(&lock->val) == _Q_PENDING_VAL)
> 		cpu_relax();
>
> before the cmpxchg loop have gotten you all this?

Yes, you are right. I don't need to do a bitwise AND with 
_Q_LOCKED_PENDING_MASK. I will try make the loop a bit simpler.

>
> I just tried this on my code and I cannot see a difference.

Again, it is a matter of timing and it depends on the tests that we 
used. My test showed a difference, but not yours. Both can be true.

-Longman
