Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760467Ab3ICT3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:29:49 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47608 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760290Ab3ICT3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:29:47 -0400
Date: Tue, 3 Sep 2013 21:29:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/spinlocks changes for v3.12
Message-ID: <20130903192942.GA2457@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-spinlocks-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-spinlocks-for-linus

   HEAD: 36bd621337c91a1ecda588e5bbbae8dd9698bae7 x86/kvm/guest: Fix sparse warning: "symbol 'klock_waiting' was not declared as static"

The biggest change here are paravirtualized ticket spinlocks (PV 
spinlocks), which bring a nice speedup on various benchmarks. (The KVM 
host side will come to you via the KVM tree.)

out-of-topic modifications in x86-spinlocks-for-linus:
------------------------------------------------------
include/linux/jump_label.h         # 851cf6e: jump_label: Split jumplabel ratel
include/linux/jump_label_ratelimit.h# 851cf6e: jump_label: Split jumplabel ratel
include/linux/perf_event.h         # 851cf6e: jump_label: Split jumplabel ratel
include/uapi/linux/kvm_para.h      # 3a3bb00: kvm uapi: Add KICK_CPU and PV_UNH
kernel/jump_label.c                # 851cf6e: jump_label: Split jumplabel ratel

 Thanks,

	Ingo

------------------>
Andrew Jones (1):
      jump_label: Split jumplabel ratelimit

Jeremy Fitzhardinge (9):
      x86, spinlock: Replace pv spinlocks with pv ticketlocks
      x86, ticketlock: Collapse a layer of functions
      xen: Defer spinlock setup until boot CPU setup
      xen, pvticketlock: Xen implementation for PV ticket locks
      xen, pvticketlocks: Add xen_nopvspin parameter to disable xen pv ticketlocks
      x86, pvticketlock: Use callee-save for lock_spinning
      x86, pvticketlock: When paravirtualizing ticket locks, increment by 2
      x86, ticketlock: Add slowpath logic
      xen, pvticketlock: Allow interrupts to be enabled while blocking

Raghavendra K T (3):
      x86, ticketlock: Don't inline _spin_unlock when using paravirt spinlocks
      kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi
      x86/kvm/guest: Fix sparse warning: "symbol 'klock_waiting' was not declared as static"

Srivatsa Vaddagiri (2):
      kvm guest: Add configuration support to enable debug information for KVM Guests
      kvm: Paravirtual ticketlocks support for linux guests running on KVM hypervisor


 arch/x86/Kconfig                      |  10 +
 arch/x86/include/asm/kvm_para.h       |  14 +-
 arch/x86/include/asm/paravirt.h       |  32 +--
 arch/x86/include/asm/paravirt_types.h |  14 +-
 arch/x86/include/asm/spinlock.h       | 128 +++++++----
 arch/x86/include/asm/spinlock_types.h |  16 +-
 arch/x86/include/uapi/asm/kvm_para.h  |   1 +
 arch/x86/kernel/kvm.c                 | 262 +++++++++++++++++++++++
 arch/x86/kernel/paravirt-spinlocks.c  |  18 +-
 arch/x86/xen/smp.c                    |   2 +-
 arch/x86/xen/spinlock.c               | 387 +++++++++++-----------------------
 include/linux/jump_label.h            |  28 +--
 include/linux/jump_label_ratelimit.h  |  34 +++
 include/linux/perf_event.h            |   1 +
 include/uapi/linux/kvm_para.h         |   1 +
 kernel/jump_label.c                   |   1 +
 16 files changed, 569 insertions(+), 380 deletions(-)
 create mode 100644 include/linux/jump_label_ratelimit.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..b1fb846 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -632,6 +632,7 @@ config PARAVIRT_DEBUG
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
 	depends on PARAVIRT && SMP
+	select UNINLINE_SPIN_UNLOCK
 	---help---
 	  Paravirtualized spinlocks allow a pvops backend to replace the
 	  spinlock implementation with something virtualization-friendly
