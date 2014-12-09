Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaLILRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:17:04 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47399 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbaLILQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:16:59 -0500
Date: Tue, 9 Dec 2014 12:16:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler tree changes for v3.19
Message-ID: <20141209111653.GA26530@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   # HEAD: fd7de1e8d5b2b2b35e71332fafb899f584597150 sched: Add missing rcu protection to wake_up_all_idle_cpus

The main changes in this cycle are:

 - 'Nested Sleep Debugging', activated when CONFIG_DEBUG_ATOMIC_SLEEP=y.
   This instruments might_sleep() checks to catch places that 
   nest blocking primitives - such as mutex usage in a wait loop. 
   Such bugs can result in hard to debug races/hangs.

   Another category of invalid nesting that this facility will 
   detect is the calling of blocking functions from within
   schedule()->sched_submit_work()->blk_schedule_flush_plug().

   There's some potential for false positives (if secondary
   blocking primitives themselves are not ready yet for this
   facility), but the kernel will warn once about such bugs per
   bootup, so the warning isn't much of a nuisance.

   This feature comes with a number of fixes, for problems
   uncovered with it, so no messages are expected normally.

 - Another round of sched/numa optimizations and refinements, for 
   CONFIG_NUMA_BALANCING=y.

 - Another round of sched/dl fixes and refinements.

Plus various smaller fixes and cleanups.

 Thanks,

	Ingo

------------------>
Andy Lutomirski (1):
      sched: Add missing rcu protection to wake_up_all_idle_cpus

Chen Hanxiao (1):
      sched: Update comments about CLONE_NEWUTS and CLONE_NEWIPC

Iulia Manda (1):
      sched: Refactor task_struct to use numa_faults instead of numa_* pointers

Juri Lelli (3):
      sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets
      sched/deadline: Ensure that updates to exclusive cpusets don't break AC
      sched/core: Use dl_bw_of() under rcu_read_lock_sched()

Kirill Tkhai (3):
      sched/deadline: Implement cancel_dl_timer() to use in switched_from_dl()
      sched/fair: Kill task_struct::numa_entry and numa_group::task_list
      sched/numa: Init numa balancing fields of init_task

Oleg Nesterov (4):
      sched: Fix the PREEMPT_ACTIVE check in __trace_sched_switch_state()
      sched: Fix schedule_tail() to disable preemption
      sched: Make finish_task_switch() return 'struct rq *'
      sched: Kill task_preempt_count()

Peter Zijlstra (17):
      locking/mutex: Don't assume TASK_RUNNING
      sched/wait: Provide infrastructure to deal with nested blocking
      sched/wait: Add might_sleep() checks
      sched, exit: Deal with nested sleeps
      sched, inotify: Deal with nested sleeps
      sched, tty: Deal with nested sleeps
      sched, smp: Correctly deal with nested sleeps
      sched, modules: Fix nested sleep in add_unformed_module()
      sched, net: Clean up sk_wait_event() vs. might_sleep()
      sched: Debug nested sleeps
      sched: Exclude cond_resched() from nested sleep test
      sched/wait: Fix a kthread race with wait_woken()
      sched/wait: Reimplement wait_event_freezable()
      audit, sched/wait: Fixup kauditd_thread() wait loop
      rfcomm, sched/wait: Fix broken wait construct
      netdev, sched/wait: Fix sleeping inside wait event
      sched: Use WARN_ONCE for the might_sleep() TASK_RUNNING test

Peter Zijlstra (Intel) (1):
      sched/wait: Remove wait_event_freezekillable()

Rik van Riel (6):
      sched/numa: Export info needed for NUMA balancing on complex topologies
      sched/numa: Classify the NUMA topology of a system
      sched/numa: Prepare for complex topology placement
      sched/numa: Calculate node scores in complex NUMA topologies
      sched/numa: Find the preferred nid with complex NUMA topology
      sched/numa: Check all nodes when placing a pseudo-interleaved group

Wanpeng Li (13):
      sched/deadline: Do not try to push tasks if pinned task switches to dl
      sched/deadline: Don't check SD_BALANCE_FORK
      sched/deadline: Don't balance during wakeup if wakee is pinned
      sched/rt: Clean up check_preempt_equal_prio()
      sched/deadline: Fix artificial overrun introduced by yield_task_dl()
      sched/deadline: Add deadline rq status print
      sched/deadline: Push task away if the deadline is equal to curr during wakeup
      sched/deadline: Reschedule from switched_from_dl() after a successful pull
      sched/deadline: Don't check CONFIG_SMP in switched_from_dl()
      sched: Move p->nr_cpus_allowed check to select_task_rq()
      sched/fair: Fix stale overloaded status in the busiest group finding logic
      sched/deadline: Fix rq->dl.pushable_tasks bug in push_dl_task()
      sched/deadline: Introduce start_hrtick_dl() for !CONFIG_SCHED_HRTICK

Wolfram Sang (1):
      sched/completion: Document when to use wait_for_completion_io_*()

Yao Dongdong (1):
      sched: Check if we got a shallowest_idle_cpu before searching for least_loaded_cpu

pang.xunlei (2):
      sched/cpupri: Remove unnecessary definitions in cpupri.h
      sched/deadline: Remove unnecessary definitions in cpudeadline.h


 arch/x86/include/asm/preempt.h   |   3 -
 drivers/tty/n_tty.c              |  17 +-
 fs/notify/inotify/inotify_user.c |   9 +-
 include/asm-generic/preempt.h    |   3 -
 include/linux/freezer.h          |  50 ------
 include/linux/init_task.h        |  10 ++
 include/linux/kernel.h           |   5 +
 include/linux/sched.h            |  87 +++++++---
 include/linux/wait.h             |  80 ++++++++-
 include/net/sock.h               |   1 +
 include/trace/events/sched.h     |   9 +-
 include/uapi/linux/sched.h       |   4 +-
 kernel/audit.c                   |  11 +-
 kernel/cpuset.c                  |  23 +--
 kernel/exit.c                    |   5 +
 kernel/locking/mutex.c           |   8 +-
 kernel/module.c                  |  30 +++-
 kernel/sched/completion.c        |   5 +-
 kernel/sched/core.c              | 241 +++++++++++++++++++-------
 kernel/sched/cpudeadline.h       |   3 -
 kernel/sched/cpupri.h            |   3 -
 kernel/sched/deadline.c          |  99 ++++++++---
 kernel/sched/debug.c             |  11 +-
 kernel/sched/fair.c              | 354 +++++++++++++++++++++++++++++----------
 kernel/sched/rt.c                |  17 +-
 kernel/sched/sched.h             |  43 +++++
 kernel/sched/wait.c              |  66 ++++++++
 kernel/smpboot.c                 |  15 +-
 net/bluetooth/rfcomm/core.c      |  18 +-
 net/core/dev.c                   |  10 +-
 net/core/rtnetlink.c             |  10 +-
 31 files changed, 915 insertions(+), 335 deletions(-)

diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 400873450e33..8f3271842533 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -30,9 +30,6 @@ static __always_inline void preempt_count_set(int pc)
 /*
  * must be macros to avoid header recursion hell
  */
-#define task_preempt_count(p) \
-	(task_thread_info(p)->saved_preempt_count & ~PREEMPT_NEED_RESCHED)
-
 #define init_task_preempt_count(p) do { \
 	task_thread_info(p)->saved_preempt_count = PREEMPT_DISABLED; \
 } while (0)
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 89c4cee253e3..fb3f519b803f 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2123,7 +2123,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	unsigned char __user *b = buf;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int c;
 	int minimum, time;
 	ssize_t retval = 0;
@@ -2186,10 +2186,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			nr--;
 			break;
 		}
-		/* This statement must be first before checking for input
-		   so that any interrupt will set the state back to
-		   TASK_RUNNING. */
-		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (((minimum - (b - buf)) < ldata->minimum_to_wake) &&
 		    ((minimum - (b - buf)) >= 1))
@@ -2220,13 +2216,13 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 				n_tty_set_room(tty);
 				up_read(&tty->termios_rwsem);
 
-				timeout = schedule_timeout(timeout);
+				timeout = wait_woken(&wait, TASK_INTERRUPTIBLE,
+						     timeout);
 
 				down_read(&tty->termios_rwsem);
 				continue;
 			}
 		}
-		__set_current_state(TASK_RUNNING);
 
 		/* Deal with packet mode. */
 		if (packet && b == buf) {
@@ -2273,7 +2269,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 	mutex_unlock(&ldata->atomic_read_lock);
 
-	__set_current_state(TASK_RUNNING);
 	if (b - buf)
 		retval = b - buf;
 
@@ -2306,7 +2301,7 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
 	const unsigned char *b = buf;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int c;
 	ssize_t retval = 0;
 
@@ -2324,7 +2319,6 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 
 	add_wait_queue(&tty->write_wait, &wait);
 	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
 			break;
@@ -2378,12 +2372,11 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 		}
 		up_read(&tty->termios_rwsem);
 
-		schedule();
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 
 		down_read(&tty->termios_rwsem);
 	}
 break_out:
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&tty->write_wait, &wait);
 	if (b - buf != nr && tty->fasync)
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index daf76652fe58..283aa312d745 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -227,14 +227,13 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 	struct fsnotify_event *kevent;
 	char __user *start;
 	int ret;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
 	start = buf;
 	group = file->private_data;
 
