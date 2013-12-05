Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3LEG5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 01:57:37 -0500
Received: from peace.netnation.com ([204.174.223.2]:34917 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3LEG5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 01:57:34 -0500
Date: Wed, 4 Dec 2013 22:57:31 -0800
From: Simon Kirby <sim@hostway.ca>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mutexes: Add CONFIG_DEBUG_MUTEX_FASTPATH=y debug variant
 to debug SMP races
Message-ID: <20131205065731.GA29736@hostway.ca>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
 <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
 <20131203085233.GA20179@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203085233.GA20179@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 09:52:33AM +0100, Ingo Molnar wrote:

> Indeed: this comes from mutex->count being separate from 
> mutex->wait_lock, and this should affect every architecture that has a 
> mutex->count fast-path implemented (essentially every architecture 
> that matters).
> 
> Such bugs should also magically go away with mutex debugging enabled.

Confirmed: I ran the reproducer with CONFIG_DEBUG_MUTEXES for a few
hours, and never got a single poison overwritten notice.

> I'd expect such bugs to be more prominent with unlucky object 
> size/alignment: if mutex->count lies on a separate cache line from 
> mutex->wait_lock.
> 
> Side note: this might be a valid light weight debugging technique, we 
> could add padding between the two fields to force them into separate 
> cache lines, without slowing it down.
> 
> Simon, would you be willing to try the fairly trivial patch below? 
> Please enable CONFIG_DEBUG_MUTEX_FASTPATH=y. Does your kernel fail 
> faster that way?

I didn't see much of a change other than the incremented poison byte is
now further in due to the padding, and it shows up in kmalloc-256.

I also tried with Linus' udelay() suggestion, below. With this, there
were many occurrences per second.

Simon-

diff --git a/kernel/mutex.c b/kernel/mutex.c
index d24105b..f65e735 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -25,6 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
+#include <linux/delay.h>
 
 /*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,
@@ -740,6 +741,11 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 		wake_up_process(waiter->task);
 	}
 
+	/* udelay a bit if the spinlock isn't contended */
+	if (lock->wait_lock.rlock.raw_lock.tickets.head + 1 ==
+	    lock->wait_lock.rlock.raw_lock.tickets.tail)
+		udelay(1);
+
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
 
