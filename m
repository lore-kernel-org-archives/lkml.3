Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbaAaTYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:24:41 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:39811 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:24:39 -0500
Message-ID: <52EBF871.5020603@hp.com>
Date: Fri, 31 Jan 2014 14:24:33 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com> <1390933151-1797-2-git-send-email-Waiman.Long@hp.com> <20140131150832.GG4941@twins.programming.kicks-ass.net>
In-Reply-To: <20140131150832.GG4941@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 10:08 AM, Peter Zijlstra wrote:
> On Tue, Jan 28, 2014 at 01:19:10PM -0500, Waiman Long wrote:
>> For single-thread performance (no contention), a 256K lock/unlock
>> loop was run on a 2.4Ghz Westmere x86-64 CPU.  The following table
>> shows the average time (in ns) for a single lock/unlock sequence
>> (including the looping and timing overhead):
>>
>>    Lock Type			Time (ns)
>>    ---------			---------
>>    Ticket spinlock		  14.1
>>    Queue spinlock (Normal)	   8.8*
> What CONFIG_NR_CPUS ?

I was testing on a RHEL6.4 system which has a CONFIG_NR_CPUS of 4096.

>
> Because for CONFIG_NR_CPUS<  128 (or 256 if you got !PARAVIRT), the fast
> path code should be:
>
> ticket:
>
>    mov $0x100,eax
>    lock xadd %ax,(%rbx)
>    cmp %al,%ah
>    jne ...
>
> although my GCC is being silly and writes:
>
>    mov $0x100,eax
>    lock xadd %ax,(%rbx)
>    movzbl %ah,%edx
>    cmp %al,%dl
>    jne ...
>
> Which seems rather like a waste of a perfectly good cycle.
>
> With a bigger NR_CPUS you do indeed need more ops:
>
>    mov $0x10000,%edx
>    lock xadd %edx,(%rbx)
>    mov %edx,%ecx
>    shr $0x10,%ecx
>    cmp %dx,%cx
>    jne ...
>
>
> Whereas for the straight cmpxchg() you'd get something relatively simple
> like:
>
>    mov %edx,%eax
>    lock cmpxchg %ecx,(%rbx)
>    cmp %edx,%eax
>    jne ...

I believe the speeds of the lock functions are about the same. However, 
qspinlock has a much simpler unlock function which probably account of 
most of the speed gain.

> Anyway, as soon as you get some (light) contention you're going to tank
> because you have to pull in extra cachelines, which is sad.

Light contention is the only case where the qspinlock may not perform as 
good as the ticket spinlock. I know this is the most common case. 
However, I would argue that the slowdown, if any, will not be really 
noticeable. This is what I will try to find out.


> I suppose we could from the ticket code more and optimize the
> uncontended path, but that'll make the contended path more expensive
> again, although probably not as bad as hitting a new cacheline.

I don't get what you are trying to say.

Right now, I am using only bit 0 as a lock bit. I can use  bit 4, for 
instance, as a pending locker bit and spin until bit 0 is clear. So if 
there is only 1 other task spinning, it won't need to  fetch another 
cacheline. However, it will slow down the uncontended path as I can't 
assign a 0 byte to free the lock. I have to use an atomic subtraction or 
clear bit instead.

-Longman
