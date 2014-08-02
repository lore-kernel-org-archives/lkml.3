Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaHBUEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 16:04:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47157 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbaHBUEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 16:04:49 -0400
Date: Sat, 2 Aug 2014 22:04:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, davidlohr@hp.com,
        jason.low2@hp.com
Subject: [RFC][PATCH] locking: Debug nested wait/locking primitives
Message-ID: <20140802200443.GA12054@laptop.lan>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
 <20140731115759.GS19379@twins.programming.kicks-ass.net>
 <CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
 <20140731131331.GT19379@twins.programming.kicks-ass.net>
 <20140731134411.GA12050@gmail.com>
 <20140731135616.GU19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731135616.GU19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This should cover most cases I think.

I'll have to break this out into different patches, and maybe clean up
things a bit (there's certainly comments missing and some repetition).

But this boots on my test box and builds a kernel without generating a
single WARN -- big improvement over not booting (partly due to excessive
warn output) with just the sched/core.c bit.

---
 drivers/tty/n_tty.c              | 71 +++++++++++++++++++++++++++++++++-------
 fs/notify/inotify/inotify_user.c | 34 +++++++++++++++++--
 fs/notify/notification.c         |  2 +-
 include/linux/kernel.h           |  4 +--
 include/linux/sched.h            | 46 ++++++++++++++++++++++++--
 include/linux/wait.h             |  2 ++
 kernel/exit.c                    |  6 ++++
 kernel/sched/core.c              | 14 ++++++++
 kernel/smpboot.c                 | 15 +++++----
 9 files changed, 168 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f44f1ba762c3..5e4830979937 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2098,6 +2098,36 @@ static int job_control(struct tty_struct *tty, struct file *file)
 	return 0;
 }
 
+/*
+ * n_tty_{read,write} use blocking primitives (mutex_lock, down_read, etc.)
+ * inside an open-coded wait loop.
+ *
+ * The wait loop relies on current->state to record wakeups; these will change
+ * it back to TASK_RUNNING. However blocking primitives themselves also change
+ * current->state. Therefore we must implement another means of recording
+ * wakeups.
+ *
+ * We do this by setting an alternative waitqueue wake function which changes
+ * an additional variable.
+ */
+
+struct n_tty_wakeup_state {
+	struct task_struct *task;
+	bool woken;
+};
+
+static int n_tty_wake(wait_queue_t *wait, unsigned mode,
+			    int wake_flags, void *key)
+{
+	struct n_tty_wakeup_state *s = wait->private;
+	DECLARE_WAITQUEUE(dummy_wait, s->task);
+
+	smp_wmb();
+	s->woken = true;
+
+	return default_wake_function(&dummy_wait, mode, wake_flags, key);
+}
+
 
 /**
  *	n_tty_read		-	read function for tty
@@ -2123,7 +2153,11 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	unsigned char __user *b = buf;
-	DECLARE_WAITQUEUE(wait, current);
+	struct n_tty_wakeup_state s = {
+		.task = current,
+		.woken = false,
+	};
+	wait_queue_t wait;
 	int c;
 	int minimum, time;
 	ssize_t retval = 0;
@@ -2167,6 +2201,9 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 	packet = tty->packet;
 
+	init_waitqueue_func_entry(&wait, n_tty_wake);
+	wait.private = &s;
+
 	add_wait_queue(&tty->read_wait, &wait);
 	while (nr) {
 		/* First test for status change. */
@@ -2186,10 +2223,11 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			nr--;
 			break;
 		}
-		/* This statement must be first before checking for input
-		   so that any interrupt will set the state back to
-		   TASK_RUNNING. */
-		set_current_state(TASK_INTERRUPTIBLE);
+		/*
+		 * This statement must be first before checking for input so
+		 * that any interrupt will set it to true.
+		 */
+		s.woken = false;
 
 		if (((minimum - (b - buf)) < ldata->minimum_to_wake) &&
 		    ((minimum - (b - buf)) >= 1))
@@ -2220,13 +2258,15 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 				n_tty_set_room(tty);
 				up_read(&tty->termios_rwsem);
 
-				timeout = schedule_timeout(timeout);
+				set_current_state(TASK_INTERRUPTIBLE);
+				if (!s.woken)
+					timeout = schedule_timeout(timeout);
+				__set_current_state(TASK_RUNNING);
 
 				down_read(&tty->termios_rwsem);
 				continue;
 			}
 		}
