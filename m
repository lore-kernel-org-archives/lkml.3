Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBGSoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:44:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaBGSn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:43:59 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140207170654.GQ5002@laptop.programming.kicks-ass.net>
References: <52F3DA85.1060209@arm.com>
	 <20140206185910.GE27276@mudshark.cambridge.arm.com>
	 <20140206192743.GH4250@linux.vnet.ibm.com>
	 <1391721423.23421.3898.camel@triegel.csb>
	 <20140206221117.GJ4250@linux.vnet.ibm.com>
	 <1391730288.23421.4102.camel@triegel.csb>
	 <20140207042051.GL4250@linux.vnet.ibm.com>
	 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
	 <20140207165028.GO4250@linux.vnet.ibm.com>
	 <20140207165548.GR5976@mudshark.cambridge.arm.com>
	 <20140207170654.GQ5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Feb 2014 19:43:22 +0100
Message-ID: <1391798602.23421.4802.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 18:06 +0100, Peter Zijlstra wrote:
> On Fri, Feb 07, 2014 at 04:55:48PM +0000, Will Deacon wrote:
> > Hi Paul,
> > 
> > On Fri, Feb 07, 2014 at 04:50:28PM +0000, Paul E. McKenney wrote:
> > > On Fri, Feb 07, 2014 at 08:44:05AM +0100, Peter Zijlstra wrote:
> > > > On Thu, Feb 06, 2014 at 08:20:51PM -0800, Paul E. McKenney wrote:
> > > > > Hopefully some discussion of out-of-thin-air values as well.
> > > > 
> > > > Yes, absolutely shoot store speculation in the head already. Then drive
> > > > a wooden stake through its hart.
> > > > 
> > > > C11/C++11 should not be allowed to claim itself a memory model until that
> > > > is sorted.
> > > 
> > > There actually is a proposal being put forward, but it might not make ARM
> > > and Power people happy because it involves adding a compare, a branch,
> > > and an ISB/isync after every relaxed load...  Me, I agree with you,
> > > much preferring the no-store-speculation approach.
> > 
> > Can you elaborate a bit on this please? We don't permit speculative stores
> > in the ARM architecture, so it seems counter-intuitive that GCC needs to
> > emit any additional instructions to prevent that from happening.
> > 
> > Stores can, of course, be observed out-of-order but that's a lot more
> > reasonable :)
> 
> This is more about the compiler speculating on stores; imagine:
> 
>   if (x)
>   	y = 1;
>   else
>   	y = 2;
> 
> The compiler is allowed to change that into:
> 
>   y = 2;
>   if (x)
>   	y = 1;

If you write the example like that, this is indeed allowed because it's
all sequential code (and there's no volatiles in there, at least you
didn't show them :).  A store to y would happen in either case.  You
cannot observe the difference between both examples in a data-race-free
program.

Are there supposed to be atomic/non-sequential accesses in there?  If
so, please update the example.

> Which is of course a big problem when you want to rely on the ordering.
> 
> There's further problems where things like memset() can write outside
> the specified address range. Examples are memset() using single
> instructions to wipe entire cachelines and then 'restoring' the tail
> bit.

As Joseph said, this would be a bug IMO.

> While valid for single threaded, its a complete disaster for concurrent
> code.
> 
> There's more, but it all boils down to doing stores you don't expect in
> a 'sane' concurrent environment and/or don't respect the control flow.

A few of those got fixed already, because they violated the memory
model's requirements.  If you have further examples that are valid code
in the C11/C++11 model, please report them.


