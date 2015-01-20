Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbbATUNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:13:53 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:52953 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbbATUNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:13:45 -0500
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
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v14 10/11] pvqspinlock, x86: Enable PV qspinlock for KVM
Date: Tue, 20 Jan 2015 15:12:34 -0500
Message-Id: <1421784755-21945-11-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com>
References: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com>
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

The tests run included the disk workload of the AIM7 benchmark on
both ext4 and xfs RAM disks at 3000 users on a 3.17 based kernel. The
"ebizzy -m" test and futextest was was also run and its performance
data were recorded.  With two VMs running, the "idle=poll" kernel
option was added to simulate a busy guest. If PV qspinlock is not
enabled, unfairlock will be used automically in a guest.

                AIM7 XFS Disk Test (no overcommit)
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  PV ticketlock         2542373    7.08       98.95       5.44
  PV qspinlock          2549575    7.06       98.63       5.40
  unfairlock	        2616279    6.91       97.05       5.42

                AIM7 XFS Disk Test (200% overcommit)
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  PV ticketlock         644468    27.93      415.22       6.33
  PV qspinlock          645624    27.88      419.84       0.39
  unfairlock	        695518    25.88      377.40       4.09

                AIM7 EXT4 Disk Test (no overcommit)
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  PV ticketlock         1995565    9.02      103.67       5.76
  PV qspinlock          2011173    8.95      102.15       5.40
  unfairlock	        2066590    8.71       98.13       5.46

                AIM7 EXT4 Disk Test (200% overcommit)
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  PV ticketlock         478341    37.63      495.81      30.78
  PV qspinlock          474058    37.97      475.74      30.95
  unfairlock	        560224    32.13      398.43      26.27

For the AIM7 disk workload, both PV ticketlock and qspinlock have
about the same performance. The unfairlock performs slightly better
than the PV lock.

                EBIZZY-m Test (no overcommit)
  kernel                Rec/s   Real Time   Sys Time    Usr Time
  -----                 -----   ---------   --------    --------
  PV ticketlock         3255      10.00       60.65       3.62
  PV qspinlock          3318      10.00       54.27       3.60
  unfairlock	        2833      10.00       26.66       3.09

                EBIZZY-m Test (200% overcommit)
  kernel                Rec/s   Real Time   Sys Time    Usr Time
  -----                 -----   ---------   --------    --------
  PV ticketlock          841      10.00       71.03       2.37
  PV qspinlock           834      10.00       68.27       2.39
  unfairlock	         865      10.00       27.08       1.51

  futextest (no overcommit)
  kernel               kops/s
  -----                ------
  PV ticketlock        11523
  PV qspinlock         12328
  unfairlock	        9478

  futextest (200% overcommit)
  kernel               kops/s
  -----                ------
  PV ticketlock         7276
  PV qspinlock          7095
  unfairlock	        5614

The ebizzy and futextest have much higher spinlock contention than

Additional kernel build tests had been done on an 8-socket 32-core
Westmere-EX system (HT off) with an overcommitted KVM PV guest of 60
vCPUs with no NUMA awareness. The kernels is 3.18-2 based. The build
times of a 3.17 kernel with "make -j 60" are shown in the table below:

  kernel	     Elapsed time	User time	Sys time
  ------	    ------------	---------	--------
  PV ticketlock		16m57s		219m17s		189m30s
  PV qspinlock		14m47s		188m50s		177m14s

There is a 13% reduction in build time. This is probably caused
by the fact that contended qspinlock produces much less cacheline
contention than contended ticket spinlock and the test system is an
8-socket server.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/kernel/kvm.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/Kconfig.locks  |    2 +-
 2 files changed, 143 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 2f1bcc9..29a312d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -575,7 +575,7 @@ arch_initcall(activate_jump_labels);
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 /* Kick a cpu by its apicid. Used to wake up a halted vcpu */
-static void kvm_kick_cpu(int cpu)
+void kvm_kick_cpu(int cpu)
 {
 	int apicid;
 	unsigned long flags = 0;
@@ -583,7 +583,9 @@ static void kvm_kick_cpu(int cpu)
 	apicid = per_cpu(x86_cpu_to_apicid, cpu);
 	kvm_hypercall2(KVM_HC_KICK_CPU, flags, apicid);
 }
