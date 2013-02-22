Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab3BVRha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:37:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3BVRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:37:28 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=D_SbEOMbAAAA:8 a=N4kJ-0Sn0eZHo3OMmsoA:9 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=7KbvKZvEaC0A:10 a=MbVE04Xk2bZjWTUa:21 a=ZcQOsZjuc04V-XWm:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Subject: [ANNOUNCE] 3.4.32-rt46
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Feb 2013 12:37:17 -0500
Message-ID: <1361554637.9470.1.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.32-rt46 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: c0fbd612e9ebadfe34303759eb37b351c5f57de1


Or to build 3.4.32-rt46 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.32.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.32-rt46.patch.xz


You can also build from 3.4.32-rt45 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.32-rt45-rt46.patch.xz



Enjoy,

-- Steve


Changes from 3.4.32-rt45:

---

Bu, Yitian (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Steven Rostedt (2):
      acpi/rt: Convert acpi_gbl_hardware lock back to a raw_spinlock_t
      Linux 3.4.32-rt46

Thomas Gleixner (4):
      x86/32: Use kmap switch for non highmem as well
      serial: Imx: Fix recursive locking bug
      wait-simple: Simple waitqueue implementation
      rcutiny: Use simple waitqueue

----
 arch/x86/kernel/process_32.c    |    2 +-
 drivers/acpi/acpica/acglobal.h  |    2 +-
 drivers/acpi/acpica/hwregs.c    |    4 +-
 drivers/acpi/acpica/hwxface.c   |    4 +-
 drivers/acpi/acpica/utmutex.c   |    4 +-
 drivers/tty/serial/imx.c        |   11 ++-
 include/acpi/platform/aclinux.h |   14 ++++
 include/linux/sched.h           |    4 +-
 include/linux/wait-simple.h     |  172 +++++++++++++++++++++++++++++++++++++++
 kernel/Makefile                 |    2 +-
 kernel/printk.c                 |    2 +-
 kernel/rcutiny_plugin.h         |   17 ++--
 kernel/wait-simple.c            |  119 +++++++++++++++++++++++++++
 localversion-rt                 |    2 +-
 14 files changed, 337 insertions(+), 22 deletions(-)
---------------------------
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 2b0882a..02ffbf5 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -286,7 +286,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
-#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+#ifdef CONFIG_PREEMPT_RT_FULL
 	/*
 	 * Save @prev's kmap_atomic stack
 	 */
diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 4f7d3f5..16dddf2 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -251,7 +251,7 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pending;
  * interrupt level
  */
 ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
-ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
+ACPI_EXTERN acpi_raw_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
 
 /*****************************************************************************
  *
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 6b6c83b..fcc264f 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -271,14 +271,14 @@ acpi_status acpi_hw_clear_acpi_status(void)
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
 
 	/* Clear the fixed events in PM1 A/B */
 
 	status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
 					ACPI_BITMASK_ALL_FIXED_STATUS);
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 
 	if (ACPI_FAILURE(status))
 		goto exit;
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index a716fed..5c6494f 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -366,7 +366,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u32 value)
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
 
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -427,7 +427,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u32 value)
 
 unlock_and_exit:
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 43174df..5aab30a 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -88,7 +88,7 @@ acpi_status acpi_ut_mutex_initialize(void)
 		return_ACPI_STATUS (status);
 	}
 
-	status = acpi_os_create_lock (&acpi_gbl_hardware_lock);
+	status = acpi_os_create_raw_lock (&acpi_gbl_hardware_lock);
 	if (ACPI_FAILURE (status)) {
 		return_ACPI_STATUS (status);
 	}
@@ -135,7 +135,7 @@ void acpi_ut_mutex_terminate(void)
 	/* Delete the spinlocks */
 
 	acpi_os_delete_lock(acpi_gbl_gpe_lock);
