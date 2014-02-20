Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaBTSLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:11:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:49496 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaBTSLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:11:23 -0500
Date: Thu, 20 Feb 2014 10:11:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140220181116.GT4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
 <1392740258.18779.7732.camel@triegel.csb>
 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
 <1392752867.18779.8120.camel@triegel.csb>
 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
 <20140220040102.GM4250@linux.vnet.ibm.com>
 <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
 <20140220083032.GN4250@linux.vnet.ibm.com>
 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022018-9332-0000-0000-0000032CE5B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 09:01:06AM -0800, Linus Torvalds wrote:
> On Thu, Feb 20, 2014 at 12:30 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >> So lets make this really simple: if you have a consume->cmp->read, is
> >> the ordering of the two reads guaranteed?
> >
> > Not as far as I know.  Also, as far as I know, there is no difference
> > between consume and relaxed in the consume->cmp->read case.
> 
> Ok, quite frankly, I think that means that "consume" is misdesigned.
> 
> > The above example can have a return value of 0 if translated
> > straightforwardly into either ARM or Power, right?
> 
> Correct. And I think that is too subtle. It's dangerous, it makes code
> that *looks* correct work incorrectly, and it actually happens to work
> on x86 since x86 doesn't have crap-for-brains memory ordering
> semantics.
> 
> > So, if you make one of two changes to your example, then I will agree
> > with you.
> 
> No. We're not playing games here. I'm fed up with complex examples
> that make no sense.

Hey, your original example didn't do what you wanted given the current
standard.  Those two modified examples are no more complex than your
original, and are the closest approximations that I can come up with
right off-hand that provide the result you wanted.

> Nobody sane writes code that does that pointer comparison, and it is
> entirely immaterial what the compiler can do behind our backs. The C
> standard semantics need to make sense to the *user* (ie programmer),
> not to a CPU and not to a compiler. The CPU and compiler are "tools".
> They don't matter. Their only job is to make the code *work*, dammit.
> 
> So no idiotic made-up examples that involve code that nobody will ever
> write and that have subtle issues.

There are places in the Linux kernel that do both pointer comparisons
and dereferences.  Something like the following:

	p = rcu_dereference(gp);
	if (!p)
		p = &default_structure;
	do_something_with(p->a, p->b);

In the typical case where default_structure was initialized early on,
no ordering is needed in the !p case.

> So the starting point is that (same example as before, but with even
> clearer naming):
> 
> Initialization state:
>   initialized = 0;
>   value = 0;
> 
> Consumer:
> 
>     return atomic_read(&initialized, consume) ? value : -1;
> 
> Writer:
>     value = 42;
>     atomic_write(&initialized, 1, release);
> 
> and because the C memory ordering standard is written in such a way
> that this is subtly buggy (and can return 0, which is *not* logically
> a valid value), then I think the C memory ordering standard is broken.

You really need that "consume" to be "acquire".

> That "consumer" memory ordering is dangerous as hell, and it is
> dangerous FOR NO GOOD REASON.
> 
> The trivial "fix" to the standard would be to get rid of all the
> "carries a dependency" crap, and just say that *anything* that depends
> on it is ordered wrt it.
> 
> That just means that on alpha, "consume" implies an unconditional read
> barrier (well, unless the value is never used and is loaded just
> because it is also volatile), on x86, "consume" is the same as
> "acquire" which is just a plain load with ordering guarantees, and on
> ARM or power you can still avoid the extra synchronization *if* the
> value is used just for computation and for following pointers, but if
> the value is used for a comparison, there needs to be a
> synchronization barrier.

Except in the default-value case, where no barrier is required.

People really do comparisons on the pointers that they get back from
rcu_dereference(), either to check for NULL (as above) or to check for
a specific pointer.  Ordering is not required in those cases.  The
cases that do require ordering from memory_order_consume values being
used in an "if" statement should instead be memory_order_acquire.

> Notice? Getting rid of the stupid "carries-dependency" crap from the
> standard actually
>  (a) simplifies the standard
>  (b) means that the above obvious example *works*
>  (c) does not in *any* way make for any less efficient code generation
> for the cases that "consume" works correctly for in the current
> mis-designed standard.
>  (d) is actually a hell of a lot easier to explain to a compiler
> writer, and I can guarantee that it is simpler to implement too.
> 
> Why do I claim (d) "it is simpler to implement" - because on ARM/power
> you can implement it *exactly* as a special "acquire", with just a
> trivial peep-hole special case that follows the use chain of the
> acquire op to the consume, and then just drop the acquire bit if the
> only use is that compute-to-load chain.

I don't believe that it is quite that simple.

But yes, the compiler guys would be extremely happy to simply drop
memory_order_consume from the standard, as it is the memory order
that they most love to hate.

Getting them to agree to any sort of peep-hole optimization semantics
for memory_order_consume is likely problematic.  

> In fact, realistically, the *only* thing you need to actually care
> about for the intended use case of "consume" is the question "is the
> consuming load immediately consumed as an address (with offset) of a
> memory operation. So you don't even need to follow any complicated
> computation chain in a compiler - the only case that matters for the
> barrier removal optimization is the "oh, I can see that it is only
> used as an address to a dereference".
> 
> Seriously. The current standard is broken. It's broken because it
> mis-compiles code that on the face of it looks logical and works, it's
> broken because it's overly complex, and it's broken because the
> complexity doesn't even *buy* you anything. All this complexity for no
> reason. When much simpler wording and implementation actually WORKS
> BETTER.

I disagree.  The use cases you claim are memory_order_consume breakage
are really bugs.  You should use memory_order_acquire in those cases.

							Thanx, Paul

