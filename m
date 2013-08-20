Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3HTDlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:41:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7069 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3HTDlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:41:44 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=vCjy3HImSv4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iFVhuBGNJz4A:10 a=pjdaNNIBAAAA:8 a=5KJXXOnXan1zFDeMUhMA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 19 Aug 2013 23:41:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kent Overstreet <koverstreet@google.com>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: [RFC][PATCH RT] rtmutex: Add up/down_read_non_owner() API
Message-ID: <20130819234141.35cdd8b2@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As the up/down_read_non_owner() API has been brought back from the
dead, and has a single user (bcache), this module now breaks -rt, as
-rt has no API for non owner rwsems.

Now I looked at the code for bcache, and I don't see a way to fix it.
Perhaps there is, but I don't see it. Thus, I decided to try and add a
work around that would work with the -rt kernel.

As -rt requires that all locks have a owner (including rwsems) I added
a "RT_MUTEX_NON_OWNER" owner, to be used with great care. The
up/down_read_non_owner()s will now call rt_mutex_(un)lock_non_owner()
-rt API.

The rt_mutex_lock_non_owner() will grab the mutex as normal, but after
it gets it, it will take the lock's wait_lock and then its own pi_lock,
and remove any waiters on the lock (if necessary). It sets the lock
owner to RT_MUTEX_NON_OWNER (which is simply (struct task_struct *)4)
and then adjusts the old owners prio (if needed).

The pi chain and other areas check if the owner is this
RT_MUTEX_NON_OWNER, and if it is, it just ends the chain there. Thus,
if something is blocked on the bcache lock, if it tries to boost the
prio, it will get no where if the lock is already held.

Note, I compiled and booted this patch, but I don't think my box
actually uses the bcache code, even though I compiled it in, so I don't
know how well this patch works :-/

Another thought, is to add a config NEED_RWSEM_NON_OWNER that
CONFIG_BCACHE will select. If it is not set, it will compile out all
the non_owner crap, and let the system run like it does today.

Ideally, the bcache code can be changed to remove this non_owner rwsem,
but as it seems to need it for now, this hack may be sufficient. I
tried to come up with the simplest solution, and this seems to be it.

Reported-by: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 5ebd0bb..504bf19 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -120,6 +120,9 @@ extern int rt_mutex_trylock(struct rt_mutex *lock);
 
 extern void rt_mutex_unlock(struct rt_mutex *lock);
 
+extern void rt_mutex_lock_non_owner(struct rt_mutex *lock);
+extern void rt_mutex_unlock_non_owner(struct rt_mutex *lock);
+
 #ifdef CONFIG_RT_MUTEXES
 # define
INIT_RT_MUTEXES(tsk)
\ .pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters),	\ diff
--git a/include/linux/rwsem_rt.h b/include/linux/rwsem_rt.h index
e94d945..c305b9d 100644 --- a/include/linux/rwsem_rt.h
+++ b/include/linux/rwsem_rt.h
@@ -63,6 +63,9 @@ extern void  rt_up_read(struct rw_semaphore *rwsem);
 extern void  rt_up_write(struct rw_semaphore *rwsem);
 extern void  rt_downgrade_write(struct rw_semaphore *rwsem);
 
+extern void  rt_down_read_non_owner(struct rw_semaphore *rwsem);
+extern void  rt_up_read_non_owner(struct rw_semaphore *rwsem);
+
 #define init_rwsem(sem)		rt_init_rwsem(sem)
 #define rwsem_is_locked(s)	rt_mutex_is_locked(&(s)->lock)
 
@@ -126,3 +129,13 @@ static inline void down_write_nest_lock(struct
rw_semaphore *sem, }
 #endif
 #endif
