Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab3KYU6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:58:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:57360 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3KYU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:58:13 -0500
Message-Id: <20131125203525.782112098@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 20:58:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC patch 2/5] futex: Document ordering guarantees
References: <20131125203358.156292370@linutronix.de>
Content-Disposition: inline; filename=futex-document-serialization.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's essential, if you want to hack on futexes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -68,6 +68,63 @@
 
 #include "locking/rtmutex_common.h"
 
+/*
+ * Basic futex operation and ordering guarantees:
+ *
+ * The waiter reads the futex value in user space and calls
+ * futex_wait(). It computes the hash bucket and acquires the hash
+ * bucket lock. After that it reads the futex user space value again
+ * and verifies that the data has not changed. If it has not changed
+ * it enqueues itself into the hash bucket, releases the hash
+ * bucket lock and schedules.
+ *
+ * The waker side modifies the user space value of the futex and calls
+ * futex_wake(). It computes the hash bucket and acquires the hash
+ * bucket lock. Then it looks for waiters on that futex in the hash
+ * bucket and wakes them.
+ *
+ * Note, that the spin_lock serializes waiters and wakers, so that the
+ * following scenario is avoided:
+ *
+ * CPU 0				CPU 1
+ * val = *futex;
+ * sys_futex(WAIT, futex, val);
+ *   futex_wait(futex, val);
+ *   uval = *futex;
+ *					*futex = newval;
+ *					sys_futex(WAKE, futex);
+ *					  futex_wake(futex);
+ *					  if (queue_empty())
+ *					    return;
+ *   if (uval == val)
+ *      lock(hash_bucket(futex));
+ *      queue();
+ *	unlock(hash_bucket(futex));
+ *	schedule();
+ *
+ * This would cause the waiter on CPU 0 to wait forever because it
+ * missed the transition of the user space value from val to newval
+ * and the waker did not find the waiter in the hash bucket queue.
+ * The spinlock serializes that:
+ *
+ * CPU 0				CPU 1
+ * val = *futex;
+ * sys_futex(WAIT, futex, val);
+ *   futex_wait(futex, val);
+ *   lock(hash_bucket(futex));
+ *   uval = *futex;
+ *					*futex = newval;
+ *					sys_futex(WAKE, futex);
+ *					  futex_wake(futex);
+ *					  lock(hash_bucket(futex));
+ *   if (uval == val)
+ *      queue();
+ *	unlock(hash_bucket(futex));
+ *	schedule();			  if (!queue_empty())
+ *					    wake_waiters(futex);
+ *					  unlock(hash_bucket(futex));
+ */
+
 int __read_mostly futex_cmpxchg_enabled;
 
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)