-	acpi_os_delete_lock(acpi_gbl_hardware_lock);
+	acpi_os_delete_raw_lock(acpi_gbl_hardware_lock);
 
 	/* Delete the reader/writer lock */
 
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 0de7ed7..6604736 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1225,8 +1225,14 @@ imx_console_write(struct console *co, const char *s, unsigned int count)
 	struct imx_port_ucrs old_ucr;
 	unsigned int ucr1;
 	unsigned long flags;
+	int locked = 1;
 
-	spin_lock_irqsave(&sport->port.lock, flags);
+	if (sport->port.sysrq)
+		locked = 0;
+	else if (oops_in_progress)
+		locked = spin_trylock_irqsave(&sport->port.lock, flags);
+	else
+		spin_lock_irqsave(&sport->port.lock, flags);
 
 	/*
 	 *	First, save UCR1/2/3 and then disable interrupts
@@ -1253,7 +1259,8 @@ imx_console_write(struct console *co, const char *s, unsigned int count)
 
 	imx_port_ucrs_restore(&sport->port, &old_ucr);
 
-	spin_unlock_irqrestore(&sport->port.lock, flags);
+	if (locked)
+		spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 /*
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 6fbc4cab..6fee309 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -72,6 +72,7 @@
 
 #define acpi_cache_t                        struct kmem_cache
 #define acpi_spinlock                       spinlock_t *
+#define acpi_raw_spinlock                   raw_spinlock_t *
 #define acpi_cpu_flags                      unsigned long
 
 #else /* !__KERNEL__ */
@@ -175,6 +176,19 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 	lock ? AE_OK : AE_NO_MEMORY;				\
 })
 
+#define acpi_os_create_raw_lock(__handle)			\
+({								\
+	raw_spinlock_t *lock = ACPI_ALLOCATE(sizeof(*lock));	\
+								\
+	if (lock) {						\
+		*(__handle) = lock;				\
+		raw_spin_lock_init(*(__handle));		\
+	}							\
+	lock ? AE_OK : AE_NO_MEMORY;				\
+})
+
+#define acpi_os_delete_raw_lock(__handle)	kfree(__handle)
+
 #endif /* __KERNEL__ */
 
 #endif /* __ACLINUX_H__ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b0b2559..7a750f5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1651,9 +1651,11 @@ struct task_struct {
 	struct rcu_head put_rcu;
 	int softirq_nestcnt;
 #endif
-#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+#ifdef CONFIG_PREEMPT_RT_FULL
+# if defined CONFIG_HIGHMEM || defined CONFIG_X86_32
 	int kmap_idx;
 	pte_t kmap_pte[KM_TYPE_NR];
+# endif
 #endif
 
 #ifdef CONFIG_DEBUG_PREEMPT
