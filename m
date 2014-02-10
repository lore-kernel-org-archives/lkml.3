Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBJDpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:45:46 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:43772 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaBJDpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:45:43 -0500
Date: Sun, 9 Feb 2014 19:45:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140210034533.GA15831@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140206192743.GH4250@linux.vnet.ibm.com>
 <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391992071.18779.99.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021003-3532-0000-0000-0000056E2A9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:27:51AM +0100, Torvald Riegel wrote:
> On Fri, 2014-02-07 at 10:02 -0800, Paul E. McKenney wrote:
> > On Fri, Feb 07, 2014 at 04:55:48PM +0000, Will Deacon wrote:

[ . . . ]

> > And then it is a short and uncontroversial step to the following:
> > 
> > Initial state: x == y == 0
> > 
> > T1:	atomic_store_explicit(42, y, memory_order_relaxed);
> > 	r1 = atomic_load_explicit(x, memory_order_relaxed);
> > 	if (r1 != 42)
> > 		atomic_store_explicit(r1, y, memory_order_relaxed);
> > 
> > T2:	r2 = atomic_load_explicit(y, memory_order_relaxed);
> > 	atomic_store_explicit(r2, x, memory_order_relaxed);
> > 
> > This can of course result in r1 == r2 == 42, even though the constant
> > 42 never appeared in the original code.  This is one way to generate
> > an out-of-thin-air value.
> > 
> > As near as I can tell, compiler writers hate the idea of prohibiting
> > speculative-store optimizations because it requires them to introduce
> > both control and data dependency tracking into their compilers.
> 
> I wouldn't characterize the situation like this (although I can't speak
> for others, obviously).  IMHO, it's perfectly fine on sequential /
> non-synchronizing code, because we know the difference isn't observable
> by a correct program.  For synchronizing code, compilers just shouldn't
> do it, or they would have to truly prove that speculation is harmless.
> That will be hard, so I think it should just be avoided.
> 
> Synchronization code will likely have been tuned anyway (especially if
> it uses relaxed MO), so I don't see a large need for trying to optimize
> using speculative atomic stores.
> 
> Thus, I think there's an easy and practical solution.

I like this approach, but there has been resistance to it in the past.
Definitely worth a good try, though!

> > Many of
> > them seem to hate dependency tracking with a purple passion.  At least,
> > such a hatred would go a long way towards explaining the incomplete
> > and high-overhead implementations of memory_order_consume, the long
> > and successful use of idioms based on the memory_order_consume pattern
> > notwithstanding [*].  ;-)
> 
> I still think that's different because it blurs the difference between
> sequential code and synchronizing code (ie, atomic accesses).  With
> consume MO, the simple solution above doesn't work anymore, because
> suddenly synchronizing code does affect optimizations in sequential
> code, even if that wouldn't reorder across the synchronizing code (which
> would be clearly "visible" to the implementation of the optimization).

I understand that memory_order_consume is a bit harder on compiler
writers than the other memory orders, but it is also pretty valuable.

							Thanx, Paul

