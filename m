Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab3BNOUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:20:31 -0500
Received: from relay.parallels.com ([195.214.232.42]:52303 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3BNOU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:20:26 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: <devel@openvz.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] sched: add wait_for_completion_io[_timeout]
Date: Thu, 14 Feb 2013 18:19:58 +0400
Message-ID: <d5e5c32b045e448072b3a4b77cd6557408b77103.1360851174.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.22.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only difference between wait_for_completion[_timeout]() and
wait_for_completion_io[_timeout]() is that the latter calls
io_schedule_timeout() instead of schedule_timeout() so that the caller
is accounted as waiting for IO, not just sleeping.

These functions can be used for correct iowait time accounting when the
completion struct is actually used for waiting for IO (e.g. completion
of a bio request in the block layer).

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/completion.h |    3 ++
 kernel/sched/core.c        |   57 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 51494e6..33f0280 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -77,10 +77,13 @@ static inline void init_completion(struct completion *x)
 }
 
 extern void wait_for_completion(struct completion *);
+extern void wait_for_completion_io(struct completion *);
 extern int wait_for_completion_interruptible(struct completion *x);
 extern int wait_for_completion_killable(struct completion *x);
 extern unsigned long wait_for_completion_timeout(struct completion *x,
 						   unsigned long timeout);
+extern unsigned long wait_for_completion_io_timeout(struct completion *x,
+						    unsigned long timeout);
 extern long wait_for_completion_interruptible_timeout(
 	struct completion *x, unsigned long timeout);
 extern long wait_for_completion_killable_timeout(
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..e0396dd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3268,7 +3268,8 @@ void complete_all(struct completion *x)
 EXPORT_SYMBOL(complete_all);
 
 static inline long __sched
-do_wait_for_common(struct completion *x, long timeout, int state)
+do_wait_for_common(struct completion *x,
+		   long (*action)(long), long timeout, int state)
 {
 	if (!x->done) {
 		DECLARE_WAITQUEUE(wait, current);
@@ -3281,7 +3282,7 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 			}
 			__set_current_state(state);
 			spin_unlock_irq(&x->wait.lock);
-			timeout = schedule_timeout(timeout);
+			timeout = action(timeout);
 			spin_lock_irq(&x->wait.lock);
 		} while (!x->done && timeout);
 		__remove_wait_queue(&x->wait, &wait);
@@ -3292,17 +3293,30 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 	return timeout ?: 1;
 }
 
-static long __sched
-wait_for_common(struct completion *x, long timeout, int state)
+static inline long __sched
+__wait_for_common(struct completion *x,
+		  long (*action)(long), long timeout, int state)
 {
 	might_sleep();
 
 	spin_lock_irq(&x->wait.lock);
-	timeout = do_wait_for_common(x, timeout, state);
+	timeout = do_wait_for_common(x, action, timeout, state);
 	spin_unlock_irq(&x->wait.lock);
 	return timeout;
 }
 
+static long __sched
+wait_for_common(struct completion *x, long timeout, int state)
+{
+	return __wait_for_common(x, schedule_timeout, timeout, state);
+}
+
+static long __sched
+wait_for_common_io(struct completion *x, long timeout, int state)
+{
+	return __wait_for_common(x, io_schedule_timeout, timeout, state);
+}
+
 /**
  * wait_for_completion: - waits for completion of a task
  * @x:  holds the state of this particular completion
@@ -3339,6 +3353,39 @@ wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 EXPORT_SYMBOL(wait_for_completion_timeout);
 
 /**
+ * wait_for_completion_io: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout. The caller is accounted as waiting
+ * for IO.
+ */
+void __sched wait_for_completion_io(struct completion *x)
+{
+	wait_for_common_io(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_io);
+
+/**
+ * wait_for_completion_io_timeout: - waits for completion of a task (w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. The timeout is in jiffies. It is not
+ * interruptible. The caller is accounted as waiting for IO.
+ *
+ * The return value is 0 if timed out, and positive (at least 1, or number of
+ * jiffies left till timeout) if completed.
+ */
+unsigned long __sched
+wait_for_completion_io_timeout(struct completion *x, unsigned long timeout)
+{
+	return wait_for_common_io(x, timeout, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_io_timeout);
+
+/**
  * wait_for_completion_interruptible: - waits for completion of a task (w/intr)
  * @x:  holds the state of this particular completion
  *
-- 
1.7.1

