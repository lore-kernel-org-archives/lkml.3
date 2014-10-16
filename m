Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaJPSLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:11:09 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:51348 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaJPSLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:11:03 -0400
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
        Douglas Hatch <doug.hatch@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v12 02/11] qspinlock, x86: Enable x86-64 to use queue spinlock
Date: Thu, 16 Oct 2014 14:10:31 -0400
Message-Id: <1413483040-58399-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the necessary changes at the x86 architecture
specific layer to enable the use of queue spinlock for x86-64. As
x86-32 machines are typically not multi-socket. The benefit of queue
spinlock may not be apparent. So queue spinlock is not enabled.

Currently, there is some incompatibilities between the para-virtualized
spinlock code (which hard-codes the use of ticket spinlock) and the
queue spinlock. Therefore, the use of queue spinlock is disabled when
the para-virtualized spinlock is enabled.

The arch/x86/include/asm/qspinlock.h header file includes some x86
specific optimization which will make the queue spinlock code perform
better than the generic implementation.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/qspinlock.h      |   25 +++++++++++++++++++++++++
 arch/x86/include/asm/spinlock.h       |    5 +++++
 arch/x86/include/asm/spinlock_types.h |    4 ++++
 4 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/qspinlock.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fad4aa6..da42708 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -123,6 +123,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select ARCH_USE_BUILTIN_BSWAP
+	select ARCH_USE_QUEUE_SPINLOCK
 	select ARCH_USE_QUEUE_RWLOCK
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
new file mode 100644
index 0000000..a6a8762
--- /dev/null
+++ b/arch/x86/include/asm/qspinlock.h
@@ -0,0 +1,25 @@
+#ifndef _ASM_X86_QSPINLOCK_H
+#define _ASM_X86_QSPINLOCK_H
+
+#include <asm-generic/qspinlock_types.h>
+
+#ifndef CONFIG_X86_PPRO_FENCE
+
+#define	queue_spin_unlock queue_spin_unlock
+/**
+ * queue_spin_unlock - release a queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ *
+ * An effective smp_store_release() on the least-significant byte.
+ */
+static inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	barrier();
+	ACCESS_ONCE(*(u8 *)lock) = 0;
+}
+
+#endif /* !CONFIG_X86_PPRO_FENCE */
+
+#include <asm-generic/qspinlock.h>
+
+#endif /* _ASM_X86_QSPINLOCK_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 9295016..5899483 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -42,6 +42,10 @@
 extern struct static_key paravirt_ticketlocks_enabled;
 static __always_inline bool static_key_false(struct static_key *key);
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+#include <asm/qspinlock.h>
+#else
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
@@ -180,6 +184,7 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 {
 	arch_spin_lock(lock);
 }
+#endif /* CONFIG_QUEUE_SPINLOCK */
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 5f9d757..5d654a1 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -23,6 +23,9 @@ typedef u32 __ticketpair_t;
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+#include <asm-generic/qspinlock_types.h>
+#else
 typedef struct arch_spinlock {
 	union {
 		__ticketpair_t head_tail;
@@ -33,6 +36,7 @@ typedef struct arch_spinlock {
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
+#endif /* CONFIG_QUEUE_SPINLOCK */
 
 #include <asm-generic/qrwlock_types.h>
 
-- 
1.7.1

