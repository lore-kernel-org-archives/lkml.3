Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaGNR3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:29:08 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:58965 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbaGNR27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:28:59 -0400
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <waiman.long@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott Norton <scott.norton@hp.com>, Dave Chinner <david@fromorbit.com>,
        Jason Low <jason.low2@hp.com>
Subject: [PATCH v2 5/5] rwsem: Reduce the size of struct rw_semaphore
Date: Mon, 14 Jul 2014 10:27:52 -0700
Message-Id: <1405358872-3732-6-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405358872-3732-1-git-send-email-jason.low2@hp.com>
References: <1405358872-3732-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent optimistic spinning additions to rwsem provide significant performance
benefits on many workloads on large machines. The cost of it was increasing
the size of the rwsem structure by up to 128 bits.

However, now that the previous patches in this series bring the overhead of
struct optimistic_spin_queue to 32 bits, this patch reorders some fields in
struct rw_semaphore such that we can reduce the overhead of the rwsem structure
by 64 bits (on 64 bit systems).

The extra overhead required for rwsem optimistic spinning would now be up
to 8 additional bytes instead of up to 16 bytes. Additionally, the size of
rwsem would now be more in line with mutexes.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 include/linux/rwsem.h |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 25cd9aa..716807f 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -24,15 +24,15 @@ struct rw_semaphore;
 /* All arch specific implementations share the same struct */
 struct rw_semaphore {
 	long count;
-	raw_spinlock_t wait_lock;
 	struct list_head wait_list;
+	raw_spinlock_t wait_lock;
 #ifdef CONFIG_SMP
+	struct optimistic_spin_queue osq; /* spinner MCS lock */
 	/*
 	 * Write owner. Used as a speculative check to see
 	 * if the owner is running on the cpu.
 	 */
 	struct task_struct *owner;
-	struct optimistic_spin_queue osq; /* spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -64,21 +64,18 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 #endif
 
 #if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
-#define __RWSEM_INITIALIZER(name)			\
-	{ RWSEM_UNLOCKED_VALUE,				\
-	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
-	  LIST_HEAD_INIT((name).wait_list),		\
-	  NULL, /* owner */				\
-	  OSQ_LOCK_UNLOCKED /* osq */			\
-	  __RWSEM_DEP_MAP_INIT(name) }
+#define __RWSEM_OPT_INIT(lockname) , .osq = OSQ_LOCK_UNLOCKED, .owner = NULL
 #else
-#define __RWSEM_INITIALIZER(name)			\
-	{ RWSEM_UNLOCKED_VALUE,				\
-	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
-	  LIST_HEAD_INIT((name).wait_list)		\
-	  __RWSEM_DEP_MAP_INIT(name) }
+#define __RWSEM_OPT_INIT(lockname)
 #endif
 
+#define __RWSEM_INITIALIZER(name)				\
+	{ .count = RWSEM_UNLOCKED_VALUE,			\
+	  .wait_list = LIST_HEAD_INIT((name).wait_list),	\
+	  .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock)	\
+	  __RWSEM_OPT_INIT(name)				\
+	  __RWSEM_DEP_MAP_INIT(name) }
+
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
 
-- 
1.7.1

