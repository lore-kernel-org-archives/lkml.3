Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaCGTCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:02:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33030 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaCGTCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:02:09 -0500
Date: Fri, 7 Mar 2014 11:02:04 -0800
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
Message-ID: <20140307190204.GQ3334@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
 <20140227205312.GX8264@linux.vnet.ibm.com>
 <20140301005047.GA14777@linux.vnet.ibm.com>
 <1393872908.28840.11660.camel@triegel.csb>
 <20140303192026.GO11910@linux.vnet.ibm.com>
 <1393879579.28840.11949.camel@triegel.csb>
 <20140304190032.GY11910@linux.vnet.ibm.com>
 <1394036796.28840.14900.camel@triegel.csb>
 <20140305180136.GL3334@linux.vnet.ibm.com>
 <1394214357.28840.19386.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394214357.28840.19386.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030719-3532-0000-0000-0000002437CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:45:57PM +0100, Torvald Riegel wrote:
> xagsmtp5.20140307174618.3777@vmsdvm6.vnet.ibm.com
> X-Xagent-Gateway: vmsdvm6.vnet.ibm.com (XAGSMTP5 at VMSDVM6)
> 
> On Wed, 2014-03-05 at 10:01 -0800, Paul E. McKenney wrote:
> > On Wed, Mar 05, 2014 at 05:26:36PM +0100, Torvald Riegel wrote:
> > > xagsmtp3.20140305162928.8243@uk1vsc.vnet.ibm.com
> > > X-Xagent-Gateway: uk1vsc.vnet.ibm.com (XAGSMTP3 at UK1VSC)
> > > 
> > > On Tue, 2014-03-04 at 11:00 -0800, Paul E. McKenney wrote:
> > > > On Mon, Mar 03, 2014 at 09:46:19PM +0100, Torvald Riegel wrote:
> > > > > xagsmtp2.20140303204700.3556@vmsdvma.vnet.ibm.com
> > > > > X-Xagent-Gateway: vmsdvma.vnet.ibm.com (XAGSMTP2 at VMSDVMA)
> > > > > 
> > > > > On Mon, 2014-03-03 at 11:20 -0800, Paul E. McKenney wrote:
> > > > > > On Mon, Mar 03, 2014 at 07:55:08PM +0100, Torvald Riegel wrote:
> > > > > > > xagsmtp2.20140303190831.9500@uk1vsc.vnet.ibm.com
> > > > > > > X-Xagent-Gateway: uk1vsc.vnet.ibm.com (XAGSMTP2 at UK1VSC)
> > > > > > > 
> > > > > > > On Fri, 2014-02-28 at 16:50 -0800, Paul E. McKenney wrote:
> > > > > > > > +o	Do not use the results from the boolean "&&" and "||" when
> > > > > > > > +	dereferencing.	For example, the following (rather improbable)
> > > > > > > > +	code is buggy:
> > > > > > > > +
> > > > > > > > +		int a[2];
> > > > > > > > +		int index;
> > > > > > > > +		int force_zero_index = 1;
> > > > > > > > +
> > > > > > > > +		...
> > > > > > > > +
> > > > > > > > +		r1 = rcu_dereference(i1)
> > > > > > > > +		r2 = a[r1 && force_zero_index];  /* BUGGY!!! */
> > > > > > > > +
> > > > > > > > +	The reason this is buggy is that "&&" and "||" are often compiled
> > > > > > > > +	using branches.  While weak-memory machines such as ARM or PowerPC
> > > > > > > > +	do order stores after such branches, they can speculate loads,
> > > > > > > > +	which can result in misordering bugs.
> > > > > > > > +
> > > > > > > > +o	Do not use the results from relational operators ("==", "!=",
> > > > > > > > +	">", ">=", "<", or "<=") when dereferencing.  For example,
> > > > > > > > +	the following (quite strange) code is buggy:
> > > > > > > > +
> > > > > > > > +		int a[2];
> > > > > > > > +		int index;
> > > > > > > > +		int flip_index = 0;
> > > > > > > > +
> > > > > > > > +		...
> > > > > > > > +
> > > > > > > > +		r1 = rcu_dereference(i1)
> > > > > > > > +		r2 = a[r1 != flip_index];  /* BUGGY!!! */
> > > > > > > > +
> > > > > > > > +	As before, the reason this is buggy is that relational operators
> > > > > > > > +	are often compiled using branches.  And as before, although
> > > > > > > > +	weak-memory machines such as ARM or PowerPC do order stores
> > > > > > > > +	after such branches, but can speculate loads, which can again
> > > > > > > > +	result in misordering bugs.
> > > > > > > 
> > > > > > > Those two would be allowed by the wording I have recently proposed,
> > > > > > > AFAICS.  r1 != flip_index would result in two possible values (unless
> > > > > > > there are further constraints due to the type of r1 and the values that
> > > > > > > flip_index can have).
> > > > > > 
> > > > > > And I am OK with the value_dep_preserving type providing more/better
> > > > > > guarantees than we get by default from current compilers.
> > > > > > 
> > > > > > One question, though.  Suppose that the code did not want a value
> > > > > > dependency to be tracked through a comparison operator.  What does
> > > > > > the developer do in that case?  (The reason I ask is that I have
> > > > > > not yet found a use case in the Linux kernel that expects a value
> > > > > > dependency to be tracked through a comparison.)
> > > > > 
> > > > > Hmm.  I suppose use an explicit cast to non-vdp before or after the
> > > > > comparison?
> > > > 
> > > > That should work well assuming that things like "if", "while", and "?:"
> > > > conditions are happy to take a vdp.
> > > 
> > > I currently don't see a reason why that should be disallowed.  If we
> > > have allowed an implicit conversion to non-vdp, I believe that should
> > > follow.
> > 
> > I am a bit nervous about a silent implicit conversion from vdp to
> > non-vdp in the general case.
> 
> Why are you nervous about it?

