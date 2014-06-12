Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaFLUsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:48:50 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:23681 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbaFLUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:48:47 -0400
Message-ID: <539A1229.1050309@hp.com>
Date: Thu, 12 Jun 2014 16:48:41 -0400
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
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v11 14/16] pvqspinlock: Add qspinlock para-virtualization
 support
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com> <1401464642-33890-15-git-send-email-Waiman.Long@hp.com> <20140612081731.GM3213@twins.programming.kicks-ass.net>
In-Reply-To: <20140612081731.GM3213@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 04:17 AM, Peter Zijlstra wrote:
> On Fri, May 30, 2014 at 11:44:00AM -0400, Waiman Long wrote:
>> @@ -19,13 +19,46 @@ extern struct static_key virt_unfairlocks_enabled;
>>    * that the clearing the lock bit is done ASAP without artificial delay
>>    * due to compiler optimization.
>>    */
>> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
>> +static __always_inline void __queue_spin_unlock(struct qspinlock *lock)
>> +#else
>>   static inline void queue_spin_unlock(struct qspinlock *lock)
>> +#endif
>>   {
>>   	barrier();
>>   	ACCESS_ONCE(*(u8 *)lock) = 0;
>>   	barrier();
>>   }
>>
>> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
>> +/*
>> + * The lock byte can have a value of _Q_LOCKED_SLOWPATH to indicate
>> + * that it needs to go through the slowpath to do the unlocking.
>> + */
>> +#define _Q_LOCKED_SLOWPATH	(_Q_LOCKED_VAL | 2)
>> +
>> +extern void queue_spin_unlock_slowpath(struct qspinlock *lock);
>> +
>> +static inline void queue_spin_unlock(struct qspinlock *lock)
>> +{
>> +	barrier();
>> +	if (static_key_false(&paravirt_spinlocks_enabled)) {
>> +		/*
>> +		 * Need to atomically clear the lock byte to avoid racing with
>> +		 * queue head waiter trying to set _QLOCK_LOCKED_SLOWPATH.
>> +		 */
>> +		if (likely(cmpxchg((u8 *)lock, _Q_LOCKED_VAL, 0)
>> +				== _Q_LOCKED_VAL))
>> +			return;
>> +		else
>> +			queue_spin_unlock_slowpath(lock);
>> +
>> +	} else {
>> +		__queue_spin_unlock(lock);
>> +	}
>> +	barrier();
>> +}
>> +#endif /* CONFIG_PARAVIRT_SPINLOCKS */
> Ideally we'd make all this use alternatives or so, such that the actual
> function remains short enough to actually inline;
>
> static inline void queue_spin_unlock(struct qspinlock *lock)
> {
> 	pv_spinlock_alternative(
> 		ACCESS_ONCE(*(u8 *)lock) = 0,
> 		pv_queue_spin_unlock(lock));
> }
>
> Or however that trickery works.

I think the paravirt version of the unlock function is already short 
enough. In addition, whenever PARAVIRT_SPINLOCKS is enabled, the 
inlining of the unlock function is disabled so that the jump label 
paravirt_spinlocks_enabled won't be used everywhere in the core kernel 
and the kernel modules. This is true for the ticket spinlock and will 
also be true for the queue spinlock.

I don't have a good understanding of the kernel alternatives mechanism. 
I think it allow boot time modification of the kernel code according to 
the CPU type, for example. The jump label mechanism is similar and is 
much easier to use than the alternatives. I don't see a need to use the 
alternatives unless you saw a big advantage of using it which I am not 
aware of.

-Longman
