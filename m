Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaBQWqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:46:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaBQWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:46:16 -0500
Date: Mon, 17 Feb 2014 14:46:00 -0800
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-8642749c6ea4a3437ac733341f0c0b83e194b2d6@git.kernel.org>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, Waiman.Long@hp.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        riel@redhat.com, Waiman.Long@hp.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1392669684-4807-3-git-send-email-Waiman.Long@hp.com>
References: <1392669684-4807-3-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] qspinlock, x86:
  Enable x86-64 to use queue spinlock
Git-Commit-ID: 8642749c6ea4a3437ac733341f0c0b83e194b2d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 17 Feb 2014 14:46:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8642749c6ea4a3437ac733341f0c0b83e194b2d6
Gitweb:     http://git.kernel.org/tip/8642749c6ea4a3437ac733341f0c0b83e194b2d6
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Mon, 17 Feb 2014 15:41:23 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 17 Feb 2014 13:44:39 -0800

qspinlock, x86: Enable x86-64 to use queue spinlock

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
Link: http://lkml.kernel.org/r/1392669684-4807-3-git-send-email-Waiman.Long@hp.com
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                      |  1 +
 arch/x86/include/asm/qspinlock.h      | 55 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/spinlock.h       |  5 ++++
 arch/x86/include/asm/spinlock_types.h |  4 +++
 4 files changed, 65 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..de573f9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -17,6 +17,7 @@ config X86_64
 	depends on 64BIT
 	select X86_DEV_DMA_OPS
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_USE_QUEUE_SPINLOCK
 
 ### Arch settings
 config X86
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
new file mode 100644
index 0000000..7316ec4
--- /dev/null
+++ b/arch/x86/include/asm/qspinlock.h
@@ -0,0 +1,55 @@
+#ifndef _ASM_X86_QSPINLOCK_H
+#define _ASM_X86_QSPINLOCK_H
+
+#include <asm-generic/qspinlock_types.h>
+
+#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+
+/*
+ * Queue spinlock union structure to be used within this header file only
+ */
+union qspinlock_x86 {
+	struct qspinlock slock;
+	u8		 lock;	/* Lock bit	*/
+};
+
+#define queue_spin_trylock_unfair queue_spin_trylock_unfair
+/**
+ * queue_spin_trylock_unfair - try to acquire the lock ignoring the qcode
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock_unfair(struct qspinlock *lock)
+{
+	union qspinlock_x86 *qlock = (union qspinlock_x86 *)lock;
+
+	if (!ACCESS_ONCE(qlock->lock) &&
+	   (cmpxchg(&qlock->lock, 0, _QSPINLOCK_LOCKED) == 0))
+		return 1;
+	return 0;
+}
+
+#define	queue_spin_unlock queue_spin_unlock
+/**
+ * queue_spin_unlock - release a queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ *
+ * No special memory barrier other than a compiler one is needed for the
+ * x86 architecture. A compiler barrier is added at the end to make sure
+ * that the clearing the lock bit is done ASAP without artificial delay
+ * due to compiler optimization.
+ */
+static inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	union qspinlock_x86 *qlock = (union qspinlock_x86 *)lock;
+
+	barrier();
+	ACCESS_ONCE(qlock->lock) = 0;
+	barrier();
+}
+
+#endif /* !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE */
+
+#include <asm-generic/qspinlock.h>
+
+#endif /* _ASM_X86_QSPINLOCK_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index bf156de..6e6de1f 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -43,6 +43,10 @@
 extern struct static_key paravirt_ticketlocks_enabled;
 static __always_inline bool static_key_false(struct static_key *key);
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+#include <asm/qspinlock.h>
+#else
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
@@ -181,6 +185,7 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 {
 	arch_spin_lock(lock);
 }
+#endif /* CONFIG_QUEUE_SPINLOCK */
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 4f1bea1..98da00b 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -11,6 +11,9 @@
 #define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
 #endif
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+#include <asm-generic/qspinlock_types.h>
+#else
 #if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
@@ -33,6 +36,7 @@ typedef struct arch_spinlock {
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
+#endif /* CONFIG_QUEUE_SPINLOCK */
 
 #include <asm/rwlock.h>
 
