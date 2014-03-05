Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaCESBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:01:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34353 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCESBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:01:42 -0500
Date: Wed, 5 Mar 2014 10:01:36 -0800
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
Message-ID: <20140305180136.GL3334@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
 <20140227190611.GU8264@linux.vnet.ibm.com>
 <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
 <20140227205312.GX8264@linux.vnet.ibm.com>
 <20140301005047.GA14777@linux.vnet.ibm.com>
 <1393872908.28840.11660.camel@triegel.csb>
 <20140303192026.GO11910@linux.vnet.ibm.com>
 <1393879579.28840.11949.camel@triegel.csb>
 <20140304190032.GY11910@linux.vnet.ibm.com>
 <1394036796.28840.14900.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394036796.28840.14900.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030518-0928-0000-0000-000000290C8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 05:26:36PM +0100, Torvald Riegel wrote:
> xagsmtp3.20140305162928.8243@uk1vsc.vnet.ibm.com
> X-Xagent-Gateway: uk1vsc.vnet.ibm.com (XAGSMTP3 at UK1VSC)
> 
> On Tue, 2014-03-04 at 11:00 -0800, Paul E. McKenney wrote:
> > On Mon, Mar 03, 2014 at 09:46:19PM +0100, Torvald Riegel wrote:
> > > xagsmtp2.20140303204700.3556@vmsdvma.vnet.ibm.com
> > > X-Xagent-Gateway: vmsdvma.vnet.ibm.com (XAGSMTP2 at VMSDVMA)
> > > 
> > > On Mon, 2014-03-03 at 11:20 -0800, Paul E. McKenney wrote:
> > > > On Mon, Mar 03, 2014 at 07:55:08PM +0100, Torvald Riegel wrote:
> > > > > xagsmtp2.20140303190831.9500@uk1vsc.vnet.ibm.com
> > > > > X-Xagent-Gateway: uk1vsc.vnet.ibm.com (XAGSMTP2 at UK1VSC)
> > > > > 
> > > > > On Fri, 2014-02-28 at 16:50 -0800, Paul E. McKenney wrote:
> > > > > > +o	Do not use the results from the boolean "&&" and "||" when
> > > > > > +	dereferencing.	For example, the following (rather improbable)
> > > > > > +	code is buggy:
> > > > > > +
> > > > > > +		int a[2];
> > > > > > +		int index;
> > > > > > +		int force_zero_index = 1;
> > > > > > +
> > > > > > +		...
> > > > > > +
> > > > > > +		r1 = rcu_dereference(i1)
> > > > > > +		r2 = a[r1 && force_zero_index];  /* BUGGY!!! */
> > > > > > +
> > > > > > +	The reason this is buggy is that "&&" and "||" are often compiled
> > > > > > +	using branches.  While weak-memory machines such as ARM or PowerPC
> > > > > > +	do order stores after such branches, they can speculate loads,
> > > > > > +	which can result in misordering bugs.
> > > > > > +
> > > > > > +o	Do not use the results from relational operators ("==", "!=",
> > > > > > +	">", ">=", "<", or "<=") when dereferencing.  For example,
> > > > > > +	the following (quite strange) code is buggy:
> > > > > > +
> > > > > > +		int a[2];
> > > > > > +		int index;
> > > > > > +		int flip_index = 0;
> > > > > > +
> > > > > > +		...
> > > > > > +
> > > > > > +		r1 = rcu_dereference(i1)
> > > > > > +		r2 = a[r1 != flip_index];  /* BUGGY!!! */
> > > > > > +
> > > > > > +	As before, the reason this is buggy is that relational operators
> > > > > > +	are often compiled using branches.  And as before, although
> > > > > > +	weak-memory machines such as ARM or PowerPC do order stores
> > > > > > +	after such branches, but can speculate loads, which can again
> > > > > > +	result in misordering bugs.
> > > > > 
> > > > > Those two would be allowed by the wording I have recently proposed,
> > > > > AFAICS.  r1 != flip_index would result in two possible values (unless
> > > > > there are further constraints due to the type of r1 and the values that
> > > > > flip_index can have).
> > > > 
> > > > And I am OK with the value_dep_preserving type providing more/better
> > > > guarantees than we get by default from current compilers.
> > > > 
> > > > One question, though.  Suppose that the code did not want a value
> > > > dependency to be tracked through a comparison operator.  What does
> > > > the developer do in that case?  (The reason I ask is that I have
> > > > not yet found a use case in the Linux kernel that expects a value
> > > > dependency to be tracked through a comparison.)
> > > 
> > > Hmm.  I suppose use an explicit cast to non-vdp before or after the
> > > comparison?
> > 
> > That should work well assuming that things like "if", "while", and "?:"
> > conditions are happy to take a vdp.
> 
> I currently don't see a reason why that should be disallowed.  If we
> have allowed an implicit conversion to non-vdp, I believe that should
> follow.

