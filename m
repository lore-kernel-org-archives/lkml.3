Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaENHHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:07:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaENHH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:07:29 -0400
Message-ID: <53731608.3010803@redhat.com>
Date: Wed, 14 May 2014 03:06:48 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
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
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 05:08 AM, Thomas Gleixner wrote:
> On Mon, 12 May 2014, Darren Hart wrote:
>> On Mon, May 12, 2014 at 08:45:32PM -0000, Thomas Gleixner wrote:
>>>    strace tells me:
>>>
>>>    futex(0x600e00, FUTEX_LOCK_PI_PRIVATE, 1) = -1 EINVAL (Invalid argument)
>>>
>>>    but the return value of pthread_mutex_lock() is 0
>>
>> So something is clearly wrong there - however, were you looking at the comments
>> (sorry, I mean the C code), or the implementation (all the ASM)? The only way
>> I've been able to be sure in the past is to delete the ASM files and recompile
>> using the C files. Hopefully we'll be able to drop all the ASM in the pthread
>> calls soonish (measured in years in glibc development time scales).... sigh.
> 
> The C implementation does:
> 
> 	    if (INTERNAL_SYSCALL_ERROR_P (e, __err)
> 		&& (INTERNAL_SYSCALL_ERRNO (e, __err) == ESRCH
> 		    || INTERNAL_SYSCALL_ERRNO (e, __err) == EDEADLK))
> 	      {
> 		assert (INTERNAL_SYSCALL_ERRNO (e, __err) != EDEADLK
> 			|| (kind != PTHREAD_MUTEX_ERRORCHECK_NP
> 			    && kind != PTHREAD_MUTEX_RECURSIVE_NP));
> 		/* ESRCH can happen only for non-robust PI mutexes where
> 		   the owner of the lock died.  */
> 		assert (INTERNAL_SYSCALL_ERRNO (e, __err) != ESRCH || !robust);
> 
> 		/* Delay the thread indefinitely.  */
> 		while (1)
> 		  pause_not_cancel ();
> 	      }
> 
> So anything else than ESRCH and EDEADLK is ignored and then the thing
> happily returns 0 at the end. Unlock is the same:

The code is valid so long as you expect only ESRCH and EDEADLK
to be the only errors the kernel returns.

What other error codes are returned and under what conditions?

Are those other errors actionable by the user?

I'm inclined to abort() on anything but some agreed upon set of error returns.

Since anything other than the agreed upon set of error returns is a failure
in the coordinated implementation between glibc and the kernel.
 
> 	{
> 	  int robust = mutex->__data.__kind & PTHREAD_MUTEX_ROBUST_NORMAL_NP;
> 	  int private = (robust
> 			 ? PTHREAD_ROBUST_MUTEX_PSHARED (mutex)
> 			 : PTHREAD_MUTEX_PSHARED (mutex));
> 	  INTERNAL_SYSCALL_DECL (__err);
> 	  INTERNAL_SYSCALL (futex, __err, 2, &mutex->__data.__lock,
> 			    __lll_private_flag (FUTEX_UNLOCK_PI, private));
> 	}

Isn't the the same issue as before? This code presumes that because the
atomic operation completed successfully that the kernel state is OK.
Assuming otherwise slows down the fast path in the unlock just to check
for kernel bugs. Is the returned error in any way actionable by the user?

Cheers,
Carlos.

Cheers,
Carlos.

