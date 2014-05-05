Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaEEIsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:48:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbaEEIsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:48:16 -0400
Date: Mon, 5 May 2014 01:46:25 -0700
From: tip-bot for Tim Chen <tipbot@zytor.com>
Message-ID: <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        peter@hurleysoftware.com, paulmck@linux.vnet.ibm.com,
        alex.shi@linaro.org, riel@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, davidlohr@hp.com, walken@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com,
        jason.low2@hp.com, riel@redhat.com, alex.shi@linaro.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, walken@google.com, davidlohr@hp.com
In-Reply-To: <1399060437.2970.146.camel@schen9-DESK>
References: <1399060437.2970.146.camel@schen9-DESK>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] rwsem:
  Add comments to explain the meaning of the rwsem's count field
Git-Commit-ID: 3cf2f34e1a3d4d5ff209d087925cf950e52f4805
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cf2f34e1a3d4d5ff209d087925cf950e52f4805
Gitweb:     http://git.kernel.org/tip/3cf2f34e1a3d4d5ff209d087925cf950e52f4805
Author:     Tim Chen <tim.c.chen@linux.intel.com>
AuthorDate: Fri, 2 May 2014 12:53:57 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 4 May 2014 20:34:26 +0200

rwsem: Add comments to explain the meaning of the rwsem's count field

It took me quite a while to understand how rwsem's count field
mainifested itself in different scenarios.

Add comments to provide a quick reference to the the rwsem's count
field for each scenario where readers and writers are contending
for the lock.

Hopefully it will be useful for future maintenance of the code and
for people to get up to speed on how the logic in the code works.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Paul E.McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1399060437.2970.146.camel@schen9-DESK
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