If someone expects the vdp to propagate into some function that might
be compiled with aggressive optimizations that break this expectation,
it would be good for that someone to know about it.

Ah!  I am assuming that the compiler is -not- emitting memory barriers
at vdp-to-non-vdp transitions.  In that case, warnings are even more
important -- without the warnings, it is a real pain chasing these
unnecessary memory barriers out of the code.

So we are -not- in the business of emitting memory barriers on
vdp-to-non-vdp transitions, right?

> > However, when the result is being used by
> > a conditional, the silent implicit conversion makes a lot of sense.
> > Is that distinction something that the compiler can handle easily?
> 
> I think so. I'm not a language lawyer, but we have other such
> conversions in the standard (e.g., int to boolean, between int and
> float) and I currently don't see a fundamental difference to those.  But
> we'll have to ask the language folks (or SG1 or LEWG) to really verify
> that.

Understood!

> > On the other hand, silent implicit conversion from non-vdp to vdp
> > is very useful for common code that can be invoked both by RCU
> > readers and by updaters.
> 
> I'd be more nervous about that because then there's less obstacles to
> one programmer expecting a vdp to indicate a dependency vs. another
> programmer putting non-vdp into vdp.

Well, that is the concern either way.  But the usual reason for putting
non-vdp into vdp is because the update-side code holds the lock, so
that nothing can change.  In this case, there is no harm in passing
the non-vdp pointer to a vdp function.

In contrast, on the read side, there is nothing preventing the underlying
data from changing at any time.  So if you have a read-side vdp, passing
it to a non-vdp function could result in an ordering bug.

And given the choice, what I would want would be to be warned of a
vdp-to-non-vdp transition within an RCU read-side critical section,
but not outside of an RCU read-side critical section.  Not sure whether
that is practical from a compiler viewpoint, though.  (Would need to tell
the compiler about rcu_read_unlock(), which is easy from my perspective,
but there are interactions with vdp-marked parameters and return values.)

> For this case of common code (which I agree is a valid concern), would
> it be a lot of programmer overhead to add explicit casts from non-vdp to
> vdp?  Would C11 generics help with that, similarly to how C++ template
> functions would?

