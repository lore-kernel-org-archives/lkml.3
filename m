Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaESNNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:13:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaESNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:13:30 -0400
Date: Mon, 19 May 2014 06:12:57 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-r1xuzmdysvuhl3h86n5fbxi7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] x86,locking: Enable qrwlock
Git-Commit-ID: 19a3e44df0600750c69d6fdffe7cb26eb3c2cfd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19a3e44df0600750c69d6fdffe7cb26eb3c2cfd5
Gitweb:     http://git.kernel.org/tip/19a3e44df0600750c69d6fdffe7cb26eb3c2cfd5
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Mon, 3 Feb 2014 13:18:57 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:06:01 +0900

x86,locking: Enable qrwlock

Make x86 use the fair rwlock_t.

Implement the custom queue_write_unlock() for best performance.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
[peterz: near complete rewrite]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-r1xuzmdysvuhl3h86n5fbxi7@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig                      |  1 +
 arch/x86/include/asm/paravirt_types.h |  7 +------
 arch/x86/include/asm/qrwlock.h        | 17 +++++++++++++++++
 arch/x86/include/asm/spinlock.h       |  4 ++++
 arch/x86/include/asm/spinlock_types.h |  4 ++++
 5 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..bf7626f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -121,6 +121,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select ARCH_USE_BUILTIN_BSWAP
+	select ARCH_USE_QUEUE_RWLOCK
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7549b8b..3d9c6be 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -326,12 +326,7 @@ struct pv_mmu_ops {
 			   phys_addr_t phys, pgprot_t flags);
 };
 
-struct arch_spinlock;
-#ifdef CONFIG_SMP
-#include <asm/spinlock_types.h>
-#else
-typedef u16 __ticket_t;
-#endif
+#include <linux/spinlock_types.h>
 
 struct pv_lock_ops {
 	struct paravirt_callee_save lock_spinning;
diff --git a/arch/x86/include/asm/qrwlock.h b/arch/x86/include/asm/qrwlock.h
new file mode 100644
index 0000000..70f46f0
--- /dev/null
+++ b/arch/x86/include/asm/qrwlock.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_X86_QRWLOCK_H
+#define _ASM_X86_QRWLOCK_H
+
+#include <asm-generic/qrwlock_types.h>
+
+#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+#define queue_write_unlock queue_write_unlock
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+        barrier();
+        ACCESS_ONCE(*(u8 *)&lock->cnts) = 0;
+}
+#endif
+
+#include <asm-generic/qrwlock.h>
+
+#endif /* _ASM_X86_QRWLOCK_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 0f62f54..54f1c80 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -187,6 +187,7 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 		cpu_relax();
 }
 
+#ifndef CONFIG_QUEUE_RWLOCK
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
@@ -269,6 +270,9 @@ static inline void arch_write_unlock(arch_rwlock_t *rw)
 	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
 		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
 }
+#else
+#include <asm/qrwlock.h>
+#endif /* CONFIG_QUEUE_RWLOCK */
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 4f1bea1..73c4c00 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -34,6 +34,10 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
+#ifdef CONFIG_QUEUE_RWLOCK
+#include <asm-generic/qrwlock_types.h>
+#else
 #include <asm/rwlock.h>
+#endif
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
