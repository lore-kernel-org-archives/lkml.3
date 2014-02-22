Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaBVUSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 15:18:15 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54384 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaBVUSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 15:18:13 -0500
Date: Sat, 22 Feb 2014 12:17:42 -0800
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
Message-ID: <20140222201742.GP4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
 <1392740258.18779.7732.camel@triegel.csb>
 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
 <1392752867.18779.8120.camel@triegel.csb>
 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
 <20140220040102.GM4250@linux.vnet.ibm.com>
 <1392917168.18779.10157.camel@triegel.csb>
 <20140220181841.GV4250@linux.vnet.ibm.com>
 <1393093837.28840.4834.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393093837.28840.4834.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022220-0928-0000-0000-000006F8247C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 07:30:37PM +0100, Torvald Riegel wrote:
> xagsmtp2.20140222183231.5343@emeavsc.vnet.ibm.com
> X-Xagent-Gateway: emeavsc.vnet.ibm.com (XAGSMTP2 at EMEAVSC)
> 
> On Thu, 2014-02-20 at 10:18 -0800, Paul E. McKenney wrote:
> > On Thu, Feb 20, 2014 at 06:26:08PM +0100, Torvald Riegel wrote:
> > > xagsmtp2.20140220172700.0416@vmsdvm4.vnet.ibm.com
> > > X-Xagent-Gateway: vmsdvm4.vnet.ibm.com (XAGSMTP2 at VMSDVM4)
> > > 
> > > On Wed, 2014-02-19 at 20:01 -0800, Paul E. McKenney wrote:
> > > > On Wed, Feb 19, 2014 at 04:53:49PM -0800, Linus Torvalds wrote:
> > > > > On Tue, Feb 18, 2014 at 11:47 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > > > > > On Tue, 2014-02-18 at 09:44 -0800, Linus Torvalds wrote:
> > > > > >>
> > > > > >> Can you point to it? Because I can find a draft standard, and it sure
> > > > > >> as hell does *not* contain any clarity of the model. It has a *lot* of
> > > > > >> verbiage, but it's pretty much impossible to actually understand, even
> > > > > >> for somebody who really understands memory ordering.
> > > > > >
> > > > > > http://www.cl.cam.ac.uk/~mjb220/n3132.pdf
> > > > > > This has an explanation of the model up front, and then the detailed
> > > > > > formulae in Section 6.  This is from 2010, and there might have been
> > > > > > smaller changes since then, but I'm not aware of any bigger ones.
> > > > > 
> > > > > Ahh, this is different from what others pointed at. Same people,
> > > > > similar name, but not the same paper.
> > > > > 
> > > > > I will read this version too, but from reading the other one and the
> > > > > standard in parallel and trying to make sense of it, it seems that I
> > > > > may have originally misunderstood part of the whole control dependency
> > > > > chain.
> > > > > 
> > > > > The fact that the left side of "? :", "&&" and "||" breaks data
> > > > > dependencies made me originally think that the standard tried very
> > > > > hard to break any control dependencies. Which I felt was insane, when
> > > > > then some of the examples literally were about the testing of the
> > > > > value of an atomic read. The data dependency matters quite a bit. The
> > > > > fact that the other "Mathematical" paper then very much talked about
> > > > > consume only in the sense of following a pointer made me think so even
> > > > > more.
> > > > > 
> > > > > But reading it some more, I now think that the whole "data dependency"
> > > > > logic (which is where the special left-hand side rule of the ternary
> > > > > and logical operators come in) are basically an exception to the rule
> > > > > that sequence points end up being also meaningful for ordering (ok, so
> > > > > C11 seems to have renamed "sequence points" to "sequenced before").
> > > > > 
> > > > > So while an expression like
> > > > > 
> > > > >     atomic_read(p, consume) ? a : b;
> > > > > 
> > > > > doesn't have a data dependency from the atomic read that forces
> > > > > serialization, writing
> > > > > 
> > > > >    if (atomic_read(p, consume))
> > > > >       a;
> > > > >    else
> > > > >       b;
> > > > > 
> > > > > the standard *does* imply that the atomic read is "happens-before" wrt
> > > > > "a", and I'm hoping that there is no question that the control
> > > > > dependency still acts as an ordering point.
> > > > 
> > > > The control dependency should order subsequent stores, at least assuming
> > > > that "a" and "b" don't start off with identical stores that the compiler
> > > > could pull out of the "if" and merge.  The same might also be true for ?:
> > > > for all I know.  (But see below)
> > > 
> > > I don't think this is quite true.  I agree that a conditional store will
> > > not be executed speculatively (note that if it would happen in both the
> > > then and the else branch, it's not conditional); so, the store in
> > > "a;" (assuming it would be a store) won't happen unless the thread can
> > > really observe a true value for p.  However, this is *this thread's*
> > > view of the world, but not guaranteed to constrain how any other thread
> > > sees the state.  mo_consume does not contribute to
> > > inter-thread-happens-before in the same way that mo_acquire does (which
> > > *does* put a constraint on i-t-h-b, and thus enforces a global
> > > constraint that all threads have to respect).
> > > 
> > > Is it clear which distinction I'm trying to show here?
> > 
> > If you are saying that the control dependencies are a result of a
> > combination of the standard and the properties of the hardware that
> > Linux runs on, I am with you.  (As opposed to control dependencies being
> > a result solely of the standard.)
> 
> I'm not quite sure I understand what you mean :)  Do you mean the
> control dependencies in the binary code, or the logical "control
> dependencies" in source programs?

At present, the intersection of those two sets, but only including those
control dependencies beginning with with a memory_order_consume load or a
[[carries_dependency]] function argument or return value.

Or something like that.  ;-)

> > This was a deliberate decision in 2007 or so.  At that time, the
> > documentation on CPU memory orderings were pretty crude, and it was
> > not clear that all relevant hardware respected control dependencies.
> > Back then, if you wanted an authoritative answer even to a fairly simple
> > memory-ordering question, you had to find a hardware architect, and you
> > probably waited weeks or even months for the answer.  Thanks to lots
> > of work from the Cambridge guys at about the time that the standard was
> > finalized, we have a much better picture of what the hardware does.
> 
> But this part I understand.

;-)

							Thanx, Paul

