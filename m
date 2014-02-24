Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaBXRkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:40:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:54807 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaBXRkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:40:42 -0500
Date: Mon, 24 Feb 2014 09:40:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Matz <matz@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140224174037.GQ8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
 <20140220181116.GT4250@linux.vnet.ibm.com>
 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
 <20140220185608.GX4250@linux.vnet.ibm.com>
 <CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com>
 <20140220221027.GC4250@linux.vnet.ibm.com>
 <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com>
 <alpine.LNX.2.00.1402211847290.7694@wotan.suse.de>
 <20140221191318.GK4250@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1402241403580.7694@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1402241403580.7694@wotan.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022417-0928-0000-0000-000006C3CA92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 02:55:07PM +0100, Michael Matz wrote:
> Hi,
> 
> On Fri, 21 Feb 2014, Paul E. McKenney wrote:
> 
> > > And with conservative I mean "everything is a source of a dependency, and 
> > > hence can't be removed, reordered or otherwise fiddled with", and that 
> > > includes code sequences where no atomic objects are anywhere in sight [1].
> > > In the light of that the only realistic way (meaning to not have to 
> > > disable optimization everywhere) to implement consume as currently 
> > > specified is to map it to acquire.  At which point it becomes pointless.
> > 
> > No, only memory_order_consume loads and [[carries_dependency]]
> > function arguments are sources of dependency chains.
> 
> I don't see [[carries_dependency]] in the C11 final draft (yeah, should 
> get a real copy, I know, but let's assume it's the same language as the 
> standard).  Therefore, yes, only consume loads are sources of 
> dependencies.  The problem with the definition of the "carries a 
> dependency" relation is not the sources, but rather where it stops.  
> It's transitively closed over "value of evaluation A is used as operand in 
> evaluation B", with very few exceptions as per 5.1.2.4#14.  Evaluations 
> can contain function calls, so if there's _any_ chance that an operand of 
> an evaluation might even indirectly use something resulting from a consume 
> load then that evaluation must be compiled in a way to not break 
> dependency chains.
> 
> I don't see a way to generally assume that e.g. the value of a function 
> argument can impossibly result from a consume load, therefore the compiler 
> must assume that all function arguments _can_ result from such loads, and 
> so must disable all depchain breaking optimization (which are many).
> 
> > > [1] Simple example of what type of transformations would be disallowed:
> > > 
> > > int getzero (int i) { return i - i; }
> > 
> > This needs to be as follows:
> > 
> > [[carries_dependency]] int getzero(int i [[carries_dependency]])
> > {
> > 	return i - i;
> > }
> > 
> > Otherwise dependencies won't get carried through it.
> 
> So, with the above do you agree that in absense of any other magic (see 
> below) the compiler is not allowed to transform my initial getzero() 
> (without the carries_dependency markers) implementation into "return 0;" 
> because of the C11 rules for "carries-a-dependency"?
> 
> If so, do you then also agree that the specification of "carries a 
> dependency" is somewhat, err, shall we say, overbroad?

>From what I can see, overbroad.  The problem is that the C++11 standard
defines how carries-dependency interacts with function calls and returns
in 7.6.4, which describes the [[carries_dependency]] attribute.  For example,
7.6.4p6 says:

	Function g’s second parameter has a carries_dependency
	attribute, but its first parameter does not. Therefore, function
	h’s first call to g carries a dependency into g, but its second
	call does not. The implementation might need to insert a fence
	prior to the second call to g.

When C11 declined to take attributes, they also left out the part saying
how carries-dependency interacts with functions.  :-/

Might be fixed by now, checking up on it.

One could argue that the bit about emitting fence instructions at
function calls and returns is implied by the as-if rule even without
this wording, but...

