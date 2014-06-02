Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaFBJUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:20:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbaFBJUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:20:39 -0400
Date: Mon, 2 Jun 2014 05:19:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: John David Anglin <dave.anglin@bell.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chegu_vinod@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
In-Reply-To: <20140601213003.GG16155@laptop.programming.kicks-ass.net>
Message-ID: <alpine.LRH.2.02.1406020503000.17105@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <20140601192026.GE16155@laptop.programming.kicks-ass.net> <BLU0-SMTP387BD0AE22A4EAD432D65F97210@phx.gbl> <20140601213003.GG16155@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jun 2014, Peter Zijlstra wrote:

> On Sun, Jun 01, 2014 at 04:46:26PM -0400, John David Anglin wrote:
> > On 1-Jun-14, at 3:20 PM, Peter Zijlstra wrote:
> > 
> > >>If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg
> > >>at
> > >>the same time, you break it. ACCESS_ONCE doesn't take the hashed
> > >>spinlock,
> > >>so, in this case, cmpxchg or xchg isn't really atomic at all.
> > >
> > >And this is really the first place in the kernel that breaks like this?
> > >I've been using xchg() and cmpxchg() without such consideration for
> > >quite a while.
> > 
> > I believe Mikulas is correct.  Even in a controlled situation where a
> > cmpxchg operation
> > is used to implement pthread_spin_lock() in userspace, we found recently
> > that the lock
> > must be released with a  cmpxchg operation and not a simple write on SMP
> > systems.
> > There is a race in the cache operations or instruction ordering that's not
> > present with
> > the ldcw instruction.
> 
> Oh, I'm not arguing that. He's quite right that its broken, but this
> form of atomic ops is also quite insane and unusual. Most sane machines
> don't have this problem.
> 
> My main concern is how are we going to avoid breaking parisc (and I
> think sparc32, which is similarly retarded) in the future; we should
> invest in machinery to find and detect these things.

Grep the kernel for "\<xchg\>" and "\<cmpxchg\>" and replace them with 
atomic types and atomic access functions.

Mikulas