+	add_wait_queue(&group->notification_waitq, &wait);
 	while (1) {
-		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
-
 		mutex_lock(&group->notification_mutex);
 		kevent = get_one_event(group, count);
 		mutex_unlock(&group->notification_mutex);
@@ -264,10 +263,10 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 		if (start != buf)
 			break;
 
-		schedule();
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
+	remove_wait_queue(&group->notification_waitq, &wait);
 
-	finish_wait(&group->notification_waitq, &wait);
 	if (start != buf && ret != -EFAULT)
 		ret = buf - start;
 	return ret;
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index 1cd3f5d767a8..eb6f9e6c3075 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -23,9 +23,6 @@ static __always_inline void preempt_count_set(int pc)
 /*
  * must be macros to avoid header recursion hell
  */
-#define task_preempt_count(p) \
-	(task_thread_info(p)->preempt_count & ~PREEMPT_NEED_RESCHED)
-
 #define init_task_preempt_count(p) do { \
 	task_thread_info(p)->preempt_count = PREEMPT_DISABLED; \
 } while (0)
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 7fd81b8c4897..6b7fd9cf5ea2 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -246,15 +246,6 @@ static inline int freezable_schedule_hrtimeout_range(ktime_t *expires,
  * defined in <linux/wait.h>
  */
 
-#define wait_event_freezekillable(wq, condition)			\
-({									\
-	int __retval;							\
-	freezer_do_not_count();						\
-	__retval = wait_event_killable(wq, (condition));		\
-	freezer_count();						\
-	__retval;							\
-})
-
 /* DO NOT ADD ANY NEW CALLERS OF THIS FUNCTION */
 #define wait_event_freezekillable_unsafe(wq, condition)			\
 ({									\
@@ -265,35 +256,6 @@ static inline int freezable_schedule_hrtimeout_range(ktime_t *expires,
 	__retval;							\
 })
 
-#define wait_event_freezable(wq, condition)				\
-({									\
-	int __retval;							\
-	freezer_do_not_count();						\
-	__retval = wait_event_interruptible(wq, (condition));		\
-	freezer_count();						\
-	__retval;							\
-})
-
-#define wait_event_freezable_timeout(wq, condition, timeout)		\
-({									\
-	long __retval = timeout;					\
-	freezer_do_not_count();						\
-	__retval = wait_event_interruptible_timeout(wq,	(condition),	\
-				__retval);				\
-	freezer_count();						\
-	__retval;							\
-})
-
-#define wait_event_freezable_exclusive(wq, condition)			\
-({									\
-	int __retval;							\
-	freezer_do_not_count();						\
-	__retval = wait_event_interruptible_exclusive(wq, condition);	\
-	freezer_count();						\
-	__retval;							\
-})
-
-
 #else /* !CONFIG_FREEZER */
 static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }
@@ -331,18 +293,6 @@ static inline void set_freezable(void) {}
 #define freezable_schedule_hrtimeout_range(expires, delta, mode)	\
 	schedule_hrtimeout_range(expires, delta, mode)
 
-#define wait_event_freezable(wq, condition)				\
-		wait_event_interruptible(wq, condition)
-
-#define wait_event_freezable_timeout(wq, condition, timeout)		\
-		wait_event_interruptible_timeout(wq, condition, timeout)
-
-#define wait_event_freezable_exclusive(wq, condition)			\
-		wait_event_interruptible_exclusive(wq, condition)
-
-#define wait_event_freezekillable(wq, condition)		\
-		wait_event_killable(wq, condition)
-
 #define wait_event_freezekillable_unsafe(wq, condition)			\
 		wait_event_killable(wq, condition)
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 77fc43f8fb72..5f30ac8c82bc 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -166,6 +166,15 @@ extern struct task_group root_task_group;
 # define INIT_RT_MUTEXES(tsk)
 #endif
 
+#ifdef CONFIG_NUMA_BALANCING
+# define INIT_NUMA_BALANCING(tsk)					\
+	.numa_preferred_nid = -1,					\
+	.numa_group = NULL,						\
+	.numa_faults = NULL,
+#else
+# define INIT_NUMA_BALANCING(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -237,6 +246,7 @@ extern struct task_group root_task_group;
 	INIT_CPUSET_SEQ(tsk)						\
 	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
+	INIT_NUMA_BALANCING(tsk)					\
 }
 
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3d770f5564b8..446d76a87ba1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -162,6 +162,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+  void ___might_sleep(const char *file, int line, int preempt_offset);
   void __might_sleep(const char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
@@ -175,10 +176,14 @@ extern int _cond_resched(void);
  */
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
+# define sched_annotate_sleep()	__set_current_state(TASK_RUNNING)
 #else
+  static inline void ___might_sleep(const char *file, int line,
+				   int preempt_offset) { }
   static inline void __might_sleep(const char *file, int line,
 				   int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
+# define sched_annotate_sleep() do { } while (0)
 #endif
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bbe63ec..bd7c14ba86c4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -243,6 +243,43 @@ extern char ___assert_task_state[1 - 2*!!(
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
@@ -259,11 +296,13 @@ extern char ___assert_task_state[1 - 2*!!(
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
 
@@ -1558,28 +1597,23 @@ struct task_struct {
 	struct numa_group *numa_group;
 
 	/*
-	 * Exponential decaying average of faults on a per-node basis.
-	 * Scheduling placement decisions are made based on the these counts.
-	 * The values remain static for the duration of a PTE scan
+	 * numa_faults is an array split into four regions:
+	 * faults_memory, faults_cpu, faults_memory_buffer, faults_cpu_buffer
+	 * in this precise order.
+	 *
+	 * faults_memory: Exponential decaying average of faults on a per-node
+	 * basis. Scheduling placement decisions are made based on these
+	 * counts. The values remain static for the duration of a PTE scan.
+	 * faults_cpu: Track the nodes the process was running on when a NUMA
+	 * hinting fault was incurred.
+	 * faults_memory_buffer and faults_cpu_buffer: Record faults per node
+	 * during the current scan window. When the scan completes, the counts
+	 * in faults_memory and faults_cpu decay and these values are copied.
 	 */
-	unsigned long *numa_faults_memory;
+	unsigned long *numa_faults;
 	unsigned long total_numa_faults;
 
 	/*
-	 * numa_faults_buffer records faults per node during the current
-	 * scan window. When the scan completes, the counts in
-	 * numa_faults_memory decay and these values are copied.
-	 */
-	unsigned long *numa_faults_buffer_memory;
-
-	/*
-	 * Track the nodes the process was running on when a NUMA hinting
-	 * fault was incurred.
-	 */
-	unsigned long *numa_faults_cpu;
-	unsigned long *numa_faults_buffer_cpu;
-
-	/*
 	 * numa_faults_locality tracks if faults recorded during the last
 	 * scan window were remote/local. The task scan period is adapted
 	 * based on the locality of the faults with different weights
@@ -1661,6 +1695,9 @@ struct task_struct {
 	unsigned int	sequential_io;
 	unsigned int	sequential_io_avg;
 #endif
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+	unsigned long	task_state_change;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
@@ -2052,6 +2089,10 @@ static inline void tsk_restore_flags(struct task_struct *task,
 	task->flags |= orig_flags & flags;
 }
 
+extern int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+				     const struct cpumask *trial);
+extern int task_can_attach(struct task_struct *p,
+			   const struct cpumask *cs_cpus_allowed);
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p,
 			       const struct cpumask *new_mask);
@@ -2760,7 +2801,7 @@ static inline int signal_pending_state(long state, struct task_struct *p)
 extern int _cond_resched(void);
 
 #define cond_resched() ({			\
-	__might_sleep(__FILE__, __LINE__, 0);	\
+	___might_sleep(__FILE__, __LINE__, 0);	\
 	_cond_resched();			\
 })
 
@@ -2773,14 +2814,14 @@ extern int __cond_resched_lock(spinlock_t *lock);
 #endif
 
 #define cond_resched_lock(lock) ({				\
-	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
+	___might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);\
 	__cond_resched_lock(lock);				\
 })
 
 extern int __cond_resched_softirq(void);
 
 #define cond_resched_softirq() ({					\
-	__might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET);	\
+	___might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET);	\
 	__cond_resched_softirq();					\
 })
 
diff --git a/include/linux/wait.h b/include/linux/wait.h
index e4a8eb9312ea..2232ed16635a 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -13,9 +13,12 @@ typedef struct __wait_queue wait_queue_t;
 typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
 
+/* __wait_queue::flags */
+#define WQ_FLAG_EXCLUSIVE	0x01
+#define WQ_FLAG_WOKEN		0x02
+
 struct __wait_queue {
 	unsigned int		flags;
-#define WQ_FLAG_EXCLUSIVE	0x01
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	task_list;
@@ -258,11 +261,37 @@ __out:	__ret;								\
  */
 #define wait_event(wq, condition)					\
 do {									\
+	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event(wq, condition);					\
 } while (0)
 
+#define __wait_event_freezable(wq, condition)				\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
+			    schedule(); try_to_freeze())
+
+/**
+ * wait_event - sleep (or freeze) until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE -- so as not to contribute
+ * to system load) until the @condition evaluates to true. The
+ * @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define wait_event_freezable(wq, condition)				\
+({									\
+	int __ret = 0;							\
+	might_sleep();							\
+	if (!(condition))						\
+		__ret = __wait_event_freezable(wq, condition);		\
+	__ret;								\
+})
+
 #define __wait_event_timeout(wq, condition, timeout)			\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
@@ -290,11 +319,30 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
+	might_sleep();							\
 	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
 
+#define __wait_event_freezable_timeout(wq, condition, timeout)		\
+	___wait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, 0, timeout,			\
+		      __ret = schedule_timeout(__ret); try_to_freeze())
+
+/*
+ * like wait_event_timeout() -- except it uses TASK_INTERRUPTIBLE to avoid
+ * increasing load and is freezable.
+ */
+#define wait_event_freezable_timeout(wq, condition, timeout)		\
+({									\
+	long __ret = timeout;						\
+	might_sleep();							\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __wait_event_freezable_timeout(wq, condition, timeout);	\
+	__ret;								\
+})
+
 #define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
 	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    cmd1; schedule(); cmd2)
@@ -315,6 +363,7 @@ do {									\
  */
 #define wait_event_cmd(wq, condition, cmd1, cmd2)			\
 do {									\
+	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
@@ -342,6 +391,7 @@ do {									\
 #define wait_event_interruptible(wq, condition)				\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible(wq, condition);	\
 	__ret;								\
@@ -375,6 +425,7 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
+	might_sleep();							\
 	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
@@ -425,6 +476,7 @@ do {									\
 #define wait_event_hrtimeout(wq, condition, timeout)			\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_UNINTERRUPTIBLE);	\
@@ -450,6 +502,7 @@ do {									\
 #define wait_event_interruptible_hrtimeout(wq, condition, timeout)	\
 ({									\
 	long __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_INTERRUPTIBLE);	\
@@ -463,12 +516,27 @@ do {									\
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible_exclusive(wq, condition);\
 	__ret;								\
 })
 
 
+#define __wait_event_freezable_exclusive(wq, condition)			\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, 0,		\
+			schedule(); try_to_freeze())
+
+#define wait_event_freezable_exclusive(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	might_sleep();							\
+	if (!(condition))						\
+		__ret = __wait_event_freezable_exclusive(wq, condition);\
+	__ret;								\
+})
+
+
 #define __wait_event_interruptible_locked(wq, condition, exclusive, irq) \
 ({									\
 	int __ret = 0;							\
@@ -637,6 +705,7 @@ do {									\
 #define wait_event_killable(wq, condition)				\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_killable(wq, condition);		\
 	__ret;								\
@@ -830,6 +899,8 @@ void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int sta
 long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
 void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait, unsigned int mode, void *key);
+long wait_woken(wait_queue_t *wait, unsigned mode, long timeout);
+int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
@@ -886,6 +957,7 @@ extern int bit_wait_io_timeout(struct wait_bit_key *);
 static inline int
 wait_on_bit(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
@@ -910,6 +982,7 @@ wait_on_bit(void *word, int bit, unsigned mode)
 static inline int
 wait_on_bit_io(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
@@ -936,6 +1009,7 @@ wait_on_bit_io(void *word, int bit, unsigned mode)
 static inline int
 wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit, action, mode);
@@ -963,6 +1037,7 @@ wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode
 static inline int
 wait_on_bit_lock(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, bit_wait, mode);
@@ -986,6 +1061,7 @@ wait_on_bit_lock(void *word, int bit, unsigned mode)
 static inline int
 wait_on_bit_lock_io(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, bit_wait_io, mode);
@@ -1011,6 +1087,7 @@ wait_on_bit_lock_io(void *word, int bit, unsigned mode)
 static inline int
 wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
@@ -1029,6 +1106,7 @@ wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned
 static inline
 int wait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mode)
 {
+	might_sleep();
 	if (atomic_read(val) == 0)
 		return 0;
 	return out_of_line_wait_on_atomic_t(val, action, mode);
diff --git a/include/net/sock.h b/include/net/sock.h
index 7db3db112baa..e6f235ebf6c9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -897,6 +897,7 @@ static inline void sock_rps_reset_rxhash(struct sock *sk)
 		if (!__rc) {						\
 			*(__timeo) = schedule_timeout(*(__timeo));	\
 		}							\
+		sched_annotate_sleep();						\
 		lock_sock(__sk);					\
 		__rc = __condition;					\
 		__rc;							\
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0a68d5ae584e..30fedaf3e56a 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -97,16 +97,19 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	long state = p->state;
 
 #ifdef CONFIG_PREEMPT
+#ifdef CONFIG_SCHED_DEBUG
+	BUG_ON(p != current);
+#endif /* CONFIG_SCHED_DEBUG */
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_preempt_count(p) & PREEMPT_ACTIVE)
+	if (preempt_count() & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
-#endif
+#endif /* CONFIG_PREEMPT */
 
 	return state;
 }
-#endif
+#endif /* CREATE_TRACE_POINTS */
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index b932be9f5c5b..cc89ddefa926 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -23,8 +23,8 @@
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
 /* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
    and is now available for re-use. */
-#define CLONE_NEWUTS		0x04000000	/* New utsname group? */
-#define CLONE_NEWIPC		0x08000000	/* New ipcs */
+#define CLONE_NEWUTS		0x04000000	/* New utsname namespace */
+#define CLONE_NEWIPC		0x08000000	/* New ipc namespace */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
 #define CLONE_NEWPID		0x20000000	/* New pid namespace */
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
diff --git a/kernel/audit.c b/kernel/audit.c
index 80983df92cd4..32bfc43ffb9a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -499,7 +499,6 @@ static int kauditd_thread(void *dummy)
 	set_freezable();
 	while (!kthread_should_stop()) {
 		struct sk_buff *skb;
-		DECLARE_WAITQUEUE(wait, current);
 
 		flush_hold_queue();
 
@@ -514,16 +513,8 @@ static int kauditd_thread(void *dummy)
 				audit_printk_skb(skb);
 			continue;
 		}
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&kauditd_wait, &wait);
 
-		if (!skb_queue_len(&audit_skb_queue)) {
-			try_to_freeze();
-			schedule();
-		}
-
-		__set_current_state(TASK_RUNNING);
-		remove_wait_queue(&kauditd_wait, &wait);
+		wait_event_freezable(kauditd_wait, skb_queue_len(&audit_skb_queue));
 	}
 	return 0;
 }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1f107c74087b..723cfc9d0ad7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -506,6 +506,16 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 			goto out;
 	}
 
+	/*
+	 * We can't shrink if we won't have enough room for SCHED_DEADLINE
+	 * tasks.
+	 */
+	ret = -EBUSY;
+	if (is_cpu_exclusive(cur) &&
+	    !cpuset_cpumask_can_shrink(cur->cpus_allowed,
+				       trial->cpus_allowed))
+		goto out;
+
 	ret = 0;
 out:
 	rcu_read_unlock();
@@ -1429,17 +1439,8 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, tset) {
-		/*
-		 * Kthreads which disallow setaffinity shouldn't be moved
-		 * to a new cpuset; we don't want to change their cpu
-		 * affinity and isolating such threads by their set of
-		 * allowed nodes is unnecessary.  Thus, cpusets are not
-		 * applicable for such threads.  This prevents checking for
-		 * success of set_cpus_allowed_ptr() on all attached tasks
-		 * before cpus_allowed may be changed.
-		 */
-		ret = -EINVAL;
-		if (task->flags & PF_NO_SETAFFINITY)
+		ret = task_can_attach(task, cs->cpus_allowed);
+		if (ret)
 			goto out_unlock;
 		ret = security_task_setscheduler(task);
 		if (ret)
diff --git a/kernel/exit.c b/kernel/exit.c
index 5d30019ff953..232c4bc8bcc9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -997,6 +997,8 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
+		sched_annotate_sleep();
+
 		if ((exit_code & 0x7f) == 0) {
 			why = CLD_EXITED;
 			status = exit_code >> 8;
@@ -1079,6 +1081,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 * thread can reap it because we its state == DEAD/TRACE.
 	 */
 	read_unlock(&tasklist_lock);
+	sched_annotate_sleep();
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
@@ -1210,6 +1213,7 @@ static int wait_task_stopped(struct wait_opts *wo,
 	pid = task_pid_vnr(p);
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
+	sched_annotate_sleep();
 
 	if (unlikely(wo->wo_flags & WNOWAIT))
 		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
@@ -1272,6 +1276,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	pid = task_pid_vnr(p);
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
+	sched_annotate_sleep();
 
 	if (!wo->wo_info) {
 		retval = wo->wo_rusage
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index dadbf88c22c4..454195194d4a 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -378,8 +378,14 @@ static bool mutex_optimistic_spin(struct mutex *lock,
 	 * reschedule now, before we try-lock the mutex. This avoids getting
 	 * scheduled out right after we obtained the mutex.
 	 */
-	if (need_resched())
+	if (need_resched()) {
+		/*
+		 * We _should_ have TASK_RUNNING here, but just in case
+		 * we do not, make it so, otherwise we might get stuck.
+		 */
+		__set_current_state(TASK_RUNNING);
 		schedule_preempt_disabled();
+	}
 
 	return false;
 }
diff --git a/kernel/module.c b/kernel/module.c
index 88cec1ddb1e3..e52a8739361a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3097,6 +3097,32 @@ static int may_init_module(void)
 }
 
 /*
+ * Can't use wait_event_interruptible() because our condition
+ * 'finished_loading()' contains a blocking primitive itself (mutex_lock).
+ */
+static int wait_finished_loading(struct module *mod)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int ret = 0;
+
+	add_wait_queue(&module_wq, &wait);
+	for (;;) {
+		if (finished_loading(mod->name))
+			break;
+
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+	}
+	remove_wait_queue(&module_wq, &wait);
+
+	return ret;
+}
+
+/*
  * We try to place it in the list now to make sure it's unique before
  * we dedicate too many resources.  In particular, temporary percpu
  * memory exhaustion.
@@ -3116,8 +3142,8 @@ static int add_unformed_module(struct module *mod)
 		    || old->state == MODULE_STATE_UNFORMED) {
 			/* Wait in case it fails to load. */
 			mutex_unlock(&module_mutex);
-			err = wait_event_interruptible(module_wq,
-					       finished_loading(mod->name));
+
+			err = wait_finished_loading(mod);
 			if (err)
 				goto out_unlocked;
 			goto again;
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index a63f4dc27909..607f852b4d04 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -148,7 +148,7 @@ EXPORT_SYMBOL(wait_for_completion_timeout);
  *
  * This waits to be signaled for completion of a specific task. It is NOT
  * interruptible and there is no timeout. The caller is accounted as waiting
- * for IO.
+ * for IO (which traditionally means blkio only).
  */
 void __sched wait_for_completion_io(struct completion *x)
 {
@@ -163,7 +163,8 @@ EXPORT_SYMBOL(wait_for_completion_io);
  *
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. The timeout is in jiffies. It is not
- * interruptible. The caller is accounted as waiting for IO.
+ * interruptible. The caller is accounted as waiting for IO (which traditionally
+ * means blkio only).
  *
  * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
  * till timeout) if completed.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24beb9bb4c3e..88f49bc935ed 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1008,6 +1008,9 @@ inline int task_curr(const struct task_struct *p)
 	return cpu_curr(task_cpu(p)) == p;
 }
 
+/*
+ * Can drop rq->lock because from sched_class::switched_from() methods drop it.
+ */
 static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 				       const struct sched_class *prev_class,
 				       int oldprio)
@@ -1015,6 +1018,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 	if (prev_class != p->sched_class) {
 		if (prev_class->switched_from)
 			prev_class->switched_from(rq, p);
+		/* Possble rq->lock 'hole'.  */
 		p->sched_class->switched_to(rq, p);
 	} else if (oldprio != p->prio || dl_task(p))
 		p->sched_class->prio_changed(rq, p, oldprio);
@@ -1054,7 +1058,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * ttwu() will sort out the placement.
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
-			!(task_preempt_count(p) & PREEMPT_ACTIVE));
+			!p->on_rq);
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1407,7 +1411,8 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 static inline
 int select_task_rq(struct task_struct *p, int cpu, int sd_flags, int wake_flags)
 {
-	cpu = p->sched_class->select_task_rq(p, cpu, sd_flags, wake_flags);
+	if (p->nr_cpus_allowed > 1)
+		cpu = p->sched_class->select_task_rq(p, cpu, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -1623,8 +1628,10 @@ void wake_up_if_idle(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	if (!is_idle_task(rq->curr))
-		return;
+	rcu_read_lock();
+
+	if (!is_idle_task(rcu_dereference(rq->curr)))
+		goto out;
 
 	if (set_nr_if_polling(rq->idle)) {
 		trace_sched_wake_idle_without_ipi(cpu);
@@ -1635,6 +1642,9 @@ void wake_up_if_idle(int cpu)
 		/* Else cpu is not in idle, do nothing here */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
+
+out:
+	rcu_read_unlock();
 }
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
@@ -1853,12 +1863,10 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
-	p->numa_faults_memory = NULL;
-	p->numa_faults_buffer_memory = NULL;
+	p->numa_faults = NULL;
 	p->last_task_numa_placement = 0;
 	p->last_sum_exec_runtime = 0;
 
-	INIT_LIST_HEAD(&p->numa_entry);
 	p->numa_group = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
 }
@@ -2034,25 +2042,6 @@ static inline int dl_bw_cpus(int i)
 }
 #endif
 
-static inline
-void __dl_clear(struct dl_bw *dl_b, u64 tsk_bw)
-{
-	dl_b->total_bw -= tsk_bw;
-}
-
-static inline
-void __dl_add(struct dl_bw *dl_b, u64 tsk_bw)
-{
-	dl_b->total_bw += tsk_bw;
-}
-
-static inline
-bool __dl_overflow(struct dl_bw *dl_b, int cpus, u64 old_bw, u64 new_bw)
-{
-	return dl_b->bw != -1 &&
-	       dl_b->bw * cpus < dl_b->total_bw - old_bw + new_bw;
-}
-
 /*
  * We must be sure that accepting a new task (or allowing changing the
  * parameters of an existing one) is consistent with the bandwidth
@@ -2220,7 +2209,6 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 
 /**
  * finish_task_switch - clean up after a task-switch
- * @rq: runqueue associated with task-switch
  * @prev: the thread we just switched away from.
  *
  * finish_task_switch must be called after the context switch, paired
@@ -2232,10 +2220,16 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * so, we finish that here outside of the runqueue lock. (Doing it
  * with the lock held can cause deadlocks; see schedule() for
  * details.)
+ *
+ * The context switch have flipped the stack from under us and restored the
+ * local variables which were saved when this task called schedule() in the
+ * past. prev == current is still correct but we need to recalculate this_rq
+ * because prev may have moved to another CPU.
  */
-static void finish_task_switch(struct rq *rq, struct task_struct *prev)
+static struct rq *finish_task_switch(struct task_struct *prev)
 	__releases(rq->lock)
 {
+	struct rq *rq = this_rq();
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
 
@@ -2275,6 +2269,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	}
 
 	tick_nohz_task_switch(current);
+	return rq;
 }
 
 #ifdef CONFIG_SMP
@@ -2309,25 +2304,22 @@ static inline void post_schedule(struct rq *rq)
 asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	__releases(rq->lock)
 {
-	struct rq *rq = this_rq();
-
-	finish_task_switch(rq, prev);
+	struct rq *rq;
 
-	/*
-	 * FIXME: do we need to worry about rq being invalidated by the
-	 * task_switch?
-	 */
+	/* finish_task_switch() drops rq->lock and enables preemtion */
+	preempt_disable();
+	rq = finish_task_switch(prev);
 	post_schedule(rq);
+	preempt_enable();
 
 	if (current->set_child_tid)
 		put_user(task_pid_vnr(current), current->set_child_tid);
 }
 
 /*
- * context_switch - switch to the new MM and the new
- * thread's register state.
+ * context_switch - switch to the new MM and the new thread's register state.
  */
-static inline void
+static inline struct rq *
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
@@ -2366,14 +2358,9 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	context_tracking_task_switch(prev, next);
 	/* Here we just switch the register state and the stack. */
 	switch_to(prev, next, prev);
-
 	barrier();
-	/*
-	 * this_rq must be evaluated again because prev may have moved
-	 * CPUs since it called schedule(), thus the 'rq' on its stack
-	 * frame will be invalid.
-	 */
-	finish_task_switch(this_rq(), prev);
+
+	return finish_task_switch(prev);
 }
 
 /*
@@ -2826,15 +2813,8 @@ static void __sched __schedule(void)
 		rq->curr = next;
 		++*switch_count;
 
-		context_switch(rq, prev, next); /* unlocks the rq */
-		/*
-		 * The context switch have flipped the stack from under us
-		 * and restored the local variables which were saved when
-		 * this task called schedule() in the past. prev == current
-		 * is still correct, but it can be moved to another cpu/rq.
-		 */
-		cpu = smp_processor_id();
-		rq = cpu_rq(cpu);
+		rq = context_switch(rq, prev, next); /* unlocks the rq */
+		cpu = cpu_of(rq);
 	} else
 		raw_spin_unlock_irq(&rq->lock);
 
@@ -4649,6 +4629,81 @@ void init_idle(struct task_struct *idle, int cpu)
 #endif
 }
 
