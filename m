Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3LSSqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:46:42 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:11330 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3LSSqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:46:08 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com, davidlohr@hp.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v3 3/4] futex: Document ordering guarantees
Date: Thu, 19 Dec 2013 10:45:45 -0800
Message-Id: <1387478746-5436-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

That's essential, if you want to hack on futexes.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Jason Low <jason.low2@hp.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 577481d..af1fc31 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -69,6 +69,63 @@
 
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
+ * Note that the spin_lock serializes waiters and wakers, so that the
+ * following scenario is avoided:
+ *
+ * CPU 0                               CPU 1
+ * val = *futex;
+ * sys_futex(WAIT, futex, val);
+ *   futex_wait(futex, val);
+ *   uval = *futex;
+ *                                     *futex = newval;
+ *                                     sys_futex(WAKE, futex);
+ *                                       futex_wake(futex);
+ *                                       if (queue_empty())
+ *                                         return;
+ *   if (uval == val)
+ *      lock(hash_bucket(futex));
+ *      queue();
+ *     unlock(hash_bucket(futex));
+ *     schedule();
+ *
+ * This would cause the waiter on CPU 0 to wait forever because it
+ * missed the transition of the user space value from val to newval
+ * and the waker did not find the waiter in the hash bucket queue.
+ * The spinlock serializes that:
+ *
+ * CPU 0                               CPU 1
+ * val = *futex;
+ * sys_futex(WAIT, futex, val);
+ *   futex_wait(futex, val);
+ *   lock(hash_bucket(futex));
+ *   uval = *futex;
+ *                                     *futex = newval;
+ *                                     sys_futex(WAKE, futex);
+ *                                       futex_wake(futex);
+ *                                       lock(hash_bucket(futex));
+ *   if (uval == val)
+ *      queue();
+ *     unlock(hash_bucket(futex));
+ *     schedule();                       if (!queue_empty())
+ *                                         wake_waiters(futex);
+ *                                       unlock(hash_bucket(futex));
+ */
+
 int __read_mostly futex_cmpxchg_enabled;
 
 /*
-- 
1.8.1.4

