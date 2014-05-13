Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbaEMJIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:08:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:60193 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaEMJIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:08:36 -0400
Date: Tue, 13 May 2014 11:08:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
In-Reply-To: <20140513035404.GA68181@dvhart-mac01.local>
Message-ID: <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Darren Hart wrote:
> On Mon, May 12, 2014 at 08:45:32PM -0000, Thomas Gleixner wrote:
> >    strace tells me:
> > 
> >    futex(0x600e00, FUTEX_LOCK_PI_PRIVATE, 1) = -1 EINVAL (Invalid argument)
> > 
> >    but the return value of pthread_mutex_lock() is 0
> 
> So something is clearly wrong there - however, were you looking at the comments
> (sorry, I mean the C code), or the implementation (all the ASM)? The only way
> I've been able to be sure in the past is to delete the ASM files and recompile
> using the C files. Hopefully we'll be able to drop all the ASM in the pthread
> calls soonish (measured in years in glibc development time scales).... sigh.

The C implementation does:

	    if (INTERNAL_SYSCALL_ERROR_P (e, __err)
		&& (INTERNAL_SYSCALL_ERRNO (e, __err) == ESRCH
		    || INTERNAL_SYSCALL_ERRNO (e, __err) == EDEADLK))
	      {
		assert (INTERNAL_SYSCALL_ERRNO (e, __err) != EDEADLK
			|| (kind != PTHREAD_MUTEX_ERRORCHECK_NP
			    && kind != PTHREAD_MUTEX_RECURSIVE_NP));
		/* ESRCH can happen only for non-robust PI mutexes where
		   the owner of the lock died.  */
		assert (INTERNAL_SYSCALL_ERRNO (e, __err) != ESRCH || !robust);

		/* Delay the thread indefinitely.  */
		while (1)
		  pause_not_cancel ();
	      }

So anything else than ESRCH and EDEADLK is ignored and then the thing
happily returns 0 at the end. Unlock is the same:

	{
	  int robust = mutex->__data.__kind & PTHREAD_MUTEX_ROBUST_NORMAL_NP;
	  int private = (robust
			 ? PTHREAD_ROBUST_MUTEX_PSHARED (mutex)
			 : PTHREAD_MUTEX_PSHARED (mutex));
	  INTERNAL_SYSCALL_DECL (__err);
	  INTERNAL_SYSCALL (futex, __err, 2, &mutex->__data.__lock,
			    __lll_private_flag (FUTEX_UNLOCK_PI, private));
	}

Quality stuff that.

Thanks,

	tglx

 