+int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+			      const struct cpumask *trial)
+{
+	int ret = 1, trial_cpus;
+	struct dl_bw *cur_dl_b;
+	unsigned long flags;
+
+	rcu_read_lock_sched();
+	cur_dl_b = dl_bw_of(cpumask_any(cur));
+	trial_cpus = cpumask_weight(trial);
+
+	raw_spin_lock_irqsave(&cur_dl_b->lock, flags);
+	if (cur_dl_b->bw != -1 &&
+	    cur_dl_b->bw * trial_cpus < cur_dl_b->total_bw)
+		ret = 0;
+	raw_spin_unlock_irqrestore(&cur_dl_b->lock, flags);
+	rcu_read_unlock_sched();
+
+	return ret;
+}
+
+int task_can_attach(struct task_struct *p,
+		    const struct cpumask *cs_cpus_allowed)
+{
+	int ret = 0;
+
+	/*
+	 * Kthreads which disallow setaffinity shouldn't be moved
+	 * to a new cpuset; we don't want to change their cpu
+	 * affinity and isolating such threads by their set of
+	 * allowed nodes is unnecessary.  Thus, cpusets are not
+	 * applicable for such threads.  This prevents checking for
+	 * success of set_cpus_allowed_ptr() on all attached tasks
+	 * before cpus_allowed may be changed.
+	 */
+	if (p->flags & PF_NO_SETAFFINITY) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+#ifdef CONFIG_SMP
+	if (dl_task(p) && !cpumask_intersects(task_rq(p)->rd->span,
+					      cs_cpus_allowed)) {
+		unsigned int dest_cpu = cpumask_any_and(cpu_active_mask,
+							cs_cpus_allowed);
+		struct dl_bw *dl_b;
+		bool overflow;
+		int cpus;
+		unsigned long flags;
+
+		rcu_read_lock_sched();
+		dl_b = dl_bw_of(dest_cpu);
+		raw_spin_lock_irqsave(&dl_b->lock, flags);
+		cpus = dl_bw_cpus(dest_cpu);
+		overflow = __dl_overflow(dl_b, cpus, 0, p->dl.dl_bw);
+		if (overflow)
+			ret = -EBUSY;
+		else {
+			/*
+			 * We reserve space for this task in the destination
+			 * root_domain, as we can't fail after this point.
+			 * We will free resources in the source root_domain
+			 * later on (see set_cpus_allowed_dl()).
+			 */
+			__dl_add(dl_b, p->dl.dl_bw);
+		}
+		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+		rcu_read_unlock_sched();
+
+	}
+#endif
+out:
+	return ret;
+}
+
 #ifdef CONFIG_SMP
 /*
  * move_queued_task - move a queued task to new rq.
@@ -6099,7 +6154,9 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 
 #ifdef CONFIG_NUMA
 static int sched_domains_numa_levels;
+enum numa_topology_type sched_numa_topology_type;
 static int *sched_domains_numa_distance;
+int sched_max_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
 static int sched_domains_curr_level;
 #endif
@@ -6271,7 +6328,7 @@ static void sched_numa_warn(const char *str)
 	printk(KERN_WARNING "\n");
 }
 
-static bool find_numa_distance(int distance)
+bool find_numa_distance(int distance)
 {
 	int i;
 
@@ -6286,6 +6343,56 @@ static bool find_numa_distance(int distance)
 	return false;
 }
 
+/*
+ * A system can have three types of NUMA topology:
+ * NUMA_DIRECT: all nodes are directly connected, or not a NUMA system
+ * NUMA_GLUELESS_MESH: some nodes reachable through intermediary nodes
+ * NUMA_BACKPLANE: nodes can reach other nodes through a backplane
+ *
+ * The difference between a glueless mesh topology and a backplane
+ * topology lies in whether communication between not directly
+ * connected nodes goes through intermediary nodes (where programs
+ * could run), or through backplane controllers. This affects
+ * placement of programs.
+ *
+ * The type of topology can be discerned with the following tests:
+ * - If the maximum distance between any nodes is 1 hop, the system
+ *   is directly connected.
+ * - If for two nodes A and B, located N > 1 hops away from each other,
+ *   there is an intermediary node C, which is < N hops away from both
+ *   nodes A and B, the system is a glueless mesh.
+ */
+static void init_numa_topology_type(void)
+{
+	int a, b, c, n;
+
+	n = sched_max_numa_distance;
+
+	if (n <= 1)
+		sched_numa_topology_type = NUMA_DIRECT;
+
+	for_each_online_node(a) {
+		for_each_online_node(b) {
+			/* Find two nodes furthest removed from each other. */
+			if (node_distance(a, b) < n)
+				continue;
+
+			/* Is there an intermediary node between a and b? */
+			for_each_online_node(c) {
+				if (node_distance(a, c) < n &&
+				    node_distance(b, c) < n) {
+					sched_numa_topology_type =
+							NUMA_GLUELESS_MESH;
+					return;
+				}
+			}
+
+			sched_numa_topology_type = NUMA_BACKPLANE;
+			return;
+		}
+	}
+}
+
 static void sched_init_numa(void)
 {
 	int next_distance, curr_distance = node_distance(0, 0);
@@ -6422,6 +6529,9 @@ static void sched_init_numa(void)
 	sched_domain_topology = tl;
 
 	sched_domains_numa_levels = level;
+	sched_max_numa_distance = sched_domains_numa_distance[level - 1];
+
+	init_numa_topology_type();
 }
 
 static void sched_domains_numa_masks_set(int cpu)