+
+static inline void  down_read_non_owner(struct rw_semaphore *sem)
+{
+	rt_down_read_non_owner(sem);
+}
+
+static inline void up_read_non_owner(struct rw_semaphore *sem)
+{
+	rt_up_read_non_owner(sem);
+}
diff --git a/kernel/rt.c b/kernel/rt.c
index 433ae42..882edb5 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -413,6 +413,18 @@ void  rt_down_read_nested(struct rw_semaphore
*rwsem, int subclass) }
 EXPORT_SYMBOL(rt_down_read_nested);
 
+void rt_down_read_non_owner(struct rw_semaphore *rwsem)
+{
+	rt_mutex_lock_non_owner(&rwsem->lock);
+}
+EXPORT_SYMBOL(rt_down_read_non_owner);
+
+void rt_up_read_non_owner(struct rw_semaphore *rwsem)
+{
+	rt_mutex_unlock_non_owner(&rwsem->lock);
+}
+EXPORT_SYMBOL(rt_up_read_non_owner);
+
 void  __rt_rwsem_init(struct rw_semaphore *rwsem, const char *name,
 			      struct lock_class_key *key)
 {
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 5d76634..2e31e70 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -302,6 +302,11 @@ static int rt_mutex_adjust_prio_chain(struct
task_struct *task, 
 	/* Grab the next task */
 	task = rt_mutex_owner(lock);
+
+	/* non owner mutex? Stop here */
+	if (task == RT_MUTEX_NON_OWNER)
+		return ret;
+
 	get_task_struct(task);
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
@@ -500,7 +505,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex
*lock, 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
-	if (!owner)
+	if (!owner || owner == RT_MUTEX_NON_OWNER)
 		return 0;
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
@@ -586,7 +591,7 @@ static void remove_waiter(struct rt_mutex *lock,
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
-	if (!owner)
+	if (!owner || owner == RT_MUTEX_NON_OWNER)
 		return;
 
 	if (first) {
@@ -683,6 +688,9 @@ static int adaptive_wait(struct rt_mutex *lock,
 {
 	int res = 0;
 
+	if (owner == RT_MUTEX_NON_OWNER)
+		return 0;
+
 	rcu_read_lock();
 	for (;;) {
 		if (owner != rt_mutex_owner(lock))
@@ -1050,6 +1058,53 @@ rt_mutex_slowlock(struct rt_mutex *lock, int
state, }
 
 /*
+ * We are about to make this lock ownerless, any waiters of the
+ * lock need to be taken off of current's PI list.
+ */
+static void __sched
+remove_pi_lock_waiters(struct task_struct *task, struct rt_mutex *lock)
+{
+	struct rt_mutex_waiter *waiter;
+
+	pi_lock(&task->pi_lock);
+	waiter = rt_mutex_top_waiter(lock);
+	plist_del(&waiter->pi_list_entry, &task->pi_waiters);
+	pi_unlock(&task->pi_lock);
+}
+
+/*
+ * Slow path lock function for non owner:
+ */
+static int __sched
+rt_mutex_slowlock_non_owner(struct rt_mutex *lock, int state,
+			    struct hrtimer_sleeper *timeout,
+			    int detect_deadlock)
+{
+	int ret;
+
+	/* there's no timeout version of non_owner */
+	BUG_ON(timeout);
+
+	ret = rt_mutex_slowlock(lock, state, NULL, detect_deadlock);
+	if (ret < 0)
+		return ret;
+
+	raw_spin_lock(&lock->wait_lock);
+
+	rt_mutex_set_owner(lock, RT_MUTEX_NON_OWNER);
+
+	/* Remove any pi waiter for this lock from current */
+	if (rt_mutex_has_waiters(lock)) {
+		remove_pi_lock_waiters(current, lock);
+		raw_spin_unlock(&lock->wait_lock);
+		rt_mutex_adjust_prio(current);
+	} else
+		raw_spin_unlock(&lock->wait_lock);
+
+	return 0;
+}
+
+/*
  * Slow path try-lock function:
  */
 static inline int
@@ -1108,17 +1163,29 @@ rt_mutex_slowunlock(struct rt_mutex *lock)
  * architecture does not support cmpxchg or when debugging is enabled.
  */
 static inline int
+__rt_mutex_fastlock(struct rt_mutex *lock, int state,
+		    int detect_deadlock,
+		    struct task_struct *task,
+		    int (*slowfn)(struct rt_mutex *lock, int state,
+				  struct hrtimer_sleeper *timeout,
+				  int detect_deadlock))
+{
+	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL,
task))) {
+		rt_mutex_deadlock_account_lock(lock, task);
+		return 0;
+	} else
+		return slowfn(lock, state, NULL, detect_deadlock);
+}
+
+static inline int
 rt_mutex_fastlock(struct rt_mutex *lock, int state,
 		  int detect_deadlock,
 		  int (*slowfn)(struct rt_mutex *lock, int state,
 				struct hrtimer_sleeper *timeout,
 				int detect_deadlock))
 {
-	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL,
current))) {
-		rt_mutex_deadlock_account_lock(lock, current);
-		return 0;
-	} else
-		return slowfn(lock, state, NULL, detect_deadlock);
+	return __rt_mutex_fastlock(lock, state, detect_deadlock,
+				   current, slowfn);
 }
 
 static inline int
@@ -1147,15 +1214,22 @@ rt_mutex_fasttrylock(struct rt_mutex *lock,
 }
 
 static inline void
-rt_mutex_fastunlock(struct rt_mutex *lock,
-		    void (*slowfn)(struct rt_mutex *lock))
+__rt_mutex_fastunlock(struct rt_mutex *lock, struct task_struct *task,
+		      void (*slowfn)(struct rt_mutex *lock))
 {
-	if (likely(rt_mutex_cmpxchg(lock, current, NULL)))
+	if (likely(rt_mutex_cmpxchg(lock, task, NULL)))
 		rt_mutex_deadlock_account_unlock(current);
 	else
 		slowfn(lock);
 }
 
+static inline void
+rt_mutex_fastunlock(struct rt_mutex *lock,
+		    void (*slowfn)(struct rt_mutex *lock))
+{
+	__rt_mutex_fastunlock(lock, current, slowfn);
+}
+
 /**
  * rt_mutex_lock - lock a rt_mutex
  *
@@ -1169,6 +1243,14 @@ void __sched rt_mutex_lock(struct rt_mutex *lock)
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock);
 
+void __sched rt_mutex_lock_non_owner(struct rt_mutex *lock)
+{
+	might_sleep();
+
+	__rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, 0,
RT_MUTEX_NON_OWNER,
+			  rt_mutex_slowlock_non_owner);
+}
+
 /**
  * rt_mutex_lock_interruptible - lock a rt_mutex interruptible
  *
@@ -1262,6 +1344,16 @@ void __sched rt_mutex_unlock(struct rt_mutex
*lock) EXPORT_SYMBOL_GPL(rt_mutex_unlock);
 
 /**
+ * rt_mutex_unlock - unlock a rt_mutex
+ *
+ * @lock: the rt_mutex to be unlocked
+ */
+void __sched rt_mutex_unlock_non_owner(struct rt_mutex *lock)
+{
+	__rt_mutex_fastunlock(lock, RT_MUTEX_NON_OWNER,
rt_mutex_slowunlock); +}
+
+/**
  * rt_mutex_destroy - mark a mutex unusable
  * @lock: the mutex to be destroyed
  *
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index 6ec3dc1..8194e18 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -121,6 +121,11 @@ extern int rt_mutex_finish_proxy_lock(struct
rt_mutex *lock, struct rt_mutex_waiter *waiter,
 				      int detect_deadlock);
 
+/*
+ * Used by the up/down_read_non_owner() API
+ */
+#define RT_MUTEX_NON_OWNER ((struct task_struct *) 4)
+
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # include "rtmutex-debug.h"
 #else
