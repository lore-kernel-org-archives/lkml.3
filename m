Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbaFCOTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:19:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbaFCOT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:19:27 -0400
Date: Tue, 3 Jun 2014 10:18:05 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <20140603132439.GN30445@twins.programming.kicks-ass.net>
Message-ID: <alpine.LRH.2.02.1406031007420.15434@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com> <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com> <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com> <alpine.LRH.2.02.1406021656550.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <20140603073613.GH11096@twins.programming.kicks-ass.net> <alpine.LRH.2.02.1406030341570.10639@file01.intranet.prod.int.rdu2.redhat.com> <20140603132439.GN30445@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jun 2014, Peter Zijlstra wrote:

> On Tue, Jun 03, 2014 at 07:14:31AM -0400, Mikulas Patocka wrote:
> > > So if we really want to keep supporting these platforms; I would propose
> > > something like:
> > > 
> > > #ifdef __CHECKER__
> > > #define __atomic	__attribute__((address_space(5)))
> > > #else
> > > #define __atomic
> > > #endif
> > > 
> > > #define store(p, v)	(*(p) = (typeof(*(p)) __force __atomic)(v))
> > > #define load(p)		((typeof(*p) __force)ACCESS_ONCE(*(p)))
> > > 
> > > Along with changes to xchg() and cmpxchg() that require them to take
> > > pointers to __atomic.
> > > 
> > > That way we keep the flexibility of xchg() and cmpxchg() for being
> > > (mostly) type and size invariant, and get sparse to find wrong usage.
> > > 
> > > Then parisc, sparc32, tile32, metag-lock1 and arc-!llsc can go implement
> > > store() however they like.
> > 
> > Your proposal is very good because it warns about incorrect usage 
> > automatically.
> 
> Exactly the point.
> 
> > Your usage is very similar to what my patch at the top of this thread 
> > does:
> > 
> > Instead of "__atomic struct s *p;" declaration, my patch uses
> > "atomic_pointer(struct s*) p;" as the declaration
> > Instead of store(&p, v), my patch uses atomic_pointer_set(&p, v);
> > Instead of load(&p), my patch uses atomic_pointer_get(&p);
> > Instead of xchg(&p, v), my patch uses atomic_pointer_xchg(&p, v);
> > Instead of cmpxchg(&p, v1, v2), my patch uses atomic_pointer_cmpxchg(&p1, v1, v2);
> > 
> > > But its horrible, and doesn't have any benefit afaict.
> > 
> > See the five cases above - why do you say that the operation on the left 
> > is good and the operation on the right is horrible? To me, it looks like 
> > they are both similar, they are just named differently. Both check the 
> > type of the pointer and warns if the user passes incompatible pointer. If 
> > I rename the operations in my patch to store(), load(), xchg(), cmpxchg(), 
> > would you like it?
> 
> Nope.. because the above store,load,xchg,cmpxchg are type invariant and
> work for anything of size (1),2,4,(8).
> 
> So I dislike your proposal on a number of points:
> 
>  1) its got pointer in, and while the immediate problem is indeed with
>  pointers, there is no reason it always should be, so we'll keep on
>  introducing new APIs;
> 
>  2) its got a fixed length, nl. sizeof(void *), if we were to find
>  another case which had the same problem which used 'int' we'd have to
>  again create new APIs;
> 
>  3) you only fixed the one site;
> 
>  4) I'm the lazy kind and atomic_foo_* is just too much typing, let
>  alone remembering all the various new atomic_foo_ APIs resulting from
>  all this.
> 
> This is the place where I really miss C++ templates; and yes before
> people shoot me in the head for that, I do know about all the various
> pitfalls and down sides of those too.
> 
> > My patch has advantage (over your #define __atomic 
> > __attribute__((address_space(5))) ) that it checks the mismatches at 
> > compile time. Your proposal only check them with sparse. But either way - 
> > it is very good that the mismatches are being checked automatically.
> 
> So my proposal goes a lot further in that by making xchg() and cmpxchg()
> require pointer to __atomic, all sites get coverage, not only the one
> case where you found was a problem.
> 
> Yes, this requires a lot more effort, for we'll have to pretty much
> audit and annotate the entire tree, but such things can be done, see for
> example the introduction of __rcu.
> 
> Also, these days we get automagic emails if we introduce new sparse
> fails, so it being sparse and not gcc isn't really any threshold at all.
> 
> > We need some method to catch these races automatically. There are places 
> > where people xchg() or cmpxchg() with direct modifications, see for 
> > example this:
> 
> Yep, so all those places will immediately stand out, the first fail will
> be that those variables aren't marked __atomic, once you do that, the
> direct assignment will complain about crossing the address_space marker.
> 
> Voila, sorted.

I originally wanted to remove PA-RISC xchg and cmpxchg, force compile 
failure on places where it is used and convert them to atomic operations. 
But there's a lot of such places, the patch would be big and it would 
probably trigger some compile failures in configurations that I can't 
test.

So, I agree that your approch with sparse tagging is better, it only warns 
about unsafe use and it won't be breaking compilation for so many people.

Mikulas