@@ -7174,6 +7284,25 @@ static inline int preempt_count_equals(int preempt_offset)
 
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
+	/*
+	 * Blocking primitives will set (and therefore destroy) current->state,
+	 * since we will exit with TASK_RUNNING make sure we enter with it,
+	 * otherwise we will destroy state.
+	 */
+	if (WARN_ONCE(current->state != TASK_RUNNING,
+			"do not call blocking ops when !TASK_RUNNING; "
+			"state=%lx set at [<%p>] %pS\n",
+			current->state,
+			(void *)current->task_state_change,
+			(void *)current->task_state_change))
+		__set_current_state(TASK_RUNNING);
+
+	___might_sleep(file, line, preempt_offset);
+}
+EXPORT_SYMBOL(__might_sleep);
+
+void ___might_sleep(const char *file, int line, int preempt_offset)
+{
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
@@ -7205,7 +7334,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 #endif
 	dump_stack();
 }
-EXPORT_SYMBOL(__might_sleep);
+EXPORT_SYMBOL(___might_sleep);
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 538c9796ad4a..020039bd1326 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -25,9 +25,6 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
 int cpudl_init(struct cpudl *cp);
 void cpudl_cleanup(struct cpudl *cp);
-#else
-#define cpudl_set(cp, cpu, dl) do { } while (0)
-#define cpudl_init() do { } while (0)
 #endif /* CONFIG_SMP */
 
 #endif /* _LINUX_CPUDL_H */
diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
index 6b033347fdfd..63cbb9ca0496 100644
--- a/kernel/sched/cpupri.h
+++ b/kernel/sched/cpupri.h
@@ -26,9 +26,6 @@ int  cpupri_find(struct cpupri *cp,
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
 int cpupri_init(struct cpupri *cp);
 void cpupri_cleanup(struct cpupri *cp);
-#else
-#define cpupri_set(cp, cpu, pri) do { } while (0)
-#define cpupri_init() do { } while (0)
 #endif
 
 #endif /* _LINUX_CPUPRI_H */
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 28fa9d9e9201..e5db8c6feebd 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -563,11 +563,6 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
 {
 	struct hrtimer *timer = &dl_se->dl_timer;
 
-	if (hrtimer_active(timer)) {
-		hrtimer_try_to_cancel(timer);
-		return;
-	}
-
 	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	timer->function = dl_task_timer;
 }
@@ -633,7 +628,7 @@ static void update_curr_dl(struct rq *rq)
 
 	sched_rt_avg_update(rq, delta_exec);
 
-	dl_se->runtime -= delta_exec;
+	dl_se->runtime -= dl_se->dl_yielded ? 0 : delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
 		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
@@ -933,7 +928,7 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
-	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
+	if (sd_flag != SD_BALANCE_WAKE)
 		goto out;
 
 	rq = cpu_rq(cpu);
@@ -1018,6 +1013,10 @@ static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 {
 	hrtick_start(rq, p->dl.runtime);
 }
+#else /* !CONFIG_SCHED_HRTICK */
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+}
 #endif
 
 static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
@@ -1071,10 +1070,8 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 	/* Running task will never be pushed. */
        dequeue_pushable_dl_task(rq, p);
 
-#ifdef CONFIG_SCHED_HRTICK
 	if (hrtick_enabled(rq))
 		start_hrtick_dl(rq, p);
-#endif
 
 	set_post_schedule(rq);
 
@@ -1093,10 +1090,8 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
 {
 	update_curr_dl(rq);
 
-#ifdef CONFIG_SCHED_HRTICK
 	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
 		start_hrtick_dl(rq, p);
-#endif
 }
 
 static void task_fork_dl(struct task_struct *p)
@@ -1333,6 +1328,7 @@ static int push_dl_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *later_rq;
+	int ret = 0;
 
 	if (!rq->dl.overloaded)
 		return 0;
@@ -1378,7 +1374,6 @@ static int push_dl_task(struct rq *rq)
 			 * The task is still there. We don't try
 			 * again, some other cpu will pull it when ready.
 			 */
-			dequeue_pushable_dl_task(rq, next_task);
 			goto out;
 		}
 
@@ -1394,6 +1389,7 @@ static int push_dl_task(struct rq *rq)
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, later_rq->cpu);
 	activate_task(later_rq, next_task, 0);
+	ret = 1;
 
 	resched_curr(later_rq);
 
@@ -1402,7 +1398,7 @@ static int push_dl_task(struct rq *rq)
 out:
 	put_task_struct(next_task);
 
-	return 1;
+	return ret;
 }
 
 static void push_dl_tasks(struct rq *rq)
@@ -1508,7 +1504,7 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
 	    p->nr_cpus_allowed > 1 &&
 	    dl_task(rq->curr) &&
 	    (rq->curr->nr_cpus_allowed < 2 ||
-	     dl_entity_preempt(&rq->curr->dl, &p->dl))) {
+	     !dl_entity_preempt(&p->dl, &rq->curr->dl))) {
 		push_dl_tasks(rq);
 	}
 }
@@ -1517,10 +1513,33 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 				const struct cpumask *new_mask)
 {
 	struct rq *rq;
+	struct root_domain *src_rd;
 	int weight;
 
 	BUG_ON(!dl_task(p));
 
+	rq = task_rq(p);
+	src_rd = rq->rd;
+	/*
+	 * Migrating a SCHED_DEADLINE task between exclusive
+	 * cpusets (different root_domains) entails a bandwidth
+	 * update. We already made space for us in the destination
+	 * domain (see cpuset_can_attach()).
+	 */
+	if (!cpumask_intersects(src_rd->span, new_mask)) {
+		struct dl_bw *src_dl_b;
+
+		src_dl_b = dl_bw_of(cpu_of(rq));
+		/*
+		 * We now free resources of the root_domain we are migrating
+		 * off. In the worst case, sched_setattr() may temporary fail
+		 * until we complete the update.
+		 */
+		raw_spin_lock(&src_dl_b->lock);
+		__dl_clear(src_dl_b, p->dl.dl_bw);
+		raw_spin_unlock(&src_dl_b->lock);
+	}
+
 	/*
 	 * Update only if the task is actually running (i.e.,
 	 * it is on the rq AND it is not throttled).
@@ -1537,8 +1556,6 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	if ((p->nr_cpus_allowed > 1) == (weight > 1))
 		return;
 
-	rq = task_rq(p);
-
 	/*
 	 * The process used to be able to migrate OR it can now migrate
 	 */
@@ -1586,22 +1603,48 @@ void init_sched_dl_class(void)
 
 #endif /* CONFIG_SMP */
 
+/*
+ *  Ensure p's dl_timer is cancelled. May drop rq->lock for a while.
+ */
+static void cancel_dl_timer(struct rq *rq, struct task_struct *p)
+{
+	struct hrtimer *dl_timer = &p->dl.dl_timer;
+
+	/* Nobody will change task's class if pi_lock is held */
+	lockdep_assert_held(&p->pi_lock);
+
+	if (hrtimer_active(dl_timer)) {
+		int ret = hrtimer_try_to_cancel(dl_timer);
+
+		if (unlikely(ret == -1)) {
+			/*
+			 * Note, p may migrate OR new deadline tasks
+			 * may appear in rq when we are unlocking it.
+			 * A caller of us must be fine with that.
+			 */
+			raw_spin_unlock(&rq->lock);
+			hrtimer_cancel(dl_timer);
+			raw_spin_lock(&rq->lock);
+		}
+	}
+}
+
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
-	if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
-		hrtimer_try_to_cancel(&p->dl.dl_timer);
+	cancel_dl_timer(rq, p);
 
 	__dl_clear_params(p);
 
-#ifdef CONFIG_SMP
 	/*
 	 * Since this might be the only -deadline task on the rq,
 	 * this is the right place to try to pull some other one
 	 * from an overloaded cpu, if any.
 	 */
-	if (!rq->dl.dl_nr_running)
-		pull_dl_task(rq);
-#endif
+	if (!task_on_rq_queued(p) || rq->dl.dl_nr_running)
+		return;
+
+	if (pull_dl_task(rq))
+		resched_curr(rq);
 }
 
 /*
@@ -1622,7 +1665,8 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 
 	if (task_on_rq_queued(p) && rq->curr != p) {
 #ifdef CONFIG_SMP
-		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
+		if (p->nr_cpus_allowed > 1 && rq->dl.overloaded &&
+			push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */
 			check_resched = 0;
 #endif /* CONFIG_SMP */
@@ -1704,3 +1748,12 @@ const struct sched_class dl_sched_class = {
 
 	.update_curr		= update_curr_dl,
 };
+
+#ifdef CONFIG_SCHED_DEBUG
+extern void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
+
+void print_dl_stats(struct seq_file *m, int cpu)
+{
+	print_dl_rq(m, cpu, &cpu_rq(cpu)->dl);
+}
+#endif /* CONFIG_SCHED_DEBUG */
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ce33780d8f20..92cc52001e74 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -261,6 +261,12 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 #undef P
 }
 
+void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
+{
+	SEQ_printf(m, "\ndl_rq[%d]:\n", cpu);
+	SEQ_printf(m, "  .%-30s: %ld\n", "dl_nr_running", dl_rq->dl_nr_running);
+}
+
 extern __read_mostly int sched_clock_running;
 
 static void print_cpu(struct seq_file *m, int cpu)
