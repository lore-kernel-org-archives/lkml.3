Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3AWAFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:05:11 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:40473 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3AWAEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:04:35 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 7/8] kvm: Prepare to add generic guest entry/exit callbacks
Date: Wed, 23 Jan 2013 01:04:01 +0100
Message-Id: <1358899442-3110-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1358899442-3110-1-git-send-email-fweisbec@gmail.com>
References: <1358899442-3110-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do some ground preparatory work before adding guest_enter()
and guest_exit() context tracking callbacks. Those will
be later used to read the guest cputime safely when we
run in full dynticks mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kvm_host.h |   39 ++++++++++++++++++++++++++++++---------
 include/linux/vtime.h    |    2 --
 kernel/sched/cputime.c   |   10 ----------
 3 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c497ab..4fe2396 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -22,6 +22,7 @@
 #include <linux/rcupdate.h>
 #include <linux/ratelimit.h>
 #include <linux/err.h>
+#include <linux/irqflags.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -740,15 +741,36 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 }
 #endif /* CONFIG_IOMMU_API */
 
-static inline void kvm_guest_enter(void)
+static inline void guest_enter(void)
 {
-	BUG_ON(preemptible());
 	/*
 	 * This is running in ioctl context so we can avoid
 	 * the call to vtime_account() with its unnecessary idle check.
 	 */
-	vtime_account_system_irqsafe(current);
+	vtime_account_system(current);
 	current->flags |= PF_VCPU;
+}
+
+static inline void guest_exit(void)
+{
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags &= ~PF_VCPU;
+}
+
+static inline void kvm_guest_enter(void)
+{
+	unsigned long flags;
+
+	BUG_ON(preemptible());
+
+	local_irq_save(flags);
+	guest_enter();
+	local_irq_restore(flags);
+
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
 	 * is very similar to exiting to userspase from rcu point of view. In
@@ -761,12 +783,11 @@ static inline void kvm_guest_enter(void)
 
 static inline void kvm_guest_exit(void)
 {
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
-	vtime_account_system_irqsafe(current);
-	current->flags &= ~PF_VCPU;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	guest_exit();
+	local_irq_restore(flags);
 }
 
 /*
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 5368af9..bb50c3c 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -6,7 +6,6 @@ struct task_struct;
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void vtime_task_switch(struct task_struct *prev);
 extern void vtime_account_system(struct task_struct *tsk);
-extern void vtime_account_system_irqsafe(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
 extern void vtime_account_user(struct task_struct *tsk);
 extern void vtime_account(struct task_struct *tsk);
@@ -20,7 +19,6 @@ static inline bool vtime_accounting_enabled(void) { return true; }
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
-static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
 static inline void vtime_account_user(struct task_struct *tsk) { }
 static inline void vtime_account(struct task_struct *tsk) { }
 static inline bool vtime_accounting_enabled(void) { return false; }
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index c533dea..a44ecdf 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -465,16 +465,6 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 	*st = cputime.stime;
 }
 
-void vtime_account_system_irqsafe(struct task_struct *tsk)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	vtime_account_system(tsk);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(vtime_account_system_irqsafe);
-
 #ifndef __ARCH_HAS_VTIME_TASK_SWITCH
 void vtime_task_switch(struct task_struct *prev)
 {
-- 
1.7.5.4

