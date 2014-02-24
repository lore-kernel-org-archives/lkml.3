Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaBXRVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:21:16 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36349 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaBXRVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:21:14 -0500
Date: Mon, 24 Feb 2014 09:21:10 -0800
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
Message-ID: <20140224172110.GO8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
 <1392922421.28840.36.camel@triegel.csb>
 <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
 <1393095223.28840.4914.camel@triegel.csb>
 <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
 <20140223003933.GQ4250@linux.vnet.ibm.com>
 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
 <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022417-6688-0000-0000-000006EFA9ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 07:57:24AM -0800, Linus Torvalds wrote:
> On Sun, Feb 23, 2014 at 11:31 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Let me think about it some more, but my gut feel is that just tweaking
> > the definition of what "ordered" means is sufficient.
> >
> > So to go back to the suggested ordering rules (ignoring the "restrict"
> > part, which is just to clarify that ordering through other means to
> > get to the object doesn't matter), I suggested:
> >
> >  "the consume ordering guarantees the ordering between that
> >   atomic read and the accesses to the object that the pointer
> >   points to"
> >
> > and I think the solution is to just say that this ordering acts as a
> > fence. It doesn't say exactly *where* the fence is, but it says that
> > there is *some* fence between the load of the pointer and any/all
> > accesses to the object through that pointer.
> 
> I'm wrong. That doesn't work. At all. There is no ordering except
> through the pointer chain.
> 
> So I think saying just that, and nothing else (no magic fences, no
> nothing) is the right thing:
> 
>  "the consume ordering guarantees the ordering between that
>   atomic read and the accesses to the object that the pointer
>   points to directly or indirectly through a chain of pointers"
> 
> The thing is, anything but a chain of pointers (and maybe relaxing it
> to "indexes in tables" in addition to pointers) doesn't really work.
> 
> The current standard tries to break it at "obvious" points that can
> lose the data dependency (either by turning it into a control
> dependency, or by just dropping the value, like the left-hand side of
> a comma-expression), but the fact is, it's broken.
> 
> It's broken not just because the value can be lost other ways (ie the
> "p-p" example), it's broken because the value can be turned into a
> control dependency so many other ways too.
> 
> Compilers regularly turn arithmetic ops with logical comparisons into
> branches. So an expression like "a = !!ptr" carries a dependency in
> the current C standard, but it's entirely possible that a compiler
> ends up turning it into a compare-and-branch rather than a
> compare-and-set-conditional, depending on just exactly how "a" ends up
> being used. That's true even on an architecture like ARM that has a
> lot of conditional instructions (there are way less if you compile for
> Thumb, for example, but compilers also do things like "if there are
> more than N predicated instructions I'll just turn it into a
> branch-over instead").
> 
> So I think the C standard needs to just explicitly say that you can
> walk a chain of pointers (with that possible "indexes in arrays"
> extension), and nothing more.

I am comfortable with this.  My desire for also marking the later
pointers does not make sense without some automated way of validating
them, which I don't immediately see a way to do.

So let me try laying out the details.  Sticking with pointers for the
moment, if we reach agreement on these, I will try expanding to integers.

1.	A pointer value obtained from a memory_order_consume load is part
	of a pointer chain.  I am calling the pointer itself a "chained
	pointer" for the moment.
	
2.	Note that it is the value that qualifies as being chained, not
	the variable.  For example, given pointer variable might hold
	a chained pointer at one point in the code, then a non-chained
	pointer later.  Therefore, "q = p", where "q" is a pointer and
	"p" is a chained pointer results in "q" containing a chained
	pointer.

3.	Adding or subtracting an integer to/from a chained pointer
	results in another chained pointer in that same pointer chain.

4.	Bitwise operators ("&", "|", "^", and I suppose also "~")
	applied to a chained pointer and an integer results in another
	chained pointer in that same pointer chain.

5.	Consider a sequence as follows: dereference operator (unary "*",
	"[]", "->") optionally followed by a series of direct selection
	operators ("."), finally (and unconditionally) followed by
	a unary "&" operator.  Applying such a sequence to a chained
	pointer results in another chained pointer in the same chain.

	Given a chained pointer "p", examples include "&p[3]",
	"&p->a.b.c.d.e.f.g", and "&*p".

6.	The expression "p->f", where "p" is a chained pointer and "f"
	is a pointer, results in a chained pointer.

	FWIW, this means that pointer chains can overlap as in this
	example:
	
		p = atomic_load_explicit(&gp, memory_order_consume);
		q = atomic_load_explicit(&p->ap, memory_order_consume);
		x = q->a;

	This should be fine, I don't see any problems with this.

7.	Applying a pointer cast to a chained pointer results in a
	chained pointer.

8.	Applying any of the following operators to a chained pointer
	results in something that is not a chained pointer:
	"()", sizeof, "!", "*", "/", "%", ">>", "<<", "<", ">", "<=",
	">=", "==", "!=", "&&", and "||".

9.	The effect of the compound assignment operators "+=", "-=",
	and so on is the same as the equivalent expression using
	simple assignment.

10.	In a "?:" operator, if the selected one of the rightmost two
	values is a chained pointer, then the result is also a
	chained pointer.

11.	In a "," operator, if the rightmost value is a chained pointer,
	then the result is also a chained pointer.

12.	A memory_order_consume load carries a dependency to any
	dereference operator (unary "*", "[]", and "->") in the
	resulting pointer chain.

I think that covers everything...

							Thanx, Paul

