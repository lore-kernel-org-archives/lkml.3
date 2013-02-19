Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab3BSN4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:56:08 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:48292 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab3BSN4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:56:05 -0500
Date: Tue, 19 Feb 2013 14:55:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core changes for v3.9
Message-ID: <20130219135559.GA12449@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

   HEAD: 36a5df85e9a3c218b73f6cf80098016ca3f0410d genirq: Export enable/disable_percpu_irq()

The biggest changes are the IRQ-work and printk changes from 
Frederic Weisbecker, which prepare the code for 'full dynticks' 
(the ability to stop or slow down the periodic tick arbitrarily, 
not just in idle time as today):

    * Don't stop tick with irq works pending. This
      fix is generally useful and concerns archs that
      can't raise self IPIs.
    
    * Flush irq works before CPU offlining.
    
    * Introduce "lazy" irq works that can wait for the
      next tick to be executed, unless it's stopped.
    
    * Implement klogd wake up using irq work. This
      removes the ad-hoc printk_tick()/printk_needs_cpu()
      hooks and make it working even in dynticks mode.

    * Cleanups and fixes.

 Thanks,

	Ingo

------------------>
Chris Metcalf (1):
      genirq: Export enable/disable_percpu_irq()

Frederic Weisbecker (7):
      irq_work: Fix racy IRQ_WORK_BUSY flag setting
      irq_work: Fix racy check on work pending flag
      irq_work: Remove CONFIG_HAVE_IRQ_WORK
      nohz: Add API to check tick state
      irq_work: Don't stop the tick with pending works
      irq_work: Make self-IPIs optable
      printk: Wake up klogd using irq_work

James Hogan (1):
      arch Kconfig: Remove references to IRQ_PER_CPU

Steven Rostedt (2):
      irq_work: Flush work on CPU_DYING
      irq_work: Warn if there's still work on cpu_down

Thomas Gleixner (1):
      genirq: Avoid deadlock in spurious handling

anish kumar (1):
      irq_work: Remove return value from the irq_work_queue() function


 arch/alpha/Kconfig                  |   1 -
 arch/arm/Kconfig                    |   1 -
 arch/arm64/Kconfig                  |   1 -
 arch/blackfin/Kconfig               |   2 -
 arch/frv/Kconfig                    |   1 -
 arch/hexagon/Kconfig                |   2 -
 arch/ia64/Kconfig                   |   1 -
 arch/mips/Kconfig                   |   2 -
 arch/parisc/Kconfig                 |   2 -
 arch/powerpc/Kconfig                |   2 -
 arch/s390/Kconfig                   |   1 -
 arch/sh/Kconfig                     |   4 -
 arch/sparc/Kconfig                  |   1 -
 arch/x86/Kconfig                    |   1 -
 drivers/staging/iio/trigger/Kconfig |   1 -
 include/linux/irq_work.h            |  22 +++++-
 include/linux/printk.h              |   3 -
 include/linux/tick.h                |  17 +++-
 init/Kconfig                        |   5 +-
 kernel/irq/manage.c                 |   2 +
 kernel/irq/spurious.c               |   7 +-
 kernel/irq_work.c                   | 150 +++++++++++++++++++++++++-----------
 kernel/printk.c                     |  36 +++++----
 kernel/time/tick-sched.c            |   7 +-
 kernel/timer.c                      |   1 -
 25 files changed, 171 insertions(+), 102 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 9d5904c..9b504af 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,7 +5,6 @@ config ALPHA
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
-	select HAVE_IRQ_WORK
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 67874b8..9bbe760 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -36,7 +36,6 @@ config ARM
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_IDE if PCI || ISA || PCMCIA
-	select HAVE_IRQ_WORK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f8f362a..75e915b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -21,7 +21,6 @@ config ARM64
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
-	select HAVE_IRQ_WORK
 	select HAVE_MEMBLOCK
 	select HAVE_PERF_EVENTS
 	select IRQ_DOMAIN
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index b6f3ad5..67e4aaa 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -24,7 +24,6 @@ config BLACKFIN
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_IDE
-	select HAVE_IRQ_WORK
 	select HAVE_KERNEL_GZIP if RAMKERNEL
 	select HAVE_KERNEL_BZIP2 if RAMKERNEL
 	select HAVE_KERNEL_LZMA if RAMKERNEL
