Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaGGTA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:00:58 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:3289 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaGGTA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:00:56 -0400
From: Jason Low <jason.low2@hp.com>
To: peterz@infradead.org, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, Waiman.Long@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, riel@redhat.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, hpa@zytor.com, tim.c.chen@linux.intel.com,
        konrad.wilk@oracle.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, jason.low2@hp.com
Subject: [PATCH 4/4] rwsem: Reduce the size of struct rw_semaphore
Date: Mon,  7 Jul 2014 11:50:19 -0700
Message-Id: <1404759019-4268-5-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
References: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
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
 include/linux/rwsem.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 9fdcdd0..f6c54c0 100644
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
@@ -66,10 +66,10 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 #if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
-	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
 	  LIST_HEAD_INIT((name).wait_list),		\
+	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
+	  { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }, /* osq */	\
 	  NULL, /* owner */				\
-	  { ATOMIC_INIT(OSQ_UNLOCKED_VAL) } /* osq */   \
 	  __RWSEM_DEP_MAP_INIT(name) }
 #else
 #define __RWSEM_INITIALIZER(name)			\
-- 
1.7.1

