Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaFBPj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:39:29 -0400
Received: from blu004-omc2s26.hotmail.com ([65.55.111.101]:62945 "EHLO
	BLU004-OMC2S26.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbaFBPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:39:27 -0400
X-TMN: [EoIX52jXqf50xVFbD0WgKAoYSC/JNbgR]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP35E10E00A34C3FF2DB55B297200@phx.gbl>
Date: Mon, 2 Jun 2014 11:39:55 -0400
From: John David Anglin <dave.anglin@bell.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chegu_vinod@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <20140601192026.GE16155@laptop.programming.kicks-ass.net> <BLU0-SMTP387BD0AE22A4EAD432D65F97210@phx.gbl> <alpine.LRH.2.02.1406020914440.18342@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1406021002090.1300@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1406021002090.1300@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2014 15:39:25.0135 (UTC) FILETIME=[D4F9CDF0:01CF7E78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/2014 10:02 AM, Mikulas Patocka wrote:
>
> On Mon, 2 Jun 2014, Mikulas Patocka wrote:
>
>>
>> On Sun, 1 Jun 2014, John David Anglin wrote:
>>
>>> On 1-Jun-14, at 3:20 PM, Peter Zijlstra wrote:
>>>
>>>>> If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg at
>>>>> the same time, you break it. ACCESS_ONCE doesn't take the hashed spinlock,
>>>>> so, in this case, cmpxchg or xchg isn't really atomic at all.
>>>> And this is really the first place in the kernel that breaks like this?
>>>> I've been using xchg() and cmpxchg() without such consideration for
>>>> quite a while.
>>> I believe Mikulas is correct.  Even in a controlled situation where a
>>> cmpxchg operation is used to implement pthread_spin_lock() in userspace,
>>> we found recently that the lock must be released with a cmpxchg
>>> operation and not a simple write on SMP systems. There is a race in the
>>> cache operations or instruction ordering that's not present with the
>>> ldcw instruction.
>>>
>>> Dave
>>> --
>>> John David Anglin	dave.anglin@bell.net
>> That is strange.
>>
>> Spinlock with cmpxchg on lock and a single write on unlock should work,
>> assuming that cmpxchg doesn't write to the target address when it detects
>> mismatch (the cmpxchg in the kernel syscall page doesn't do it, it
>> nullifies the write instruction on mismatch).
>>
>> Do you have some code that reproduces this misbehavior?
There is a pthread_spin_lock test in the  kyotocabinet package that 
reproduces
this misbehavior.  Essentially, it creates four threads which loop doing 
pthread_spin_lock(),
sched_yield() and then pthread_spin_unlock().  On SMP systems, the test 
hangs with
the pthread_spin_lock locked and no thread holding lock (i.e., unlock 
failed).

The pthread support uses the cmpxchg code in 
arch/parisc/kernel/syscall.S.  This uses
"hashed" locks, etc, in a manner similar to the kernel code.

>>
>> We really need to find out why does it behave this way:
>> - is PA-RISC really out of order? (we used to believe that it is in-order
>>    and we have empty barrier instructions in the kernel). Does adding the
>>    "SYNC" instruction before the write in pthread_spin_unlock fix it?
I tried "SYNC" instruction before write and after the cmpxchg operation both
with.  In the cmpxchg operation, I also tried it with cache flush. I was 
trying to
simulated ldcw behavior.
>> - does the processor performs nullified writes unconditionally? Does
>>    moving the write in the cmpxchg implementation from the nullified slot
>>    to is own branch fix it?
I don't see how the processor can perform nullified writes 
unconditionally although that
might explain the observed symptom.  Didn't try moving the cmpxchg write.

>> - does adding a dummy "ldcw" instruction to an unrelated address fix it?
>>    Is it that "ldcw" has some magic barrier properties?
I had wondered about that.  One can't use %r0 as the instruction target 
as the architecture
manual says that it may then be implemented as a normal load. "ldcw" 
definitely has some magic
cache and barrier properties.  A normal store definitely works with it 
to reset the semaphore.
> - and there is "stw,o" instruction that does ordered store according to
> the specification, so we should test it too...
This doesn't help.

Currently, the Debian eglibc has a pthread_spin_unlock.diff patch that 
resolves the
kyotocabinet bug.  See:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=725508

>
>> I think we need to perform these tests and maybe some more to find out
>> what really happened there...
>>
>> BTW. in Debian 5 libc 2.7, pthread_spin_lock uses ldcw and
>> pthread_spin_unlock uses a single write (just like the kernel spinlock
>> implementation). In Debian-ports libc 2.18, both pthread_spin_lock and
>> pthread_spin_unlock call the kernel syscall page. What was the reason for
>> switching to a less efficient implementation?
>>
>> Mikulas
>>
>

Dave

-- 
John David Anglin    dave.anglin@bell.net

