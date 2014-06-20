Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835AbaFTQW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:22:56 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:57718 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934758AbaFTQWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:22:55 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH] lockdep: restrict the use of recursive read_lock with qrwlock
Date: Fri, 20 Jun 2014 12:22:43 -0400
Message-Id: <1403281363-33403-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the original unfair rwlock implementation, queued rwlock
will grant lock according to the chronological sequence of the lock
requests except when the lock requester is in the interrupt context.
As a result, recursive read_lock calls will hang the process if there
is a write_lock call somewhere in between the read_lock calls.

This patch updates the lockdep implementation to look for recursive
read_lock calls when queued rwlock is being used.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/lockdep.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e433..b6c9f2e 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1766,12 +1766,22 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
 		if (hlock_class(prev) != hlock_class(next))
 			continue;
 
+#ifdef CONFIG_QUEUE_RWLOCK
+		/*
+		 * Queue rwlock only allows read-after-read recursion of the
+		 * same lock class when the latter read is in an interrupt
+		 * context.
+		 */
+		if ((read == 2) && prev->read && in_interrupt())
+			return 2;
+#else
 		/*
 		 * Allow read-after-read recursion of the same
 		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
 		 */
 		if ((read == 2) && prev->read)
 			return 2;
+#endif
 
 		/*
 		 * We're holding the nest_lock, which serializes this lock's
@@ -1852,8 +1862,10 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * write-lock never takes any other locks, then the reads are
 	 * equivalent to a NOP.
 	 */
+#ifndef CONFIG_QUEUE_RWLOCK
 	if (next->read == 2 || prev->read == 2)
 		return 1;
+#endif
 	/*
 	 * Is the <prev> -> <next> dependency already present?
 	 *
-- 
1.7.1

