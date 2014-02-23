Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaBWDuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 22:50:40 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:48136 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBWDug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 22:50:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140223003933.GQ4250@linux.vnet.ibm.com>
References: <20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
Date: Sat, 22 Feb 2014 19:50:35 -0800
X-Google-Sender-Auth: m1sF34AkA93J5MDbA_bGDdsrQOI
Message-ID: <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 4:39 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Agreed, by far the most frequent use is "->" to dereference and assignment
> to store into a local variable.  The other operations where the kernel
> expects ordering to be maintained are:
>
> o       Bitwise "&" to strip off low-order bits.  The FIB tree does
>         this, for example in fib_table_lookup() in net/ipv4/fib_trie.c.
>         The low-order bit is used to distinguish internal nodes from
>         leaves -- nodes and leaves are different types of structures.
>         (There are a few others.)

Note that this is very much outside the scope of the C standard,
regardless of 'consume' or not.

We'll always do things outside the standard, so I wouldn't worry.

> o       Uses "?:" to substitute defaults in case of NULL pointers,
>         but ordering must be maintained in the non-default case.
>         Most, perhaps all, of these could be converted to "if" should
>         "?:" prove problematic.

Note that this doesn't actually affect the restrict/ordering rule in
theory: "?:" isn't special according to those rules. The rules are
fairly simple: we guarantee ordering only to the object that the
pointer points to, and even that guarantee goes out the window if
there is some *other* way to reach the object.

?: is not really relevant, except in the sense that *any* expression
that ends up pointing to outside the object will lose the ordering
guarantee. ?: can be one such expression, but so can "p-p" or anything
like that.

And in *practice*, the only thing that needs to be sure to generate
special code is alpha, and there you'd just add the "rmb" after the
load. That is sufficient to fulfill the guarantees.

On ARM and powerpc, the compiler obviously has to guarantee that it
doesn't do value-speculation on the result, but again, that never
really had anything to do with the whole "carries a dependency", it is
really all about the fact that in order to guarantee the ordering, the
compiler mustn't generate that magical aliased pointer value. But if
the aliased pointer value comes from the *source* code, all bets are
off.

Now, even on alpha, the compiler can obviously move that "rmb" around.
For example, if there is a conditional after the
"atomic_read(mo_consume)", and the compiler can tell that the pointer
that got read by mo_consume is dead along one branch, then the
compiler can move the "rmb" to only exist in the other branch. Why?
Because we inherently guarantee only the order to any accesses to the
object the pointer pointed to, and that the pointer that got loaded is
the *only* way to get to that object (in this context), so if the
value is dead, then so is the ordering.

In fact, even if the value is *not* dead, but it is NULL, the compiler
can validly say "the NULL pointer cannot point to any object, so I
don't have to guarantee any serialization". So code like this (writing
alpha assembly, since in practice only alpha will ever care):

    ptr = atomic_read(pp, mo_consume);
    if (ptr) {
       ... do something with ptr ..
    }
    return ptr;

can validly be translated to:

    ldq $1,0($2)
    beq $1,branch-over
    rmb
    .. the do-something code using register $1 ..

because the compiler knows that a NULL pointer cannot be dereferenced,
so it can decide to put the rmb in the non-NULL path - even though the
pointer value is still *live* in the other branch (well, the liveness
of a constant value is somewhat debatable, but you get the idea), and
may be used by the caller (but since it is NULL, the "use" can not
include accessing any object, only really testing)

So note how this is actually very different from the "carries
dependency" rule. It's simpler, and it allows much more natural
optimizations.

> o       Addition and subtraction to adjust both pointers to and indexes
>         into RCU-protected arrays.  There are not that many indexes,
>         and they could be converted to pointers, but the addition and
>         subtraction looks necessary in a some cases.

Addition and subtraction is fine, as long as they stay within the same
object/array.

And realistically, people violate the whole C pointer "same object"
rule all the time. Any time you implement a raw memory allocator,
you'll violate the C standard and you *will* basically be depending on
architecture-specific behavior. So everybody knows that the C "pointer
arithmetic has to stay within the object" is really a fairly made-up
but convenient shorthand for "sure, we know you'll do tricks on
pointer values, but they won't be portable and you may have to take
particular machine representations into account".

> o       Array indexing.  The value from rcu_dereference() is used both
>         before and inside the "[]", interestingly enough.

Well, in the C sense, or in the actual "integer index" sense? Because
technically, a[b] is nothing but *(a+b), so "inside" the "[]" is
strictly speaking meaningless. Inside and outside are just syntactic
sugar.

