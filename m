Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaEBTyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:54:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:6081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaEBTyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:54:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,974,1389772800"; 
   d="scan'208";a="533818757"
Subject: [PATCH v2] rwsem: Comments to explain the meaning of the rwsem's
 count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 May 2014 12:53:57 -0700
Message-ID: <1399060437.2970.146.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It takes me quite a while to understand how rwsem's count field mainifest
itself in different scenarios.  I'm adding comments to provide a quick
reference on the the rwsem's count field for each scenario where readers
and writers are contending for the lock.  Hopefully it will be useful
for future maintenance of the code and for people to get up to speed on
how the logic in the code works.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
Changes from v1 (https://lkml.org/lkml/2014/5/1/327)
 - Account for the scenarios where readers/writers are attempting lock.
 - Grammatical corrections.
 - Corrected value for the second case of 0xffff0001 count.

 kernel/locking/rwsem-xadd.c | 49 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 1d66e08..b4219ff 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -12,6 +12,55 @@
 #include <linux/export.h>
 
 /*
+ * Guide to the rw_semaphore's count field for common values.
+ * (32-bit case illustrated, similar for 64-bit)
+ *
+ * 0x0000000X	(1) X readers active or attempting lock, no writer waiting
+ *		    X = #active_readers + #readers attempting to lock
+ *		    (X*ACTIVE_BIAS)
+ *
+ * 0x00000000	rwsem is unlocked, and no one is waiting for the lock or
+ *		attempting to read lock or write lock.
+ *
+ * 0xffff000X	(1) X readers active or attempting lock, with waiters for lock
+ *		    X = #active readers + # readers attempting lock
+ *		    (X*ACTIVE_BIAS + WAITING_BIAS)
+ *		(2) 1 writer attempting lock, no waiters for lock
+ *		    X-1 = #active readers + #readers attempting lock
+ *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
+ *		(3) 1 writer active, no waiters for lock
+ *		    X-1 = #active readers + #readers attempting lock
+ *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
+ *
+ * 0xffff0001	(1) 1 reader active or attempting lock, waiters for lock
+ *		    (WAITING_BIAS + ACTIVE_BIAS)
+ *		(2) 1 writer active or attempting lock, no waiters for lock
+ *		    (ACTIVE_WRITE_BIAS)
+ *
+ * 0xffff0000	(1) There are writers or readers queued but none active
+ *		    or in the process of attempting lock.
+ *		    (WAITING_BIAS)
+ *		Note: writer can attempt to steal lock for this count by adding
+ *		ACTIVE_WRITE_BIAS in cmpxchg and checking the old count
+ *
+ * 0xfffe0001	(1) 1 writer active, or attempting lock. Waiters on queue.
+ *		    (ACTIVE_WRITE_BIAS + WAITING_BIAS)
+ *
+ * Note: Readers attempt to lock by adding ACTIVE_BIAS in down_read and checking
+ *	 the count becomes more than 0 for successful lock acquisition,
+ *	 i.e. the case where there are only readers or nobody has lock.
+ *	 (1st and 2nd case above).
+ *
+ *	 Writers attempt to lock by adding ACTIVE_WRITE_BIAS in down_write and
+ *	 checking the count becomes ACTIVE_WRITE_BIAS for successful lock
+ *	 acquisition (i.e. nobody else has lock or attempts lock).  If
+ *	 unsuccessful, in rwsem_down_write_failed, we'll check to see if there
+ *	 are only waiters but none active (5th case above), and attempt to
+ *	 steal the lock.
+ *
+ */
+
+/*
  * Initialize an rwsem:
  */
 void __init_rwsem(struct rw_semaphore *sem, const char *name,
-- 
1.7.11.7


