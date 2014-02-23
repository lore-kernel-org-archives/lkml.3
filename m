Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBWTb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 14:31:29 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:53910 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaBWTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 14:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <20140223063426.GT4250@linux.vnet.ibm.com>
References: <20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
Date: Sun, 23 Feb 2014 11:31:25 -0800
X-Google-Sender-Auth: lFHbORT80dnTJzNxrF-i46LPGXQ
Message-ID: <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 10:34 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Adding and subtracting integers to/from a RCU-protected pointer makes
> sense to me.

Ack. And that's normal "access to an object" behavior anyway.

> Adding and subtracting integers to/from an RCU-protected integer makes
> sense in many practical cases, but I worry about the compiler figuring
> out that the RCU-protected integer cancelled with some other integer.

I suspect that in practice, all the same normal rules apply - assuming
that there aren't any "aliasing" integers, and that the compiler
doesn't do any value prediction, the end result *should* be exactly
the same as for the pointer arithmetic. So even if the standard were
to talk about just pointers, I suspect that in practice, there really
isn't anything that can go wrong.

> I don't feel all that good about subtractions involving an RCU-protected
> pointer and another pointer, again due to the possibility of arithmetic
> optimizations cancelling everything.

Actually, pointer subtraction is a pretty useful operation, even
without the "gotcha" case of "p-p" just to force a fake dependency.
Getting an index, or indeed just getting an offset within a structure,
is valid and common, and people will and should do it. It doesn't
really matter for my suggested language: it should be perfectly fine
to do something like

   ptr = atomic_read(pp, mo_consume);
   index = ptr - array_base;
   .. pass off 'index' to some function, which then re-generates the
ptr using it ..

and the compiler will have no trouble generating code, and the
suggested "ordered wrt that object" guarantee is that the eventual
ordering is between the pointer load and the use in the function,
regardless of how it got there (ie turning it into an index and back
is perfectly fine).

So both from a legalistic language wording standpoint, and from a
compiler code generation standpoint, this is a non-issue.

Now, if you actually lose information (ie some chain there drops
enough data from the pointer that it cannot be recovered, partially of
fully), and then "regenerate" the object value by faking it, and still
end up accessing the right data, but without actually going through
any of the the pointer that you loaded, that falls under the
"restricted" heading, and you must clearly at least partially have
used other information. In which case the standard wording wouldn't
guarantee anything at all.

>> I don't see that you would need to protect anything but the first
>> read, so I think you need rcu_dereference() only on the initial
>> pointer access.
>
> Let me try an example:
>
>         struct bar {
>                 int a;
>                 unsigned b;
>         };
>
>         struct foo {
>                 struct bar *next;
>                 char c;
>         };
>
>         struct bar bar1;
>         struct foo foo1;
>
>         struct foo *foop;
>
> T1:     bar1.a = -1;
>         bar1.b = 2;
>         foo1.next = &bar;
>         foo1.c = "*";
>         atomic_store_explicit(&foop, &foo1, memory_order_release);

So here, the standard requires that the store with release is an
ordering to all preceding writes. So *all* writes to bar and foo are
ordered, despite the fact that the pointer just points to foo.

> T2:     struct foo restrict *p;
>         struct bar *q;
>
>         p = atomic_load_explicit(&foop, memory_order_consume);
>         if (p == NULL)
>                 return -EDEALWITHIT;
>         q = p->next;  /* Ordered with above load. */
>         do_something(q->b); /* Non-decorated pointer, ordered? */

So the theory is that a compiler *could* do some value speculation now
on "q", and with value speculation move the actual load of "q->p" up
to before "foop" was even loaded.

So in practice, I think we agree that this doesn't really affect
compiler writers (because they'd have to do a whole lot extra code to
break it intentionally, considering that they can't do
value-prediction on 'p'), and we just need to make sure to close the
hole in the language to make this safe, right?

Let me think about it some more, but my gut feel is that just tweaking
the definition of what "ordered" means is sufficient.

So to go back to the suggested ordering rules (ignoring the "restrict"
part, which is just to clarify that ordering through other means to
get to the object doesn't matter), I suggested:

 "the consume ordering guarantees the ordering between that
  atomic read and the accesses to the object that the pointer
  points to"

and I think the solution is to just say that this ordering acts as a
fence. It doesn't say exactly *where* the fence is, but it says that
there is *some* fence between the load of the pointer and any/all
accesses to the object through that pointer.

So with that definition, the memory accesses that are dependent on 'q'
will obviously be ordered. Now, they will *not* be ordered wrt the
load of q itself, but they will be ordered wrt the load from 'foop' -
because we've made it clear that there is a fence *somewhere* between
that atomic_load and the load of 'q'.

So that handles the ordering guarantee you worry about.

Now, the other worry is that this "fence" language would impose a
*stricter* ordering, and that by saying there is a fence, we'd now
constrain code generation on architectures like ARM and power, agreed?
And we do not want to do that, other than make it clear that the whole
"break the dependency chain through value speculation" cannot break it
past the load from 'foop'. Are we in agreement?

So we do *not* want that fence to limit re-ordering of independent
memory operations. All agreed?

But let's look at any independent chain, especially around that
consuming load from '&foop'. Say we have some other memory access
(adding them for visualization into your example):

        p = atomic_load_explicit(&foop, memory_order_consume);
        if (p == NULL)
                return -EDEALWITHIT;
        q = p->next;  /* Ordered with above load. */
+       a = *b; *c = d;
        do_something(q->b); /* Non-decorated pointer, ordered? */

and we are looking to make sure that those memory accesses can still
move around freely.

I'm claiming that they can, even with the "fence" language, because

 (a) we've said 'q' is restricted, so there is no aliasing between q
and the pointers b/c. So the compiler is free to move those accesses
around the "q = p->next" access.

 (b) once you've moved them to *before* the "q = p->next" access, the
fence no longer constrains you, because the guarantee is that there is
a fence *somewhere* between the consuming load and the accesses to
that object, but it could be *at* the access, so you're done.

So I think the "we guarantee there is an ordering *somewhere* between
the consuming load and the first ordered access" model actually gives
us the semantics we need.

(Note that you cannot necessarily move the accesses through the
pointers b/c past the consuming load, since the only non-aliasing
guarantee is about the pointer 'p', not about 'foop'. But you may use
other arguments to move them past that too)

But it's possible that the above argument doesn't really work. It is a
very off-the-cuff "my intuition says this should work" model.

            Linus