@@ -656,6 +657,15 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_DEBUG_FS
+	bool "Enable debug information for KVM Guests in debugfs"
+	depends on KVM_GUEST && DEBUG_FS
+	default n
+	---help---
+	  This option enables collection of various statistics for KVM guest.
+	  Statistics are displayed in debugfs filesystem. Enabling this option
+	  may incur significant overhead.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT_TIME_ACCOUNTING
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
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cfdc9ee..401f350 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -712,36 +712,16 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
-static inline int arch_spin_is_locked(struct arch_spinlock *lock)
+static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
+							__ticket_t ticket)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_is_locked, lock);
+	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static inline int arch_spin_is_contended(struct arch_spinlock *lock)
+static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
+							__ticket_t ticket)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_is_contended, lock);
-}
-#define arch_spin_is_contended	arch_spin_is_contended
-
-static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
-{
-	PVOP_VCALL1(pv_lock_ops.spin_lock, lock);
-}
-
-static __always_inline void arch_spin_lock_flags(struct arch_spinlock *lock,
-						  unsigned long flags)
-{
-	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
-}
-
-static __always_inline int arch_spin_trylock(struct arch_spinlock *lock)
-{
-	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
-}
-
-static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
-{
-	PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
+	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
 
 #endif
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 0db1fca..04ac40e 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -327,13 +327,15 @@ struct pv_mmu_ops {
 };
 
 struct arch_spinlock;
+#ifdef CONFIG_SMP
+#include <asm/spinlock_types.h>
+#else
+typedef u16 __ticket_t;
+#endif
+
 struct pv_lock_ops {
-	int (*spin_is_locked)(struct arch_spinlock *lock);
-	int (*spin_is_contended)(struct arch_spinlock *lock);
-	void (*spin_lock)(struct arch_spinlock *lock);
-	void (*spin_lock_flags)(struct arch_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct arch_spinlock *lock);
-	void (*spin_unlock)(struct arch_spinlock *lock);
+	struct paravirt_callee_save lock_spinning;
+	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
 };
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 33692ea..d68883d 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -1,11 +1,14 @@
 #ifndef _ASM_X86_SPINLOCK_H
 #define _ASM_X86_SPINLOCK_H
 
+#include <linux/jump_label.h>
 #include <linux/atomic.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <linux/compiler.h>
 #include <asm/paravirt.h>
+#include <asm/bitops.h>
+
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  *
@@ -34,6 +37,31 @@
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+/* How long a lock should spin before we consider blocking */
+#define SPIN_THRESHOLD	(1 << 15)
+
+extern struct static_key paravirt_ticketlocks_enabled;
+static __always_inline bool static_key_false(struct static_key *key);
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
+{
+	set_bit(0, (volatile unsigned long *)&lock->tickets.tail);
+}
+
+#else  /* !CONFIG_PARAVIRT_SPINLOCKS */
+static __always_inline void __ticket_lock_spinning(arch_spinlock_t *lock,
+							__ticket_t ticket)
+{
+}
+static inline void __ticket_unlock_kick(arch_spinlock_t *lock,
+							__ticket_t ticket)
+{
+}
+
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -47,81 +75,101 @@
  * in the high part, because a wide xadd increment of the low part would carry
  * up and contaminate the high part.
  */
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 {
-	register struct __raw_tickets inc = { .tail = 1 };
+	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
 
 	inc = xadd(&lock->tickets, inc);
+	if (likely(inc.head == inc.tail))
+		goto out;
 
+	inc.tail &= ~TICKET_SLOWPATH_FLAG;
 	for (;;) {
-		if (inc.head == inc.tail)
-			break;
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
+		unsigned count = SPIN_THRESHOLD;
+
+		do {
+			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
+				goto out;
+			cpu_relax();
+		} while (--count);
+		__ticket_lock_spinning(lock, inc.tail);
 	}
-	barrier();		/* make sure nothing creeps before the lock is taken */
+out:	barrier();	/* make sure nothing creeps before the lock is taken */
 }
 
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
+static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	arch_spinlock_t old, new;
 
 	old.tickets = ACCESS_ONCE(lock->tickets);
-	if (old.tickets.head != old.tickets.tail)
+	if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
 		return 0;
 
-	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
+	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
 
 	/* cmpxchg is a full barrier, so nothing can move before it */
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
 
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
+static inline void __ticket_unlock_slowpath(arch_spinlock_t *lock,
+					    arch_spinlock_t old)
 {
-	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
+	arch_spinlock_t new;
+
+	BUILD_BUG_ON(((__ticket_t)NR_CPUS) != NR_CPUS);
+
+	/* Perform the unlock on the "before" copy */
+	old.tickets.head += TICKET_LOCK_INC;
+
+	/* Clear the slowpath flag */
+	new.head_tail = old.head_tail & ~(TICKET_SLOWPATH_FLAG << TICKET_SHIFT);
+
+	/*
+	 * If the lock is uncontended, clear the flag - use cmpxchg in
+	 * case it changes behind our back though.
+	 */
+	if (new.tickets.head != new.tickets.tail ||
+	    cmpxchg(&lock->head_tail, old.head_tail,
+					new.head_tail) != old.head_tail) {
+		/*
+		 * Lock still has someone queued for it, so wake up an
+		 * appropriate waiter.
+		 */
+		__ticket_unlock_kick(lock, old.tickets.head);
+	}
 }
 
-static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
+static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
-	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+	if (TICKET_SLOWPATH_FLAG &&
+	    static_key_false(&paravirt_ticketlocks_enabled)) {
+		arch_spinlock_t prev;
 
-	return tmp.tail != tmp.head;
-}
+		prev = *lock;
+		add_smp(&lock->tickets.head, TICKET_LOCK_INC);
 
-static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
-{
-	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+		/* add_smp() is a full mb() */
 
-	return (__ticket_t)(tmp.tail - tmp.head) > 1;
+		if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
+			__ticket_unlock_slowpath(lock, prev);
+	} else
+		__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
 }
 
