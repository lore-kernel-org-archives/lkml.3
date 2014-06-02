Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaFBQns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:43:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49498 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaFBQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:43:46 -0400
Date: Mon, 2 Jun 2014 09:43:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chegu_vinod@hp.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140602164339.GS22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602162525.GH16155@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060216-0928-0000-0000-00000259A056
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 06:25:25PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 02, 2014 at 12:00:45PM -0400, Mikulas Patocka wrote:
> >  struct optimistic_spin_queue {
> > -	struct optimistic_spin_queue *next, *prev;
> > +	atomic_pointer(struct optimistic_spin_queue *) next;
> > +	struct optimistic_spin_queue *prev;
> >  	int locked; /* 1 if lock acquired */
> >  };
> >  
> > Index: linux-3.15-rc8/include/asm-generic/atomic-long.h
> > ===================================================================
> > --- linux-3.15-rc8.orig/include/asm-generic/atomic-long.h	2014-06-02 17:11:17.000000000 +0200
> > +++ linux-3.15-rc8/include/asm-generic/atomic-long.h	2014-06-02 17:11:50.000000000 +0200
> > @@ -255,4 +255,31 @@ static inline long atomic_long_add_unles
> >  
> >  #endif  /*  BITS_PER_LONG == 64  */
> >  
> > +#define atomic_pointer(type)						\
> > +union {									\
> > +	atomic_long_t __a;						\
> > +	type __t;							\
> > +	char __check_sizeof[sizeof(type) == sizeof(long) ? 1 : -1];	\
> > +}
> 
> That's still entirely disgusting, and afaict entirely redundant. You can
> do that test in the operators below just fine.
> 
> > +#define ATOMIC_POINTER_INIT(i)	{ .__t = (i) }
> > +
> > +#define atomic_pointer_read(v)	((typeof((v)->__t))atomic_long_read(&(v)->__a))
> > +
> > +#define atomic_pointer_set(v, i)		({			\
> > +	typeof((v)->__t) __i = (i);					\
> > +	atomic_long_set(&(v)->__a, (long)(__i));			\
> > +})
> > +
> > +#define atomic_pointer_xchg(v, i)		({			\
> > +	typeof((v)->__t) __i = (i);					\
> > +	(typeof((v)->__t))atomic_long_xchg(&(v)->__a, (long)(__i));	\
> > +})
> > +
> > +#define atomic_pointer_cmpxchg(v, old, new)	({			\
> > +	typeof((v)->__t) __old = (old);					\
> > +	typeof((v)->__t) __new = (new);					\
> > +	(typeof((v)->__t))atomic_long_cmpxchg(&(v)->__a, (long)(__old), (long)(__new));\
> > +})
> 
> And I can't say I'm a particular fan of these ops either, as alternative
> I'm almost inclined to just exclude parisc from using opt spinning.

That is an excellent point for this particular issue.  Do parisc systems
really support enough CPUs to make queued spinlocks worthwhile?  If not,
maybe we should just have parisc stick with traditional spinlocks.

> That said, this patch still doesn't address the far more interesting
> problem of actually finding these issues for these few weird archs.

Indeed.  And finding other lower-probability failures due to other
atomic manipulations of pointers that are also accessed with normal
loads and stores.

							Thanx, Paul

