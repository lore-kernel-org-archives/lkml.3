Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaDQVUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:20:39 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:5241 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDQVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:20:36 -0400
Message-ID: <5350459F.5010903@hp.com>
Date: Thu, 17 Apr 2014 17:20:31 -0400
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
Subject: Re: [PATCH v9 03/19] qspinlock: Add pending bit
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <1397747051-15401-4-git-send-email-Waiman.Long@hp.com> <20140417154200.GN11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140417154200.GN11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 11:42 AM, Peter Zijlstra wrote:
> On Thu, Apr 17, 2014 at 11:03:55AM -0400, Waiman Long wrote:
>> +/**
>> + * trylock_pending - try to acquire queue spinlock using the pending bit
>> + * @lock : Pointer to queue spinlock structure
>> + * @pval : Pointer to value of the queue spinlock 32-bit word
>> + * Return: 1 if lock acquired, 0 otherwise
>> + */
>> +static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
>> +{
>> +	u32 old, new, val = *pval;
> I'm not thrilled about you breaking this into a separate function; the
> compiler will put it right back and now you get to have that ugly
> pointer stuff.
>
> It also makes the function control flow not match the state diagram
> anymore.

I separate it out primarily to break the pending bit logic away from the 
core MCS queuing logic to make each of them easier to understand as they 
are kind of independent. I fully understand that the compiler will put 
them back together. As I pile on more code, the slowpath function will 
grow bigger making it harder to comprehend and find out where are the 
boundary between them.

I will take a look at the state diagram to see what adjustment will be 
needed.

>> +
>> +	/*
>> +	 * trylock || pending
>> +	 *
>> +	 * 0,0,0 ->  0,0,1 ; trylock
>> +	 * 0,0,1 ->  0,1,1 ; pending
>> +	 */
>> +	for (;;) {
>> +		/*
>> +		 * If we observe any contention; queue.
>> +		 */
>> +		if (val&  ~_Q_LOCKED_MASK)
>> +			return 0;
>> +
>> +		new = _Q_LOCKED_VAL;
>> +		if (val == new)
>> +			new |= _Q_PENDING_VAL;
>> +
>> +		old = atomic_cmpxchg(&lock->val, val, new);
>> +		if (old == val)
>> +			break;
>> +
>> +		*pval = val = old;
>> +	}
>> +
>> +	/*
>> +	 * we won the trylock
>> +	 */
>> +	if (new == _Q_LOCKED_VAL)
>> +		return 1;
>> +
>> +	/*
>> +	 * we're pending, wait for the owner to go away.
>> +	 *
>> +	 * *,1,1 ->  *,1,0
>> +	 */
>> +	while ((val = atomic_read(&lock->val))&  _Q_LOCKED_MASK)
>> +		arch_mutex_cpu_relax();
> That was a cpu_relax().

Yes, but arch_mutex_cpu_relax() is the same as cpu_relax() for x86.

-Longman
