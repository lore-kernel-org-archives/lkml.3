Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3KYTrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:47:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:57002 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3KYTrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:47:46 -0500
Date: Mon, 25 Nov 2013 20:47:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        jeffm@suse.com, "Norton, Scott J" <scott.norton@hp.com>,
        tom.vaden@hp.com, "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
In-Reply-To: <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1311251938570.30673@ionos.tec.linutronix.de>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>  <1385168197-8612-5-git-send-email-davidlohr@hp.com>  <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com> <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
 <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov 2013, Thomas Gleixner wrote:
> On Fri, 22 Nov 2013, Davidlohr Bueso wrote:
> So with the atomic ops you are changing that to:
> 
> CPU 0					CPU 1
> 
>     val = *futex;
>     futex_wait(futex, val);
> 
>     spin_lock(&hb->lock);
> 
>     atomic_inc(&hb->waiters);
>     uval = *futex;
> 					*futex = newval;
> 
>     if (uval != val) {			futex_wake();
>        spin_unlock(&hb->lock);		if (!atomic_read(&hb->waiters))
>        return;				   return;
>     }
>    					spin_lock((&hb->lock);	
>     plist_add(hb, self);
>     spin_unlock(&hb->lock);
>     schedule();				wakeup_waiters(hb);
>     ...
> 
> which restores the ordering guarantee, which the hash bucket lock
> provided so far.

Actually that's not true by design, it just happens to work.

atomic_inc() on x86 is a "lock incl".

 The LOCK prefix just guarantees that the cache line which is affected
 by the INCL is locked. And it guarantees that locked operations
 serialize all outstanding load and store operations.

 But Documentation/atomic_ops.txt says about atomic_inc():

 "One very important aspect of these two routines is that they DO NOT
  require any explicit memory barriers.  They need only perform the
  atomic_t counter update in an SMP safe manner."

 So while this has a barrier on x86, it's not guaranteed.

atomic_read() is a simple read.

 This does not guarantee anything. And if you read
 Documentation/atomic_ops.txt it's well documented:

 "*** WARNING: atomic_read() and atomic_set() DO NOT IMPLY BARRIERS! ***"


So now your code melts down to:

 write(hb->waiters)    |    write(uaddr)
 mb		       |    read(hb->waiters)
 read(uaddr)

I fear you simply managed to make the window small enough that your
testing was not longer able expose it.

Thanks,

	tglx