diff --git a/include/linux/wait-simple.h b/include/linux/wait-simple.h
new file mode 100644
index 0000000..44fee60
--- /dev/null
+++ b/include/linux/wait-simple.h
@@ -0,0 +1,172 @@
+#ifndef _LINUX_WAIT_SIMPLE_H
+#define _LINUX_WAIT_SIMPLE_H
+
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+#include <asm/current.h>
+
+struct swaiter {
+	struct task_struct	*task;
+	struct list_head	node;
+};
+
+#define DEFINE_SWAITER(name)					\
+	struct swaiter name = {					\
+		.task	= current,				\
+		.node	= LIST_HEAD_INIT((name).node),		\
+	}
+
+struct swait_head {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+
+#define SWAIT_HEAD_INITIALIZER(name) {				\
+		.lock	= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.list	= LIST_HEAD_INIT((name).list),		\
+	}
+
+#define DEFINE_SWAIT_HEAD(name)					\
+	struct swait_head name = SWAIT_HEAD_INITIALIZER(name)
+
+extern void __init_swait_head(struct swait_head *h, struct lock_class_key *key);
+
+#define init_swait_head(swh)					\
+	do {							\
+		static struct lock_class_key __key;		\
+								\
+		__init_swait_head((swh), &__key);		\
+	} while (0)
+
+/*
+ * Waiter functions
+ */
+extern void swait_prepare_locked(struct swait_head *head, struct swaiter *w);
+extern void swait_prepare(struct swait_head *head, struct swaiter *w, int state);
+extern void swait_finish_locked(struct swait_head *head, struct swaiter *w);
+extern void swait_finish(struct swait_head *head, struct swaiter *w);
+
+/*
+ * Wakeup functions
+ */
+extern unsigned int __swait_wake(struct swait_head *head, unsigned int state, unsigned int num);
+extern unsigned int __swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int num);
+
+#define swait_wake(head)			__swait_wake(head, TASK_NORMAL, 1)
+#define swait_wake_interruptible(head)		__swait_wake(head, TASK_INTERRUPTIBLE, 1)
+#define swait_wake_all(head)			__swait_wake(head, TASK_NORMAL, 0)
+#define swait_wake_all_interruptible(head)	__swait_wake(head, TASK_INTERRUPTIBLE, 0)
+
+/*
+ * Event API
+ */
+#define __swait_event(wq, condition)					\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event(wq, condition)					\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event(wq, condition);					\
+} while (0)
+
+#define __swait_event_interruptible(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_interruptible - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event_interruptible(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__swait_event_interruptible(wq, condition, __ret);	\
+	__ret;								\
+})
+
+#define __swait_event_timeout(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		ret = schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_timeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if the @timeout elapsed, and the remaining
+ * jiffies if the condition evaluated to true before the timeout elapsed.
+ */
+#define swait_event_timeout(wq, condition, timeout)			\
+({									\
+	long __ret = timeout;						\
+	if (!(condition))						\
+		__swait_event_timeout(wq, condition, __ret);		\
+	__ret;								\
+})
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index f4bf68a..e7bbd15 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o
+	    async.o range.o groups.o wait-simple.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff --git a/kernel/printk.c b/kernel/printk.c
index 7109711..56d7497 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -868,9 +868,9 @@ static int console_trylock_for_printk(unsigned int cpu, unsigned long flags)
 		}
 	}
 	printk_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 static const char recursion_bug_msg [] =
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 97e359b..2824dbd 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/wait-simple.h>
 
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
@@ -261,7 +262,7 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 
 /* Controls for rcu_kthread() kthread. */
 static struct task_struct *rcu_kthread_task;
-static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
+static DEFINE_SWAIT_HEAD(rcu_kthread_wq);
 static unsigned long have_rcu_kthread_work;
 
 /*
@@ -754,7 +755,7 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
-static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
+static DEFINE_SWAIT_HEAD(sync_rcu_preempt_exp_wq);
 static unsigned long sync_rcu_preempt_exp_count;
 static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
 
@@ -776,7 +777,7 @@ static int rcu_preempted_readers_exp(void)
  */
 static void rcu_report_exp_done(void)
 {
-	wake_up(&sync_rcu_preempt_exp_wq);
+	swait_wake(&sync_rcu_preempt_exp_wq);
 }
 
 /*
@@ -828,8 +829,8 @@ void synchronize_rcu_expedited(void)
 	else {
 		rcu_initiate_boost();
 		local_irq_restore(flags);
-		wait_event(sync_rcu_preempt_exp_wq,
-			   !rcu_preempted_readers_exp());
+		swait_event(sync_rcu_preempt_exp_wq,
+			    !rcu_preempted_readers_exp());
 	}
 
 	/* Clean up and exit. */
@@ -917,7 +918,7 @@ static void invoke_rcu_callbacks(void)
 {
 	have_rcu_kthread_work = 1;
 	if (rcu_kthread_task != NULL)
-		wake_up(&rcu_kthread_wq);
+		swait_wake(&rcu_kthread_wq);
 }
 
 #ifdef CONFIG_RCU_TRACE
