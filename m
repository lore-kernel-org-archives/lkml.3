Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaBQUhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:37:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:36818 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaBQUhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:37:22 -0500
Date: Mon, 17 Feb 2014 21:37:17 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.11-rt17
Message-ID: <20140217203717.GA19687@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.11-rt17 patch set.

Changes since v3.12.11-rt16
- ARM uses rawlocks during unwinding of modules. Earlier I aborted the
  unwind process if it was called from irq context. Now it uses rawlocks
  and works from irq context. tglx asked for this.

- Clean up of a few do while(0) loops in the rwlock code where the do
  while(0) loop was not necessary. Patch by Nicholas Mc Guire.

- checkpatch.pl cleanup of about 19 patches in the queue by Nicholas Mc
  Guire. None of the patches made it to the list except for the
  "latency-hist" cleanup. Most of the changes were cosmetic and did not
  introduce a functional change. Some of the patches just changed the
  body of the patch (because checkpatch.pl complained about invalid tags
  in the CC:/Sign-off area) and that is why the patch at the end of the
  email touches only 11 files (in case someone wonders since I mentined
  19 patches).

Known issues:

      - bcache is disabled.

The delta patch against v3.12.11-rt16 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.11-rt16-rt17.patch.xz

The RT patch against 3.12.11 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.11-rt17.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.11-rt17.tar.xz

Sebastian

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 2af232d..bbafc67 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -87,7 +87,7 @@ extern const struct unwind_idx __start_unwind_idx[];
 static const struct unwind_idx *__origin_unwind_idx;
 extern const struct unwind_idx __stop_unwind_idx[];
 
-static DEFINE_SPINLOCK(unwind_lock);
+static DEFINE_RAW_SPINLOCK(unwind_lock);
 static LIST_HEAD(unwind_tables);
 
 /* Convert a prel31 symbol to an absolute address */
@@ -195,12 +195,7 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 		/* module unwind tables */
 		struct unwind_table *table;
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-		if (irqs_disabled())
-			goto out;
-#endif
-
-		spin_lock_irqsave(&unwind_lock, flags);
+		raw_spin_lock_irqsave(&unwind_lock, flags);
 		list_for_each_entry(table, &unwind_tables, list) {
 			if (addr >= table->begin_addr &&
 			    addr < table->end_addr) {
@@ -212,11 +207,10 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&unwind_lock, flags);
+		raw_spin_unlock_irqrestore(&unwind_lock, flags);
 	}
 
 	pr_debug("%s: idx = %p\n", __func__, idx);
-out:
 	return idx;
 }
 
@@ -351,9 +345,7 @@ int unwind_frame(struct stackframe *frame)
 
 	idx = unwind_find_idx(frame->pc);
 	if (!idx) {
-#ifndef CONFIG_PREEMPT_RT_FULL
 		pr_warning("unwind: Index not found %08lx\n", frame->pc);
-#endif
 		return -URC_FAILURE;
 	}
 
@@ -477,9 +469,9 @@ struct unwind_table *unwind_table_add(unsigned long start, unsigned long size,
 	tab->begin_addr = text_addr;
 	tab->end_addr = text_addr + text_size;
 
-	spin_lock_irqsave(&unwind_lock, flags);
+	raw_spin_lock_irqsave(&unwind_lock, flags);
 	list_add_tail(&tab->list, &unwind_tables);
-	spin_unlock_irqrestore(&unwind_lock, flags);
+	raw_spin_unlock_irqrestore(&unwind_lock, flags);
 
 	return tab;
 }
@@ -491,9 +483,9 @@ void unwind_table_del(struct unwind_table *tab)
 	if (!tab)
 		return;
 
-	spin_lock_irqsave(&unwind_lock, flags);
+	raw_spin_lock_irqsave(&unwind_lock, flags);
 	list_del(&tab->list);
-	spin_unlock_irqrestore(&unwind_lock, flags);
+	raw_spin_unlock_irqrestore(&unwind_lock, flags);
 
 	kfree(tab);
 }
diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index d2676b8..577092b3a 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -96,7 +96,7 @@ static struct dentry *debug_sample_width;	/* sample width us */
 static struct dentry *debug_sample_window;	/* sample window us */
 static struct dentry *debug_sample;		/* raw samples us */
 static struct dentry *debug_threshold;		/* threshold us */
