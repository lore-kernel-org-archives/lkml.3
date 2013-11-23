Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3KWNQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 08:16:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:48801 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3KWNQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 08:16:18 -0500
Date: Sat, 23 Nov 2013 14:16:07 +0100 (CET)
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
In-Reply-To: <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>  <1385168197-8612-5-git-send-email-davidlohr@hp.com>  <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com> <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Davidlohr Bueso wrote:
> On Fri, 2013-11-22 at 17:25 -0800, Linus Torvalds wrote:
> > On Fri, Nov 22, 2013 at 4:56 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > In futex_wake() there is clearly no point in taking the hb->lock if
> > > we know beforehand that there are no tasks to be woken. This comes
> > > at the smaller cost of doing some atomic operations to keep track of
> > > the list's size.
> > 
> > Hmm. Why? Afaik, you only care about "empty or not". And if you don't
> > need the serialization from locking, then afaik you can just do a
> > "plist_head_empty()" without holding the lock.
> 
> I remember this being the original approach, but after noticing some
> strange behavior we quickly decided it wasn't the path. And sure enough,
> I just double checked and tried the patch without atomic ops and can see
> things being off: one of the futextest performance cases is stuck
> blocked on a futex and I couldn't reboot the machine either -- nothing
> apparent in dmesg, just not 100% functional. The thing is, we can only
> avoid taking the lock only if nobody else is trying to add itself to the
> list.

Right. The reason is:

CPU 0					CPU 1

    val = *futex;
    futex_wait(futex, val);

    spin_lock(&hb->lock);

    uval = *futex;
					*futex = newval;

    if (uval != val) {			futex_wake();
       spin_unlock(&hb->lock);		if (plist_empty(hb))
       return;				   return;
    }

    plist_add(hb, self);
    spin_unlock(&hb->lock);
    schedule();
    ...

So the waiter on CPU0 gets queued after the user space value changed
and the wakee on CPU1 returns because plist is empty. Waiter therefor
waits forever.

So with the atomic ops you are changing that to:

CPU 0					CPU 1

    val = *futex;
    futex_wait(futex, val);

    spin_lock(&hb->lock);

    atomic_inc(&hb->waiters);
    uval = *futex;
					*futex = newval;

    if (uval != val) {			futex_wake();
       spin_unlock(&hb->lock);		if (!atomic_read(&hb->waiters))
       return;				   return;
    }
   					spin_lock((&hb->lock);	
    plist_add(hb, self);
    spin_unlock(&hb->lock);
    schedule();				wakeup_waiters(hb);
    ...

which restores the ordering guarantee, which the hash bucket lock
provided so far.

Now the question is why we queue the waiter _AFTER_ reading the user
space value. The comment in the code is pretty non sensical:

   * On the other hand, we insert q and release the hash-bucket only
   * after testing *uaddr.  This guarantees that futex_wait() will NOT
   * absorb a wakeup if *uaddr does not match the desired values
   * while the syscall executes.

There is no reason why we cannot queue _BEFORE_ reading the user space
value. We just have to dequeue in all the error handling cases, but
for the fast path it does not matter at all.

CPU 0					CPU 1

    val = *futex;
    futex_wait(futex, val);

    spin_lock(&hb->lock);

    plist_add(hb, self);
    smp_wmb();

    uval = *futex;
					*futex = newval;
					futex_wake();
					
					smp_rmb();
					if (plist_empty(hb))
					   return;

   					spin_lock((&hb->lock);	
    if (uval != val) {			
       plist_del(self);			
       spin_unlock(&hb->lock);
       return;		
    }

    spin_unlock(&hb->lock);
    schedule();				wakeup_waiters(hb);
    ...

Thanks,

	tglx