@@ -329,6 +335,7 @@ do {									\
 	spin_lock_irqsave(&sched_debug_lock, flags);
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
+	print_dl_stats(m, cpu);
 
 	print_rq(m, rq, cpu);
 	spin_unlock_irqrestore(&sched_debug_lock, flags);
@@ -528,8 +535,8 @@ static void sched_show_numa(struct task_struct *p, struct seq_file *m)
 			unsigned long nr_faults = -1;
 			int cpu_current, home_node;
 
-			if (p->numa_faults_memory)
-				nr_faults = p->numa_faults_memory[2*node + i];
+			if (p->numa_faults)
+				nr_faults = p->numa_faults[2*node + i];
 
 			cpu_current = !i ? (task_node(p) == node) :
 				(pol && node_isset(node, pol->v.nodes));
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ef2b104b254c..df2cdf77f899 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -873,7 +873,6 @@ struct numa_group {
 	spinlock_t lock; /* nr_tasks, tasks */
 	int nr_tasks;
 	pid_t gid;
-	struct list_head task_list;
 
 	struct rcu_head rcu;
 	nodemask_t active_nodes;
@@ -901,18 +900,24 @@ pid_t task_numa_group_id(struct task_struct *p)
 	return p->numa_group ? p->numa_group->gid : 0;
 }
 
-static inline int task_faults_idx(int nid, int priv)
+/*
+ * The averaged statistics, shared & private, memory & cpu,
+ * occupy the first half of the array. The second half of the
+ * array is for current counters, which are averaged into the
+ * first set by task_numa_placement.
+ */
+static inline int task_faults_idx(enum numa_faults_stats s, int nid, int priv)
 {
-	return NR_NUMA_HINT_FAULT_TYPES * nid + priv;
+	return NR_NUMA_HINT_FAULT_TYPES * (s * nr_node_ids + nid) + priv;
 }
 
 static inline unsigned long task_faults(struct task_struct *p, int nid)
 {
-	if (!p->numa_faults_memory)
+	if (!p->numa_faults)
 		return 0;
 
-	return p->numa_faults_memory[task_faults_idx(nid, 0)] +
-		p->numa_faults_memory[task_faults_idx(nid, 1)];
+	return p->numa_faults[task_faults_idx(NUMA_MEM, nid, 0)] +
+		p->numa_faults[task_faults_idx(NUMA_MEM, nid, 1)];
 }
 
 static inline unsigned long group_faults(struct task_struct *p, int nid)
@@ -920,14 +925,79 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
 	if (!p->numa_group)
 		return 0;
 
-	return p->numa_group->faults[task_faults_idx(nid, 0)] +
-		p->numa_group->faults[task_faults_idx(nid, 1)];
+	return p->numa_group->faults[task_faults_idx(NUMA_MEM, nid, 0)] +
+		p->numa_group->faults[task_faults_idx(NUMA_MEM, nid, 1)];
 }
 
 static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
 {
-	return group->faults_cpu[task_faults_idx(nid, 0)] +
-		group->faults_cpu[task_faults_idx(nid, 1)];
+	return group->faults_cpu[task_faults_idx(NUMA_MEM, nid, 0)] +
+		group->faults_cpu[task_faults_idx(NUMA_MEM, nid, 1)];
+}
+
+/* Handle placement on systems where not all nodes are directly connected. */
+static unsigned long score_nearby_nodes(struct task_struct *p, int nid,
+					int maxdist, bool task)
+{
+	unsigned long score = 0;
+	int node;
+
+	/*
+	 * All nodes are directly connected, and the same distance
+	 * from each other. No need for fancy placement algorithms.
+	 */
+	if (sched_numa_topology_type == NUMA_DIRECT)
+		return 0;
+
+	/*
+	 * This code is called for each node, introducing N^2 complexity,
+	 * which should be ok given the number of nodes rarely exceeds 8.
+	 */
+	for_each_online_node(node) {
+		unsigned long faults;
+		int dist = node_distance(nid, node);
+
+		/*
+		 * The furthest away nodes in the system are not interesting
+		 * for placement; nid was already counted.
+		 */
+		if (dist == sched_max_numa_distance || node == nid)
+			continue;
+
+		/*
+		 * On systems with a backplane NUMA topology, compare groups
+		 * of nodes, and move tasks towards the group with the most
+		 * memory accesses. When comparing two nodes at distance
+		 * "hoplimit", only nodes closer by than "hoplimit" are part
+		 * of each group. Skip other nodes.
+		 */
+		if (sched_numa_topology_type == NUMA_BACKPLANE &&
+					dist > maxdist)
+			continue;
+
+		/* Add up the faults from nearby nodes. */
+		if (task)
+			faults = task_faults(p, node);
+		else
+			faults = group_faults(p, node);
+
+		/*
+		 * On systems with a glueless mesh NUMA topology, there are
+		 * no fixed "groups of nodes". Instead, nodes that are not
+		 * directly connected bounce traffic through intermediate
+		 * nodes; a numa_group can occupy any set of nodes.
+		 * The further away a node is, the less the faults count.
+		 * This seems to result in good task placement.
+		 */
+		if (sched_numa_topology_type == NUMA_GLUELESS_MESH) {
+			faults *= (sched_max_numa_distance - dist);
+			faults /= (sched_max_numa_distance - LOCAL_DISTANCE);
+		}
+
+		score += faults;
+	}
+
+	return score;
 }
 
 /*
@@ -936,11 +1006,12 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
  * larger multiplier, in order to group tasks together that are almost
  * evenly spread out between numa nodes.
  */
-static inline unsigned long task_weight(struct task_struct *p, int nid)
+static inline unsigned long task_weight(struct task_struct *p, int nid,
+					int dist)
 {
-	unsigned long total_faults;
+	unsigned long faults, total_faults;
 
-	if (!p->numa_faults_memory)
+	if (!p->numa_faults)
 		return 0;
 
 	total_faults = p->total_numa_faults;
@@ -948,15 +1019,29 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 	if (!total_faults)
 		return 0;
 
-	return 1000 * task_faults(p, nid) / total_faults;
+	faults = task_faults(p, nid);
+	faults += score_nearby_nodes(p, nid, dist, true);
+
+	return 1000 * faults / total_faults;
 }
 
-static inline unsigned long group_weight(struct task_struct *p, int nid)
+static inline unsigned long group_weight(struct task_struct *p, int nid,
+					 int dist)
 {
-	if (!p->numa_group || !p->numa_group->total_faults)
+	unsigned long faults, total_faults;
+
+	if (!p->numa_group)
 		return 0;
 
-	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
+	total_faults = p->numa_group->total_faults;
+
+	if (!total_faults)
+		return 0;
+
+	faults = group_faults(p, nid);
+	faults += score_nearby_nodes(p, nid, dist, false);
+
+	return 1000 * faults / total_faults;
 }
 
 bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
@@ -1089,6 +1174,7 @@ struct task_numa_env {
 	struct numa_stats src_stats, dst_stats;
 
 	int imbalance_pct;
+	int dist;
 
 	struct task_struct *best_task;
 	long best_imp;
@@ -1168,6 +1254,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	long load;
 	long imp = env->p->numa_group ? groupimp : taskimp;
 	long moveimp = imp;
+	int dist = env->dist;
 
 	rcu_read_lock();
 
@@ -1208,8 +1295,8 @@ static void task_numa_compare(struct task_numa_env *env,
 		 * in any group then look only at task weights.
 		 */
 		if (cur->numa_group == env->p->numa_group) {
-			imp = taskimp + task_weight(cur, env->src_nid) -
-			      task_weight(cur, env->dst_nid);
+			imp = taskimp + task_weight(cur, env->src_nid, dist) -
+			      task_weight(cur, env->dst_nid, dist);
 			/*
 			 * Add some hysteresis to prevent swapping the
 			 * tasks within a group over tiny differences.
@@ -1223,11 +1310,11 @@ static void task_numa_compare(struct task_numa_env *env,
 			 * instead.
 			 */
 			if (cur->numa_group)
-				imp += group_weight(cur, env->src_nid) -
-				       group_weight(cur, env->dst_nid);
+				imp += group_weight(cur, env->src_nid, dist) -
+				       group_weight(cur, env->dst_nid, dist);
 			else
-				imp += task_weight(cur, env->src_nid) -
-				       task_weight(cur, env->dst_nid);
+				imp += task_weight(cur, env->src_nid, dist) -
+				       task_weight(cur, env->dst_nid, dist);
 		}
 	}
 
@@ -1326,7 +1413,7 @@ static int task_numa_migrate(struct task_struct *p)
 	};
 	struct sched_domain *sd;
 	unsigned long taskweight, groupweight;
-	int nid, ret;
+	int nid, ret, dist;
 	long taskimp, groupimp;
 
 	/*
@@ -1354,29 +1441,45 @@ static int task_numa_migrate(struct task_struct *p)
 		return -EINVAL;
 	}
 
-	taskweight = task_weight(p, env.src_nid);
-	groupweight = group_weight(p, env.src_nid);
-	update_numa_stats(&env.src_stats, env.src_nid);
 	env.dst_nid = p->numa_preferred_nid;
-	taskimp = task_weight(p, env.dst_nid) - taskweight;
-	groupimp = group_weight(p, env.dst_nid) - groupweight;
+	dist = env.dist = node_distance(env.src_nid, env.dst_nid);
+	taskweight = task_weight(p, env.src_nid, dist);
+	groupweight = group_weight(p, env.src_nid, dist);
+	update_numa_stats(&env.src_stats, env.src_nid);
+	taskimp = task_weight(p, env.dst_nid, dist) - taskweight;
+	groupimp = group_weight(p, env.dst_nid, dist) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
 	/* Try to find a spot on the preferred nid. */
 	task_numa_find_cpu(&env, taskimp, groupimp);
 
-	/* No space available on the preferred nid. Look elsewhere. */
-	if (env.best_cpu == -1) {
+	/*
+	 * Look at other nodes in these cases:
+	 * - there is no space available on the preferred_nid
+	 * - the task is part of a numa_group that is interleaved across
+	 *   multiple NUMA nodes; in order to better consolidate the group,
+	 *   we need to check other locations.
+	 */
+	if (env.best_cpu == -1 || (p->numa_group &&
+			nodes_weight(p->numa_group->active_nodes) > 1)) {
 		for_each_online_node(nid) {
 			if (nid == env.src_nid || nid == p->numa_preferred_nid)
 				continue;
 
+			dist = node_distance(env.src_nid, env.dst_nid);
+			if (sched_numa_topology_type == NUMA_BACKPLANE &&
+						dist != env.dist) {
+				taskweight = task_weight(p, env.src_nid, dist);
+				groupweight = group_weight(p, env.src_nid, dist);
+			}
+
 			/* Only consider nodes where both task and groups benefit */
-			taskimp = task_weight(p, nid) - taskweight;
-			groupimp = group_weight(p, nid) - groupweight;
+			taskimp = task_weight(p, nid, dist) - taskweight;
+			groupimp = group_weight(p, nid, dist) - groupweight;
 			if (taskimp < 0 && groupimp < 0)
 				continue;
 
+			env.dist = dist;
 			env.dst_nid = nid;
 			update_numa_stats(&env.dst_stats, env.dst_nid);
 			task_numa_find_cpu(&env, taskimp, groupimp);
@@ -1431,7 +1534,7 @@ static void numa_migrate_preferred(struct task_struct *p)
 	unsigned long interval = HZ;
 
 	/* This task has no NUMA fault statistics yet */
-	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults_memory))
+	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults))
 		return;
 
 	/* Periodically retry migrating the task to the preferred node */
@@ -1580,6 +1683,92 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
 	return delta;
 }
 