For common code, it depends on other decisions.  For example, in the
case where "p" being vdp implies that "p->f" is vdp even when "f" is
declared non-vdp, there would be an intolerable number of casts.

I am not sure to what extent generics or templates would help.  The use
of gcc type-generic macros would be much easier with some primitive that
could strip vdp from a given type.

> Nonetheless, in the end this is just trading off convenient use against
> different ways to catch different but simple errors.

Yep.  Perhaps best just to make two separate command-line flags, one to
enable vdp-to-non-vdp warnings and the other to enable non-vdp-to-vdp
warnings.  That would allow each project to adapt the compiler to their
coding standards and expectations.

> > >          ?: could be somewhat special, in that the type depends on the
> > > 2nd and 3rd operand.  Thus, "vdp x = non-vdp ? vdp : vdp;" should be
> > > allowed, whereas "vdp x = non-vdp ? non-vdp : vdp;" probably should be
> > > disallowed if we don't provide for implicit casts from non-vdp to vdp.
> > 
> > Actually, from the Linux-kernel code that I am seeing, we want to be able
> > to silently convert from non-vdp to vdp in order to permit common code
> > that is invoked from both RCU readers (vdp) and updaters (often non-vdp).
> > This common code must be compiled conservatively to allow vdp, but should
> > be just find with non-vdp.
> > 
> > Going through the combinations...
> > 
> >  0.	vdp x = vdp ? vdp : vdp;		 /* OK, matches. */
> >  1.	vdp x = vdp ? vdp : non-vdp;		 /* Silent conversion. */
> >  2.	vdp x = vdp ? non-vdp : vdp;		 /* Silent conversion. */
> >  3.	vdp x = vdp ? non-vdp : non-vdp;	 /* Silent conversion. */
> >  4.	vdp x = non-vdp ? vdp : vdp;		 /* OK, matches. */
> >  5.	vdp x = non-vdp ? vdp : non-vdp;	 /* Silent conversion. */
> >  6.	vdp x = non-vdp ? non-vdp : vdp;	 /* Silent conversion. */
> >  7.	vdp x = non-vdp ? non-vdp : non-vdp;	 /* Silent conversion. */
> >  8.	non-vdp x = vdp ? vdp : vdp;		 /* Warning unless condition. */
> >  9.	non-vdp x = vdp ? vdp : non-vdp;	 /* Warning unless condition. */
> > 10.	non-vdp x = vdp ? non-vdp : vdp;	 /* Warning unless condition. */
> > 11.	non-vdp x = vdp ? non-vdp : non-vdp;	 /* OK, matches. */
> > 12.	non-vdp x = non-vdp ? vdp : vdp;	 /* Warning unless condition. */
> > 13.	non-vdp x = non-vdp ? vdp : non-vdp;	 /* Warning unless condition. */
> > 14.	non-vdp x = non-vdp ? non-vdp : vdp;	 /* Warning unless condition. */
> > 15.	non-vdp x = non-vdp ? non-vdp : non-vdp; /* OK, matches. */
> > 
> > 0, 4, 11, and 15 are OK because both legs of the ?: match the variable
> > being assigned to.  1, 2, 3, 4, 6, and 7 are implicit silent conversions
> > from non-vdp to vdp, which is always safe and is useful for common code.
> 
> Note that some of those can in fact be vdp depending on operands, but
> don't necessarily carry an actual value dependency.  So, from a type
> system perspective, I would guess that those expressions would be vdp by
> default (except 7 and 3).
> 
> > 8, 9, 10, 12, 13, and 14 are mismatches: A vdp quantity is being assigned
> > to a non-vdp variable, which could potentially be passed to a vdp-oblivious
> > function.
> 
> I agree that there is a mismatch, but I'm not sure we want to warn on
> silent conversion from vdp to non-vdp instead of just doing a silent
> conversion.  Otherwise, we'll have to add casts whenever we send a vdp
> to something that doesn't want to make use of the value dependency
> (e.g., printf, an if statement, ...).  What would be the programmer
> overhead for the latter?

