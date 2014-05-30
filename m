Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbaE3PrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:47:06 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:3863 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026AbaE3Pq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:46:58 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v11 15/16] pvqspinlock, x86: Enable PV qspinlock PV for KVM
Date: Fri, 30 May 2014 11:44:01 -0400
Message-Id: <1401464642-33890-16-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary KVM specific code to allow KVM to
support the CPU halting and kicking operations needed by the queue
spinlock PV code.

Two KVM guests of 20 CPU cores (2 nodes) were created for performance
testing in one of the following three configurations:
 1) Only 1 VM is active
 2) Both VMs are active and they share the same 20 physical CPUs
   (200% overcommit)

The tests run included the disk workload of the AIM7 benchmark on both
ext4 and xfs RAM disks at 3000 users on a 3.15-rc7 based kernel. The
"ebizzy -m" test was was also run and its performance data were
recorded.  With two VMs running, the "idle=poll" kernel option was
added to simulate a busy guest. The entry "unfair + PV qspinlock"
below means that both the unfair lock and PV spinlock configuration
options were turned on.

                AIM7 XFS Disk Test (no overcommit)
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  PV ticketlock         2521008    7.24      101.02       5.24
  qspinlock             2571429    7.00       99.10       5.49
  PV qspinlock          2535211    7.10      100.32       5.45
  unfair qspinlock      2571429    7.00       99.25       5.40
  unfair + PV qspinlock 2549575    7.06       99.81       5.31

                AIM7 XFS Disk Test (200% overcommit)
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  PV ticketlock         768902    23.41      341.71       3.07
  qspinlock             784656    22.94      346.22       2.90
  PV qspinlock          773861    23.26      352.47       2.30
  unfair qspinlock      835655    21.54      316.52       1.57
  unfair + PV qspinlock 797165    22.58      323.95       3.58

                AIM7 EXT4 Disk Test (no overcommit)
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  PV ticketlock         1956522    9.20      106.58       5.35
  qspinlock             1995565    9.02      103.19       5.37
  PV qspinlock          1958651    9.19      106.57       5.30
  unfair qspinlock      2022472    8.90      103.58       5.37
  unfair + PV qspinlock 1991150    9.04      104.41       5.46

                AIM7 EXT4 Disk Test (200% overcommit)
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  PV ticketlock         576553    31.22      407.44       1.51
  qspinlock             609550    29.53      407.14       1.69
  PV qspinlock          592105    30.40      410.51       1.67
  unfair qspinlock      672897    26.75      359.78       1.66
  unfair + PV qspinlock 670391    26.85      357.09       0.63

                EBIZZY-M Test (no overcommit)
  kernel                Rec/s   Real Time   Sys Time    Usr Time
  -----                 -----   ---------   --------    --------
  PV ticketlock         1328      10.00      82.82        1.46
  qspinlock             1679      10.00      65.37        1.80
  PV qspinlock          1470      10.00      75.54        1.54
  unfair qspinlock      1518      10.00      70.80        1.71
  unfair + PV qspinlock 1585      10.00      69.02        1.76

                EBIZZY-M Test (200% overcommit)
  kernel                Rec/s   Real Time   Sys Time    Usr Time
  -----                 -----   ---------   --------    --------
  PV ticketlock          453      10.00      77.11        0.00
  qspinlock              459      10.00      77.50        0.00
  PV qspinlock           402      10.00      91.55        0.00
  unfair qspinlock       570      10.00      62.98        0.00
  unfair + PV qspinlock  586      10.00      59.68        0.00

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Tested-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/kernel/kvm.c |  135 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/Kconfig.locks  |    2 +-
 2 files changed, 136 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7ab8ab3..eef427b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -567,6 +567,7 @@ static void kvm_kick_cpu(int cpu)
 	kvm_hypercall2(KVM_HC_KICK_CPU, flags, apicid);
 }
 
+#ifndef CONFIG_QUEUE_SPINLOCK
 enum kvm_contention_stat {
 	TAKEN_SLOW,
 	TAKEN_SLOW_PICKUP,
@@ -794,6 +795,134 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 		}
 	}
 }
