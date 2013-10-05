Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3JEPnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:43:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:58142 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JEPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:43:50 -0400
Date: Sat, 5 Oct 2013 17:43:48 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.10.14-rt9
Message-ID: <20131005154348.GA13400@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.10.14-rt9 patch set.

Changes since v3.10.14-rt8

- the threshold module option of hwlat is no longer ignored. Path sent
  by Mike Galbraith
- two patches from Kirill Tkhai to get basic RT compiled on Sparc.
- the ppc patch for the 5200 has been altered slightly. Patch sent by
  Wolfram Sang
- A patch for SLAB to get it working on !RT (Thanks Corey Minyard).
- a fix for "sleeping from invalid context" in clock_was_set_delayed().
  Patch by Yang Shi.
- another fix for "sleeping from invalid context" in drain_all_stock.
  Patch also by Yang Shi.

Known issues:

      - SLAB support not working

      - The cpsw network driver shows some issues.

      - bcache is disabled.

      - an ancient race (since we got sleeping spinlocks) where the
        TASK_TRACED state is temporary replaced while waiting on a rw
        lock and the task can't be traced.

The delta patch against v3.10.10-rt6 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.14-rt8-rt9.patch.xz

The RT patch against 3.10.14 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.14-rt9.patch.xz

The split quilt queue is available at:

    https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patches-3.10.14-rt9.tar.xz

Sebastian

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index b69221b..2898b73 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -340,7 +340,7 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 {
 	int l1irq;
 	int l2irq;
-	struct irq_chip *irqchip;
+	struct irq_chip *uninitialized_var(irqchip);
 	void *hndlr;
 	int type;
 	u32 reg;
@@ -373,9 +373,8 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 	case MPC52xx_IRQ_L1_PERP: irqchip = &mpc52xx_periph_irqchip; break;
 	case MPC52xx_IRQ_L1_SDMA: irqchip = &mpc52xx_sdma_irqchip; break;
 	case MPC52xx_IRQ_L1_CRIT:
-	default:
 		pr_warn("%s: Critical IRQ #%d is unsupported! Nopping it.\n",
-			__func__, l1irq);
+			__func__, l2irq);
 		irq_set_chip(virq, &no_irq_chip);
 		return 0;
 	}
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 9ac9f16..6787bd3 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -521,6 +521,10 @@ menu "Executable file formats"
 
 source "fs/Kconfig.binfmt"
 
+config EARLY_PRINTK
+	bool
+	default y
+
 config COMPAT
 	bool
 	depends on SPARC64
diff --git a/arch/sparc/lib/ksyms.c b/arch/sparc/lib/ksyms.c
index 0c4e35e..323335b 100644
--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -98,15 +98,6 @@ EXPORT_SYMBOL(___copy_from_user);
 EXPORT_SYMBOL(___copy_in_user);
 EXPORT_SYMBOL(__clear_user);
 
-/* RW semaphores */
-EXPORT_SYMBOL(__down_read);
-EXPORT_SYMBOL(__down_read_trylock);
-EXPORT_SYMBOL(__down_write);
-EXPORT_SYMBOL(__down_write_trylock);
-EXPORT_SYMBOL(__up_read);
-EXPORT_SYMBOL(__up_write);
-EXPORT_SYMBOL(__downgrade_write);
-
 /* Atomic counter implementation. */
 EXPORT_SYMBOL(atomic_add);
 EXPORT_SYMBOL(atomic_add_ret);
diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index 6f61d5f..d2676b8 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -413,7 +413,7 @@ static int init_stats(void)
 		goto out;
 
 	__reset_stats();
-	data.threshold = DEFAULT_LAT_THRESHOLD;	    /* threshold us */
+	data.threshold = threshold ?: DEFAULT_LAT_THRESHOLD;	    /* threshold us */
 	data.sample_window = DEFAULT_SAMPLE_WINDOW; /* window us */
 	data.sample_width = DEFAULT_SAMPLE_WIDTH;   /* width us */
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index bd61c40..a63cfaf 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -47,6 +47,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
 #include <linux/timer.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 
@@ -740,6 +741,44 @@ static void clock_was_set_work(struct work_struct *work)
 
 static DECLARE_WORK(hrtimer_work, clock_was_set_work);
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * RT can not call schedule_work from real interrupt context.
+ * Need to make a thread to do the real work.
+ */
+static struct task_struct *clock_set_delay_thread;
+static bool do_clock_set_delay;
+
+static int run_clock_set_delay(void *ignore)
+{
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (do_clock_set_delay) {
+			do_clock_set_delay = false;
+			schedule_work(&hrtimer_work);
+		}
+		schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+void clock_was_set_delayed(void)
+{
+	do_clock_set_delay = true;
+	/* Make visible before waking up process */
+	smp_wmb();
+	wake_up_process(clock_set_delay_thread);
+}
+
+static __init int create_clock_set_delay_thread(void)
+{
+	clock_set_delay_thread = kthread_run(run_clock_set_delay, NULL, "kclksetdelayd");
+	BUG_ON(!clock_set_delay_thread);
+	return 0;
+}
+early_initcall(create_clock_set_delay_thread);
+#else /* PREEMPT_RT_FULL */
 /*
  * Called from timekeeping and resume code to reprogramm the hrtimer
  * interrupt device on all cpus.
@@ -748,6 +787,7 @@ void clock_was_set_delayed(void)
 {
 	schedule_work(&hrtimer_work);
 }
+#endif
 
 #else
 
diff --git a/localversion-rt b/localversion-rt
index 700c857..22746d6 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt8
+-rt9
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 905ce72..f113cb7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2436,11 +2436,10 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
  */
 static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 {
-	int cpu, curcpu;
+	int cpu;
 
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-	curcpu = get_cpu();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2450,14 +2449,9 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 			continue;
 		if (!mem_cgroup_same_or_subtree(root_memcg, memcg))
 			continue;
-		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
-			if (cpu == curcpu)
-				drain_local_stock(&stock->work);
-			else
-				schedule_work_on(cpu, &stock->work);
-		}
+		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+			schedule_work_on(cpu, &stock->work);
 	}
-	put_cpu();
 
 	if (!sync)
 		goto out;
diff --git a/mm/slab.c b/mm/slab.c
index 494274e..0a3d6d3 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1270,7 +1270,6 @@ static void __cpuinit cpuup_canceled(long cpu)
 			free_block(cachep, nc->entry, nc->avail, node);
 
 		if (!cpumask_empty(mask)) {
-			local_spin_unlock_irq(slab_lock, &n->list_lock);
 			unlock_l3_and_free_delayed(&n->list_lock);
 			goto free_array_cache;
 		}
@@ -1285,7 +1284,6 @@ static void __cpuinit cpuup_canceled(long cpu)
 		alien = n->alien;
 		n->alien = NULL;
 
-		local_spin_unlock_irq(slab_lock, &n->list_lock);
 		unlock_l3_and_free_delayed(&n->list_lock);
 
 		kfree(shared);