@@ -947,8 +948,8 @@ static int rcu_kthread(void *arg)
 	unsigned long flags;
 
 	for (;;) {
-		wait_event_interruptible(rcu_kthread_wq,
-					 have_rcu_kthread_work != 0);
+		swait_event_interruptible(rcu_kthread_wq,
+					  have_rcu_kthread_work != 0);
 		morework = rcu_boost();
 		local_irq_save(flags);
 		work = have_rcu_kthread_work;
diff --git a/kernel/wait-simple.c b/kernel/wait-simple.c
new file mode 100644
index 0000000..c35ec78
--- /dev/null
+++ b/kernel/wait-simple.c
@@ -0,0 +1,119 @@
+/*
+ * Simple waitqueues without fancy flags and callbacks
+ *
+ * (C) 2011 Thomas Gleixner <tglx@linutronix.de>
+ *
+ * Based on kernel/wait.c
+ *
+ * For licencing details see kernel-base/COPYING
+ */
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/wait-simple.h>
+
+/* Adds w to head->list. Must be called with head->lock locked. */
+static inline void __swait_enqueue(struct swait_head *head, struct swaiter *w)
+{
+	list_add(&w->node, &head->list);
+}
+
+/* Removes w from head->list. Must be called with head->lock locked. */
+static inline void __swait_dequeue(struct swaiter *w)
+{
+	list_del_init(&w->node);
+}
+
+/* Check whether a head has waiters enqueued */
+static inline bool swait_head_has_waiters(struct swait_head *h)
+{
+	return !list_empty(&h->list);
+}
+
+void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
+{
+	raw_spin_lock_init(&head->lock);
+	lockdep_set_class(&head->lock, key);
+	INIT_LIST_HEAD(&head->list);
+}
+EXPORT_SYMBOL_GPL(__init_swait_head);
+
+void swait_prepare_locked(struct swait_head *head, struct swaiter *w)
+{
+	w->task = current;
+	if (list_empty(&w->node))
+		__swait_enqueue(head, w);
+}
+
+void swait_prepare(struct swait_head *head, struct swaiter *w, int state)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	swait_prepare_locked(head, w);
+	__set_current_state(state);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
+EXPORT_SYMBOL_GPL(swait_prepare);
+
+void swait_finish_locked(struct swait_head *head, struct swaiter *w)
+{
+	__set_current_state(TASK_RUNNING);
+	if (w->task)
+		__swait_dequeue(w);
+}
+
+void swait_finish(struct swait_head *head, struct swaiter *w)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+	if (w->task) {
+		raw_spin_lock_irqsave(&head->lock, flags);
+		__swait_dequeue(w);
+		raw_spin_unlock_irqrestore(&head->lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(swait_finish);
+
+unsigned int
+__swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int num)
+{
+	struct swaiter *curr, *next;
+	int woken = 0;
+
+	list_for_each_entry_safe(curr, next, &head->list, node) {
+		if (wake_up_state(curr->task, state)) {
+			__swait_dequeue(curr);
+			/*
+			 * The waiting task can free the waiter as
+			 * soon as curr->task = NULL is written,
+			 * without taking any locks. A memory barrier
+			 * is required here to prevent the following
+			 * store to curr->task from getting ahead of
+			 * the dequeue operation.
+			 */
+			smp_wmb();
+			curr->task = NULL;
+			if (++woken == num)
+				break;
+		}
+	}
+	return woken;
+}
+
+unsigned int
+__swait_wake(struct swait_head *head, unsigned int state, unsigned int num)
+{
+	unsigned long flags;
+	int woken;
+
+	if (!swait_head_has_waiters(head))
+		return 0;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	woken = __swait_wake_locked(head, state, num);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+	return woken;
+}
+EXPORT_SYMBOL_GPL(__swait_wake);
diff --git a/localversion-rt b/localversion-rt
index 38c40b2..2721581 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt45
+-rt46