@@ -38,7 +37,6 @@ config BLACKFIN
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_PROBE
-	select IRQ_PER_CPU if SMP
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 9d26264..17df48f 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -3,7 +3,6 @@ config FRV
 	default y
 	select HAVE_IDE
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 0744f7d..e4decc6 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -12,9 +12,7 @@ config HEXAGON
 	# select ARCH_WANT_OPTIONAL_GPIOLIB
 	# select ARCH_REQUIRE_GPIOLIB
 	# select HAVE_CLK
-	# select IRQ_PER_CPU
 	# select GENERIC_PENDING_IRQ if SMP
-	select HAVE_IRQ_WORK
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 3279646..00c2e88 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -29,7 +29,6 @@ config IA64
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
-	select IRQ_PER_CPU
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 2ac626a..9becc44 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -4,7 +4,6 @@ config MIPS
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
@@ -2161,7 +2160,6 @@ source "mm/Kconfig"
 config SMP
 	bool "Multi-Processing support"
 	depends on SYS_SUPPORTS_SMP
-	select IRQ_PER_CPU
 	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index b77feff..a32e34e 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -9,14 +9,12 @@ config PARISC
 	select RTC_DRV_GENERIC
 	select INIT_ALL_POSSIBLE
 	select BUG
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
 	select HAVE_GENERIC_HARDIRQS
 	select BROKEN_RODATA
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PCI_IOMAP
-	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 17903f1..561ccca 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -118,14 +118,12 @@ config PPC
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
 	select HAVE_GENERIC_HARDIRQS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select SPARSE_IRQ
-	select IRQ_PER_CPU
 	select IRQ_DOMAIN
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index b5ea38c..c15ba7d 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -78,7 +78,6 @@ config S390
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
 	select INIT_ALL_POSSIBLE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_DEBUG_KMEMLEAK
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index babc2b8..9c833c5 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -11,7 +11,6 @@ config SUPERH
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
@@ -91,9 +90,6 @@ config GENERIC_CSUM
 config GENERIC_HWEIGHT
 	def_bool y
 
-config IRQ_PER_CPU
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool n
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 9f2edb5..ed937ae 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -23,7 +23,6 @@ config SPARC
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select RTC_CLASS
 	select RTC_DRV_M48T59
-	select HAVE_IRQ_WORK
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..5d3d61f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,7 +28,6 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
-	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
diff --git a/drivers/staging/iio/trigger/Kconfig b/drivers/staging/iio/trigger/Kconfig
index 7d32075..d44d3ad 100644
--- a/drivers/staging/iio/trigger/Kconfig
+++ b/drivers/staging/iio/trigger/Kconfig
@@ -21,7 +21,6 @@ config IIO_GPIO_TRIGGER
 config IIO_SYSFS_TRIGGER
 	tristate "SYSFS trigger"
 	depends on SYSFS
-	depends on HAVE_IRQ_WORK
 	select IRQ_WORK
 	help
 	  Provides support for using SYSFS entry as IIO triggers.
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6a9e8f5..f5dbce5 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -3,6 +3,20 @@
 
 #include <linux/llist.h>
 
+/*
+ * An entry can be in one of four states:
+ *
+ * free	     NULL, 0 -> {claimed}       : free to be used
+ * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
+ * pending   next, 3 -> {busy}          : queued, pending callback
+ * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
+ */
+
+#define IRQ_WORK_PENDING	1UL
+#define IRQ_WORK_BUSY		2UL
+#define IRQ_WORK_FLAGS		3UL
+#define IRQ_WORK_LAZY		4UL /* Doesn't want IPI, wait for tick */
+
 struct irq_work {
 	unsigned long flags;
 	struct llist_node llnode;
@@ -16,8 +30,14 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 	work->func = func;
 }
 
