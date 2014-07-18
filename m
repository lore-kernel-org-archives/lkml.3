Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965701AbaGRNNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:13:22 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17693 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933684AbaGRNNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:13:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Brad Mouring <bmouring@ni.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 006/170] rtmutex: Handle deadlock detection smarter
Date: Fri, 18 Jul 2014 14:10:11 +0200
Message-Id: <a2e64fcdc83c645813f7b93e4df291841ba7c625.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3d5c9340d1949733eb37616abd15db36aef9a57c upstream.

Even in the case when deadlock detection is not requested by the
caller, we can detect deadlocks. Right now the code stops the lock
chain walk and keeps the waiter enqueued, even on itself. Silly not to
yell when such a scenario is detected and to keep the waiter enqueued.

Return -EDEADLK unconditionally and handle it at the call sites.

The futex calls return -EDEADLK. The non futex ones dequeue the
waiter, throw a warning and put the task into a schedule loop.

Tagged for stable as it makes the code more robust.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Brad Mouring <bmouring@ni.com>
Link: http://lkml.kernel.org/r/20140605152801.836501969@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/rtmutex-debug.h |  5 +++++
 kernel/rtmutex.c       | 33 ++++++++++++++++++++++++++++-----
 kernel/rtmutex.h       |  5 +++++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/kernel/rtmutex-debug.h b/kernel/rtmutex-debug.h
index 14193d596d78..ab29b6a22669 100644
--- a/kernel/rtmutex-debug.h
+++ b/kernel/rtmutex-debug.h
@@ -31,3 +31,8 @@ static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
 {
 	return (waiter != NULL);
 }
+
+static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
+{
+	debug_rt_mutex_print_deadlock(w);
+}
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index c343cc9702af..ff24a43f192f 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -205,7 +205,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		}
 		put_task_struct(task);
 
-		return deadlock_detect ? -EDEADLK : 0;
+		return -EDEADLK;
 	}
  retry:
 	/*
@@ -280,7 +280,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
 		raw_spin_unlock(&lock->wait_lock);
-		ret = deadlock_detect ? -EDEADLK : 0;
+		ret = -EDEADLK;
 		goto out_unlock_pi;
 	}
 
@@ -470,7 +470,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 * which is wrong, as the other waiter is not in a deadlock
 	 * situation.
 	 */
-	if (detect_deadlock && owner == task)
+	if (owner == task)
 		return -EDEADLK;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -697,6 +697,26 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	return ret;
 }
 
+static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
+				     struct rt_mutex_waiter *w)
+{
+	/*
+	 * If the result is not -EDEADLOCK or the caller requested
+	 * deadlock detection, nothing to do here.
+	 */
+	if (res != -EDEADLOCK || detect_deadlock)
+		return;
+
+	/*
+	 * Yell lowdly and stop the task right here.
+	 */
+	rt_mutex_print_deadlock(w);
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
+}
+
 /*
  * Slow path lock function:
  */
@@ -734,8 +754,10 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		remove_waiter(lock, &waiter);
+		rt_mutex_handle_deadlock(ret, detect_deadlock, &waiter);
+	}
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -1043,7 +1065,8 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	/* We enforce deadlock detection for futexes */
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
diff --git a/kernel/rtmutex.h b/kernel/rtmutex.h
index a1a1dd06421d..f6a1f3c133b1 100644
--- a/kernel/rtmutex.h
+++ b/kernel/rtmutex.h
@@ -24,3 +24,8 @@
 #define debug_rt_mutex_print_deadlock(w)		do { } while (0)
 #define debug_rt_mutex_detect_deadlock(w,d)		(d)
 #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
+
+static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
+{
+	WARN(1, "rtmutex deadlock detected\n");
+}
-- 
2.0.0

