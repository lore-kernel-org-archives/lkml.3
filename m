Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaDQPHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:07:06 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43552 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaDQPFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:05:02 -0400
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
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v9 18/19] pvqspinlock, x86: Enable PV qspinlock PV for KVM
Date: Thu, 17 Apr 2014 11:04:10 -0400
Message-Id: <1397747051-15401-19-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
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
 3) Both VMs are active and they shares 30 physical CPUs (10 delicated
    and 10 shared - 133% overcommit)

The tests run included the disk workload of the AIM7 benchmark on both
ext4 and xfs RAM disks at 3000 users on a 3.15-rc1 based kernel. The
"ebizzy -m" test was was also run and its performance data were
recorded.  With two VMs running, the "idle=poll" kernel option was
added to simulate a busy guest. The entry "unfair + PV qspinlock"
below means that both the unfair lock and PV spinlock configuration
options were turned on.

  		AIM7 XFS Disk Test (no overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		2489626	   7.23	     101.08	  5.30
  qspinlock		2531646	   7.11	     100.75	  5.43
  PV qspinlock		2500000	   7.20	     101.94       5.40
  unfair qspinlock	2549575	   7.06	      99.81	  5.35
  unfair + PV qspinlock	2486188	   7.24	     101.55	  5.51

  		AIM7 XFS Disk Test (133% overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		1114551	  16.15	     220.17	 10.75
  qspinlock		1159047	  15.53      216.60	 10.24
  PV qspinlock		1170351	  15.38	     216.16      11.03
  unfair qspinlock	1188119	  15.15	     209.37	 10.82
  unfair + PV qspinlock	1178782	  15.27	     211.37	 11.25

  		AIM7 XFS Disk Test (200% overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		587467	  30.64	     444.95	 11.92
  qspinlock		593276	  30.34	     439.39	 14.59
  PV qspinlock		601403	  29.93	     426.04      14.49
  unfair qspinlock	654070	  27.52	     400.82	 10.86
  unfair + PV qspinlock	614334	  29.30	     393.38	 28.56

  		AIM7 EXT4 Disk Test (no overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		2002225	   9.07	     105.62	  5.43
  qspinlock		2006689	   8.97	     105.65	  5.26
  PV qspinlock		2002225	   8.99	     103.19       5.19
  unfair qspinlock	1988950	   9.05	     103.81	  5.03
  unfair + PV qspinlock	1993355	   9.03	     107.99	  5.68

  		AIM7 EXT4 Disk Test (133% overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		 987383	  18.23	     221.63	  8.89
  qspinlock		1050788	  17.13	     206.87	  8.35
  PV qspinlock		1058823	  17.00	     205.22       9.18
  unfair qspinlock	1161290	  15.50	     184.22	  8.84
  unfair + PV qspinlock	1122894	  16.03	     195.86	  9.34

  		AIM7 EXT4 Disk Test (200% overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		420757	  42.78	     565.96	  5.84
  qspinlock		427452	  42.11	     543.08	 11.12
  PV qspinlock		420659	  42.79	     548.30      10.56
  unfair qspinlock	504909	  35.65	     466.71	  5.38
  unfair + PV qspinlock	500974	  35.93	     469.02	  6.77

		EBIZZY-M Test (no overcommit)
  kernel		Rec/s	Real Time   Sys Time	Usr Time
  -----			-----	---------   --------	--------
  PV ticketlock		1230	  10.00	     88.34	  1.42
  qspinlock		1212	  10.00	     68.25	  1.47
  PV qspinlock		1265	  10.00	     91.50	  1.41
  unfair qspinlock	1304	  10.00	     77.94	  1.49
  unfair + PV qspinlock	1445	  10.00	     75.45	  1.68

		EBIZZY-M Test (133% overcommit)
  kernel		Rec/s	Real Time   Sys Time	Usr Time
  -----			-----	---------   --------	--------
  PV ticketlock		 467	  10.00	     88.16	  0.73
  qspinlock		 463	  10.00	     89.44	  0.78
  PV qspinlock		 441	  10.00	     95.10	  0.74
  unfair qspinlock	1233	  10.00	     35.76	  1.76
  unfair + PV qspinlock	1555	  10.00	     32.12	  1.96

		EBIZZY-M Test (200% overcommit)
  kernel		Rec/s	Real Time   Sys Time	Usr Time
  -----			-----	---------   --------	--------
  PV ticketlock		 263	  10.00	     84.48	  4.27
  qspinlock		 226	  10.00	     87.74	  2.02
  PV qspinlock		 253	  10.00	     98.28	  2.63
  unfair qspinlock	 338	  10.00	     61.15	  1.68
  unfair + PV qspinlock	 346	  10.00	     60.47	  3.31

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
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

