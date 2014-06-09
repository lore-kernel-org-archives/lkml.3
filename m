Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbaFIQu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:50:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44823 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbaFIQuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:50:54 -0400
Date: Mon, 9 Jun 2014 09:49:15 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-3d5c9340d1949733eb37616abd15db36aef9a57c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bmouring@ni.com, rostedt@goodmis.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, bmouring@ni.com, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20140605152801.836501969@linutronix.de>
References: <20140605152801.836501969@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] rtmutex: Handle deadlock detection smarter
Git-Commit-ID: 3d5c9340d1949733eb37616abd15db36aef9a57c
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

Commit-ID:  3d5c9340d1949733eb37616abd15db36aef9a57c
Gitweb:     http://git.kernel.org/tip/3d5c9340d1949733eb37616abd15db36aef9a57c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 5 Jun 2014 12:34:23 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 7 Jun 2014 14:55:40 +0200

rtmutex: Handle deadlock detection smarter

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex-debug.h |  5 +++++
 kernel/locking/rtmutex.c       | 33 ++++++++++++++++++++++++++++-----
 kernel/locking/rtmutex.h       |  5 +++++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/rtmutex-debug.h b/kernel/locking/rtmutex-debug.h
index 14193d5..ab29b6a 100644
--- a/kernel/locking/rtmutex-debug.h
+++ b/kernel/locking/rtmutex-debug.h
@@ -31,3 +31,8 @@ static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
 {
 	return (waiter != NULL);
 }
+
+static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
+{
+	debug_rt_mutex_print_deadlock(w);
+}
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index a620d4d..eb7a463 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -314,7 +314,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		}
 		put_task_struct(task);
 
-		return deadlock_detect ? -EDEADLK : 0;
+		return -EDEADLK;
 	}
  retry:
 	/*
@@ -377,7 +377,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
 		raw_spin_unlock(&lock->wait_lock);
-		ret = deadlock_detect ? -EDEADLK : 0;
+		ret = -EDEADLK;
 		goto out_unlock_pi;
 	}
 
@@ -548,7 +548,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 * which is wrong, as the other waiter is not in a deadlock
 	 * situation.
 	 */
-	if (detect_deadlock && owner == task)
+	if (owner == task)
 		return -EDEADLK;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -763,6 +763,26 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
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
@@ -802,8 +822,10 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		remove_waiter(lock, &waiter);
+		rt_mutex_handle_deadlock(ret, detect_deadlock, &waiter);
+	}
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -1112,7 +1134,8 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	/* We enforce deadlock detection for futexes */
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
diff --git a/kernel/locking/rtmutex.h b/kernel/locking/rtmutex.h
index a1a1dd0..f6a1f3c 100644
--- a/kernel/locking/rtmutex.h
+++ b/kernel/locking/rtmutex.h
@@ -24,3 +24,8 @@
 #define debug_rt_mutex_print_deadlock(w)		do { } while (0)
 #define debug_rt_mutex_detect_deadlock(w,d)		(d)
 #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
+
+static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
+{
+	WARN(1, "rtmutex deadlock detected\n");
+}
