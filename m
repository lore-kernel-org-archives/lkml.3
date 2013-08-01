Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3HAAb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:31:59 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61128 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3HAAbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:31:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 03/23] vtime: Update a few comments
Date: Thu,  1 Aug 2013 02:31:20 +0200
Message-Id: <1375317100-20651-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update a stale comment from the old vtime era and document some
locking that might be non obvious.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
---
 include/linux/context_tracking.h |   10 ++++------
 kernel/sched/cputime.c           |    7 +++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 5984f25..d883ff0 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -72,8 +72,9 @@ extern void guest_exit(void);
 static inline void guest_enter(void)
 {
 	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
+	 * This is running in ioctl context so its safe
+	 * to assume that it's the stime pending cputime
+	 * to flush.
 	 */
 	vtime_account_system(current);
 	current->flags |= PF_VCPU;
@@ -81,10 +82,7 @@ static inline void guest_enter(void)
 
 static inline void guest_exit(void)
 {
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
+	/* Flush the guest cputime we spent on the guest */
 	vtime_account_system(current);
 	current->flags &= ~PF_VCPU;
 }
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a7959e0..223a35e 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -712,6 +712,13 @@ void vtime_user_enter(struct task_struct *tsk)
 
 void vtime_guest_enter(struct task_struct *tsk)
 {
+	/*
+	 * The flags must be updated under the lock with
+	 * the vtime_snap flush and update.
+	 * That enforces a right ordering and update sequence
+	 * synchronization against the reader (task_gtime())
+	 * that can thus safely catch up with a tickless delta.
+	 */
 	write_seqlock(&tsk->vtime_seqlock);
 	__vtime_account_system(tsk);
 	current->flags |= PF_VCPU;
-- 
1.7.5.4

