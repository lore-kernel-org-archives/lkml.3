Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3ILBJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:09:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4762 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3ILBJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:09:19 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=BlFRXlQ3G-i6-0yzTUUA:9 a=QEXdDO2ut3YA:10 a=AK5NDuejd-hlnPrJ:21 a=ZYByAbW_FTrqajoU:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 21:09:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.0.89-rt118
Message-ID: <20130911210917.1efe6c2e@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.0.89-rt118 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.0-rt
  Head SHA1: 5df5fdd22f799e1919b2def24b24b9f48abdba2f


Or to build 3.0.89-rt118 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.89.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.89-rt118.patch.xz



You can also build from 3.0.89-rt117 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.89-rt117-rt118.patch.xz



Enjoy,

-- Steve


Changes from v3.0.89-rt117:

---

Ivo Sieben (1):
      genirq: Set irq thread to RT priority on creation

Mike Galbraith (1):
      x86/mce: fix mce timer interval

Paul Gortmaker (1):
      list_bl.h: make list head locking RT safe

Sebastian Andrzej Siewior (4):
      kernel/cpu: fix cpu down problem if kthread's cpu is going down
      kernel/hotplug: restore original cpu mask oncpu/down
      drm/i915: drop trace_i915_gem_ring_dispatch on rt
      genirq: do not invoke the affinity callback via a workqueue

Steven Rostedt (5):
      sched/workqueue: Only wake up idle workers if not blocked on sleeping spin lock
      rt,ntp: Move call to schedule_delayed_work() to helper thread
      hwlat-detector: Update hwlat_detector to add outer loop detection
      hwlat-detector: Use trace_clock_local if available
      hwlat-detector: Use thread instead of stop machine

Steven Rostedt (Red Hat) (2):
      hwlat-detect/trace: Export trace_clock_local for hwlat-detector
      Linux 3.0.89-rt118

Uwe Kleine-König (1):
      list_bl.h: fix it for for !SMP && !DEBUG_SPINLOCK

Zhao Hongjiang (1):
      timers: prepare for full preemption improve

----
 arch/x86/kernel/cpu/mcheck/mce.c           |    4 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +
 drivers/misc/hwlat_detector.c              |  117 +++++++++++++++++-----------
 include/linux/interrupt.h                  |    1 +
 include/linux/list_bl.h                    |   28 ++++++-
 kernel/cpu.c                               |   29 ++++++-
 kernel/irq/manage.c                        |   89 +++++++++++++++++++--
 kernel/sched.c                             |    4 +-
 kernel/time/ntp.c                          |   42 ++++++++++
 kernel/timer.c                             |    8 +-
 kernel/trace/trace_clock.c                 |    1 +
 localversion-rt                            |    2 +-
 12 files changed, 264 insertions(+), 63 deletions(-)
---------------------------
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c859bb4..e51191f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1171,7 +1171,7 @@ static enum hrtimer_restart mce_start_timer(struct hrtimer *timer)
 		*n = min(*n*2, round_jiffies_relative(check_interval*HZ));
 
 	hrtimer_forward(timer, timer->base->get_time(),
-			ns_to_ktime(jiffies_to_usecs(*n) * 1000));
+			ns_to_ktime(jiffies_to_usecs(*n) * 1000ULL));
 	return HRTIMER_RESTART;
 }
 
@@ -1452,7 +1452,7 @@ static void __mcheck_cpu_init_timer(void)
 	if (!*n)
 		return;
 
-	hrtimer_start_range_ns(t, ns_to_ktime(jiffies_to_usecs(*n) * 1000),
+	hrtimer_start_range_ns(t, ns_to_ktime(jiffies_to_usecs(*n) * 1000ULL),
 			       0 , HRTIMER_MODE_REL_PINNED);
 }
 
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 1ca53ff..4d04a9f 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1189,7 +1189,9 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 		}
 	}
 
+#ifndef CONFIG_PREEMPT_RT_BASE
 	trace_i915_gem_ring_dispatch(ring, seqno);
+#endif
 
 	exec_start = batch_obj->gtt_offset + args->batch_start_offset;
 	exec_len = args->batch_len;
diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index b7b7c90..6f61d5f 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -41,7 +41,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ring_buffer.h>
-#include <linux/stop_machine.h>
 #include <linux/time.h>
 #include <linux/hrtimer.h>
 #include <linux/kthread.h>
