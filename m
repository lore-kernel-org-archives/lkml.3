Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaFBVNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:13:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbaFBVNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:13:19 -0400
Date: Mon, 2 Jun 2014 17:12:16 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
In-Reply-To: <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1406021656550.5874@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com> <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com> <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Jun 2014, Linus Torvalds wrote:

> On Mon, Jun 2, 2014 at 1:46 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > And what else do you want to do?
> >
> > Peter Zijlstra said "I've been using xchg() and cmpxchg() without such
> > consideration for quite a while." - so it basically implies that the
> > kernel is full of such races, mcs_spinlock is just the most visible one
> > that crashes the kernel first.
> 
> .. so your whole argument is bogus, because it doesn't actually fix
> anything else.
>
> Now, something that *would* fix something else is (for example) to
> just make "ACCESS_ONCE()" a rvalue so that you cannot use it for
> assignments, and then trying to sort out what happens then. It's
> possible that the "atomic_pointer_t" would be a part of the solution
> to that "what happens then", but THERE IS NO WAY IN HELL we're adding
> it for just one architecture and one use that doesn't warrant even
> _existing_ on that architecture.

The patch adds atomic_pointer_t for all architectures - it is in the 
common code and it is backed by atomic_long_t (that already exists for all 
architectures). There is no new arch-specific code at all.

When we have atomic_pointer_t, we can find the instances of xchg() and 
cmpxchg() and convert them to atomic_pointer_t (or to other atomic*_t 
types).

When we convert them all, we can drop xchg() and cmpxchg() at all (at 
least from architecture-neutral code).

The problem with xchg() and cmpxchg() is that they are very easy to 
misuse. Peter Zijlstra didn't know that they are not atomic w.r.t. normal 
stores, a lot of other people don't know it too - and if we allow these 
functions to be used, this race condition will reappear in the future 
again and again.

That's why I'm proposing atomic_pointer_t - it guarantees that this race 
condition can't be made.

> See what I'm saying?
> 
> You're not fixing the problem, you're fixing one unimportant detail
> that isn't worth fixing that way.
> 
>                Linus

Regarding reworking ACCESS_ONCE() for reads and writes - the problem is - 
how do you make people use it? ACCESS_ONCE() is already missing at a lot 
of places (it doesn't cause any visible bug on the condition that the 
compiler doesn't split the load or store to multiple accesses), I can 
assume that people will omit ATOMIC_ONCE_STORE() too even if we make it.

Mikulas
