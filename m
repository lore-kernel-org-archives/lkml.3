Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaAMPxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:53:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaAMPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:53:37 -0500
Date: Mon, 13 Jan 2014 07:52:49 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-99b60ce69734dfeda58c6184a326b9475ce1dba3@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, efault@gmx.de,
        peterz@infradead.org, rdunlap@infradead.org, jason.low2@hp.com,
        Waiman.Long@hp.com, akpm@linux-foundation.org, tglx@linutronix.de,
        scott.norton@hp.com, davidlohr@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, dvhart@linux.intel.com, paulmck@linux.vnet.ibm.com,
        tom.vaden@hp.com, jeffm@suse.com, aswin@hp.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, efault@gmx.de, rdunlap@infradead.org,
        jason.low2@hp.com, Waiman.Long@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, davidlohr@hp.com, scott.norton@hp.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, dvhart@linux.intel.com,
        paulmck@linux.vnet.ibm.com, tom.vaden@hp.com, jeffm@suse.com,
        aswin@hp.com
In-Reply-To: <1389569486-25487-4-git-send-email-davidlohr@hp.com>
References: <1389569486-25487-4-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futexes:
  Document multiprocessor ordering guarantees
Git-Commit-ID: 99b60ce69734dfeda58c6184a326b9475ce1dba3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:52:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99b60ce69734dfeda58c6184a326b9475ce1dba3
Gitweb:     http://git.kernel.org/tip/99b60ce69734dfeda58c6184a326b9475ce1dba3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 12 Jan 2014 15:31:24 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 11:45:19 +0100

futexes: Document multiprocessor ordering guarantees

That's essential, if you want to hack on futexes.

Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1389569486-25487-4-git-send-email-davidlohr@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/futex.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 577481d..fcc6850 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -69,6 +69,63 @@
 
 #include "locking/rtmutex_common.h"
 
+/*
+ * Basic futex operation and ordering guarantees:
+ *
+ * The waiter reads the futex value in user space and calls
+ * futex_wait(). This function computes the hash bucket and acquires
+ * the hash bucket lock. After that it reads the futex user space value
+ * again and verifies that the data has not changed. If it has not
+ * changed it enqueues itself into the hash bucket, releases the hash
+ * bucket lock and schedules.
+ *
+ * The waker side modifies the user space value of the futex and calls
+ * futex_wake(). This functions computes the hash bucket and acquires
+ * the hash bucket lock. Then it looks for waiters on that futex in the
+ * hash bucket and wakes them.
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
