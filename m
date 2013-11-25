Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3KYUEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:04:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:21842 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab3KYUEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:04:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,769,1378882800"; 
   d="scan'208";a="441580418"
Message-ID: <1385409830.12342.41.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Darren Hart <dvhart@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, jeffm@suse.com,
        "Norton, Scott J" <scott.norton@hp.com>, tom.vaden@hp.com,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 25 Nov 2013 12:03:50 -0800
In-Reply-To: <alpine.DEB.2.02.1311251938570.30673@ionos.tec.linutronix.de>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	  <1385168197-8612-5-git-send-email-davidlohr@hp.com>
	  <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
	 <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
	 <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
	 <alpine.DEB.2.02.1311251938570.30673@ionos.tec.linutronix.de>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 20:47 +0100, Thomas Gleixner wrote:
> On Sat, 23 Nov 2013, Thomas Gleixner wrote:
> > On Fri, 22 Nov 2013, Davidlohr Bueso wrote:
> > So with the atomic ops you are changing that to:
> > 
> > CPU 0                                 CPU 1
> > 
> >     val = *futex;
> >     futex_wait(futex, val);
> > 
> >     spin_lock(&hb->lock);
> > 
> >     atomic_inc(&hb->waiters);
> >     uval = *futex;
> >                                       *futex = newval;
> > 
> >     if (uval != val) {                        futex_wake();
> >        spin_unlock(&hb->lock);                if (!atomic_read(&hb->waiters))
> >        return;                                   return;
> >     }
> >                                       spin_lock((&hb->lock);  
> >     plist_add(hb, self);
> >     spin_unlock(&hb->lock);
> >     schedule();                               wakeup_waiters(hb);
> >     ...
> > 
> > which restores the ordering guarantee, which the hash bucket lock
> > provided so far.
> 
> Actually that's not true by design, it just happens to work.
> 
> atomic_inc() on x86 is a "lock incl".
> 
>  The LOCK prefix just guarantees that the cache line which is affected
>  by the INCL is locked. And it guarantees that locked operations
>  serialize all outstanding load and store operations.
> 
>  But Documentation/atomic_ops.txt says about atomic_inc():
> 
>  "One very important aspect of these two routines is that they DO NOT
>   require any explicit memory barriers.  They need only perform the
>   atomic_t counter update in an SMP safe manner."
> 
>  So while this has a barrier on x86, it's not guaranteed.


But it is guaranteed to be "in an SMP safe manner"... which I guess just
means that two writes will not intermix bytes, but no guarantee that the
value will be visible to other CPUs unless some kind of barrier is
explicitly imposed.

Correct?


> atomic_read() is a simple read.
> 
>  This does not guarantee anything. And if you read
>  Documentation/atomic_ops.txt it's well documented:
> 
>  "*** WARNING: atomic_read() and atomic_set() DO NOT IMPLY BARRIERS! ***"
> 
> 
> So now your code melts down to:
> 
>  write(hb->waiters)    |    write(uaddr)
>  mb                    |    read(hb->waiters)
>  read(uaddr)
> 
> I fear you simply managed to make the window small enough that your
> testing was not longer able expose it.

Does seem to be the case.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


