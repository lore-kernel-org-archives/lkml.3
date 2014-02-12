Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaBLSUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:20:20 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35709 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaBLSUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:20:11 -0500
Date: Wed, 12 Feb 2014 10:07:39 -0800
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
Message-ID: <20140212180739.GB4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
 <1392183564.18779.2187.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392183564.18779.2187.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021218-0928-0000-0000-00000688F4B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 09:39:24PM -0800, Torvald Riegel wrote:
> On Mon, 2014-02-10 at 11:09 -0800, Linus Torvalds wrote:
> > On Sun, Feb 9, 2014 at 4:27 PM, Torvald Riegel <triegel@redhat.com> wrote:
> > >
> > > Intuitively, this is wrong because this let's the program take a step
> > > the abstract machine wouldn't do.  This is different to the sequential
> > > code that Peter posted because it uses atomics, and thus one can't
> > > easily assume that the difference is not observable.
> > 
> > Btw, what is the definition of "observable" for the atomics?
> > 
> > Because I'm hoping that it's not the same as for volatiles, where
> > "observable" is about the virtual machine itself, and as such volatile
> > accesses cannot be combined or optimized at all.
> 
> No, atomics aren't an observable behavior of the abstract machine
> (unless they are volatile).  See 1.8.p8 (citing the C++ standard).

Us Linux-kernel hackers will often need to use volatile semantics in
combination with C11 atomics in most cases.  The C11 atomics do cover
some of the reasons we currently use ACCESS_ONCE(), but not all of them --
in particular, it allows load/store merging.

> > Now, I claim that atomic accesses cannot be done speculatively for
> > writes, and not re-done for reads (because the value could change),
> 
> Agreed, unless the compiler can prove that this doesn't make a
> difference in the program at hand and it's not volatile atomics.  In
> general, that will be hard and thus won't happen often I suppose, but if
> correctly proved it would fall under the as-if rule I think.
> 
> > but *combining* them would be possible and good.
> 
> Agreed.

In some cases, agreed.  But many uses in the Linux kernel will need
volatile semantics in combination with C11 atomics.  Which is OK, for
the foreseeable future, anyway.

> > For example, we often have multiple independent atomic accesses that
> > could certainly be combined: testing the individual bits of an atomic
> > value with helper functions, causing things like "load atomic, test
> > bit, load same atomic, test another bit". The two atomic loads could
> > be done as a single load without possibly changing semantics on a real
> > machine, but if "visibility" is defined in the same way it is for
> > "volatile", that wouldn't be a valid transformation. Right now we use
> > "volatile" semantics for these kinds of things, and they really can
> > hurt.
> 
> Agreed.  In your example, the compiler would have to prove that the
> abstract machine would always be able to run the two loads atomically
> (ie, as one load) without running into impossible/disallowed behavior of
> the program.  But if there's no loop or branch or such in-between, this
> should be straight-forward because any hardware oddity or similar could
> merge those loads and it wouldn't be disallowed by the standard
> (considering that we're talking about a finite number of loads), so the
> compiler would be allowed to do it as well.

As long as they are not marked volatile, agreed.

							Thanx, Paul

> > Same goes for multiple writes (possibly due to setting bits):
> > combining multiple accesses into a single one is generally fine, it's
> > *adding* write accesses speculatively that is broken by design..
> 
> Agreed.  As Paul points out, this being correct assumes that there are
> no other ordering guarantees or memory accesses "interfering", but if
> the stores are to the same memory location and adjacent to each other in
> the program, then I don't see a reason why they wouldn't be combinable.
> 
> > At the same time, you can't combine atomic loads or stores infinitely
> > - "visibility" on a real machine definitely is about timeliness.
> > Removing all but the last write when there are multiple consecutive
> > writes is generally fine, even if you unroll a loop to generate those
> > writes. But if what remains is a loop, it might be a busy-loop
> > basically waiting for something, so it would be wrong ("untimely") to
> > hoist a store in a loop entirely past the end of the loop, or hoist a
> > load in a loop to before the loop.
> 
> Agreed.  That's what 1.10p24 and 1.10p25 are meant to specify for loads,
> although those might not be bullet-proof as Paul points out.  Forward
> progress is rather vaguely specified in the standard, but at least parts
> of the committee (and people in ISO C++ SG1, in particular) are working
> on trying to improve this.
> 
> > Does the standard allow for that kind of behavior?
> 
> I think the standard requires (or intends to require) the behavior that
> you (and I) seem to prefer in these examples.
> 
> 

