Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaENK0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:26:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:41927 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbaENK0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:26:09 -0400
Date: Wed, 14 May 2014 12:26:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Carlos O'Donell" <carlos@redhat.com>
cc: Darren Hart <dvhart@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <53731608.3010803@redhat.com>
Message-ID: <alpine.DEB.2.02.1405141155260.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de> <53731608.3010803@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Carlos O'Donell wrote:
> On 05/13/2014 05:08 AM, Thomas Gleixner wrote:
> > So anything else than ESRCH and EDEADLK is ignored and then the thing
> > happily returns 0 at the end. Unlock is the same:
> 
> The code is valid so long as you expect only ESRCH and EDEADLK
> to be the only errors the kernel returns.

Brilliant assumption, really. So we rather return 0 to the user than
having a catch for that case?

You know that this is how a large portion of security holes are
created, right?

> What other error codes are returned and under what conditions?
 
   -ENOMEM  Kernel can't allocate state.

   -EFAULT  Accessing the user space futex failed. Might be a mapping
    	    zapped by a different thread or no valid access (e.g. RO
    	    mapping)

   -EPERM   No permission to attach yourself to a futex owned by someone
   	    else or to unlock it.

   -EINVAL  Inconsistant state detected.

   -ETIMEDOUT
	    timed op timed out	

   -EWOULDBLOCK

	   For non PI indicates that the caller raced against another
	   thread.

	   For PI also returned if trylock fails.

   -ESRCH  Owner died

   -EAGAIN Owner is about to die, but has not yet finished the cleanup	   

> Are those other errors actionable by the user?

Define actionable. Most of them are in my opinion.

Some of them like -EWOULDBLOCK for non PI or -EAGAIN are for glibc
internal consumption.

> Since anything other than the agreed upon set of error returns is a failure
> in the coordinated implementation between glibc and the kernel.

Well. Back then when we implemented pi and robust futex support this
was done hand in hand with glibc folks and they knew about ALL the
error codes we return. I'm quite sure that we did not add any new one
since then, but I really can't be bothered to look.

> > 	{
> > 	  int robust = mutex->__data.__kind & PTHREAD_MUTEX_ROBUST_NORMAL_NP;
> > 	  int private = (robust
> > 			 ? PTHREAD_ROBUST_MUTEX_PSHARED (mutex)
> > 			 : PTHREAD_MUTEX_PSHARED (mutex));
> > 	  INTERNAL_SYSCALL_DECL (__err);
> > 	  INTERNAL_SYSCALL (futex, __err, 2, &mutex->__data.__lock,
> > 			    __lll_private_flag (FUTEX_UNLOCK_PI, private));
> > 	}
> 
> Isn't the the same issue as before? This code presumes that because the
> atomic operation completed successfully that the kernel state is OK.
> Assuming otherwise slows down the fast path in the unlock just to check
> for kernel bugs. Is the returned error in any way actionable by the user?

We return EPERM, EFAULT and EINVAL on unlock.

   EPERM    Tells you that the user space / kernel state is
	    inconsistent, because kernel thinks the owner is not current.
   	    
   EINVAL   That would be a glibc bug calling unlock pi for a non futex,
   	    which has non pi waiters in the kernel.

	    That one was explicitely there from the very beginning.

And as I demonstrated in the other mail, it's easy to corrupt state
w/o glibc even being able to notice. So you better handle that
gracefully instead of making utterly stupid assumptions.

Thanks,

	tglx
