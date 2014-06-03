Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbaFCPAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:00:02 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39934 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaFCO77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:59:59 -0400
Date: Tue, 3 Jun 2014 07:07:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140603140727.GM22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
 <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com>
 <alpine.LRH.2.02.1406021656550.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <20140603073613.GH11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603073613.GH11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060314-0928-0000-0000-0000026D99A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:36:13AM +0200, Peter Zijlstra wrote:
> On Mon, Jun 02, 2014 at 05:12:16PM -0400, Mikulas Patocka wrote:
> > The patch adds atomic_pointer_t for all architectures - it is in the 
> > common code and it is backed by atomic_long_t (that already exists for all 
> > architectures). There is no new arch-specific code at all.
> > 
> > When we have atomic_pointer_t, we can find the instances of xchg() and 
> > cmpxchg() and convert them to atomic_pointer_t (or to other atomic*_t 
> > types).
> > 
> > When we convert them all, we can drop xchg() and cmpxchg() at all (at 
> > least from architecture-neutral code).
> > 
> > The problem with xchg() and cmpxchg() is that they are very easy to 
> > misuse. Peter Zijlstra didn't know that they are not atomic w.r.t. normal 
> > stores, a lot of other people don't know it too - and if we allow these 
> > functions to be used, this race condition will reappear in the future 
> > again and again.
> > 
> > That's why I'm proposing atomic_pointer_t - it guarantees that this race 
> > condition can't be made.
> 
> But its horrible, and doesn't have any benefit afaict.
> 
> So if we really want to keep supporting these platforms; I would propose
> something like:
> 
> #ifdef __CHECKER__
> #define __atomic	__attribute__((address_space(5)))
> #else
> #define __atomic
> #endif
> 
> #define store(p, v)	(*(p) = (typeof(*(p)) __force __atomic)(v))
> #define load(p)		((typeof(*p) __force)ACCESS_ONCE(*(p)))
> 
> Along with changes to xchg() and cmpxchg() that require them to take
> pointers to __atomic.
> 
> That way we keep the flexibility of xchg() and cmpxchg() for being
> (mostly) type and size invariant, and get sparse to find wrong usage.
> 
> Then parisc, sparc32, tile32, metag-lock1 and arc-!llsc can go implement
> store() however they like.

Should be fun interacting with atomic operations on __rcu variables
(address space 4).  Of course, that is already fun...

							Thanx, Paul

