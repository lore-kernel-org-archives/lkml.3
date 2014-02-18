Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaBRQv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:51:26 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51762 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaBRQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:51:24 -0500
Date: Tue, 18 Feb 2014 08:51:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218165119.GN4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1392352981.18779.3800.camel@triegel.csb>
 <20140214172920.GQ4250@linux.vnet.ibm.com>
 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
 <1392486310.18779.6447.camel@triegel.csb>
 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <20140218030002.GA15857@linux.vnet.ibm.com>
 <1392739000.18779.7692.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392739000.18779.7692.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021816-9332-0000-0000-00000324D3C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 04:56:40PM +0100, Torvald Riegel wrote:
> On Mon, 2014-02-17 at 19:00 -0800, Paul E. McKenney wrote:
> > On Mon, Feb 17, 2014 at 12:18:21PM -0800, Linus Torvalds wrote:
> > > On Mon, Feb 17, 2014 at 11:55 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > > >
> > > > Which example do you have in mind here?  Haven't we resolved all the
> > > > debated examples, or did I miss any?
> > > 
> > > Well, Paul seems to still think that the standard possibly allows
> > > speculative writes or possibly value speculation in ways that break
> > > the hardware-guaranteed orderings.
> > 
> > It is not that I know of any specific problems, but rather that I
> > know I haven't looked under all the rocks.  Plus my impression from
> > my few years on the committee is that the standard will be pushed to
> > the limit when it comes time to add optimizations.
> > 
> > One example that I learned about last week uses the branch-prediction
> > hardware to validate value speculation.  And no, I am not at all a fan
> > of value speculation, in case you were curious.  However, it is still
> > an educational example.
> > 
> > This is where you start:
> > 
> > 	p = gp.load_explicit(memory_order_consume); /* AKA rcu_dereference() */
> > 	do_something(p->a, p->b, p->c);
> > 	p->d = 1;
> 
> I assume that's the source code.

Yep!

> > Then you leverage branch-prediction hardware as follows:
> > 
> > 	p = gp.load_explicit(memory_order_consume); /* AKA rcu_dereference() */
> > 	if (p == GUESS) {
> > 		do_something(GUESS->a, GUESS->b, GUESS->c);
> > 		GUESS->d = 1;
> > 	} else {
> > 		do_something(p->a, p->b, p->c);
> > 		p->d = 1;
> > 	}
> 
> I assume that this is a potential transformation by a compiler.

Again, yep!

> > The CPU's branch-prediction hardware squashes speculation in the case where
> > the guess was wrong, and this prevents the speculative store to ->d from
> > ever being visible.  However, the then-clause breaks dependencies, which
> > means that the loads -could- be speculated, so that do_something() gets
> > passed pre-initialization values.
> > 
> > Now, I hope and expect that the wording in the standard about dependency
> > ordering prohibits this sort of thing.  But I do not yet know for certain.
> 
> The transformation would be incorrect.  p->a in the source code carries
> a dependency, and as you say, the transformed code wouldn't have that
> dependency any more.  So the transformed code would loose ordering
> constraints that it has in the virtual machine, so in the absence of
> other proofs of correctness based on properties not shown in the
> example, the transformed code would not result in the same behavior as
> allowed by the abstract machine.

Glad that you agree!  ;-)

> If the transformation would actually be by a programmer, then this
> wouldn't do the same as the first example because mo_consume doesn't
> work through the if statement.

Agreed.

> Are there other specified concerns that you have regarding this example?

Nope.  Just generalized paranoia.  (But just because I am paranoid
doesn't mean that there isn't a bug lurking somewhere in the standard,
the compiler, the kernel, or my own head!)

I will likely have more once I start mapping Linux kernel atomics to the
C11 standard.  One more paper past N3934 comes first, though.

							Thanx, Paul

