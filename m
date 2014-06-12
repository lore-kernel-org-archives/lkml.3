Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaFLVIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:08:37 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:17125 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaFLVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:08:35 -0400
Message-ID: <539A16CC.6040104@hp.com>
Date: Thu, 12 Jun 2014 17:08:28 -0400
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
Subject: Re: [PATCH v11 09/16] qspinlock, x86: Allow unfair spinlock in a
 virtual guest
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com> <1401464642-33890-10-git-send-email-Waiman.Long@hp.com> <20140611105402.GL3213@twins.programming.kicks-ass.net> <53990473.7020802@hp.com> <20140612055016.GP6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140612055016.GP6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 01:50 AM, Peter Zijlstra wrote:
> On Wed, Jun 11, 2014 at 09:37:55PM -0400, Long, Wai Man wrote:
>> On 6/11/2014 6:54 AM, Peter Zijlstra wrote:
>>> On Fri, May 30, 2014 at 11:43:55AM -0400, Waiman Long wrote:
>>>> Enabling this configuration feature causes a slight decrease the
>>>> performance of an uncontended lock-unlock operation by about 1-2%
>>>> mainly due to the use of a static key. However, uncontended lock-unlock
>>>> operation are really just a tiny percentage of a real workload. So
>>>> there should no noticeable change in application performance.
>>> No, entirely unacceptable.
>>>
>>>> +#ifdef CONFIG_VIRT_UNFAIR_LOCKS
>>>> +/**
>>>> + * queue_spin_trylock_unfair - try to acquire the queue spinlock unfairly
>>>> + * @lock : Pointer to queue spinlock structure
>>>> + * Return: 1 if lock acquired, 0 if failed
>>>> + */
>>>> +static __always_inline int queue_spin_trylock_unfair(struct qspinlock *lock)
>>>> +{
>>>> +	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
>>>> +
>>>> +	if (!qlock->locked&&  (cmpxchg(&qlock->locked, 0, _Q_LOCKED_VAL) == 0))
>>>> +		return 1;
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +/**
>>>> + * queue_spin_lock_unfair - acquire a queue spinlock unfairly
>>>> + * @lock: Pointer to queue spinlock structure
>>>> + */
>>>> +static __always_inline void queue_spin_lock_unfair(struct qspinlock *lock)
>>>> +{
>>>> +	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
>>>> +
>>>> +	if (likely(cmpxchg(&qlock->locked, 0, _Q_LOCKED_VAL) == 0))
>>>> +		return;
>>>> +	/*
>>>> +	 * Since the lock is now unfair, we should not activate the 2-task
>>>> +	 * pending bit spinning code path which disallows lock stealing.
>>>> +	 */
>>>> +	queue_spin_lock_slowpath(lock, -1);
>>>> +}
>>> Why is this needed?
>> I added the unfair version of lock and trylock as my original version isn't
>> a simple test-and-set lock. Now I changed the core part to use the simple
>> test-and-set lock. However, I still think that an unfair version in the fast
>> path can be helpful to performance when both the unfair lock and paravirt
>> spinlock are enabled. In this case, paravirt spinlock code will disable the
>> unfair lock code in the slowpath, but still allow the unfair version in the
>> fast path to get the best possible performance in a virtual guest.
>>
>> Yes, I could take that out to allow either unfair or paravirt spinlock, but
>> not both. I do think that a little bit of unfairness will help in the
>> virtual environment.
> When will you learn to like simplicity and stop this massive over
> engineering effort?
>
> There's no sane reason to have the test-and-set virt and paravirt locks
> enabled at the same bloody time.
>
> There's 3 distinct cases:
>
>   - native
>   - virt
>   - paravirt
>
> And they do not overlap. Furthermore, if there is any possibility at all
> of not polluting the native code, grab it with both hands.
>
> Native performance is king, try your very utmost bestest to preserve
> that, paravirt is a distant second and nobody sane should care about the
> virt case at all.

The patch won't affect native performance unless the kernel is built 
with VIRT_UNFAIR_LOCKS selected. The same is also true when 
PARAVIRT_SPINLOCKS is selected. There is no way around that.

I do agree that I may over-engineer on this patch, but my main purpose 
is to achieve the best possible performance and so may sacrifice 
simplicity in some cases. Still allowing lock stealing in the fastpath 
is already much simpler than what my original patch was doing with lock 
stealing in the slowpath. If you still think it is too complex, I am 
willing to take that out if it is what I need to get your approval.

Please also review the rests of the pvspinlock patches and let me know 
if you have other comments. I would like to have one more version to go 
and be done with it.

Thanks,
Longman

