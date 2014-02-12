Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaBLRmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:42:21 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59129 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaBLRmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:42:19 -0500
Date: Wed, 12 Feb 2014 09:42:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Torvald Riegel <triegel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140212174209.GA4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
 <20140211155941.GU4250@linux.vnet.ibm.com>
 <1392185194.18779.2239.camel@triegel.csb>
 <20140212091907.GA3545@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212091907.GA3545@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021217-9332-0000-0000-00000314D1AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:19:07AM +0100, Peter Zijlstra wrote:
> > I don't know the specifics of your example, but from how I understand
> > it, I don't see a problem if the compiler can prove that the store will
> > always happen.
> > 
> > To be more specific, if the compiler can prove that the store will
> > happen anyway, and the region of code can be assumed to always run
> > atomically (e.g., there's no loop or such in there), then it is known
> > that we have one atomic region of code that will always perform the
> > store, so we might as well do the stuff in the region in some order.
> > 
> > Now, if any of the memory accesses are atomic, then the whole region of
> > code containing those accesses is often not atomic because other threads
> > might observe intermediate results in a data-race-free way.
> > 
> > (I know that this isn't a very precise formulation, but I hope it brings
> > my line of reasoning across.)
> 
> So given something like:
> 
> 	if (x)
> 		y = 3;
> 
> assuming both x and y are atomic (so don't gimme crap for now knowing
> the C11 atomic incantations); and you can prove x is always true; you
> don't see a problem with not emitting the conditional?

You need volatile semantics to force the compiler to ignore any proofs
it might otherwise attempt to construct.  Hence all the ACCESS_ONCE()
calls in my email to Torvald.  (Hopefully I translated your example
reasonably.)

							Thanx, Paul

> Avoiding the conditional changes the result; see that control dependency
> email from earlier. In the above example the load of X and the store to
> Y are strictly ordered, due to control dependencies. Not emitting the
> condition and maybe not even emitting the load completely wrecks this.
> 
> Its therefore an invalid optimization to take out the conditional or
> speculate the store, since it takes out the dependency.
> 

