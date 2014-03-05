Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaCEQ1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:27:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791AbaCEQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:27:17 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
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
In-Reply-To: <20140304190032.GY11910@linux.vnet.ibm.com>
References: <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
	 <1393515453.28840.9961.camel@triegel.csb>
	 <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
	 <20140227190611.GU8264@linux.vnet.ibm.com>
	 <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
	 <20140227205312.GX8264@linux.vnet.ibm.com>
	 <20140301005047.GA14777@linux.vnet.ibm.com>
	 <1393872908.28840.11660.camel@triegel.csb>
	 <20140303192026.GO11910@linux.vnet.ibm.com>
	 <1393879579.28840.11949.camel@triegel.csb>
	 <20140304190032.GY11910@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Mar 2014 17:26:36 +0100
Message-ID: <1394036796.28840.14900.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 11:00 -0800, Paul E. McKenney wrote:
> On Mon, Mar 03, 2014 at 09:46:19PM +0100, Torvald Riegel wrote:
> > xagsmtp2.20140303204700.3556@vmsdvma.vnet.ibm.com
> > X-Xagent-Gateway: vmsdvma.vnet.ibm.com (XAGSMTP2 at VMSDVMA)
> > 
> > On Mon, 2014-03-03 at 11:20 -0800, Paul E. McKenney wrote:
> > > On Mon, Mar 03, 2014 at 07:55:08PM +0100, Torvald Riegel wrote:
> > > > xagsmtp2.20140303190831.9500@uk1vsc.vnet.ibm.com
> > > > X-Xagent-Gateway: uk1vsc.vnet.ibm.com (XAGSMTP2 at UK1VSC)
> > > > 
> > > > On Fri, 2014-02-28 at 16:50 -0800, Paul E. McKenney wrote:
> > > > > +o	Do not use the results from the boolean "&&" and "||" when
> > > > > +	dereferencing.	For example, the following (rather improbable)
> > > > > +	code is buggy:
> > > > > +
> > > > > +		int a[2];
> > > > > +		int index;
> > > > > +		int force_zero_index = 1;
> > > > > +
> > > > > +		...
> > > > > +
> > > > > +		r1 = rcu_dereference(i1)
> > > > > +		r2 = a[r1 && force_zero_index];  /* BUGGY!!! */
> > > > > +
> > > > > +	The reason this is buggy is that "&&" and "||" are often compiled
> > > > > +	using branches.  While weak-memory machines such as ARM or PowerPC
> > > > > +	do order stores after such branches, they can speculate loads,
> > > > > +	which can result in misordering bugs.
> > > > > +
> > > > > +o	Do not use the results from relational operators ("==", "!=",
> > > > > +	">", ">=", "<", or "<=") when dereferencing.  For example,
> > > > > +	the following (quite strange) code is buggy:
> > > > > +
> > > > > +		int a[2];
> > > > > +		int index;
> > > > > +		int flip_index = 0;
> > > > > +
> > > > > +		...
> > > > > +
> > > > > +		r1 = rcu_dereference(i1)
> > > > > +		r2 = a[r1 != flip_index];  /* BUGGY!!! */
> > > > > +
> > > > > +	As before, the reason this is buggy is that relational operators
> > > > > +	are often compiled using branches.  And as before, although
> > > > > +	weak-memory machines such as ARM or PowerPC do order stores
> > > > > +	after such branches, but can speculate loads, which can again
> > > > > +	result in misordering bugs.
> > > > 
> > > > Those two would be allowed by the wording I have recently proposed,
> > > > AFAICS.  r1 != flip_index would result in two possible values (unless
> > > > there are further constraints due to the type of r1 and the values that
> > > > flip_index can have).
> > > 
> > > And I am OK with the value_dep_preserving type providing more/better
> > > guarantees than we get by default from current compilers.
> > > 
> > > One question, though.  Suppose that the code did not want a value
> > > dependency to be tracked through a comparison operator.  What does
> > > the developer do in that case?  (The reason I ask is that I have
> > > not yet found a use case in the Linux kernel that expects a value
> > > dependency to be tracked through a comparison.)
> > 
> > Hmm.  I suppose use an explicit cast to non-vdp before or after the
> > comparison?
> 
> That should work well assuming that things like "if", "while", and "?:"
> conditions are happy to take a vdp.

I currently don't see a reason why that should be disallowed.  If we
have allowed an implicit conversion to non-vdp, I believe that should
follow.  ?: could be somewhat special, in that the type depends on the
2nd and 3rd operand.  Thus, "vdp x = non-vdp ? vdp : vdp;" should be
allowed, whereas "vdp x = non-vdp ? non-vdp : vdp;" probably should be
disallowed if we don't provide for implicit casts from non-vdp to vdp.

> This assumes that p->a only returns
> vdp if field "a" is declared vdp, otherwise we have vdps running wild
> through the program.  ;-)

That's a good question.  For the scheme I had in mind, I'm not concerned
about vdps running wild because one needs to assign to explicitly
vdp-typed variables (or function arguments, etc.) to let vdp extend to
beyond single expressions.

Nonetheless, I think it's a good question how -> should behave if the
field is not vdp; in particular, should vdp->non_vdp be automatically
vdp?  One concern might be that we know something about non-vdp -- OTOH,
we shouldn't be able to do so because we (assume to) don't know anything
about the vdp pointer, so we can't infer something about something it
points to.

> The other thing that can happen is that a vdp can get handed off to
> another synchronization mechanism, for example, to reference counting:
> 
> 	p = atomic_load_explicit(&gp, memory_order_consume);
> 	if (do_something_with(p->a)) {
> 		/* fast path protected by RCU. */
> 		return 0;
> 	}
> 	if (atomic_inc_not_zero(&p->refcnt) {

Is the argument to atomic_inc_no_zero vdp or non-vdp?

> 		/* slow path protected by reference counting. */
> 		return do_something_else_with((struct foo *)p);  /* CHANGE */
> 	}
> 	/* Needed slow path, but raced with deletion. */
> 	return -EAGAIN;
> 
> I am guessing that the cast ends the vdp.  Is that the case?

That would end it, yes.  The other way this could happen is that the
argument of do_something_else_with() would be specified to be non-vdp.

