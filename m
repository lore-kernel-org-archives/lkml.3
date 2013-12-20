Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3LTCWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:22:25 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:43885 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3LTCWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:22:23 -0500
Message-ID: <1387506141.8363.47.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 19 Dec 2013 18:22:21 -0800
In-Reply-To: <CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	 <1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 15:53 -0800, Linus Torvalds wrote:
> On Thu, Dec 19, 2013 at 3:42 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> >> And it can look at
> >> the wait-list for that - but you want to close the race between the
> >> entry actually getting added to the list using this counter. But the
> >> place you increment the new counter is the same place as you take the
> >> spinlock, which does that ticket increment. No?
> >
> > I don't think so. If we rely on this, then we could end up missing
> > to-be-queued tasks that are in the process of acquiring the lock, so
> > waiters could sleep forever. So we need a way of acknowledging that a
> > task is in the process of waiting when concurrently doing wakeups.
> 
> I don't understand. Why is that any better with the separate atomic count?
> 
> The only place you increment the count - hb_waiters_inc() - is called
> in exactly two places:
> 
>  - in requeue_futex(), which already holds the spinlock on both queues
> 
>  - in queue_lock(), immediately before getting the spinlock (which
> will do the SAME ATOMIC INCREMENT, except it's just doing it on a
> different member of the structure, namely the spinlock head)
> 
> so if you drop the waiters increment, and instead use the spinlock
> head increment as the "waiters", you get exactly the same semantics.
> If anything, for the requeue_futex() case, the spinlock increment was
> done *earlier*, but that's really not relevant.

Ok so when I replied I was thinking about the plist really and not the
hb->lock ticket counter. Yeah, what you propose does make sense for
waiters. However in wake paths we have to decrement  the counter nwake
times (per each call to __unqueue_futex()), and if we rely on the
ticket, then we do it only once, in the unlock, so the counter doesn't
reflect the actual waitqueue size. Or am I missing something with ticket
spinlocks (I'm not very familiar with that code)?

Also by using the ticket counter we can run into scenarios where empty
wakers could still contend for the lock since we don't update the
counter after unlocking, instead of after plist_del. I guess this would
mostly affect requeuers since queue_unlock() would be exactly the same
as to what you propose.

Now, we've discussed this in the past and have agreed that we cannot
rely on plist_head_empty() as a waiter can queued after the user space
value changed and a concurrent wakeup will just return because at that
time plist is empty; thus the waiter blocks forever -- this program
illustrates the problem with nthreads > 1:

http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/performance/futex_wait.c

Yes, the solution to that is to optimistically add the waiter to the
queue and afterwards do the "has the value changed?" check. I do not see
this being any better than using a counter. As Thomas pointed out
previously, we already dirty the cacheline for waiter paths and don't
have to do any housekeeping/dequeuing in case when the futex_wait() call
doesn't succeed.

Btw, I tried using spin_is_contended + plist_head_empty and we run into
a whole bunch of nasty issues which I have yet to sit down and look
into.

Thanks,
Davidlohr

