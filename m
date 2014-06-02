Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaFBRPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:15:05 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55260 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbaFBRPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:15:03 -0400
Message-ID: <1401729299.2204.27.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chegu_vinod@hp.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Date: Mon, 02 Jun 2014 10:14:59 -0700
In-Reply-To: <20140602164339.GS22231@linux.vnet.ibm.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
	 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
	 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
	 <20140602164339.GS22231@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 09:43 -0700, Paul E. McKenney wrote:
> On Mon, Jun 02, 2014 at 06:25:25PM +0200, Peter Zijlstra wrote:
> > On Mon, Jun 02, 2014 at 12:00:45PM -0400, Mikulas Patocka wrote:
> > >  struct optimistic_spin_queue {
> > > -	struct optimistic_spin_queue *next, *prev;
> > > +	atomic_pointer(struct optimistic_spin_queue *) next;
> > > +	struct optimistic_spin_queue *prev;
> > >  	int locked; /* 1 if lock acquired */
> > >  };
> > >  
> > > Index: linux-3.15-rc8/include/asm-generic/atomic-long.h
> > > ===================================================================
> > > --- linux-3.15-rc8.orig/include/asm-generic/atomic-long.h	2014-06-02 17:11:17.000000000 +0200
> > > +++ linux-3.15-rc8/include/asm-generic/atomic-long.h	2014-06-02 17:11:50.000000000 +0200
> > > @@ -255,4 +255,31 @@ static inline long atomic_long_add_unles
> > >  
> > >  #endif  /*  BITS_PER_LONG == 64  */
> > >  
> > > +#define atomic_pointer(type)						\
> > > +union {									\
> > > +	atomic_long_t __a;						\
> > > +	type __t;							\
> > > +	char __check_sizeof[sizeof(type) == sizeof(long) ? 1 : -1];	\
> > > +}
> > 
> > That's still entirely disgusting, and afaict entirely redundant. You can
> > do that test in the operators below just fine.
> > 
> > > +#define ATOMIC_POINTER_INIT(i)	{ .__t = (i) }
> > > +
> > > +#define atomic_pointer_read(v)	((typeof((v)->__t))atomic_long_read(&(v)->__a))
> > > +
> > > +#define atomic_pointer_set(v, i)		({			\
> > > +	typeof((v)->__t) __i = (i);					\
> > > +	atomic_long_set(&(v)->__a, (long)(__i));			\
> > > +})
> > > +
> > > +#define atomic_pointer_xchg(v, i)		({			\
> > > +	typeof((v)->__t) __i = (i);					\
> > > +	(typeof((v)->__t))atomic_long_xchg(&(v)->__a, (long)(__i));	\
> > > +})
> > > +
> > > +#define atomic_pointer_cmpxchg(v, old, new)	({			\
> > > +	typeof((v)->__t) __old = (old);					\
> > > +	typeof((v)->__t) __new = (new);					\
> > > +	(typeof((v)->__t))atomic_long_cmpxchg(&(v)->__a, (long)(__old), (long)(__new));\
> > > +})
> > 
> > And I can't say I'm a particular fan of these ops either, as alternative
> > I'm almost inclined to just exclude parisc from using opt spinning.
> 
> That is an excellent point for this particular issue.  Do parisc systems
> really support enough CPUs to make queued spinlocks worthwhile?  If not,
> maybe we should just have parisc stick with traditional spinlocks.

Yes and No.  No for Linux because the only hyper CPU system is the
superdome, which we've never managed to boot linux on (it has some
complexities in the Bus architecture) and we're not likely to try
because the installations tend to cost north of US$1m.  For the Server
systems we do have a few high CPU count ones, but we lost access to them
when HP dismantled the parisc linux lab.  Currently the standard is
about 4 cpus.

I think just not using queued spinlocks is fine for us.  Should anyone
ever try the large CPU systems, we can revisit.

James


