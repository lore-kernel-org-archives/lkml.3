Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3KEMXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:23:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55942 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3KEMXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:23:47 -0500
Message-Id: <20131105110027.205590619@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 13:10:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC 5/8] locking: Move rtmutex into kernel/locking/
References: <20131105105244.666320103@infradead.org>
Content-Disposition: inline; filename=peterz-move-locking-rtmutex.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: tglx@linutronix.de
Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/Makefile                 |    3 
 kernel/futex.c                  |    2 
 kernel/locking/Makefile         |    3 
 kernel/locking/rtmutex-debug.c  |  187 +++++++
 kernel/locking/rtmutex-debug.h  |   33 +
 kernel/locking/rtmutex-tester.c |  420 +++++++++++++++
 kernel/locking/rtmutex.c        | 1060 ++++++++++++++++++++++++++++++++++++++++
 kernel/locking/rtmutex.h        |   26 
 kernel/locking/rtmutex_common.h |  126 ++++
 kernel/rtmutex-debug.c          |  187 -------
 kernel/rtmutex-debug.h          |   33 -
 kernel/rtmutex-tester.c         |  420 ---------------
 kernel/rtmutex.c                | 1060 ----------------------------------------
 kernel/rtmutex.h                |   26 
 kernel/rtmutex_common.h         |  126 ----
 15 files changed, 1856 insertions(+), 1856 deletions(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -35,9 +35,6 @@ obj-$(CONFIG_FUTEX) += futex.o
 ifeq ($(CONFIG_COMPAT),y)
 obj-$(CONFIG_FUTEX) += futex_compat.o
 endif
-obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
-obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
-obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -66,7 +66,7 @@
 
 #include <asm/futex.h>
 
-#include "rtmutex_common.h"
+#include "locking/rtmutex_common.h"
 
 int __read_mostly futex_cmpxchg_enabled;
 
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -15,5 +15,8 @@ obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
+obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
+obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
+obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
--- /dev/null
+++ b/kernel/locking/rtmutex-debug.c
@@ -0,0 +1,187 @@
+/*
+ * RT-Mutexes: blocking mutual exclusion locks with PI support
+ *
+ * started by Ingo Molnar and Thomas Gleixner:
+ *
+ *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *
+ * This code is based on the rt.c implementation in the preempt-rt tree.
+ * Portions of said code are
+ *
+ *  Copyright (C) 2004  LynuxWorks, Inc., Igor Manyilov, Bill Huey
+ *  Copyright (C) 2006  Esben Nielsen
+ *  Copyright (C) 2006  Kihon Technologies Inc.,
+ *			Steven Rostedt <rostedt@goodmis.org>
+ *
+ * See rt.c in preempt-rt for proper credits and further information
+ */
+#include <linux/sched.h>
+#include <linux/sched/rt.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/spinlock.h>
+#include <linux/kallsyms.h>
+#include <linux/syscalls.h>
+#include <linux/interrupt.h>
+#include <linux/plist.h>
+#include <linux/fs.h>
+#include <linux/debug_locks.h>
+
+#include "rtmutex_common.h"
+
+static void printk_task(struct task_struct *p)
+{
+	if (p)
+		printk("%16s:%5d [%p, %3d]", p->comm, task_pid_nr(p), p, p->prio);
+	else
+		printk("<none>");
+}
+
+static void printk_lock(struct rt_mutex *lock, int print_owner)
+{
+	if (lock->name)
+		printk(" [%p] {%s}\n",
+			lock, lock->name);
+	else
+		printk(" [%p] {%s:%d}\n",
+			lock, lock->file, lock->line);
+
+	if (print_owner && rt_mutex_owner(lock)) {
+		printk(".. ->owner: %p\n", lock->owner);
+		printk(".. held by:  ");
+		printk_task(rt_mutex_owner(lock));
+		printk("\n");
+	}
+}
+
+void rt_mutex_debug_task_free(struct task_struct *task)
+{
+	DEBUG_LOCKS_WARN_ON(!plist_head_empty(&task->pi_waiters));
+	DEBUG_LOCKS_WARN_ON(task->pi_blocked_on);
+}
+
+/*
+ * We fill out the fields in the waiter to store the information about
+ * the deadlock. We print when we return. act_waiter can be NULL in
+ * case of a remove waiter operation.
+ */
+void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *act_waiter,
+			     struct rt_mutex *lock)
+{
+	struct task_struct *task;
+
+	if (!debug_locks || detect || !act_waiter)
+		return;
+
+	task = rt_mutex_owner(act_waiter->lock);
+	if (task && task != current) {
+		act_waiter->deadlock_task_pid = get_pid(task_pid(task));
+		act_waiter->deadlock_lock = lock;
+	}
+}
+
+void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter)
+{
+	struct task_struct *task;
+
+	if (!waiter->deadlock_lock || !debug_locks)
+		return;
+
+	rcu_read_lock();
+	task = pid_task(waiter->deadlock_task_pid, PIDTYPE_PID);
+	if (!task) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (!debug_locks_off()) {
+		rcu_read_unlock();
+		return;
+	}
+
+	printk("\n============================================\n");
+	printk(  "[ BUG: circular locking deadlock detected! ]\n");
+	printk("%s\n", print_tainted());
+	printk(  "--------------------------------------------\n");
+	printk("%s/%d is deadlocking current task %s/%d\n\n",
+	       task->comm, task_pid_nr(task),
+	       current->comm, task_pid_nr(current));
+
+	printk("\n1) %s/%d is trying to acquire this lock:\n",
+	       current->comm, task_pid_nr(current));
+	printk_lock(waiter->lock, 1);
+
+	printk("\n2) %s/%d is blocked on this lock:\n",
+		task->comm, task_pid_nr(task));
+	printk_lock(waiter->deadlock_lock, 1);
+
+	debug_show_held_locks(current);
+	debug_show_held_locks(task);
+
+	printk("\n%s/%d's [blocked] stackdump:\n\n",
+		task->comm, task_pid_nr(task));
+	show_stack(task, NULL);
+	printk("\n%s/%d's [current] stackdump:\n\n",
+		current->comm, task_pid_nr(current));
+	dump_stack();
+	debug_show_all_locks();
+	rcu_read_unlock();
+
+	printk("[ turning off deadlock detection."
+	       "Please report this trace. ]\n\n");
+}
+
+void debug_rt_mutex_lock(struct rt_mutex *lock)
+{
+}
+
+void debug_rt_mutex_unlock(struct rt_mutex *lock)
+{
+	DEBUG_LOCKS_WARN_ON(rt_mutex_owner(lock) != current);
+}
+
+void
+debug_rt_mutex_proxy_lock(struct rt_mutex *lock, struct task_struct *powner)
+{
+}
+
+void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock)
+{
+	DEBUG_LOCKS_WARN_ON(!rt_mutex_owner(lock));
+}
+
+void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
+{
+	memset(waiter, 0x11, sizeof(*waiter));
+	plist_node_init(&waiter->list_entry, MAX_PRIO);
+	plist_node_init(&waiter->pi_list_entry, MAX_PRIO);
+	waiter->deadlock_task_pid = NULL;
+}
+
+void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
+{
+	put_pid(waiter->deadlock_task_pid);
+	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->list_entry));
+	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
+	memset(waiter, 0x22, sizeof(*waiter));
+}
+
+void debug_rt_mutex_init(struct rt_mutex *lock, const char *name)
+{
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
+	lock->name = name;
+}
+
+void
+rt_mutex_deadlock_account_lock(struct rt_mutex *lock, struct task_struct *task)
+{
+}
+
+void rt_mutex_deadlock_account_unlock(struct task_struct *task)
+{
+}
+
--- /dev/null
+++ b/kernel/locking/rtmutex-debug.h
@@ -0,0 +1,33 @@
+/*
+ * RT-Mutexes: blocking mutual exclusion locks with PI support
+ *
+ * started by Ingo Molnar and Thomas Gleixner:
+ *
+ *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *
+ * This file contains macros used solely by rtmutex.c. Debug version.
+ */
+
+extern void
+rt_mutex_deadlock_account_lock(struct rt_mutex *lock, struct task_struct *task);
+extern void rt_mutex_deadlock_account_unlock(struct task_struct *task);
+extern void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter);
+extern void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter);
+extern void debug_rt_mutex_init(struct rt_mutex *lock, const char *name);
+extern void debug_rt_mutex_lock(struct rt_mutex *lock);
+extern void debug_rt_mutex_unlock(struct rt_mutex *lock);
+extern void debug_rt_mutex_proxy_lock(struct rt_mutex *lock,
+				      struct task_struct *powner);
+extern void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock);
+extern void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *waiter,
+				    struct rt_mutex *lock);
+extern void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter);
+# define debug_rt_mutex_reset_waiter(w)			\
+	do { (w)->deadlock_lock = NULL; } while (0)
+
+static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
+						 int detect)
+{
+	return (waiter != NULL);
+}
--- /dev/null
+++ b/kernel/locking/rtmutex-tester.c
@@ -0,0 +1,420 @@
+/*
+ * RT-Mutex-tester: scriptable tester for rt mutexes
+ *
+ * started by Thomas Gleixner:
+ *
+ *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *
+ */
+#include <linux/device.h>
+#include <linux/kthread.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/sched/rt.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <linux/freezer.h>
+#include <linux/stat.h>
+
+#include "rtmutex.h"
+
+#define MAX_RT_TEST_THREADS	8
+#define MAX_RT_TEST_MUTEXES	8
+
+static spinlock_t rttest_lock;
+static atomic_t rttest_event;
+
+struct test_thread_data {
+	int			opcode;
+	int			opdata;
+	int			mutexes[MAX_RT_TEST_MUTEXES];
+	int			event;
+	struct device		dev;
+};
+
+static struct test_thread_data thread_data[MAX_RT_TEST_THREADS];
+static struct task_struct *threads[MAX_RT_TEST_THREADS];
+static struct rt_mutex mutexes[MAX_RT_TEST_MUTEXES];
+
+enum test_opcodes {
+	RTTEST_NOP = 0,
+	RTTEST_SCHEDOT,		/* 1 Sched other, data = nice */
+	RTTEST_SCHEDRT,		/* 2 Sched fifo, data = prio */
+	RTTEST_LOCK,		/* 3 Lock uninterruptible, data = lockindex */
+	RTTEST_LOCKNOWAIT,	/* 4 Lock uninterruptible no wait in wakeup, data = lockindex */
+	RTTEST_LOCKINT,		/* 5 Lock interruptible, data = lockindex */
+	RTTEST_LOCKINTNOWAIT,	/* 6 Lock interruptible no wait in wakeup, data = lockindex */
+	RTTEST_LOCKCONT,	/* 7 Continue locking after the wakeup delay */
+	RTTEST_UNLOCK,		/* 8 Unlock, data = lockindex */
+	/* 9, 10 - reserved for BKL commemoration */
+	RTTEST_SIGNAL = 11,	/* 11 Signal other test thread, data = thread id */
+	RTTEST_RESETEVENT = 98,	/* 98 Reset event counter */
+	RTTEST_RESET = 99,	/* 99 Reset all pending operations */
+};
+
+static int handle_op(struct test_thread_data *td, int lockwakeup)
+{
+	int i, id, ret = -EINVAL;
+
+	switch(td->opcode) {
+
+	case RTTEST_NOP:
+		return 0;
+
+	case RTTEST_LOCKCONT:
+		td->mutexes[td->opdata] = 1;
+		td->event = atomic_add_return(1, &rttest_event);
+		return 0;
+
+	case RTTEST_RESET:
+		for (i = 0; i < MAX_RT_TEST_MUTEXES; i++) {
+			if (td->mutexes[i] == 4) {
+				rt_mutex_unlock(&mutexes[i]);
+				td->mutexes[i] = 0;
+			}
+		}
+		return 0;
+
+	case RTTEST_RESETEVENT:
+		atomic_set(&rttest_event, 0);
+		return 0;
+
+	default:
+		if (lockwakeup)
+			return ret;
+	}
+
+	switch(td->opcode) {
+
+	case RTTEST_LOCK:
+	case RTTEST_LOCKNOWAIT:
+		id = td->opdata;
+		if (id < 0 || id >= MAX_RT_TEST_MUTEXES)
+			return ret;
+
+		td->mutexes[id] = 1;
+		td->event = atomic_add_return(1, &rttest_event);
+		rt_mutex_lock(&mutexes[id]);
+		td->event = atomic_add_return(1, &rttest_event);
+		td->mutexes[id] = 4;
+		return 0;
+
+	case RTTEST_LOCKINT:
+	case RTTEST_LOCKINTNOWAIT:
+		id = td->opdata;
+		if (id < 0 || id >= MAX_RT_TEST_MUTEXES)
+			return ret;
+
+		td->mutexes[id] = 1;
+		td->event = atomic_add_return(1, &rttest_event);
+		ret = rt_mutex_lock_interruptible(&mutexes[id], 0);
+		td->event = atomic_add_return(1, &rttest_event);
+		td->mutexes[id] = ret ? 0 : 4;
+		return ret ? -EINTR : 0;
+
+	case RTTEST_UNLOCK:
+		id = td->opdata;
+		if (id < 0 || id >= MAX_RT_TEST_MUTEXES || td->mutexes[id] != 4)
+			return ret;
+
+		td->event = atomic_add_return(1, &rttest_event);
+		rt_mutex_unlock(&mutexes[id]);
+		td->event = atomic_add_return(1, &rttest_event);
+		td->mutexes[id] = 0;
+		return 0;
+
+	default:
+		break;
+	}
+	return ret;
+}
+
+/*
+ * Schedule replacement for rtsem_down(). Only called for threads with
+ * PF_MUTEX_TESTER set.
+ *
+ * This allows us to have finegrained control over the event flow.
+ *
+ */
+void schedule_rt_mutex_test(struct rt_mutex *mutex)
+{
+	int tid, op, dat;
+	struct test_thread_data *td;
+
+	/* We have to lookup the task */
+	for (tid = 0; tid < MAX_RT_TEST_THREADS; tid++) {
+		if (threads[tid] == current)
+			break;
+	}
+
+	BUG_ON(tid == MAX_RT_TEST_THREADS);
+
+	td = &thread_data[tid];
+
+	op = td->opcode;
+	dat = td->opdata;
+
+	switch (op) {
+	case RTTEST_LOCK:
+	case RTTEST_LOCKINT:
+	case RTTEST_LOCKNOWAIT:
+	case RTTEST_LOCKINTNOWAIT:
+		if (mutex != &mutexes[dat])
+			break;
+
+		if (td->mutexes[dat] != 1)
+			break;
+
+		td->mutexes[dat] = 2;
+		td->event = atomic_add_return(1, &rttest_event);
+		break;
+
+	default:
+		break;
+	}
+
+	schedule();
+
+
+	switch (op) {
+	case RTTEST_LOCK:
+	case RTTEST_LOCKINT:
+		if (mutex != &mutexes[dat])
+			return;
+
+		if (td->mutexes[dat] != 2)
+			return;
+
+		td->mutexes[dat] = 3;
+		td->event = atomic_add_return(1, &rttest_event);
+		break;
+
+	case RTTEST_LOCKNOWAIT:
+	case RTTEST_LOCKINTNOWAIT:
+		if (mutex != &mutexes[dat])
+			return;
+
+		if (td->mutexes[dat] != 2)
+			return;
+
+		td->mutexes[dat] = 1;
+		td->event = atomic_add_return(1, &rttest_event);
+		return;
+
+	default:
+		return;
+	}
+
+	td->opcode = 0;
+
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		if (td->opcode > 0) {
+			int ret;
+
+			set_current_state(TASK_RUNNING);
+			ret = handle_op(td, 1);
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (td->opcode == RTTEST_LOCKCONT)
+				break;
+			td->opcode = ret;
+		}
+
+		/* Wait for the next command to be executed */
+		schedule();
+	}
+
+	/* Restore previous command and data */
+	td->opcode = op;
+	td->opdata = dat;
+}
+
+static int test_func(void *data)
+{
+	struct test_thread_data *td = data;
+	int ret;
+
+	current->flags |= PF_MUTEX_TESTER;
+	set_freezable();
+	allow_signal(SIGHUP);
+
+	for(;;) {
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		if (td->opcode > 0) {
+			set_current_state(TASK_RUNNING);
+			ret = handle_op(td, 0);
+			set_current_state(TASK_INTERRUPTIBLE);
+			td->opcode = ret;
+		}
+
+		/* Wait for the next command to be executed */
+		schedule();
+		try_to_freeze();
+
+		if (signal_pending(current))
+			flush_signals(current);
+
+		if(kthread_should_stop())
+			break;
+	}
+	return 0;
+}
+
+/**
+ * sysfs_test_command - interface for test commands
+ * @dev:	thread reference
+ * @buf:	command for actual step
+ * @count:	length of buffer
+ *
+ * command syntax:
+ *
+ * opcode:data
+ */
+static ssize_t sysfs_test_command(struct device *dev, struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct sched_param schedpar;
+	struct test_thread_data *td;
+	char cmdbuf[32];
+	int op, dat, tid, ret;
+
+	td = container_of(dev, struct test_thread_data, dev);
+	tid = td->dev.id;
+
+	/* strings from sysfs write are not 0 terminated! */
+	if (count >= sizeof(cmdbuf))
+		return -EINVAL;
+
+	/* strip of \n: */
+	if (buf[count-1] == '\n')
+		count--;
+	if (count < 1)
+		return -EINVAL;
+
+	memcpy(cmdbuf, buf, count);
+	cmdbuf[count] = 0;
+
+	if (sscanf(cmdbuf, "%d:%d", &op, &dat) != 2)
+		return -EINVAL;
+
+	switch (op) {
+	case RTTEST_SCHEDOT:
+		schedpar.sched_priority = 0;
+		ret = sched_setscheduler(threads[tid], SCHED_NORMAL, &schedpar);
+		if (ret)
+			return ret;
+		set_user_nice(current, 0);
+		break;
+
+	case RTTEST_SCHEDRT:
+		schedpar.sched_priority = dat;
+		ret = sched_setscheduler(threads[tid], SCHED_FIFO, &schedpar);
+		if (ret)
+			return ret;
+		break;
+
+	case RTTEST_SIGNAL:
+		send_sig(SIGHUP, threads[tid], 0);
+		break;
+
+	default:
+		if (td->opcode > 0)
+			return -EBUSY;
+		td->opdata = dat;
+		td->opcode = op;
+		wake_up_process(threads[tid]);
+	}
+
+	return count;
+}
+
+/**
+ * sysfs_test_status - sysfs interface for rt tester
+ * @dev:	thread to query
+ * @buf:	char buffer to be filled with thread status info
+ */
+static ssize_t sysfs_test_status(struct device *dev, struct device_attribute *attr,
+				 char *buf)
+{
+	struct test_thread_data *td;
+	struct task_struct *tsk;
+	char *curr = buf;
+	int i;
+
+	td = container_of(dev, struct test_thread_data, dev);
+	tsk = threads[td->dev.id];
+
+	spin_lock(&rttest_lock);
+
+	curr += sprintf(curr,
+		"O: %4d, E:%8d, S: 0x%08lx, P: %4d, N: %4d, B: %p, M:",
+		td->opcode, td->event, tsk->state,
+			(MAX_RT_PRIO - 1) - tsk->prio,
+			(MAX_RT_PRIO - 1) - tsk->normal_prio,
+		tsk->pi_blocked_on);
+
+	for (i = MAX_RT_TEST_MUTEXES - 1; i >=0 ; i--)
+		curr += sprintf(curr, "%d", td->mutexes[i]);
+
+	spin_unlock(&rttest_lock);
+
+	curr += sprintf(curr, ", T: %p, R: %p\n", tsk,
+			mutexes[td->dev.id].owner);
+
+	return curr - buf;
+}
+
+static DEVICE_ATTR(status, S_IRUSR, sysfs_test_status, NULL);
+static DEVICE_ATTR(command, S_IWUSR, NULL, sysfs_test_command);
+
+static struct bus_type rttest_subsys = {
+	.name = "rttest",
+	.dev_name = "rttest",
+};
+
+static int init_test_thread(int id)
+{
+	thread_data[id].dev.bus = &rttest_subsys;
+	thread_data[id].dev.id = id;
+
+	threads[id] = kthread_run(test_func, &thread_data[id], "rt-test-%d", id);
+	if (IS_ERR(threads[id]))
+		return PTR_ERR(threads[id]);
+
+	return device_register(&thread_data[id].dev);
+}
+
+static int init_rttest(void)
+{
+	int ret, i;
+
+	spin_lock_init(&rttest_lock);
+
+	for (i = 0; i < MAX_RT_TEST_MUTEXES; i++)
+		rt_mutex_init(&mutexes[i]);
+
+	ret = subsys_system_register(&rttest_subsys, NULL);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < MAX_RT_TEST_THREADS; i++) {
+		ret = init_test_thread(i);
+		if (ret)
+			break;
+		ret = device_create_file(&thread_data[i].dev, &dev_attr_status);
+		if (ret)
+			break;
+		ret = device_create_file(&thread_data[i].dev, &dev_attr_command);
+		if (ret)
+			break;
+	}
+
+	printk("Initializing RT-Tester: %s\n", ret ? "Failed" : "OK" );
+
+	return ret;
+}
+
+device_initcall(init_rttest);
--- /dev/null
+++ b/kernel/locking/rtmutex.c
@@ -0,0 +1,1060 @@
+/*
+ * RT-Mutexes: simple blocking mutual exclusion locks with PI support
+ *
+ * started by Ingo Molnar and Thomas Gleixner.
+ *
+ *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2005-2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *  Copyright (C) 2005 Kihon Technologies Inc., Steven Rostedt
+ *  Copyright (C) 2006 Esben Nielsen
+ *
+ *  See Documentation/rt-mutex-design.txt for details.
+ */
+#include <linux/spinlock.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/sched/rt.h>
+#include <linux/timer.h>
+
+#include "rtmutex_common.h"
+
+/*
+ * lock->owner state tracking:
+ *
+ * lock->owner holds the task_struct pointer of the owner. Bit 0
+ * is used to keep track of the "lock has waiters" state.
+ *
+ * owner	bit0
+ * NULL		0	lock is free (fast acquire possible)
+ * NULL		1	lock is free and has waiters and the top waiter
+ *				is going to take the lock*
+ * taskpointer	0	lock is held (fast release possible)
+ * taskpointer	1	lock is held and has waiters**
+ *
+ * The fast atomic compare exchange based acquire and release is only
+ * possible when bit 0 of lock->owner is 0.
+ *
+ * (*) It also can be a transitional state when grabbing the lock
+ * with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
+ * we need to set the bit0 before looking at the lock, and the owner may be
+ * NULL in this small time, hence this can be a transitional state.
+ *
+ * (**) There is a small time when bit 0 is set but there are no
+ * waiters. This can happen when grabbing the lock in the slow path.
+ * To prevent a cmpxchg of the owner releasing the lock, we need to
+ * set this bit before looking at the lock.
+ */
+
+static void
+rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner)
+{
+	unsigned long val = (unsigned long)owner;
+
+	if (rt_mutex_has_waiters(lock))
+		val |= RT_MUTEX_HAS_WAITERS;
+
+	lock->owner = (struct task_struct *)val;
+}
+
+static inline void clear_rt_mutex_waiters(struct rt_mutex *lock)
+{
+	lock->owner = (struct task_struct *)
+			((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
+}
+
+static void fixup_rt_mutex_waiters(struct rt_mutex *lock)
+{
+	if (!rt_mutex_has_waiters(lock))
+		clear_rt_mutex_waiters(lock);
+}
+
+/*
+ * We can speed up the acquire/release, if the architecture
+ * supports cmpxchg and if there's no debugging state to be set up
+ */
+#if defined(__HAVE_ARCH_CMPXCHG) && !defined(CONFIG_DEBUG_RT_MUTEXES)
+# define rt_mutex_cmpxchg(l,c,n)	(cmpxchg(&l->owner, c, n) == c)
+static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
+{
+	unsigned long owner, *p = (unsigned long *) &lock->owner;
+
+	do {
+		owner = *p;
+	} while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner);
+}
+#else
+# define rt_mutex_cmpxchg(l,c,n)	(0)
+static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
+{
+	lock->owner = (struct task_struct *)
+			((unsigned long)lock->owner | RT_MUTEX_HAS_WAITERS);
+}
+#endif
+
+/*
+ * Calculate task priority from the waiter list priority
+ *
+ * Return task->normal_prio when the waiter list is empty or when
+ * the waiter is not allowed to do priority boosting
+ */
+int rt_mutex_getprio(struct task_struct *task)
+{
+	if (likely(!task_has_pi_waiters(task)))
+		return task->normal_prio;
+
+	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
+		   task->normal_prio);
+}
+
+/*
+ * Adjust the priority of a task, after its pi_waiters got modified.
+ *
+ * This can be both boosting and unboosting. task->pi_lock must be held.
+ */
+static void __rt_mutex_adjust_prio(struct task_struct *task)
+{
+	int prio = rt_mutex_getprio(task);
+
+	if (task->prio != prio)
+		rt_mutex_setprio(task, prio);
+}
+
+/*
+ * Adjust task priority (undo boosting). Called from the exit path of
+ * rt_mutex_slowunlock() and rt_mutex_slowlock().
+ *
+ * (Note: We do this outside of the protection of lock->wait_lock to
+ * allow the lock to be taken while or before we readjust the priority
+ * of task. We do not use the spin_xx_mutex() variants here as we are
+ * outside of the debug path.)
+ */
+static void rt_mutex_adjust_prio(struct task_struct *task)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	__rt_mutex_adjust_prio(task);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+}
+
+/*
+ * Max number of times we'll walk the boosting chain:
+ */
+int max_lock_depth = 1024;
+
+/*
+ * Adjust the priority chain. Also used for deadlock detection.
+ * Decreases task's usage by one - may thus free the task.
+ *
+ * @task: the task owning the mutex (owner) for which a chain walk is probably
+ *	  needed
+ * @deadlock_detect: do we have to carry out deadlock detection?
+ * @orig_lock: the mutex (can be NULL if we are walking the chain to recheck
+ * 	       things for a task that has just got its priority adjusted, and
+ *	       is waiting on a mutex)
+ * @orig_waiter: rt_mutex_waiter struct for the task that has just donated
+ *		 its priority to the mutex owner (can be NULL in the case
+ *		 depicted above or if the top waiter is gone away and we are
+ *		 actually deboosting the owner)
+ * @top_task: the current top waiter
+ *
+ * Returns 0 or -EDEADLK.
+ */
+static int rt_mutex_adjust_prio_chain(struct task_struct *task,
+				      int deadlock_detect,
+				      struct rt_mutex *orig_lock,
+				      struct rt_mutex_waiter *orig_waiter,
+				      struct task_struct *top_task)
+{
+	struct rt_mutex *lock;
+	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
+	int detect_deadlock, ret = 0, depth = 0;
+	unsigned long flags;
+
+	detect_deadlock = debug_rt_mutex_detect_deadlock(orig_waiter,
+							 deadlock_detect);
+
+	/*
+	 * The (de)boosting is a step by step approach with a lot of
+	 * pitfalls. We want this to be preemptible and we want hold a
+	 * maximum of two locks per step. So we have to check
+	 * carefully whether things change under us.
+	 */
+ again:
+	if (++depth > max_lock_depth) {
+		static int prev_max;
+
+		/*
+		 * Print this only once. If the admin changes the limit,
+		 * print a new message when reaching the limit again.
+		 */
+		if (prev_max != max_lock_depth) {
+			prev_max = max_lock_depth;
+			printk(KERN_WARNING "Maximum lock depth %d reached "
+			       "task: %s (%d)\n", max_lock_depth,
+			       top_task->comm, task_pid_nr(top_task));
+		}
+		put_task_struct(task);
+
+		return deadlock_detect ? -EDEADLK : 0;
+	}
+ retry:
+	/*
+	 * Task can not go away as we did a get_task() before !
+	 */
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+	waiter = task->pi_blocked_on;
+	/*
+	 * Check whether the end of the boosting chain has been
+	 * reached or the state of the chain has changed while we
+	 * dropped the locks.
+	 */
+	if (!waiter)
+		goto out_unlock_pi;
+
+	/*
+	 * Check the orig_waiter state. After we dropped the locks,
+	 * the previous owner of the lock might have released the lock.
+	 */
+	if (orig_waiter && !rt_mutex_owner(orig_lock))
+		goto out_unlock_pi;
+
+	/*
+	 * Drop out, when the task has no waiters. Note,
+	 * top_waiter can be NULL, when we are in the deboosting
+	 * mode!
+	 */
+	if (top_waiter && (!task_has_pi_waiters(task) ||
+			   top_waiter != task_top_pi_waiter(task)))
+		goto out_unlock_pi;
+
+	/*
+	 * When deadlock detection is off then we check, if further
+	 * priority adjustment is necessary.
+	 */
+	if (!detect_deadlock && waiter->list_entry.prio == task->prio)
+		goto out_unlock_pi;
+
+	lock = waiter->lock;
+	if (!raw_spin_trylock(&lock->wait_lock)) {
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		cpu_relax();
+		goto retry;
+	}
+
+	/* Deadlock detection */
+	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
+		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
+		raw_spin_unlock(&lock->wait_lock);
+		ret = deadlock_detect ? -EDEADLK : 0;
+		goto out_unlock_pi;
+	}
+
+	top_waiter = rt_mutex_top_waiter(lock);
+
+	/* Requeue the waiter */
+	plist_del(&waiter->list_entry, &lock->wait_list);
+	waiter->list_entry.prio = task->prio;
+	plist_add(&waiter->list_entry, &lock->wait_list);
+
+	/* Release the task */
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	if (!rt_mutex_owner(lock)) {
+		/*
+		 * If the requeue above changed the top waiter, then we need
+		 * to wake the new top waiter up to try to get the lock.
+		 */
+
+		if (top_waiter != rt_mutex_top_waiter(lock))
+			wake_up_process(rt_mutex_top_waiter(lock)->task);
+		raw_spin_unlock(&lock->wait_lock);
+		goto out_put_task;
+	}
+	put_task_struct(task);
+
+	/* Grab the next task */
+	task = rt_mutex_owner(lock);
+	get_task_struct(task);
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+	if (waiter == rt_mutex_top_waiter(lock)) {
+		/* Boost the owner */
+		plist_del(&top_waiter->pi_list_entry, &task->pi_waiters);
+		waiter->pi_list_entry.prio = waiter->list_entry.prio;
+		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		__rt_mutex_adjust_prio(task);
+
+	} else if (top_waiter == waiter) {
+		/* Deboost the owner */
+		plist_del(&waiter->pi_list_entry, &task->pi_waiters);
+		waiter = rt_mutex_top_waiter(lock);
+		waiter->pi_list_entry.prio = waiter->list_entry.prio;
+		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		__rt_mutex_adjust_prio(task);
+	}
+
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	top_waiter = rt_mutex_top_waiter(lock);
+	raw_spin_unlock(&lock->wait_lock);
+
+	if (!detect_deadlock && waiter != top_waiter)
+		goto out_put_task;
+
+	goto again;
+
+ out_unlock_pi:
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+ out_put_task:
+	put_task_struct(task);
+
+	return ret;
+}
+
+/*
+ * Try to take an rt-mutex
+ *
+ * Must be called with lock->wait_lock held.
+ *
+ * @lock:   the lock to be acquired.
+ * @task:   the task which wants to acquire the lock
+ * @waiter: the waiter that is queued to the lock's wait list. (could be NULL)
+ */
+static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
+		struct rt_mutex_waiter *waiter)
+{
+	/*
+	 * We have to be careful here if the atomic speedups are
+	 * enabled, such that, when
+	 *  - no other waiter is on the lock
+	 *  - the lock has been released since we did the cmpxchg
+	 * the lock can be released or taken while we are doing the
+	 * checks and marking the lock with RT_MUTEX_HAS_WAITERS.
+	 *
+	 * The atomic acquire/release aware variant of
+	 * mark_rt_mutex_waiters uses a cmpxchg loop. After setting
+	 * the WAITERS bit, the atomic release / acquire can not
+	 * happen anymore and lock->wait_lock protects us from the
+	 * non-atomic case.
+	 *
+	 * Note, that this might set lock->owner =
+	 * RT_MUTEX_HAS_WAITERS in the case the lock is not contended
+	 * any more. This is fixed up when we take the ownership.
+	 * This is the transitional state explained at the top of this file.
+	 */
+	mark_rt_mutex_waiters(lock);
+
+	if (rt_mutex_owner(lock))
+		return 0;
+
+	/*
+	 * It will get the lock because of one of these conditions:
+	 * 1) there is no waiter
+	 * 2) higher priority than waiters
+	 * 3) it is top waiter
+	 */
+	if (rt_mutex_has_waiters(lock)) {
+		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio) {
+			if (!waiter || waiter != rt_mutex_top_waiter(lock))
+				return 0;
+		}
+	}
+
+	if (waiter || rt_mutex_has_waiters(lock)) {
+		unsigned long flags;
+		struct rt_mutex_waiter *top;
+
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+		/* remove the queued waiter. */
+		if (waiter) {
+			plist_del(&waiter->list_entry, &lock->wait_list);
+			task->pi_blocked_on = NULL;
+		}
+
+		/*
+		 * We have to enqueue the top waiter(if it exists) into
+		 * task->pi_waiters list.
+		 */
+		if (rt_mutex_has_waiters(lock)) {
+			top = rt_mutex_top_waiter(lock);
+			top->pi_list_entry.prio = top->list_entry.prio;
+			plist_add(&top->pi_list_entry, &task->pi_waiters);
+		}
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	}
+
+	/* We got the lock. */
+	debug_rt_mutex_lock(lock);
+
+	rt_mutex_set_owner(lock, task);
+
+	rt_mutex_deadlock_account_lock(lock, task);
+
+	return 1;
+}
+
+/*
+ * Task blocks on lock.
+ *
+ * Prepare waiter and propagate pi chain
+ *
+ * This must be called with lock->wait_lock held.
+ */
+static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
+				   struct rt_mutex_waiter *waiter,
+				   struct task_struct *task,
+				   int detect_deadlock)
+{
+	struct task_struct *owner = rt_mutex_owner(lock);
+	struct rt_mutex_waiter *top_waiter = waiter;
+	unsigned long flags;
+	int chain_walk = 0, res;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	__rt_mutex_adjust_prio(task);
+	waiter->task = task;
+	waiter->lock = lock;
+	plist_node_init(&waiter->list_entry, task->prio);
+	plist_node_init(&waiter->pi_list_entry, task->prio);
+
+	/* Get the top priority waiter on the lock */
+	if (rt_mutex_has_waiters(lock))
+		top_waiter = rt_mutex_top_waiter(lock);
+	plist_add(&waiter->list_entry, &lock->wait_list);
+
+	task->pi_blocked_on = waiter;
+
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	if (!owner)
+		return 0;
+
+	if (waiter == rt_mutex_top_waiter(lock)) {
+		raw_spin_lock_irqsave(&owner->pi_lock, flags);
+		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
+		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
+
+		__rt_mutex_adjust_prio(owner);
+		if (owner->pi_blocked_on)
+			chain_walk = 1;
+		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+	}
+	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
+		chain_walk = 1;
+
+	if (!chain_walk)
+		return 0;
+
+	/*
+	 * The owner can't disappear while holding a lock,
+	 * so the owner struct is protected by wait_lock.
+	 * Gets dropped in rt_mutex_adjust_prio_chain()!
+	 */
+	get_task_struct(owner);
+
+	raw_spin_unlock(&lock->wait_lock);
+
+	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
+					 task);
+
+	raw_spin_lock(&lock->wait_lock);
+
+	return res;
+}
+
+/*
+ * Wake up the next waiter on the lock.
+ *
+ * Remove the top waiter from the current tasks waiter list and wake it up.
+ *
+ * Called with lock->wait_lock held.
+ */
+static void wakeup_next_waiter(struct rt_mutex *lock)
+{
+	struct rt_mutex_waiter *waiter;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&current->pi_lock, flags);
+
+	waiter = rt_mutex_top_waiter(lock);
+
+	/*
+	 * Remove it from current->pi_waiters. We do not adjust a
+	 * possible priority boost right now. We execute wakeup in the
+	 * boosted mode and go back to normal after releasing
+	 * lock->wait_lock.
+	 */
+	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
+
+	rt_mutex_set_owner(lock, NULL);
+
+	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+
+	wake_up_process(waiter->task);
+}
+
+/*
+ * Remove a waiter from a lock and give up
+ *
+ * Must be called with lock->wait_lock held and
+ * have just failed to try_to_take_rt_mutex().
+ */
+static void remove_waiter(struct rt_mutex *lock,
+			  struct rt_mutex_waiter *waiter)
+{
+	int first = (waiter == rt_mutex_top_waiter(lock));
+	struct task_struct *owner = rt_mutex_owner(lock);
+	unsigned long flags;
+	int chain_walk = 0;
+
+	raw_spin_lock_irqsave(&current->pi_lock, flags);
+	plist_del(&waiter->list_entry, &lock->wait_list);
+	current->pi_blocked_on = NULL;
+	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+
+	if (!owner)
+		return;
+
+	if (first) {
+
+		raw_spin_lock_irqsave(&owner->pi_lock, flags);
+
+		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
+
+		if (rt_mutex_has_waiters(lock)) {
+			struct rt_mutex_waiter *next;
+
+			next = rt_mutex_top_waiter(lock);
+			plist_add(&next->pi_list_entry, &owner->pi_waiters);
+		}
+		__rt_mutex_adjust_prio(owner);
+
+		if (owner->pi_blocked_on)
+			chain_walk = 1;
+
+		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+	}
+
+	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
+
+	if (!chain_walk)
+		return;
+
+	/* gets dropped in rt_mutex_adjust_prio_chain()! */
+	get_task_struct(owner);
+
+	raw_spin_unlock(&lock->wait_lock);
+
+	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
+
+	raw_spin_lock(&lock->wait_lock);
+}
+
+/*
+ * Recheck the pi chain, in case we got a priority setting
+ *
+ * Called from sched_setscheduler
+ */
+void rt_mutex_adjust_pi(struct task_struct *task)
+{
+	struct rt_mutex_waiter *waiter;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+	waiter = task->pi_blocked_on;
+	if (!waiter || waiter->list_entry.prio == task->prio) {
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		return;
+	}
+
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	/* gets dropped in rt_mutex_adjust_prio_chain()! */
+	get_task_struct(task);
+	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
+}
+
+/**
+ * __rt_mutex_slowlock() - Perform the wait-wake-try-to-take loop
+ * @lock:		 the rt_mutex to take
+ * @state:		 the state the task should block in (TASK_INTERRUPTIBLE
+ * 			 or TASK_UNINTERRUPTIBLE)
+ * @timeout:		 the pre-initialized and started timer, or NULL for none
+ * @waiter:		 the pre-initialized rt_mutex_waiter
+ *
+ * lock->wait_lock must be held by the caller.
+ */
+static int __sched
+__rt_mutex_slowlock(struct rt_mutex *lock, int state,
+		    struct hrtimer_sleeper *timeout,
+		    struct rt_mutex_waiter *waiter)
+{
+	int ret = 0;
+
+	for (;;) {
+		/* Try to acquire the lock: */
+		if (try_to_take_rt_mutex(lock, current, waiter))
+			break;
+
+		/*
+		 * TASK_INTERRUPTIBLE checks for signals and
+		 * timeout. Ignored otherwise.
+		 */
+		if (unlikely(state == TASK_INTERRUPTIBLE)) {
+			/* Signal pending? */
+			if (signal_pending(current))
+				ret = -EINTR;
+			if (timeout && !timeout->task)
+				ret = -ETIMEDOUT;
+			if (ret)
+				break;
+		}
+
+		raw_spin_unlock(&lock->wait_lock);
+
+		debug_rt_mutex_print_deadlock(waiter);
+
+		schedule_rt_mutex(lock);
+
+		raw_spin_lock(&lock->wait_lock);
+		set_current_state(state);
+	}
+
+	return ret;
+}
+
+/*
+ * Slow path lock function:
+ */
+static int __sched
+rt_mutex_slowlock(struct rt_mutex *lock, int state,
+		  struct hrtimer_sleeper *timeout,
+		  int detect_deadlock)
+{
+	struct rt_mutex_waiter waiter;
+	int ret = 0;
+
+	debug_rt_mutex_init_waiter(&waiter);
+
+	raw_spin_lock(&lock->wait_lock);
+
+	/* Try to acquire the lock again: */
+	if (try_to_take_rt_mutex(lock, current, NULL)) {
+		raw_spin_unlock(&lock->wait_lock);
+		return 0;
+	}
+
+	set_current_state(state);
+
+	/* Setup the timer, when timeout != NULL */
+	if (unlikely(timeout)) {
+		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
+		if (!hrtimer_active(&timeout->timer))
+			timeout->task = NULL;
+	}
+
+	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
+
+	if (likely(!ret))
+		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
+
+	set_current_state(TASK_RUNNING);
+
+	if (unlikely(ret))
+		remove_waiter(lock, &waiter);
+
+	/*
+	 * try_to_take_rt_mutex() sets the waiter bit
+	 * unconditionally. We might have to fix that up.
+	 */
+	fixup_rt_mutex_waiters(lock);
+
+	raw_spin_unlock(&lock->wait_lock);
+
+	/* Remove pending timer: */
+	if (unlikely(timeout))
+		hrtimer_cancel(&timeout->timer);
+
+	debug_rt_mutex_free_waiter(&waiter);
+
+	return ret;
+}
+
+/*
+ * Slow path try-lock function:
+ */
+static inline int
+rt_mutex_slowtrylock(struct rt_mutex *lock)
+{
+	int ret = 0;
+
+	raw_spin_lock(&lock->wait_lock);
+
+	if (likely(rt_mutex_owner(lock) != current)) {
+
+		ret = try_to_take_rt_mutex(lock, current, NULL);
+		/*
+		 * try_to_take_rt_mutex() sets the lock waiters
+		 * bit unconditionally. Clean this up.
+		 */
+		fixup_rt_mutex_waiters(lock);
+	}
+
+	raw_spin_unlock(&lock->wait_lock);
+
+	return ret;
+}
+
+/*
+ * Slow path to release a rt-mutex:
+ */
+static void __sched
+rt_mutex_slowunlock(struct rt_mutex *lock)
+{
+	raw_spin_lock(&lock->wait_lock);
+
+	debug_rt_mutex_unlock(lock);
+
+	rt_mutex_deadlock_account_unlock(current);
+
+	if (!rt_mutex_has_waiters(lock)) {
+		lock->owner = NULL;
+		raw_spin_unlock(&lock->wait_lock);
+		return;
+	}
+
+	wakeup_next_waiter(lock);
+
+	raw_spin_unlock(&lock->wait_lock);
+
+	/* Undo pi boosting if necessary: */
+	rt_mutex_adjust_prio(current);
+}
+
+/*
+ * debug aware fast / slowpath lock,trylock,unlock
+ *
+ * The atomic acquire/release ops are compiled away, when either the
+ * architecture does not support cmpxchg or when debugging is enabled.
+ */
+static inline int
+rt_mutex_fastlock(struct rt_mutex *lock, int state,
+		  int detect_deadlock,
+		  int (*slowfn)(struct rt_mutex *lock, int state,
+				struct hrtimer_sleeper *timeout,
+				int detect_deadlock))
+{
+	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
+		rt_mutex_deadlock_account_lock(lock, current);
+		return 0;
+	} else
+		return slowfn(lock, state, NULL, detect_deadlock);
+}
+
+static inline int
+rt_mutex_timed_fastlock(struct rt_mutex *lock, int state,
+			struct hrtimer_sleeper *timeout, int detect_deadlock,
+			int (*slowfn)(struct rt_mutex *lock, int state,
+				      struct hrtimer_sleeper *timeout,
+				      int detect_deadlock))
+{
+	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
+		rt_mutex_deadlock_account_lock(lock, current);
+		return 0;
+	} else
+		return slowfn(lock, state, timeout, detect_deadlock);
+}
+
+static inline int
+rt_mutex_fasttrylock(struct rt_mutex *lock,
+		     int (*slowfn)(struct rt_mutex *lock))
+{
+	if (likely(rt_mutex_cmpxchg(lock, NULL, current))) {
+		rt_mutex_deadlock_account_lock(lock, current);
+		return 1;
+	}
+	return slowfn(lock);
+}
+
+static inline void
+rt_mutex_fastunlock(struct rt_mutex *lock,
+		    void (*slowfn)(struct rt_mutex *lock))
+{
+	if (likely(rt_mutex_cmpxchg(lock, current, NULL)))
+		rt_mutex_deadlock_account_unlock(current);
+	else
+		slowfn(lock);
+}
+
+/**
+ * rt_mutex_lock - lock a rt_mutex
+ *
+ * @lock: the rt_mutex to be locked
+ */
+void __sched rt_mutex_lock(struct rt_mutex *lock)
+{
+	might_sleep();
+
+	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, 0, rt_mutex_slowlock);
+}
+EXPORT_SYMBOL_GPL(rt_mutex_lock);
+
+/**
+ * rt_mutex_lock_interruptible - lock a rt_mutex interruptible
+ *
+ * @lock: 		the rt_mutex to be locked
+ * @detect_deadlock:	deadlock detection on/off
+ *
+ * Returns:
+ *  0 		on success
+ * -EINTR 	when interrupted by a signal
+ * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
+ */
+int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
+						 int detect_deadlock)
+{
+	might_sleep();
+
+	return rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE,
+				 detect_deadlock, rt_mutex_slowlock);
+}
+EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
+
+/**
+ * rt_mutex_timed_lock - lock a rt_mutex interruptible
+ *			the timeout structure is provided
+ *			by the caller
+ *
+ * @lock: 		the rt_mutex to be locked
+ * @timeout:		timeout structure or NULL (no timeout)
+ * @detect_deadlock:	deadlock detection on/off
+ *
+ * Returns:
+ *  0 		on success
+ * -EINTR 	when interrupted by a signal
+ * -ETIMEDOUT	when the timeout expired
+ * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
+ */
+int
+rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout,
+		    int detect_deadlock)
+{
+	might_sleep();
+
+	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
+				       detect_deadlock, rt_mutex_slowlock);
+}
+EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
+
+/**
+ * rt_mutex_trylock - try to lock a rt_mutex
+ *
+ * @lock:	the rt_mutex to be locked
+ *
+ * Returns 1 on success and 0 on contention
+ */
+int __sched rt_mutex_trylock(struct rt_mutex *lock)
+{
+	return rt_mutex_fasttrylock(lock, rt_mutex_slowtrylock);
+}
+EXPORT_SYMBOL_GPL(rt_mutex_trylock);
+
+/**
+ * rt_mutex_unlock - unlock a rt_mutex
+ *
+ * @lock: the rt_mutex to be unlocked
+ */
+void __sched rt_mutex_unlock(struct rt_mutex *lock)
+{
+	rt_mutex_fastunlock(lock, rt_mutex_slowunlock);
+}
+EXPORT_SYMBOL_GPL(rt_mutex_unlock);
+
+/**
+ * rt_mutex_destroy - mark a mutex unusable
+ * @lock: the mutex to be destroyed
+ *
+ * This function marks the mutex uninitialized, and any subsequent
+ * use of the mutex is forbidden. The mutex must not be locked when
+ * this function is called.
+ */
+void rt_mutex_destroy(struct rt_mutex *lock)
+{
+	WARN_ON(rt_mutex_is_locked(lock));
+#ifdef CONFIG_DEBUG_RT_MUTEXES
+	lock->magic = NULL;
+#endif
+}
+
+EXPORT_SYMBOL_GPL(rt_mutex_destroy);
+
+/**
+ * __rt_mutex_init - initialize the rt lock
+ *
+ * @lock: the rt lock to be initialized
+ *
+ * Initialize the rt lock to unlocked state.
+ *
+ * Initializing of a locked rt lock is not allowed
+ */
+void __rt_mutex_init(struct rt_mutex *lock, const char *name)
+{
+	lock->owner = NULL;
+	raw_spin_lock_init(&lock->wait_lock);
+	plist_head_init(&lock->wait_list);
+
+	debug_rt_mutex_init(lock, name);
+}
+EXPORT_SYMBOL_GPL(__rt_mutex_init);
+
+/**
+ * rt_mutex_init_proxy_locked - initialize and lock a rt_mutex on behalf of a
+ *				proxy owner
+ *
+ * @lock: 	the rt_mutex to be locked
+ * @proxy_owner:the task to set as owner
+ *
+ * No locking. Caller has to do serializing itself
+ * Special API call for PI-futex support
+ */
+void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
+				struct task_struct *proxy_owner)
+{
+	__rt_mutex_init(lock, NULL);
+	debug_rt_mutex_proxy_lock(lock, proxy_owner);
+	rt_mutex_set_owner(lock, proxy_owner);
+	rt_mutex_deadlock_account_lock(lock, proxy_owner);
+}
+
+/**
+ * rt_mutex_proxy_unlock - release a lock on behalf of owner
+ *
+ * @lock: 	the rt_mutex to be locked
+ *
+ * No locking. Caller has to do serializing itself
+ * Special API call for PI-futex support
+ */
+void rt_mutex_proxy_unlock(struct rt_mutex *lock,
+			   struct task_struct *proxy_owner)
+{
+	debug_rt_mutex_proxy_unlock(lock);
+	rt_mutex_set_owner(lock, NULL);
+	rt_mutex_deadlock_account_unlock(proxy_owner);
+}
+
+/**
+ * rt_mutex_start_proxy_lock() - Start lock acquisition for another task
+ * @lock:		the rt_mutex to take
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @task:		the task to prepare
+ * @detect_deadlock:	perform deadlock detection (1) or not (0)
+ *
+ * Returns:
+ *  0 - task blocked on lock
+ *  1 - acquired the lock for task, caller should wake it up
+ * <0 - error
+ *
+ * Special API call for FUTEX_REQUEUE_PI support.
+ */
+int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+			      struct rt_mutex_waiter *waiter,
+			      struct task_struct *task, int detect_deadlock)
+{
+	int ret;
+
+	raw_spin_lock(&lock->wait_lock);
+
+	if (try_to_take_rt_mutex(lock, task, NULL)) {
+		raw_spin_unlock(&lock->wait_lock);
+		return 1;
+	}
+
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+
+	if (ret && !rt_mutex_owner(lock)) {
+		/*
+		 * Reset the return value. We might have
+		 * returned with -EDEADLK and the owner
+		 * released the lock while we were walking the
+		 * pi chain.  Let the waiter sort it out.
+		 */
+		ret = 0;
+	}
+
+	if (unlikely(ret))
+		remove_waiter(lock, waiter);
+
+	raw_spin_unlock(&lock->wait_lock);
+
+	debug_rt_mutex_print_deadlock(waiter);
+
+	return ret;
+}
+
+/**
+ * rt_mutex_next_owner - return the next owner of the lock
+ *
+ * @lock: the rt lock query
+ *
+ * Returns the next owner of the lock or NULL
+ *
+ * Caller has to serialize against other accessors to the lock
+ * itself.
+ *
+ * Special API call for PI-futex support
+ */
+struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock)
+{
+	if (!rt_mutex_has_waiters(lock))
+		return NULL;
+
+	return rt_mutex_top_waiter(lock)->task;
+}
+
+/**
+ * rt_mutex_finish_proxy_lock() - Complete lock acquisition
+ * @lock:		the rt_mutex we were woken on
+ * @to:			the timeout, null if none. hrtimer should already have
+ * 			been started.
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @detect_deadlock:	perform deadlock detection (1) or not (0)
+ *
+ * Complete the lock acquisition started our behalf by another thread.
+ *
+ * Returns:
+ *  0 - success
+ * <0 - error, one of -EINTR, -ETIMEDOUT, or -EDEADLK
+ *
+ * Special API call for PI-futex requeue support
+ */
+int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
+			       struct hrtimer_sleeper *to,
+			       struct rt_mutex_waiter *waiter,
+			       int detect_deadlock)
+{
+	int ret;
+
+	raw_spin_lock(&lock->wait_lock);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
+
+	set_current_state(TASK_RUNNING);
+
+	if (unlikely(ret))
+		remove_waiter(lock, waiter);
+
+	/*
+	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
+	 * have to fix that up.
+	 */
+	fixup_rt_mutex_waiters(lock);
+
+	raw_spin_unlock(&lock->wait_lock);
+
+	return ret;
+}
--- /dev/null
+++ b/kernel/locking/rtmutex.h
@@ -0,0 +1,26 @@
+/*
+ * RT-Mutexes: blocking mutual exclusion locks with PI support
+ *
+ * started by Ingo Molnar and Thomas Gleixner:
+ *
+ *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *
+ * This file contains macros used solely by rtmutex.c.
+ * Non-debug version.
+ */
+
+#define rt_mutex_deadlock_check(l)			(0)
+#define rt_mutex_deadlock_account_lock(m, t)		do { } while (0)
+#define rt_mutex_deadlock_account_unlock(l)		do { } while (0)
+#define debug_rt_mutex_init_waiter(w)			do { } while (0)
+#define debug_rt_mutex_free_waiter(w)			do { } while (0)
+#define debug_rt_mutex_lock(l)				do { } while (0)
+#define debug_rt_mutex_proxy_lock(l,p)			do { } while (0)
+#define debug_rt_mutex_proxy_unlock(l)			do { } while (0)
+#define debug_rt_mutex_unlock(l)			do { } while (0)
+#define debug_rt_mutex_init(m, n)			do { } while (0)
+#define debug_rt_mutex_deadlock(d, a ,l)		do { } while (0)
+#define debug_rt_mutex_print_deadlock(w)		do { } while (0)
+#define debug_rt_mutex_detect_deadlock(w,d)		(d)
+#define debug_rt_mutex_reset_waiter(w)			do { } while (0)
--- /dev/null
+++ b/kernel/locking/rtmutex_common.h
@@ -0,0 +1,126 @@
+/*
+ * RT Mutexes: blocking mutual exclusion locks with PI support
+ *
+ * started by Ingo Molnar and Thomas Gleixner:
+ *
+ *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *
+ * This file contains the private data structure and API definitions.
+ */
+
+#ifndef __KERNEL_RTMUTEX_COMMON_H
+#define __KERNEL_RTMUTEX_COMMON_H
+
+#include <linux/rtmutex.h>
+
+/*
+ * The rtmutex in kernel tester is independent of rtmutex debugging. We
+ * call schedule_rt_mutex_test() instead of schedule() for the tasks which
+ * belong to the tester. That way we can delay the wakeup path of those
+ * threads to provoke lock stealing and testing of  complex boosting scenarios.
+ */
+#ifdef CONFIG_RT_MUTEX_TESTER
+
+extern void schedule_rt_mutex_test(struct rt_mutex *lock);
+
+#define schedule_rt_mutex(_lock)				\
+  do {								\
+	if (!(current->flags & PF_MUTEX_TESTER))		\
+		schedule();					\
+	else							\
+		schedule_rt_mutex_test(_lock);			\
+  } while (0)
+
+#else
+# define schedule_rt_mutex(_lock)			schedule()
+#endif
+
+/*
+ * This is the control structure for tasks blocked on a rt_mutex,
+ * which is allocated on the kernel stack on of the blocked task.
+ *
+ * @list_entry:		pi node to enqueue into the mutex waiters list
+ * @pi_list_entry:	pi node to enqueue into the mutex owner waiters list
+ * @task:		task reference to the blocked task
+ */
+struct rt_mutex_waiter {
+	struct plist_node	list_entry;
+	struct plist_node	pi_list_entry;
+	struct task_struct	*task;
+	struct rt_mutex		*lock;
+#ifdef CONFIG_DEBUG_RT_MUTEXES
+	unsigned long		ip;
+	struct pid		*deadlock_task_pid;
+	struct rt_mutex		*deadlock_lock;
+#endif
+};
+
+/*
+ * Various helpers to access the waiters-plist:
+ */
+static inline int rt_mutex_has_waiters(struct rt_mutex *lock)
+{
+	return !plist_head_empty(&lock->wait_list);
+}
+
+static inline struct rt_mutex_waiter *
+rt_mutex_top_waiter(struct rt_mutex *lock)
+{
+	struct rt_mutex_waiter *w;
+
+	w = plist_first_entry(&lock->wait_list, struct rt_mutex_waiter,
+			       list_entry);
+	BUG_ON(w->lock != lock);
+
+	return w;
+}
+
+static inline int task_has_pi_waiters(struct task_struct *p)
+{
+	return !plist_head_empty(&p->pi_waiters);
+}
+
+static inline struct rt_mutex_waiter *
+task_top_pi_waiter(struct task_struct *p)
+{
+	return plist_first_entry(&p->pi_waiters, struct rt_mutex_waiter,
+				  pi_list_entry);
+}
+
+/*
+ * lock->owner state tracking:
+ */
+#define RT_MUTEX_HAS_WAITERS	1UL
+#define RT_MUTEX_OWNER_MASKALL	1UL
+
+static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
+{
+	return (struct task_struct *)
+		((unsigned long)lock->owner & ~RT_MUTEX_OWNER_MASKALL);
+}
+
+/*
+ * PI-futex support (proxy locking functions, etc.):
+ */
+extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
+extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
+				       struct task_struct *proxy_owner);
+extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
+				  struct task_struct *proxy_owner);
+extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+				     struct rt_mutex_waiter *waiter,
+				     struct task_struct *task,
+				     int detect_deadlock);
+extern int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
+				      struct hrtimer_sleeper *to,
+				      struct rt_mutex_waiter *waiter,
+				      int detect_deadlock);
+
+#ifdef CONFIG_DEBUG_RT_MUTEXES
+# include "rtmutex-debug.h"
+#else
+# include "rtmutex.h"
+#endif
+
+#endif
--- a/kernel/rtmutex-debug.c
+++ /dev/null
@@ -1,187 +0,0 @@
-/*
- * RT-Mutexes: blocking mutual exclusion locks with PI support
- *
- * started by Ingo Molnar and Thomas Gleixner:
- *
- *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- *  Copyright (C) 2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
- *
- * This code is based on the rt.c implementation in the preempt-rt tree.
- * Portions of said code are
- *
- *  Copyright (C) 2004  LynuxWorks, Inc., Igor Manyilov, Bill Huey
- *  Copyright (C) 2006  Esben Nielsen
- *  Copyright (C) 2006  Kihon Technologies Inc.,
- *			Steven Rostedt <rostedt@goodmis.org>
- *
- * See rt.c in preempt-rt for proper credits and further information
- */
-#include <linux/sched.h>
-#include <linux/sched/rt.h>
-#include <linux/delay.h>
-#include <linux/export.h>
-#include <linux/spinlock.h>
-#include <linux/kallsyms.h>
-#include <linux/syscalls.h>
-#include <linux/interrupt.h>
-#include <linux/plist.h>
-#include <linux/fs.h>
-#include <linux/debug_locks.h>
-
-#include "rtmutex_common.h"
-
-static void printk_task(struct task_struct *p)
-{
-	if (p)
-		printk("%16s:%5d [%p, %3d]", p->comm, task_pid_nr(p), p, p->prio);
-	else
-		printk("<none>");
-}
-
-static void printk_lock(struct rt_mutex *lock, int print_owner)
-{
-	if (lock->name)
-		printk(" [%p] {%s}\n",
-			lock, lock->name);
-	else
-		printk(" [%p] {%s:%d}\n",
-			lock, lock->file, lock->line);
-
-	if (print_owner && rt_mutex_owner(lock)) {
-		printk(".. ->owner: %p\n", lock->owner);
-		printk(".. held by:  ");
-		printk_task(rt_mutex_owner(lock));
-		printk("\n");
-	}
-}
-
-void rt_mutex_debug_task_free(struct task_struct *task)
-{
-	DEBUG_LOCKS_WARN_ON(!plist_head_empty(&task->pi_waiters));
-	DEBUG_LOCKS_WARN_ON(task->pi_blocked_on);
-}
-
-/*
- * We fill out the fields in the waiter to store the information about
- * the deadlock. We print when we return. act_waiter can be NULL in
- * case of a remove waiter operation.
- */
-void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *act_waiter,
-			     struct rt_mutex *lock)
-{
-	struct task_struct *task;
-
-	if (!debug_locks || detect || !act_waiter)
-		return;
-
-	task = rt_mutex_owner(act_waiter->lock);
-	if (task && task != current) {
-		act_waiter->deadlock_task_pid = get_pid(task_pid(task));
-		act_waiter->deadlock_lock = lock;
-	}
-}
-
-void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter)
-{
-	struct task_struct *task;
-
-	if (!waiter->deadlock_lock || !debug_locks)
-		return;
-
-	rcu_read_lock();
-	task = pid_task(waiter->deadlock_task_pid, PIDTYPE_PID);
-	if (!task) {
-		rcu_read_unlock();
-		return;
-	}
-
-	if (!debug_locks_off()) {
-		rcu_read_unlock();
-		return;
-	}
-
-	printk("\n============================================\n");
-	printk(  "[ BUG: circular locking deadlock detected! ]\n");
-	printk("%s\n", print_tainted());
-	printk(  "--------------------------------------------\n");
-	printk("%s/%d is deadlocking current task %s/%d\n\n",
-	       task->comm, task_pid_nr(task),
-	       current->comm, task_pid_nr(current));
-
-	printk("\n1) %s/%d is trying to acquire this lock:\n",
-	       current->comm, task_pid_nr(current));
-	printk_lock(waiter->lock, 1);
-
-	printk("\n2) %s/%d is blocked on this lock:\n",
-		task->comm, task_pid_nr(task));
-	printk_lock(waiter->deadlock_lock, 1);
-
-	debug_show_held_locks(current);
-	debug_show_held_locks(task);
-
-	printk("\n%s/%d's [blocked] stackdump:\n\n",
-		task->comm, task_pid_nr(task));
-	show_stack(task, NULL);
-	printk("\n%s/%d's [current] stackdump:\n\n",
-		current->comm, task_pid_nr(current));
-	dump_stack();
-	debug_show_all_locks();
-	rcu_read_unlock();
-
-	printk("[ turning off deadlock detection."
-	       "Please report this trace. ]\n\n");
-}
-
-void debug_rt_mutex_lock(struct rt_mutex *lock)
-{
-}
-
-void debug_rt_mutex_unlock(struct rt_mutex *lock)
-{
-	DEBUG_LOCKS_WARN_ON(rt_mutex_owner(lock) != current);
-}
-
-void
-debug_rt_mutex_proxy_lock(struct rt_mutex *lock, struct task_struct *powner)
-{
-}
-
-void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock)
-{
-	DEBUG_LOCKS_WARN_ON(!rt_mutex_owner(lock));
-}
-
-void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
-{
-	memset(waiter, 0x11, sizeof(*waiter));
-	plist_node_init(&waiter->list_entry, MAX_PRIO);
-	plist_node_init(&waiter->pi_list_entry, MAX_PRIO);
-	waiter->deadlock_task_pid = NULL;
-}
-
-void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
-{
-	put_pid(waiter->deadlock_task_pid);
-	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->list_entry));
-	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
-	memset(waiter, 0x22, sizeof(*waiter));
-}
-
-void debug_rt_mutex_init(struct rt_mutex *lock, const char *name)
-{
-	/*
-	 * Make sure we are not reinitializing a held lock:
-	 */
-	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lock->name = name;
-}
-
-void
-rt_mutex_deadlock_account_lock(struct rt_mutex *lock, struct task_struct *task)
-{
-}
-
-void rt_mutex_deadlock_account_unlock(struct task_struct *task)
-{
-}
-
--- a/kernel/rtmutex-debug.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * RT-Mutexes: blocking mutual exclusion locks with PI support
- *
- * started by Ingo Molnar and Thomas Gleixner:
- *
- *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
- *
- * This file contains macros used solely by rtmutex.c. Debug version.
- */
-
-extern void
-rt_mutex_deadlock_account_lock(struct rt_mutex *lock, struct task_struct *task);
-extern void rt_mutex_deadlock_account_unlock(struct task_struct *task);
-extern void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter);
-extern void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter);
-extern void debug_rt_mutex_init(struct rt_mutex *lock, const char *name);
-extern void debug_rt_mutex_lock(struct rt_mutex *lock);
-extern void debug_rt_mutex_unlock(struct rt_mutex *lock);
-extern void debug_rt_mutex_proxy_lock(struct rt_mutex *lock,
-				      struct task_struct *powner);
-extern void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock);
-extern void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *waiter,
-				    struct rt_mutex *lock);
-extern void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter);
-# define debug_rt_mutex_reset_waiter(w)			\
-	do { (w)->deadlock_lock = NULL; } while (0)
-
-static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
-						 int detect)
-{
-	return (waiter != NULL);
-}
--- a/kernel/rtmutex-tester.c
+++ /dev/null
@@ -1,420 +0,0 @@
-/*
- * RT-Mutex-tester: scriptable tester for rt mutexes
- *
- * started by Thomas Gleixner:
- *
- *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
- *
- */
-#include <linux/device.h>
-#include <linux/kthread.h>
-#include <linux/export.h>
-#include <linux/sched.h>
-#include <linux/sched/rt.h>
-#include <linux/spinlock.h>
-#include <linux/timer.h>
-#include <linux/freezer.h>
-#include <linux/stat.h>
-
-#include "rtmutex.h"
-
-#define MAX_RT_TEST_THREADS	8
-#define MAX_RT_TEST_MUTEXES	8
-
-static spinlock_t rttest_lock;
-static atomic_t rttest_event;
-
-struct test_thread_data {
-	int			opcode;
-	int			opdata;
-	int			mutexes[MAX_RT_TEST_MUTEXES];
-	int			event;
-	struct device		dev;
-};
-
-static struct test_thread_data thread_data[MAX_RT_TEST_THREADS];
-static struct task_struct *threads[MAX_RT_TEST_THREADS];
-static struct rt_mutex mutexes[MAX_RT_TEST_MUTEXES];
-
-enum test_opcodes {
-	RTTEST_NOP = 0,
-	RTTEST_SCHEDOT,		/* 1 Sched other, data = nice */
-	RTTEST_SCHEDRT,		/* 2 Sched fifo, data = prio */
-	RTTEST_LOCK,		/* 3 Lock uninterruptible, data = lockindex */
-	RTTEST_LOCKNOWAIT,	/* 4 Lock uninterruptible no wait in wakeup, data = lockindex */
-	RTTEST_LOCKINT,		/* 5 Lock interruptible, data = lockindex */
-	RTTEST_LOCKINTNOWAIT,	/* 6 Lock interruptible no wait in wakeup, data = lockindex */
-	RTTEST_LOCKCONT,	/* 7 Continue locking after the wakeup delay */
-	RTTEST_UNLOCK,		/* 8 Unlock, data = lockindex */
-	/* 9, 10 - reserved for BKL commemoration */
-	RTTEST_SIGNAL = 11,	/* 11 Signal other test thread, data = thread id */
-	RTTEST_RESETEVENT = 98,	/* 98 Reset event counter */
-	RTTEST_RESET = 99,	/* 99 Reset all pending operations */
-};
-
-static int handle_op(struct test_thread_data *td, int lockwakeup)
-{
-	int i, id, ret = -EINVAL;
-
-	switch(td->opcode) {
-
-	case RTTEST_NOP:
-		return 0;
-
-	case RTTEST_LOCKCONT:
-		td->mutexes[td->opdata] = 1;
-		td->event = atomic_add_return(1, &rttest_event);
-		return 0;
-
-	case RTTEST_RESET:
-		for (i = 0; i < MAX_RT_TEST_MUTEXES; i++) {
-			if (td->mutexes[i] == 4) {
-				rt_mutex_unlock(&mutexes[i]);
-				td->mutexes[i] = 0;
-			}
-		}
-		return 0;
-
-	case RTTEST_RESETEVENT:
-		atomic_set(&rttest_event, 0);
-		return 0;
-
-	default:
-		if (lockwakeup)
-			return ret;
-	}
-
-	switch(td->opcode) {
-
-	case RTTEST_LOCK:
-	case RTTEST_LOCKNOWAIT:
-		id = td->opdata;
-		if (id < 0 || id >= MAX_RT_TEST_MUTEXES)
-			return ret;
-
-		td->mutexes[id] = 1;
-		td->event = atomic_add_return(1, &rttest_event);
-		rt_mutex_lock(&mutexes[id]);
-		td->event = atomic_add_return(1, &rttest_event);
-		td->mutexes[id] = 4;
-		return 0;
-
-	case RTTEST_LOCKINT:
-	case RTTEST_LOCKINTNOWAIT:
-		id = td->opdata;
-		if (id < 0 || id >= MAX_RT_TEST_MUTEXES)
-			return ret;
-
-		td->mutexes[id] = 1;
-		td->event = atomic_add_return(1, &rttest_event);
-		ret = rt_mutex_lock_interruptible(&mutexes[id], 0);
-		td->event = atomic_add_return(1, &rttest_event);
-		td->mutexes[id] = ret ? 0 : 4;
-		return ret ? -EINTR : 0;
-
-	case RTTEST_UNLOCK:
-		id = td->opdata;
-		if (id < 0 || id >= MAX_RT_TEST_MUTEXES || td->mutexes[id] != 4)
-			return ret;
-
-		td->event = atomic_add_return(1, &rttest_event);
-		rt_mutex_unlock(&mutexes[id]);
-		td->event = atomic_add_return(1, &rttest_event);
-		td->mutexes[id] = 0;
-		return 0;
-
-	default:
-		break;
-	}
-	return ret;
-}
-
-/*
- * Schedule replacement for rtsem_down(). Only called for threads with
- * PF_MUTEX_TESTER set.
- *
- * This allows us to have finegrained control over the event flow.
- *
- */
-void schedule_rt_mutex_test(struct rt_mutex *mutex)
-{
-	int tid, op, dat;
-	struct test_thread_data *td;
-
-	/* We have to lookup the task */
-	for (tid = 0; tid < MAX_RT_TEST_THREADS; tid++) {
-		if (threads[tid] == current)
-			break;
-	}
-
-	BUG_ON(tid == MAX_RT_TEST_THREADS);
-
-	td = &thread_data[tid];
-
-	op = td->opcode;
-	dat = td->opdata;
-
-	switch (op) {
-	case RTTEST_LOCK:
-	case RTTEST_LOCKINT:
-	case RTTEST_LOCKNOWAIT:
-	case RTTEST_LOCKINTNOWAIT:
-		if (mutex != &mutexes[dat])
-			break;
-
-		if (td->mutexes[dat] != 1)
-			break;
-
-		td->mutexes[dat] = 2;
-		td->event = atomic_add_return(1, &rttest_event);
-		break;
-
-	default:
-		break;
-	}
-
-	schedule();
-
-
-	switch (op) {
-	case RTTEST_LOCK:
-	case RTTEST_LOCKINT:
-		if (mutex != &mutexes[dat])
-			return;
-
-		if (td->mutexes[dat] != 2)
-			return;
-
-		td->mutexes[dat] = 3;
-		td->event = atomic_add_return(1, &rttest_event);
-		break;
-
-	case RTTEST_LOCKNOWAIT:
-	case RTTEST_LOCKINTNOWAIT:
-		if (mutex != &mutexes[dat])
-			return;
-
-		if (td->mutexes[dat] != 2)
-			return;
-
-		td->mutexes[dat] = 1;
-		td->event = atomic_add_return(1, &rttest_event);
-		return;
-
-	default:
-		return;
-	}
-
-	td->opcode = 0;
-
-	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		if (td->opcode > 0) {
-			int ret;
-
-			set_current_state(TASK_RUNNING);
-			ret = handle_op(td, 1);
-			set_current_state(TASK_INTERRUPTIBLE);
-			if (td->opcode == RTTEST_LOCKCONT)
-				break;
-			td->opcode = ret;
-		}
-
-		/* Wait for the next command to be executed */
-		schedule();
-	}
-
-	/* Restore previous command and data */
-	td->opcode = op;
-	td->opdata = dat;
-}
-
-static int test_func(void *data)
-{
-	struct test_thread_data *td = data;
-	int ret;
-
-	current->flags |= PF_MUTEX_TESTER;
-	set_freezable();
-	allow_signal(SIGHUP);
-
-	for(;;) {
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		if (td->opcode > 0) {
-			set_current_state(TASK_RUNNING);
-			ret = handle_op(td, 0);
-			set_current_state(TASK_INTERRUPTIBLE);
-			td->opcode = ret;
-		}
-
-		/* Wait for the next command to be executed */
-		schedule();
-		try_to_freeze();
-
-		if (signal_pending(current))
-			flush_signals(current);
-
-		if(kthread_should_stop())
-			break;
-	}
-	return 0;
-}
-
-/**
- * sysfs_test_command - interface for test commands
- * @dev:	thread reference
- * @buf:	command for actual step
- * @count:	length of buffer
- *
- * command syntax:
- *
- * opcode:data
- */
-static ssize_t sysfs_test_command(struct device *dev, struct device_attribute *attr,
-				  const char *buf, size_t count)
-{
-	struct sched_param schedpar;
-	struct test_thread_data *td;
-	char cmdbuf[32];
-	int op, dat, tid, ret;
-
-	td = container_of(dev, struct test_thread_data, dev);
-	tid = td->dev.id;
-
-	/* strings from sysfs write are not 0 terminated! */
-	if (count >= sizeof(cmdbuf))
-		return -EINVAL;
-
-	/* strip of \n: */
-	if (buf[count-1] == '\n')
-		count--;
-	if (count < 1)
-		return -EINVAL;
-
-	memcpy(cmdbuf, buf, count);
-	cmdbuf[count] = 0;
-
-	if (sscanf(cmdbuf, "%d:%d", &op, &dat) != 2)
-		return -EINVAL;
-
-	switch (op) {
-	case RTTEST_SCHEDOT:
-		schedpar.sched_priority = 0;
-		ret = sched_setscheduler(threads[tid], SCHED_NORMAL, &schedpar);
-		if (ret)
-			return ret;
-		set_user_nice(current, 0);
-		break;
-
-	case RTTEST_SCHEDRT:
-		schedpar.sched_priority = dat;
-		ret = sched_setscheduler(threads[tid], SCHED_FIFO, &schedpar);
-		if (ret)
-			return ret;
-		break;
-
-	case RTTEST_SIGNAL:
-		send_sig(SIGHUP, threads[tid], 0);
-		break;
-
-	default:
-		if (td->opcode > 0)
-			return -EBUSY;
-		td->opdata = dat;
-		td->opcode = op;
-		wake_up_process(threads[tid]);
-	}
-
-	return count;
-}
-
-/**
- * sysfs_test_status - sysfs interface for rt tester
- * @dev:	thread to query
- * @buf:	char buffer to be filled with thread status info
- */
-static ssize_t sysfs_test_status(struct device *dev, struct device_attribute *attr,
-				 char *buf)
-{
-	struct test_thread_data *td;
-	struct task_struct *tsk;
-	char *curr = buf;
-	int i;
-
-	td = container_of(dev, struct test_thread_data, dev);
-	tsk = threads[td->dev.id];
-
-	spin_lock(&rttest_lock);
-
-	curr += sprintf(curr,
-		"O: %4d, E:%8d, S: 0x%08lx, P: %4d, N: %4d, B: %p, M:",
-		td->opcode, td->event, tsk->state,
-			(MAX_RT_PRIO - 1) - tsk->prio,
-			(MAX_RT_PRIO - 1) - tsk->normal_prio,
-		tsk->pi_blocked_on);
-
-	for (i = MAX_RT_TEST_MUTEXES - 1; i >=0 ; i--)
-		curr += sprintf(curr, "%d", td->mutexes[i]);
-
-	spin_unlock(&rttest_lock);
-
-	curr += sprintf(curr, ", T: %p, R: %p\n", tsk,
-			mutexes[td->dev.id].owner);
-
-	return curr - buf;
-}
-
-static DEVICE_ATTR(status, S_IRUSR, sysfs_test_status, NULL);
-static DEVICE_ATTR(command, S_IWUSR, NULL, sysfs_test_command);
-
-static struct bus_type rttest_subsys = {
-	.name = "rttest",
-	.dev_name = "rttest",
-};
-
-static int init_test_thread(int id)
-{
-	thread_data[id].dev.bus = &rttest_subsys;
-	thread_data[id].dev.id = id;
-
-	threads[id] = kthread_run(test_func, &thread_data[id], "rt-test-%d", id);
-	if (IS_ERR(threads[id]))
-		return PTR_ERR(threads[id]);
-
-	return device_register(&thread_data[id].dev);
-}
-
-static int init_rttest(void)
-{
-	int ret, i;
-
-	spin_lock_init(&rttest_lock);
-
-	for (i = 0; i < MAX_RT_TEST_MUTEXES; i++)
-		rt_mutex_init(&mutexes[i]);
-
-	ret = subsys_system_register(&rttest_subsys, NULL);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < MAX_RT_TEST_THREADS; i++) {
-		ret = init_test_thread(i);
-		if (ret)
-			break;
-		ret = device_create_file(&thread_data[i].dev, &dev_attr_status);
-		if (ret)
-			break;
-		ret = device_create_file(&thread_data[i].dev, &dev_attr_command);
-		if (ret)
-			break;
-	}
-
-	printk("Initializing RT-Tester: %s\n", ret ? "Failed" : "OK" );
-
-	return ret;
-}
-
-device_initcall(init_rttest);
--- a/kernel/rtmutex.c
+++ /dev/null
@@ -1,1060 +0,0 @@
-/*
- * RT-Mutexes: simple blocking mutual exclusion locks with PI support
- *
- * started by Ingo Molnar and Thomas Gleixner.
- *
- *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- *  Copyright (C) 2005-2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
- *  Copyright (C) 2005 Kihon Technologies Inc., Steven Rostedt
- *  Copyright (C) 2006 Esben Nielsen
- *
- *  See Documentation/rt-mutex-design.txt for details.
- */
-#include <linux/spinlock.h>
-#include <linux/export.h>
-#include <linux/sched.h>
-#include <linux/sched/rt.h>
-#include <linux/timer.h>
-
-#include "rtmutex_common.h"
-
-/*
- * lock->owner state tracking:
- *
- * lock->owner holds the task_struct pointer of the owner. Bit 0
- * is used to keep track of the "lock has waiters" state.
- *
- * owner	bit0
- * NULL		0	lock is free (fast acquire possible)
- * NULL		1	lock is free and has waiters and the top waiter
- *				is going to take the lock*
- * taskpointer	0	lock is held (fast release possible)
- * taskpointer	1	lock is held and has waiters**
- *
- * The fast atomic compare exchange based acquire and release is only
- * possible when bit 0 of lock->owner is 0.
- *
- * (*) It also can be a transitional state when grabbing the lock
- * with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
- * we need to set the bit0 before looking at the lock, and the owner may be
- * NULL in this small time, hence this can be a transitional state.
- *
- * (**) There is a small time when bit 0 is set but there are no
- * waiters. This can happen when grabbing the lock in the slow path.
- * To prevent a cmpxchg of the owner releasing the lock, we need to
- * set this bit before looking at the lock.
- */
-
-static void
-rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner)
-{
-	unsigned long val = (unsigned long)owner;
-
-	if (rt_mutex_has_waiters(lock))
-		val |= RT_MUTEX_HAS_WAITERS;
-
-	lock->owner = (struct task_struct *)val;
-}
-
-static inline void clear_rt_mutex_waiters(struct rt_mutex *lock)
-{
-	lock->owner = (struct task_struct *)
-			((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
-}
-
-static void fixup_rt_mutex_waiters(struct rt_mutex *lock)
-{
-	if (!rt_mutex_has_waiters(lock))
-		clear_rt_mutex_waiters(lock);
-}
-
-/*
- * We can speed up the acquire/release, if the architecture
- * supports cmpxchg and if there's no debugging state to be set up
- */
-#if defined(__HAVE_ARCH_CMPXCHG) && !defined(CONFIG_DEBUG_RT_MUTEXES)
-# define rt_mutex_cmpxchg(l,c,n)	(cmpxchg(&l->owner, c, n) == c)
-static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
-{
-	unsigned long owner, *p = (unsigned long *) &lock->owner;
-
-	do {
-		owner = *p;
-	} while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner);
-}
-#else
-# define rt_mutex_cmpxchg(l,c,n)	(0)
-static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
-{
-	lock->owner = (struct task_struct *)
-			((unsigned long)lock->owner | RT_MUTEX_HAS_WAITERS);
-}
-#endif
-
-/*
- * Calculate task priority from the waiter list priority
- *
- * Return task->normal_prio when the waiter list is empty or when
- * the waiter is not allowed to do priority boosting
- */
-int rt_mutex_getprio(struct task_struct *task)
-{
-	if (likely(!task_has_pi_waiters(task)))
-		return task->normal_prio;
-
-	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
-		   task->normal_prio);
-}
-
-/*
- * Adjust the priority of a task, after its pi_waiters got modified.
- *
- * This can be both boosting and unboosting. task->pi_lock must be held.
- */
-static void __rt_mutex_adjust_prio(struct task_struct *task)
-{
-	int prio = rt_mutex_getprio(task);
-
-	if (task->prio != prio)
-		rt_mutex_setprio(task, prio);
-}
-
-/*
- * Adjust task priority (undo boosting). Called from the exit path of
- * rt_mutex_slowunlock() and rt_mutex_slowlock().
- *
- * (Note: We do this outside of the protection of lock->wait_lock to
- * allow the lock to be taken while or before we readjust the priority
- * of task. We do not use the spin_xx_mutex() variants here as we are
- * outside of the debug path.)
- */
-static void rt_mutex_adjust_prio(struct task_struct *task)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	__rt_mutex_adjust_prio(task);
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-}
-
-/*
- * Max number of times we'll walk the boosting chain:
- */
-int max_lock_depth = 1024;
-
-/*
- * Adjust the priority chain. Also used for deadlock detection.
- * Decreases task's usage by one - may thus free the task.
- *
- * @task: the task owning the mutex (owner) for which a chain walk is probably
- *	  needed
- * @deadlock_detect: do we have to carry out deadlock detection?
- * @orig_lock: the mutex (can be NULL if we are walking the chain to recheck
- * 	       things for a task that has just got its priority adjusted, and
- *	       is waiting on a mutex)
- * @orig_waiter: rt_mutex_waiter struct for the task that has just donated
- *		 its priority to the mutex owner (can be NULL in the case
- *		 depicted above or if the top waiter is gone away and we are
- *		 actually deboosting the owner)
- * @top_task: the current top waiter
- *
- * Returns 0 or -EDEADLK.
- */
-static int rt_mutex_adjust_prio_chain(struct task_struct *task,
-				      int deadlock_detect,
-				      struct rt_mutex *orig_lock,
-				      struct rt_mutex_waiter *orig_waiter,
-				      struct task_struct *top_task)
-{
-	struct rt_mutex *lock;
-	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
-	int detect_deadlock, ret = 0, depth = 0;
-	unsigned long flags;
-
-	detect_deadlock = debug_rt_mutex_detect_deadlock(orig_waiter,
-							 deadlock_detect);
-
-	/*
-	 * The (de)boosting is a step by step approach with a lot of
-	 * pitfalls. We want this to be preemptible and we want hold a
-	 * maximum of two locks per step. So we have to check
-	 * carefully whether things change under us.
-	 */
- again:
-	if (++depth > max_lock_depth) {
-		static int prev_max;
-
-		/*
-		 * Print this only once. If the admin changes the limit,
-		 * print a new message when reaching the limit again.
-		 */
-		if (prev_max != max_lock_depth) {
-			prev_max = max_lock_depth;
-			printk(KERN_WARNING "Maximum lock depth %d reached "
-			       "task: %s (%d)\n", max_lock_depth,
-			       top_task->comm, task_pid_nr(top_task));
-		}
-		put_task_struct(task);
-
-		return deadlock_detect ? -EDEADLK : 0;
-	}
- retry:
-	/*
-	 * Task can not go away as we did a get_task() before !
-	 */
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-
-	waiter = task->pi_blocked_on;
-	/*
-	 * Check whether the end of the boosting chain has been
-	 * reached or the state of the chain has changed while we
-	 * dropped the locks.
-	 */
-	if (!waiter)
-		goto out_unlock_pi;
-
-	/*
-	 * Check the orig_waiter state. After we dropped the locks,
-	 * the previous owner of the lock might have released the lock.
-	 */
-	if (orig_waiter && !rt_mutex_owner(orig_lock))
-		goto out_unlock_pi;
-
-	/*
-	 * Drop out, when the task has no waiters. Note,
-	 * top_waiter can be NULL, when we are in the deboosting
-	 * mode!
-	 */
-	if (top_waiter && (!task_has_pi_waiters(task) ||
-			   top_waiter != task_top_pi_waiter(task)))
-		goto out_unlock_pi;
-
-	/*
-	 * When deadlock detection is off then we check, if further
-	 * priority adjustment is necessary.
-	 */
-	if (!detect_deadlock && waiter->list_entry.prio == task->prio)
-		goto out_unlock_pi;
-
-	lock = waiter->lock;
-	if (!raw_spin_trylock(&lock->wait_lock)) {
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-		cpu_relax();
-		goto retry;
-	}
-
-	/* Deadlock detection */
-	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
-		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
-		raw_spin_unlock(&lock->wait_lock);
-		ret = deadlock_detect ? -EDEADLK : 0;
-		goto out_unlock_pi;
-	}
-
-	top_waiter = rt_mutex_top_waiter(lock);
-
-	/* Requeue the waiter */
-	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->list_entry.prio = task->prio;
-	plist_add(&waiter->list_entry, &lock->wait_list);
-
-	/* Release the task */
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	if (!rt_mutex_owner(lock)) {
-		/*
-		 * If the requeue above changed the top waiter, then we need
-		 * to wake the new top waiter up to try to get the lock.
-		 */
-
-		if (top_waiter != rt_mutex_top_waiter(lock))
-			wake_up_process(rt_mutex_top_waiter(lock)->task);
-		raw_spin_unlock(&lock->wait_lock);
-		goto out_put_task;
-	}
-	put_task_struct(task);
-
-	/* Grab the next task */
-	task = rt_mutex_owner(lock);
-	get_task_struct(task);
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-
-	if (waiter == rt_mutex_top_waiter(lock)) {
-		/* Boost the owner */
-		plist_del(&top_waiter->pi_list_entry, &task->pi_waiters);
-		waiter->pi_list_entry.prio = waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
-		__rt_mutex_adjust_prio(task);
-
-	} else if (top_waiter == waiter) {
-		/* Deboost the owner */
-		plist_del(&waiter->pi_list_entry, &task->pi_waiters);
-		waiter = rt_mutex_top_waiter(lock);
-		waiter->pi_list_entry.prio = waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
-		__rt_mutex_adjust_prio(task);
-	}
-
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-
-	top_waiter = rt_mutex_top_waiter(lock);
-	raw_spin_unlock(&lock->wait_lock);
-
-	if (!detect_deadlock && waiter != top_waiter)
-		goto out_put_task;
-
-	goto again;
-
- out_unlock_pi:
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
- out_put_task:
-	put_task_struct(task);
-
-	return ret;
-}
-
-/*
- * Try to take an rt-mutex
- *
- * Must be called with lock->wait_lock held.
- *
- * @lock:   the lock to be acquired.
- * @task:   the task which wants to acquire the lock
- * @waiter: the waiter that is queued to the lock's wait list. (could be NULL)
- */
-static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
-		struct rt_mutex_waiter *waiter)
-{
-	/*
-	 * We have to be careful here if the atomic speedups are
-	 * enabled, such that, when
-	 *  - no other waiter is on the lock
-	 *  - the lock has been released since we did the cmpxchg
-	 * the lock can be released or taken while we are doing the
-	 * checks and marking the lock with RT_MUTEX_HAS_WAITERS.
-	 *
-	 * The atomic acquire/release aware variant of
-	 * mark_rt_mutex_waiters uses a cmpxchg loop. After setting
-	 * the WAITERS bit, the atomic release / acquire can not
-	 * happen anymore and lock->wait_lock protects us from the
-	 * non-atomic case.
-	 *
-	 * Note, that this might set lock->owner =
-	 * RT_MUTEX_HAS_WAITERS in the case the lock is not contended
-	 * any more. This is fixed up when we take the ownership.
-	 * This is the transitional state explained at the top of this file.
-	 */
-	mark_rt_mutex_waiters(lock);
-
-	if (rt_mutex_owner(lock))
-		return 0;
-
-	/*
-	 * It will get the lock because of one of these conditions:
-	 * 1) there is no waiter
-	 * 2) higher priority than waiters
-	 * 3) it is top waiter
-	 */
-	if (rt_mutex_has_waiters(lock)) {
-		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio) {
-			if (!waiter || waiter != rt_mutex_top_waiter(lock))
-				return 0;
-		}
-	}
-
-	if (waiter || rt_mutex_has_waiters(lock)) {
-		unsigned long flags;
-		struct rt_mutex_waiter *top;
-
-		raw_spin_lock_irqsave(&task->pi_lock, flags);
-
-		/* remove the queued waiter. */
-		if (waiter) {
-			plist_del(&waiter->list_entry, &lock->wait_list);
-			task->pi_blocked_on = NULL;
-		}
-
-		/*
-		 * We have to enqueue the top waiter(if it exists) into
-		 * task->pi_waiters list.
-		 */
-		if (rt_mutex_has_waiters(lock)) {
-			top = rt_mutex_top_waiter(lock);
-			top->pi_list_entry.prio = top->list_entry.prio;
-			plist_add(&top->pi_list_entry, &task->pi_waiters);
-		}
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	}
-
-	/* We got the lock. */
-	debug_rt_mutex_lock(lock);
-
-	rt_mutex_set_owner(lock, task);
-
-	rt_mutex_deadlock_account_lock(lock, task);
-
-	return 1;
-}
-
-/*
- * Task blocks on lock.
- *
- * Prepare waiter and propagate pi chain
- *
- * This must be called with lock->wait_lock held.
- */
-static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
-				   struct rt_mutex_waiter *waiter,
-				   struct task_struct *task,
-				   int detect_deadlock)
-{
-	struct task_struct *owner = rt_mutex_owner(lock);
-	struct rt_mutex_waiter *top_waiter = waiter;
-	unsigned long flags;
-	int chain_walk = 0, res;
-
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	__rt_mutex_adjust_prio(task);
-	waiter->task = task;
-	waiter->lock = lock;
-	plist_node_init(&waiter->list_entry, task->prio);
-	plist_node_init(&waiter->pi_list_entry, task->prio);
-
-	/* Get the top priority waiter on the lock */
-	if (rt_mutex_has_waiters(lock))
-		top_waiter = rt_mutex_top_waiter(lock);
-	plist_add(&waiter->list_entry, &lock->wait_list);
-
-	task->pi_blocked_on = waiter;
-
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-
-	if (!owner)
-		return 0;
-
-	if (waiter == rt_mutex_top_waiter(lock)) {
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
-		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
-		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
-
-		__rt_mutex_adjust_prio(owner);
-		if (owner->pi_blocked_on)
-			chain_walk = 1;
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
-	}
-	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
-		chain_walk = 1;
-
-	if (!chain_walk)
-		return 0;
-
-	/*
-	 * The owner can't disappear while holding a lock,
-	 * so the owner struct is protected by wait_lock.
-	 * Gets dropped in rt_mutex_adjust_prio_chain()!
-	 */
-	get_task_struct(owner);
-
-	raw_spin_unlock(&lock->wait_lock);
-
-	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
-					 task);
-
-	raw_spin_lock(&lock->wait_lock);
-
-	return res;
-}
-
-/*
- * Wake up the next waiter on the lock.
- *
- * Remove the top waiter from the current tasks waiter list and wake it up.
- *
- * Called with lock->wait_lock held.
- */
-static void wakeup_next_waiter(struct rt_mutex *lock)
-{
-	struct rt_mutex_waiter *waiter;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&current->pi_lock, flags);
-
-	waiter = rt_mutex_top_waiter(lock);
-
-	/*
-	 * Remove it from current->pi_waiters. We do not adjust a
-	 * possible priority boost right now. We execute wakeup in the
-	 * boosted mode and go back to normal after releasing
-	 * lock->wait_lock.
-	 */
-	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
-
-	rt_mutex_set_owner(lock, NULL);
-
-	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
-
-	wake_up_process(waiter->task);
-}
-
-/*
- * Remove a waiter from a lock and give up
- *
- * Must be called with lock->wait_lock held and
- * have just failed to try_to_take_rt_mutex().
- */
-static void remove_waiter(struct rt_mutex *lock,
-			  struct rt_mutex_waiter *waiter)
-{
-	int first = (waiter == rt_mutex_top_waiter(lock));
-	struct task_struct *owner = rt_mutex_owner(lock);
-	unsigned long flags;
-	int chain_walk = 0;
-
-	raw_spin_lock_irqsave(&current->pi_lock, flags);
-	plist_del(&waiter->list_entry, &lock->wait_list);
-	current->pi_blocked_on = NULL;
-	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
-
-	if (!owner)
-		return;
-
-	if (first) {
-
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
-
-		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
-
-		if (rt_mutex_has_waiters(lock)) {
-			struct rt_mutex_waiter *next;
-
-			next = rt_mutex_top_waiter(lock);
-			plist_add(&next->pi_list_entry, &owner->pi_waiters);
-		}
-		__rt_mutex_adjust_prio(owner);
-
-		if (owner->pi_blocked_on)
-			chain_walk = 1;
-
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
-	}
-
-	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
-
-	if (!chain_walk)
-		return;
-
-	/* gets dropped in rt_mutex_adjust_prio_chain()! */
-	get_task_struct(owner);
-
-	raw_spin_unlock(&lock->wait_lock);
-
-	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
-
-	raw_spin_lock(&lock->wait_lock);
-}
-
-/*
- * Recheck the pi chain, in case we got a priority setting
- *
- * Called from sched_setscheduler
- */
-void rt_mutex_adjust_pi(struct task_struct *task)
-{
-	struct rt_mutex_waiter *waiter;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-
-	waiter = task->pi_blocked_on;
-	if (!waiter || waiter->list_entry.prio == task->prio) {
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-		return;
-	}
-
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-
-	/* gets dropped in rt_mutex_adjust_prio_chain()! */
-	get_task_struct(task);
-	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
-}
-
-/**
- * __rt_mutex_slowlock() - Perform the wait-wake-try-to-take loop
- * @lock:		 the rt_mutex to take
- * @state:		 the state the task should block in (TASK_INTERRUPTIBLE
- * 			 or TASK_UNINTERRUPTIBLE)
- * @timeout:		 the pre-initialized and started timer, or NULL for none
- * @waiter:		 the pre-initialized rt_mutex_waiter
- *
- * lock->wait_lock must be held by the caller.
- */
-static int __sched
-__rt_mutex_slowlock(struct rt_mutex *lock, int state,
-		    struct hrtimer_sleeper *timeout,
-		    struct rt_mutex_waiter *waiter)
-{
-	int ret = 0;
-
-	for (;;) {
-		/* Try to acquire the lock: */
-		if (try_to_take_rt_mutex(lock, current, waiter))
-			break;
-
-		/*
-		 * TASK_INTERRUPTIBLE checks for signals and
-		 * timeout. Ignored otherwise.
-		 */
-		if (unlikely(state == TASK_INTERRUPTIBLE)) {
-			/* Signal pending? */
-			if (signal_pending(current))
-				ret = -EINTR;
-			if (timeout && !timeout->task)
-				ret = -ETIMEDOUT;
-			if (ret)
-				break;
-		}
-
-		raw_spin_unlock(&lock->wait_lock);
-
-		debug_rt_mutex_print_deadlock(waiter);
-
-		schedule_rt_mutex(lock);
-
-		raw_spin_lock(&lock->wait_lock);
-		set_current_state(state);
-	}
-
-	return ret;
-}
-
-/*
- * Slow path lock function:
- */
-static int __sched
-rt_mutex_slowlock(struct rt_mutex *lock, int state,
-		  struct hrtimer_sleeper *timeout,
-		  int detect_deadlock)
-{
-	struct rt_mutex_waiter waiter;
-	int ret = 0;
-
-	debug_rt_mutex_init_waiter(&waiter);
-
-	raw_spin_lock(&lock->wait_lock);
-
-	/* Try to acquire the lock again: */
-	if (try_to_take_rt_mutex(lock, current, NULL)) {
-		raw_spin_unlock(&lock->wait_lock);
-		return 0;
-	}
-
-	set_current_state(state);
-
-	/* Setup the timer, when timeout != NULL */
-	if (unlikely(timeout)) {
-		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
-		if (!hrtimer_active(&timeout->timer))
-			timeout->task = NULL;
-	}
-
-	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
-
-	if (likely(!ret))
-		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
-
-	set_current_state(TASK_RUNNING);
-
-	if (unlikely(ret))
-		remove_waiter(lock, &waiter);
-
-	/*
-	 * try_to_take_rt_mutex() sets the waiter bit
-	 * unconditionally. We might have to fix that up.
-	 */
-	fixup_rt_mutex_waiters(lock);
-
-	raw_spin_unlock(&lock->wait_lock);
-
-	/* Remove pending timer: */
-	if (unlikely(timeout))
-		hrtimer_cancel(&timeout->timer);
-
-	debug_rt_mutex_free_waiter(&waiter);
-
-	return ret;
-}
-
-/*
- * Slow path try-lock function:
- */
-static inline int
-rt_mutex_slowtrylock(struct rt_mutex *lock)
-{
-	int ret = 0;
-
-	raw_spin_lock(&lock->wait_lock);
-
-	if (likely(rt_mutex_owner(lock) != current)) {
-
-		ret = try_to_take_rt_mutex(lock, current, NULL);
-		/*
-		 * try_to_take_rt_mutex() sets the lock waiters
-		 * bit unconditionally. Clean this up.
-		 */
-		fixup_rt_mutex_waiters(lock);
-	}
-
-	raw_spin_unlock(&lock->wait_lock);
-
-	return ret;
-}
-
-/*
- * Slow path to release a rt-mutex:
- */
-static void __sched
-rt_mutex_slowunlock(struct rt_mutex *lock)
-{
-	raw_spin_lock(&lock->wait_lock);
-
-	debug_rt_mutex_unlock(lock);
-
-	rt_mutex_deadlock_account_unlock(current);
-
-	if (!rt_mutex_has_waiters(lock)) {
-		lock->owner = NULL;
-		raw_spin_unlock(&lock->wait_lock);
-		return;
-	}
-
-	wakeup_next_waiter(lock);
-
-	raw_spin_unlock(&lock->wait_lock);
-
-	/* Undo pi boosting if necessary: */
-	rt_mutex_adjust_prio(current);
-}
-
-/*
- * debug aware fast / slowpath lock,trylock,unlock
- *
- * The atomic acquire/release ops are compiled away, when either the
- * architecture does not support cmpxchg or when debugging is enabled.
- */
-static inline int
-rt_mutex_fastlock(struct rt_mutex *lock, int state,
-		  int detect_deadlock,
-		  int (*slowfn)(struct rt_mutex *lock, int state,
-				struct hrtimer_sleeper *timeout,
-				int detect_deadlock))
-{
-	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
-		rt_mutex_deadlock_account_lock(lock, current);
-		return 0;
-	} else
-		return slowfn(lock, state, NULL, detect_deadlock);
-}
-
-static inline int
-rt_mutex_timed_fastlock(struct rt_mutex *lock, int state,
-			struct hrtimer_sleeper *timeout, int detect_deadlock,
-			int (*slowfn)(struct rt_mutex *lock, int state,
-				      struct hrtimer_sleeper *timeout,
-				      int detect_deadlock))
-{
-	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
-		rt_mutex_deadlock_account_lock(lock, current);
-		return 0;
-	} else
-		return slowfn(lock, state, timeout, detect_deadlock);
-}
-
-static inline int
-rt_mutex_fasttrylock(struct rt_mutex *lock,
-		     int (*slowfn)(struct rt_mutex *lock))
-{
-	if (likely(rt_mutex_cmpxchg(lock, NULL, current))) {
-		rt_mutex_deadlock_account_lock(lock, current);
-		return 1;
-	}
-	return slowfn(lock);
-}
-
-static inline void
-rt_mutex_fastunlock(struct rt_mutex *lock,
-		    void (*slowfn)(struct rt_mutex *lock))
-{
-	if (likely(rt_mutex_cmpxchg(lock, current, NULL)))
-		rt_mutex_deadlock_account_unlock(current);
-	else
-		slowfn(lock);
-}
-
-/**
- * rt_mutex_lock - lock a rt_mutex
- *
- * @lock: the rt_mutex to be locked
- */
-void __sched rt_mutex_lock(struct rt_mutex *lock)
-{
-	might_sleep();
-
-	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, 0, rt_mutex_slowlock);
-}
-EXPORT_SYMBOL_GPL(rt_mutex_lock);
-
-/**
- * rt_mutex_lock_interruptible - lock a rt_mutex interruptible
- *
- * @lock: 		the rt_mutex to be locked
- * @detect_deadlock:	deadlock detection on/off
- *
- * Returns:
- *  0 		on success
- * -EINTR 	when interrupted by a signal
- * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
- */
-int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
-						 int detect_deadlock)
-{
-	might_sleep();
-
-	return rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE,
-				 detect_deadlock, rt_mutex_slowlock);
-}
-EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
-
-/**
- * rt_mutex_timed_lock - lock a rt_mutex interruptible
- *			the timeout structure is provided
- *			by the caller
- *
- * @lock: 		the rt_mutex to be locked
- * @timeout:		timeout structure or NULL (no timeout)
- * @detect_deadlock:	deadlock detection on/off
- *
- * Returns:
- *  0 		on success
- * -EINTR 	when interrupted by a signal
- * -ETIMEDOUT	when the timeout expired
- * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
- */
-int
-rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout,
-		    int detect_deadlock)
-{
-	might_sleep();
-
-	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
-				       detect_deadlock, rt_mutex_slowlock);
-}
-EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
-
-/**
- * rt_mutex_trylock - try to lock a rt_mutex
- *
- * @lock:	the rt_mutex to be locked
- *
- * Returns 1 on success and 0 on contention
- */
-int __sched rt_mutex_trylock(struct rt_mutex *lock)
-{
-	return rt_mutex_fasttrylock(lock, rt_mutex_slowtrylock);
-}
-EXPORT_SYMBOL_GPL(rt_mutex_trylock);
-
-/**
- * rt_mutex_unlock - unlock a rt_mutex
- *
- * @lock: the rt_mutex to be unlocked
- */
-void __sched rt_mutex_unlock(struct rt_mutex *lock)
-{
-	rt_mutex_fastunlock(lock, rt_mutex_slowunlock);
-}
-EXPORT_SYMBOL_GPL(rt_mutex_unlock);
-
-/**
- * rt_mutex_destroy - mark a mutex unusable
- * @lock: the mutex to be destroyed
- *
- * This function marks the mutex uninitialized, and any subsequent
- * use of the mutex is forbidden. The mutex must not be locked when
- * this function is called.
- */
-void rt_mutex_destroy(struct rt_mutex *lock)
-{
-	WARN_ON(rt_mutex_is_locked(lock));
-#ifdef CONFIG_DEBUG_RT_MUTEXES
-	lock->magic = NULL;
-#endif
-}
-
-EXPORT_SYMBOL_GPL(rt_mutex_destroy);
-
-/**
- * __rt_mutex_init - initialize the rt lock
- *
- * @lock: the rt lock to be initialized
- *
- * Initialize the rt lock to unlocked state.
- *
- * Initializing of a locked rt lock is not allowed
- */
-void __rt_mutex_init(struct rt_mutex *lock, const char *name)
-{
-	lock->owner = NULL;
-	raw_spin_lock_init(&lock->wait_lock);
-	plist_head_init(&lock->wait_list);
-
-	debug_rt_mutex_init(lock, name);
-}
-EXPORT_SYMBOL_GPL(__rt_mutex_init);
-
-/**
- * rt_mutex_init_proxy_locked - initialize and lock a rt_mutex on behalf of a
- *				proxy owner
- *
- * @lock: 	the rt_mutex to be locked
- * @proxy_owner:the task to set as owner
- *
- * No locking. Caller has to do serializing itself
- * Special API call for PI-futex support
- */
-void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
-				struct task_struct *proxy_owner)
-{
-	__rt_mutex_init(lock, NULL);
-	debug_rt_mutex_proxy_lock(lock, proxy_owner);
-	rt_mutex_set_owner(lock, proxy_owner);
-	rt_mutex_deadlock_account_lock(lock, proxy_owner);
-}
-
-/**
- * rt_mutex_proxy_unlock - release a lock on behalf of owner
- *
- * @lock: 	the rt_mutex to be locked
- *
- * No locking. Caller has to do serializing itself
- * Special API call for PI-futex support
- */
-void rt_mutex_proxy_unlock(struct rt_mutex *lock,
-			   struct task_struct *proxy_owner)
-{
-	debug_rt_mutex_proxy_unlock(lock);
-	rt_mutex_set_owner(lock, NULL);
-	rt_mutex_deadlock_account_unlock(proxy_owner);
-}
-
-/**
- * rt_mutex_start_proxy_lock() - Start lock acquisition for another task
- * @lock:		the rt_mutex to take
- * @waiter:		the pre-initialized rt_mutex_waiter
- * @task:		the task to prepare
- * @detect_deadlock:	perform deadlock detection (1) or not (0)
- *
- * Returns:
- *  0 - task blocked on lock
- *  1 - acquired the lock for task, caller should wake it up
- * <0 - error
- *
- * Special API call for FUTEX_REQUEUE_PI support.
- */
-int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
-			      struct rt_mutex_waiter *waiter,
-			      struct task_struct *task, int detect_deadlock)
-{
-	int ret;
-
-	raw_spin_lock(&lock->wait_lock);
-
-	if (try_to_take_rt_mutex(lock, task, NULL)) {
-		raw_spin_unlock(&lock->wait_lock);
-		return 1;
-	}
-
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
-
-	if (ret && !rt_mutex_owner(lock)) {
-		/*
-		 * Reset the return value. We might have
-		 * returned with -EDEADLK and the owner
-		 * released the lock while we were walking the
-		 * pi chain.  Let the waiter sort it out.
-		 */
-		ret = 0;
-	}
-
-	if (unlikely(ret))
-		remove_waiter(lock, waiter);
-
-	raw_spin_unlock(&lock->wait_lock);
-
-	debug_rt_mutex_print_deadlock(waiter);
-
-	return ret;
-}
-
-/**
- * rt_mutex_next_owner - return the next owner of the lock
- *
- * @lock: the rt lock query
- *
- * Returns the next owner of the lock or NULL
- *
- * Caller has to serialize against other accessors to the lock
- * itself.
- *
- * Special API call for PI-futex support
- */
-struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock)
-{
-	if (!rt_mutex_has_waiters(lock))
-		return NULL;
-
-	return rt_mutex_top_waiter(lock)->task;
-}
-
-/**
- * rt_mutex_finish_proxy_lock() - Complete lock acquisition
- * @lock:		the rt_mutex we were woken on
- * @to:			the timeout, null if none. hrtimer should already have
- * 			been started.
- * @waiter:		the pre-initialized rt_mutex_waiter
- * @detect_deadlock:	perform deadlock detection (1) or not (0)
- *
- * Complete the lock acquisition started our behalf by another thread.
- *
- * Returns:
- *  0 - success
- * <0 - error, one of -EINTR, -ETIMEDOUT, or -EDEADLK
- *
- * Special API call for PI-futex requeue support
- */
-int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
-			       struct hrtimer_sleeper *to,
-			       struct rt_mutex_waiter *waiter,
-			       int detect_deadlock)
-{
-	int ret;
-
-	raw_spin_lock(&lock->wait_lock);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-
-	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
-
-	set_current_state(TASK_RUNNING);
-
-	if (unlikely(ret))
-		remove_waiter(lock, waiter);
-
-	/*
-	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
-	 * have to fix that up.
-	 */
-	fixup_rt_mutex_waiters(lock);
-
-	raw_spin_unlock(&lock->wait_lock);
-
-	return ret;
-}
--- a/kernel/rtmutex.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * RT-Mutexes: blocking mutual exclusion locks with PI support
- *
- * started by Ingo Molnar and Thomas Gleixner:
- *
- *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
- *
- * This file contains macros used solely by rtmutex.c.
- * Non-debug version.
- */
-
-#define rt_mutex_deadlock_check(l)			(0)
-#define rt_mutex_deadlock_account_lock(m, t)		do { } while (0)
-#define rt_mutex_deadlock_account_unlock(l)		do { } while (0)
-#define debug_rt_mutex_init_waiter(w)			do { } while (0)
-#define debug_rt_mutex_free_waiter(w)			do { } while (0)
-#define debug_rt_mutex_lock(l)				do { } while (0)
-#define debug_rt_mutex_proxy_lock(l,p)			do { } while (0)
-#define debug_rt_mutex_proxy_unlock(l)			do { } while (0)
-#define debug_rt_mutex_unlock(l)			do { } while (0)
-#define debug_rt_mutex_init(m, n)			do { } while (0)
-#define debug_rt_mutex_deadlock(d, a ,l)		do { } while (0)
-#define debug_rt_mutex_print_deadlock(w)		do { } while (0)
-#define debug_rt_mutex_detect_deadlock(w,d)		(d)
-#define debug_rt_mutex_reset_waiter(w)			do { } while (0)
--- a/kernel/rtmutex_common.h
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * RT Mutexes: blocking mutual exclusion locks with PI support
- *
- * started by Ingo Molnar and Thomas Gleixner:
- *
- *  Copyright (C) 2004-2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- *  Copyright (C) 2006, Timesys Corp., Thomas Gleixner <tglx@timesys.com>
- *
- * This file contains the private data structure and API definitions.
- */
-
-#ifndef __KERNEL_RTMUTEX_COMMON_H
-#define __KERNEL_RTMUTEX_COMMON_H
-
-#include <linux/rtmutex.h>
-
-/*
- * The rtmutex in kernel tester is independent of rtmutex debugging. We
- * call schedule_rt_mutex_test() instead of schedule() for the tasks which
- * belong to the tester. That way we can delay the wakeup path of those
- * threads to provoke lock stealing and testing of  complex boosting scenarios.
- */
-#ifdef CONFIG_RT_MUTEX_TESTER
-
-extern void schedule_rt_mutex_test(struct rt_mutex *lock);
-
-#define schedule_rt_mutex(_lock)				\
-  do {								\
-	if (!(current->flags & PF_MUTEX_TESTER))		\
-		schedule();					\
-	else							\
-		schedule_rt_mutex_test(_lock);			\
-  } while (0)
-
-#else
-# define schedule_rt_mutex(_lock)			schedule()
-#endif
-
-/*
- * This is the control structure for tasks blocked on a rt_mutex,
- * which is allocated on the kernel stack on of the blocked task.
- *
- * @list_entry:		pi node to enqueue into the mutex waiters list
- * @pi_list_entry:	pi node to enqueue into the mutex owner waiters list
- * @task:		task reference to the blocked task
- */
-struct rt_mutex_waiter {
-	struct plist_node	list_entry;
-	struct plist_node	pi_list_entry;
-	struct task_struct	*task;
-	struct rt_mutex		*lock;
-#ifdef CONFIG_DEBUG_RT_MUTEXES
-	unsigned long		ip;
-	struct pid		*deadlock_task_pid;
-	struct rt_mutex		*deadlock_lock;
-#endif
-};
-
-/*
- * Various helpers to access the waiters-plist:
- */
-static inline int rt_mutex_has_waiters(struct rt_mutex *lock)
-{
-	return !plist_head_empty(&lock->wait_list);
-}
-
-static inline struct rt_mutex_waiter *
-rt_mutex_top_waiter(struct rt_mutex *lock)
-{
-	struct rt_mutex_waiter *w;
-
-	w = plist_first_entry(&lock->wait_list, struct rt_mutex_waiter,
-			       list_entry);
-	BUG_ON(w->lock != lock);
-
-	return w;
-}
-
-static inline int task_has_pi_waiters(struct task_struct *p)
-{
-	return !plist_head_empty(&p->pi_waiters);
-}
-
-static inline struct rt_mutex_waiter *
-task_top_pi_waiter(struct task_struct *p)
-{
-	return plist_first_entry(&p->pi_waiters, struct rt_mutex_waiter,
-				  pi_list_entry);
-}
-
-/*
- * lock->owner state tracking:
- */
-#define RT_MUTEX_HAS_WAITERS	1UL
-#define RT_MUTEX_OWNER_MASKALL	1UL
-
-static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
-{
-	return (struct task_struct *)
-		((unsigned long)lock->owner & ~RT_MUTEX_OWNER_MASKALL);
-}
-
-/*
- * PI-futex support (proxy locking functions, etc.):
- */
-extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
-extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
-				       struct task_struct *proxy_owner);
-extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
-				  struct task_struct *proxy_owner);
-extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
-				     struct rt_mutex_waiter *waiter,
-				     struct task_struct *task,
-				     int detect_deadlock);
-extern int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
-				      struct hrtimer_sleeper *to,
-				      struct rt_mutex_waiter *waiter,
-				      int detect_deadlock);
-
-#ifdef CONFIG_DEBUG_RT_MUTEXES
-# include "rtmutex-debug.h"
-#else
-# include "rtmutex.h"
-#endif
-
-#endif


