Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423196Ab3CWB3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:29:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:55320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422733Ab3CWBZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338477"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 15/29] x86, tsx: Add TSX lock elision infrastructure
Date: Fri, 22 Mar 2013 18:25:09 -0700
Message-Id: <1364001923-10796-16-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add basic TSX lock elision infrastructure. This is implemented
using RTM to give more flexibility.  A lock is elided by
wrapping an elision check around it: when the lock is free
try to speculatively execute the lock region and fall back
if that fails.

Provide some generic macros to add lock elision wrapping
to different lock types.

Patch into the spinlocks using paravirt ops. We also
have to intercept cli/sti to avoiding aborts due to
changing the interrupt flag (see the comment in the source
for more details)

Since paravirt ops cannot be stacked this implies currently
that either a pvops using hypervisor or elision are active,
but not both at the same time. This is likely fixable.

For read write locks and other locks we have to use direct hooks
(added in followon patches)

All elision can be enabled/disabled through module params.

We also use the module params for tuning and exporting statistics.
While that is slightly unusal, it leads to very simple
and concise code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig                     |   15 ++
 arch/x86/include/asm/elide.h         |   58 ++++++
 arch/x86/include/asm/rtm-locks.h     |   18 ++
 arch/x86/include/asm/setup.h         |    6 +
 arch/x86/kernel/Makefile             |    3 +
 arch/x86/kernel/paravirt-spinlocks.c |    4 +-
 arch/x86/kernel/rtm-locks.c          |  350 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c              |    1 +
 8 files changed, 453 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/elide.h
 create mode 100644 arch/x86/include/asm/rtm-locks.h
 create mode 100644 arch/x86/kernel/rtm-locks.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..015db67 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -656,9 +656,24 @@ config PARAVIRT_SPINLOCKS
 
 	  If you are unsure how to answer this question, answer N.
 
+config RTM_LOCKS
+       bool "RTM elided locks"
+       depends on PARAVIRT && SMP && !LOCKDEP
+       ---help---
+	  Use TSX enabled locks.
+	  This allows to elide locks systems that support Intel TSX.
+	  Eliding locks allows to run the locks in parallel when various
+	  conditions are met. On systems without TSX this will do nothing.
+	  This uses the same mechanisms as used for paravirtualized locks
+	  on Xen and other hypervisors and only either can be used.
+
 config PARAVIRT_CLOCK
 	bool
 
+config ARCH_HAS_ELISION
+       def_bool y
+       depends on RTM_LOCKS
+
 endif
 
 config PARAVIRT_DEBUG
diff --git a/arch/x86/include/asm/elide.h b/arch/x86/include/asm/elide.h
new file mode 100644
index 0000000..c492aed
--- /dev/null
+++ b/arch/x86/include/asm/elide.h
@@ -0,0 +1,58 @@
+#ifndef _ASM_ELIDE_H
+#define _ASM_ELIDE_H 1
+
+#ifdef CONFIG_RTM_LOCKS
+#include <asm/rtm.h>
+
+/*
+ * These are out of line unfortunately, just to avoid
+ * a nasty include loop with per cpu data.
+ * (FIXME)
+ */
+extern int __elide_lock(void);
+extern void __elide_unlock(void);
+
+/*
+ * Simple lock elision wrappers for locks.
+ * f is the static key that enables/disables elision
+ * l must be evaluated by the macro later, and yield 1
+ * when the lock is free.
+ *
+ * TBD should use static_keys too, but that needs
+ * more changes to avoid include loop hell with users.
+ */
+
+#define elide_lock(f, l) ({		\
+	int flag = 0;			\
+	if ((f) && __elide_lock()) {	\
+		if (l)			\
+			flag = 1;	\
+		else			\
+			_xabort(0xff);	\
+	}				\
+	flag;				\
+})
+
+/*
+ * Note that if you see a general protection fault
+ * in the _xend you have a unmatched unlock. Please fix
+ * your code.
+ */
+
+#define elide_unlock(l) ({			\
+	int flag = 0;				\
+	if (l)	{				\
+		__elide_unlock();		\
+		flag = 1;			\
+	}					\
+	flag;					\
+})
+
+/*
+ * Use for code that cannot elide, primarily code that queries
+ * the lock state.
+ */
+#define elide_abort() _xabort(0xfe)
+
+#endif
+#endif
diff --git a/arch/x86/include/asm/rtm-locks.h b/arch/x86/include/asm/rtm-locks.h
new file mode 100644
index 0000000..1a7ff2a
--- /dev/null
+++ b/arch/x86/include/asm/rtm-locks.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_RTM_LOCKS
+#define _ASM_RTM_LOCKS 1
+
+#include <asm/rwlock.h>
+
+/* rwlocks */
+
+void rtm_read_lock(arch_rwlock_t *rw);
+void rtm_read_unlock(arch_rwlock_t *rw);
+void rtm_read_unlock_irq(arch_rwlock_t *rw);
+void rtm_read_unlock_irqrestore(arch_rwlock_t *rw, unsigned long flags);
+int rtm_read_trylock(arch_rwlock_t *rw);
+void rtm_write_lock(arch_rwlock_t *rw);
+void rtm_write_unlock(arch_rwlock_t *rw);
+void rtm_write_unlock_irq(arch_rwlock_t *rw);
+void rtm_write_unlock_irqrestore(arch_rwlock_t *rw, unsigned long flags);
+
+#endif
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index b7bf350..3fbfdaf 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -34,6 +34,12 @@ void vsmp_init(void);
 static inline void vsmp_init(void) { }
 #endif
 