@@ -51,6 +50,7 @@
 #include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/trace_clock.h>
 
 #define BUF_SIZE_DEFAULT	262144UL		/* 8K*(sizeof(entry)) */
 #define BUF_FLAGS		(RB_FL_OVERWRITE)	/* no block on full */
@@ -106,7 +106,6 @@ struct data;					/* Global state */
 /* Sampling functions */
 static int __buffer_add_sample(struct sample *sample);
 static struct sample *buffer_get_sample(struct sample *sample);
-static int get_sample(void *unused);
 
 /* Threading and state */
 static int kthread_fn(void *unused);
@@ -143,11 +142,12 @@ static void detector_exit(void);
 struct sample {
 	u64		seqnum;		/* unique sequence */
 	u64		duration;	/* ktime delta */
+	u64		outer_duration;	/* ktime delta (outer loop) */
 	struct timespec	timestamp;	/* wall time */
 	unsigned long   lost;
 };
 
-/* keep the global state somewhere. Mostly used under stop_machine. */
+/* keep the global state somewhere. */
 static struct data {
 
 	struct mutex lock;		/* protect changes */
@@ -170,7 +170,7 @@ static struct data {
  * @sample: The new latency sample value
  *
  * This receives a new latency sample and records it in a global ring buffer.
- * No additional locking is used in this case - suited for stop_machine use.
+ * No additional locking is used in this case.
  */
 static int __buffer_add_sample(struct sample *sample)
 {
@@ -210,29 +210,60 @@ static struct sample *buffer_get_sample(struct sample *sample)
 	return sample;
 }
 
+#ifndef CONFIG_TRACING
+#define time_type	ktime_t
+#define time_get()	ktime_get()
+#define time_to_us(x)	ktime_to_us(x)
+#define time_sub(a, b)	ktime_sub(a, b)
+#define init_time(a, b)	(a).tv64 = b
+#define time_u64(a)	(a).tv64
+#else
+#define time_type	u64
+#define time_get()	trace_clock_local()
+#define time_to_us(x)	div_u64(x, 1000)
+#define time_sub(a, b)	((a) - (b))
+#define init_time(a, b)	a = b
+#define time_u64(a)	a
+#endif
 /**
  * get_sample - sample the CPU TSC and look for likely hardware latencies
- * @unused: This is not used but is a part of the stop_machine API
  *
  * Used to repeatedly capture the CPU TSC (or similar), looking for potential
- * hardware-induced latency. Called under stop_machine, with data.lock held.
+ * hardware-induced latency. Called with interrupts disabled and with data.lock held.
  */
-static int get_sample(void *unused)
+static int get_sample(void)
 {
-	ktime_t start, t1, t2;
+	time_type start, t1, t2, last_t2;
 	s64 diff, total = 0;
 	u64 sample = 0;
-	int ret = 1;
+	u64 outer_sample = 0;
+	int ret = -1;
 
-	start = ktime_get(); /* start timestamp */
+	init_time(last_t2, 0);
+	start = time_get(); /* start timestamp */
 
 	do {
 
-		t1 = ktime_get();	/* we'll look for a discontinuity */
-		t2 = ktime_get();
+		t1 = time_get();	/* we'll look for a discontinuity */
+		t2 = time_get();
+
+		if (time_u64(last_t2)) {
+			/* Check the delta from the outer loop (t2 to next t1) */
+			diff = time_to_us(time_sub(t1, last_t2));
+			/* This shouldn't happen */
+			if (diff < 0) {
+				printk(KERN_ERR BANNER "time running backwards\n");
+				goto out;
+			}
+			if (diff > outer_sample)
+				outer_sample = diff;
+		}
+		last_t2 = t2;
+
+		total = time_to_us(time_sub(t2, start)); /* sample width */
 
-		total = ktime_to_us(ktime_sub(t2, start)); /* sample width */
-		diff = ktime_to_us(ktime_sub(t2, t1));     /* current diff */
+		/* This checks the inner loop (t1 to t2) */
+		diff = time_to_us(time_sub(t2, t1));     /* current diff */
 
 		/* This shouldn't happen */
 		if (diff < 0) {
@@ -245,13 +276,18 @@ static int get_sample(void *unused)
 
 	} while (total <= data.sample_width);
 
+	ret = 0;
+
 	/* If we exceed the threshold value, we have found a hardware latency */
-	if (sample > data.threshold) {
+	if (sample > data.threshold || outer_sample > data.threshold) {
 		struct sample s;
 
+		ret = 1;
+
 		data.count++;
 		s.seqnum = data.count;
 		s.duration = sample;
+		s.outer_duration = outer_sample;
 		s.timestamp = CURRENT_TIME;
 		__buffer_add_sample(&s);
 
@@ -260,7 +296,6 @@ static int get_sample(void *unused)
 			data.max_sample = sample;
 	}
 
-	ret = 0;
 out:
 	return ret;
 }
@@ -270,32 +305,30 @@ out:
  * @unused: A required part of the kthread API.
  *
  * Used to periodically sample the CPU TSC via a call to get_sample. We
- * use stop_machine, whith does (intentionally) introduce latency since we
+ * disable interrupts, which does (intentionally) introduce latency since we
  * need to ensure nothing else might be running (and thus pre-empting).
  * Obviously this should never be used in production environments.
  *
- * stop_machine will schedule us typically only on CPU0 which is fine for
- * almost every real-world hardware latency situation - but we might later
- * generalize this if we find there are any actualy systems with alternate
- * SMI delivery or other non CPU0 hardware latencies.
+ * Currently this runs on which ever CPU it was scheduled on, but most
+ * real-worald hardware latency situations occur across several CPUs,
+ * but we might later generalize this if we find there are any actualy
+ * systems with alternate SMI delivery or other hardware latencies.
  */
 static int kthread_fn(void *unused)
 {
-	int err = 0;
-	u64 interval = 0;
+	int ret;
+	u64 interval;
 
 	while (!kthread_should_stop()) {
 
 		mutex_lock(&data.lock);
 
-		err = stop_machine(get_sample, unused, 0);
-		if (err) {
-			/* Houston, we have a problem */
-			mutex_unlock(&data.lock);
-			goto err_out;
-		}
+		local_irq_disable();
+		ret = get_sample();
+		local_irq_enable();
 
-		wake_up(&data.wq); /* wake up reader(s) */
+		if (ret > 0)
+			wake_up(&data.wq); /* wake up reader(s) */
 
 		interval = data.sample_window - data.sample_width;
 		do_div(interval, USEC_PER_MSEC); /* modifies interval value */
@@ -303,15 +336,10 @@ static int kthread_fn(void *unused)
 		mutex_unlock(&data.lock);
 
 		if (msleep_interruptible(interval))
-			goto out;
+			break;
 	}
-		goto out;
-err_out:
-	printk(KERN_ERR BANNER "could not call stop_machine, disabling\n");
-	enabled = 0;
-out:
-	return err;
 
+	return 0;
 }
 
 /**
@@ -407,8 +435,7 @@ out:
  * This function provides a generic read implementation for the global state
  * "data" structure debugfs filesystem entries. It would be nice to use
  * simple_attr_read directly, but we need to make sure that the data.lock
- * spinlock is held during the actual read (even though we likely won't ever
- * actually race here as the updater runs under a stop_machine context).
+ * is held during the actual read.
  */
 static ssize_t simple_data_read(struct file *filp, char __user *ubuf,
 				size_t cnt, loff_t *ppos, const u64 *entry)
@@ -443,8 +470,7 @@ static ssize_t simple_data_read(struct file *filp, char __user *ubuf,
  * This function provides a generic write implementation for the global state
  * "data" structure debugfs filesystem entries. It would be nice to use
  * simple_attr_write directly, but we need to make sure that the data.lock
- * spinlock is held during the actual write (even though we likely won't ever
- * actually race here as the updater runs under a stop_machine context).
+ * is held during the actual write.
  */
 static ssize_t simple_data_write(struct file *filp, const char __user *ubuf,
 				 size_t cnt, loff_t *ppos, u64 *entry)
@@ -738,10 +764,11 @@ static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
 		}
 	}
 
-	len = snprintf(buf, sizeof(buf), "%010lu.%010lu\t%llu\n",
-		      sample->timestamp.tv_sec,
-		      sample->timestamp.tv_nsec,
-		      sample->duration);
+	len = snprintf(buf, sizeof(buf), "%010lu.%010lu\t%llu\t%llu\n",
+		       sample->timestamp.tv_sec,
+		       sample->timestamp.tv_nsec,
+		       sample->duration,
+		       sample->outer_duration);
 
 
 	/* handling partial reads is more trouble than it's worth */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 71c2c0b..9f67f91 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -255,6 +255,7 @@ struct irq_affinity_notify {
 	unsigned int irq;
 	struct kref kref;
 	struct work_struct work;
+	struct list_head list;
 	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
 	void (*release)(struct kref *ref);
 };
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 31f9d75..becd7a6 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -2,6 +2,7 @@
 #define _LINUX_LIST_BL_H
 
 #include <linux/list.h>
+#include <linux/spinlock.h>
 #include <linux/bit_spinlock.h>
 
 /*
@@ -32,13 +33,22 @@
 
 struct hlist_bl_head {
 	struct hlist_bl_node *first;
+#ifdef CONFIG_PREEMPT_RT_BASE
+	raw_spinlock_t lock;
+#endif
 };
 
 struct hlist_bl_node {
 	struct hlist_bl_node *next, **pprev;
 };
-#define INIT_HLIST_BL_HEAD(ptr) \
-	((ptr)->first = NULL)
+
+static inline void INIT_HLIST_BL_HEAD(struct hlist_bl_head *h)
+{
+	h->first = NULL;
+#ifdef CONFIG_PREEMPT_RT_BASE
+	raw_spin_lock_init(&h->lock);
+#endif
+}
 
 static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
 {
@@ -117,12 +127,26 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 
 static inline void hlist_bl_lock(struct hlist_bl_head *b)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 	bit_spin_lock(0, (unsigned long *)b);
+#else
+	raw_spin_lock(&b->lock);
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+	__set_bit(0, (unsigned long *)b);
+#endif
+#endif
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 	__bit_spin_unlock(0, (unsigned long *)b);
+#else
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+	__clear_bit(0, (unsigned long *)b);
+#endif
+	raw_spin_unlock(&b->lock);
+#endif
 }
 
 /**
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3bcbf99..4abfd5d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -78,6 +78,7 @@ struct hotplug_pcp {
 	int refcount;
 	int grab_lock;
 	struct completion synced;
+	struct completion unplug_wait;
 #ifdef CONFIG_PREEMPT_RT_FULL
 	spinlock_t lock;
 #else
@@ -175,6 +176,7 @@ static int sync_unplug_thread(void *data)
 {
 	struct hotplug_pcp *hp = data;
 
+	wait_for_completion(&hp->unplug_wait);
 	preempt_disable();
 	hp->unplug = current;
 	wait_for_pinned_cpus(hp);
@@ -240,6 +242,14 @@ static void __cpu_unplug_sync(struct hotplug_pcp *hp)
 	wait_for_completion(&hp->synced);
 }
 
+static void __cpu_unplug_wait(unsigned int cpu)
+{
+	struct hotplug_pcp *hp = &per_cpu(hotplug_pcp, cpu);
+
+	complete(&hp->unplug_wait);
+	wait_for_completion(&hp->synced);
+}
+
 /*
  * Start the sync_unplug_thread on the target cpu and wait for it to
  * complete.
@@ -263,6 +273,7 @@ static int cpu_unplug_begin(unsigned int cpu)
 	tell_sched_cpu_down_begin(cpu);
 
 	init_completion(&hp->synced);
+	init_completion(&hp->unplug_wait);
 
 	hp->sync_tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d", cpu);
 	if (IS_ERR(hp->sync_tsk)) {
@@ -278,8 +289,7 @@ static int cpu_unplug_begin(unsigned int cpu)
 	 * wait for tasks that are going to enter these sections and
 	 * we must not have them block.
 	 */
-	__cpu_unplug_sync(hp);
-
+	wake_up_process(hp->sync_tsk);
 	return 0;
 }
 
@@ -487,6 +497,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		.hcpu = hcpu,
 	};
 	cpumask_var_t cpumask;
+	cpumask_var_t cpumask_org;
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -497,6 +508,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	/* Move the downtaker off the unplug cpu */
 	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
 		return -ENOMEM;
+	if (!alloc_cpumask_var(&cpumask_org, GFP_KERNEL))  {
+		free_cpumask_var(cpumask);
+		return -ENOMEM;
+	}
+
+	cpumask_copy(cpumask_org, tsk_cpus_allowed(current));
 	cpumask_andnot(cpumask, cpu_online_mask, cpumask_of(cpu));
 	set_cpus_allowed_ptr(current, cpumask);
 	free_cpumask_var(cpumask);
@@ -505,7 +522,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (mycpu == cpu) {
 		printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
 		migrate_enable();
-		return -EBUSY;
+		err = -EBUSY;
+		goto restore_cpus;
 	}
 
 	cpu_hotplug_begin();
@@ -524,6 +542,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		goto out_release;
 	}
 