I am a bit nervous about a silent implicit conversion from vdp to
non-vdp in the general case.  However, when the result is being used by
a conditional, the silent implicit conversion makes a lot of sense.
Is that distinction something that the compiler can handle easily?

On the other hand, silent implicit conversion from non-vdp to vdp
is very useful for common code that can be invoked both by RCU
readers and by updaters.

>          ?: could be somewhat special, in that the type depends on the
> 2nd and 3rd operand.  Thus, "vdp x = non-vdp ? vdp : vdp;" should be
> allowed, whereas "vdp x = non-vdp ? non-vdp : vdp;" probably should be
> disallowed if we don't provide for implicit casts from non-vdp to vdp.

Actually, from the Linux-kernel code that I am seeing, we want to be able
to silently convert from non-vdp to vdp in order to permit common code
that is invoked from both RCU readers (vdp) and updaters (often non-vdp).
This common code must be compiled conservatively to allow vdp, but should
be just find with non-vdp.

Going through the combinations...

 0.	vdp x = vdp ? vdp : vdp;		 /* OK, matches. */
 1.	vdp x = vdp ? vdp : non-vdp;		 /* Silent conversion. */
 2.	vdp x = vdp ? non-vdp : vdp;		 /* Silent conversion. */
 3.	vdp x = vdp ? non-vdp : non-vdp;	 /* Silent conversion. */
 4.	vdp x = non-vdp ? vdp : vdp;		 /* OK, matches. */
 5.	vdp x = non-vdp ? vdp : non-vdp;	 /* Silent conversion. */
 6.	vdp x = non-vdp ? non-vdp : vdp;	 /* Silent conversion. */
 7.	vdp x = non-vdp ? non-vdp : non-vdp;	 /* Silent conversion. */
 8.	non-vdp x = vdp ? vdp : vdp;		 /* Warning unless condition. */
 9.	non-vdp x = vdp ? vdp : non-vdp;	 /* Warning unless condition. */
10.	non-vdp x = vdp ? non-vdp : vdp;	 /* Warning unless condition. */
11.	non-vdp x = vdp ? non-vdp : non-vdp;	 /* OK, matches. */
12.	non-vdp x = non-vdp ? vdp : vdp;	 /* Warning unless condition. */
13.	non-vdp x = non-vdp ? vdp : non-vdp;	 /* Warning unless condition. */
14.	non-vdp x = non-vdp ? non-vdp : vdp;	 /* Warning unless condition. */
15.	non-vdp x = non-vdp ? non-vdp : non-vdp; /* OK, matches. */

0, 4, 11, and 15 are OK because both legs of the ?: match the variable
being assigned to.  1, 2, 3, 4, 6, and 7 are implicit silent conversions
from non-vdp to vdp, which is always safe and is useful for common code.
8, 9, 10, 12, 13, and 14 are mismatches: A vdp quantity is being assigned
to a non-vdp variable, which could potentially be passed to a vdp-oblivious
function.  However, 8, 9, 10, 12, 13, and 14 are OK if the result is
consumed by a conditional.  That said, I would not complain if something
like the following kicked out a warning:

	struct foo value_dep_preserving *p;
	struct foo *q;

	p = rcu_dereference(gp);
	q = f() ? p : p + 1;
	if (q < THE_LIMIT)
		do_something();
	else
		do_something_else(p);