That said, I agree that the way I phrased things really limits things
to *just* pointers, and if you want to do RCU on integer values (that
get turned into pointers some other way), that would be outside the
spec.

But in practice, the code generation will *work* for non-pointers too
(the exception might be if the compiler actually does the above "NULL
is special, so I know I don't need to order wrt it". Exactly the way
that people do arithmetic operations on pointers that aren't really
covered by the standard (ie arithmetic 'and' to align them etc), the
code still *works*. It may be outside the standard, but everybody does
it, and one of the reasons C is so powerful is exactly that you *can*
do things like that. They won't be portable, and you have to know what
you are doing, but they don't stop working just because they aren't
covered by the standard.

>>  - the "restricted pointer" part means that the compiler does not need
>> to worry about serialization to that object through other possible
>> pointers - we have basically promised that the *only* pointer to that
>> object comes from the mo_consume. So that part makes it clear that the
>> "consume" ordering really only is valid wrt that particular pointer
>> load.
>
> That could work, though there are some cases where a multi-linked
> structure is made visible using a single rcu_assign_pointer(), and
> rcu_dereference() is used only for the pointer leading to that
> multi-linked structure, not for the pointers among the elements
> making up that structure.  One way to handle this would be to
> require rcu_dereference() to be used within the structure an well
> as upon first traversal to the structure.

I don't see that you would need to protect anything but the first
read, so I think you need rcu_dereference() only on the initial
pointer access.

On architectures where following a pointer is sufficient ordering,
we're fine. On alpha (and, if anybody ever makes that horrid mistake
again), the 'rmb' after the first access will guarantee that all the
later accesses will see the new list.

So basically, 'consume' will end up inserting a barrier (if necessary)
before following the pointer for the first time, but once that barrier
has been inserted, we are now fully ordered wrt the releasing store,
so we're done. No need to order *all* the accesses (even off the same
base pointer), only the first one.

> But now it is time for some bullshit syntax for the RCU-protected arrays
> in the Linux kernel:
>
>         p = atomic_load_explicit(gp, memory_order_consume);
>         r1 = *p; /* Ordering maintained. */
>         r2 = p[5]; /* Ordering maintained? */

Oh yes. It's in the same object. If it wasn't, then "p[5]" itself
would be meaningless and outside the scope of the standard to begin
with.

>         r3 = p + 5; /* Ordering maintained? */
>         n = get_an_index();
>         r4 = p[n]; /* Ordering maintained? */

Yes. By definition. And again, for the very same reason. You would
violate *other* parts of the C standard before you violated the
suggested rule.

Also, remember: a lot of this is about "legalistic guarantees". In
practice, just the fact that a data chain *exists* is guarantee
enough, so from a code generation standpoint, NONE OF THIS MATTERS.

The exception is alpha, where a "mo_consume" load basically needs to
be generated with a "rmb" following it (see above how you can relax
that a _bit_, but not much). Trivial.

So code generation is actually *trivial*. Ordering is maintained
*automatically*, with no real effort on the side of the compiler.

The only issues really are:

 - the current C standard language implies *too much* ordering. The
whole "carries dependency" is broken. The practical example - even
without using "?:" or any conditionals or any function calls - is just
that

        ptr = atomic_read(pp, mo_consume);
        value = array[ptr-ptr];

  and there really isn't any sane ordering there. But the current
standard clearly says there is. The current standard is wrong.

 - my trick of saying that it is only ordered wrt accesses to the
object the pointer points to gets rid of that whole bogus false
dependency.

 - the "restricted pointer" thing is just legalistic crap, and has no
actual meaning for code generation, it is _literally_ just that if the
programmer does value speculation by hand:

        ptr = atomic_read(pp, mo_consume);
        value = object.val;
        if (ptr != &object)
                value = ptr->val;

    then in this situation the compiler does *not* need to worry about
the ordering to the "object.val" access, because it was gotten through
an alias.

So that "restrict" thing is really just a way to say "the ordering
only exists through that single pointer". That's not really what
restrict was _designed_ for, but to quote the standard:

 "An object that is accessed through a restrict-qualiﬁed pointer has a
special association
  with that pointer. This association, deﬁned in 6.7.3.1 below,
requires that all accesses to
  that object use, directly or indirectly, the value of that particular pointer"

that's not the *definition* of "restrict", and quite frankly, the
actual language that talks about "restrict" really talks about being
able to know that nobody *modifies* the value through another pointer,
so I'm clearly stretching things a bit. But anybody reading the above
quote from the standard hopefully agrees that I'm not stretching it
all that much.

                 Linus
