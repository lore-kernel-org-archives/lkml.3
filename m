Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaENVWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaENVWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:22:49 -0400
Message-ID: <5373D94E.5030800@redhat.com>
Date: Wed, 14 May 2014 16:59:58 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Darren Hart <dvhart@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de> <53731608.3010803@redhat.com> <alpine.DEB.2.02.1405141155260.6261@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405141155260.6261@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:26 AM, Thomas Gleixner wrote:
> On Wed, 14 May 2014, Carlos O'Donell wrote:
>> On 05/13/2014 05:08 AM, Thomas Gleixner wrote:
>>> So anything else than ESRCH and EDEADLK is ignored and then the thing
>>> happily returns 0 at the end. Unlock is the same:
>>
>> The code is valid so long as you expect only ESRCH and EDEADLK
>> to be the only errors the kernel returns.
> 
> Brilliant assumption, really. So we rather return 0 to the user than
> having a catch for that case?

That's correct. At the time the argument was that performance of
the hot path was the only thing that mattered. For each additional
error code we add the hot path instruction length is enlarged.
I'm not arguing for or against, but simply stating the design
criteria that I know were part of the original work. Thus it would
have been perfectly valid to ignore all error codes except those
that mattered to the implementation, leaving failures like ENOMEM
to bubble up elsewhere instead of slowing down threads.
 
> You know that this is how a large portion of security holes are
> created, right?

I don't have any data to back up that claim, but I agree that
choosing performance as the only metric has resulted in code that
does not handle error conditions gracefully. Here we are 8 years
later talking about maintenance and robustness.

I will make my personal opinion clear:

- Internal defects should raise immediate assertions.

- Real problems like resource availability, deadlocks, and
  other recoverable errors should result in the API returning
  an appropriate error code that must not diverge from the POSIX
  definitions for those codes (when such a definition exists).

I'm not a believer in "only the hot path matters", there are such
things as robustness and error detection, and they matter.
 
>> What other error codes are returned and under what conditions?
>  
>    -ENOMEM  Kernel can't allocate state.
> 
>    -EFAULT  Accessing the user space futex failed. Might be a mapping
>     	    zapped by a different thread or no valid access (e.g. RO
>     	    mapping)
> 
>    -EPERM   No permission to attach yourself to a futex owned by someone
>    	    else or to unlock it.
> 
>    -EINVAL  Inconsistant state detected.
> 
>    -ETIMEDOUT
> 	    timed op timed out	
> 
>    -EWOULDBLOCK
> 
> 	   For non PI indicates that the caller raced against another
> 	   thread.
> 
> 	   For PI also returned if trylock fails.
> 
>    -ESRCH  Owner died
> 
>    -EAGAIN Owner is about to die, but has not yet finished the cleanup	   

Awesome. I like the direction this conversation is taking, since this is
actionable for me to fix the implementation.

Have we added all of this to the linux kernel man page entry for the
futex syscall? I consider Michael Kerrisk the trusted gate keeper for
documenting syscall APIs in sufficient detail that both the kernel and
glibc can agree on the usage (or any C library wishing to use the
interfaces).

I see Darren Hart has restarted the conversation with Michael to update
the futex() syscall documentation, which is the right way forward there.

>> Are those other errors actionable by the user?
> 
> Define actionable. Most of them are in my opinion.
> 
> Some of them like -EWOULDBLOCK for non PI or -EAGAIN are for glibc
> internal consumption.

That's what I mean. Can the user do anything useful with the error?

In the case of ENOMEM it's immediately obvious that the user could
attempt to give back memory to the kernel and retry the operation.

However, if glibc detects an inconsistency between the kernel and
glibc, I am not excited about returning EINVAL to the user, I would
rather abort or assert that the data structures have been corrupted.
The principal here being to abort or assert as close to the point at
which the corruption occurred to help the developer debug the problem.
I would argue that returning EINVAL to a library or application that
already manged to corrupt state is unlikely to know how to properly
handle the error anyway.

Would you agree?

>> Since anything other than the agreed upon set of error returns is a failure
>> in the coordinated implementation between glibc and the kernel.
> 
> Well. Back then when we implemented pi and robust futex support this
> was done hand in hand with glibc folks and they knew about ALL the
> error codes we return. I'm quite sure that we did not add any new one
> since then, but I really can't be bothered to look.

That's fine. If you assert the design is this way, then I trust you.
What I need from you is a list of all possible error returns, and you've
provided that, we're ready to fix things.

>>> 	{
>>> 	  int robust = mutex->__data.__kind & PTHREAD_MUTEX_ROBUST_NORMAL_NP;
>>> 	  int private = (robust
>>> 			 ? PTHREAD_ROBUST_MUTEX_PSHARED (mutex)
>>> 			 : PTHREAD_MUTEX_PSHARED (mutex));
>>> 	  INTERNAL_SYSCALL_DECL (__err);
>>> 	  INTERNAL_SYSCALL (futex, __err, 2, &mutex->__data.__lock,
>>> 			    __lll_private_flag (FUTEX_UNLOCK_PI, private));
>>> 	}
>>
>> Isn't the the same issue as before? This code presumes that because the
>> atomic operation completed successfully that the kernel state is OK.
>> Assuming otherwise slows down the fast path in the unlock just to check
>> for kernel bugs. Is the returned error in any way actionable by the user?
> 
> We return EPERM, EFAULT and EINVAL on unlock.
> 
>    EPERM    Tells you that the user space / kernel state is
> 	    inconsistent, because kernel thinks the owner is not current.

I would assert on that.
    	    
>    EINVAL   That would be a glibc bug calling unlock pi for a non futex,
>    	    which has non pi waiters in the kernel.
> 
> 	    That one was explicitely there from the very beginning.

I would also assert on this.

> And as I demonstrated in the other mail, it's easy to corrupt state
> w/o glibc even being able to notice. So you better handle that
> gracefully instead of making utterly stupid assumptions.

The assumptions are predicated on a particular design that doesn't
seem to match your expectations. I accept that in this case you're
correct. We should be catching state corruption and asserting. It's
useful and prevents the program from continuing to corrupt other
potentially more important program state.

As I mentioned before I'm not overly worried about a few extra
instructions in the hot path. I am worried about programs that run
as if they were correct but in fact are corrupting state. Debugging
this is both costly and painful.

Nobody has looked at this code in years, likely because all parties
thought they were done, but had in fact agreed to distinct expectations
and assumptions about the implementation.

I want it fix, and I'm in a position to move resources to fix it.

Cheers,
Carlos.

