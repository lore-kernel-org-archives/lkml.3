Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3HLR2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:28:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3HLR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:28:05 -0400
Date: Mon, 12 Aug 2013 10:27:41 -0700
From: tip-bot for Srivatsa Vaddagiri <tipbot@zytor.com>
Message-ID: <tip-f9021f7fd9c8c8101c90b901053f99bfd0288021@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, gleb@redhat.com, raghavendra.kt@linux.vnet.ibm.com,
        suzuki@in.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, gleb@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, suzuki@in.ibm.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130810193849.GA25260@linux.vnet.ibm.com>
References: <20130810193849.GA25260@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] kvm:
  Paravirtual ticketlocks support for linux guests running on KVM hypervisor
Git-Commit-ID: f9021f7fd9c8c8101c90b901053f99bfd0288021
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 10:27:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9021f7fd9c8c8101c90b901053f99bfd0288021
Gitweb:     http://git.kernel.org/tip/f9021f7fd9c8c8101c90b901053f99bfd0288021
Author:     Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
AuthorDate: Tue, 6 Aug 2013 14:55:41 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 12 Aug 2013 09:03:57 -0700

kvm: Paravirtual ticketlocks support for linux guests running on KVM hypervisor

During smp_boot_cpus  paravirtualied KVM guest detects if the hypervisor has
required feature (KVM_FEATURE_PV_UNHALT) to support pv-ticketlocks. If so,
 support for pv-ticketlocks is registered via pv_lock_ops.

Use KVM_HC_KICK_CPU hypercall to wakeup waiting/halted vcpu.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130810193849.GA25260@linux.vnet.ibm.com
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
[Raghu: check_zero race fix, enum for kvm_contention_stat, jumplabel related changes,
addition of safe_halt for irq enabled case, bailout spinning in nmi case(Gleb)]
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/kvm_para.h |  14 ++-
 arch/x86/kernel/kvm.c           | 262 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 274 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 695399f..427afcb 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -118,10 +118,20 @@ void kvm_async_pf_task_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
-#else
-#define kvm_guest_init() do { } while (0)
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+void __init kvm_spinlock_init(void);
+#else /* !CONFIG_PARAVIRT_SPINLOCKS */
+static inline void kvm_spinlock_init(void)
+{
+}
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
+
+#else /* CONFIG_KVM_GUEST */
+#define kvm_guest_init() do {} while (0)
 #define kvm_async_pf_task_wait(T) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)
+
 static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a96d32c..d442471 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -34,6 +34,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/kprobes.h>
+#include <linux/debugfs.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -419,6 +420,7 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 	WARN_ON(kvm_register_clock("primary cpu clock"));
 	kvm_guest_cpu_init();
 	native_smp_prepare_boot_cpu();
+	kvm_spinlock_init();
 }
 
 static void kvm_guest_cpu_online(void *dummy)
