Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaDBNaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:30:10 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:15279 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859AbaDBN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:29:14 -0400
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
Subject: [PATCH v8 09/10] pvqspinlock, x86: Enable qspinlock PV support for KVM
Date: Wed,  2 Apr 2014 09:27:38 -0400
Message-Id: <1396445259-27670-10-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary KVM specific code to allow KVM to support
the sleeping and CPU kicking operations needed by the queue spinlock PV
code.

Two KVM guests of 20 CPU cores (2 nodes) were created for performance
testing in one of the following three configurations:
 1) Only 1 VM is active
 2) Both VMs are active and they share the same 20 physical CPUs
   (200% overcommit)
 3) Both VMs are active and they shares 30 physical CPUs (10 delicated
    and 10 shared - 133% overcommit)

The tests run included the disk workload of the AIM7 benchmark
on both ext4 and xfs RAM disks at 3000 users on a 3.14-rc8 based
kernel. A kernel compilation test was also run and the execution
times were noted. With to VMs running, the "idle=poll" kernel option
was added to simulate a busy guest. The entry "unfair + PV qspinlock"
below means that both the unfair lock and PV spinlock configuration
options were turned on.

  		AIM7 XFS Disk Test (no overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		2380952	   7.56	     107.34	  5.65
  qspinlock		2400000	   7.50	     105.68	  5.68
  PV qspinlock		2390438	   7.53	     102.52       5.48
  unfair qspinloc	2432432	   7.40	     105.30	  5.72
  unfair + PV qspinlock	2340702	   7.69	     107.67	  5.65

  		AIM7 XFS Disk Test (133% overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		1137081	  15.83	     213.29	 13.03
  qspinlock		1132075	  15.90      221.92	 13.92
  PV qspinlock		1097561	  16.40	     229.30      13.72
  unfair qspinloc	1138520	  15.81	     220.13	 13.10
  unfair + PV qspinlock	1118707	  16.09	     225.08	 13.25

  		AIM7 XFS Disk Test (200% overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		577108	  31.19	     447.10	 26.60
  qspinlock		117493	 153.20	    1006.06	 59.60
  PV qspinlock		568361	  31.67	     402.69      25.08
  unfair qspinloc	604432	  29.78	     402.20	 26.17
  unfair + PV qspinlock	629591	  28.59	     364.56	 23.74

  		AIM7 EXT4 Disk Test (no overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		1284797	  14.01	     172.90	  5.59
  qspinlock		1169591	  15.39	     177.13	  5.62
  PV qspinlock		1243953	  14.47	     179.86       5.34
  unfair qspinloc	1474201	  12.21	     145.08	  5.50
  unfair + PV qspinlock	1486375	  12.11	     146.55	  5.58

  		AIM7 EXT4 Disk Test (133% overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		126130	 142.71	    2534.69	 18.23
  qspinlock		119792	 150.26	    2767.86	 24.32
  PV qspinlock		116928	 153.94	    2804.52      20.21
  unfair qspinloc	877192	  20.52	     262.69	 10.80
  unfair + PV qspinlock	740741	  24.30	     328.64	 12.29

  		AIM7 EXT4 Disk Test (200% overcommit)
  kernel		 JPM	Real Time   Sys Time	Usr Time
  -----			 ---	---------   --------	--------
  PV ticketlock		100880	 178.43	    3108.33	 35.78
  qspinlock		 54995	 327.30	    5023.58	 54.73
  PV qspinlock		104100	 172.91	    2947.03      33.69
  unfair qspinloc	390033	  46.15	     612.80	 27.08
  unfair + PV qspinlock	357640	  50.33	     670.15	 29.22

The kernel build test (make -j 20) results are as follows:

  			(no overcommit)
  kernel		Real Time   Sys Time	Usr Time
  -----			---------   --------	--------
  PV ticketlock		8m42.284s   17m2.638s	117m6.862s
  qspinlock		8m56.907s   16m34.614s  117m28.756s
  PV qspinlock		8m30.477s   16m51.550s  117m28.743s
  unfair qspinlock	9m5.152s    16m48.353s  117m50.292s
  unfair + PV qspinlock	8m41.729s   16m51.905s  117m20.809s

  			(133% overcommit)
  kernel		Real Time   Sys Time	Usr Time
  -----			---------   --------	--------
  PV ticketlock		13m8.703s   32m14.437s  187m34.016s
  qspinlock		13m3.169s   32m9.641s   186m40.085s
  PV qspinlock		12m53.279s  32m16.687s  186m32.541s
  unfair qspinlock	12m56.707s  31m55.581s  187m45.494s
  unfair + PV qspinlock	12m46.688s  32m5.035s   186m15.042s

  			(200% overcommit)
  kernel		Real Time   Sys Time	Usr Time
  -----			---------   --------	--------
  PV ticketlock		20m9.236s   41m35.786s  283m56.333s
  qspinlock		26m41.294s  74m55.585s	346m31.981s
  PV qspinlock		20m14.312s  41m34.621s  283m50.145s
  unfair qspinlock	19m57.384s  40m40.880s	282m54.679s
  unfair + PV qspinlock	20m17.564s  41m33.687s	283m1.035s

In term of spinlock contention, the ordering of the 3 workloads are:

    kernel build < AIM7 disk xfs < AIM7 disk ext4

With no overcommit, the PV code and unfair lock doesn't differ that
much from the plain qspinlock with the exception of the AIM7 disk
ext4 test which has high spinlock contention.

With 133% overcommit, there were some performance benefit with PV
and unfair lock. With heavy spinlock contention in the ext4 test,
unfair lock performed much better than the rests.

With 200% overcommit, we saw even more benefit with PV and unfair
locks.  Again unfair lock provided a much better performance boost
with heavy spinlock contention.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/kernel/kvm.c |  111 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/Kconfig.locks  |    2 +-
 2 files changed, 112 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8e646a7..7d97e58 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -568,6 +568,7 @@ static void kvm_kick_cpu(int cpu)
 	kvm_hypercall2(KVM_HC_KICK_CPU, flags, apicid);
 }
 
+#ifndef CONFIG_QUEUE_SPINLOCK
 enum kvm_contention_stat {
 	TAKEN_SLOW,
 	TAKEN_SLOW_PICKUP,
@@ -795,6 +796,110 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 		}
 	}
 }
+#else /* !CONFIG_QUEUE_SPINLOCK */
+
+#ifdef CONFIG_KVM_DEBUG_FS
+static struct dentry *d_spin_debug;
+static struct dentry *d_kvm_debug;
+static u32 kick_stats;		/* CPU kick count		*/
+static u32 kick_nohalt_stats;	/* Kick but not halt count	*/
+static u32 halt_qhead_stats;	/* Queue head halting count	*/
+static u32 halt_qnode_stats;	/* Queue node halting count	*/
+static u32 wake_kick_stats;	/* Wakeup by kicking count	*/
+static u32 wake_spur_stats;	/* Spurious wakeup count	*/
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
+	return 0;
+}
+
+static inline void kvm_kick_stats(void)
+{
+	add_smp(&kick_stats, 1);
+}
+
+static inline void kvm_halt_stats(enum pv_lock_stats type)
+{
+	if (type == PV_HALT_QHEAD)
+		add_smp(&halt_qhead_stats, 1);
+	else /* type == PV_HALT_QNODE */
+		add_smp(&halt_qnode_stats, 1);
+}
+
+static inline void kvm_lock_stats(enum pv_lock_stats type)
+{
+	if (type == PV_WAKE_KICKED)
+		add_smp(&wake_kick_stats, 1);
+	else if (type == PV_WAKE_SPURIOUS)
+		add_smp(&wake_spur_stats, 1);
+	else /* type == PV_KICK_NOHALT */
+		add_smp(&kick_nohalt_stats, 1);
+}
+
+fs_initcall(kvm_spinlock_debugfs);
+
+#else /* CONFIG_KVM_DEBUG_FS */
+static inline void kvm_kick_stats(void)
+{
+}
+
+static inline void kvm_halt_stats(enum pv_lock_stats type)
+{
+}
+
+static inline void kvm_lock_stats(enum pv_lock_stats type)
+{
+}
+#endif /* CONFIG_KVM_DEBUG_FS */
+
+static void kvm_kick_cpu_stats(int cpu)
+{
+	kvm_kick_cpu(cpu);
+	kvm_kick_stats();
+}
+
+/*
+ * Halt the current CPU & release it back to the host
+ */
+static void kvm_hibernate(enum pv_lock_stats type)
+{
+	unsigned long flags;
+
+	if (in_nmi())
+		return;
+
+	kvm_halt_stats(type);
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+	if (arch_irqs_disabled_flags(flags))
+		halt();
+	else
+		safe_halt();
+	local_irq_restore(flags);
+}
+#endif /* !CONFIG_QUEUE_SPINLOCK */
 
 /*
  * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
@@ -807,8 +912,14 @@ void __init kvm_spinlock_init(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return;
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+	pv_lock_ops.kick_cpu = kvm_kick_cpu_stats;
+	pv_lock_ops.hibernate = kvm_hibernate;
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