-bool irq_work_queue(struct irq_work *work);
+void irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
+#ifdef CONFIG_IRQ_WORK
+bool irq_work_needs_cpu(void);
+#else
+static bool irq_work_needs_cpu(void) { return false; }
+#endif
+
 #endif /* _LINUX_IRQ_WORK_H */
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9afc01e..86c4b62 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -98,9 +98,6 @@ int no_printk(const char *fmt, ...)
 extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
 
-extern int printk_needs_cpu(int cpu);
-extern void printk_tick(void);
-
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
 int vprintk_emit(int facility, int level,
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 1a6567b..553272e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -8,6 +8,8 @@
 
 #include <linux/clockchips.h>
 #include <linux/irqflags.h>
+#include <linux/percpu.h>
+#include <linux/hrtimer.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -122,13 +124,26 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
+DECLARE_PER_CPU(struct tick_sched, tick_cpu_sched);
+
+static inline int tick_nohz_tick_stopped(void)
+{
+	return __this_cpu_read(tick_cpu_sched.tick_stopped);
+}
+
 extern void tick_nohz_idle_enter(void);
 extern void tick_nohz_idle_exit(void);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
-# else
+
+# else /* !CONFIG_NO_HZ */
+static inline int tick_nohz_tick_stopped(void)
+{
+	return 0;
+}
+
 static inline void tick_nohz_idle_enter(void) { }
 static inline void tick_nohz_idle_exit(void) { }
 
diff --git a/init/Kconfig b/init/Kconfig
index be8b7f5..a98e1ac 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -20,12 +20,8 @@ config CONSTRUCTORS
 	bool
 	depends on !UML
 
-config HAVE_IRQ_WORK
-	bool
-
 config IRQ_WORK
 	bool
-	depends on HAVE_IRQ_WORK
 
 config BUILDTIME_EXTABLE_SORT
 	bool
@@ -1263,6 +1259,7 @@ config HOTPLUG
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
+	select IRQ_WORK
 	help
 	  This option enables normal printk support. Removing it
 	  eliminates most of the message strings from the kernel image
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e49a288..88e7bed 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1524,6 +1524,7 @@ void enable_percpu_irq(unsigned int irq, unsigned int type)
 out:
 	irq_put_desc_unlock(desc, flags);
 }
+EXPORT_SYMBOL_GPL(enable_percpu_irq);
 
 void disable_percpu_irq(unsigned int irq)
 {
@@ -1537,6 +1538,7 @@ void disable_percpu_irq(unsigned int irq)
 	irq_percpu_disable(desc, cpu);
 	irq_put_desc_unlock(desc, flags);
 }
+EXPORT_SYMBOL_GPL(disable_percpu_irq);
 
 /*
  * Internal function to unregister a percpu irqaction.
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 611cd60..7b5f012 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -80,13 +80,11 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 
 	/*
 	 * All handlers must agree on IRQF_SHARED, so we test just the
-	 * first. Check for action->next as well.
+	 * first.
 	 */
 	action = desc->action;
 	if (!action || !(action->flags & IRQF_SHARED) ||
-	    (action->flags & __IRQF_TIMER) ||
-	    (action->handler(irq, action->dev_id) == IRQ_HANDLED) ||
-	    !action->next)
+	    (action->flags & __IRQF_TIMER))
 		goto out;
 
 	/* Already running on another processor */