-#ifndef CONFIG_PARAVIRT_SPINLOCKS
-
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
-	return __ticket_spin_is_locked(lock);
-}
-
-static inline int arch_spin_is_contended(arch_spinlock_t *lock)
-{
-	return __ticket_spin_is_contended(lock);
-}
-#define arch_spin_is_contended	arch_spin_is_contended
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
-{
-	__ticket_spin_lock(lock);
+	return tmp.tail != tmp.head;
 }
 
-static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
-	return __ticket_spin_trylock(lock);
-}
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
-{
-	__ticket_spin_unlock(lock);
+	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
 }
+#define arch_spin_is_contended	arch_spin_is_contended
 
 static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 						  unsigned long flags)
@@ -129,8 +177,6 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 	arch_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
-
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (arch_spin_is_locked(lock))
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index ad0ad07..4f1bea1 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -1,13 +1,17 @@
 #ifndef _ASM_X86_SPINLOCK_TYPES_H
 #define _ASM_X86_SPINLOCK_TYPES_H
 
-#ifndef __LINUX_SPINLOCK_TYPES_H
-# error "please don't include this file directly"
-#endif
-
 #include <linux/types.h>
 
-#if (CONFIG_NR_CPUS < 256)
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#define __TICKET_LOCK_INC	2
+#define TICKET_SLOWPATH_FLAG	((__ticket_t)1)
+#else
+#define __TICKET_LOCK_INC	1
+#define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
+#endif
+
+#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
 #else
@@ -15,6 +19,8 @@ typedef u16 __ticket_t;
 typedef u32 __ticketpair_t;
 #endif
 
+#define TICKET_LOCK_INC	((__ticket_t)__TICKET_LOCK_INC)
+
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
 
 typedef struct arch_spinlock {
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 06fdbd9..94dc8ca 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -23,6 +23,7 @@
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
 #define KVM_FEATURE_PV_EOI		6
+#define KVM_FEATURE_PV_UNHALT		7
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a96d32c..56e2fa4 100644
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
+static void kvm_kick_cpu(int cpu)
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
+static DEFINE_PER_CPU(struct kvm_lock_waiting, klock_waiting);
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
+	w = &__get_cpu_var(klock_waiting);
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
+		const struct kvm_lock_waiting *w = &per_cpu(klock_waiting, cpu);
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
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 676b8c7..bbb6c73 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -4,25 +4,17 @@
  */
 #include <linux/spinlock.h>
 #include <linux/module.h>
+#include <linux/jump_label.h>
 
 #include <asm/paravirt.h>
 
-static inline void
-default_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
-{
-	arch_spin_lock(lock);
-}
-
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
-	.spin_is_locked = __ticket_spin_is_locked,
-	.spin_is_contended = __ticket_spin_is_contended,
-
-	.spin_lock = __ticket_spin_lock,
-	.spin_lock_flags = default_spin_lock_flags,
-	.spin_trylock = __ticket_spin_trylock,
-	.spin_unlock = __ticket_spin_unlock,
+	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
+	.unlock_kick = paravirt_nop,
 #endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
+struct static_key paravirt_ticketlocks_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL(paravirt_ticketlocks_enabled);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index ca92754..3b52d80 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -279,6 +279,7 @@ static void __init xen_smp_prepare_boot_cpu(void)
 
 	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
+	xen_init_spinlocks();
 }
 
 static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