> > > depchains don't matter, could _then_ optmize it to zero.  But that's 
> > > insane, especially considering that it's hard to detect if a given context 
> > > doesn't care for depchains, after all the depchain relation is constructed 
> > > exactly so that it bleeds into nearly everywhere.  So we would most of 
> > > the time have to assume that the ultimate context will be depchain-aware 
> > > and therefore disable many transformations.
> > 
> > Any function that does not contain a memory_order_consume load and that 
> > doesn't have any arguments marked [[carries_dependency]] can be 
> > optimized just as before.
> 
> And as such marker doesn't exist we must conservatively assume that it's 
> on _all_ parameters, so I'll stand by my claim.

Or that you have to emit a fence instruction when a dependency chain
enters or leaves a function in cases where all callers/calles are not
visible to the compiler.

My preference is that the ordering properties of a carries-dependency
chain is implementation defined at the point that it enters or leaves
a function without the marker, but others strongly disagreed.  ;-)

> > > Then inlining getzero would merely add another "# j.dep = i.dep" 
> > > relation, so depchains are still there but the value optimization can 
> > > happen before inlining.  Having to do something like that I'd find 
> > > disgusting, and rather rewrite consume into acquire :)  Or make the 
> > > depchain relation somehow realistically implementable.
> > 
> > I was actually OK with arithmetic cancellation breaking the dependency 
> > chains.  Others on the committee felt otherwise, and I figured that (1) 
> > I wouldn't be writing that kind of function anyway and (2) they knew 
> > more about writing compilers than I.  I would still be OK saying that 
> > things like "i-i", "i*0", "i%1", "i&0", "i|~0" and so on just break the 
> > dependency chain.
> 
> Exactly.  I can see the problem that people had with that, though.  There 
> are very many ways to write conceiled zeros (or generally neutral elements 
> of the function in question).  My getzero() function is one (it could e.g. 
> be an assembler implementation).  The allowance to break dependency chains 
> would have to apply to such cancellation as well, and so can't simply 
> itemize all cases in which cancellation is allowed.  Rather it would have 
> had to argue about something like "value dependency", ala "evaluation B 
> depends on A, if there exist at least two different values A1 and A2 
> (results from A), for which evaluation B (with otherwise same operands) 
> yields different values B1 and B2".

And that was in fact one of the arguments used against me.  ;-)

> Alas, it doesn't, except if you want to understand the term "the value of 
> A is used as an operand of B" in that way.  Even then you'd still have the 
> second case of the depchain definition, via intermediate not even atomic 
> memory stores and loads to make two evaluations be ordered per 
> carries-a-dependency.
> 
> And even that understanding of "is used" wouldn't be enough, because there 
> are cases where the cancellation happens in steps, and where it interacts 
> with the third clause (transitiveness):  Assume this:
> 
>   a = something()  // evaluation A
>   b = 1 - a        // evaluation B
>   c = a - 1 + b    // evaluation C
> 
> Now, clearly B depends on A.  Also C depends on B (because with otherwise 
> same operands changing just B also changes C), because of transitiveness C 
> then also depends on A.  But equally cleary C was just an elaborate way to 
> write "0", and so depends on nothing.  The problem was of course that A 
> and B weren't independent when determining the dependencies of C.  But 
> allowing cancellation to break dependency chains would have to allow for 
> these cases as well.
> 
> So, now, that leaves us basically with depchains forcing us to disable 
> many useful transformation or finding some other magic.  One would be to 
> just regard all consume loads as acquire loads and be done (and 
> effectively remove the ill-advised "carries a dependency" relation from 
> consideration).
> 
> You say downthread that it'd also be possible to just emit barriers before 
> all function calls (I say "all" because the compiler will generally 
> have applied some transformation that broke depchains if they existed).  
> That seems to me to be a bigger hammer than just ignoring depchains and 
> emit acquires instead of consumes (because the latter changes only exactly 
> where atomics are used, the former seems to me to have unbounded effect).

Yep, converting the acquire to a consume is a valid alternative to
emitting a memory-barrier instruction prior to entering/exiting the
function in question.

> So, am still missing something or is my understanding of the 
> carries-a-dependency relation correct and my conclusions are merely too 
> pessimistic?

Given the definition as it is, I believe you understand it.

							Thanx, Paul

