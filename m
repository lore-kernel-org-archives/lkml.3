Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3FSMyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:54:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:54960 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3FSMyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:54:19 -0400
Date: Wed, 19 Jun 2013 14:54:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] timer fixes for 3.10
Message-ID: <alpine.DEB.2.02.1306191449090.4013@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

 * Fix inconstinant clock usage in virtual time accounting
 * Fix a build error in KVM caused by the NOHZ work
 * Remove a pointless timekeeping duty assignment which breaks NOHZ
 * Use a proper notifier return value to avoid random behaviour

Thanks,

	tglx

------------------>
Frederic Weisbecker (2):
      vtime: Use consistent clocks among nohz accounting
      kvm: Move guest entry/exit APIs to context_tracking

Jiri Bohac (1):
      tick: Remove useless timekeeping duty attribution to broadcast source

Li Zhong (1):
      nohz: Fix notifier return val that enforce timekeeping


 include/linux/context_tracking.h |   35 +++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h         |   37 +------------------------------------
 include/linux/vtime.h            |    4 ++--
 kernel/context_tracking.c        |    1 -
 kernel/sched/core.c              |    2 +-
 kernel/sched/cputime.c           |    6 +++---
 kernel/time/tick-broadcast.c     |    4 ----
 kernel/time/tick-sched.c         |    2 +-
 8 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 365f4a6..fc09d7b 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,6 +3,7 @@
 
 #include <linux/sched.h>
 #include <linux/percpu.h>
+#include <linux/vtime.h>
 #include <asm/ptrace.h>
 
 struct context_tracking {
@@ -19,6 +20,26 @@ struct context_tracking {
 	} state;
 };
 
+static inline void __guest_enter(void)
+{
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags |= PF_VCPU;
+}
+
+static inline void __guest_exit(void)
+{
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags &= ~PF_VCPU;
+}
+
 #ifdef CONFIG_CONTEXT_TRACKING
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
@@ -35,6 +56,9 @@ static inline bool context_tracking_active(void)
 extern void user_enter(void);
 extern void user_exit(void);
 
+extern void guest_enter(void);
+extern void guest_exit(void);
+
 static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
@@ -57,6 +81,17 @@ extern void context_tracking_task_switch(struct task_struct *prev,
 static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
+
+static inline void guest_enter(void)
+{
+	__guest_enter();
+}
+
+static inline void guest_exit(void)
+{
+	__guest_exit();
+}
+
 static inline enum ctx_state exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f0eea07..8db53cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -23,6 +23,7 @@
 #include <linux/ratelimit.h>
 #include <linux/err.h>
 #include <linux/irqflags.h>
+#include <linux/context_tracking.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -760,42 +761,6 @@ static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
 }
 #endif
 
-static inline void __guest_enter(void)
-{
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
-	vtime_account_system(current);
-	current->flags |= PF_VCPU;
-}
-
-static inline void __guest_exit(void)
-{
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
-	vtime_account_system(current);
-	current->flags &= ~PF_VCPU;
-}
-
-#ifdef CONFIG_CONTEXT_TRACKING
-extern void guest_enter(void);
-extern void guest_exit(void);
-
-#else /* !CONFIG_CONTEXT_TRACKING */
-static inline void guest_enter(void)
-{
-	__guest_enter();
-}
-
-static inline void guest_exit(void)
-{
-	__guest_exit();
-}
-#endif /* !CONFIG_CONTEXT_TRACKING */
-
 static inline void kvm_guest_enter(void)
 {
 	unsigned long flags;
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 71a5782..b1dd2db 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -34,7 +34,7 @@ static inline void vtime_user_exit(struct task_struct *tsk)
 }
 extern void vtime_guest_enter(struct task_struct *tsk);
 extern void vtime_guest_exit(struct task_struct *tsk);
-extern void vtime_init_idle(struct task_struct *tsk);
+extern void vtime_init_idle(struct task_struct *tsk, int cpu);
 #else
 static inline void vtime_account_irq_exit(struct task_struct *tsk)
 {
@@ -45,7 +45,7 @@ static inline void vtime_user_enter(struct task_struct *tsk) { }
 static inline void vtime_user_exit(struct task_struct *tsk) { }
 static inline void vtime_guest_enter(struct task_struct *tsk) { }
 static inline void vtime_guest_exit(struct task_struct *tsk) { }
-static inline void vtime_init_idle(struct task_struct *tsk) { }
+static inline void vtime_init_idle(struct task_struct *tsk, int cpu) { }
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 65349f0..85bdde1 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/context_tracking.h>
-#include <linux/kvm_host.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/hardirq.h>
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..e1a27f9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4745,7 +4745,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 */
 	idle->sched_class = &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
-	vtime_init_idle(idle);
+	vtime_init_idle(idle, cpu);
 #if defined(CONFIG_SMP)
 	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
 #endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index cc2dc3e..b5ccba2 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -747,17 +747,17 @@ void arch_vtime_task_switch(struct task_struct *prev)
 
 	write_seqlock(&current->vtime_seqlock);
 	current->vtime_snap_whence = VTIME_SYS;
-	current->vtime_snap = sched_clock();
+	current->vtime_snap = sched_clock_cpu(smp_processor_id());
 	write_sequnlock(&current->vtime_seqlock);
 }
 
-void vtime_init_idle(struct task_struct *t)
+void vtime_init_idle(struct task_struct *t, int cpu)
 {
 	unsigned long flags;
 
 	write_seqlock_irqsave(&t->vtime_seqlock, flags);
 	t->vtime_snap_whence = VTIME_SYS;
-	t->vtime_snap = sched_clock();
+	t->vtime_snap = sched_clock_cpu(cpu);
 	write_sequnlock_irqrestore(&t->vtime_seqlock, flags);
 }
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 0c73942..b4c2455 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -698,10 +698,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 
-		/* Take the do_timer update */
-		if (!tick_nohz_full_cpu(cpu))
-			tick_do_timer_cpu = cpu;
-
 		/*
 		 * We must be careful here. There might be other CPUs
 		 * waiting for periodic broadcast. We need to set the
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f420813..0cf1c14 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -306,7 +306,7 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 		 * we can't safely shutdown that CPU.
 		 */
 		if (have_nohz_full_mask && tick_do_timer_cpu == cpu)
-			return -EINVAL;
+			return NOTIFY_BAD;
 		break;
 	}
 	return NOTIFY_OK;