@@ -523,3 +525,263 @@ static __init int activate_jump_labels(void)
 	return 0;
 }
 arch_initcall(activate_jump_labels);
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+/* Kick a cpu by its apicid. Used to wake up a halted vcpu */
+void kvm_kick_cpu(int cpu)
+{
+	int apicid;
+	unsigned long flags = 0;
+
+	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	kvm_hypercall2(KVM_HC_KICK_CPU, flags, apicid);
+}
+
+enum kvm_contention_stat {
+	TAKEN_SLOW,
+	TAKEN_SLOW_PICKUP,
+	RELEASED_SLOW,
+	RELEASED_SLOW_KICKED,
+	NR_CONTENTION_STATS
+};
+
+#ifdef CONFIG_KVM_DEBUG_FS
+#define HISTO_BUCKETS	30
+
+static struct kvm_spinlock_stats
+{
+	u32 contention_stats[NR_CONTENTION_STATS];
+	u32 histo_spin_blocked[HISTO_BUCKETS+1];
+	u64 time_blocked;
+} spinlock_stats;
+
+static u8 zero_stats;
+
+static inline void check_zero(void)
+{
+	u8 ret;
+	u8 old;
+
+	old = ACCESS_ONCE(zero_stats);
+	if (unlikely(old)) {
+		ret = cmpxchg(&zero_stats, old, 0);
+		/* This ensures only one fellow resets the stat */
+		if (ret == old)
+			memset(&spinlock_stats, 0, sizeof(spinlock_stats));
+	}
+}
+
+static inline void add_stats(enum kvm_contention_stat var, u32 val)
+{
+	check_zero();
+	spinlock_stats.contention_stats[var] += val;
+}
+
+
+static inline u64 spin_time_start(void)
+{
+	return sched_clock();
+}
+
+static void __spin_time_accum(u64 delta, u32 *array)
+{
+	unsigned index;
+
+	index = ilog2(delta);
+	check_zero();
+
+	if (index < HISTO_BUCKETS)
+		array[index]++;
+	else
+		array[HISTO_BUCKETS]++;
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+	u32 delta;
+
+	delta = sched_clock() - start;
+	__spin_time_accum(delta, spinlock_stats.histo_spin_blocked);
+	spinlock_stats.time_blocked += delta;
+}
+
+static struct dentry *d_spin_debug;
+static struct dentry *d_kvm_debug;
+
+struct dentry *kvm_init_debugfs(void)
+{
+	d_kvm_debug = debugfs_create_dir("kvm", NULL);
+	if (!d_kvm_debug)
+		printk(KERN_WARNING "Could not create 'kvm' debugfs directory\n");
+
+	return d_kvm_debug;
+}
+
+static int __init kvm_spinlock_debugfs(void)
+{
+	struct dentry *d_kvm;
+
+	d_kvm = kvm_init_debugfs();
+	if (d_kvm == NULL)
+		return -ENOMEM;
+
+	d_spin_debug = debugfs_create_dir("spinlocks", d_kvm);
+
+	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
+
+	debugfs_create_u32("taken_slow", 0444, d_spin_debug,
+		   &spinlock_stats.contention_stats[TAKEN_SLOW]);
+	debugfs_create_u32("taken_slow_pickup", 0444, d_spin_debug,
+		   &spinlock_stats.contention_stats[TAKEN_SLOW_PICKUP]);
+
+	debugfs_create_u32("released_slow", 0444, d_spin_debug,
+		   &spinlock_stats.contention_stats[RELEASED_SLOW]);
+	debugfs_create_u32("released_slow_kicked", 0444, d_spin_debug,
+		   &spinlock_stats.contention_stats[RELEASED_SLOW_KICKED]);
+
+	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
+			   &spinlock_stats.time_blocked);
+
+	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
+		     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
+
+	return 0;
+}
+fs_initcall(kvm_spinlock_debugfs);
+#else  /* !CONFIG_KVM_DEBUG_FS */
+static inline void add_stats(enum kvm_contention_stat var, u32 val)
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
+#endif  /* CONFIG_KVM_DEBUG_FS */
+
+struct kvm_lock_waiting {
+	struct arch_spinlock *lock;
+	__ticket_t want;
+};
+
+/* cpus 'waiting' on a spinlock to become available */
+static cpumask_t waiting_cpus;
+
+/* Track spinlock on which a cpu is waiting */
+static DEFINE_PER_CPU(struct kvm_lock_waiting, lock_waiting);
+
+static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
+{
+	struct kvm_lock_waiting *w;
+	int cpu;
+	u64 start;
+	unsigned long flags;
+
+	if (in_nmi())
+		return;
+
+	w = &__get_cpu_var(lock_waiting);
+	cpu = smp_processor_id();
+	start = spin_time_start();
+
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+
+	/*
+	 * The ordering protocol on this is that the "lock" pointer
+	 * may only be set non-NULL if the "want" ticket is correct.
+	 * If we're updating "want", we must first clear "lock".
+	 */
+	w->lock = NULL;
+	smp_wmb();
+	w->want = want;
+	smp_wmb();
+	w->lock = lock;
+
+	add_stats(TAKEN_SLOW, 1);
+
+	/*
+	 * This uses set_bit, which is atomic but we should not rely on its
+	 * reordering gurantees. So barrier is needed after this call.
+	 */
+	cpumask_set_cpu(cpu, &waiting_cpus);
+
+	barrier();
+
+	/*
+	 * Mark entry to slowpath before doing the pickup test to make
+	 * sure we don't deadlock with an unlocker.
+	 */
+	__ticket_enter_slowpath(lock);
+
+	/*
+	 * check again make sure it didn't become free while
+	 * we weren't looking.
+	 */
+	if (ACCESS_ONCE(lock->tickets.head) == want) {
+		add_stats(TAKEN_SLOW_PICKUP, 1);
+		goto out;
+	}
+
+	/*
+	 * halt until it's our turn and kicked. Note that we do safe halt
+	 * for irq enabled case to avoid hang when lock info is overwritten
+	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
+	 */
+	if (arch_irqs_disabled_flags(flags))
+		halt();
+	else
+		safe_halt();
+
+out:
+	cpumask_clear_cpu(cpu, &waiting_cpus);
+	w->lock = NULL;
+	local_irq_restore(flags);
+	spin_time_accum_blocked(start);
+}
+PV_CALLEE_SAVE_REGS_THUNK(kvm_lock_spinning);
+
+/* Kick vcpu waiting on @lock->head to reach value @ticket */
+static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
+{
+	int cpu;
+
+	add_stats(RELEASED_SLOW, 1);
+	for_each_cpu(cpu, &waiting_cpus) {
+		const struct kvm_lock_waiting *w = &per_cpu(lock_waiting, cpu);
+		if (ACCESS_ONCE(w->lock) == lock &&
+		    ACCESS_ONCE(w->want) == ticket) {
+			add_stats(RELEASED_SLOW_KICKED, 1);
+			kvm_kick_cpu(cpu);
+			break;
+		}
+	}
+}
+
+/*
+ * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
+ */
+void __init kvm_spinlock_init(void)
+{
+	if (!kvm_para_available())
+		return;
+	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
+		return;
+
+	printk(KERN_INFO "KVM setup paravirtual spinlock\n");
+
+	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
+	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+}
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
