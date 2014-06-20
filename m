Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaFTRkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:40:49 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:41555 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaFTRks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:40:48 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2] lockdep: restrict the use of recursive read_lock with qrwlock
Date: Fri, 20 Jun 2014 13:40:27 -0400
Message-Id: <1403286027-34328-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
 - Use less conditional & make it easier to read

Unlike the original unfair rwlock implementation, queued rwlock
will grant lock according to the chronological sequence of the lock
requests except when the lock requester is in the interrupt context.
As a result, recursive read_lock calls will hang the process if there
is a write_lock call somewhere in between the read_lock calls.

This patch updates the lockdep implementation to look for recursive
read_lock calls when queued rwlock is being used.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/lockdep.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e433..a430286 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -67,6 +67,16 @@ module_param(lock_stat, int, 0644);
 #define lock_stat 0
 #endif
 
+#ifdef CONFIG_QUEUE_RWLOCK
+/*
+* Queue rwlock only allows read-after-read recursion of the same lock class
+* when the latter read is in an interrupt context.
+*/
+#define allow_recursive_read	in_interrupt()
+#else
+#define allow_recursive_read	true
+#endif
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -1770,7 +1780,7 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
 		 * Allow read-after-read recursion of the same
 		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
 		 */
-		if ((read == 2) && prev->read)
+		if ((read == 2) && prev->read && allow_recursive_read)
 			return 2;
 
 		/*
@@ -1852,7 +1862,7 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * write-lock never takes any other locks, then the reads are
 	 * equivalent to a NOP.
 	 */
-	if (next->read == 2 || prev->read == 2)
+	if ((next->read == 2 || prev->read == 2) && allow_recursive_read)
 		return 1;
 	/*
 	 * Is the <prev> -> <next> dependency already present?
-- 
1.7.1