@@ -104,6 +102,7 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 	do {
 		if (handle_irq_event(desc) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
+		/* Make sure that there is still a valid action */
 		action = desc->action;
 	} while ((desc->istate & IRQS_PENDING) && action);
 	desc->istate &= ~IRQS_POLL_INPROGRESS;
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..55fcce6 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -12,37 +12,36 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
+#include <linux/sched.h>
+#include <linux/tick.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
 #include <asm/processor.h>
 
-/*
- * An entry can be in one of four states:
- *
- * free	     NULL, 0 -> {claimed}       : free to be used
- * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
- * pending   next, 3 -> {busy}          : queued, pending callback
- * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
- */
-
-#define IRQ_WORK_PENDING	1UL
-#define IRQ_WORK_BUSY		2UL
-#define IRQ_WORK_FLAGS		3UL
 
 static DEFINE_PER_CPU(struct llist_head, irq_work_list);
+static DEFINE_PER_CPU(int, irq_work_raised);
 
 /*
  * Claim the entry so that no one else will poke at it.
  */
 static bool irq_work_claim(struct irq_work *work)
 {
-	unsigned long flags, nflags;
+	unsigned long flags, oflags, nflags;
 
+	/*
+	 * Start with our best wish as a premise but only trust any
+	 * flag value after cmpxchg() result.
+	 */
+	flags = work->flags & ~IRQ_WORK_PENDING;
 	for (;;) {
-		flags = work->flags;
-		if (flags & IRQ_WORK_PENDING)
-			return false;
 		nflags = flags | IRQ_WORK_FLAGS;
-		if (cmpxchg(&work->flags, flags, nflags) == flags)
+		oflags = cmpxchg(&work->flags, flags, nflags);
+		if (oflags == flags)
 			break;
+		if (oflags & IRQ_WORK_PENDING)
+			return false;
+		flags = oflags;
 		cpu_relax();
 	}
 
@@ -57,57 +56,69 @@ void __weak arch_irq_work_raise(void)
 }
 
 /*
- * Queue the entry and raise the IPI if needed.
+ * Enqueue the irq_work @entry unless it's already pending
+ * somewhere.
+ *
+ * Can be re-enqueued while the callback is still in progress.
  */
-static void __irq_work_queue(struct irq_work *work)
+void irq_work_queue(struct irq_work *work)
 {
-	bool empty;
+	/* Only queue if not already pending */
+	if (!irq_work_claim(work))
+		return;
 
+	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-	/* The list was empty, raise self-interrupt to start processing. */
-	if (empty)
-		arch_irq_work_raise();
+	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+
+	/*
+	 * If the work is not "lazy" or the tick is stopped, raise the irq
+	 * work interrupt (if supported by the arch), otherwise, just wait
+	 * for the next tick.
+	 */
+	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
+		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
+			arch_irq_work_raise();
+	}
 
 	preempt_enable();
 }
+EXPORT_SYMBOL_GPL(irq_work_queue);
 
-/*
- * Enqueue the irq_work @entry, returns true on success, failure when the
- * @entry was already enqueued by someone else.
- *
- * Can be re-enqueued while the callback is still in progress.
- */
-bool irq_work_queue(struct irq_work *work)
+bool irq_work_needs_cpu(void)
 {
-	if (!irq_work_claim(work)) {
-		/*
-		 * Already enqueued, can't do!
-		 */
+	struct llist_head *this_list;
+
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list))
 		return false;
-	}
 
-	__irq_work_queue(work);
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
+
 	return true;
 }
-EXPORT_SYMBOL_GPL(irq_work_queue);
 
-/*
- * Run the irq_work entries on this cpu. Requires to be ran from hardirq
- * context with local IRQs disabled.
- */
-void irq_work_run(void)
+static void __irq_work_run(void)
 {
+	unsigned long flags;
 	struct irq_work *work;
 	struct llist_head *this_list;
 	struct llist_node *llnode;
 
+
+	/*
+	 * Reset the "raised" state right before we check the list because
+	 * an NMI may enqueue after we find the list empty from the runner.
+	 */
+	__this_cpu_write(irq_work_raised, 0);
+	barrier();
+
 	this_list = &__get_cpu_var(irq_work_list);
 	if (llist_empty(this_list))
 		return;
 
-	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
 	llnode = llist_del_all(this_list);
@@ -119,16 +130,31 @@ void irq_work_run(void)
 		/*
 		 * Clear the PENDING bit, after this point the @work
 		 * can be re-used.
+		 * Make it immediately visible so that other CPUs trying
+		 * to claim that work don't rely on us to handle their data
+		 * while we are in the middle of the func.
 		 */
-		work->flags = IRQ_WORK_BUSY;
+		flags = work->flags & ~IRQ_WORK_PENDING;
+		xchg(&work->flags, flags);
+
 		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
+		(void)cmpxchg(&work->flags, flags, flags & ~IRQ_WORK_BUSY);
 	}
 }
