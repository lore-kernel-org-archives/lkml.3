Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaFKVWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:22:35 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:10088 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaFKVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:22:33 -0400
Message-ID: <5398C894.6040808@hp.com>
Date: Wed, 11 Jun 2014 17:22:28 -0400
From: "Long, Wai Man" <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v11 06/16] qspinlock: prolong the stay in the pending
 bit path
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com> <1401464642-33890-7-git-send-email-Waiman.Long@hp.com> <20140611102606.GK3213@twins.programming.kicks-ass.net>
In-Reply-To: <20140611102606.GK3213@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2014 6:26 AM, Peter Zijlstra wrote:
> On Fri, May 30, 2014 at 11:43:52AM -0400, Waiman Long wrote:
>> ---
>>   kernel/locking/qspinlock.c |   18 ++++++++++++++++--
>>   1 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
>> index fc7fd8c..7f10758 100644
>> --- a/kernel/locking/qspinlock.c
>> +++ b/kernel/locking/qspinlock.c
>> @@ -233,11 +233,25 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>>   	 */
>>   	for (;;) {
>>   		/*
>> -		 * If we observe any contention; queue.
>> +		 * If we observe that the queue is not empty or both
>> +		 * the pending and lock bits are set, queue
>>   		 */
>> -		if (val & ~_Q_LOCKED_MASK)
>> +		if ((val & _Q_TAIL_MASK) ||
>> +		    (val == (_Q_LOCKED_VAL|_Q_PENDING_VAL)))
>>   			goto queue;
>>   
>> +		if (val == _Q_PENDING_VAL) {
>> +			/*
>> +			 * Pending bit is set, but not the lock bit.
>> +			 * Assuming that the pending bit holder is going to
>> +			 * set the lock bit and clear the pending bit soon,
>> +			 * it is better to wait than to exit at this point.
>> +			 */
>> +			cpu_relax();
>> +			val = atomic_read(&lock->val);
>> +			continue;
>> +		}
>> +
>>   		new = _Q_LOCKED_VAL;
>>   		if (val == new)
>>   			new |= _Q_PENDING_VAL;
>
> So, again, you just posted a new version without replying to the
> previous discussion; so let me try again, what's wrong with the proposal
> here:
>
>    lkml.kernel.org/r/20140417163640.GT11096@twins.programming.kicks-ass.net
>
>

I thought I had answered you before, maybe the message was lost or the 
answer was not complete. Anyway, I will try to response to your question 
again here.

> Wouldn't something like:
>
>	while (atomic_read(&lock->val) == _Q_PENDING_VAL)
>		cpu_relax();
>
> before the cmpxchg loop have gotten you all this?

That is not exactly the same. The loop will exit if other bits are set or the pending
bit cleared. In the case, we will need to do the same check at the beginning of the
for loop in order to avoid doing an extra cmpxchg that is not necessary.


> I just tried this on my code and I cannot see a difference.

As I said before, I did see a difference with that change. I think it 
depends on the CPU chip that we used for testing. I ran my test on a 
10-core Westmere-EX chip. I run my microbench on different pairs of core 
within the same chip. It produces different results that varies from 
779.5ms to up to 1192ms. Without that patch, the lowest value I can get 
is still close to 800ms, but the highest can be up to 1800ms or so. So I 
believe it is just a matter of timing that you did not observed in your 
test machine.

-Longman

