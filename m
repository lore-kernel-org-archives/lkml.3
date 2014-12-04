Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbaLDSgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:36:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33619 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaLDSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:36:37 -0500
Date: Thu, 4 Dec 2014 10:36:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RFC] locking: Add volatile to arch_spinlock_t structures
Message-ID: <20141204183628.GT25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141204062005.GA2553@linux.vnet.ibm.com>
 <CA+55aFzn-6asfWHB8SAvz4GJWz7uEriujgVLfaqoo_VPtNBLuA@mail.gmail.com>
 <CA+55aFxGCxQNE4HzRP_Uk2FmFDn_+Hfm6GBz75S+5+SDeODVJQ@mail.gmail.com>
 <20141204070248.GJ25340@linux.vnet.ibm.com>
 <CA+55aFxDmaA2D37Zz1Zc7y6iD6gVs=wskP5wgJb37R98aN-qmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxDmaA2D37Zz1Zc7y6iD6gVs=wskP5wgJb37R98aN-qmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120418-0013-0000-0000-000006C49F7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:02:14AM -0800, Linus Torvalds wrote:
> On Wed, Dec 3, 2014 at 11:02 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Dec 03, 2014 at 10:40:45PM -0800, Linus Torvalds wrote:
> >> On Dec 3, 2014 10:31 PM, "Linus Torvalds" <torvalds@linux-foundation.org>
> >> wrote:
> >> >
> >> > So no, no, no. C got this wrong. Volatile data structures are a
> >> fundamental mistake and a bug.
> >>
> >> BTW, I'm not at all interested in language lawyering and people who say
> >> "but but we can do x". A compiler that modifies adjacent fields because the
> >> standard leaves is open is a crap compiler, and we won't use it, or disable
> >> the broken optimization. It is wrong from a concurrency standpoint anyway,
> >> and adding broken volatiles is just making things worse.
> >
> > Understood, for example, adjacent fields protected by different locks
> > as one example, where adjacent-field overwriting completely breaks even
> > very conservatively designed code.
> 
> Exactly. Compilers that "optimize" things to touch fields that aren't
> touched by the source code are simply inherently buggy shit. I'm not
> at all interested in catering to their insanity.
> 
> It doesn't matter one whit if they can point to the legacy C "virtual
> machine" definition and say that those accesses are invisible in the
> virtual machine. They are not invisible in real life, and it is
> entirely possible that two adjacent variables or fields are protected
> by different locks - even in non-kernel code. Claiming that they need
> to be marked volatile is a symptom of a diseased compiler writer.
> 
> Now, the one exception to this is generally bitfields, because there
> the programmer knowingly and intentionally puts the fields together in
> the same storage unit. I also think that volatile bitfields are an
> insane concept, even if I think that the standard allows them. So I am
> not saying that compilers should try to magically make bitfield
> members not access the members around them.
> 
> I also accept that some architectures are broken. Old
> non-byte/word-access alpha being the really canonical example. It's
> not the compilers fault if the architecture is broken, and the
> compiler cannot magically fix it.

I have to ask...  Does this mean we can remove the current
restrictions against 8-bit and 16-bit access from smp_load_acquire()
and smp_store_release()?

> But compilers that think that "hey, vectorization is cool, and I can
> do load-stores and mask things dynamically" are misguided crap. It may
> be fancy, it may be really cool compiler technology, but it's
> fundamentally wrong unless the programmer told it was safe some way
> (be it with a "pragma" or "restrict" or a compile-time switch or
> whatever).

You might be happy to hear that I just sent an email to the C++ standards
committee noting that valid C11 compilers are not supposed to be able to
introduce data races [1].  I further argued that any store-widening access
affecting any non-private adjacent variable must be assumed to (illegally
per the C11 standard) introduce a data race, even if there are no locks,
atomic accesses, transactions, or any other synchronization mechanism
anywhere in that translation unit.  After all, any non-static function
in that translation unit might be called from some other translation
unit that -did- use locking or whatever.

I will let you know how it goes.  ;-)

							Thanx, Paul

[1]	A "data race" occurs in any C11 program where multiple threads
	might be accessing a non-atomic variable, and where at least
	one of the accesses is a write.  C11 states that data races
	result in undefined behavior.  Therefore, if the source code
	does not contain a data race, the object code had also better
	be free of data races.  Otherwise, the compiler inflicted
	undefined behavior on a perfectly legitimate program.

