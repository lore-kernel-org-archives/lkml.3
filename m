Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaLDSCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:02:17 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:41346 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaLDSCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <20141204070248.GJ25340@linux.vnet.ibm.com>
References: <20141204062005.GA2553@linux.vnet.ibm.com>
	<CA+55aFzn-6asfWHB8SAvz4GJWz7uEriujgVLfaqoo_VPtNBLuA@mail.gmail.com>
	<CA+55aFxGCxQNE4HzRP_Uk2FmFDn_+Hfm6GBz75S+5+SDeODVJQ@mail.gmail.com>
	<20141204070248.GJ25340@linux.vnet.ibm.com>
Date: Thu, 4 Dec 2014 10:02:14 -0800
X-Google-Sender-Auth: t9ztH_lSFbE4o6kFOnQMqSmZBMs
Message-ID: <CA+55aFxDmaA2D37Zz1Zc7y6iD6gVs=wskP5wgJb37R98aN-qmg@mail.gmail.com>
Subject: Re: [PATCH RFC] locking: Add volatile to arch_spinlock_t structures
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 11:02 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Dec 03, 2014 at 10:40:45PM -0800, Linus Torvalds wrote:
>> On Dec 3, 2014 10:31 PM, "Linus Torvalds" <torvalds@linux-foundation.org>
>> wrote:
>> >
>> > So no, no, no. C got this wrong. Volatile data structures are a
>> fundamental mistake and a bug.
>>
>> BTW, I'm not at all interested in language lawyering and people who say
>> "but but we can do x". A compiler that modifies adjacent fields because the
>> standard leaves is open is a crap compiler, and we won't use it, or disable
>> the broken optimization. It is wrong from a concurrency standpoint anyway,
>> and adding broken volatiles is just making things worse.
>
> Understood, for example, adjacent fields protected by different locks
> as one example, where adjacent-field overwriting completely breaks even
> very conservatively designed code.

Exactly. Compilers that "optimize" things to touch fields that aren't
touched by the source code are simply inherently buggy shit. I'm not
at all interested in catering to their insanity.

It doesn't matter one whit if they can point to the legacy C "virtual
machine" definition and say that those accesses are invisible in the
virtual machine. They are not invisible in real life, and it is
entirely possible that two adjacent variables or fields are protected
by different locks - even in non-kernel code. Claiming that they need
to be marked volatile is a symptom of a diseased compiler writer.

Now, the one exception to this is generally bitfields, because there
the programmer knowingly and intentionally puts the fields together in
the same storage unit. I also think that volatile bitfields are an
insane concept, even if I think that the standard allows them. So I am
not saying that compilers should try to magically make bitfield
members not access the members around them.

I also accept that some architectures are broken. Old
non-byte/word-access alpha being the really canonical example. It's
not the compilers fault if the architecture is broken, and the
compiler cannot magically fix it.

But compilers that think that "hey, vectorization is cool, and I can
do load-stores and mask things dynamically" are misguided crap. It may
be fancy, it may be really cool compiler technology, but it's
fundamentally wrong unless the programmer told it was safe some way
(be it with a "pragma" or "restrict" or a compile-time switch or
whatever).

                            Linus
