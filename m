Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3ILBHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:07:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3ILBHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:07:05 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=_4FCbG-fbZxghAKZcmoA:9 a=CjuIK1q_8ugA:10 a=sAUb61P50ZWkquYE:21 a=vGOYkVCrHYIJl-Wd:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 21:07:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.8.13-rt16
Message-ID: <20130911210702.4c3aed7b@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.8.13-rt16 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.8-rt
  Head SHA1: 983a26769301b0e19ce787baf37a58ee73cd34f7


Or to build 3.8.13-rt16 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13-rt16.patch.xz



You can also build from 3.8.13-rt15 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13-rt15-rt16.patch.xz



Enjoy,

-- Steve


Changes from v3.8.13-rt15:

---

John Kacur (1):
      hpsa: fix warning with smp_processor_id() in preemptible section

Sebastian Andrzej Siewior (2):
      powerpc: 52xx: provide a default in mpc52xx_irqhost_map()
      genirq: do not invoke the affinity callback via a workqueue

Steven Rostedt (4):
      rt,ntp: Move call to schedule_delayed_work() to helper thread
      hwlat-detector: Update hwlat_detector to add outer loop detection
      hwlat-detector: Use trace_clock_local if available
      hwlat-detector: Use thread instead of stop machine

Steven Rostedt (Red Hat) (2):
      hwlat-detect/trace: Export trace_clock_local for hwlat-detector
      Linux 3.8.13-rt16

Thomas Gleixner (1):
      sched: Distangle worker accounting from rqlock

----
 arch/powerpc/platforms/52xx/mpc52xx_pic.c |    3 +-
 drivers/misc/hwlat_detector.c             |  117 ++++++++++++++++++-----------
 drivers/scsi/hpsa.c                       |    2 +-
 include/linux/interrupt.h                 |    1 +
 kernel/irq/manage.c                       |   79 ++++++++++++++++++-
 kernel/sched/core.c                       |   70 ++++-------------
 kernel/time/ntp.c                         |   40 ++++++++++
 kernel/trace/trace_clock.c                |    1 +
 kernel/workqueue.c                        |   63 +++++++---------
 kernel/workqueue_sched.h                  |    5 +-
 localversion-rt                           |    2 +-
 11 files changed, 240 insertions(+), 143 deletions(-)
---------------------------
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index b89ef65..b69221b 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -373,8 +373,9 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 	case MPC52xx_IRQ_L1_PERP: irqchip = &mpc52xx_periph_irqchip; break;
 	case MPC52xx_IRQ_L1_SDMA: irqchip = &mpc52xx_sdma_irqchip; break;
 	case MPC52xx_IRQ_L1_CRIT:
+	default:
 		pr_warn("%s: Critical IRQ #%d is unsupported! Nopping it.\n",
-			__func__, l2irq);
+			__func__, l1irq);
 		irq_set_chip(virq, &no_irq_chip);
 		return 0;
 	}
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
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4f33806..80a44b1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -583,7 +583,7 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
 		if (likely(h->msix_vector))
 			c->Header.ReplyQueue =
-				smp_processor_id() % h->nreply_queues;
+				raw_smp_processor_id() % h->nreply_queues;
 	}
 }
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 11bdb1e..838d4bd 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -263,6 +263,7 @@ struct irq_affinity_notify {
 	unsigned int irq;
 	struct kref kref;
 	struct work_struct work;
+	struct list_head list;
 	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
 	void (*release)(struct kref *ref);
 };
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 81a28dd..cf5b5f7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -163,6 +163,62 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
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
@@ -181,7 +237,17 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 
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
 
@@ -222,10 +288,8 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
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
@@ -247,6 +311,13 @@ out:
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
@@ -276,6 +347,8 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 		notify->irq = irq;
 		kref_init(&notify->kref);
 		INIT_WORK(&notify->work, irq_affinity_notify);
