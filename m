Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbaEJAuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:50:17 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:59552 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbaEJAuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:50:15 -0400
Message-ID: <536D77AE.40306@hp.com>
Date: Fri, 09 May 2014 20:49:50 -0400
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
Subject: Re: [PATCH v10 03/19] qspinlock: Add pending bit
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com> <1399474907-22206-4-git-send-email-Waiman.Long@hp.com> <20140508185712.GM2844@laptop.programming.kicks-ass.net>
In-Reply-To: <20140508185712.GM2844@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 02:57 PM, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 11:01:31AM -0400, Waiman Long wrote:
>> +/**
>> + * trylock_pending - try to acquire queue spinlock using the pending bit
>> + * @lock : Pointer to queue spinlock structure
>> + * @pval : Pointer to value of the queue spinlock 32-bit word
>> + * Return: 1 if lock acquired, 0 otherwise
>> + */
>> +static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
> Still don't like you put it in a separate function, but you don't need
> the pointer thing. Note how after you fail the trylock_pending() you
> touch the second (node) cacheline.
>
>> @@ -110,6 +184,9 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>>
>>   	BUILD_BUG_ON(CONFIG_NR_CPUS>= (1U<<  _Q_TAIL_CPU_BITS));
>>
>> +	if (trylock_pending(lock,&val))
>> +		return;	/* Lock acquired */
>> +
>>   	node = this_cpu_ptr(&mcs_nodes[0]);
>>   	idx = node->count++;
>>   	tail = encode_tail(smp_processor_id(), idx);
>> @@ -119,15 +196,18 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>>   	node->next = NULL;
>>
>>   	/*
>> +	 * we already touched the queueing cacheline; don't bother with pending
>> +	 * stuff.
>> +	 *
>>   	 * trylock || xchg(lock, node)
>>   	 *
>> -	 * 0,0 ->  0,1 ; trylock
>> -	 * p,x ->  n,x ; prev = xchg(lock, node)
>> +	 * 0,0,0 ->  0,0,1 ; trylock
>> +	 * p,y,x ->  n,y,x ; prev = xchg(lock, node)
>>   	 */
> And any value of @val we might have had here is completely out-dated.
> The only thing that makes sense it to set:
>
> 	val = 0;
>
> Which makes us start with a trylock, alternatively we can re-read val.

That is true. I will make the change to get rid of the pointer thing.

As for the separate trylock_pending function, my original goal was to 
have a better delineation of different portions of the code.  Given the 
fact that I broke up the slowpath function into 2 in a later patch, I 
may not really need to separate it out. I will pull it back in the next 
version.

-Longman