You have convinced me that different projects will want to have different
types of warnings, so that there should be a pair of compiler command-line
flags, one to enable vdp-to-non-vdb warnings and another to enable
non-vdp-to-vdp warnings.

> > However, 8, 9, 10, 12, 13, and 14 are OK if the result is
> > consumed by a conditional.  That said, I would not complain if something
> > like the following kicked out a warning:
> > 
> > 	struct foo value_dep_preserving *p;
> > 	struct foo *q;
> > 
> > 	p = rcu_dereference(gp);
> > 	q = f() ? p : p + 1;
> 
> You'd like to see the warning here, right?

Yes, if enabled and inside an RCU read-side critical section.

> > 	if (q < THE_LIMIT)
> > 		do_something();
> > 	else
> > 		do_something_else(p);
> > 
> > The warning could be avoided by marking q value_dep_preserving or by
> > eliminating q entirely:
> > 
> > 	struct foo value_dep_preserving *p;
> > 
> > 	p = rcu_dereference(gp);
> > 	if ((f() ? p : p + 1) < THE_LIMIT)
> > 		do_something();
> > 	else
> > 		do_something_else(p);
> > 
> > Or, for that matter, by using a cast:
> > 
> > 	struct foo value_dep_preserving *p;
> > 	struct foo *q;
> > 
> > 	p = rcu_dereference(gp);
> > 	q = (struct foo *)(f() ? p : p + 1);
> 
> So the cast would be like kill_dependency()?

In the sense that it tells the compiler to stop worrying about the
value dependency.

> > 	if (q < THE_LIMIT)
> > 		do_something();
> > 	else
> > 		do_something_else(p);
> > 
> > Does that make sense?
> 
> I think I understand which scheme you have in mind.  I just don't have a
> strong preference for either your approach (AFAIU, roughly, to expect
> programmers to kill vdp and to warn on silent kills otherwise) and what
> I had in mind (to allow silent transitions to non-vdp but to provide a
> helper function/macro that raises an error if the access is not vdp (so
> one can "request" to get a vdp for memory accesses where this matters)).

Ah, I see where you were coming from for your non-vdp-to-vdp warning, as
that would catch the case where your function/macro might get the wrong
answer.  Hmmm...

> Did I understand your approach correctly?

I believe you did.

> Right now, I can't confidently say that one would be better than the
> other.  I think we need to get feedback for both.

Makes sense.

> > > > This assumes that p->a only returns
> > > > vdp if field "a" is declared vdp, otherwise we have vdps running wild
> > > > through the program.  ;-)
> > > 
> > > That's a good question.  For the scheme I had in mind, I'm not concerned
> > > about vdps running wild because one needs to assign to explicitly
> > > vdp-typed variables (or function arguments, etc.) to let vdp extend to
> > > beyond single expressions.
> > > 
> > > Nonetheless, I think it's a good question how -> should behave if the
> > > field is not vdp; in particular, should vdp->non_vdp be automatically
> > > vdp?  One concern might be that we know something about non-vdp -- OTOH,
> > > we shouldn't be able to do so because we (assume to) don't know anything
> > > about the vdp pointer, so we can't infer something about something it
> > > points to.
> > 
> > In almost all the cases I am seeing in the Linux kernel, p->f wants to
> > be non-vdp.  A common case is that "f" is an integer that is used in
> > later computation, but where the ordering is needed only when fetching
> > p->f, not during later use of the resulting integer.
> 
> Module perhaps a few minor missed optimizations in this expression, if
> we had implicit/silent conversion to non-vdp, this should just work fine
> I believe even if we say that vdp->non_vdp is vdp by default.
> 
> > So it is looking like p->f should be vdp only if field "f" is declared vdp.
> 
> I can see that if the silent conversion to non-vdp is not allowed, then
> this approach might lead to fewer casts / kill_dependency().

Agreed in both cases.

