Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaBNCBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:01:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57909 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaBNCBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:01:51 -0500
Date: Thu, 13 Feb 2014 18:01:44 -0800
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
Message-ID: <20140214020144.GO4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
 <1392183564.18779.2187.camel@triegel.csb>
 <20140212180739.GB4250@linux.vnet.ibm.com>
 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
 <20140213002355.GI4250@linux.vnet.ibm.com>
 <1392321837.18779.3249.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392321837.18779.3249.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021402-0928-0000-0000-0000069D3720
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 12:03:57PM -0800, Torvald Riegel wrote:
> On Wed, 2014-02-12 at 16:23 -0800, Paul E. McKenney wrote:
> > On Wed, Feb 12, 2014 at 12:22:53PM -0800, Linus Torvalds wrote:
> > > On Wed, Feb 12, 2014 at 10:07 AM, Paul E. McKenney
> > > <paulmck@linux.vnet.ibm.com> wrote:
> > > >
> > > > Us Linux-kernel hackers will often need to use volatile semantics in
> > > > combination with C11 atomics in most cases.  The C11 atomics do cover
> > > > some of the reasons we currently use ACCESS_ONCE(), but not all of them --
> > > > in particular, it allows load/store merging.
> > > 
> > > I really disagree with the "will need to use volatile".
> > > 
> > > We should never need to use volatile (outside of whatever MMIO we do
> > > using C) if C11 defines atomics correctly.
> > > 
> > > Allowing load/store merging is *fine*. All sane CPU's do that anyway -
> > > it's called a cache - and there's no actual reason to think that
> > > "ACCESS_ONCE()" has to mean our current "volatile".
> > > 
> > > Now, it's possible that the C standards simply get atomics _wrong_, so
> > > that they create visible semantics that are different from what a CPU
> > > cache already does, but that's a plain bug in the standard if so.
> > > 
> > > But merging loads and stores is fine. And I *guarantee* it is fine,
> > > exactly because CPU's already do it, so claiming that the compiler
> > > couldn't do it is just insanity.
> > 
> > Agreed, both CPUs and compilers can merge loads and stores.  But CPUs
> > normally get their stores pushed through the store buffer in reasonable
> > time, and CPUs also use things like invalidations to ensure that a
> > store is seen in reasonable time by readers.  Compilers don't always
> > have these two properties, so we do need to be more careful of load
> > and store merging by compilers.
> 
> The standard's _wording_ is a little vague about forward-progress
> guarantees, but I believe the vast majority of the people involved do
> want compilers to not prevent forward progress.  There is of course a
> difference whether a compiler establishes _eventual_ forward progress in
> the sense of after 10 years or forward progress in a small bounded
> interval of time, but this is a QoI issue, and good compilers won't want
> to introduce unnecessary latencies.  I believe that it is fine if the
> standard merely talks about eventual forward progress.

The compiler will need to earn my trust on this one.  ;-)

> > > Now, there are things that are *not* fine, like speculative stores
> > > that could be visible to other threads. Those are *bugs* (either in
> > > the compiler or in the standard), and anybody who claims otherwise is
> > > not worth discussing with.
> > 
> > And as near as I can tell, volatile semantics are required in C11 to
> > avoid speculative stores.  I might be wrong about this, and hope that
> > I am wrong.  But I am currently not seeing it in the current standard.
> > (Though I expect that most compilers would avoid speculating stores,
> > especially in the near term.
> 
> This really depends on how we define speculative stores.  The memory
> model is absolutely clear that programs have to behave as if executed by
> the virtual machine, and that rules out speculative stores to volatiles
> and other locations.  Under certain circumstances, there will be
> "speculative" stores in the sense that they will happen at different
> times as if you had a trivial implementation of the abstract machine.
> But to be allowed to do that, the compiler has to prove that such a
> transformation still fulfills the as-if rule.

Agreed, although the as-if rule would ignore control dependencies, since
these are not yet part of the standard (as you in fact note below).
I nevertheless consider myself at least somewhat reassured that current
C11 won't speculate stores.  My remaining concerns involve the compiler
proving to itself that a given branch is always taken, thus motivating
it to optimize the branch away -- though this is more properly a
control-dependency concern.

> IOW, the abstract machine is what currently defines disallowed
> speculative stores.  If you want to put *further* constraints on what
> implementations are allowed to do, I suppose it is best to talk about
> those and see how we can add rules that allow programmers to express
> those constraints.  For example, control dependencies might be such a
> case.  I don't have a specific suggestion -- maybe the control
> dependencies are best tackled similar to consume dependencies (even
> though we don't have a good solution for those yets).  But using
> volatile accesses for that seems to be a big hammer, or even the wrong
> one.

In current compilers, the two hammers we have are volatile and barrier().
But yes, it would be good to have something more focused.  One option
would be to propose memory_order_control loads to see how loudly the
committee screams.  One use case might be as follows:

	if (atomic_load(x, memory_order_control))
		atomic_store(y, memory_order_relaxed);

This could also be written:

	r1 = atomic_load(x, memory_order_control);
	if (r1)
		atomic_store(y, memory_order_relaxed);

A branch depending on the memory_order_control load could not be optimized
out, though I suppose that the compiler could substitute a memory-barrier
instruction for the branch.  Seems like it would take a very large number
of branches to equal the overhead of the memory barrier, though.

Another option would be to flag the conditional expression, prohibiting
the compiler from optimizing out any conditional branches.  Perhaps
something like this:

	r1 = atomic_load(x, memory_order_control);
	if (control_dependency(r1))
		atomic_store(y, memory_order_relaxed);

Other thoughts?

							Thanx, Paul

