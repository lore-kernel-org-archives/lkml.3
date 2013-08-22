Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3HVBEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 21:04:32 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26508 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3HVBEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 21:04:31 -0400
Message-ID: <5215638E.5020702@hp.com>
Date: Wed, 21 Aug 2013 21:04:14 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Alexander Fyodorov <halcy@yandex.ru>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <15321377012704@web8h.yandex.ru> <52142D6C.6000400@hp.com> <336901377100289@web16f.yandex.ru>
In-Reply-To: <336901377100289@web16f.yandex.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 11:51 AM, Alexander Fyodorov wrote:
> 21.08.2013, 07:01, "Waiman Long"<waiman.long@hp.com>:
>> On 08/20/2013 11:31 AM, Alexander Fyodorov wrote:
>>> Isn't a race possible if another thread acquires the spinlock in the window
>>> between setting lock->locked to 0 and issuing smp_wmb()? Writes from
>>> the critical section from our thread might be delayed behind the write to
>>> lock->locked if the corresponding cache bank is busy.
>> The purpose of smp_wmb() is to make sure that content in the cache will
>> be flushed out to the memory in case the cache coherency protocol cannot
>> guarantee a single view of memory content on all processor.
> Linux kernel does not support architectures without cache coherency, and while using memory barriers just for flushing write buffers ASAP on cache-coherent processors might benefit performance on some architectures it will hurt performance on others. So it must not be done in architecture-independent code.
>
>> In other
>> word, smp_wmb() is used to make other processors see that the lock has
>> been freed ASAP. If another processor see that before smp_wmb(), it will
>> be even better as the latency is reduced. As the lock holder is the only
>> one that can release the lock, there is no race condition here.
> No, I was talking about the window between freeing lock and issuing smp_wmb(). What I meant is:
> 1) A = 0
> 2) CPU0 locks the spinlock protecting A.
> 3) CPU0 writes 1 to A, but the write gets stalled because the corresponding cache bank is busy.
> 4) CPU0 calls spin_unlock() and sets lock->locked to 0.
>
> If CPU1 does a spin_lock() right now, it will succeed (since lock->locked == 0). But the write to A hasn't reached cache yet, so CPU1 will see A == 0.
>
> More examples on this are in Documentation/memory-barriers.txt

In this case, we should have smp_wmb() before freeing the lock. The 
question is whether we need to do a full mb() instead. The x86 ticket 
spinlock unlock code is just a regular add instruction except for some 
exotic processors. So it is a compiler barrier but not really a memory 
fence. However, we may need to do a full memory fence for some other 
processors.

>> That is a legitimate question. I don't think it is a problem on x86 as
>> the x86 spinlock code doesn't do a full mb() in the lock and unlock
>> paths.
> It does because "lock" prefix implies a full memory barrier.
>
>> The smp_mb() will be conditionalized depending on the ARCH_QSPINLOCK
>> setting. The smp_wmb() may not be needed, but a compiler barrier should
>> still be there.
> Do you mean because of inline? That shouldn't be a problem because smp_mb() prohibits compiler from doing any optimizations across the barrier (thanks to the "volatile" keyword).

What I mean is that I don't want any delay in issuing the unlock 
instruction because of compiler rearrangement. So there should be at 
least a barrier() call at the end of the unlock function.

At this point, I am inclined to have either a smp_wmb() or smp_mb() at 
the beginning of the unlock function and a barrier() at the end.

> More on this in Documentation/memory-barriers.txt
>
>>>   Also I don't understand why there are so many uses of ACCESS_ONCE()
>>> macro. It does not guarantee memory ordering with regard to other CPUs,
>>> so probably most of the uses can be removed (with exception of
>>> lock_is_contended(), where it prohibits gcc from optimizing the loop away).
>> All the lock/unlock code can be inlined and we don't know what the
>> compiler will do to optimize code. The ACCESS_ONCE() macro is used to
>> make sure that the compiler won't optimize away the actual fetch or
>> write of the memory. Even if the compiler won't optimize away the memory
>> access, adding the ACCESS_ONCE() macro won't have any extra overhead. So
>> a more liberal use of it won't hurt performance.
> If compiler optimized memory access away it would be a bug. And I'm not so sure about overhead... For example, on some VLIW architectures ACCESS_ONCE() might prohibit compiler from mixing other instructions to the unlock.

As the lock/unlock functions can be inlined, it is possible that a 
memory variable can be accessed earlier in the calling function and the 
stale copy may be used in the inlined lock/unlock function instead of 
fetching a new copy. That is why I prefer a more liberal use of 
ACCESS_ONCE() for safety purpose.
