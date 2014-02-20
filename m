Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaBTRQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:16:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbaBTRQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:16:31 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Mark Batty <mbatty@cl.cam.ac.uk>,
        Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
In-Reply-To: <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
References: <1392321837.18779.3249.camel@triegel.csb>
	 <20140214020144.GO4250@linux.vnet.ibm.com>
	 <1392352981.18779.3800.camel@triegel.csb>
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <20140218030002.GA15857@linux.vnet.ibm.com>
	 <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	 <1392740258.18779.7732.camel@triegel.csb>
	 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	 <1392752867.18779.8120.camel@triegel.csb>
	 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Feb 2014 18:14:52 +0100
Message-ID: <1392916492.18779.10136.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 16:53 -0800, Linus Torvalds wrote:
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
> hard to break any control dependencies.

Hmm... (I'm not quite sure how to express this properly, so bear with
me.)

The control dependencies as you seem to consider aren't there *as is*,
and removing "? :", "&&", and "||" from what's called
Carries-a-dependency-to in n3132 is basically removing control
dependences in expressions from that relation (ie, so it's just data
dependences).

However, control dependences in the program are not ignored, because
they control what steps the abstract machine would do.  If we have
candidate executions with a particular choice for the reads-from
relation, they must make sense in terms of program logic (which does
include conditionals and such), or a candidate execution will not be
consistent.  The difference is in how reads-from is constrainted by
different memory orders.

I hope what I mean gets clearer below when looking at the example...

Mark Batty / Peter Sewell:  Do you have a better explanation?  (And
please correct anything wrong in what I wrote ;)

> Which I felt was insane, when
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

I'm not quite sure what you mean, but I think that this isn't quite the
case.  mo_consume and mo_acquire combine with sequenced-before
differently.  Have a look at the definition of
inter-thread-happens-before (6.15 in n3132): for synchronizes-with, the
composition with sequenced-before is used (ie, what you'd get with
mo_acquire), whereas for mo_consume, we just have
dependency_ordered_before (so, data dependencies only).

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

I don't think it does for mo_consume (but does for mo_acquire).  Both
examples do basically the same in the abstract machine, and I think it
would be surprising if rewriting could the code with something seemingly
equivalent would make a semantic difference.  AFAICT, "? :" etc. is
removed to allow the standard defining data dependencies as being based
on expressions that take the mo_consume value as input, without also
pulling in control dependencies.

To look at this example in the cppmem tool, we can transform your
example above into:

int main() {
  atomic_int x = 0; 
  int y = 0;
  {{{ { y = 1; x.store(1, memory_order_release); }
  ||| { if (x.load(memory_order_consume)) r2 = y; }
  }}};
  return 0; }

This has 2 threads, one is doing the store to y (the data) and the
release operation, the other is using consume to try to read the data.

This yields 2 consistent executions (we can read 2 values of x), but the
execution in which we read y has a data race.

I'm not quite sure how the tool parses/models data dependencies in
expressions, but the program (ie, your example) doesn't carry a
dependency from the mo_consume load to the load from y (as defined in C
++ 1.10p9 and n3132 6.13).  Thus, the mo_release store is
dependency-ordered-before the mo_consume load ("dob" in the tool's
output graph), but that doesn't extend to the load from y.  Therefore,
the load is unordered wrt. to the first thread's "y = 1", and because
they are nonatomic, we get a data race (labeled "dr").  (The labels on
the edges are easier to see in the "dot" Display Layout, even though one
has to then figure out which vertex belongs to which thread.)

If you enable it with the display options, the tool will show a control
dependency, but that is currently unused it seems (see 6.20 in n3132).

If we change mo_consume to mo_acquire in the example, the race goes
away.  (This is visible in the inter-thread-happens-before relation,
which can be shown by "removing suppress_edge ithb." under "edit display
options" (but this makes the graph kind of messy)).

BTW, a pretty similar way to expressing this cppmem code above is using
readsvalue() to constrain executions:

int main() {
  atomic_int x = 0; 
  int y = 0;
  {{{ { y = 1; x.store(1, memory_order_release); }
  ||| { r1 = x.load(memory_order_consume).readsvalue(1); r2 = y; }
  }}};
  return 0; }

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
> 
> So the clarification is basically to the statement that the "if
> (consume(p)) a" version *would* have an ordering guarantee between the
> read of "p" and "a", but the "consume(p) ? a : b" would *not* have
> such an ordering guarantee. Yes?

Not as I understand it.  If my reply above wasn't clear, let me know and
I'll try to rephrase it into something that is.

