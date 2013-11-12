Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3KLOzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:55:07 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:7107 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab3KLOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:56 -0500
Message-ID: <52824130.5030404@hp.com>
Date: Tue, 12 Nov 2013 09:54:40 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v5 4/4] MCS Lock: Barrier corrections
References: <cover.1383935697.git.tim.c.chen@linux.intel.com>  <1383940358.11046.417.camel@schen9-DESK>  <20131111181049.GL28302@mudshark.cambridge.arm.com> <1384204673.10046.6.camel@schen9-mobl3>
In-Reply-To: <1384204673.10046.6.camel@schen9-mobl3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 04:17 PM, Tim Chen wrote:
>> You could then augment that with [cmp]xchg_{acquire,release} as
>> appropriate.
>>
>>> +/*
>>>    * In order to acquire the lock, the caller should declare a local node and
>>>    * pass a reference of the node to this function in addition to the lock.
>>>    * If the lock has already been acquired, then this will proceed to spin
>>> @@ -37,15 +62,19 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>>>   	node->locked = 0;
>>>   	node->next   = NULL;
>>>
>>> -	prev = xchg(lock, node);
>>> +	/* xchg() provides a memory barrier */
>>> +	prev = xchg_acquire(lock, node);
>>>   	if (likely(prev == NULL)) {
>>>   		/* Lock acquired */
>>>   		return;
>>>   	}
>>>   	ACCESS_ONCE(prev->next) = node;
>>> -	smp_wmb();
>>> -	/* Wait until the lock holder passes the lock down */
>>> -	while (!ACCESS_ONCE(node->locked))
>>> +	/*
>>> +	 * Wait until the lock holder passes the lock down.
>>> +	 * Using smp_load_acquire() provides a memory barrier that
>>> +	 * ensures subsequent operations happen after the lock is acquired.
>>> +	 */
>>> +	while (!(smp_load_acquire(&node->locked)))
>>>   		arch_mutex_cpu_relax();
> An alternate implementation is
> 	while (!ACCESS_ONCE(node->locked))
> 		arch_mutex_cpu_relax();
> 	smp_load_acquire(&node->locked);
>
> Leaving the smp_load_acquire at the end to provide appropriate barrier.
> Will that be acceptable?
>
> Tim

I second Tim's opinion. It will be help to have a smp_mb_load_acquire() 
function that provide a memory barrier with load-acquire semantic. I 
don't think we need one for store-release as that will not be in a loop.

Peter, what do you think about adding that to your patch?

-Longman
