Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaBTSSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:18:49 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44043 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaBTSSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:18:46 -0500
Date: Thu, 20 Feb 2014 10:18:41 -0800
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
Message-ID: <20140220181841.GV4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <20140218030002.GA15857@linux.vnet.ibm.com>
 <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
 <1392740258.18779.7732.camel@triegel.csb>
 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
 <1392752867.18779.8120.camel@triegel.csb>
 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
 <20140220040102.GM4250@linux.vnet.ibm.com>
 <1392917168.18779.10157.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392917168.18779.10157.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022018-9332-0000-0000-0000032CEE00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 06:26:08PM +0100, Torvald Riegel wrote:
> xagsmtp2.20140220172700.0416@vmsdvm4.vnet.ibm.com
> X-Xagent-Gateway: vmsdvm4.vnet.ibm.com (XAGSMTP2 at VMSDVM4)
> 
> On Wed, 2014-02-19 at 20:01 -0800, Paul E. McKenney wrote:
> > On Wed, Feb 19, 2014 at 04:53:49PM -0800, Linus Torvalds wrote:
> > > On Tue, Feb 18, 2014 at 11:47 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > > > On Tue, 2014-02-18 at 09:44 -0800, Linus Torvalds wrote:
> > > >>
> > > >> Can you point to it? Because I can find a draft standard, and it sure
> > > >> as hell does *not* contain any clarity of the model. It has a *lot* of
> > > >> verbiage, but it's pretty much impossible to actually understand, even
> > > >> for somebody who really understands memory ordering.
> > > >
> > > > http://www.cl.cam.ac.uk/~mjb220/n3132.pdf
> > > > This has an explanation of the model up front, and then the detailed
> > > > formulae in Section 6.  This is from 2010, and there might have been
> > > > smaller changes since then, but I'm not aware of any bigger ones.
> > > 
> > > Ahh, this is different from what others pointed at. Same people,
> > > similar name, but not the same paper.
> > > 
> > > I will read this version too, but from reading the other one and the
> > > standard in parallel and trying to make sense of it, it seems that I
> > > may have originally misunderstood part of the whole control dependency
> > > chain.
> > > 
> > > The fact that the left side of "? :", "&&" and "||" breaks data
> > > dependencies made me originally think that the standard tried very
> > > hard to break any control dependencies. Which I felt was insane, when
> > > then some of the examples literally were about the testing of the
> > > value of an atomic read. The data dependency matters quite a bit. The
> > > fact that the other "Mathematical" paper then very much talked about
> > > consume only in the sense of following a pointer made me think so even
> > > more.
> > > 
> > > But reading it some more, I now think that the whole "data dependency"
> > > logic (which is where the special left-hand side rule of the ternary
> > > and logical operators come in) are basically an exception to the rule
> > > that sequence points end up being also meaningful for ordering (ok, so
> > > C11 seems to have renamed "sequence points" to "sequenced before").
> > > 
> > > So while an expression like
> > > 
> > >     atomic_read(p, consume) ? a : b;
> > > 
> > > doesn't have a data dependency from the atomic read that forces
> > > serialization, writing
> > > 
> > >    if (atomic_read(p, consume))
> > >       a;
> > >    else
> > >       b;
> > > 
> > > the standard *does* imply that the atomic read is "happens-before" wrt
> > > "a", and I'm hoping that there is no question that the control
> > > dependency still acts as an ordering point.
> > 
> > The control dependency should order subsequent stores, at least assuming
> > that "a" and "b" don't start off with identical stores that the compiler
> > could pull out of the "if" and merge.  The same might also be true for ?:
> > for all I know.  (But see below)
> 
> I don't think this is quite true.  I agree that a conditional store will
> not be executed speculatively (note that if it would happen in both the
> then and the else branch, it's not conditional); so, the store in
> "a;" (assuming it would be a store) won't happen unless the thread can
> really observe a true value for p.  However, this is *this thread's*
> view of the world, but not guaranteed to constrain how any other thread
> sees the state.  mo_consume does not contribute to
> inter-thread-happens-before in the same way that mo_acquire does (which
> *does* put a constraint on i-t-h-b, and thus enforces a global
> constraint that all threads have to respect).
> 
> Is it clear which distinction I'm trying to show here?

If you are saying that the control dependencies are a result of a
combination of the standard and the properties of the hardware that
Linux runs on, I am with you.  (As opposed to control dependencies being
a result solely of the standard.)

This was a deliberate decision in 2007 or so.  At that time, the
documentation on CPU memory orderings were pretty crude, and it was
not clear that all relevant hardware respected control dependencies.
Back then, if you wanted an authoritative answer even to a fairly simple
memory-ordering question, you had to find a hardware architect, and you
probably waited weeks or even months for the answer.  Thanks to lots
of work from the Cambridge guys at about the time that the standard was
finalized, we have a much better picture of what the hardware does.

> > That said, in this case, you could substitute relaxed for consume and get
> > the same effect.  The return value from atomic_read() gets absorbed into
> > the "if" condition, so there is no dependency-ordered-before relationship,
> > so nothing for consume to do.
> > 
> > One caution...  The happens-before relationship requires you to trace a
> > full path between the two operations of interest.  This is illustrated
> > by the following example, with both x and y initially zero:
> > 
> > T1:	atomic_store_explicit(&x, 1, memory_order_relaxed);
> > 	r1 = atomic_load_explicit(&y, memory_order_relaxed);
> > 
> > T2:	atomic_store_explicit(&y, 1, memory_order_relaxed);
> > 	r2 = atomic_load_explicit(&x, memory_order_relaxed);
> > 
> > There is a happens-before relationship between T1's load and store,
> > and another happens-before relationship between T2's load and store,
> > but there is no happens-before relationship from T1 to T2, and none
> > in the other direction, either.  And you don't get to assume any
> > ordering based on reasoning about these two disjoint happens-before
> > relationships.
> > 
> > So it is quite possible for r1==1&&r2==1 after both threads complete.
> > 
> > Which should be no surprise: This misordering can happen even on x86,
> > which would need a full smp_mb() to prevent it.
> > 
> > > THAT was one of my big confusions, the discussion about control
> > > dependencies and the fact that the logical ops broke the data
> > > dependency made me believe that the standard tried to actively avoid
> > > the whole issue with "control dependencies can break ordering
> > > dependencies on some CPU's due to branch prediction and memory
> > > re-ordering by the CPU".
> > > 
> > > But after all the reading, I'm starting to think that that was never
> > > actually the implication at all, and the "logical ops breaks the data
> > > dependency rule" is simply an exception to the sequence point rule.
> > > All other sequence points still do exist, and do imply an ordering
> > > that matters for "consume"
> > > 
> > > Am I now reading it right?
> > 
> > As long as there is an unbroken chain of -data- dependencies from the
> > consume to the later access in question, and as long as that chain
> > doesn't go through the excluded operations, yes.
> > 
> > > So the clarification is basically to the statement that the "if
> > > (consume(p)) a" version *would* have an ordering guarantee between the
> > > read of "p" and "a", but the "consume(p) ? a : b" would *not* have
> > > such an ordering guarantee. Yes?
> > 
> > Neither has a data-dependency guarantee, because there is no data
> > dependency from the load to either "a" or "b".  After all, the value
> > loaded got absorbed into the "if" condition.
> 
> Agreed.
> 
> > However, according to
> > discussions earlier in this thread, the "if" variant would have a
> > control-dependency ordering guarantee for any stores in "a" and "b"
> > (but not loads!).  The ?: form might also have a control-dependency
> > guarantee for any stores in "a" and "b" (again, not loads).
> 
> Don't quite agree; see above for my opinion on this.

And see above for my best guess at what your opinion is based on.  If
my guess is correct, we might even be in agreement.

							Thanx, Paul

