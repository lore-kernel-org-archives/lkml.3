Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaFAVaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 17:30:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaFAVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 17:30:38 -0400
Date: Sun, 1 Jun 2014 23:30:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John David Anglin <dave.anglin@bell.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chegu_vinod@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
Message-ID: <20140601213003.GG16155@laptop.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <20140601192026.GE16155@laptop.programming.kicks-ass.net>
 <BLU0-SMTP387BD0AE22A4EAD432D65F97210@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP387BD0AE22A4EAD432D65F97210@phx.gbl>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 04:46:26PM -0400, John David Anglin wrote:
> On 1-Jun-14, at 3:20 PM, Peter Zijlstra wrote:
> 
> >>If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg
> >>at
> >>the same time, you break it. ACCESS_ONCE doesn't take the hashed
> >>spinlock,
> >>so, in this case, cmpxchg or xchg isn't really atomic at all.
> >
> >And this is really the first place in the kernel that breaks like this?
> >I've been using xchg() and cmpxchg() without such consideration for
> >quite a while.
> 
> I believe Mikulas is correct.  Even in a controlled situation where a
> cmpxchg operation
> is used to implement pthread_spin_lock() in userspace, we found recently
> that the lock
> must be released with a  cmpxchg operation and not a simple write on SMP
> systems.
> There is a race in the cache operations or instruction ordering that's not
> present with
> the ldcw instruction.

Oh, I'm not arguing that. He's quite right that its broken, but this
form of atomic ops is also quite insane and unusual. Most sane machines
don't have this problem.

My main concern is how are we going to avoid breaking parisc (and I
think sparc32, which is similarly retarded) in the future; we should
invest in machinery to find and detect these things.

