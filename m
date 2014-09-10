Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaIJVfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:35:14 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56742 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaIJVdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:33:39 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3/8] irq_work: Force raised irq work to run on irq work interrupt
Date: Wed, 10 Sep 2014 23:33:23 +0200
Message-Id: <1410384808-14760-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nohz full kick, which restarts the tick when any resource depend
on it, can't be executed anywhere given the operation it does on timers.
If it is called from the scheduler or timers code, chances are that
we run into a deadlock.

This is why we run the nohz full kick from an irq work. That way we make
sure that the kick runs on a virgin context.

However if that's the case when irq work runs in its own dedicated
self-ipi, things are different for the big bunch of archs that don't
support the self triggered way. In order to support them, irq works are
also handled by the timer interrupt as fallback.

Now when irq works run on the timer interrupt, the context isn't blank.
More precisely, they can run in the context of the hrtimer that runs the
tick. But the nohz kick cancels and restarts this hrtimer and cancelling
an hrtimer from itself isn't allowed. This is why we run in an endless
loop:

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

To fix this we force non-lazy irq works to run on irq work self-IPIs
when available. That ability of the arch to trigger irq work self IPIs
is available with arch_irq_work_has_interrupt().

Reported-by: Catalin Iacob <iacobcatalin@gmail.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq_work.h |  1 +
 kernel/irq_work.c        | 13 +++++++++++--
 kernel/time/timer.c      |  2 +-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6b47b2e..bf3fe71 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -39,6 +39,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu);
 #endif
 
 void irq_work_run(void);
+void irq_work_tick(void);
 void irq_work_sync(struct irq_work *work);
 
 #ifdef CONFIG_IRQ_WORK
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index e6bcbe7..353967d 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -115,8 +115,10 @@ bool irq_work_needs_cpu(void)
 
 	raised = &__get_cpu_var(raised_list);
 	lazy = &__get_cpu_var(lazy_list);
-	if (llist_empty(raised) && llist_empty(lazy))
-		return false;
+
+	if (llist_empty(raised) || arch_irq_work_has_interrupt())
+		if (llist_empty(lazy))
+			return false;
 
 	/* All work should have been flushed before going offline */
 	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
@@ -171,6 +173,13 @@ void irq_work_run(void)
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
+void irq_work_tick(void)
+{
+	if (!arch_irq_work_has_interrupt())
+		irq_work_run_list(&__get_cpu_var(raised_list));
+	irq_work_run_list(&__get_cpu_var(lazy_list));
+}
+
 /*
  * Synchronize against the irq_work @entry, ensures the entry is not
  * currently in use.
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
2.1.0