+/*
+ * Determine the preferred nid for a task in a numa_group. This needs to
+ * be done in a way that produces consistent results with group_weight,
+ * otherwise workloads might not converge.
+ */
+static int preferred_group_nid(struct task_struct *p, int nid)
+{
+	nodemask_t nodes;
+	int dist;
+
+	/* Direct connections between all NUMA nodes. */
+	if (sched_numa_topology_type == NUMA_DIRECT)
+		return nid;
+
+	/*
+	 * On a system with glueless mesh NUMA topology, group_weight
+	 * scores nodes according to the number of NUMA hinting faults on
+	 * both the node itself, and on nearby nodes.
+	 */
+	if (sched_numa_topology_type == NUMA_GLUELESS_MESH) {
+		unsigned long score, max_score = 0;
+		int node, max_node = nid;
+
+		dist = sched_max_numa_distance;
+
+		for_each_online_node(node) {
+			score = group_weight(p, node, dist);
+			if (score > max_score) {
+				max_score = score;
+				max_node = node;
+			}
+		}
+		return max_node;
+	}
+
+	/*
+	 * Finding the preferred nid in a system with NUMA backplane
+	 * interconnect topology is more involved. The goal is to locate
+	 * tasks from numa_groups near each other in the system, and
+	 * untangle workloads from different sides of the system. This requires
+	 * searching down the hierarchy of node groups, recursively searching
+	 * inside the highest scoring group of nodes. The nodemask tricks
+	 * keep the complexity of the search down.
+	 */
+	nodes = node_online_map;
+	for (dist = sched_max_numa_distance; dist > LOCAL_DISTANCE; dist--) {
+		unsigned long max_faults = 0;
+		nodemask_t max_group;
+		int a, b;
+
+		/* Are there nodes at this distance from each other? */
+		if (!find_numa_distance(dist))
+			continue;
+
+		for_each_node_mask(a, nodes) {
+			unsigned long faults = 0;
+			nodemask_t this_group;
+			nodes_clear(this_group);
+
+			/* Sum group's NUMA faults; includes a==b case. */
+			for_each_node_mask(b, nodes) {
+				if (node_distance(a, b) < dist) {
+					faults += group_faults(p, b);
+					node_set(b, this_group);
+					node_clear(b, nodes);
+				}
+			}
+
+			/* Remember the top group. */
+			if (faults > max_faults) {
+				max_faults = faults;
+				max_group = this_group;
+				/*
+				 * subtle: at the smallest distance there is
+				 * just one node left in each "group", the
+				 * winner is the preferred nid.
+				 */
+				nid = a;
+			}
+		}
+		/* Next round, evaluate the nodes within max_group. */
+		nodes = max_group;
+	}
+	return nid;
+}
+
 static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1, max_group_nid = -1;
@@ -1607,18 +1796,23 @@ static void task_numa_placement(struct task_struct *p)
 
 	/* Find the node with the highest number of faults */
 	for_each_online_node(nid) {
+		/* Keep track of the offsets in numa_faults array */
+		int mem_idx, membuf_idx, cpu_idx, cpubuf_idx;
 		unsigned long faults = 0, group_faults = 0;
-		int priv, i;
+		int priv;
 
 		for (priv = 0; priv < NR_NUMA_HINT_FAULT_TYPES; priv++) {
 			long diff, f_diff, f_weight;
 
-			i = task_faults_idx(nid, priv);
+			mem_idx = task_faults_idx(NUMA_MEM, nid, priv);
+			membuf_idx = task_faults_idx(NUMA_MEMBUF, nid, priv);
+			cpu_idx = task_faults_idx(NUMA_CPU, nid, priv);
+			cpubuf_idx = task_faults_idx(NUMA_CPUBUF, nid, priv);
 
 			/* Decay existing window, copy faults since last scan */
-			diff = p->numa_faults_buffer_memory[i] - p->numa_faults_memory[i] / 2;
-			fault_types[priv] += p->numa_faults_buffer_memory[i];
-			p->numa_faults_buffer_memory[i] = 0;
+			diff = p->numa_faults[membuf_idx] - p->numa_faults[mem_idx] / 2;
+			fault_types[priv] += p->numa_faults[membuf_idx];
+			p->numa_faults[membuf_idx] = 0;
 
 			/*
 			 * Normalize the faults_from, so all tasks in a group
@@ -1628,21 +1822,27 @@ static void task_numa_placement(struct task_struct *p)
 			 * faults are less important.
 			 */
 			f_weight = div64_u64(runtime << 16, period + 1);
-			f_weight = (f_weight * p->numa_faults_buffer_cpu[i]) /
+			f_weight = (f_weight * p->numa_faults[cpubuf_idx]) /
 				   (total_faults + 1);
-			f_diff = f_weight - p->numa_faults_cpu[i] / 2;
-			p->numa_faults_buffer_cpu[i] = 0;
+			f_diff = f_weight - p->numa_faults[cpu_idx] / 2;
+			p->numa_faults[cpubuf_idx] = 0;
 
-			p->numa_faults_memory[i] += diff;
-			p->numa_faults_cpu[i] += f_diff;
-			faults += p->numa_faults_memory[i];
+			p->numa_faults[mem_idx] += diff;
+			p->numa_faults[cpu_idx] += f_diff;
+			faults += p->numa_faults[mem_idx];
 			p->total_numa_faults += diff;
 			if (p->numa_group) {
-				/* safe because we can only change our own group */
-				p->numa_group->faults[i] += diff;
-				p->numa_group->faults_cpu[i] += f_diff;
+				/*
+				 * safe because we can only change our own group
+				 *
+				 * mem_idx represents the offset for a given
+				 * nid and priv in a specific region because it
+				 * is at the beginning of the numa_faults array.
+				 */
+				p->numa_group->faults[mem_idx] += diff;
+				p->numa_group->faults_cpu[mem_idx] += f_diff;
 				p->numa_group->total_faults += diff;
-				group_faults += p->numa_group->faults[i];
+				group_faults += p->numa_group->faults[mem_idx];
 			}
 		}
 
@@ -1662,7 +1862,7 @@ static void task_numa_placement(struct task_struct *p)
 	if (p->numa_group) {
 		update_numa_active_node_mask(p->numa_group);
 		spin_unlock_irq(group_lock);
-		max_nid = max_group_nid;
+		max_nid = preferred_group_nid(p, max_group_nid);
 	}
 
 	if (max_faults) {
@@ -1705,7 +1905,6 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 		atomic_set(&grp->refcount, 1);
 		spin_lock_init(&grp->lock);
-		INIT_LIST_HEAD(&grp->task_list);
 		grp->gid = p->pid;
 		/* Second half of the array tracks nids where faults happen */
 		grp->faults_cpu = grp->faults + NR_NUMA_HINT_FAULT_TYPES *
@@ -1714,11 +1913,10 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		node_set(task_node(current), grp->active_nodes);
 
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
-			grp->faults[i] = p->numa_faults_memory[i];
+			grp->faults[i] = p->numa_faults[i];
 
 		grp->total_faults = p->total_numa_faults;
 
-		list_add(&p->numa_entry, &grp->task_list);
 		grp->nr_tasks++;
 		rcu_assign_pointer(p->numa_group, grp);
 	}
@@ -1773,13 +1971,12 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
-		my_grp->faults[i] -= p->numa_faults_memory[i];
-		grp->faults[i] += p->numa_faults_memory[i];
+		my_grp->faults[i] -= p->numa_faults[i];
+		grp->faults[i] += p->numa_faults[i];
 	}
 	my_grp->total_faults -= p->total_numa_faults;
 	grp->total_faults += p->total_numa_faults;
 
-	list_move(&p->numa_entry, &grp->task_list);
 	my_grp->nr_tasks--;
 	grp->nr_tasks++;
 
@@ -1799,27 +1996,23 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 void task_numa_free(struct task_struct *p)
 {
 	struct numa_group *grp = p->numa_group;
-	void *numa_faults = p->numa_faults_memory;
+	void *numa_faults = p->numa_faults;
 	unsigned long flags;
 	int i;
 
 	if (grp) {
 		spin_lock_irqsave(&grp->lock, flags);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
-			grp->faults[i] -= p->numa_faults_memory[i];
+			grp->faults[i] -= p->numa_faults[i];
 		grp->total_faults -= p->total_numa_faults;
 
-		list_del(&p->numa_entry);
 		grp->nr_tasks--;
 		spin_unlock_irqrestore(&grp->lock, flags);
 		RCU_INIT_POINTER(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
 
-	p->numa_faults_memory = NULL;
-	p->numa_faults_buffer_memory = NULL;
-	p->numa_faults_cpu= NULL;
-	p->numa_faults_buffer_cpu = NULL;
+	p->numa_faults = NULL;
 	kfree(numa_faults);
 }
 
@@ -1842,24 +2035,14 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
-	if (unlikely(!p->numa_faults_memory)) {
-		int size = sizeof(*p->numa_faults_memory) *
+	if (unlikely(!p->numa_faults)) {
+		int size = sizeof(*p->numa_faults) *
 			   NR_NUMA_HINT_FAULT_BUCKETS * nr_node_ids;
 
-		p->numa_faults_memory = kzalloc(size, GFP_KERNEL|__GFP_NOWARN);
-		if (!p->numa_faults_memory)
+		p->numa_faults = kzalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		if (!p->numa_faults)
 			return;
 
-		BUG_ON(p->numa_faults_buffer_memory);
-		/*
-		 * The averaged statistics, shared & private, memory & cpu,
-		 * occupy the first half of the array. The second half of the
-		 * array is for current counters, which are averaged into the
-		 * first set by task_numa_placement.
-		 */
-		p->numa_faults_cpu = p->numa_faults_memory + (2 * nr_node_ids);
-		p->numa_faults_buffer_memory = p->numa_faults_memory + (4 * nr_node_ids);
-		p->numa_faults_buffer_cpu = p->numa_faults_memory + (6 * nr_node_ids);
 		p->total_numa_faults = 0;
 		memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
 	}
@@ -1899,8 +2082,8 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (migrated)
 		p->numa_pages_migrated += pages;
 
-	p->numa_faults_buffer_memory[task_faults_idx(mem_node, priv)] += pages;
-	p->numa_faults_buffer_cpu[task_faults_idx(cpu_node, priv)] += pages;
+	p->numa_faults[task_faults_idx(NUMA_MEMBUF, mem_node, priv)] += pages;
+	p->numa_faults[task_faults_idx(NUMA_CPUBUF, cpu_node, priv)] += pages;
 	p->numa_faults_locality[local] += pages;
 }
 
@@ -4469,7 +4652,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 				latest_idle_timestamp = rq->idle_stamp;
 				shallowest_idle_cpu = i;
 			}
-		} else {
+		} else if (shallowest_idle_cpu == -1) {
 			load = weighted_cpuload(i);
 			if (load < min_load || (load == min_load && i == this_cpu)) {
 				min_load = load;
@@ -4547,9 +4730,6 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
 
-	if (p->nr_cpus_allowed == 1)
-		return prev_cpu;
-
 	if (sd_flag & SD_BALANCE_WAKE)
 		want_affine = cpumask_test_cpu(cpu, tsk_cpus_allowed(p));
 
@@ -5189,7 +5369,7 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 	struct numa_group *numa_group = rcu_dereference(p->numa_group);
 	int src_nid, dst_nid;
 
-	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults_memory ||
+	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults ||
 	    !(env->sd->flags & SD_NUMA)) {
 		return false;
 	}
@@ -5228,7 +5408,7 @@ static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	if (!sched_feat(NUMA) || !sched_feat(NUMA_RESIST_LOWER))
 		return false;
 
-	if (!p->numa_faults_memory || !(env->sd->flags & SD_NUMA))
+	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
 		return false;
 
 	src_nid = cpu_to_node(env->src_cpu);
@@ -6172,8 +6352,10 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_free_capacity)
+		    sds->local_stat.group_has_free_capacity) {
 			sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
+			sgs->group_type = group_classify(sg, sgs);
+		}
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 20bca398084a..ee15f5a0d1c1 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1301,9 +1301,6 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
-	if (p->nr_cpus_allowed == 1)
-		goto out;
-
 	/* For anything but wake ups, just return the task_cpu */
 	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
 		goto out;