+#else /* !CONFIG_QUEUE_SPINLOCK */
+
+#ifdef CONFIG_KVM_DEBUG_FS
+static struct dentry *d_spin_debug;
+static struct dentry *d_kvm_debug;
+static u32 kick_nohlt_stats;	/* Kick but not halt count	*/
+static u32 halt_qhead_stats;	/* Queue head halting count	*/
+static u32 halt_qnode_stats;	/* Queue node halting count	*/
+static u32 halt_abort_stats;	/* Halting abort count		*/
+static u32 wake_kick_stats;	/* Wakeup by kicking count	*/
+static u32 wake_spur_stats;	/* Spurious wakeup count	*/
+static u64 time_blocked;	/* Total blocking time		*/
+
+static int __init kvm_spinlock_debugfs(void)
+{
+	d_kvm_debug = debugfs_create_dir("kvm-guest", NULL);
+	if (!d_kvm_debug) {
+		printk(KERN_WARNING
+		       "Could not create 'kvm' debugfs directory\n");
+		return -ENOMEM;
+	}
+	d_spin_debug = debugfs_create_dir("spinlocks", d_kvm_debug);
+
+	debugfs_create_u32("kick_nohlt_stats",
+			   0644, d_spin_debug, &kick_nohlt_stats);
+	debugfs_create_u32("halt_qhead_stats",
+			   0644, d_spin_debug, &halt_qhead_stats);
+	debugfs_create_u32("halt_qnode_stats",
+			   0644, d_spin_debug, &halt_qnode_stats);
+	debugfs_create_u32("halt_abort_stats",
+			   0644, d_spin_debug, &halt_abort_stats);
+	debugfs_create_u32("wake_kick_stats",
+			   0644, d_spin_debug, &wake_kick_stats);
+	debugfs_create_u32("wake_spur_stats",
+			   0644, d_spin_debug, &wake_spur_stats);
+	debugfs_create_u64("time_blocked",
+			   0644, d_spin_debug, &time_blocked);
+	return 0;
+}
+
+static inline void kvm_halt_stats(enum pv_lock_stats type)
+{
+	if (type == PV_HALT_QHEAD)
+		add_smp(&halt_qhead_stats, 1);
+	else if (type == PV_HALT_QNODE)
+		add_smp(&halt_qnode_stats, 1);
+	else /* type == PV_HALT_ABORT */
+		add_smp(&halt_abort_stats, 1);
+}
+
+static inline void kvm_lock_stats(enum pv_lock_stats type)
+{
+	if (type == PV_WAKE_KICKED)
+		add_smp(&wake_kick_stats, 1);
+	else if (type == PV_WAKE_SPURIOUS)
+		add_smp(&wake_spur_stats, 1);
+	else /* type == PV_KICK_NOHALT */
+		add_smp(&kick_nohlt_stats, 1);
+}
+
+static inline u64 spin_time_start(void)
+{
+	return sched_clock();
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+	u64 delta;
+
+	delta = sched_clock() - start;
+	add_smp(&time_blocked, delta);
+}
+
+fs_initcall(kvm_spinlock_debugfs);
+
+#else /* CONFIG_KVM_DEBUG_FS */
+static inline void kvm_halt_stats(enum pv_lock_stats type)
+{
+}
+
+static inline void kvm_lock_stats(enum pv_lock_stats type)
+{
+}
+
+static inline u64 spin_time_start(void)
+{
+	return 0;
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+}
+#endif /* CONFIG_KVM_DEBUG_FS */
+
+/*
+ * Halt the current CPU & release it back to the host
+ */
+static void kvm_halt_cpu(enum pv_lock_stats type, s8 *state, s8 sval)
+{
+	unsigned long flags;
+	u64 start;
+
+	if (in_nmi())
+		return;
+
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+	/*
+	 * Don't halt if the CPU state has been changed.
+	 */
+	if (ACCESS_ONCE(*state) != sval) {
+		kvm_halt_stats(PV_HALT_ABORT);
+		goto out;
+	}
+	start = spin_time_start();
+	kvm_halt_stats(type);
+	if (arch_irqs_disabled_flags(flags))
+		halt();
+	else
+		safe_halt();
+	spin_time_accum_blocked(start);
+out:
+	local_irq_restore(flags);
+}
+#endif /* !CONFIG_QUEUE_SPINLOCK */
 
 /*
  * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
@@ -806,8 +935,14 @@ void __init kvm_spinlock_init(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return;
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+	pv_lock_ops.kick_cpu = kvm_kick_cpu;
+	pv_lock_ops.halt_cpu = kvm_halt_cpu;
+	pv_lock_ops.lockstat = kvm_lock_stats;
+#else
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
 	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+#endif
 }
 
 static __init int kvm_spinlock_init_jump(void)
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index f185584..a70fdeb 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -229,4 +229,4 @@ config ARCH_USE_QUEUE_SPINLOCK
 
 config QUEUE_SPINLOCK
 	def_bool y if ARCH_USE_QUEUE_SPINLOCK
-	depends on SMP && !PARAVIRT_SPINLOCKS
+	depends on SMP && (!PARAVIRT_SPINLOCKS || !XEN)
-- 
1.7.1

