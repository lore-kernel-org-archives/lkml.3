Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaBFT1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:27:50 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54049 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaBFT1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:27:48 -0500
Date: Thu, 6 Feb 2014 11:27:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140206192743.GH4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140206134825.305510953@infradead.org>
 <21984.1391711149@warthog.procyon.org.uk>
 <52F3DA85.1060209@arm.com>
 <20140206185910.GE27276@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206185910.GE27276@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020619-3532-0000-0000-00000553AA4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 06:59:10PM +0000, Will Deacon wrote:
> On Thu, Feb 06, 2014 at 06:55:01PM +0000, Ramana Radhakrishnan wrote:
> > On 02/06/14 18:25, David Howells wrote:
> > >
> > > Is it worth considering a move towards using C11 atomics and barriers and
> > > compiler intrinsics inside the kernel?  The compiler _ought_ to be able to do
> > > these.
> > 
> > 
> > It sounds interesting to me, if we can make it work properly and 
> > reliably. + gcc@gcc.gnu.org for others in the GCC community to chip in.
> 
> Given my (albeit limited) experience playing with the C11 spec and GCC, I
> really think this is a bad idea for the kernel. It seems that nobody really
> agrees on exactly how the C11 atomics map to real architectural
> instructions on anything but the trivial architectures. For example, should
> the following code fire the assert?
> 
> 
> extern atomic<int> foo, bar, baz;
> 
> void thread1(void)
> {
> 	foo.store(42, memory_order_relaxed);
> 	bar.fetch_add(1, memory_order_seq_cst);
> 	baz.store(42, memory_order_relaxed);
> }
> 
> void thread2(void)
> {
> 	while (baz.load(memory_order_seq_cst) != 42) {
> 		/* do nothing */
> 	}
> 
> 	assert(foo.load(memory_order_seq_cst) == 42);
> }
> 
> 
> To answer that question, you need to go and look at the definitions of
> synchronises-with, happens-before, dependency_ordered_before and a whole
> pile of vaguely written waffle to realise that you don't know. Certainly,
> the code that arm64 GCC currently spits out would allow the assertion to fire
> on some microarchitectures.

Yep!  I believe that a memory_order_seq_cst fence in combination with the
fetch_add() would do the trick on many architectures, however.  All of
this is one reason that any C11 definitions need to be individually
overridable by individual architectures.

> There are also so many ways to blow your head off it's untrue. For example,
> cmpxchg takes a separate memory model parameter for failure and success, but
> then there are restrictions on the sets you can use for each. It's not hard
> to find well-known memory-ordering experts shouting "Just use
> memory_model_seq_cst for everything, it's too hard otherwise". Then there's
> the fun of load-consume vs load-acquire (arm64 GCC completely ignores consume
> atm and optimises all of the data dependencies away) as well as the definition
> of "data races", which seem to be used as an excuse to miscompile a program
> at the earliest opportunity.

Trust me, rcu_dereference() is not going to be defined in terms of
memory_order_consume until the compilers implement it both correctly and
efficiently.  They are not there yet, and there is currently no shortage
of compiler writers who would prefer to ignore memory_order_consume.
And rcu_dereference() will need per-arch overrides for some time during
any transition to memory_order_consume.

> Trying to introduce system concepts (writes to devices, interrupts,
> non-coherent agents) into this mess is going to be an uphill battle IMHO. I'd
> just rather stick to the semantics we have and the asm volatile barriers.

And barrier() isn't going to go away any time soon, either.  And
ACCESS_ONCE() needs to keep volatile semantics until there is some
memory_order_whatever that prevents loads and stores from being coalesced.

> That's not to say I don't there's no room for improvement in what we have
> in the kernel. Certainly, I'd welcome allowing more relaxed operations on
> architectures that support them, but it needs to be something that at least
> the different architecture maintainers can understand how to implement
> efficiently behind an uncomplicated interface. I don't think that interface is
> C11.
> 
> Just my thoughts on the matter...

C11 does not provide a good interface for the Linux kernel, nor was it
intended to do so.  It might provide good implementations for some of
the atomic ops for some architectures.  This could reduce the amount of
assembly written for new architectures, and could potentially allow the
compiler to do a better job of optimizing (scary thought!).  But for this
to work, that architecture's Linux-kernel maintainer and gcc maintainer
would need to be working together.

							Thanx, Paul