@@ -680,7 +681,6 @@ void __init xen_smp_init(void)
 {
 	smp_ops = xen_smp_ops;
 	xen_fill_possible_map();
-	xen_init_spinlocks();
 }
 
 static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index cf3caee..0438b93 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -17,45 +17,44 @@
 #include "xen-ops.h"
 #include "debugfs.h"
 
-#ifdef CONFIG_XEN_DEBUG_FS
-static struct xen_spinlock_stats
-{
-	u64 taken;
-	u32 taken_slow;
-	u32 taken_slow_nested;
-	u32 taken_slow_pickup;
-	u32 taken_slow_spurious;
-	u32 taken_slow_irqenable;
+enum xen_contention_stat {
+	TAKEN_SLOW,
+	TAKEN_SLOW_PICKUP,
+	TAKEN_SLOW_SPURIOUS,
+	RELEASED_SLOW,
+	RELEASED_SLOW_KICKED,
+	NR_CONTENTION_STATS
+};
 
-	u64 released;
-	u32 released_slow;
-	u32 released_slow_kicked;
 
+#ifdef CONFIG_XEN_DEBUG_FS
 #define HISTO_BUCKETS	30
-	u32 histo_spin_total[HISTO_BUCKETS+1];
-	u32 histo_spin_spinning[HISTO_BUCKETS+1];
+static struct xen_spinlock_stats
+{
+	u32 contention_stats[NR_CONTENTION_STATS];
 	u32 histo_spin_blocked[HISTO_BUCKETS+1];
-
-	u64 time_total;
-	u64 time_spinning;
 	u64 time_blocked;
 } spinlock_stats;
 
 static u8 zero_stats;
 
-static unsigned lock_timeout = 1 << 10;
-#define TIMEOUT lock_timeout
-
 static inline void check_zero(void)
 {
-	if (unlikely(zero_stats)) {
-		memset(&spinlock_stats, 0, sizeof(spinlock_stats));
-		zero_stats = 0;
+	u8 ret;
+	u8 old = ACCESS_ONCE(zero_stats);
+	if (unlikely(old)) {
+		ret = cmpxchg(&zero_stats, old, 0);
+		/* This ensures only one fellow resets the stat */
+		if (ret == old)
+			memset(&spinlock_stats, 0, sizeof(spinlock_stats));
 	}
 }
 
-#define ADD_STATS(elem, val)			\
-	do { check_zero(); spinlock_stats.elem += (val); } while(0)
+static inline void add_stats(enum xen_contention_stat var, u32 val)
+{
+	check_zero();
+	spinlock_stats.contention_stats[var] += val;
+}
 
 static inline u64 spin_time_start(void)
 {
@@ -74,22 +73,6 @@ static void __spin_time_accum(u64 delta, u32 *array)
 		array[HISTO_BUCKETS]++;
 }
 
-static inline void spin_time_accum_spinning(u64 start)
-{
-	u32 delta = xen_clocksource_read() - start;
-
-	__spin_time_accum(delta, spinlock_stats.histo_spin_spinning);
-	spinlock_stats.time_spinning += delta;
-}
-
-static inline void spin_time_accum_total(u64 start)
-{
-	u32 delta = xen_clocksource_read() - start;
-
-	__spin_time_accum(delta, spinlock_stats.histo_spin_total);
-	spinlock_stats.time_total += delta;
-}
-
 static inline void spin_time_accum_blocked(u64 start)
 {
 	u32 delta = xen_clocksource_read() - start;
@@ -99,19 +82,15 @@ static inline void spin_time_accum_blocked(u64 start)
 }
 #else  /* !CONFIG_XEN_DEBUG_FS */
 #define TIMEOUT			(1 << 10)
-#define ADD_STATS(elem, val)	do { (void)(val); } while(0)
+static inline void add_stats(enum xen_contention_stat var, u32 val)
+{
+}
 
 static inline u64 spin_time_start(void)
 {
 	return 0;
 }
 
-static inline void spin_time_accum_total(u64 start)
-{
-}
-static inline void spin_time_accum_spinning(u64 start)
-{
-}
 static inline void spin_time_accum_blocked(u64 start)
 {
 }
@@ -134,227 +113,123 @@ typedef u16 xen_spinners_t;
 	asm(LOCK_PREFIX " decw %0" : "+m" ((xl)->spinners) : : "memory");
 #endif
 
-struct xen_spinlock {
-	unsigned char lock;		/* 0 -> free; 1 -> locked */
-	xen_spinners_t spinners;	/* count of waiting cpus */
+struct xen_lock_waiting {
+	struct arch_spinlock *lock;
+	__ticket_t want;
 };
 
-static int xen_spin_is_locked(struct arch_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	return xl->lock != 0;
-}
-
-static int xen_spin_is_contended(struct arch_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	/* Not strictly true; this is only the count of contended
-	   lock-takers entering the slow path. */
-	return xl->spinners != 0;
-}
-
-static int xen_spin_trylock(struct arch_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	u8 old = 1;
-
-	asm("xchgb %b0,%1"
-	    : "+q" (old), "+m" (xl->lock) : : "memory");
-
-	return old == 0;
-}
-
-static DEFINE_PER_CPU(char *, irq_name);
 static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
-static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
-
-/*
- * Mark a cpu as interested in a lock.  Returns the CPU's previous
- * lock of interest, in case we got preempted by an interrupt.
- */
-static inline struct xen_spinlock *spinning_lock(struct xen_spinlock *xl)
-{
-	struct xen_spinlock *prev;
-
-	prev = __this_cpu_read(lock_spinners);
-	__this_cpu_write(lock_spinners, xl);
-
-	wmb();			/* set lock of interest before count */
-
-	inc_spinners(xl);
-
-	return prev;
-}
-
-/*
- * Mark a cpu as no longer interested in a lock.  Restores previous
- * lock of interest (NULL for none).
- */
-static inline void unspinning_lock(struct xen_spinlock *xl, struct xen_spinlock *prev)
-{
-	dec_spinners(xl);
-	wmb();			/* decrement count before restoring lock */
-	__this_cpu_write(lock_spinners, prev);
-}
+static DEFINE_PER_CPU(char *, irq_name);
+static DEFINE_PER_CPU(struct xen_lock_waiting, lock_waiting);
+static cpumask_t waiting_cpus;
 
-static noinline int xen_spin_lock_slow(struct arch_spinlock *lock, bool irq_enable)
+static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	struct xen_spinlock *prev;
 	int irq = __this_cpu_read(lock_kicker_irq);
-	int ret;
+	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
+	int cpu = smp_processor_id();
 	u64 start;
+	unsigned long flags;
 
 	/* If kicker interrupts not initialized yet, just spin */
 	if (irq == -1)
-		return 0;
+		return;
 
 	start = spin_time_start();
 
-	/* announce we're spinning */
-	prev = spinning_lock(xl);
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+	/*
+	 * We don't really care if we're overwriting some other
+	 * (lock,want) pair, as that would mean that we're currently
+	 * in an interrupt context, and the outer context had
+	 * interrupts enabled.  That has already kicked the VCPU out
+	 * of xen_poll_irq(), so it will just return spuriously and
+	 * retry with newly setup (lock,want).
+	 *
+	 * The ordering protocol on this is that the "lock" pointer
+	 * may only be set non-NULL if the "want" ticket is correct.
+	 * If we're updating "want", we must first clear "lock".
+	 */
+	w->lock = NULL;
+	smp_wmb();
+	w->want = want;
+	smp_wmb();
+	w->lock = lock;
 
-	ADD_STATS(taken_slow, 1);
-	ADD_STATS(taken_slow_nested, prev != NULL);
+	/* This uses set_bit, which atomic and therefore a barrier */
+	cpumask_set_cpu(cpu, &waiting_cpus);
+	add_stats(TAKEN_SLOW, 1);
 
-	do {
-		unsigned long flags;
+	/* clear pending */
+	xen_clear_irq_pending(irq);
 
-		/* clear pending */
-		xen_clear_irq_pending(irq);
+	/* Only check lock once pending cleared */
+	barrier();
 
-		/* check again make sure it didn't become free while
-		   we weren't looking  */
-		ret = xen_spin_trylock(lock);
-		if (ret) {
-			ADD_STATS(taken_slow_pickup, 1);
+	/*
+	 * Mark entry to slowpath before doing the pickup test to make
+	 * sure we don't deadlock with an unlocker.
+	 */
+	__ticket_enter_slowpath(lock);
 
-			/*
-			 * If we interrupted another spinlock while it
-			 * was blocking, make sure it doesn't block
-			 * without rechecking the lock.
-			 */
-			if (prev != NULL)
-				xen_set_irq_pending(irq);
-			goto out;
-		}
+	/*
+	 * check again make sure it didn't become free while
+	 * we weren't looking
+	 */
+	if (ACCESS_ONCE(lock->tickets.head) == want) {
+		add_stats(TAKEN_SLOW_PICKUP, 1);
+		goto out;
+	}
 
-		flags = arch_local_save_flags();
-		if (irq_enable) {
-			ADD_STATS(taken_slow_irqenable, 1);
-			raw_local_irq_enable();
-		}
+	/* Allow interrupts while blocked */
+	local_irq_restore(flags);
 
-		/*
-		 * Block until irq becomes pending.  If we're
-		 * interrupted at this point (after the trylock but
-		 * before entering the block), then the nested lock
-		 * handler guarantees that the irq will be left
-		 * pending if there's any chance the lock became free;
-		 * xen_poll_irq() returns immediately if the irq is
-		 * pending.
-		 */
-		xen_poll_irq(irq);
+	/*
+	 * If an interrupt happens here, it will leave the wakeup irq
+	 * pending, which will cause xen_poll_irq() to return
+	 * immediately.
+	 */
 
-		raw_local_irq_restore(flags);
+	/* Block until irq becomes pending (or perhaps a spurious wakeup) */
+	xen_poll_irq(irq);
+	add_stats(TAKEN_SLOW_SPURIOUS, !xen_test_irq_pending(irq));
 
-		ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
-	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
+	local_irq_save(flags);
 
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
-
 out:
-	unspinning_lock(xl, prev);
-	spin_time_accum_blocked(start);
-
-	return ret;
-}
-
-static inline void __xen_spin_lock(struct arch_spinlock *lock, bool irq_enable)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	unsigned timeout;
-	u8 oldval;
-	u64 start_spin;
-
-	ADD_STATS(taken, 1);
-
-	start_spin = spin_time_start();
-
-	do {
-		u64 start_spin_fast = spin_time_start();
-
-		timeout = TIMEOUT;
-
-		asm("1: xchgb %1,%0\n"
-		    "   testb %1,%1\n"
-		    "   jz 3f\n"
-		    "2: rep;nop\n"
-		    "   cmpb $0,%0\n"
-		    "   je 1b\n"
-		    "   dec %2\n"
-		    "   jnz 2b\n"
-		    "3:\n"
-		    : "+m" (xl->lock), "=q" (oldval), "+r" (timeout)
-		    : "1" (1)
-		    : "memory");
+	cpumask_clear_cpu(cpu, &waiting_cpus);
+	w->lock = NULL;
 
-		spin_time_accum_spinning(start_spin_fast);
+	local_irq_restore(flags);
 
-	} while (unlikely(oldval != 0 &&
-			  (TIMEOUT == ~0 || !xen_spin_lock_slow(lock, irq_enable))));
-
-	spin_time_accum_total(start_spin);
-}
-
-static void xen_spin_lock(struct arch_spinlock *lock)
-{
-	__xen_spin_lock(lock, false);
-}
-
-static void xen_spin_lock_flags(struct arch_spinlock *lock, unsigned long flags)
-{
-	__xen_spin_lock(lock, !raw_irqs_disabled_flags(flags));
+	spin_time_accum_blocked(start);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_lock_spinning);
 
-static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
+static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 {
 	int cpu;
 
-	ADD_STATS(released_slow, 1);
+	add_stats(RELEASED_SLOW, 1);
+
+	for_each_cpu(cpu, &waiting_cpus) {
+		const struct xen_lock_waiting *w = &per_cpu(lock_waiting, cpu);
 
-	for_each_online_cpu(cpu) {
-		/* XXX should mix up next cpu selection */
-		if (per_cpu(lock_spinners, cpu) == xl) {
-			ADD_STATS(released_slow_kicked, 1);
+		/* Make sure we read lock before want */
+		if (ACCESS_ONCE(w->lock) == lock &&
+		    ACCESS_ONCE(w->want) == next) {
+			add_stats(RELEASED_SLOW_KICKED, 1);
 			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
+			break;
 		}
 	}
 }
 
-static void xen_spin_unlock(struct arch_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	ADD_STATS(released, 1);
-
-	smp_wmb();		/* make sure no writes get moved after unlock */
-	xl->lock = 0;		/* release lock */
-
-	/*
-	 * Make sure unlock happens before checking for waiting
-	 * spinners.  We need a strong barrier to enforce the
-	 * write-read ordering to different memory locations, as the
-	 * CPU makes no implied guarantees about their ordering.
-	 */
-	mb();
-
-	if (unlikely(xl->spinners))
-		xen_spin_unlock_slow(xl);
-}
-
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
 	BUG();
@@ -408,6 +283,8 @@ void xen_uninit_lock_cpu(int cpu)
 	per_cpu(irq_name, cpu) = NULL;
 }
 
+static bool xen_pvspin __initdata = true;
+
 void __init xen_init_spinlocks(void)
 {
 	/*
@@ -417,15 +294,23 @@ void __init xen_init_spinlocks(void)
 	if (xen_hvm_domain())
 		return;
 
-	BUILD_BUG_ON(sizeof(struct xen_spinlock) > sizeof(arch_spinlock_t));
+	if (!xen_pvspin) {
+		printk(KERN_DEBUG "xen: PV spinlocks disabled\n");
+		return;
+	}
 
-	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
-	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
-	pv_lock_ops.spin_lock = xen_spin_lock;
-	pv_lock_ops.spin_lock_flags = xen_spin_lock_flags;
-	pv_lock_ops.spin_trylock = xen_spin_trylock;
-	pv_lock_ops.spin_unlock = xen_spin_unlock;
+	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
+	pv_lock_ops.unlock_kick = xen_unlock_kick;
+}
+
+static __init int xen_parse_nopvspin(char *arg)
+{
+	xen_pvspin = false;
+	return 0;
 }
+early_param("xen_nopvspin", xen_parse_nopvspin);
 
 #ifdef CONFIG_XEN_DEBUG_FS
 
@@ -442,37 +327,21 @@ static int __init xen_spinlock_debugfs(void)
 
 	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
 
-	debugfs_create_u32("timeout", 0644, d_spin_debug, &lock_timeout);
-
-	debugfs_create_u64("taken", 0444, d_spin_debug, &spinlock_stats.taken);
 	debugfs_create_u32("taken_slow", 0444, d_spin_debug,
-			   &spinlock_stats.taken_slow);
-	debugfs_create_u32("taken_slow_nested", 0444, d_spin_debug,
-			   &spinlock_stats.taken_slow_nested);
+			   &spinlock_stats.contention_stats[TAKEN_SLOW]);
 	debugfs_create_u32("taken_slow_pickup", 0444, d_spin_debug,
-			   &spinlock_stats.taken_slow_pickup);
+			   &spinlock_stats.contention_stats[TAKEN_SLOW_PICKUP]);
 	debugfs_create_u32("taken_slow_spurious", 0444, d_spin_debug,
-			   &spinlock_stats.taken_slow_spurious);
-	debugfs_create_u32("taken_slow_irqenable", 0444, d_spin_debug,
-			   &spinlock_stats.taken_slow_irqenable);
+			   &spinlock_stats.contention_stats[TAKEN_SLOW_SPURIOUS]);
 
-	debugfs_create_u64("released", 0444, d_spin_debug, &spinlock_stats.released);
 	debugfs_create_u32("released_slow", 0444, d_spin_debug,
-			   &spinlock_stats.released_slow);
+			   &spinlock_stats.contention_stats[RELEASED_SLOW]);
 	debugfs_create_u32("released_slow_kicked", 0444, d_spin_debug,
-			   &spinlock_stats.released_slow_kicked);
+			   &spinlock_stats.contention_stats[RELEASED_SLOW_KICKED]);
 
-	debugfs_create_u64("time_spinning", 0444, d_spin_debug,
-			   &spinlock_stats.time_spinning);
 	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
 			   &spinlock_stats.time_blocked);
-	debugfs_create_u64("time_total", 0444, d_spin_debug,
-			   &spinlock_stats.time_total);
 
-	debugfs_create_u32_array("histo_total", 0444, d_spin_debug,
-				spinlock_stats.histo_spin_total, HISTO_BUCKETS + 1);
-	debugfs_create_u32_array("histo_spinning", 0444, d_spin_debug,
-				spinlock_stats.histo_spin_spinning, HISTO_BUCKETS + 1);
 	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
 				spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
 
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 0976fc4..a507907 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -48,7 +48,6 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/workqueue.h>
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
@@ -61,12 +60,6 @@ struct static_key {
 #endif
 };
 
-struct static_key_deferred {
-	struct static_key key;
-	unsigned long timeout;
-	struct delayed_work work;
-};
-
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
@@ -78,6 +71,7 @@ enum jump_label_type {
 
 struct module;
 
+#include <linux/atomic.h>
 #ifdef HAVE_JUMP_LABEL
 
 #define JUMP_LABEL_TRUE_BRANCH 1UL
@@ -119,10 +113,7 @@ extern void arch_jump_label_transform_static(struct jump_entry *entry,
 extern int jump_label_text_reserved(void *start, void *end);
 extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
-extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
 extern void jump_label_apply_nops(struct module *mod);
-extern void
-jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 
 #define STATIC_KEY_INIT_TRUE ((struct static_key) \
 	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
@@ -131,8 +122,6 @@ jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 
 #else  /* !HAVE_JUMP_LABEL */
 
-#include <linux/atomic.h>
-
 struct static_key {
 	atomic_t enabled;
 };
@@ -141,10 +130,6 @@ static __always_inline void jump_label_init(void)
 {
 }
 
-struct static_key_deferred {
-	struct static_key  key;
-};
-
 static __always_inline bool static_key_false(struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
@@ -169,11 +154,6 @@ static inline void static_key_slow_dec(struct static_key *key)
 	atomic_dec(&key->enabled);
 }
 
-static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
-{
-	static_key_slow_dec(&key->key);
-}
-
 static inline int jump_label_text_reserved(void *start, void *end)
 {
 	return 0;
@@ -187,12 +167,6 @@ static inline int jump_label_apply_nops(struct module *mod)
 	return 0;
 }
 
-static inline void
-jump_label_rate_limit(struct static_key_deferred *key,
-		unsigned long rl)
-{
-}
-
 #define STATIC_KEY_INIT_TRUE ((struct static_key) \
 		{ .enabled = ATOMIC_INIT(1) })
 #define STATIC_KEY_INIT_FALSE ((struct static_key) \
diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
new file mode 100644
index 0000000..1137883
--- /dev/null
+++ b/include/linux/jump_label_ratelimit.h
@@ -0,0 +1,34 @@
+#ifndef _LINUX_JUMP_LABEL_RATELIMIT_H
+#define _LINUX_JUMP_LABEL_RATELIMIT_H
+
+#include <linux/jump_label.h>
+#include <linux/workqueue.h>
+
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+struct static_key_deferred {
+	struct static_key key;
+	unsigned long timeout;
+	struct delayed_work work;
+};
+#endif
+
+#ifdef HAVE_JUMP_LABEL
+extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
+extern void
+jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
+
+#else	/* !HAVE_JUMP_LABEL */
+struct static_key_deferred {
+	struct static_key  key;
+};
+static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
+{
+	static_key_slow_dec(&key->key);
+}
+static inline void
+jump_label_rate_limit(struct static_key_deferred *key,
+		unsigned long rl)
+{
+}
+#endif	/* HAVE_JUMP_LABEL */
+#endif	/* _LINUX_JUMP_LABEL_RATELIMIT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c43f6ea..226be8d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -48,6 +48,7 @@ struct perf_guest_info_callbacks {
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
 #include <linux/static_key.h>
+#include <linux/jump_label_ratelimit.h>
 #include <linux/atomic.h>
 #include <linux/sysfs.h>
 #include <linux/perf_regs.h>
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index cea2c5c..2841f86 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_KICK_CPU			5
 
 /*
  * hypercalls use architecture specific
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 60f48fa..297a924 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -13,6 +13,7 @@
 #include <linux/sort.h>
 #include <linux/err.h>
 #include <linux/static_key.h>
+#include <linux/jump_label_ratelimit.h>
 
 #ifdef HAVE_JUMP_LABEL
 