The warning could be avoided by marking q value_dep_preserving or by
eliminating q entirely:

	struct foo value_dep_preserving *p;

	p = rcu_dereference(gp);
	if ((f() ? p : p + 1) < THE_LIMIT)
		do_something();
	else
		do_something_else(p);

Or, for that matter, by using a cast:

	struct foo value_dep_preserving *p;
	struct foo *q;

	p = rcu_dereference(gp);
	q = (struct foo *)(f() ? p : p + 1);
	if (q < THE_LIMIT)
		do_something();
	else
		do_something_else(p);

Does that make sense?

> > This assumes that p->a only returns
> > vdp if field "a" is declared vdp, otherwise we have vdps running wild
> > through the program.  ;-)
> 
> That's a good question.  For the scheme I had in mind, I'm not concerned
> about vdps running wild because one needs to assign to explicitly
> vdp-typed variables (or function arguments, etc.) to let vdp extend to
> beyond single expressions.
> 
> Nonetheless, I think it's a good question how -> should behave if the
> field is not vdp; in particular, should vdp->non_vdp be automatically
> vdp?  One concern might be that we know something about non-vdp -- OTOH,
> we shouldn't be able to do so because we (assume to) don't know anything
> about the vdp pointer, so we can't infer something about something it
> points to.

In almost all the cases I am seeing in the Linux kernel, p->f wants to
be non-vdp.  A common case is that "f" is an integer that is used in
later computation, but where the ordering is needed only when fetching
p->f, not during later use of the resulting integer.

So it is looking like p->f should be vdp only if field "f" is declared vdp.

> > The other thing that can happen is that a vdp can get handed off to
> > another synchronization mechanism, for example, to reference counting:
> > 
> > 	p = atomic_load_explicit(&gp, memory_order_consume);
> > 	if (do_something_with(p->a)) {
> > 		/* fast path protected by RCU. */
> > 		return 0;
> > 	}
> > 	if (atomic_inc_not_zero(&p->refcnt) {
> 
> Is the argument to atomic_inc_no_zero vdp or non-vdp?

The argument to atomic_inc_not_zero() is non-vdp, and because it is an
atomic operation, it would not make sense to mark it vdp.  This results
in a bit of a dilemma: I am finding code that wants "&p->f" to be vdp
if "p" is vdp, and I am finding other code (like the above) that wants
"&p->f" to be non-vdp always.

The approaches I can think of at the moment include:

1.	If "p" is vdp, make "&p->f" be vdp, but don't complain about
	subsequent assignments to non-vdp variables.  Sounds like quite
	a mess in the compiler.

2.	Propagate value_dep_preserving tags throughout the kernel.
	Sounds like a good recipe for a Linux-kernel revolt against
	this proposal.

3.	Require explicit casts to avoid warnings:

	if atomic_inc_not_zero((struct foo *)&p->refcnt) {

	This would not be as bad as #2, but would still require
	a fair amount of markup.

4.	Use something like kill_dependency().  This has strengths
	and weaknesses similar to #3, but has the advantage of
	being useful in type-generic macros.

5.	Either #3 or #4 above, but have a command-line flag that
	shuts off the warnings.  That way, people who want the
	diagnostics can enable them in their own code, and people
	who don't can disable them.

#5 looks like the way to go to me.  So "&p->f" has the same vdp-ness
as "p", so that assigning it to a non-vdp variable, passing it via a
non-vdp argument, or returning it via a non-vdp return value will
cause a warning.  However, that warning can be easily shut off on a
file-by-file basis.

Seem reasonable?

> > 		/* slow path protected by reference counting. */
> > 		return do_something_else_with((struct foo *)p);  /* CHANGE */
> > 	}
> > 	/* Needed slow path, but raced with deletion. */
> > 	return -EAGAIN;
> > 
> > I am guessing that the cast ends the vdp.  Is that the case?
> 
> That would end it, yes.  The other way this could happen is that the
> argument of do_something_else_with() would be specified to be non-vdp.

Agreed.

							Thanx, Paul

