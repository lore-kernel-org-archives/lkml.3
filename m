Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaBTEBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:01:12 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55635 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaBTEBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:01:09 -0500
Date: Wed, 19 Feb 2014 20:01:02 -0800
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
Message-ID: <20140220040102.GM4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <20140218030002.GA15857@linux.vnet.ibm.com>
 <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
 <1392740258.18779.7732.camel@triegel.csb>
 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
 <1392752867.18779.8120.camel@triegel.csb>
 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022004-1542-0000-0000-0000066BB5C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:53:49PM -0800, Linus Torvalds wrote:
> On Tue, Feb 18, 2014 at 11:47 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > On Tue, 2014-02-18 at 09:44 -0800, Linus Torvalds wrote:
> >>
> >> Can you point to it? Because I can find a draft standard, and it sure
> >> as hell does *not* contain any clarity of the model. It has a *lot* of
> >> verbiage, but it's pretty much impossible to actually understand, even
> >> for somebody who really understands memory ordering.
> >
> > http://www.cl.cam.ac.uk/~mjb220/n3132.pdf
> > This has an explanation of the model up front, and then the detailed
> > formulae in Section 6.  This is from 2010, and there might have been
> > smaller changes since then, but I'm not aware of any bigger ones.
> 
> Ahh, this is different from what others pointed at. Same people,
> similar name, but not the same paper.
> 
> I will read this version too, but from reading the other one and the
> standard in parallel and trying to make sense of it, it seems that I
> may have originally misunderstood part of the whole control dependency
> chain.
> 
> The fact that the left side of "? :", "&&" and "||" breaks data
> dependencies made me originally think that the standard tried very
> hard to break any control dependencies. Which I felt was insane, when
> then some of the examples literally were about the testing of the
> value of an atomic read. The data dependency matters quite a bit. The
> fact that the other "Mathematical" paper then very much talked about
> consume only in the sense of following a pointer made me think so even
> more.
> 
> But reading it some more, I now think that the whole "data dependency"
> logic (which is where the special left-hand side rule of the ternary
> and logical operators come in) are basically an exception to the rule
> that sequence points end up being also meaningful for ordering (ok, so
> C11 seems to have renamed "sequence points" to "sequenced before").
> 
> So while an expression like
> 
>     atomic_read(p, consume) ? a : b;
> 
> doesn't have a data dependency from the atomic read that forces
> serialization, writing
> 
>    if (atomic_read(p, consume))
>       a;
>    else
>       b;
> 
> the standard *does* imply that the atomic read is "happens-before" wrt
> "a", and I'm hoping that there is no question that the control
> dependency still acts as an ordering point.

The control dependency should order subsequent stores, at least assuming
that "a" and "b" don't start off with identical stores that the compiler
could pull out of the "if" and merge.  The same might also be true for ?:
for all I know.  (But see below)

That said, in this case, you could substitute relaxed for consume and get
the same effect.  The return value from atomic_read() gets absorbed into
the "if" condition, so there is no dependency-ordered-before relationship,
so nothing for consume to do.

One caution...  The happens-before relationship requires you to trace a
full path between the two operations of interest.  This is illustrated
by the following example, with both x and y initially zero:

T1:	atomic_store_explicit(&x, 1, memory_order_relaxed);
	r1 = atomic_load_explicit(&y, memory_order_relaxed);

T2:	atomic_store_explicit(&y, 1, memory_order_relaxed);
	r2 = atomic_load_explicit(&x, memory_order_relaxed);

There is a happens-before relationship between T1's load and store,
and another happens-before relationship between T2's load and store,
but there is no happens-before relationship from T1 to T2, and none
in the other direction, either.  And you don't get to assume any
ordering based on reasoning about these two disjoint happens-before
relationships.

So it is quite possible for r1==1&&r2==1 after both threads complete.

Which should be no surprise: This misordering can happen even on x86,
which would need a full smp_mb() to prevent it.

> THAT was one of my big confusions, the discussion about control
> dependencies and the fact that the logical ops broke the data
> dependency made me believe that the standard tried to actively avoid
> the whole issue with "control dependencies can break ordering
> dependencies on some CPU's due to branch prediction and memory
> re-ordering by the CPU".
> 
> But after all the reading, I'm starting to think that that was never
> actually the implication at all, and the "logical ops breaks the data
> dependency rule" is simply an exception to the sequence point rule.
> All other sequence points still do exist, and do imply an ordering
> that matters for "consume"
> 
> Am I now reading it right?

As long as there is an unbroken chain of -data- dependencies from the
consume to the later access in question, and as long as that chain
doesn't go through the excluded operations, yes.

> So the clarification is basically to the statement that the "if
> (consume(p)) a" version *would* have an ordering guarantee between the
> read of "p" and "a", but the "consume(p) ? a : b" would *not* have
> such an ordering guarantee. Yes?

Neither has a data-dependency guarantee, because there is no data
dependency from the load to either "a" or "b".  After all, the value
loaded got absorbed into the "if" condition.  However, according to
discussions earlier in this thread, the "if" variant would have a
control-dependency ordering guarantee for any stores in "a" and "b"
(but not loads!).  The ?: form might also have a control-dependency
guarantee for any stores in "a" and "b" (again, not loads).

Why my uncertainty?

Well, the standard does not talk explicitly about control dependencies.
They currently appear to be a side effect of other requirements in the
standard, for example, the prohibition against doing stores to atomics
if those stores wouldn't happen in an unoptimized naive compilation
of the program.  Even then, you have to take this in combination with
ordering guarantees of all the hardware that Linux currently runs on to
get to the control dependency.

I would feel way better if the standard explicitly called out ordering
based on control dependencies, but that is something for Torvald Riegel
and me to hash out.  ;-)

							Thanx, Paul