+#ifdef CONFIG_RTM_LOCKS
+void init_rtm_spinlocks(void);
+#else
+static inline void init_rtm_spinlocks(void) { }
+#endif
+
 void setup_bios_corruption_check(void);
 
 #ifdef CONFIG_X86_VISWS
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f46aebd..995c788 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -14,6 +14,7 @@ CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
+CFLAGS_REMOVE_rtm-spinlocks.o = -pg
 endif
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
@@ -103,6 +104,8 @@ obj-$(CONFIG_UPROBES)			+= uprobes.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 
+obj-$(CONFIG_RTM_LOCKS)		+= rtm-locks.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index c41fc8c..1451956 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -36,8 +36,8 @@ struct pv_lock_ops pv_lock_ops = {
 	.spin_lock_flags = default_spin_lock_flags,
 	.spin_trylock = __ticket_spin_trylock,
 	.spin_unlock = __ticket_spin_unlock,
-	.spin_unlock_irq = default_spin_unlock_flags,
-	.spin_unlock_flags = default_spin_unlock_irq,
+	.spin_unlock_irq = default_spin_unlock_irq,
+	.spin_unlock_flags = default_spin_unlock_flags,
 #endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
new file mode 100644
index 0000000..0717050
--- /dev/null
+++ b/arch/x86/kernel/rtm-locks.c
@@ -0,0 +1,350 @@
+/*
+ * Intel TSX RTM (Restricted Transactional Memory) lock elision.
+ * Lock elision allows to run locks in parallel using transactional memory.
+ *
+ * (C) Copyright 2012, 2013 Intel Corporation
+ * Author: Andi Kleen <ak@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Adds a fast path for locks. Run each lock speculatively in a hardware
+ * memory transaction implemented by the CPU. When the transaction succeeds
+ * the lock will have executed in parallel without blocking.
+ *
+ * If the transaction aborts (due to memory conflicts or other causes)
+ * eventually fall back to normal locking.
+ *
+ * For spinlocks use paravirt ops to hook in the RTM lock elision.  For
+ * interrupt disabling we also use the pvops to patch in our own code
+ * that avoids aborts. For other locks that are not supported by pvops
+ * use direct hooks.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/percpu.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/elide.h>
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/bit_spinlock.h>
+#include <linux/jump_label.h>
+#include <asm/rtm.h>
+#include <asm/paravirt.h>
+
+/*
+ * We need a software in_tx marker, to answer the question
+ * "Is this an inner nested transaction commit?" inside the transaction.
+ * XTEST unfortunately does not tell us that.
+ *
+ * This is needed to handle
+ *
+ * spin_lock(x)
+ * spin_lock_irqsave(y, flags)
+ * spin_unlock(y)    // no _irqrestore
+ * spin_unlock(x)
+ * ... code that relies on interrupts disabled ...
+ * local_irq_restore(flags)
+ *
+ * If the outermost spin_lock has the irqsave there is no problem
+ * because we just disable/reenable interrupts outside the transaction.
+ * But we cannot do that for a nested spin lock, because disabling
+ * interrupts would abort. Normally we don't need to disable
+ * interrupts in a transaction anyways because any interrupt aborts.
+ * But there's no way to atomically disable the interrupts on
+ * unlock/commit and keep them disabled after the transaction.
+ *
+ * The current solution is to detect the non matched unlock and abort
+ * (and fix code which does that frequently). This needs the software
+ * in_tx counter.
+ */
+
+static DEFINE_PER_CPU(int, in_tx);
+static DEFINE_PER_CPU(bool, cli_elided);
+
+#define start_in_tx() __this_cpu_inc(in_tx)
+#define end_in_tx() __this_cpu_dec(in_tx)
+#define is_in_tx() __this_cpu_read(in_tx)
+
+static struct static_key spinlock_elision = STATIC_KEY_INIT_TRUE;
+module_param(spinlock_elision, static_key, 0644);
+
+static int rtm_spin_trylock(struct arch_spinlock *lock)
+{
+	if (elide_lock(spinlock_elision, !__ticket_spin_is_locked(lock)))
+		return 1;
+	return __ticket_spin_trylock(lock);
+}
+
+static inline void rtm_spin_lock(struct arch_spinlock *lock)
+{
+	if (!elide_lock(spinlock_elision, !__ticket_spin_is_locked(lock)))
+		__ticket_spin_lock(lock);
+}
+
+static void rtm_spin_lock_flags(struct arch_spinlock *lock, unsigned long flags)
+{
+	rtm_spin_lock(lock);
+}
+
+static inline void
+rtm_spin_unlock_check(struct arch_spinlock *lock, bool not_enabling)
+{
+	/*
+	 * Note when you get a #GP here this usually means that you
+	 * unlocked a lock that was not locked. Please fix your code.
+	 */
+	if (!__ticket_spin_is_locked(lock)) {
+		/*
+		 * Unlock without restoring interrupts without restoring
+		 * interrupts that were disabled nested.
+		 * In this case we have to abort.
+		 */
+		if (not_enabling && this_cpu_read(cli_elided) &&
+		    this_cpu_read(in_tx) == 1)
+			_xabort(0xfc);
+		end_in_tx();
+		_xend();
+	} else
+		__ticket_spin_unlock(lock);
+}
+
+static void rtm_spin_unlock(struct arch_spinlock *lock)
+{
+	rtm_spin_unlock_check(lock, true);
+}
+
+static void rtm_spin_unlock_flags(struct arch_spinlock *lock,
+				  unsigned long flags)
+{
+	rtm_spin_unlock_check(lock, !(flags & X86_EFLAGS_IF));
+	local_irq_restore(flags);
+}
+
+static void rtm_spin_unlock_irq(struct arch_spinlock *lock)
+{
+	rtm_spin_unlock_check(lock, false);
+	local_irq_enable();
+}
+
+static int rtm_spin_is_locked(struct arch_spinlock *lock)
+{
+	/*
+	 * Cannot tell reliably if the lock is locked or not
+	 * when we're in a transaction. So abort instead.
+	 */
+	_xabort(0xfe);
+	return __ticket_spin_is_locked(lock);
+}
+
+/*
+ * rwlocks: both readers and writers freely speculate.
+ * This uses direct calls with static patching, not pvops.
+ */
+
+__read_mostly bool rwlock_elision = true;
+module_param(rwlock_elision, bool, 0644);
+
+void rtm_read_lock(arch_rwlock_t *rw)
+{
+	/*
+	 * Abort when there is a writer.
+	 * In principle we don't care about readers here,
+	 * but since they are on the same cache line they
+	 * would abort anyways.
+	 */
+
+	if (!elide_lock(rwlock_elision, !arch_rwlock_is_locked(rw)))
+		arch_do_read_lock(rw);
+}
+EXPORT_SYMBOL(rtm_read_lock);
+
+static inline void rtm_read_unlock_check(arch_rwlock_t *rw, bool not_enabling)
+{
+	/*
+	 * Note when you get a #GP here this usually means that you
+	 * unlocked a lock that was not locked. Please fix your code.
+	 */
+	if (!arch_rwlock_is_locked(rw)) {
+		if (not_enabling && this_cpu_read(cli_elided) &&
+		    this_cpu_read(in_tx) == 1)
+			_xabort(0xfd);
+		end_in_tx();
+		_xend();
+	} else
+		arch_do_read_unlock(rw);
+}
+
+void rtm_read_unlock(arch_rwlock_t *rw)
+{
+	rtm_read_unlock_check(rw, true);
+}
+EXPORT_SYMBOL(rtm_read_unlock);
+
+void rtm_read_unlock_irq(arch_rwlock_t *rw)
+{
+	rtm_read_unlock_check(rw, false);
+	local_irq_enable();
+}
+EXPORT_SYMBOL(rtm_read_unlock_irq);
+
+void rtm_read_unlock_irqrestore(arch_rwlock_t *rw, unsigned long flags)
+{
+	rtm_read_unlock_check(rw, !(flags & X86_EFLAGS_IF));
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(rtm_read_unlock_irqrestore);
+
+int rtm_read_trylock(arch_rwlock_t *rw)
+{
+	if (elide_lock(rwlock_elision, !arch_rwlock_is_locked(rw)))
+		return 1;
+	return arch_do_read_trylock(rw);
+}
+EXPORT_SYMBOL(rtm_read_trylock);
+
+void rtm_write_lock(arch_rwlock_t *rw)
+{
+	if (!elide_lock(rwlock_elision, !arch_write_can_lock(rw)))
+		arch_do_write_lock(rw);
+}
+EXPORT_SYMBOL(rtm_write_lock);
+
+static inline void rtm_write_unlock_check(arch_rwlock_t *rw, bool not_enabling)
+{
+	/*
+	 * Note when you get a #GP here this usually means that you
+	 * unlocked a lock that was not locked. Please fix your code.
+	 */
+	if (!arch_rwlock_is_locked(rw)) {
+		if (not_enabling && this_cpu_read(cli_elided) &&
+		    this_cpu_read(in_tx) == 1)
+			_xabort(0xfd);
+		end_in_tx();
+		_xend();
+	} else
+		arch_do_write_unlock(rw);
+}
+
+void rtm_write_unlock(arch_rwlock_t *rw)
+{
+	rtm_write_unlock_check(rw, true);
+}
+EXPORT_SYMBOL(rtm_write_unlock);
+
+void rtm_write_unlock_irq(arch_rwlock_t *rw)
+{
+	rtm_write_unlock_check(rw, false);
+	local_irq_enable();
+}
+EXPORT_SYMBOL(rtm_write_unlock_irq);
+
+void rtm_write_unlock_irqrestore(arch_rwlock_t *rw, unsigned long flags)
+{
+	rtm_write_unlock_check(rw, !(flags & X86_EFLAGS_IF));
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(rtm_write_unlock_irqrestore);
+
+/*
+ * This should be in the headers for inlining, but include loop hell
+ * prevents it.
+ */
+
+inline int __elide_lock(void)
+{
+	if (!txn_disabled() && _xbegin() == _XBEGIN_STARTED) {
+		start_in_tx();
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(__elide_lock);
+
+inline void __elide_unlock(void)
+{
+	/*
+	 * Note when you get a #GP here this usually means that you
+	 * unlocked a lock that was not locked. Please fix your code.
+	 */
+	end_in_tx();
+	_xend();
+}
+EXPORT_SYMBOL(__elide_unlock);
+
+
+/*
+ * CLI aborts, so avoid it inside transactions
+ *
+ * Could also turn non txn cli into transactions?
+ */
+
+static void rtm_restore_fl(unsigned long flags)
+{
+	if (flags & X86_EFLAGS_IF)
+		this_cpu_write(cli_elided, false);
+	if (!_xtest())
+		native_restore_fl(flags);
+}
+PV_CALLEE_SAVE_REGS_THUNK(rtm_restore_fl);
+
+static void rtm_irq_disable(void)
+{
+	if (!_xtest())
+		native_irq_disable();
+	else if (native_save_fl() & X86_EFLAGS_IF)
+		this_cpu_write(cli_elided, true);
+}
+PV_CALLEE_SAVE_REGS_THUNK(rtm_irq_disable);
+
+static void rtm_irq_enable(void)
+{
+	if (!_xtest())
+		native_irq_enable();
+	this_cpu_write(cli_elided, false);
+}
+PV_CALLEE_SAVE_REGS_THUNK(rtm_irq_enable);
+
+static unsigned rtm_patch(u8 type, u16 clobbers, void *ibuf,
+			  unsigned long addr, unsigned len)
+{
+	switch (type) {
+	case PARAVIRT_PATCH(pv_irq_ops.irq_enable):
+	case PARAVIRT_PATCH(pv_irq_ops.irq_disable):
+	case PARAVIRT_PATCH(pv_irq_ops.restore_fl):
+		return paravirt_patch_default(type, clobbers, ibuf, addr, len);
+	default:
+		return native_patch(type, clobbers, ibuf, addr, len);
+	}
+}
+
+void init_rtm_spinlocks(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_RTM))
+		return;
+
+	if (strcmp(pv_info.name, "bare hardware")) {
+		pr_info("No TSX lock elision because of conflicting paravirt ops\n");
+		return;
+	}
+
+	pr_info("Enabling TSX based elided spinlocks\n");
+	pv_info.name = "rtm locking";
+	/* spin_is_contended will lie now */
+	pv_lock_ops.spin_lock = rtm_spin_lock;
+	pv_lock_ops.spin_lock_flags = rtm_spin_lock_flags;
+	pv_lock_ops.spin_trylock = rtm_spin_trylock;
+	pv_lock_ops.spin_unlock = rtm_spin_unlock;
+	pv_lock_ops.spin_unlock_flags = rtm_spin_unlock_flags;
+	pv_lock_ops.spin_unlock_irq = rtm_spin_unlock_irq;
+	pv_lock_ops.spin_is_locked = rtm_spin_is_locked;
+
+	pv_irq_ops.irq_disable = PV_CALLEE_SAVE(rtm_irq_disable);
+	pv_irq_ops.irq_enable = PV_CALLEE_SAVE(rtm_irq_enable);
+	pv_irq_ops.restore_fl = PV_CALLEE_SAVE(rtm_restore_fl);
+	pv_init_ops.patch = rtm_patch;
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..a888c48 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1101,6 +1101,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_crashkernel();
 
 	vsmp_init();
+	init_rtm_spinlocks();
 
 	io_delay_init();
 
-- 
1.7.7.6

