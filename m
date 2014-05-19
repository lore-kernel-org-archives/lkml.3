Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaESUaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:30:30 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:25946 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaESUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:30:28 -0400
Message-ID: <537A69DE.5080000@hp.com>
Date: Mon, 19 May 2014 16:30:22 -0400
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
Subject: Re: [PATCH v10 10/19] qspinlock, x86: Allow unfair spinlock in a
 virtual guest
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com> <1399474907-22206-11-git-send-email-Waiman.Long@hp.com> <20140508191228.GS2844@laptop.programming.kicks-ass.net>
In-Reply-To: <20140508191228.GS2844@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 03:12 PM, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 11:01:38AM -0400, Waiman Long wrote:
>
>
> No, we want the unfair thing for VIRT, not PARAVIRT.
>

Yes, you are right. I will change that to VIRT.

>> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
>> index 9e7659e..10e87e1 100644
>> --- a/kernel/locking/qspinlock.c
>> +++ b/kernel/locking/qspinlock.c
>> @@ -227,6 +227,14 @@ static __always_inline int get_qlock(struct qspinlock *lock)
>>   {
>>   	struct __qspinlock *l = (void *)lock;
>>
>> +#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
>> +	if (static_key_false(&paravirt_unfairlocks_enabled))
>> +		/*
>> +		 * Need to use atomic operation to get the lock when
>> +		 * lock stealing can happen.
>> +		 */
>> +		return cmpxchg(&l->locked, 0, _Q_LOCKED_VAL) == 0;
> That's missing {}.

It is a single statement which doesn't need braces according to kernel 
coding style. I could move the comments up a bit to make it easier to read.

>> +#endif
>
>>   	barrier();
>>   	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
>>   	barrier();
>
> But no, what you want is:
>
> static __always_inline bool virt_lock(struct qspinlock *lock)
> {
> #ifdef CONFIG_VIRT_MUCK
> 	if (static_key_false(&virt_unfairlocks_enabled)) {
> 		while (!queue_spin_trylock(lock))
> 			cpu_relax();
>
> 		return true;
> 	}
> #else
> 	return false;
> }
>
>
> void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
> {
> 	if (virt_lock(lock))
> 		return;
>
> 	...
> }

This is a possible way of doing it. I can do that in the patch series to 
simplify it. Hopefully that will speed up the review process and get it 
done quicker.

-Longman