+	__cpu_unplug_wait(cpu);
+
 	/* Notifiers are done. Don't let any more tasks pin this CPU. */
 	cpu_unplug_sync(cpu);
 
@@ -561,6 +581,9 @@ out_cancel:
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+restore_cpus:
+	set_cpus_allowed_ptr(current, cpumask_org);
+	free_cpumask_var(cpumask_org);
 	return err;
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d750268..3d7d5f6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -141,6 +141,62 @@ static inline void
 irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
 #endif
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+static void _irq_affinity_notify(struct irq_affinity_notify *notify);
+static struct task_struct *set_affinity_helper;
+static LIST_HEAD(affinity_list);
+static DEFINE_RAW_SPINLOCK(affinity_list_lock);
+
+static int set_affinity_thread(void *unused)
+{
+	while (1) {
+		struct irq_affinity_notify *notify;
+		int empty;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		raw_spin_lock_irq(&affinity_list_lock);
+		empty = list_empty(&affinity_list);
+		raw_spin_unlock_irq(&affinity_list_lock);
+
+		if (empty)
+			schedule();
+		if (kthread_should_stop())
+			break;
+		set_current_state(TASK_RUNNING);
+try_next:
+		notify = NULL;
+
+		raw_spin_lock_irq(&affinity_list_lock);
+		if (!list_empty(&affinity_list)) {
+			notify = list_first_entry(&affinity_list,
+					struct irq_affinity_notify, list);
+			list_del_init(&notify->list);
+		}
+		raw_spin_unlock_irq(&affinity_list_lock);
+
+		if (!notify)
+			continue;
+		_irq_affinity_notify(notify);
+		goto try_next;
+	}
+	return 0;
+}
+
+static void init_helper_thread(void)
+{
+	if (set_affinity_helper)
+		return;
+	set_affinity_helper = kthread_run(set_affinity_thread, NULL,
+			"affinity-cb");
+	WARN_ON(IS_ERR(set_affinity_helper));
+}
+#else
+
+static inline void init_helper_thread(void) { }
+
+#endif
+
 int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
