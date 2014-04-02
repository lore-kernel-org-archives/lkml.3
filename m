Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaDBN3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:29:34 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:47040 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaDBN32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:29:28 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v8 10/10] pvqspinlock, x86: Enable qspinlock PV support for XEN
Date: Wed,  2 Apr 2014 09:27:39 -0400
Message-Id: <1396445259-27670-11-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary KVM specific code to allow XEN to support
the sleeping and CPU kicking operations needed by the queue spinlock PV
code.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/xen/spinlock.c |  119 +++++++++++++++++++++++++++++++++++++++++++++--
 kernel/Kconfig.locks    |    2 +-
 2 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 06f4a64..6bbe798 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -17,6 +17,12 @@
 #include "xen-ops.h"
 #include "debugfs.h"
 
+static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+static DEFINE_PER_CPU(char *, irq_name);
+static bool xen_pvspin = true;
+
+#ifndef CONFIG_QUEUE_SPINLOCK
+
 enum xen_contention_stat {
 	TAKEN_SLOW,
 	TAKEN_SLOW_PICKUP,
@@ -100,12 +106,9 @@ struct xen_lock_waiting {
 	__ticket_t want;
 };
 
-static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
-static DEFINE_PER_CPU(char *, irq_name);
 static DEFINE_PER_CPU(struct xen_lock_waiting, lock_waiting);
 static cpumask_t waiting_cpus;
 
-static bool xen_pvspin = true;
 __visible void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	int irq = __this_cpu_read(lock_kicker_irq);
@@ -213,6 +216,94 @@ static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 	}
 }
 
+#else /* CONFIG_QUEUE_SPINLOCK */
+
+#ifdef CONFIG_XEN_DEBUG_FS
+static u32 kick_stats;			/* CPU kick count		*/
+static u32 kick_nohalt_stats;		/* Kick but not halt count	*/
+static u32 halt_qhead_stats;		/* Queue head halting count	*/
+static u32 halt_qnode_stats;		/* Queue node halting count	*/
+static u32 wake_kick_stats;		/* Wakeup by kicking count	*/
+static u32 wake_spur_stats;		/* Spurious wakeup count	*/
+
+static inline void xen_kick_stats(void)
+{
+	add_smp(&kick_stats, 1);
+}
+
+static inline void xen_halt_stats(enum pv_lock_stats type)
+{
+	if (type == PV_HALT_QHEAD)
+		add_smp(&halt_qhead_stats, 1);
+	else /* type == PV_HALT_QNODE */
+		add_smp(&halt_qnode_stats, 1);
+}
+
+static inline void xen_lock_stats(enum pv_lock_stats type)
+{
+	if (type == PV_WAKE_KICKED)
+		add_smp(&wake_kick_stats, 1);
+	else if (type == PV_WAKE_SPURIOUS)
+		add_smp(&wake_spur_stats, 1);
+	else /* type == PV_KICK_NOHALT */
+		add_smp(&kick_nohalt_stats, 1);
+}
+#else /* CONFIG_XEN_DEBUG_FS */
+static inline void xen_kick_stats(void)
+{
+}
+
+static inline void xen_halt_stats(enum pv_lock_stats type)
+{
+}
+
+static inline void xen_lock_stats(enum pv_lock_stats type)
+{
+}
+#endif /* CONFIG_XEN_DEBUG_FS */
+
+static void xen_kick_cpu(int cpu)
+{
+	xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
+	xen_kick_stats();
+}
+
+/*
+ * Halt the current CPU & release it back to the host
+ */
+static void xen_hibernate(enum pv_lock_stats type)
+{
+	int irq = __this_cpu_read(lock_kicker_irq);
+	unsigned long flags;
+
+	/* If kicker interrupts not initialized yet, just spin */
+	if (irq == -1)
+		return;
+
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+
+	xen_halt_stats(type);
+	/* clear pending */
+	xen_clear_irq_pending(irq);
+
+	/* Allow interrupts while blocked */
+	local_irq_restore(flags);
+
+	/*
+	 * If an interrupt happens here, it will leave the wakeup irq
+	 * pending, which will cause xen_poll_irq() to return
+	 * immediately.
+	 */
+
+	/* Block until irq becomes pending (or perhaps a spurious wakeup) */
+	xen_poll_irq(irq);
+}
+#endif /* CONFIG_QUEUE_SPINLOCK */
+
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
 	BUG();
@@ -258,7 +349,6 @@ void xen_uninit_lock_cpu(int cpu)
 	per_cpu(irq_name, cpu) = NULL;
 }
 
-
 /*
  * Our init of PV spinlocks is split in two init functions due to us
  * using paravirt patching and jump labels patching and having to do
@@ -275,8 +365,14 @@ void __init xen_init_spinlocks(void)
 		return;
 	}
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+	pv_lock_ops.kick_cpu = xen_kick_cpu;
+	pv_lock_ops.hibernate = xen_hibernate;
+	pv_lock_ops.lockstat = xen_lock_stats;
+#else
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
+#endif
 }
 
 /*
@@ -318,6 +414,7 @@ static int __init xen_spinlock_debugfs(void)
 
 	d_spin_debug = debugfs_create_dir("spinlocks", d_xen);
 
+#ifndef CONFIG_QUEUE_SPINLOCK
 	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
 
 	debugfs_create_u32("taken_slow", 0444, d_spin_debug,
@@ -337,7 +434,19 @@ static int __init xen_spinlock_debugfs(void)
 
 	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
 				spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
-
+#else /* CONFIG_QUEUE_SPINLOCK */
+	debugfs_create_u32("kick_stats", 0644, d_spin_debug, &kick_stats);
+	debugfs_create_u32("kick_nohalt_stats",
+			   0644, d_spin_debug, &kick_nohalt_stats);
+	debugfs_create_u32("halt_qhead_stats",
+			   0644, d_spin_debug, &halt_qhead_stats);
+	debugfs_create_u32("halt_qnode_stats",
+			   0644, d_spin_debug, &halt_qnode_stats);
+	debugfs_create_u32("wake_kick_stats",
+			   0644, d_spin_debug, &wake_kick_stats);
+	debugfs_create_u32("wake_spur_stats",
+			   0644, d_spin_debug, &wake_spur_stats);
+#endif /* CONFIG_QUEUE_SPINLOCK */
 	return 0;
 }
 fs_initcall(xen_spinlock_debugfs);
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index a70fdeb..451e392 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -229,4 +229,4 @@ config ARCH_USE_QUEUE_SPINLOCK
 
 config QUEUE_SPINLOCK
 	def_bool y if ARCH_USE_QUEUE_SPINLOCK
-	depends on SMP && (!PARAVIRT_SPINLOCKS || !XEN)
+	depends on SMP
-- 
1.7.1

