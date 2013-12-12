Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3LLBKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:10:39 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60311 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3LLBJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:09:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/3] sched/core: convert completions to use simple wait queues
Date: Wed, 11 Dec 2013 20:06:38 -0500
Message-ID: <1386810399-8973-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Completions have no long lasting callbacks and therefore do not need
the complex waitqueue variant.  Use simple waitqueues which reduces
the contention on the waitqueue lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[PG: carry forward from v3.10-rt, drop RT specific chunks, align with
 names that were chosen to match normal waitqueue support.]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/completion.h |  8 ++++----
 include/linux/uprobes.h    |  1 +
 kernel/sched/completion.c  | 34 +++++++++++++++++-----------------
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 5d5aaae..d8e6db9 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -8,7 +8,7 @@
  * See kernel/sched/completion.c for details.
  */
 
-#include <linux/wait.h>
+#include <linux/swait.h>
 
 /*
  * struct completion - structure used to maintain state for a "completion"
@@ -24,11 +24,11 @@
  */
 struct completion {
 	unsigned int done;
-	wait_queue_head_t wait;
+	swait_queue_head_t wait;
 };
 
 #define COMPLETION_INITIALIZER(work) \
-	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
+	{ 0, SWAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
 
 #define COMPLETION_INITIALIZER_ONSTACK(work) \
 	({ init_completion(&work); work; })
@@ -73,7 +73,7 @@ struct completion {
 static inline void init_completion(struct completion *x)
 {
 	x->done = 0;
-	init_waitqueue_head(&x->wait);
+	init_swaitqueue_head(&x->wait);
 }
 
 /**
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 319eae7..e3a167f 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -26,6 +26,7 @@
 
 #include <linux/errno.h>
 #include <linux/rbtree.h>
+#include <linux/wait.h>
 
 struct vm_area_struct;
 struct mm_struct;
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index a63f4dc..bcdd609 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -30,10 +30,10 @@ void complete(struct completion *x)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
-	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	__swake_up_locked(&x->wait, TASK_NORMAL, 1);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
 
@@ -50,10 +50,10 @@ void complete_all(struct completion *x)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
-	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	__swake_up_locked(&x->wait, TASK_NORMAL, 0);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
 
@@ -62,20 +62,20 @@ do_wait_for_common(struct completion *x,
 		   long (*action)(long), long timeout, int state)
 {
 	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
+		DEFINE_SWAITER(wait);
 
-		__add_wait_queue_tail_exclusive(&x->wait, &wait);
+		swait_prepare_locked(&x->wait, &wait);
 		do {
 			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
 				break;
 			}
 			__set_current_state(state);
-			spin_unlock_irq(&x->wait.lock);
+			raw_spin_unlock_irq(&x->wait.lock);
 			timeout = action(timeout);
-			spin_lock_irq(&x->wait.lock);
+			raw_spin_lock_irq(&x->wait.lock);
 		} while (!x->done && timeout);
-		__remove_wait_queue(&x->wait, &wait);
+		swait_finish_locked(&x->wait, &wait);
 		if (!x->done)
 			return timeout;
 	}
@@ -89,9 +89,9 @@ __wait_for_common(struct completion *x,
 {
 	might_sleep();
 
-	spin_lock_irq(&x->wait.lock);
+	raw_spin_lock_irq(&x->wait.lock);
 	timeout = do_wait_for_common(x, action, timeout, state);
-	spin_unlock_irq(&x->wait.lock);
+	raw_spin_unlock_irq(&x->wait.lock);
 	return timeout;
 }
 
@@ -267,12 +267,12 @@ bool try_wait_for_completion(struct completion *x)
 	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
 	else
 		x->done--;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(try_wait_for_completion);
@@ -290,10 +290,10 @@ bool completion_done(struct completion *x)
 	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(completion_done);
-- 
1.8.5.1

