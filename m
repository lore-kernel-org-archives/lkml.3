Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaBUTYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:24:19 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38278 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaBUTYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:24:17 -0500
Date: Fri, 21 Feb 2014 11:24:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Mark Batty <mbatty@cantab.net>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140221192412.GM4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1392740258.18779.7732.camel@triegel.csb>
 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
 <1392752867.18779.8120.camel@triegel.csb>
 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
 <20140220040102.GM4250@linux.vnet.ibm.com>
 <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
 <20140220083032.GN4250@linux.vnet.ibm.com>
 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
 <CAHWkzRQZ8+gOGMFNyTKjFNzpUv6d_J1G9KL0x_iCa=YCgvEojQ@mail.gmail.com>
 <CAHWkzRRxqhH+DnuQHu9bM4ywGBen3oqtT8W4Xqt1CFAHy2WQRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHWkzRRxqhH+DnuQHu9bM4ywGBen3oqtT8W4Xqt1CFAHy2WQRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022119-0928-0000-0000-000006F0BC76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 06:28:05PM +0000, Peter Sewell wrote:
> On 20 February 2014 17:01, Linus Torvalds <torvalds@linux-foundation.org
> >wrote:

[ . . . ]

> > > So, if you make one of two changes to your example, then I will agree
> > > with you.
> >
> > No. We're not playing games here. I'm fed up with complex examples
> > that make no sense.
> >
> > Nobody sane writes code that does that pointer comparison, and it is
> > entirely immaterial what the compiler can do behind our backs. The C
> > standard semantics need to make sense to the *user* (ie programmer),
> > not to a CPU and not to a compiler. The CPU and compiler are "tools".
> > They don't matter. Their only job is to make the code *work*, dammit.
> >
> > So no idiotic made-up examples that involve code that nobody will ever
> > write and that have subtle issues.
> >
> > So the starting point is that (same example as before, but with even
> > clearer naming):
> >
> > Initialization state:
> >   initialized = 0;
> >   value = 0;
> >
> > Consumer:
> >
> >     return atomic_read(&initialized, consume) ? value : -1;
> >
> > Writer:
> >     value = 42;
> >     atomic_write(&initialized, 1, release);
> >
> > and because the C memory ordering standard is written in such a way
> > that this is subtly buggy (and can return 0, which is *not* logically
> > a valid value), then I think the C memory ordering standard is broken.
> >
> > That "consumer" memory ordering is dangerous as hell, and it is
> > dangerous FOR NO GOOD REASON.
> >
> > The trivial "fix" to the standard would be to get rid of all the
> > "carries a dependency" crap, and just say that *anything* that depends
> > on it is ordered wrt it.
> >
> 
> There are two difficulties with this, if I understand correctly what
> you're proposing.
> 
> The first is knowing where to stop.  If one includes all data and
> control dependencies, pretty much all the continuation of execution
> would depend on the consume read, so the compiler would eventually
> have to give up and insert a gratuitous barrier.  One might imagine
> somehow annotating the return_expensive_system_value() you have below
> to say "stop dependency tracking at the return" (thereby perhaps
> enabling the compiler to optimise the barrier that you'd need in h/w
> to order the Linus-consume-read of initialised and the non-atomic read
> of calculated, replacing it by a compiler-introduced artificial
> dependency), and indeed that's roughly what the standard's
> kill_dependency does for consumes.

One way to tell the compiler where to stop would be to place markers
in the source code saying where dependencies stop.  These markers
could be provided by the definitions of the current rcu_read_unlock()
tags in the Linux kernel (and elsewhere, for that matter).  These would
be overridden by [[carries_dependency]] tags on function arguments and
return values, which is needed to handle the possibility of nested RCU
read-side critical sections.

> The second is the proposal in later mails to use some notion of
> "semantic" dependency instead of this syntactic one.  That's maybe
> attractive at first sight, but rather hard to define in a decent way
> in general.  To define whether the consume load can "really" affect
> some subsequent value, you need to know about all the set of possible
> executions of the program - which is exactly what we have to define.
> 
> For syntactic dependencies, in contrast, you can at least tell whether
> they exist by examining the source code you have in front of you.  The
> fact that artificial dependencies like (&x + y-y) are significant is
> (I guess) basically incidental at the C level - sometimes things like
> this are the best idiom to enforce ordering at the assembly level, but
> in C I imagine they won't normally arise.  If they do, it might be
> nicer to have a more informative syntax, eg (&x + dependency(y)).

This was in fact one of the arguments put forward in favor of carrying
dependencies through things like "y-y" back in the 2007-8 timeframe.

Can't say that I am much of a fan of manually tagging all dependencies:
Machines are much better at that sort of thing than are humans.
But just out of curiosity, did you instead mean (&x + dependency(y-y))
or some such?

							Thanx, Paul

