Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaCJQEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:04:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaCJQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:02:35 -0400
Message-Id: <20140310155543.483195157@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Mar 2014 16:42:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com,
        Waiman Long <Waiman.Long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 2/7] qspinlock, x86: Enable x86 to use queue spinlock
References: <20140310154236.038181843@infradead.org>
Content-Disposition: inline; filename=waiman_long-qspinlock_x86-enable_x86-64_to_use_queue_spinlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the necessary changes at the x86 architecture
specific layer to enable the use of queue spinlock for x86.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/qspinlock.h      |   29 +++++++++++++++++++++++++++++
 arch/x86/include/asm/spinlock.h       |    5 +++++
 arch/x86/include/asm/spinlock_types.h |    4 ++++
 4 files changed, 39 insertions(+)
 create mode 100644 arch/x86/include/asm/qspinlock.h

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -128,6 +128,7 @@ config X86
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 	select HAVE_CC_STACKPROTECTOR
+	select ARCH_USE_QUEUE_SPINLOCK
 
 config INSTRUCTION_DECODER
 	def_bool y
--- /dev/null
+++ b/arch/x86/include/asm/qspinlock.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_X86_QSPINLOCK_H
+#define _ASM_X86_QSPINLOCK_H
+
+#include <asm-generic/qspinlock_types.h>
+
+#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
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
+	barrier();
+	ACCESS_ONCE(*(u8 *)lock) = 0;
+	barrier();
+}
+
+#endif /* !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE */
+
+#include <asm-generic/qspinlock.h>
+
+#endif /* _ASM_X86_QSPINLOCK_H */
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
@@ -181,6 +185,7 @@ static __always_inline void arch_spin_lo
 {
 	arch_spin_lock(lock);
 }
+#endif /* CONFIG_QUEUE_SPINLOCK */
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
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
 
 #ifdef CONFIG_QUEUE_RWLOCK
 #include <asm/qrwlock.h>