+		INIT_LIST_HEAD(&notify->list);
+		init_helper_thread();
 	}
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 505e08f..d7c1471 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1321,10 +1321,6 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 {
 	activate_task(rq, p, en_flags);
 	p->on_rq = 1;
-
-	/* if a worker is waking up, notify workqueue */
-	if (p->flags & PF_WQ_WORKER)
-		wq_worker_waking_up(p, cpu_of(rq));
 }
 
 /*
@@ -1551,42 +1547,6 @@ out:
 }
 
 /**
- * try_to_wake_up_local - try to wake up a local task with rq lock held
- * @p: the thread to be awakened
- *
- * Put @p on the run-queue if it's not already there. The caller must
- * ensure that this_rq() is locked, @p is bound to this_rq() and not
- * the current task.
- */
-static void try_to_wake_up_local(struct task_struct *p)
-{
-	struct rq *rq = task_rq(p);
-
-	if (WARN_ON_ONCE(rq != this_rq()) ||
-	    WARN_ON_ONCE(p == current))
-		return;
-
-	lockdep_assert_held(&rq->lock);
-
-	if (!raw_spin_trylock(&p->pi_lock)) {
-		raw_spin_unlock(&rq->lock);
-		raw_spin_lock(&p->pi_lock);
-		raw_spin_lock(&rq->lock);
-	}
-
-	if (!(p->state & TASK_NORMAL))
-		goto out;
-
-	if (!p->on_rq)
-		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
-
-	ttwu_do_wakeup(rq, p, 0);
-	ttwu_stat(p, smp_processor_id(), 0);
-out:
-	raw_spin_unlock(&p->pi_lock);
-}
-
-/**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.
  *
@@ -3139,21 +3099,6 @@ need_resched:
 		} else {
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
-
-			/*
-			 * If a worker went to sleep, notify and ask workqueue
-			 * whether it wants to wake up a task to maintain
-			 * concurrency.
-			 * Only call wake up if prev isn't blocked on a sleeping
-			 * spin lock.
-			 */
-			if (prev->flags & PF_WQ_WORKER && !prev->saved_state) {
-				struct task_struct *to_wakeup;
-
-				to_wakeup = wq_worker_sleeping(prev, cpu);
-				if (to_wakeup)
-					try_to_wake_up_local(to_wakeup);
-			}
 		}
 		switch_count = &prev->nvcsw;
 	}
@@ -3197,6 +3142,14 @@ static inline void sched_submit_work(struct task_struct *tsk)
 {
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
+
+	/*
+	 * If a worker went to sleep, notify and ask workqueue whether
+	 * it wants to wake up a task to maintain concurrency.
+	 */
+	if (tsk->flags & PF_WQ_WORKER)
+		wq_worker_sleeping(tsk);
+
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
@@ -3205,12 +3158,19 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
 
+static inline void sched_update_worker(struct task_struct *tsk)
+{
+	if (tsk->flags & PF_WQ_WORKER)
+		wq_worker_running(tsk);
+}
+
 asmlinkage void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 
 	sched_submit_work(tsk);
 	__schedule();
+	sched_update_worker(tsk);
 }
 EXPORT_SYMBOL(schedule);
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index bb1edfa..3e93516 100644
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
@@ -529,10 +530,49 @@ static void sync_cmos_clock(struct work_struct *work)
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
+	do_cmos_delay = true;
+	/* Make visible before waking up process */
+	smp_wmb();
+	wake_up_process(cmos_delay_thread);
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
 	schedule_delayed_work(&sync_cmos_work, 0);
 }
+#endif /* CONFIG_PREEMPT_RT_FULL */
 
 #else
 static inline void notify_cmos_timer(void) { }
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 3947835..1bbb1b2 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -44,6 +44,7 @@ u64 notrace trace_clock_local(void)
 
 	return clock;
 }