@@ -1351,16 +1348,22 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	if (rq->curr->nr_cpus_allowed == 1)
+	/*
+	 * Current can't be migrated, useless to reschedule,
+	 * let's hope p can move out.
+	 */
+	if (rq->curr->nr_cpus_allowed == 1 ||
+	    !cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
 		return;
 
+	/*
+	 * p is migratable, so let's not schedule it and
+	 * see if it is pushed or pulled somewhere else.
+	 */
 	if (p->nr_cpus_allowed != 1
 	    && cpupri_find(&rq->rd->cpupri, p, NULL))
 		return;
 
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
-		return;
-
 	/*
 	 * There appears to be other cpus that can accept
 	 * current and none to run 'p', so lets reschedule
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 2df8ef067cc5..9a2a45c970e7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -176,6 +176,25 @@ struct dl_bw {
 	u64 bw, total_bw;
 };
 
+static inline
+void __dl_clear(struct dl_bw *dl_b, u64 tsk_bw)
+{
+	dl_b->total_bw -= tsk_bw;
+}
+
+static inline
+void __dl_add(struct dl_bw *dl_b, u64 tsk_bw)
+{
+	dl_b->total_bw += tsk_bw;
+}
+
+static inline
+bool __dl_overflow(struct dl_bw *dl_b, int cpus, u64 old_bw, u64 new_bw)
+{
+	return dl_b->bw != -1 &&
+	       dl_b->bw * cpus < dl_b->total_bw - old_bw + new_bw;
+}
+
 extern struct mutex sched_domains_mutex;
 
 #ifdef CONFIG_CGROUP_SCHED
@@ -678,7 +697,25 @@ static inline u64 rq_clock_task(struct rq *rq)
 	return rq->clock_task;
 }
 
+#ifdef CONFIG_NUMA
+enum numa_topology_type {
+	NUMA_DIRECT,
+	NUMA_GLUELESS_MESH,
+	NUMA_BACKPLANE,
+};
+extern enum numa_topology_type sched_numa_topology_type;
+extern int sched_max_numa_distance;
+extern bool find_numa_distance(int distance);
+#endif
+
 #ifdef CONFIG_NUMA_BALANCING
+/* The regions in numa_faults array from task_struct */
+enum numa_faults_stats {
+	NUMA_MEM = 0,
+	NUMA_CPU,
+	NUMA_MEMBUF,
+	NUMA_CPUBUF
+};
 extern void sched_setnuma(struct task_struct *p, int node);
 extern int migrate_task_to(struct task_struct *p, int cpu);
 extern int migrate_swap(struct task_struct *, struct task_struct *);
@@ -1127,6 +1164,11 @@ struct sched_class {
 	void (*task_fork) (struct task_struct *p);
 	void (*task_dead) (struct task_struct *p);
 
+	/*
+	 * The switched_from() call is allowed to drop rq->lock, therefore we
+	 * cannot assume the switched_from/switched_to pair is serliazed by
+	 * rq->lock. They are however serialized by p->pi_lock.
+	 */
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
@@ -1504,6 +1546,7 @@ extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
 extern struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq);
 extern void print_cfs_stats(struct seq_file *m, int cpu);
 extern void print_rt_stats(struct seq_file *m, int cpu);
+extern void print_dl_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 5a62915f47a8..852143a79f36 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/wait.h>
 #include <linux/hash.h>
+#include <linux/kthread.h>
 
 void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
 {
@@ -297,6 +298,71 @@ int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *
 }
 EXPORT_SYMBOL(autoremove_wake_function);
 
+static inline bool is_kthread_should_stop(void)
+{
+	return (current->flags & PF_KTHREAD) && kthread_should_stop();
+}
+
+/*
+ * DEFINE_WAIT_FUNC(wait, woken_wake_func);
+ *
+ * add_wait_queue(&wq, &wait);
+ * for (;;) {
+ *     if (condition)
+ *         break;
+ *
+ *     p->state = mode;				condition = true;
+ *     smp_mb(); // A				smp_wmb(); // C
+ *     if (!wait->flags & WQ_FLAG_WOKEN)	wait->flags |= WQ_FLAG_WOKEN;
+ *         schedule()				try_to_wake_up();
+ *     p->state = TASK_RUNNING;		    ~~~~~~~~~~~~~~~~~~
+ *     wait->flags &= ~WQ_FLAG_WOKEN;		condition = true;
+ *     smp_mb() // B				smp_wmb(); // C
+ *						wait->flags |= WQ_FLAG_WOKEN;
+ * }
+ * remove_wait_queue(&wq, &wait);
+ *
+ */
+long wait_woken(wait_queue_t *wait, unsigned mode, long timeout)
+{
+	set_current_state(mode); /* A */
+	/*
+	 * The above implies an smp_mb(), which matches with the smp_wmb() from
+	 * woken_wake_function() such that if we observe WQ_FLAG_WOKEN we must
+	 * also observe all state before the wakeup.
+	 */
+	if (!(wait->flags & WQ_FLAG_WOKEN) && !is_kthread_should_stop())
+		timeout = schedule_timeout(timeout);
+	__set_current_state(TASK_RUNNING);
+
+	/*
+	 * The below implies an smp_mb(), it too pairs with the smp_wmb() from
+	 * woken_wake_function() such that we must either observe the wait
+	 * condition being true _OR_ WQ_FLAG_WOKEN such that we will not miss
+	 * an event.
+	 */
+	set_mb(wait->flags, wait->flags & ~WQ_FLAG_WOKEN); /* B */
+
+	return timeout;
+}
+EXPORT_SYMBOL(wait_woken);
+
+int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	/*
+	 * Although this function is called under waitqueue lock, LOCK
+	 * doesn't imply write barrier and the users expects write
+	 * barrier semantics on wakeup functions.  The following
+	 * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
+	 * and is paired with set_mb() in wait_woken().
+	 */
+	smp_wmb(); /* C */
+	wait->flags |= WQ_FLAG_WOKEN;
+
+	return default_wake_function(wait, mode, sync, key);
+}
+EXPORT_SYMBOL(woken_wake_function);
+
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
 {
 	struct wait_bit_key *key = arg;
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
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index af73bc3acb40..410dd5e76c41 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -101,11 +101,11 @@ static struct rfcomm_session *rfcomm_session_del(struct rfcomm_session *s);
 #define __get_rpn_stop_bits(line) (((line) >> 2) & 0x1)
 #define __get_rpn_parity(line)    (((line) >> 3) & 0x7)
 
+static DECLARE_WAIT_QUEUE_HEAD(rfcomm_wq);
+
 static void rfcomm_schedule(void)
 {
-	if (!rfcomm_thread)
-		return;
-	wake_up_process(rfcomm_thread);
+	wake_up_all(&rfcomm_wq);
 }
 
 /* ---- RFCOMM FCS computation ---- */
@@ -2086,24 +2086,22 @@ static void rfcomm_kill_listener(void)
 
 static int rfcomm_run(void *unused)
 {
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	BT_DBG("");
 
 	set_user_nice(current, -10);
 
 	rfcomm_add_listener(BDADDR_ANY);
 
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		if (kthread_should_stop())
-			break;
+	add_wait_queue(&rfcomm_wq, &wait);
+	while (!kthread_should_stop()) {
 
 		/* Process stuff */
 		rfcomm_process_sessions();
 
-		schedule();
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&rfcomm_wq, &wait);
 
 	rfcomm_kill_listener();
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 945bbd001359..3acff0974560 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7200,11 +7200,10 @@ static void __net_exit rtnl_lock_unregistering(struct list_head *net_list)
 	 */
 	struct net *net;
 	bool unregistering;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+	add_wait_queue(&netdev_unregistering_wq, &wait);
 	for (;;) {
-		prepare_to_wait(&netdev_unregistering_wq, &wait,
-				TASK_UNINTERRUPTIBLE);
 		unregistering = false;
 		rtnl_lock();
 		list_for_each_entry(net, net_list, exit_list) {
@@ -7216,9 +7215,10 @@ static void __net_exit rtnl_lock_unregistering(struct list_head *net_list)
 		if (!unregistering)
 			break;
 		__rtnl_unlock();
-		schedule();
+
+		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	finish_wait(&netdev_unregistering_wq, &wait);
+	remove_wait_queue(&netdev_unregistering_wq, &wait);
 }
 
 static void __net_exit default_device_exit_batch(struct list_head *net_list)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a6882686ca3a..b095296f711f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -365,11 +365,10 @@ static void rtnl_lock_unregistering_all(void)
 {
 	struct net *net;
 	bool unregistering;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+	add_wait_queue(&netdev_unregistering_wq, &wait);
 	for (;;) {
-		prepare_to_wait(&netdev_unregistering_wq, &wait,
-				TASK_UNINTERRUPTIBLE);
 		unregistering = false;
 		rtnl_lock();
 		for_each_net(net) {
@@ -381,9 +380,10 @@ static void rtnl_lock_unregistering_all(void)
 		if (!unregistering)
 			break;
 		__rtnl_unlock();
-		schedule();
+
+		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	finish_wait(&netdev_unregistering_wq, &wait);
+	remove_wait_queue(&netdev_unregistering_wq, &wait);
 }
 
 /**
