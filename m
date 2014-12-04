Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaLDUBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:01:01 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42307 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaLDUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:00:59 -0500
Date: Thu, 4 Dec 2014 12:00:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RFC] locking: Add volatile to arch_spinlock_t structures
Message-ID: <20141204200052.GY25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141204062005.GA2553@linux.vnet.ibm.com>
 <CA+55aFzn-6asfWHB8SAvz4GJWz7uEriujgVLfaqoo_VPtNBLuA@mail.gmail.com>
 <CA+55aFxGCxQNE4HzRP_Uk2FmFDn_+Hfm6GBz75S+5+SDeODVJQ@mail.gmail.com>
 <20141204070248.GJ25340@linux.vnet.ibm.com>
 <CA+55aFxDmaA2D37Zz1Zc7y6iD6gVs=wskP5wgJb37R98aN-qmg@mail.gmail.com>
 <20141204183628.GT25340@linux.vnet.ibm.com>
 <CA+55aFzPZdk5F2q7HjTnjFq673xpZGWUtkMZFx24q8RWQE0-dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzPZdk5F2q7HjTnjFq673xpZGWUtkMZFx24q8RWQE0-dg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120420-0009-0000-0000-000006DB2B47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 11:18:17AM -0800, Linus Torvalds wrote:
> On Thu, Dec 4, 2014 at 10:36 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > I have to ask...  Does this mean we can remove the current
> > restrictions against 8-bit and 16-bit access from smp_load_acquire()
> > and smp_store_release()?
> 
> I'd certainly be ok with it. Alpha doesn't have acquire/release
> semantics anyway (really, it's the worst memory ordering model
> *ever*), so those will end up being just plain (access-once) loads and
> stores, followed/preceded by a memory barrier anyway. So it arguably
> is no worse than the existing situation with ACCESS_ONCE() on alpha.
> 
> And quite frankly, I simply don't think that an old broken alpha
> architecture should be something we worry about. Remember: the byte
> and word ops were introduced in 21164, and released in 1996, so it's
> not even like "alpha has broken behavior". It's literally just "the
> very earliest alphas were broken", and I suspect most of those
> machines (at least running Linux) weren't even SMP (ie somebody may
> still have a Multia around for sentimental reasons, but SMP? No).
> 
> Of course, I'd like there to be a real reason to do so, not just "who
> cares about really old alphas, nyaah, nyaah, nyaah"? But if there is a
> clear case where a byte load-acquire and store-release would improve
> on something important, then yes, I think we should do it.
> 
> We dropped support for the original i386, we can drop support for old
> broken alphas. People running them for sentimental reasons might as
> well be sentimental about software too, and run old kernels ;)

Sad to say, I cannot argue that the places where I have hit this thus far
have been anything more than irritations, although they have sometimes
been quite irritating.  One is in rcutorture, but memory size is not a
concern there.  Another is in a field in a struct that also contains an
rcu_head structure, so shrinking it below an int doesn't actually save
any space.  A third one is a single global variable used to track sysidle
state, but it is just a single global variable that is not in TINY_RCU,
so who cares?  If I find some place where this is either increasing
the size of a data structure that can have lots of instances or where
it is preventing an explicit memory barrier from being pulled into an
smp_load_acquire() or smp_store_release(), I will revisit.

And it turns out that there really is a prohibition against clobbering
other-thread-accessible adjacent fields and variables in the C11 standard,
section 3.14p2:

	NOTE 1 Two threads of execution can update and access separate
	memory locations without interfering with each other.

In the C++11 standard, 1.7p3 has a similar prohibition, as Ville
Voutilainen pointed out in response to my email:

	Two or more threads of execution (1.10) can update and access
	separate memory locations without interfering with each other.

I would have expected this to be in 1.10 rather than 1.7, but as long
as it is in there somewhere.  ;-)

In both standards, "separate memory locations" mean "having no bytes
in common".  This confirms your intuition that concurrent access to
bitfields cannnot always be trusted.  Yes, if the two bitfields don't
have any bits living in the same byte, we can in theory have two threads
updating them conconcurrently, but that would be a pain to verify.

So any compiler that clobbers some adjacent non-bitfield variable or
field that is accessible by other threads is not just despicable, it
fails to conform to the standard.

Whew!  ;-)

							Thanx, Paul

