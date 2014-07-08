Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaGHT1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:27:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54212 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Brad Mouring" <bmouring@ni.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.600618622@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 079/125] rtmutex: Handle deadlock detection smarter
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

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
[bwh: Backported to 3.2: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/rtmutex-debug.h |  5 +++++
 kernel/rtmutex.c       | 33 ++++++++++++++++++++++++++++-----
 kernel/rtmutex.h       |  5 +++++
 3 files changed, 38 insertions(+), 5 deletions(-)

--- a/kernel/rtmutex-debug.h
+++ b/kernel/rtmutex-debug.h
@@ -31,3 +31,8 @@ static inline int debug_rt_mutex_detect_
 {
 	return (waiter != NULL);
 }
+
+static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
+{
+	debug_rt_mutex_print_deadlock(w);
+}
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -182,7 +182,7 @@ static int rt_mutex_adjust_prio_chain(st
 		}
 		put_task_struct(task);
 
-		return deadlock_detect ? -EDEADLK : 0;
+		return -EDEADLK;
 	}
  retry:
 	/*
@@ -245,7 +245,7 @@ static int rt_mutex_adjust_prio_chain(st
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
 		raw_spin_unlock(&lock->wait_lock);
-		ret = deadlock_detect ? -EDEADLK : 0;
+		ret = -EDEADLK;
 		goto out_unlock_pi;
 	}
 
@@ -419,7 +419,7 @@ static int task_blocks_on_rt_mutex(struc
 	 * which is wrong, as the other waiter is not in a deadlock
 	 * situation.
 	 */
-	if (detect_deadlock && owner == task)
+	if (owner == task)
 		return -EDEADLK;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -644,6 +644,26 @@ __rt_mutex_slowlock(struct rt_mutex *loc
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
@@ -681,8 +701,10 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		remove_waiter(lock, &waiter);
+		rt_mutex_handle_deadlock(ret, detect_deadlock, &waiter);
+	}
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -990,7 +1012,8 @@ int rt_mutex_start_proxy_lock(struct rt_
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	/* We enforce deadlock detection for futexes */
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
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

