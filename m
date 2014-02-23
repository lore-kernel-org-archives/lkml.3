Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaBWAjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 19:39:42 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:48815 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaBWAjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 19:39:40 -0500
Date: Sat, 22 Feb 2014 16:39:33 -0800
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
Message-ID: <20140223003933.GQ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022300-0928-0000-0000-000006F8DF0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 01:53:30PM -0800, Linus Torvalds wrote:
> On Sat, Feb 22, 2014 at 10:53 AM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > Stating that (1) "the standard is wrong" and (2) that you think that
> > mo_consume semantics are not good is two different things.
> 
> I do agree. They are two independent things.
> 
> I think the standard is wrong, because it's overly complex, hard to
> understand, and nigh unimplementable. As shown by the bugzilla
> example, "carries a dependency" encompasses things that are *not* just
> synchronizing things just through a pointer, and as a result it's
> actually very complicated, since they could have been optimized away,
> or done in non-local code that wasn't even aware of the dependency
> carrying.
> 
> That said, I'm reconsidering my suggested stricter semantics, because
> for RCU we actually do want to test the resulting pointer against NULL
> _without_ any implied serialization.
> 
> So I still feel that the standard as written is fragile and confusing
> (and the bugzilla entry pretty much proves that it is also practically
> unimplementable as written), but strengthening the serialization may
> be the wrong thing.
> 
> Within the kernel, the RCU use for this is literally purely about
> loading a pointer, and doing either:
> 
>  - testing its value against NULL (without any implied synchronization at all)
> 
>  - using it as a pointer to an object, and expecting that any accesses
> to that object are ordered wrt the consuming load.

Agreed, by far the most frequent use is "->" to dereference and assignment
to store into a local variable.  The other operations where the kernel
expects ordering to be maintained are:

o	Bitwise "&" to strip off low-order bits.  The FIB tree does
	this, for example in fib_table_lookup() in net/ipv4/fib_trie.c.
	The low-order bit is used to distinguish internal nodes from
	leaves -- nodes and leaves are different types of structures.
	(There are a few others.)

o	Uses "?:" to substitute defaults in case of NULL pointers,
	but ordering must be maintained in the non-default case.
	Most, perhaps all, of these could be converted to "if" should
	"?:" prove problematic.

o	Addition and subtraction to adjust both pointers to and indexes
	into RCU-protected arrays.  There are not that many indexes,
	and they could be converted to pointers, but the addition and
	subtraction looks necessary in a some cases.

o	Array indexing.  The value from rcu_dereference() is used both
	before and inside the "[]", interestingly enough.

o	Casts along with unary "&" and "*".

That said, I did not see any code that dependended on ordering through
the function-call "()", boolean complement "!", comparison (only "=="
and "!="), logical operators ("&&" and "||"), and the "*", "/", and "%"
arithmetic operators.

> So I actually have a suggested *very* different model that people
> might find more acceptable.
> 
> How about saying that the result of a "atomic_read(&a, mo_consume)" is
> required to be a _restricted_ pointer type, and that the consume
> ordering guarantees the ordering between that atomic read and the
> accesses to the object that the pointer points to.
> 
> No "carries a dependency", no nothing.

In the case of arrays, the object that the pointer points to is
considered to be the full array, right?

> Now, there's two things to note in there:
> 
>  - the "restricted pointer" part means that the compiler does not need
> to worry about serialization to that object through other possible
> pointers - we have basically promised that the *only* pointer to that
> object comes from the mo_consume. So that part makes it clear that the
> "consume" ordering really only is valid wrt that particular pointer
> load.

That could work, though there are some cases where a multi-linked
structure is made visible using a single rcu_assign_pointer(), and
rcu_dereference() is used only for the pointer leading to that
multi-linked structure, not for the pointers among the elements
making up that structure.  One way to handle this would be to
require rcu_dereference() to be used within the structure an well
as upon first traversal to the structure.

>  - the "to the object that the pointer points to" makes it clear that
> you can't use the pointer to generate arbitrary other values and claim
> to serialize that way.
> 
> IOW, with those alternate semantics, that gcc bugzilla example is
> utterly bogus, and a compiler can ignore it, because while it tries to
> synchronize through the "dependency chain" created with that "p-i+i"
> expression, that is completely irrelevant when you use the above rules
> instead.
> 
> In the bugzilla example, the object that "*(p-i+i)" accesses isn't
> actually the object pointed to by the pointer, so no serialization is
> implied. And if it actually *were* to be the same object, because "p"
> happens to have the same value as "i", then the "restrict" part of the
> rule pops up and the compiler can again say that there is no ordering
> guarantee, since the programmer lied to it and used a restricted
> pointer that aliased with another one.
> 
> So the above suggestion basically tightens the semantics of "consume"
> in a totally different way - it doesn't make it serialize more, in
> fact it weakens the serialization guarantees a lot, but it weakens
> them in a way that makes the semantics a lot simpler and clearer.

It does look simpler and does look like it handles a large fraction of
the Linux-kernel uses.

But now it is time for some bullshit syntax for the RCU-protected arrays
in the Linux kernel:

	p = atomic_load_explicit(gp, memory_order_consume);
	r1 = *p; /* Ordering maintained. */
	r2 = p[5]; /* Ordering maintained? */
	r3 = p + 5; /* Ordering maintained? */
	n = get_an_index();
	r4 = p[n]; /* Ordering maintained? */

If the answer to the three questions is "no", then perhaps some special
function takes care of accesses to RCU-protected arrays.

							Thanx, Paul

