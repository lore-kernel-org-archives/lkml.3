Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaFBKfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:35:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaFBKfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:35:03 -0400
Date: Mon, 2 Jun 2014 06:34:03 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chegu_vinod@hp.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
In-Reply-To: <20140601192026.GE16155@laptop.programming.kicks-ass.net>
Message-ID: <alpine.LRH.2.02.1406020622130.17105@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <20140601192026.GE16155@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jun 2014, Peter Zijlstra wrote:

> On Sun, Jun 01, 2014 at 01:53:11PM -0400, Mikulas Patocka wrote:
> > PA-RISC doesn't have xchg or cmpxchg atomic instructions like other
> > processors. It only has ldcw and ldcd instructions that load a word (or
> > doubleword) from memory and atomically store zero at the same location.
> > These instructions can only be used to implement spinlocks, direct
> > implementation of other atomic operations is impossible.
> > 
> > Consequently, Linux xchg and cmpxchg functions are implemented in such a
> > way that they hash the address, use the hash to index a spinlock, take the
> > spinlock, perform the xchg or cmpxchg operation non-atomically and drop
> > the spinlock.
> > 
> > If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg at
> > the same time, you break it. ACCESS_ONCE doesn't take the hashed spinlock,
> > so, in this case, cmpxchg or xchg isn't really atomic at all.
> 
> And this is really the first place in the kernel that breaks like this?
> I've been using xchg() and cmpxchg() without such consideration for
> quite a while.

It happens on a common mutex operation and it took an hour of 
stress-testing to trigger it.

The other cases may be buggy too, but no one has written a stress test 
specifically tailored for them.

> Doesn't sparc32 have similarly broken atomic ops?

Yes. tile32, arc and metag seem to be broken by this too. hexagon also has 
non-standard atomic_set, so it may be broken too.

> Ideally, if we really want to preserve such broken-ness, we'd add some
> debugging infrastructure to detect such nonsense.
> 
> > This patch fixes the bug by introducing a new type atomic_pointer_t 
> > (backed by atomic_long_t) and replacing the offending pointer with it. 
> > atomic_long_set takes the hashed spinlock, so it avoids the race 
> > condition.
> 
> So I hate that twice, once since xchg() and cmpxchg() do not share the
> atomic_ prefix, its inappropriate and misleading here, and secondly,
> non of this is specific to pointers, xchg() and cmpxchg() take any
> (naturally aligned) 'native' size type.

I think we don't need xchg() and cmpxchg() at all, because we have atomic 
types.

Mikulas
