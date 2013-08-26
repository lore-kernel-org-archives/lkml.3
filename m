Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3HZUPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:15:35 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43328 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3HZUPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:15:34 -0400
Message-ID: <521BB71F.6080300@hp.com>
Date: Mon, 26 Aug 2013 16:14:23 -0400
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
References: <15321377012704@web8h.yandex.ru> <52142D6C.6000400@hp.com> <336901377100289@web16f.yandex.ru> <5215638E.5020702@hp.com> <169431377178121@web21f.yandex.ru>
In-Reply-To: <169431377178121@web21f.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 09:28 AM, Alexander Fyodorov wrote:
> 22.08.2013, 05:04, "Waiman Long"<waiman.long@hp.com>:
>> On 08/21/2013 11:51 AM, Alexander Fyodorov wrote:
>> In this case, we should have smp_wmb() before freeing the lock. The
>> question is whether we need to do a full mb() instead. The x86 ticket
>> spinlock unlock code is just a regular add instruction except for some
>> exotic processors. So it is a compiler barrier but not really a memory
>> fence. However, we may need to do a full memory fence for some other
>> processors.
> The thing is that x86 ticket spinlock code does have full memory barriers both in lock() and unlock() code: "add" instruction there has "lock" prefix which implies a full memory barrier. So it is better to use smp_mb() and let each architecture define it.

I also thought that the x86 spinlock unlock path was an atomic add. It 
just comes to my realization recently that this is not the case. The 
UNLOCK_LOCK_PREFIX will be mapped to "" except for some old 32-bit x86 
processors.

>> At this point, I am inclined to have either a smp_wmb() or smp_mb() at
>> the beginning of the unlock function and a barrier() at the end.
>>
>> As the lock/unlock functions can be inlined, it is possible that a
>> memory variable can be accessed earlier in the calling function and the
>> stale copy may be used in the inlined lock/unlock function instead of
>> fetching a new copy. That is why I prefer a more liberal use of
>> ACCESS_ONCE() for safety purpose.
> That is impossible: both lock() and unlock() must have either full memory barrier or an atomic operation which returns value. Both of them prohibit optimizations and compiler cannot reuse any global variable. So this usage of ACCESS_ONCE() is unneeded.
>
> You can read more on this in Documentation/volatile-considered-harmful.txt
>
> And although I already suggested that, have you read Documentation/memory-barriers.txt? There is a lot of valuable information there.

I did read Documentation/memory-barriers.txt. I will read 
volatile-considered-harmful.txt.

Regards,
Longman
