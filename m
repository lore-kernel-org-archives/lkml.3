Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaENTOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:14:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaENTOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:14:32 -0400
Date: Wed, 14 May 2014 21:13:40 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 03/19] qspinlock: Add pending bit
Message-ID: <20140514191339.GA22813@potion.brq.redhat.com>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-4-git-send-email-Waiman.Long@hp.com>
 <20140512152208.GA12309@potion.brq.redhat.com>
 <537276B4.10209@hp.com>
 <20140514165121.GA21370@potion.redhat.com>
 <20140514170016.GW30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140514170016.GW30445@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-14 19:00+0200, Peter Zijlstra:
> On Wed, May 14, 2014 at 06:51:24PM +0200, Radim Krčmář wrote:
> > Ok.
> > I've seen merit in pvqspinlock even with slightly slower first-waiter,
> > so I would have happily sacrificed those horrible branches.
> > (I prefer elegant to optimized code, but I can see why we want to be
> >  strictly better than ticketlock.)
> > Peter mentioned that we are focusing on bare-metal patches, so I'll
> > withold my other paravirt rants until they are polished.

(It was an ambiguous sentence, I have comments for later patches.)

> Well, paravirt must happen too, but comes later in this series, patch 3
> which we're replying to is still very much in the bare metal part of the
> series.

(I think that bare metal spans the first 7 patches.)

> I've not had time yet to decode all that Waiman has done to make
> paravirt work.
> 
> But as a general rule I like patches that start with something simple
> and working and then optimize it, this series doesn't seem to quite
> grasp that.
> 
> > And to forcefully bring this thread a little bit on-topic:
> > 
> > Pending-bit is effectively a lock in a lock, so I was wondering why
> > don't we use more pending bits; advantages are the same, just diminished
> > by the probability of having an ideally contended lock:
> >  - waiter won't be blocked on RAM access if critical section (or more)
> >    ends sooner
> >  - some unlucky cacheline is not forgotten
> >  - faster unlock (no need for tail operations)
> > (- ?)
> > disadvantages are magnified:
> >  - increased complexity
> >  - intense cacheline sharing
> >    (I thought that this is the main disadvantage of ticketlock.)
> > (- ?)
> > 
> > One bit still improved performance, is it the best we got?
> 
> So, the advantage of one bit is that if we use a whole byte for 1 bit we
> can avoid some atomic ops.
> 
> The entire reason for this in-word spinner is to amortize the cost of
> hitting the external node cacheline.

Every pending CPU removes one length of the critical section from the
delay caused by cacheline propagation and really cold cache is
hundreds(?) of cycles, so we could burn some to ensure correctness and
still be waiting when the first pending CPU unlocks.

> So traditional locks like test-and-test and the ticket lock only ever
> access the spinlock word itsef, this MCS style queueing lock has a
> second (and, see my other rants in this thread, when done wrong more
> than 2) cacheline to touch.
> 
> That said, all our benchmarking is pretty much for the cache-hot case,
> so I'm not entirely convinced yet that the one pending bit makes up for
> it, it does in the cache-hot case.

Yeah, we probably use the faster pre-lock quite a lot.
Cover letter states that queue depth 1-3 is a bit slower than ticket
spinlock, so we might not be losing if we implemented a faster
in-word-lock of this capacity.  (Not that I'm a fan of the hybrid lock.)

> But... writing cache-cold benchmarks is _hard_ :/

Wouldn't clflush of the second cacheline before trying for the lock give
us a rough estimate?