+PV_CALLEE_SAVE_REGS_THUNK(kvm_kick_cpu);
 
+#ifndef CONFIG_QUEUE_SPINLOCK
 enum kvm_contention_stat {
 	TAKEN_SLOW,
 	TAKEN_SLOW_PICKUP,
@@ -811,6 +813,137 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
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
+void kvm_lock_stats(int stat_types)
+{
+	if (stat_types & PV_LOCKSTAT_WAKE_KICKED)
+		add_smp(&wake_kick_stats, 1);
+	if (stat_types & PV_LOCKSTAT_WAKE_SPURIOUS)
+		add_smp(&wake_spur_stats, 1);
+	if (stat_types & PV_LOCKSTAT_KICK_NOHALT)
+		add_smp(&kick_nohlt_stats, 1);
+	if (stat_types & PV_LOCKSTAT_HALT_QHEAD)
+		add_smp(&halt_qhead_stats, 1);
+	if (stat_types & PV_LOCKSTAT_HALT_QNODE)
+		add_smp(&halt_qnode_stats, 1);
+	if (stat_types & PV_LOCKSTAT_HALT_ABORT)
+		add_smp(&halt_abort_stats, 1);
+}
+PV_CALLEE_SAVE_REGS_THUNK(kvm_lock_stats);
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
+static inline void kvm_lock_stats(int stat_types)
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
+ * Halt the current CPU & release it back to the host unless the given
+ * byte pointer has value different from the given one.
+ *
+ * Return 0 if halted, -1 otherwise.
+ */
+int kvm_halt_cpu(u8 *byte, u8 val)
+{
+	unsigned long flags;
+	int ret = -1;
+	u64 start = (u64)-1;
+
+	if (in_nmi())
+		return ret;
+
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+	/*
+	 * Don't halt if the content of the given byte address differs from
+	 * the expected value. A read memory barrier is added to make sure that
+	 * the latest value of the byte address is fetched.
+	 */
+	smp_rmb();
+	if (*byte != val) {
+		kvm_lock_stats(PV_LOCKSTAT_HALT_ABORT);
+		goto out;
+	}
+	start = spin_time_start();
+	if (arch_irqs_disabled_flags(flags))
+		halt();
+	else
+		safe_halt();
+	ret = 0;
+out:
+	local_irq_restore(flags);
+	if (start != (u64)-1)
+		spin_time_accum_blocked(start);
+	return ret;
+}
+PV_CALLEE_SAVE_REGS_THUNK(kvm_halt_cpu);
+#endif /* !CONFIG_QUEUE_SPINLOCK */
 
 /*
  * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
@@ -823,8 +956,16 @@ void __init kvm_spinlock_init(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return;
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+	pv_lock_ops.kick_cpu = kvm_kick_cpu;
+	pv_lock_ops.lockwait = PV_CALLEE_SAVE(kvm_halt_cpu);
+#ifdef CONFIG_KVM_DEBUG_FS
+	pv_lock_ops.lockstat = PV_CALLEE_SAVE(kvm_lock_stats);
+#endif
+#else
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
 	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+#endif
 }
 
 static __init int kvm_spinlock_init_jump(void)
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 9215fab..57301de 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -236,7 +236,7 @@ config ARCH_USE_QUEUE_SPINLOCK
 
 config QUEUE_SPINLOCK
 	def_bool y if ARCH_USE_QUEUE_SPINLOCK
-	depends on SMP && !PARAVIRT_SPINLOCKS
+	depends on SMP && (!PARAVIRT_SPINLOCKS || !XEN)
 
 config ARCH_USE_QUEUE_RWLOCK
 	bool
-- 
1.7.1

