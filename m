Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaBMAYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:24:05 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36244 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaBMAYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:24:02 -0500
Date: Wed, 12 Feb 2014 16:23:55 -0800
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
Message-ID: <20140213002355.GI4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
 <1392183564.18779.2187.camel@triegel.csb>
 <20140212180739.GB4250@linux.vnet.ibm.com>
 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021300-0928-0000-0000-0000068C8469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:22:53PM -0800, Linus Torvalds wrote:
> On Wed, Feb 12, 2014 at 10:07 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Us Linux-kernel hackers will often need to use volatile semantics in
> > combination with C11 atomics in most cases.  The C11 atomics do cover
> > some of the reasons we currently use ACCESS_ONCE(), but not all of them --
> > in particular, it allows load/store merging.
> 
> I really disagree with the "will need to use volatile".
> 
> We should never need to use volatile (outside of whatever MMIO we do
> using C) if C11 defines atomics correctly.
> 
> Allowing load/store merging is *fine*. All sane CPU's do that anyway -
> it's called a cache - and there's no actual reason to think that
> "ACCESS_ONCE()" has to mean our current "volatile".
> 
> Now, it's possible that the C standards simply get atomics _wrong_, so
> that they create visible semantics that are different from what a CPU
> cache already does, but that's a plain bug in the standard if so.
> 
> But merging loads and stores is fine. And I *guarantee* it is fine,
> exactly because CPU's already do it, so claiming that the compiler
> couldn't do it is just insanity.

Agreed, both CPUs and compilers can merge loads and stores.  But CPUs
normally get their stores pushed through the store buffer in reasonable
time, and CPUs also use things like invalidations to ensure that a
store is seen in reasonable time by readers.  Compilers don't always
have these two properties, so we do need to be more careful of load
and store merging by compilers.

> Now, there are things that are *not* fine, like speculative stores
> that could be visible to other threads. Those are *bugs* (either in
> the compiler or in the standard), and anybody who claims otherwise is
> not worth discussing with.

And as near as I can tell, volatile semantics are required in C11 to
avoid speculative stores.  I might be wrong about this, and hope that
I am wrong.  But I am currently not seeing it in the current standard.
(Though I expect that most compilers would avoid speculating stores,
especially in the near term.

> But I really really disagree with the "we might have to use
> 'volatile'". Because if we *ever* have to use 'volatile' with the
> standard C atomic types, then we're just better off ignoring the
> atomic types entirely, because they are obviously broken shit - and
> we're better off doing it ourselves the way we have forever.
> 
> Seriously. This is not even hyperbole. It really is as simple as that.

Agreed, if we are talking about replacing ACCESS_ONCE() with C11
relaxed atomics any time soon.  But someone porting Linux to a
new CPU architecture might use a carefully chosen subset of C11
atomics to implement some of the Linux atomic operations, especially
non-value-returning atomics such as atomic_inc().

							Thanx, Paul

