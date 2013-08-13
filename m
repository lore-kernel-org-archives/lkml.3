Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3HMSmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:42:10 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21413 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434Ab3HMSlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:41:51 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH RFC v2 2/2] qspinlock x86: Enable x86 to use queue spinlock
Date: Tue, 13 Aug 2013 14:41:07 -0400
Message-Id: <1376419267-17663-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1376419267-17663-1-git-send-email-Waiman.Long@hp.com>
References: <1376419267-17663-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the necessary changes at the x86 architecture specific
layer to enable the presence of the CONFIG_QSPINLOCK kernel option
which can be used to replace the ticket spinlock by the queue spinlock.

The turning on of ARCH_QSPINLOCK config option does not mean that the
ticket spinlock will be replaced. It only means that the architecture
supports the replacement. Actual replacement will only happen if the
QSPINLOCK config option is also set.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/Kconfig                      |    3 +++
 arch/x86/include/asm/spinlock.h       |    2 ++
 arch/x86/include/asm/spinlock_types.h |    4 ++++
 arch/x86/kernel/paravirt-spinlocks.c  |   10 ++++++++++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..c70db51 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2344,6 +2344,9 @@ config X86_DMA_REMAP
 	bool
 	depends on STA2X11
 
+config ARCH_QSPINLOCK
+	def_bool y
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 33692ea..d55decf 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -34,6 +34,7 @@
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+#ifndef CONFIG_QSPINLOCK
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -130,6 +131,7 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 }
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+#endif	/* !CONFIG_QSPINLOCK */
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index ad0ad07..e030e20 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -7,6 +7,9 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_QSPINLOCK
+# include <asm-generic/qspinlock.h>
+#else
 #if (CONFIG_NR_CPUS < 256)
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
@@ -27,6 +30,7 @@ typedef struct arch_spinlock {
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
+#endif
 
 #include <asm/rwlock.h>
 
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 676b8c7..4bcca15 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -15,6 +15,15 @@ default_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
+# ifdef CONFIG_QSPINLOCK
+	.spin_is_locked = queue_spin_is_locked,
+	.spin_is_contended = queue_spin_is_contended,
+
+	.spin_lock = queue_spin_lock,
+	.spin_lock_flags = default_spin_lock_flags,
+	.spin_trylock = queue_spin_trylock,
+	.spin_unlock = queue_spin_unlock,
+# else
 	.spin_is_locked = __ticket_spin_is_locked,
 	.spin_is_contended = __ticket_spin_is_contended,
 
@@ -22,6 +31,7 @@ struct pv_lock_ops pv_lock_ops = {
 	.spin_lock_flags = default_spin_lock_flags,
 	.spin_trylock = __ticket_spin_trylock,
 	.spin_unlock = __ticket_spin_unlock,
+# endif
 #endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
-- 
1.7.1