+EXPORT_SYMBOL_GPL(trace_clock_local);
 
 /*
  * trace_clock(): 'between' trace clock. Not completely serialized,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 99855b3..788b017 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -149,6 +149,7 @@ struct worker {
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
 	int			id;		/* I: worker id */
+	int			sleeping;	/* None */
 
 	/* for rebinding worker to CPU */
 	struct work_struct	rebind_work;	/* L: for busy worker */
@@ -730,54 +731,45 @@ static void wake_up_worker(struct worker_pool *pool)
 }
 
 /**
- * wq_worker_waking_up - a worker is waking up
- * @task: task waking up
- * @cpu: CPU @task is waking up to
+ * wq_worker_running - a worker is running again
+ * @task: task returning from sleep
  *
- * This function is called during try_to_wake_up() when a worker is
- * being awoken.
- *
- * CONTEXT:
- * spin_lock_irq(rq->lock)
+ * This function is called when a worker returns from schedule()
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
+void wq_worker_running(struct task_struct *task)
 {
 	struct worker *worker = kthread_data(task);
 
-	if (!(worker->flags & WORKER_NOT_RUNNING)) {
-		WARN_ON_ONCE(worker->pool->gcwq->cpu != cpu);
+	if (!worker->sleeping)
+		return;
+	if (!(worker->flags & WORKER_NOT_RUNNING))
 		atomic_inc(get_pool_nr_running(worker->pool));
-	}
+	worker->sleeping = 0;
 }
 
 /**
  * wq_worker_sleeping - a worker is going to sleep
  * @task: task going to sleep
- * @cpu: CPU in question, must be the current CPU number
- *
- * This function is called during schedule() when a busy worker is
- * going to sleep.  Worker on the same cpu can be woken up by
- * returning pointer to its task.
- *
- * CONTEXT:
- * spin_lock_irq(rq->lock)
- *
- * RETURNS:
- * Worker task on @cpu to wake up, %NULL if none.
+ * This function is called from schedule() when a busy worker is
+ * going to sleep.
  */
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu)
+void wq_worker_sleeping(struct task_struct *task)
 {
-	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
-	struct worker_pool *pool = worker->pool;
-	atomic_t *nr_running = get_pool_nr_running(pool);
+	struct worker *next, *worker = kthread_data(task);
+	struct worker_pool *pool;
+	atomic_t *nr_running;
 
 	if (worker->flags & WORKER_NOT_RUNNING)
-		return NULL;
+		return;
+
+	if (WARN_ON_ONCE(worker->sleeping))
+		return;
 
-	/* this can only happen on the local cpu */
-	BUG_ON(cpu != raw_smp_processor_id());
+	pool = worker->pool;
+	nr_running = get_pool_nr_running(pool);
 
+	worker->sleeping = 1;
+	spin_lock_irq(&pool->gcwq->lock);
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
 	 * worklist not empty test sequence is in insert_work().
@@ -789,9 +781,12 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	 * manipulating idle_list, so dereferencing idle_list without gcwq
 	 * lock is safe.
 	 */
-	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
-		to_wakeup = first_worker(pool);
-	return to_wakeup ? to_wakeup->task : NULL;
+	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist)) {
+		next = first_worker(pool);
+		if (next)
+			wake_up_process(next->task);
+	}
+	spin_unlock_irq(&pool->gcwq->lock);
 }
 
 /**
diff --git a/kernel/workqueue_sched.h b/kernel/workqueue_sched.h
index 2d10fc9..3bf73e2 100644
--- a/kernel/workqueue_sched.h
+++ b/kernel/workqueue_sched.h
@@ -4,6 +4,5 @@
  * Scheduler hooks for concurrency managed workqueue.  Only to be
  * included from sched.c and workqueue.c.
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu);
+void wq_worker_running(struct task_struct *task);
+void wq_worker_sleeping(struct task_struct *task);
diff --git a/localversion-rt b/localversion-rt
index 18777ec..1199eba 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt15
+-rt16
