Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3LEIG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:06:57 -0500
Received: from peace.netnation.com ([204.174.223.2]:34930 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3LEIGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:06:54 -0500
Date: Thu, 5 Dec 2013 00:06:51 -0800
From: Simon Kirby <sim@hostway.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mutexes: Add CONFIG_DEBUG_MUTEX_FASTPATH=y debug variant
 to debug SMP races
Message-ID: <20131205080650.GB29736@hostway.ca>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
 <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
 <20131203085233.GA20179@gmail.com>
 <CA+55aFxhUYi6Lbrxfjgq7OqSDMF24wqvnGn_J_RAMY7y-AmRiQ@mail.gmail.com>
 <20131204091903.GA18675@hostway.ca>
 <CA+55aFwDaeYav1WGpmoHH4tTZ5xTWjkEO-46RvLb6DRYD_BnSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwDaeYav1WGpmoHH4tTZ5xTWjkEO-46RvLb6DRYD_BnSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 01:14:56PM -0800, Linus Torvalds wrote:

> The lock we're moving up isn't the lock that actually protects the
> whole allocation logic (it's the lock that then protects the pipe
> contents when a pipe is *used*). So it's a useless lock, and moving it
> up is a good idea regardless (because it makes the locks only protect
> the parts they are actually *supposed* to protect.
> 
> And while extraneous lock wouldn't normally hurt, the sleeping locks
> (both mutexes and semaphores) aren't actually safe wrt de-allocation -
> they protect anything *inside* the lock, but the lock data structure
> itself is accessed racily wrt other lockers (in a way that still
> leaves the locked region protected, but not the lock itself). If you
> care about details, you can walk through my example.

Yes, this makes sense now. It was spin_unlock_mutex() on the pipe lock
that itself was already already freed and poisoned by another cpu. This
explicit poison check also fires:

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index bf156de..ae425d0 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -159,6 +159,7 @@ static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 			__ticket_unlock_slowpath(lock, prev);
 	} else
 		__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
+	WARN_ON(*(unsigned int *)&lock->tickets.head == 0x6b6b6b6c);
 }
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)

It warns only as often as the poison checking already did, with a stack
of warn_*, __mutex_unlock_slowpath(), mutex_unlock(), pipe_release().

Trying to prove a negative, of course, but I tested with your first fix
overnight and got no errors. Current git (with b0d8d2292160bb63de) also
looks good. I will leave it running for a few days.

Thanks for getting stuck on this one. It was educational, at least!

Simon-
