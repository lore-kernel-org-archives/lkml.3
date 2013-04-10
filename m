Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936980Ab3DJPrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:47:25 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:14435 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab3DJPrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:47:23 -0400
Message-ID: <51658986.2080009@hp.com>
Date: Wed, 10 Apr 2013 11:47:18 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH RFC 1/3] mutex: Make more scalable by doing less atomic
 operations
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com> <1365087258-7169-2-git-send-email-Waiman.Long@hp.com> <20130408124223.GA10093@gmail.com> <51630168.40403@hp.com> <20130410102829.GA28505@gmail.com>
In-Reply-To: <20130410102829.GA28505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 06:28 AM, Ingo Molnar wrote:
> * Waiman Long<Waiman.Long@hp.com>  wrote:
>
>>> Furthermore, since you are seeing this effect so profoundly, have you
>>> considered using another approach, such as queueing all the poll-waiters in
>>> some fashion?
>>>
>>> That would optimize your workload additionally: removing the 'stampede' of
>>> trylock attempts when an unlock happens - only a single wait-poller would get
>>> the lock.
>> The mutex code in the slowpath has already put the waiters into a sleep queue
>> and wait up only one at a time.
> Yes - but I'm talking about spin/poll-waiters.
>
Thank for the clarification.

>> [...] However, there are 2 additional source of mutex lockers besides those in
>> the sleep queue:
>>
>> 1. New tasks trying to acquire the mutex and currently in the fast path.
>> 2. Mutex spinners (CONFIG_MUTEX_SPIN_ON_OWNER on) who are spinning
>> on the owner field and ready to acquire the mutex once the owner
>> field change.
>>
>> The 2nd and 3rd patches are my attempts to limit the second types of mutex
>> lockers.
> Even the 1st patch seems to do that, it limits the impact of spin-loopers, right?

Yes, that is true.

> I'm fine with patch #1 [your numbers are proof enough that it helps while the low
> client count effect seems to be in the noise] - the questions that seem open to me
> are:
>
>   - Could the approach in patch #1 be further improved by an additional patch that
>     adds queueing to the _spinners_ in some fashion - like ticket spin locks try to
>     do in essence? Not queue the blocked waiters (they are already queued), but the
>     active spinners. This would have additional benefits, especially with a high
>     CPU count and a high NUMA factor, by removing the stampede effect as owners get
>     switched.
Yes, I think we can implement some kind of ticketing system for the 
spinners. Similar to patch #2, we have to add a new field to the mutex 
structure for the head/tail ticketing numbers and hence will add a 
little more contention to the same mutex cacheline when the ticket 
numbers are updated. I can think of an easy way to do that without 
increasing the size of the mutex. I will try it out to see what 
performance impact it will have.

>   - Why does patch #2 have an effect? (it shouldn't at first glance) It has a
>     non-trivial cost, it increases the size of 'struct mutex' by 8 bytes, which
>     structure is embedded in numerous kernel data structures. When doing
>     comparisons I'd suggest comparing it not to just vanilla, but to a patch that
>     only extends the struct mutex data structure (and changes no code) - this
>     allows the isolation of cache layout change effects.
>
>   - Patch #3 is rather ugly - and my hope would be that if spinners are queued in
>     some fashion it becomes unnecessary.
I think these two patches can have some performance impact because it 
allows the CPUs to be used for some other tasks that are waiting for CPU 
instead of allowing the CPUs idle waiting for the mutex to be acquired. 
It isn't a big problem if only 1 or 2 threads are spinning, but it could 
be if most the CPUs in the system are wasting time spinning for the 
mutex. That begs the question that even if we implement a ticket queuing 
system, will it make sense to limit the number of spinners to just a 
few, say 3?

Regards,
Longman
