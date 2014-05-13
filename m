Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaEMDxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:53:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:34743 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbaEMDxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:53:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1040,1389772800"; 
   d="scan'208";a="510668054"
Date: Mon, 12 May 2014 20:54:04 -0700
From: Darren Hart <dvhart@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
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
Message-ID: <20140513035404.GA68181@dvhart-mac01.local>
References: <20140512190438.314125476@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512190438.314125476@linutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 08:45:32PM -0000, Thomas Gleixner wrote:
> Dave reported recently that the trinity syscall fuzzer triggers a
> warning in the rtmutex code via the futex syscall.
> 
> It took me quite a while to understand the issue, until I was able to
> write a minimalistic reproducer.
> 
> The first two patches address the issues and the third one is adding
> an unrelated sanity check to prevent user space from assigning PI
> futexes to kernel threads.
> 
> I ran it through my usual tests (except of one, see below), Darrens
> futex tester and it holds up against a 400 threads trinity whacking
> for well above 12hrs now.
> 
> Staring three days into futex.c/rtmutex.c and a few GB of traces
> definitly brings one in a lousy mood. But I discovered two things
> which made me outright grumpy:
> 
> 
> 2) glibc fun
> 
>    While writing an isolated test case for the trinity wreckage, I
>    found out that glibc has an interesting misfeature:
> 
>    strace tells me:
> 
>    futex(0x600e00, FUTEX_LOCK_PI_PRIVATE, 1) = -1 EINVAL (Invalid argument)
> 
>    but the return value of pthread_mutex_lock() is 0

So something is clearly wrong there - however, were you looking at the comments
(sorry, I mean the C code), or the implementation (all the ASM)? The only way
I've been able to be sure in the past is to delete the ASM files and recompile
using the C files. Hopefully we'll be able to drop all the ASM in the pthread
calls soonish (measured in years in glibc development time scales).... sigh.

>    Yay, for another master piece of trainwreck engineering!
> 
>    I checked the glibc source and of course neither the lock nor the unlock path
>    gets any error code from the syscall propagated.
> 
>    The handling of -EDEADLOCK is even more impressive. Instead of
>    propagating it to the caller something in the guts of glibc calls pause().
> 
>      futex(0x601300, FUTEX_LOCK_PI_PRIVATE, 1) = -1 EDEADLK (Resource deadlock avoided)
>      pause(
> 

Gotta love comments like these though - such trust!:

	/* The mutex is locked.  The kernel will now take care of
           everything. */

IIRC, glibc takes the approach that if this operation fails, there is no way for
it to recovery "properly", and so it chooses to:

	/* Delay the thread indefinitely. */

I believe the thinking goes that if we get to here, then the lock is in an
inconsistent state (between kernel and userspace). I don't have an answer for
why pausing forever would be preferable to returning an error however...

>    So any kind of futex wreckage which is not detectable by glibc
>    itself ends up in a disaster one way or the other. How is Joe user
>    of this stuff who reads the manpages supposed to find out that the
>    kernel detected an inconsistent user space variable?
> 
>    If someone of the glibc folks can be bothered to look after that,
>    I'm happy to provide the simple test cases, but I'm sure that
>    looking at the code which simply ignores or pauses on kernel error
>    return values is enough to figure out why its broken.

Was there a spot where it ignores it completely? I suppose if it's anything
other than ESRCH or EDEADLK... yuck...

> 
>    This does not only apply to the PI version, the bog standard
>    futexes have error returns from the kernel as well, which are
>    handled in the same absurd way.

We do have the attention of some of the new glibc maintainers with the requeue
PI work, and some redhat folks are digging into other PI related spec issues.
I'll bring this up in those discussions and see if there might be something we
can do here.

--
Darren

> 
> Yours grumpy
> 
>       tglx
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
