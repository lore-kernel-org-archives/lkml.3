Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3KYMB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:01:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:53945 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3KYMBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:01:25 -0500
Date: Mon, 25 Nov 2013 13:01:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>, "Norton, Scott J" <scott.norton@hp.com>,
        tom.vaden@hp.com, "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
In-Reply-To: <1385270135.5402.43.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1311251107240.30673@ionos.tec.linutronix.de>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>  <1385168197-8612-5-git-send-email-davidlohr@hp.com>  <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>  <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net> 
 <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>  <CA+55aFwzRqPHKp67EhJ9hsX4v5=p3uQxvnaVZko2ZXDf6CQAPQ@mail.gmail.com> <1385270135.5402.43.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov 2013, Davidlohr Bueso wrote:
> On Sat, 2013-11-23 at 19:46 -0800, Linus Torvalds wrote:
> > On Sat, Nov 23, 2013 at 5:16 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >
> > > Now the question is why we queue the waiter _AFTER_ reading the user
> > > space value. The comment in the code is pretty non sensical:
> > >
> > >    * On the other hand, we insert q and release the hash-bucket only
> > >    * after testing *uaddr.  This guarantees that futex_wait() will NOT
> > >    * absorb a wakeup if *uaddr does not match the desired values
> > >    * while the syscall executes.
> > >
> > > There is no reason why we cannot queue _BEFORE_ reading the user space
> > > value. We just have to dequeue in all the error handling cases, but
> > > for the fast path it does not matter at all.
> > >
> > > CPU 0                                   CPU 1
> > >
> > >     val = *futex;
> > >     futex_wait(futex, val);
> > >
> > >     spin_lock(&hb->lock);
> > >
> > >     plist_add(hb, self);
> > >     smp_wmb();
> > >
> > >     uval = *futex;
> > >                                         *futex = newval;
> > >                                         futex_wake();
> > >
> > >                                         smp_rmb();
> > >                                         if (plist_empty(hb))
> > >                                            return;
> > > ...
> > 
> > This would seem to be a nicer approach indeed, without needing the
> > extra atomics.
> 
> Yep, I think we can all agree that doing this optization without atomic
> ops is a big plus.
> 
> > 
> > Davidlohr, mind trying Thomas' approach?
> 
> I just took a quick look and it seems pretty straightforward, but not
> without some details to consider. We basically have to redo/reorder
> futex_wait_setup(), which checks that uval == val, and
> futex_wait_queue_me(), which adds the task to the list and blocks. Now,
> both futex_wait() and futex_wait_requeue_pi() have this logic, but since
> we don't use futex_wake() to wakeup tasks on pi futex_qs, I believe it's
> ok to only change futex_wait(), while the order of the uval checking
> doesn't matter for futex_wait_requeue_pi() so it can stay as is.

There is no mechanism which prevents a futex_wake() call on the inner
futex of the wait_requeue_pi mechanism. So no, we have to change both.

futexes are no place for believe. Either you understand them
completely or you just leave them alone.

Thanks,

	tglx