> > > > The other thing that can happen is that a vdp can get handed off to
> > > > another synchronization mechanism, for example, to reference counting:
> > > > 
> > > > 	p = atomic_load_explicit(&gp, memory_order_consume);
> > > > 	if (do_something_with(p->a)) {
> > > > 		/* fast path protected by RCU. */
> > > > 		return 0;
> > > > 	}
> > > > 	if (atomic_inc_not_zero(&p->refcnt) {
> > > 
> > > Is the argument to atomic_inc_no_zero vdp or non-vdp?
> > 
> > The argument to atomic_inc_not_zero() is non-vdp, and because it is an
> > atomic operation, it would not make sense to mark it vdp.
> 
> Why?  If it would be an atomic mo_relaxed load, for example, then vdp
> would possibly make sense, or not?  For atomic RMW ops, I also don't see
> why we'd always want non-vdp as operands.

I should have said that it is a value-returning read-modify-write atomic
operation, which translates to something stronger than memory_order_seq_cst
in C11.  The reason that it is stronger is that provides more ordering
guarantees to surrounding relaxed (ACCESS_ONCE()) operations.

For example, given x and y both initially zero:

T1:	ACCESS_ONCE(x) = 1;
	if (atomic_inc_not_zero(&p->refcnt))
		ACCESS_ONCE(y) = 1;

T2:	if (ACCESS_ONCE(y)) {
		if (atomic_inc_not_zero(q->other_refcnt))
			BUG_ON(!ACCESS_ONCE(x));
	}

In the Linux kernel, the BUG_ON() cannot trigger.  In C11, it could.

So, to answer your question, if atomic_inc_not_zero() mapped to a
memory_order_relaxed operation, then yes, you might need vdp.  But given
that it maps to stronger-than-memory_order_seq_cst, you do not.

> > This results
> > in a bit of a dilemma: I am finding code that wants "&p->f" to be vdp
> > if "p" is vdp, and I am finding other code (like the above) that wants
> > "&p->f" to be non-vdp always.
> > 
> > The approaches I can think of at the moment include:
> > 
> > 1.	If "p" is vdp, make "&p->f" be vdp, but don't complain about
> > 	subsequent assignments to non-vdp variables.  Sounds like quite
> > 	a mess in the compiler.
> 
> Why?  On the assignment, there will need to be an implicit conversion.
> But assigning floats to integers or integer to boolean seems quite
> similar, or not?

In your scheme, you would never complain about vdp-to-non-vdp assignments,
so no problem.  If it is also not a problem in my approach, so mucn the
better!  ;-)

> > 2.	Propagate value_dep_preserving tags throughout the kernel.
> > 	Sounds like a good recipe for a Linux-kernel revolt against
> > 	this proposal.
> > 
> > 3.	Require explicit casts to avoid warnings:
> > 
> > 	if atomic_inc_not_zero((struct foo *)&p->refcnt) {
> > 
> > 	This would not be as bad as #2, but would still require
> > 	a fair amount of markup.
> 
> 3a.
> We could also allow implicit conversion from non-vdp to vdp (but a
> default to go from vdp to vdp, conservatively, so that dependency chains
> in expressions aren't broken accidentally).

Right, this is your proposal.

> > 4.	Use something like kill_dependency().  This has strengths
> > 	and weaknesses similar to #3, but has the advantage of
> > 	being useful in type-generic macros.
> > 
> > 5.	Either #3 or #4 above, but have a command-line flag that
> > 	shuts off the warnings.  That way, people who want the
> > 	diagnostics can enable them in their own code, and people
> > 	who don't can disable them.
> 
> If we have implicit conversions, than having warnings for when (some of)
> those happen sounds like a good idea.

Very good.

> > #5 looks like the way to go to me.  So "&p->f" has the same vdp-ness
> > as "p", so that assigning it to a non-vdp variable, passing it via a
> > non-vdp argument, or returning it via a non-vdp return value will
> > cause a warning.  However, that warning can be easily shut off on a
> > file-by-file basis.
> > 
> > Seem reasonable?
> 
> Yes, except that I think that we need to describe this differently (ie,
> more like what the standard handles other implicit conversions).
> Whether the warning should be on by default (ie, opt-out) or should be
> part of -Wall can be separately discussed, I believe.

Right, the standardese would be quite different.

							Thanx, Paul