@@ -166,7 +222,17 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 
 	if (desc->affinity_notify) {
 		kref_get(&desc->affinity_notify->kref);
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+		raw_spin_lock(&affinity_list_lock);
+		if (list_empty(&desc->affinity_notify->list))
+			list_add_tail(&affinity_list,
+					&desc->affinity_notify->list);
+		raw_spin_unlock(&affinity_list_lock);
+		wake_up_process(set_affinity_helper);
+#else
 		schedule_work(&desc->affinity_notify->work);
+#endif
 	}
 	irqd_set(data, IRQD_AFFINITY_SET);
 
@@ -207,10 +273,8 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
 
-static void irq_affinity_notify(struct work_struct *work)
+static void _irq_affinity_notify(struct irq_affinity_notify *notify)
 {
-	struct irq_affinity_notify *notify =
-		container_of(work, struct irq_affinity_notify, work);
 	struct irq_desc *desc = irq_to_desc(notify->irq);
 	cpumask_var_t cpumask;
 	unsigned long flags;
@@ -232,6 +296,13 @@ out:
 	kref_put(&notify->kref, notify->release);
 }
 
+static void irq_affinity_notify(struct work_struct *work)
+{
+	struct irq_affinity_notify *notify =
+		container_of(work, struct irq_affinity_notify, work);
+	_irq_affinity_notify(notify);
+}
+
 /**
  *	irq_set_affinity_notifier - control notification of IRQ affinity changes
  *	@irq:		Interrupt for which to enable/disable notification
@@ -261,6 +332,8 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 		notify->irq = irq;
 		kref_init(&notify->kref);
 		INIT_WORK(&notify->work, irq_affinity_notify);
+		INIT_LIST_HEAD(&notify->list);
+		init_helper_thread();
 	}
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -780,9 +853,6 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
  */
 static int irq_thread(void *data)
 {
-	static const struct sched_param param = {
-		.sched_priority = MAX_USER_RT_PRIO/2,
-	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -795,7 +865,6 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
 
 	while (!irq_wait_for_interrupt(action)) {
@@ -932,11 +1001,17 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (new->thread_fn && !nested) {
 		struct task_struct *t;
+		static const struct sched_param param = {
+			.sched_priority = MAX_USER_RT_PRIO/2,
+		};
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
 				   new->name);
 		if (IS_ERR(t))
 			return PTR_ERR(t);
+
+		sched_setscheduler(t, SCHED_FIFO, &param);
+
 		/*
 		 * We keep the reference to the task struct even if
 		 * the thread dies to avoid that the interrupt code
diff --git a/kernel/sched.c b/kernel/sched.c
index 96dd9c2..59bb8bc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4436,8 +4436,10 @@ static inline void sched_submit_work(struct task_struct *tsk)
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
+	 * Only call wake up if prev isn't blocked on a sleeping
+	 * spin lock.
 	 */
-	if (tsk->flags & PF_WQ_WORKER)
+	if (tsk->flags & PF_WQ_WORKER && !tsk->saved_state)
 		wq_worker_sleeping(tsk);
 
 	/*
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8b3a185..fa0c206 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -10,6 +10,7 @@
 #include <linux/workqueue.h>
 #include <linux/hrtimer.h>
 #include <linux/jiffies.h>
+#include <linux/kthread.h>
 #include <linux/math64.h>
 #include <linux/timex.h>
 #include <linux/time.h>
@@ -494,11 +495,52 @@ static void sync_cmos_clock(struct work_struct *work)
 	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * RT can not call schedule_delayed_work from real interrupt context.
+ * Need to make a thread to do the real work.
+ */
+static struct task_struct *cmos_delay_thread;
+static bool do_cmos_delay;
+
+static int run_cmos_delay(void *ignore)
+{
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (do_cmos_delay) {
+			do_cmos_delay = false;
+			schedule_delayed_work(&sync_cmos_work, 0);
+		}
+		schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+static void notify_cmos_timer(void)
+{
+	if (!no_sync_cmos_clock) {
+		do_cmos_delay = true;
+		/* Make visible before waking up process */
+		smp_wmb();
+		wake_up_process(cmos_delay_thread);
+	}
+}
+
+static __init int create_cmos_delay_thread(void)
+{
+	cmos_delay_thread = kthread_run(run_cmos_delay, NULL, "kcmosdelayd");
+	BUG_ON(!cmos_delay_thread);
+	return 0;
+}
+early_initcall(create_cmos_delay_thread);
+#else
 static void notify_cmos_timer(void)
 {
 	if (!no_sync_cmos_clock)
 		schedule_delayed_work(&sync_cmos_work, 0);
 }
+#endif /* CONFIG_PREEMPT_RT_FULL */
 
 #else
 static inline void notify_cmos_timer(void) { }
diff --git a/kernel/timer.c b/kernel/timer.c
index 2e21a6c..07070cb 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -76,7 +76,9 @@ struct tvec_root {
 struct tvec_base {
 	spinlock_t lock;
 	struct timer_list *running_timer;
+#ifdef CONFIG_PREEMPT_RT_FULL
 	wait_queue_head_t wait_for_running_timer;
+#endif
 	unsigned long timer_jiffies;
 	unsigned long next_timer;
 	struct tvec_root tv1;
@@ -930,7 +932,7 @@ static void wait_for_running_timer(struct timer_list *timer)
 			   base->running_timer != timer);
 }
 
-# define wakeup_timer_waiters(b)	wake_up(&(b)->wait_for_tunning_timer)
+# define wakeup_timer_waiters(b)	wake_up(&(b)->wait_for_running_timer)
 #else
 static inline void wait_for_running_timer(struct timer_list *timer)
 {
@@ -1183,7 +1185,7 @@ static inline void __run_timers(struct tvec_base *base)
 			spin_lock_irq(&base->lock);
 		}
 	}
-	wake_up(&base->wait_for_running_timer);
+	wakeup_timer_waiters(base);
 	spin_unlock_irq(&base->lock);
 }
 
@@ -1706,7 +1708,9 @@ static int __cpuinit init_timers_cpu(int cpu)
 			base = &boot_tvec_bases;
 		}
 		spin_lock_init(&base->lock);
+#ifdef CONFIG_PREEMPT_RT_FULL
 		init_waitqueue_head(&base->wait_for_running_timer);
+#endif
 		tvec_base_done[cpu] = 1;
 	} else {
 		base = per_cpu(tvec_bases, cpu);
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6302747..e5163ab 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -44,6 +44,7 @@ u64 notrace trace_clock_local(void)
 
 	return clock;
 }
+EXPORT_SYMBOL_GPL(trace_clock_local);
 
 /*
  * trace_clock(): 'between' trace clock. Not completely serialized,
diff --git a/localversion-rt b/localversion-rt
index 9788245..4e32122 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt117
+-rt118
