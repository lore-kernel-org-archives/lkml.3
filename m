Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaHUO5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:57:49 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:52575 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaHUOxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 3/9] irq_work: Force raised irq work to run on irq work interrupt
Date: Thu, 21 Aug 2014 16:52:51 +0200
Message-Id: <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nohz full kick, which restarts the tick after some new state depend
on it, can't be called from any place given the operation it does on
timers. If it is called from the scheduler or timers code, chances are that
we run into a deadlock.

This is why we run the nohz full kick from an irq work. That way we make
sure that the kick runs on a virgin context.

However if that's the case when irq work runs in its own dedicated
self-ipi, things are different for the big bunch of archs that don't
support the self triggered way. In order to handle them, irq works are
also handled by the timer interrupt as fallback.

Now when irq works run on the timer interrupt, the context isn't blank.
More precisely, they can run in the context of the hrtimer that runs the
tick. But the nohz kick cancels and restarts this hrtimer. If it does
the cancellation from the hrtimer itself, we run in an endless loop:

	Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
	CPU: 2 PID: 7538 Comm: kworker/u8:8 Not tainted 3.16.0+ #34
	Workqueue: btrfs-endio-write normal_work_helper [btrfs]
	 ffff880244c06c88 000000001b486fe1 ffff880244c06bf0 ffffffff8a7f1e37
	 ffffffff8ac52a18 ffff880244c06c78 ffffffff8a7ef928 0000000000000010
	 ffff880244c06c88 ffff880244c06c20 000000001b486fe1 0000000000000000
	Call Trace:
	 <NMI[<ffffffff8a7f1e37>] dump_stack+0x4e/0x7a
	 [<ffffffff8a7ef928>] panic+0xd4/0x207
	 [<ffffffff8a1450e8>] watchdog_overflow_callback+0x118/0x120
	 [<ffffffff8a186b0e>] __perf_event_overflow+0xae/0x350
	 [<ffffffff8a184f80>] ? perf_event_task_disable+0xa0/0xa0
	 [<ffffffff8a01a4cf>] ? x86_perf_event_set_period+0xbf/0x150
	 [<ffffffff8a187934>] perf_event_overflow+0x14/0x20
	 [<ffffffff8a020386>] intel_pmu_handle_irq+0x206/0x410
	 [<ffffffff8a01937b>] perf_event_nmi_handler+0x2b/0x50
	 [<ffffffff8a007b72>] nmi_handle+0xd2/0x390
	 [<ffffffff8a007aa5>] ? nmi_handle+0x5/0x390
	 [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
	 [<ffffffff8a008062>] default_do_nmi+0x72/0x1c0
	 [<ffffffff8a008268>] do_nmi+0xb8/0x100
	 [<ffffffff8a7ff66a>] end_repeat_nmi+0x1e/0x2e
	 [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
	 [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
	 [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
	 <<EOE><IRQ[<ffffffff8a0ccd2f>] lock_acquired+0xaf/0x450
	 [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
	 [<ffffffff8a7fc678>] _raw_spin_lock_irqsave+0x78/0x90
	 [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
	 [<ffffffff8a0f74c5>] lock_hrtimer_base.isra.20+0x25/0x50
	 [<ffffffff8a0f7723>] hrtimer_try_to_cancel+0x33/0x1e0
	 [<ffffffff8a0f78ea>] hrtimer_cancel+0x1a/0x30
	 [<ffffffff8a109237>] tick_nohz_restart+0x17/0x90
	 [<ffffffff8a10a213>] __tick_nohz_full_check+0xc3/0x100
	 [<ffffffff8a10a25e>] nohz_full_kick_work_func+0xe/0x10
	 [<ffffffff8a17c884>] irq_work_run_list+0x44/0x70
	 [<ffffffff8a17c8da>] irq_work_run+0x2a/0x50
	 [<ffffffff8a0f700b>] update_process_times+0x5b/0x70
	 [<ffffffff8a109005>] tick_sched_handle.isra.21+0x25/0x60
	 [<ffffffff8a109b81>] tick_sched_timer+0x41/0x60
	 [<ffffffff8a0f7aa2>] __run_hrtimer+0x72/0x470
	 [<ffffffff8a109b40>] ? tick_sched_do_timer+0xb0/0xb0
	 [<ffffffff8a0f8707>] hrtimer_interrupt+0x117/0x270
	 [<ffffffff8a034357>] local_apic_timer_interrupt+0x37/0x60
	 [<ffffffff8a80010f>] smp_apic_timer_interrupt+0x3f/0x50
	 [<ffffffff8a7fe52f>] apic_timer_interrupt+0x6f/0x80

Two possible solutions to fix this: either we make the kick self-aware
of the context it runs on (tick hrtimer or irq work IPI) and adapt the
action on top of it or we force non-lazy irq works to run on irq work
IPIs when available.

The second solution needs the irq work subsystem to know if the arch
supports irq work IPIs. This information will have to be available anyway
because nohz full can't work without that arch support and we must
initialize irq work properly with that dependency in mind.

So lets provide a way for archs to tell about that irq work IPI support.
On top of that we can force irq works on that IPI to avoid lockups like
above.

Reported-by: Dave Jones <davej@redhat.com>
Cc: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq_work.h |  3 +++
 init/main.c              |  1 +
 kernel/irq_work.c        | 21 ++++++++++++++++++++-
 kernel/time/timer.c      |  2 +-
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index bf9422c..708c895 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -39,11 +39,14 @@ bool irq_work_queue_on(struct irq_work *work, int cpu);
 #endif
 
 void irq_work_run(void);
+void irq_work_tick(void);
 void irq_work_sync(struct irq_work *work);
 
 #ifdef CONFIG_IRQ_WORK
+void irq_work_init(void);
 bool irq_work_needs_cpu(void);
 #else
+static inline void irq_work_init(void) { }
 static inline bool irq_work_needs_cpu(void) { return false; }
 #endif
 
diff --git a/init/main.c b/init/main.c
index 8af2f1a..0c0015f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -582,6 +582,7 @@ asmlinkage __visible void __init start_kernel(void)
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
+	irq_work_init();
 	tick_init();
 	init_timers();
 	hrtimers_init();
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index e6bcbe7..17bd203 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -22,6 +22,7 @@
 
 static DEFINE_PER_CPU(struct llist_head, raised_list);
 static DEFINE_PER_CPU(struct llist_head, lazy_list);
+static bool has_own_interrupt;
 
 /*
  * Claim the entry so that no one else will poke at it.
@@ -56,6 +57,11 @@ void __weak arch_irq_work_raise(void)
 	 */
 }
 
+int __init __weak arch_irq_work_has_own_interrupt(void)
+{
+	return 0;
+}
+
 #ifdef CONFIG_SMP
 /*
  * Enqueue the irq_work @work on @cpu unless it's already pending
@@ -115,7 +121,8 @@ bool irq_work_needs_cpu(void)
 
 	raised = &__get_cpu_var(raised_list);
 	lazy = &__get_cpu_var(lazy_list);
-	if (llist_empty(raised) && llist_empty(lazy))
+
+	if ((llist_empty(raised) || has_own_interrupt) && llist_empty(lazy))
 		return false;
 
 	/* All work should have been flushed before going offline */
@@ -171,6 +178,13 @@ void irq_work_run(void)
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
+void irq_work_tick(void)
+{
+	if (!has_own_interrupt)
+		irq_work_run_list(&__get_cpu_var(raised_list));
+	irq_work_run_list(&__get_cpu_var(lazy_list));
+}
+
 /*
  * Synchronize against the irq_work @entry, ensures the entry is not
  * currently in use.
@@ -183,3 +197,8 @@ void irq_work_sync(struct irq_work *work)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
+
+void __init irq_work_init(void)
+{
+	has_own_interrupt = arch_irq_work_has_own_interrupt();
+}
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index aca5dfe..9bbb834 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1385,7 +1385,7 @@ void update_process_times(int user_tick)
 	rcu_check_callbacks(cpu, user_tick);
 #ifdef CONFIG_IRQ_WORK
 	if (in_irq())
-		irq_work_run();
+		irq_work_tick();
 #endif
 	scheduler_tick();
 	run_posix_cpu_timers(p);
-- 
1.8.3.1

