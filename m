Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaBXBRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:17:04 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52959 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaBXBRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:17:01 -0500
Date: Sun, 23 Feb 2014 17:16:51 -0800
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
Message-ID: <20140224011651.GC8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140220181116.GT4250@linux.vnet.ibm.com>
 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
 <1392922421.28840.36.camel@triegel.csb>
 <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
 <1393095223.28840.4914.camel@triegel.csb>
 <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
 <20140223003933.GQ4250@linux.vnet.ibm.com>
 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
 <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022401-0928-0000-0000-000006BEB5D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 11:31:25AM -0800, Linus Torvalds wrote:
> On Sat, Feb 22, 2014 at 10:34 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Adding and subtracting integers to/from a RCU-protected pointer makes
> > sense to me.
> 
> Ack. And that's normal "access to an object" behavior anyway.

And covers things like container_of() as well as array indexing and
field selection, so good.

> > Adding and subtracting integers to/from an RCU-protected integer makes
> > sense in many practical cases, but I worry about the compiler figuring
> > out that the RCU-protected integer cancelled with some other integer.
> 
> I suspect that in practice, all the same normal rules apply - assuming
> that there aren't any "aliasing" integers, and that the compiler
> doesn't do any value prediction, the end result *should* be exactly
> the same as for the pointer arithmetic. So even if the standard were
> to talk about just pointers, I suspect that in practice, there really
> isn't anything that can go wrong.

Yep, in practice in absence of the "i-i" code, it should work.  As long
as the integer returned from the memory_order_consume load is always
kept in an integer tagged as "restrict", I believe that it should be
possible to make the standard guarantee it as well.

> > I don't feel all that good about subtractions involving an RCU-protected
> > pointer and another pointer, again due to the possibility of arithmetic
> > optimizations cancelling everything.
> 
> Actually, pointer subtraction is a pretty useful operation, even
> without the "gotcha" case of "p-p" just to force a fake dependency.
> Getting an index, or indeed just getting an offset within a structure,
> is valid and common, and people will and should do it. It doesn't
> really matter for my suggested language: it should be perfectly fine
> to do something like
> 
>    ptr = atomic_read(pp, mo_consume);
>    index = ptr - array_base;
>    .. pass off 'index' to some function, which then re-generates the
> ptr using it ..

I believe that the devil is in the details of the regeneration of the
pointer.  Yet another example below.

> and the compiler will have no trouble generating code, and the
> suggested "ordered wrt that object" guarantee is that the eventual
> ordering is between the pointer load and the use in the function,
> regardless of how it got there (ie turning it into an index and back
> is perfectly fine).
> 
> So both from a legalistic language wording standpoint, and from a
> compiler code generation standpoint, this is a non-issue.
> 
> Now, if you actually lose information (ie some chain there drops
> enough data from the pointer that it cannot be recovered, partially of
> fully), and then "regenerate" the object value by faking it, and still
> end up accessing the right data, but without actually going through
> any of the the pointer that you loaded, that falls under the
> "restricted" heading, and you must clearly at least partially have
> used other information. In which case the standard wording wouldn't
> guarantee anything at all.

I agree in general, but believe that the pointer regeneration needs
to be done with care.  If you are adding the difference back into
the original variable ptr read from the RCU-protected pointer, I have
no problem with it.

My concern is with more elaborate cases.  For example:

	struct foo g1[N];
	struct bar g2[N];
	struct foo restrict *p1;
	struct bar *p2;
	int index;

	p1 = atomic_read_explicit(*gp1, memory_order_consume);
	index = (ptr - g1) / 2;  /* Getting this into the BS syntax realm. */
	p2 = g2 + index;

The standard as currently worded would force ordering between the read
into p1 and the read into p2.  But it does so via dependency chains,
so this is starting to feel to me like we are getting back into the
business of tracing dependency chains.

Of course, one can argue that parallel arrays are not all that useful
in the Linux kernel, and one can argue that dividing indexes by two is
beyond the pale.  (Although heaps in dense arrays really do this sort of
index arithmetic, I am having some trouble imagining why RCU protection
would be useful in that case.  Yes, I could make up something about
replacing one heap locklessly with another, but...)

I might well be in my usual overly paranoid mode, but this is the sort
of thing that makes me a bit nervous.  I would rather either have it
bulletproof safe, or to say "don't do that".

Hmmm...  I don't recall seeing a use case for subtraction involving
an RCU-protected pointer and another pointer when I looked through
all the rcu_dereference() invocations in the Linux kernel.  Is there
a use case that I am missing?

> >> I don't see that you would need to protect anything but the first
> >> read, so I think you need rcu_dereference() only on the initial
> >> pointer access.
> >
> > Let me try an example:
> >
> >         struct bar {
> >                 int a;
> >                 unsigned b;
> >         };
> >
> >         struct foo {
> >                 struct bar *next;
> >                 char c;
> >         };
> >
> >         struct bar bar1;
> >         struct foo foo1;
> >
> >         struct foo *foop;
> >
> > T1:     bar1.a = -1;
> >         bar1.b = 2;
> >         foo1.next = &bar;
> >         foo1.c = "*";
> >         atomic_store_explicit(&foop, &foo1, memory_order_release);
> 
> So here, the standard requires that the store with release is an
> ordering to all preceding writes. So *all* writes to bar and foo are
> ordered, despite the fact that the pointer just points to foo.

As long as T1 does some load from foop that extends T1's happens-before
chain, agreed.

