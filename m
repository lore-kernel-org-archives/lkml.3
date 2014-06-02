Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaFBP6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:58:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaFBP6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:58:14 -0400
Date: Mon, 2 Jun 2014 11:57:14 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        John David Anglin <dave.anglin@bell.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chegu_vinod@hp.com, Waiman.Long@hp.com,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
In-Reply-To: <20140602132454.GO22231@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.02.1406021146030.20627@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <20140601192026.GE16155@laptop.programming.kicks-ass.net> <BLU0-SMTP387BD0AE22A4EAD432D65F97210@phx.gbl> <20140601213003.GG16155@laptop.programming.kicks-ass.net>
 <alpine.LRH.2.02.1406020503000.17105@file01.intranet.prod.int.rdu2.redhat.com> <20140602132454.GO22231@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Jun 2014, Paul E. McKenney wrote:

> On Mon, Jun 02, 2014 at 05:19:39AM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Sun, 1 Jun 2014, Peter Zijlstra wrote:
> > 
> > > On Sun, Jun 01, 2014 at 04:46:26PM -0400, John David Anglin wrote:
> > > > On 1-Jun-14, at 3:20 PM, Peter Zijlstra wrote:
> > > > 
> > > > >>If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg
> > > > >>at
> > > > >>the same time, you break it. ACCESS_ONCE doesn't take the hashed
> > > > >>spinlock,
> > > > >>so, in this case, cmpxchg or xchg isn't really atomic at all.
> > > > >
> > > > >And this is really the first place in the kernel that breaks like this?
> > > > >I've been using xchg() and cmpxchg() without such consideration for
> > > > >quite a while.
> > > > 
> > > > I believe Mikulas is correct.  Even in a controlled situation where a
> > > > cmpxchg operation
> > > > is used to implement pthread_spin_lock() in userspace, we found recently
> > > > that the lock
> > > > must be released with a  cmpxchg operation and not a simple write on SMP
> > > > systems.
> > > > There is a race in the cache operations or instruction ordering that's not
> > > > present with
> > > > the ldcw instruction.
> > > 
> > > Oh, I'm not arguing that. He's quite right that its broken, but this
> > > form of atomic ops is also quite insane and unusual. Most sane machines
> > > don't have this problem.
> > > 
> > > My main concern is how are we going to avoid breaking parisc (and I
> > > think sparc32, which is similarly retarded) in the future; we should
> > > invest in machinery to find and detect these things.
> > 
> > Grep the kernel for "\<xchg\>" and "\<cmpxchg\>" and replace them with 
> > atomic types and atomic access functions.
> 
> Not so good for pointers, though.  Defeats type-checking, for one thing.
> An example of this is use of xchg() for atomically enqueuing RCU callbacks
> in kernel/rcu/tree_plugin.h.
> 
> I still like the idea of PA-RISC's compiler implementing ACCESS_ONCE()
> as needed to make things work on that architecture.
> 
> 							Thanx, Paul

We can perform some preprocessor tricks to check the pointer type. See my 
next patch that adds type checking - you declare the variable with

	atomic_pointer(struct optimistic_spin_queue *) next;

and the pointer type is checked on all atomic operations involving this 
variable.


The problem with ACCESS_ONCE is that people omit it. There's plenty of 
places in the kernel where ACCESS_ONCE should be used and isn't 
(i_size_read, i_size_write, rt_mutex_is_locked...). Nothing really forces 
people to write the code correctly and use it.

atomic_pointer (and other atomic types) have the advantage that they force 
people to use the atomic functions to access them. If you read or write to 
the variable directly, it won't compile.

I think the best solution is to wrap the critical pointers with 
atomic_pointer(pointer_type *) and let the compiler report errors on all 
places where it is used unsafely.

Mikulas