-		__set_current_state(TASK_RUNNING);
 
 		/* Deal with packet mode. */
 		if (packet && b == buf) {
@@ -2273,7 +2313,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 	mutex_unlock(&ldata->atomic_read_lock);
 
-	__set_current_state(TASK_RUNNING);
 	if (b - buf)
 		retval = b - buf;
 
@@ -2306,7 +2345,11 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
 	const unsigned char *b = buf;
-	DECLARE_WAITQUEUE(wait, current);
+	struct n_tty_wakeup_state s = {
+		.task = current,
+		.woken = false,
+	};
+	wait_queue_t wait;
 	int c;
 	ssize_t retval = 0;
 
@@ -2322,9 +2365,12 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 	/* Write out any echoed characters that are still pending */
 	process_echoes(tty);
 
+	init_waitqueue_func_entry(&wait, n_tty_wake);
+	wait.private = &s;
+
 	add_wait_queue(&tty->write_wait, &wait);
 	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
+		s.woken = false;
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
 			break;
@@ -2378,7 +2424,10 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 		}
 		up_read(&tty->termios_rwsem);
 
-		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!s.woken)
+			schedule();
+		__set_current_state(TASK_RUNNING);
 
 		down_read(&tty->termios_rwsem);
 	}
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index cc423a30a0c8..e3b65ce6b312 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -220,6 +220,23 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	return event_size;
 }
 