> > T2:     struct foo restrict *p;
> >         struct bar *q;
> >
> >         p = atomic_load_explicit(&foop, memory_order_consume);
> >         if (p == NULL)
> >                 return -EDEALWITHIT;
> >         q = p->next;  /* Ordered with above load. */
> >         do_something(q->b); /* Non-decorated pointer, ordered? */
> 
> So the theory is that a compiler *could* do some value speculation now
> on "q", and with value speculation move the actual load of "q->p" up
> to before "foop" was even loaded.

That would be one concern.  The other concern is that the only reason I
believe that this is safe is because I trace the dependency chain from
"p" through "p->next" and through "q->b".  And because the more clearly
the standard states the rules the Linux kernel relies on, the easier it
is to get compiler writers to pay attention to bug reports.

It might be that adding "restrict" to the definition of "q" would address
my concerns.

> So in practice, I think we agree that this doesn't really affect
> compiler writers (because they'd have to do a whole lot extra code to
> break it intentionally, considering that they can't do
> value-prediction on 'p'), and we just need to make sure to close the
> hole in the language to make this safe, right?

Yep.  Unless the compiler is doing some "interesting" optimizations on
q, this should in practice be safe.  After all, we are relying on this
right now.  ;-)

> Let me think about it some more, but my gut feel is that just tweaking
> the definition of what "ordered" means is sufficient.
> 
> So to go back to the suggested ordering rules (ignoring the "restrict"
> part, which is just to clarify that ordering through other means to
> get to the object doesn't matter), I suggested:
> 
>  "the consume ordering guarantees the ordering between that
>   atomic read and the accesses to the object that the pointer
>   points to"
> 
> and I think the solution is to just say that this ordering acts as a
> fence. It doesn't say exactly *where* the fence is, but it says that
> there is *some* fence between the load of the pointer and any/all
> accesses to the object through that pointer.
> 
> So with that definition, the memory accesses that are dependent on 'q'
> will obviously be ordered. Now, they will *not* be ordered wrt the
> load of q itself, but they will be ordered wrt the load from 'foop' -
> because we've made it clear that there is a fence *somewhere* between
> that atomic_load and the load of 'q'.
> 
> So that handles the ordering guarantee you worry about.
> 
> Now, the other worry is that this "fence" language would impose a
> *stricter* ordering, and that by saying there is a fence, we'd now
> constrain code generation on architectures like ARM and power, agreed?
> And we do not want to do that, other than make it clear that the whole
> "break the dependency chain through value speculation" cannot break it
> past the load from 'foop'. Are we in agreement?
> 
> So we do *not* want that fence to limit re-ordering of independent
> memory operations. All agreed?

Yep!

> But let's look at any independent chain, especially around that
> consuming load from '&foop'. Say we have some other memory access
> (adding them for visualization into your example):
> 
>         p = atomic_load_explicit(&foop, memory_order_consume);
>         if (p == NULL)
>                 return -EDEALWITHIT;
>         q = p->next;  /* Ordered with above load. */
> +       a = *b; *c = d;
>         do_something(q->b); /* Non-decorated pointer, ordered? */
> 
> and we are looking to make sure that those memory accesses can still
> move around freely.
> 
> I'm claiming that they can, even with the "fence" language, because
> 
>  (a) we've said 'q' is restricted, so there is no aliasing between q
> and the pointers b/c. So the compiler is free to move those accesses
> around the "q = p->next" access.

Ah, if I understand you, very good!

My example intentionally left "q" -not- restricted.  I have to think about
it more, but I believe that I am OK requiring that "q" be restricted
in order to have the ordering guarantees.  In other words, leaving "q"
unrestricted would with extremely high probability get you the ordering
guarantees in practice, but would not be absolutely guaranteed according
to the standard.  Changing the above example to mark "q" restricted
gets you the guarantee both in practice and according to the standard.

Is that where you are going with this?

>  (b) once you've moved them to *before* the "q = p->next" access, the
> fence no longer constrains you, because the guarantee is that there is
> a fence *somewhere* between the consuming load and the accesses to
> that object, but it could be *at* the access, so you're done.

Plus the pointer "p" is restricted, so the reasoning above should
also allow moving the assignments to b/c to before the assignment to
"p", right?

> So I think the "we guarantee there is an ordering *somewhere* between
> the consuming load and the first ordered access" model actually gives
> us the semantics we need.
> 
> (Note that you cannot necessarily move the accesses through the
> pointers b/c past the consuming load, since the only non-aliasing
> guarantee is about the pointer 'p', not about 'foop'. But you may use
> other arguments to move them past that too)
> 
> But it's possible that the above argument doesn't really work. It is a
> very off-the-cuff "my intuition says this should work" model.

Yes, we definitely will need to run it past Peter Sewell and Mark Batty
once we have it fully nailed down to see if it survives formalization.  ;-)

But expanding the example one step further:

+	char ch;

        p = atomic_load_explicit(&foop, memory_order_consume);
        if (p == NULL)
                return -EDEALWITHIT;
        q = p->next;  /* Ordered with above load. */
	ch = p->c; /* Ordered with above load. */
        a = *b; *c = d;
        do_something(q->b); /* Non-decorated pointer, ordered? */
+	r1 = somearray[ch]; /* "ch" is not restricted, no guarantee. */

Again, given current compilers and hardware, the load into r1 would be
ordered, and the current unloved standard would guarantee that as well
(at great pain to compiler writers, I hasten to add).

But I would be OK with this guarantee not being ironclad as far as a new
version standard is concerned.  If you needed the standard to guarantee
this ordering, you could write

	char restrict ch;

instead of just plain "char ch".

Does that fit into the approach you are thinking of?

							Thanx, Paul