-static struct dentry *debug_enable;         	/* enable/disable */
+static struct dentry *debug_enable;		/* enable/disable */
 
 /* Individual samples and global state */
 
@@ -216,20 +216,21 @@ static struct sample *buffer_get_sample(struct sample *sample)
 #define time_to_us(x)	ktime_to_us(x)
 #define time_sub(a, b)	ktime_sub(a, b)
 #define init_time(a, b)	(a).tv64 = b
-#define time_u64(a)	(a).tv64
+#define time_u64(a)	((a).tv64)
 #else
 #define time_type	u64
 #define time_get()	trace_clock_local()
 #define time_to_us(x)	div_u64(x, 1000)
 #define time_sub(a, b)	((a) - (b))
-#define init_time(a, b)	a = b
+#define init_time(a, b)	(a = b)
 #define time_u64(a)	a
 #endif
 /**
  * get_sample - sample the CPU TSC and look for likely hardware latencies
  *
  * Used to repeatedly capture the CPU TSC (or similar), looking for potential
- * hardware-induced latency. Called with interrupts disabled and with data.lock held.
+ * hardware-induced latency. Called with interrupts disabled and with
+ * data.lock held.
  */
 static int get_sample(void)
 {
@@ -248,11 +249,11 @@ static int get_sample(void)
 		t2 = time_get();
 
 		if (time_u64(last_t2)) {
-			/* Check the delta from the outer loop (t2 to next t1) */
+			/* Check the delta from outer loop (t2 to next t1) */
 			diff = time_to_us(time_sub(t1, last_t2));
 			/* This shouldn't happen */
 			if (diff < 0) {
-				printk(KERN_ERR BANNER "time running backwards\n");
+				pr_err(BANNER "time running backwards\n");
 				goto out;
 			}
 			if (diff > outer_sample)
@@ -267,7 +268,7 @@ static int get_sample(void)
 
 		/* This shouldn't happen */
 		if (diff < 0) {
-			printk(KERN_ERR BANNER "time running backwards\n");
+			pr_err(BANNER "time running backwards\n");
 			goto out;
 		}
 
@@ -353,7 +354,7 @@ static int start_kthread(void)
 	kthread = kthread_run(kthread_fn, NULL,
 					DRVNAME);
 	if (IS_ERR(kthread)) {
-		printk(KERN_ERR BANNER "could not start sampling thread\n");
+		pr_err(BANNER "could not start sampling thread\n");
 		enabled = 0;
 		return -ENOMEM;
 	}
@@ -413,7 +414,7 @@ static int init_stats(void)
 		goto out;
 
 	__reset_stats();
-	data.threshold = threshold ?: DEFAULT_LAT_THRESHOLD;	    /* threshold us */
+	data.threshold = threshold ?: DEFAULT_LAT_THRESHOLD; /* threshold us */
 	data.sample_window = DEFAULT_SAMPLE_WINDOW; /* window us */
 	data.sample_width = DEFAULT_SAMPLE_WIDTH;   /* width us */
 
@@ -485,7 +486,7 @@ static ssize_t simple_data_write(struct file *filp, const char __user *ubuf,
 		return -EFAULT;
 
 	buf[U64STR_SIZE-1] = '\0';			/* just in case */
-	err = strict_strtoull(buf, 10, &val);
+	err = kstrtoull(buf, 10, &val);
 	if (err)
 		return -EINVAL;
 
@@ -614,7 +615,7 @@ static ssize_t  debug_enable_fwrite(struct file *filp,
 		return -EFAULT;
 
 	buf[sizeof(buf)-1] = '\0';			/* just in case */
-	err = strict_strtoul(buf, 10, &val);
+	err = kstrtoull(buf, 10, &val);
 	if (0 != err)
 		return -EINVAL;
 
@@ -631,7 +632,7 @@ static ssize_t  debug_enable_fwrite(struct file *filp,
 		enabled = 0;
 		err = stop_kthread();
 		if (err) {
-			printk(KERN_ERR BANNER "cannot stop kthread\n");
+			pr_err(BANNER "cannot stop kthread\n");
 			return -EFAULT;
 		}
 		wake_up(&data.wq);		/* reader(s) should return */
@@ -919,7 +920,7 @@ static ssize_t  debug_width_fwrite(struct file *filp,
 		return -EFAULT;
 
 	buf[U64STR_SIZE-1] = '\0';			/* just in case */
-	err = strict_strtoull(buf, 10, &val);
+	err = kstrtoull(buf, 10, &val);
 	if (0 != err)
 		return -EINVAL;
 
@@ -1003,7 +1004,7 @@ static ssize_t  debug_window_fwrite(struct file *filp,
 		return -EFAULT;
 
 	buf[U64STR_SIZE-1] = '\0';			/* just in case */
-	err = strict_strtoull(buf, 10, &val);
+	err = kstrtoull(buf, 10, &val);
 	if (0 != err)
 		return -EINVAL;
 
@@ -1053,7 +1054,7 @@ static const struct file_operations max_fops = {
  * Function pointers for the "sample" debugfs file operations
  */
 static const struct file_operations sample_fops = {
-	.open 		= debug_sample_fopen,
+	.open		= debug_sample_fopen,
 	.read		= debug_sample_fread,
 	.release	= debug_sample_release,
 	.owner		= THIS_MODULE,
@@ -1194,7 +1195,7 @@ static int detector_init(void)
 {
 	int ret = -ENOMEM;
 
-	printk(KERN_INFO BANNER "version %s\n", VERSION);
+	pr_info(BANNER "version %s\n", VERSION);
 
 	ret = init_stats();
 	if (0 != ret)
@@ -1227,7 +1228,7 @@ static void detector_exit(void)
 		enabled = 0;
 		err = stop_kthread();
 		if (err)
-			printk(KERN_ERR BANNER "cannot stop kthread\n");
+			pr_err(BANNER "cannot stop kthread\n");
 	}
 
 	free_debugfs();
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 0ec035d..7565b99 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1939,7 +1939,7 @@ static void tulip_remove_one(struct pci_dev *pdev)
 	pci_iounmap(pdev, tp->base_addr);
 	free_netdev (dev);
 	pci_release_regions (pdev);
-	pci_disable_device (pdev);
+	pci_disable_device(pdev);
 	pci_set_drvdata (pdev, NULL);
 
 	/* pci_power_off (pdev, -1); */
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 24e693b..cac4973 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -78,7 +78,7 @@ struct buffer_head {
 #ifdef CONFIG_PREEMPT_RT_BASE
 	spinlock_t b_uptodate_lock;
 #if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE) || \
-    defined(CONFIG_JBD2) || defined(CONFIG_JBD2_MODULE)
+	defined(CONFIG_JBD2) || defined(CONFIG_JBD2_MODULE)
 	spinlock_t b_state_lock;
 	spinlock_t b_journal_head_lock;
 #endif
@@ -114,7 +114,7 @@ static inline void buffer_head_init_locks(struct buffer_head *bh)
 #ifdef CONFIG_PREEMPT_RT_BASE
 	spin_lock_init(&bh->b_uptodate_lock);
 #if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE) || \
-    defined(CONFIG_JBD2) || defined(CONFIG_JBD2_MODULE)
+	defined(CONFIG_JBD2) || defined(CONFIG_JBD2_MODULE)
 	spin_lock_init(&bh->b_state_lock);
 	spin_lock_init(&bh->b_journal_head_lock);
 #endif
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a5747d7..a2609fb 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -318,7 +318,7 @@ static inline int disable_irq_wake(unsigned int irq)
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 # ifndef CONFIG_PREEMPT_RT_BASE
-   extern bool force_irqthreads;
+extern bool force_irqthreads;
 # else
 #  define force_irqthreads	(true)
 # endif
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index a52b35d..0977829 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -157,8 +157,8 @@
 #ifdef CONFIG_PREEMPT_RT_FULL
 # define local_irq_disable_nort()	do { } while (0)
 # define local_irq_enable_nort()	do { } while (0)
-# define local_irq_save_nort(flags)	do { local_save_flags(flags); } while (0)
-# define local_irq_restore_nort(flags)	do { (void)(flags); } while (0)
+# define local_irq_save_nort(flags)	local_save_flags(flags)
+# define local_irq_restore_nort(flags)	(void)(flags)
 # define local_irq_disable_rt()		local_irq_disable()
 # define local_irq_enable_rt()		local_irq_enable()
 #else
diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index e85a5df..49ed2d4 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -42,10 +42,7 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 		flags = rt_write_lock_irqsave(lock);	\
 	} while (0)
 
-#define read_lock(lock)					\
-	do {						\
-		rt_read_lock(lock);			\
-	} while (0)
+#define read_lock(lock)		rt_read_lock(lock)
 
 #define read_lock_bh(lock)				\
 	do {						\
@@ -55,10 +52,7 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 
 #define read_lock_irq(lock)	read_lock(lock)
 
-#define write_lock(lock)				\
-	do {						\
-		rt_write_lock(lock);			\
-	} while (0)
+#define write_lock(lock)	rt_write_lock(lock)
 
 #define write_lock_bh(lock)				\
 	do {						\
@@ -68,10 +62,7 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 
 #define write_lock_irq(lock)	write_lock(lock)
 
-#define read_unlock(lock)				\
-	do {						\
-		rt_read_unlock(lock);			\
-	} while (0)
+#define read_unlock(lock)	rt_read_unlock(lock)
 
 #define read_unlock_bh(lock)				\
 	do {						\
@@ -81,10 +72,7 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 
 #define read_unlock_irq(lock)	read_unlock(lock)
 
-#define write_unlock(lock)				\
-	do {						\
-		rt_write_unlock(lock);			\
-	} while (0)
+#define write_unlock(lock)	rt_write_unlock(lock)
 
 #define write_unlock_bh(lock)				\
 	do {						\
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 17da6c3..d5e50dd 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -108,7 +108,8 @@ void process_srcu(struct work_struct *work);
 
 #define DEFINE_STATIC_SRCU(name)					\
 	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
-	static struct srcu_struct name = __SRCU_STRUCT_INIT(name, name##_srcu_array);
+	static struct srcu_struct name = __SRCU_STRUCT_INIT(\
+		name, name##_srcu_array);
 
 /**
  * call_srcu() - Queue a callback for invocation after an SRCU grace period
diff --git a/include/trace/events/hist.h b/include/trace/events/hist.h
index 28646db..6122e42 100644
--- a/include/trace/events/hist.h
+++ b/include/trace/events/hist.h
@@ -8,7 +8,7 @@
 #include <linux/tracepoint.h>
 
 #if !defined(CONFIG_PREEMPT_OFF_HIST) && !defined(CONFIG_INTERRUPT_OFF_HIST)
-#define trace_preemptirqsoff_hist(a,b)
+#define trace_preemptirqsoff_hist(a, b)
 #else
 TRACE_EVENT(preemptirqsoff_hist,
 
@@ -17,8 +17,8 @@ TRACE_EVENT(preemptirqsoff_hist,
 	TP_ARGS(reason, starthist),
 
 	TP_STRUCT__entry(
-		__field(int,	reason	)
-		__field(int,	starthist	)
+		__field(int,	reason)
+		__field(int,	starthist)
 	),
 
 	TP_fast_assign(
@@ -32,21 +32,22 @@ TRACE_EVENT(preemptirqsoff_hist,
 #endif
 
 #ifndef CONFIG_MISSED_TIMER_OFFSETS_HIST
-#define trace_hrtimer_interrupt(a,b,c,d)
+#define trace_hrtimer_interrupt(a, b, c, d)
 #else
 TRACE_EVENT(hrtimer_interrupt,
 
-	TP_PROTO(int cpu, long long offset, struct task_struct *curr, struct task_struct *task),
+	TP_PROTO(int cpu, long long offset, struct task_struct *curr,
+		struct task_struct *task),
 
 	TP_ARGS(cpu, offset, curr, task),
 
 	TP_STRUCT__entry(
-		__field(int,		cpu	)
-		__field(long long,	offset	)
+		__field(int,		cpu)
+		__field(long long,	offset)
 		__array(char,		ccomm,	TASK_COMM_LEN)
-		__field(int,		cprio	)
+		__field(int,		cprio)
 		__array(char,		tcomm,	TASK_COMM_LEN)
-		__field(int,		tprio	)
+		__field(int,		tprio)
 	),
 
 	TP_fast_assign(
@@ -54,12 +55,14 @@ TRACE_EVENT(hrtimer_interrupt,
 		__entry->offset	= offset;
 		memcpy(__entry->ccomm, curr->comm, TASK_COMM_LEN);
 		__entry->cprio  = curr->prio;
-		memcpy(__entry->tcomm, task != NULL ? task->comm : "<none>", task != NULL ? TASK_COMM_LEN : 7);
+		memcpy(__entry->tcomm, task != NULL ? task->comm : "<none>",
+			task != NULL ? TASK_COMM_LEN : 7);
 		__entry->tprio  = task != NULL ? task->prio : -1;
 	),
 
 	TP_printk("cpu=%d offset=%lld curr=%s[%d] thread=%s[%d]",
-		__entry->cpu, __entry->offset, __entry->ccomm, __entry->cprio, __entry->tcomm, __entry->tprio)
+		__entry->cpu, __entry->offset, __entry->ccomm,
+		__entry->cprio, __entry->tcomm, __entry->tprio)
 );
 #endif
 
diff --git a/include/trace/events/latency_hist.h b/include/trace/events/latency_hist.h
index 7f70794..d3f2fbd 100644
--- a/include/trace/events/latency_hist.h
+++ b/include/trace/events/latency_hist.h
@@ -22,8 +22,8 @@ static char *actions[] = {
 static inline char *getaction(int action)
 {
 	if (action >= 0 && action <= sizeof(actions)/sizeof(actions[0]))
-		return(actions[action]);
-	return("unknown");
+		return actions[action];
+	return "unknown";
 }
 
 #endif /* _LATENCY_HIST_H */
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 38a32b0..e5a309a 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -341,8 +341,7 @@ MODULE_PARM_DESC(noirqdebug, "Disable irq lockup detection when true");
 static int __init irqfixup_setup(char *str)
 {
 #ifdef CONFIG_PREEMPT_RT_BASE
-	printk(KERN_WARNING "irqfixup boot option not supported "
-		"w/ CONFIG_PREEMPT_RT_BASE\n");
+	pr_warn("irqfixup boot option not supported w/ CONFIG_PREEMPT_RT_BASE\n");
 	return 1;
 #endif
 	irqfixup = 1;
@@ -358,8 +357,7 @@ module_param(irqfixup, int, 0644);
 static int __init irqpoll_setup(char *str)
 {
 #ifdef CONFIG_PREEMPT_RT_BASE
-	printk(KERN_WARNING "irqpoll boot option not supported "
-		"w/ CONFIG_PREEMPT_RT_BASE\n");
+	pr_warn("irqpoll boot option not supported w/ CONFIG_PREEMPT_RT_BASE\n");
 	return 1;
 #endif
 	irqfixup = 2;
diff --git a/kernel/trace/latency_hist.c b/kernel/trace/latency_hist.c
index 011c232..66a69eb 100644
--- a/kernel/trace/latency_hist.c
+++ b/kernel/trace/latency_hist.c
@@ -22,7 +22,7 @@
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
 #include <linux/slab.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <asm/div64.h>
 
 #include "trace.h"
@@ -95,7 +95,7 @@ static struct enable_data preemptirqsoff_enabled_data = {
 #endif
 
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 struct maxlatproc_data {
 	char comm[FIELD_SIZEOF(struct task_struct, comm)];
 	char current_comm[FIELD_SIZEOF(struct task_struct, comm)];
@@ -115,11 +115,11 @@ static DEFINE_PER_CPU(struct hist_data, wakeup_latency_hist_sharedprio);
 static char *wakeup_latency_hist_dir = "wakeup";
 static char *wakeup_latency_hist_dir_sharedprio = "sharedprio";
 static notrace void probe_wakeup_latency_hist_start(void *v,
-    struct task_struct *p, int success);
+	struct task_struct *p, int success);
 static notrace void probe_wakeup_latency_hist_stop(void *v,
-    struct task_struct *prev, struct task_struct *next);
+	struct task_struct *prev, struct task_struct *next);
 static notrace void probe_sched_migrate_task(void *,
-    struct task_struct *task, int cpu);
+	struct task_struct *task, int cpu);
 static struct enable_data wakeup_latency_enabled_data = {
 	.latency_type = WAKEUP_LATENCY,
 	.enabled = 0,
@@ -135,7 +135,7 @@ static unsigned long wakeup_pid;
 static DEFINE_PER_CPU(struct hist_data, missed_timer_offsets);
 static char *missed_timer_offsets_dir = "missed_timer_offsets";
 static notrace void probe_hrtimer_interrupt(void *v, int cpu,
-    long long offset, struct task_struct *curr, struct task_struct *task);
+	long long offset, struct task_struct *curr, struct task_struct *task);
 static struct enable_data missed_timer_offsets_enabled_data = {
 	.latency_type = MISSED_TIMER_OFFSETS,
 	.enabled = 0,
@@ -145,7 +145,7 @@ static unsigned long missed_timer_offsets_pid;
 #endif
 
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 static DEFINE_PER_CPU(struct hist_data, timerandwakeup_latency_hist);
 static char *timerandwakeup_latency_hist_dir = "timerandwakeup";
 static struct enable_data timerandwakeup_enabled_data = {
@@ -161,11 +161,11 @@ void notrace latency_hist(int latency_type, int cpu, long latency,
 {
 	struct hist_data *my_hist;
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 	struct maxlatproc_data *mp = NULL;
 #endif
 
-	if (cpu < 0 || cpu >= NR_CPUS || latency_type < 0 ||
+	if (!cpu_possible(cpu) || latency_type < 0 ||
 	    latency_type >= MAX_LATENCY_TYPE)
 		return;
 
@@ -202,7 +202,7 @@ void notrace latency_hist(int latency_type, int cpu, long latency,
 		break;
 #endif
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 	case TIMERANDWAKEUP_LATENCY:
 		my_hist = &per_cpu(timerandwakeup_latency_hist, cpu);
 		mp = &per_cpu(timerandwakeup_maxlatproc, cpu);
@@ -229,7 +229,7 @@ void notrace latency_hist(int latency_type, int cpu, long latency,
 	if (unlikely(latency > my_hist->max_lat ||
 	    my_hist->min_lat == LONG_MAX)) {
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 		if (latency_type == WAKEUP_LATENCY ||
 		    latency_type == WAKEUP_LATENCY_SHAREDPRIO ||
 		    latency_type == MISSED_TIMER_OFFSETS ||
@@ -334,7 +334,7 @@ static int l_show(struct seq_file *m, void *p)
 	return 0;
 }
 
-static struct seq_operations latency_hist_seq_op = {
+static const struct seq_operations latency_hist_seq_op = {
 	.start = l_start,
 	.next  = l_next,
 	.stop  = l_stop,
@@ -353,7 +353,7 @@ static int latency_hist_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static struct file_operations latency_hist_fops = {
+static const struct file_operations latency_hist_fops = {
 	.open = latency_hist_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -361,7 +361,7 @@ static struct file_operations latency_hist_fops = {
 };
 
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 static void clear_maxlatprocdata(struct maxlatproc_data *mp)
 {
 	mp->comm[0] = mp->current_comm[0] = '\0';
@@ -393,7 +393,7 @@ latency_hist_reset(struct file *file, const char __user *a,
 	int cpu;
 	struct hist_data *hist = NULL;
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 	struct maxlatproc_data *mp = NULL;
 #endif
 	off_t latency_type = (off_t) file->private_data;
@@ -433,7 +433,7 @@ latency_hist_reset(struct file *file, const char __user *a,
 			break;
 #endif
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 		case TIMERANDWAKEUP_LATENCY:
 			hist = &per_cpu(timerandwakeup_latency_hist, cpu);
 			mp = &per_cpu(timerandwakeup_maxlatproc, cpu);
@@ -443,7 +443,7 @@ latency_hist_reset(struct file *file, const char __user *a,
 
 		hist_reset(hist);
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 		if (latency_type == WAKEUP_LATENCY ||
 		    latency_type == WAKEUP_LATENCY_SHAREDPRIO ||
 		    latency_type == MISSED_TIMER_OFFSETS ||
@@ -456,7 +456,7 @@ latency_hist_reset(struct file *file, const char __user *a,
 }
 
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 static ssize_t
 show_pid(struct file *file, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
@@ -483,8 +483,8 @@ static ssize_t do_pid(struct file *file, const char __user *ubuf,
 
 	buf[cnt] = '\0';
 
-	if (strict_strtoul(buf, 10, &pid))
-		return(-EINVAL);
+	if (kstrtoul(buf, 10, &pid))
+		return -EINVAL;
 
 	*this_pid = pid;
 
@@ -493,7 +493,7 @@ static ssize_t do_pid(struct file *file, const char __user *ubuf,
 #endif
 
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 static ssize_t
 show_maxlatproc(struct file *file, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
@@ -554,8 +554,8 @@ do_enable(struct file *file, const char __user *ubuf, size_t cnt, loff_t *ppos)
 
 	buf[cnt] = 0;
 
-	if (strict_strtol(buf, 10, &enable))
-		return(-EINVAL);
+	if (kstrtoul(buf, 10, &enable))
+		return -EINVAL;
 
 	if ((enable && ed->enabled) || (!enable && !ed->enabled))
 		return cnt;
@@ -637,7 +637,7 @@ do_enable(struct file *file, const char __user *ubuf, size_t cnt, loff_t *ppos)
 			break;
 #endif
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 		case TIMERANDWAKEUP_LATENCY:
 			if (!wakeup_latency_enabled_data.enabled ||
 			    !missed_timer_offsets_enabled_data.enabled)
@@ -726,7 +726,7 @@ static const struct file_operations enable_fops = {
 };
 
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 static const struct file_operations pid_fops = {
 	.open = tracing_open_generic,
 	.read = show_pid,
@@ -741,7 +741,7 @@ static const struct file_operations maxlatproc_fops = {
 
 #if defined(CONFIG_INTERRUPT_OFF_HIST) || defined(CONFIG_PREEMPT_OFF_HIST)
 static notrace void probe_preemptirqsoff_hist(void *v, int reason,
-    int starthist)
+	int starthist)
 {
 	int cpu = raw_smp_processor_id();
 	int time_set = 0;
@@ -846,7 +846,7 @@ static notrace void probe_preemptirqsoff_hist(void *v, int reason,
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
 static DEFINE_RAW_SPINLOCK(wakeup_lock);
 static notrace void probe_sched_migrate_task(void *v, struct task_struct *task,
-    int cpu)
+	int cpu)
 {
 	int old_cpu = task_cpu(task);
 
@@ -869,7 +869,7 @@ static notrace void probe_sched_migrate_task(void *v, struct task_struct *task,
 }
 
 static notrace void probe_wakeup_latency_hist_start(void *v,
-    struct task_struct *p, int success)
+	struct task_struct *p, int success)
 {
 	unsigned long flags;
 	struct task_struct *curr = current;
@@ -907,7 +907,7 @@ static notrace void probe_wakeup_latency_hist_start(void *v,
 }
 
 static notrace void probe_wakeup_latency_hist_stop(void *v,
-    struct task_struct *prev, struct task_struct *next)
+	struct task_struct *prev, struct task_struct *next)
 {
 	unsigned long flags;
 	int cpu = task_cpu(next);
@@ -976,7 +976,8 @@ static notrace void probe_wakeup_latency_hist_stop(void *v,
 
 #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
 static notrace void probe_hrtimer_interrupt(void *v, int cpu,
-    long long latency_ns, struct task_struct *curr, struct task_struct *task)
+	long long latency_ns, struct task_struct *curr,
+	struct task_struct *task)
 {
 	if (latency_ns <= 0 && task != NULL && rt_task(task) &&
 	    (task->prio < curr->prio ||
@@ -1016,7 +1017,7 @@ static __init int latency_hist_init(void)
 	char name[64];
 	char *cpufmt = "CPU%d";
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 	char *cpufmt_maxlatproc = "max_latency-CPU%d";
 	struct maxlatproc_data *mp = NULL;
 #endif
@@ -1147,7 +1148,7 @@ static __init int latency_hist_init(void)
 #endif
 
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
+	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 	dentry = debugfs_create_dir(timerandwakeup_latency_hist_dir,
 	    latency_hist_root);
 	for_each_possible_cpu(i) {
@@ -1174,4 +1175,4 @@ static __init int latency_hist_init(void)
 	return 0;
 }
 
-__initcall(latency_hist_init);
+device_initcall(latency_hist_init);
diff --git a/localversion-rt b/localversion-rt
index 1199eba..1e584b4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt16
+-rt17
