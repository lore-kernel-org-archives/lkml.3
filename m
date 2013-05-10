Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3EJQmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:42:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19257 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3EJQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:42:53 -0400
Message-ID: <518D236D.6000608@oracle.com>
Date: Fri, 10 May 2013 12:42:21 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] liblockdep: Support using LD_PRELOAD
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com> <1368115089-8909-8-git-send-email-sasha.levin@oracle.com> <20130510135716.GA304@dyad.programming.kicks-ass.net> <518D1B16.9080904@oracle.com> <20130510162115.GB885@dyad.programming.kicks-ass.net>
In-Reply-To: <20130510162115.GB885@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 12:21 PM, Peter Zijlstra wrote:
> On Fri, May 10, 2013 at 12:06:46PM -0400, Sasha Levin wrote:
>> On 05/10/2013 09:57 AM, Peter Zijlstra wrote:
>>> So you're doing instance tracking and not creating classes like the kernel
>>> lockdep does? While that reduces false positives it also greatly reduces the
>>> effectiveness of lockdep.
>>>
>>> The power of lock-classes is that it increases the chance of catching potential
>>> deadlocks without there ever actually being a deadlock.
>>
>> Originally I had classes working as you've pointed out, until the first time I've
>> tried running lockdep on qemu.
>>
>> They appear to have wrappers for every api call known to man, including all the
>> posix locking apis.
>>
>> Basically, instead of directly calling pthread_mutex_lock() for example, there's
>> a wrapper named qemu_mutex_lock() that calls the api above:
>>
>> 	void qemu_mutex_lock(QemuMutex *mutex)
>> 	{
>> 	    int err;
>> 	
>> 	    err = pthread_mutex_lock(&mutex->lock);
>> 	    if (err)
>> 	        error_exit(err, __func__);
>> 	}
>>
>> So as you might imagine, the first time I ran it my log exploded with warnings.
>>
>> I've poked around the source of other big projects, and the example above is
>> somewhat common with projects that wrap everything to be compatible with different
>> architectures or apis - which is something that doesn't happen in the kernel.
> 
> Urgh.. yes that might be a problem. Still it is something that should at least
> be clearly stated somewhere (the Changelog for one).
> 
> Not being able to do classes sucks though :/
> 
> Hmm, we could do something like:
> 
>   $ LIBLOCKDEP_CLASS_DEPTH=n LD_PRELOAD=liblockdep.so my_app
> 
> where an @n of -1 would indicate per-instance classes and 0+ would be the
> __builtin_return_address(n). That way, the above qemu thing should work with 1;
> which should be the return address of the wrapper.
> 
> Of course, projects mixing different wrapper depths will be immense 'fun' :/

Like, um, qemu? :)

You think that the only pthread_mutex_lock() calls you'd see are in the wrapper
module, right? grepping for pthread_mutex_lock will show that that's not the case...

Which is also why I'd rather leave this part out for now. I really want something
pretty simple that works for *most* cases and relies *mostly* on kernel/lockdep.c
logic instead of custom liblockdep stuff (right now the only "logic" in liblockdep
is rb-tree loockups) so that we won't scare Linus.

Also, if qemu (for example) really wants to get proper lockdep support for their
testing all it takes is just an extra call to liblockdep's mutex init api inside
their code - it means that they would need to modify their code and actually link
with liblockdep, but there's a limit to the magic that can be done from outside the code.


(I'm using qemu as an example not because I think it's horrible or something like
that, but because it's a great example for a mature big project that is still
relatively easy to work with).


Thanks,
Sasha