+struct inotify_wakeup_state {
+	struct task_struct *task;
+	bool woken;
+};
+
+static int inotify_wake(wait_queue_t *wait, unsigned mode,
+			int wake_flags, void *key)
+{
+	struct inotify_wakeup_state *s = wait->private;
+	DECLARE_WAITQUEUE(dummy_wait, s->task);
+
+	smp_wmb();
+	s->woken = true;
+
+	return autoremove_wake_function(&dummy_wait, mode, wake_flags, key);
+}
+
 static ssize_t inotify_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *pos)
 {
@@ -227,13 +244,21 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 	struct fsnotify_event *kevent;
 	char __user *start;
 	int ret;
-	DEFINE_WAIT(wait);
+	struct inotify_wakeup_state s = {
+		.task = current,
+		.woken = false,
+	};
+	wait_queue_t wait;
+
+	init_waitqueue_func_entry(&wait, inotify_wake);
+	wait.private = &s;
 
 	start = buf;
 	group = file->private_data;
 
+	add_wait_queue(&group->notification_waitq, &wait);
 	while (1) {
-		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
+		s.woken = false;
 
 		mutex_lock(&group->notification_mutex);
 		kevent = get_one_event(group, count);
@@ -264,7 +289,10 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 		if (start != buf)
 			break;
 
-		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!s.woken)
+			schedule();
+		__set_current_state(TASK_RUNNING);
 	}
 
 	finish_wait(&group->notification_waitq, &wait);
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 1e58402171a5..dcfcdd69d1de 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -63,7 +63,7 @@ EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 /* return true if the notify queue is empty, false otherwise */
 bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
 {
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	lockdep_assert_held(&group->notification_mutex);
 	return list_empty(&group->notification_list) ? true : false;
 }
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907a6d8b..aac1dc9da2d0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -162,7 +162,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-  void __might_sleep(const char *file, int line, int preempt_offset);
+extern  void __might_sleep(const char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -174,7 +174,7 @@ extern int _cond_resched(void);
  * supposed to.
  */
 # define might_sleep() \
-	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
+	  do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
 #else
   static inline void __might_sleep(const char *file, int line,
 				   int preempt_offset) { }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 66124d63371a..62dab5738e66 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -241,6 +241,43 @@ extern char ___assert_task_state[1 - 2*!!(
 				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
 				 (task->flags & PF_FROZEN) == 0)
 
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+
+#define __set_task_state(tsk, state_value)			\
+	do {							\
+		(tsk)->task_state_change = _THIS_IP_;		\
+		(tsk)->state = (state_value);			\
+	} while (0)
+#define set_task_state(tsk, state_value)			\
+	do {							\
+		(tsk)->task_state_change = _THIS_IP_;		\
+		set_mb((tsk)->state, (state_value));		\
+	} while (0)
+
+/*
+ * set_current_state() includes a barrier so that the write of current->state
+ * is correctly serialised wrt the caller's subsequent test of whether to
+ * actually sleep:
+ *
+ *	set_current_state(TASK_UNINTERRUPTIBLE);
+ *	if (do_i_need_to_sleep())
+ *		schedule();
+ *
+ * If the caller does not need such serialisation then use __set_current_state()
+ */
+#define __set_current_state(state_value)			\
+	do {							\
+		current->task_state_change = _THIS_IP_;		\
+		current->state = (state_value);			\
+	} while (0)
+#define set_current_state(state_value)				\
+	do {							\
+		current->task_state_change = _THIS_IP_;		\
+		set_mb(current->state, (state_value));		\
+	} while (0)
+
+#else
+
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
 #define set_task_state(tsk, state_value)		\
@@ -257,11 +294,13 @@ extern char ___assert_task_state[1 - 2*!!(
  *
  * If the caller does not need such serialisation then use __set_current_state()
  */
-#define __set_current_state(state_value)			\
+#define __set_current_state(state_value)		\
 	do { current->state = (state_value); } while (0)
-#define set_current_state(state_value)		\
+#define set_current_state(state_value)			\
 	set_mb(current->state, (state_value))
 
+#endif
+
 /* Task command name length */
 #define TASK_COMM_LEN 16
 
@@ -1650,6 +1689,9 @@ struct task_struct {
 	unsigned int	sequential_io;
 	unsigned int	sequential_io_avg;
 #endif
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+	unsigned long	task_state_change;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6fb1ba5f9b2f..041b744e99b4 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -211,6 +211,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 	wait_queue_t __wait;						\
 	long __ret = ret;	/* explicit shadow */			\
 									\
+	might_sleep();							\
+									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	if (exclusive)							\
 		__wait.flags = WQ_FLAG_EXCLUSIVE;			\
diff --git a/kernel/exit.c b/kernel/exit.c
index e5c4668f1799..44cbc8791fca 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1067,6 +1067,12 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	}
 
 	/*
+	 * Since we're going to terminate the wait loop from do_wait(),
+	 * reset task state.
+	 */
+	__set_current_state(TASK_RUNNING);
+
+	/*
 	 * Now we are sure this task is interesting, and no other
 	 * thread can reap it because we its state == DEAD/TRACE.
 	 */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2676866b4394..0577c12c9cf8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7077,6 +7077,19 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 {
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
+	/*
+	 * Blocking primitives will set (and therefore destroy) current->state,
+	 * since we will exit with TASK_RUNNING make sure we enter with it,
+	 * otherwise we will destroy state.
+	 */
+	if (WARN(current->state != TASK_RUNNING,
+			"do not call blocking ops when !TASK_RUNNING; "
+			"state=%lx set at [<%p>] %pS\n",
+			current->state,
+			current->task_state_change,
+			current->task_state_change))
+		__set_current_state(TASK_RUNNING);
+
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
 	     !is_idle_task(current)) ||
@@ -7107,6 +7120,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	dump_stack();
 }
 EXPORT_SYMBOL(__might_sleep);
+
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index eb89e1807408..f032fb5284e3 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -110,7 +110,7 @@ static int smpboot_thread_fn(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		preempt_disable();
 		if (kthread_should_stop()) {
-			set_current_state(TASK_RUNNING);
+			__set_current_state(TASK_RUNNING);
 			preempt_enable();
 			if (ht->cleanup)
 				ht->cleanup(td->cpu, cpu_online(td->cpu));
@@ -136,26 +136,27 @@ static int smpboot_thread_fn(void *data)
 		/* Check for state change setup */
 		switch (td->status) {
 		case HP_THREAD_NONE:
+			__set_current_state(TASK_RUNNING);
 			preempt_enable();
 			if (ht->setup)
 				ht->setup(td->cpu);
 			td->status = HP_THREAD_ACTIVE;
-			preempt_disable();
-			break;
+			continue;
+
 		case HP_THREAD_PARKED:
+			__set_current_state(TASK_RUNNING);
 			preempt_enable();
 			if (ht->unpark)
 				ht->unpark(td->cpu);
 			td->status = HP_THREAD_ACTIVE;
-			preempt_disable();
-			break;
+			continue;
 		}
 
 		if (!ht->thread_should_run(td->cpu)) {
-			preempt_enable();
+			preempt_enable_no_resched();
 			schedule();
 		} else {
-			set_current_state(TASK_RUNNING);
+			__set_current_state(TASK_RUNNING);
 			preempt_enable();
 			ht->thread_fn(td->cpu);
 		}