+
+/*
+ * Run the irq_work entries on this cpu. Requires to be ran from hardirq
+ * context with local IRQs disabled.
+ */
+void irq_work_run(void)
+{
+	BUG_ON(!in_irq());
+	__irq_work_run();
+}
 EXPORT_SYMBOL_GPL(irq_work_run);
 
 /*
@@ -143,3 +169,35 @@ void irq_work_sync(struct irq_work *work)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
+
+#ifdef CONFIG_HOTPLUG_CPU
+static int irq_work_cpu_notify(struct notifier_block *self,
+			       unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_DYING:
+		/* Called from stop_machine */
+		if (WARN_ON_ONCE(cpu != smp_processor_id()))
+			break;
+		__irq_work_run();
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpu_notify;
+
+static __init int irq_work_init_cpu_notifier(void)
+{
+	cpu_notify.notifier_call = irq_work_cpu_notify;
+	cpu_notify.priority = 0;
+	register_cpu_notifier(&cpu_notify);
+	return 0;
+}
+device_initcall(irq_work_init_cpu_notifier);
+
+#endif /* CONFIG_HOTPLUG_CPU */
diff --git a/kernel/printk.c b/kernel/printk.c
index 357f714..0b31715 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -42,6 +42,7 @@
 #include <linux/notifier.h>
 #include <linux/rculist.h>
 #include <linux/poll.h>
+#include <linux/irq_work.h>
 
 #include <asm/uaccess.h>
 
@@ -1967,30 +1968,32 @@ int is_console_locked(void)
 static DEFINE_PER_CPU(int, printk_pending);
 static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
-void printk_tick(void)
+static void wake_up_klogd_work_func(struct irq_work *irq_work)
 {
-	if (__this_cpu_read(printk_pending)) {
-		int pending = __this_cpu_xchg(printk_pending, 0);
-		if (pending & PRINTK_PENDING_SCHED) {
-			char *buf = __get_cpu_var(printk_sched_buf);
-			printk(KERN_WARNING "[sched_delayed] %s", buf);
-		}
-		if (pending & PRINTK_PENDING_WAKEUP)
-			wake_up_interruptible(&log_wait);
+	int pending = __this_cpu_xchg(printk_pending, 0);
+
+	if (pending & PRINTK_PENDING_SCHED) {
+		char *buf = __get_cpu_var(printk_sched_buf);
+		printk(KERN_WARNING "[sched_delayed] %s", buf);
 	}
-}
 
-int printk_needs_cpu(int cpu)
-{
-	if (cpu_is_offline(cpu))
-		printk_tick();
-	return __this_cpu_read(printk_pending);
+	if (pending & PRINTK_PENDING_WAKEUP)
+		wake_up_interruptible(&log_wait);
 }
 
+static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
+	.func = wake_up_klogd_work_func,
+	.flags = IRQ_WORK_LAZY,
+};
+
 void wake_up_klogd(void)
 {
-	if (waitqueue_active(&log_wait))
+	preempt_disable();
+	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	}
+	preempt_enable();
 }
 
 static void console_cont_flush(char *text, size_t size)
@@ -2471,6 +2474,7 @@ int printk_sched(const char *fmt, ...)
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
+	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
 	local_irq_restore(flags);
 
 	return r;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d58e552..fb8e5e4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/irq_work.h>
 
 #include <asm/irq_regs.h>
 
@@ -28,7 +29,7 @@
 /*
  * Per cpu nohz control structure
  */
-static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
+DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
 
 /*
  * The time, when the last jiffy update happened. Protected by jiffies_lock.
@@ -331,8 +332,8 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&jiffies_lock, seq));
 
-	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
+	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
diff --git a/kernel/timer.c b/kernel/timer.c
index 367d008..ff3b516 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1351,7 +1351,6 @@ void update_process_times(int user_tick)
 	account_process_tick(p, user_tick);
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
-	printk_tick();
 #ifdef CONFIG_IRQ_WORK
 	if (in_irq())
 		irq_work_run();
