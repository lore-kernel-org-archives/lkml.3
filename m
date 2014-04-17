Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaDQPHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:07:53 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43471 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaDQPFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:05:01 -0400
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
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v9 15/19] pvqspinlock, x86: Add PV data structure & methods
Date: Thu, 17 Apr 2014 11:04:07 -0400
Message-Id: <1397747051-15401-16-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the para-virtualization (PV) infrastructure code
of the x86-64 architecture to support the PV queue spinlock. Three
new virtual methods are added to support PV qspinlock:

 1) kick_cpu - schedule in a virtual CPU
 2) halt_cpu - schedule out a virtual CPU
 3) lockstat - update statistical data for debugfs

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/paravirt.h       |   18 +++++++++++++++++-
 arch/x86/include/asm/paravirt_types.h |   17 +++++++++++++++++
 arch/x86/kernel/paravirt-spinlocks.c  |    6 ++++++
 3 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e161..d71e123 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -711,7 +711,23 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 }
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
+#ifdef CONFIG_QUEUE_SPINLOCK
+static __always_inline void __queue_kick_cpu(int cpu)
+{
+	PVOP_VCALL1(pv_lock_ops.kick_cpu, cpu);
+}
+
+static __always_inline void
+__queue_halt_cpu(enum pv_lock_stats type, s8 *state, s8 sval)
+{
+	PVOP_VCALL3(pv_lock_ops.halt_cpu, type, state, sval);
+}
 
+static __always_inline void __queue_lockstat(enum pv_lock_stats type)
+{
+	PVOP_VCALL1(pv_lock_ops.lockstat, type);
+}
+#else
 static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
 							__ticket_t ticket)
 {
@@ -723,7 +739,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
-
+#endif
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7549b8b..549b3a0 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -333,9 +333,26 @@ struct arch_spinlock;
 typedef u16 __ticket_t;
 #endif
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+enum pv_lock_stats {
+	PV_HALT_QHEAD,		/* Queue head halting	    */
+	PV_HALT_QNODE,		/* Other queue node halting */
+	PV_HALT_ABORT,		/* Halting aborted	    */
+	PV_WAKE_KICKED,		/* Wakeup by kicking	    */
+	PV_WAKE_SPURIOUS,	/* Spurious wakeup	    */
+	PV_KICK_NOHALT		/* Kick but CPU not halted  */
+};
+#endif
+
 struct pv_lock_ops {
+#ifdef CONFIG_QUEUE_SPINLOCK
+	void (*kick_cpu)(int cpu);
+	void (*halt_cpu)(enum pv_lock_stats type, s8 *state, s8 sval);
+	void (*lockstat)(enum pv_lock_stats type);
+#else
 	struct paravirt_callee_save lock_spinning;
 	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
+#endif
 };
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 6d36731..8d15bea 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -11,9 +11,15 @@
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
+#ifdef CONFIG_QUEUE_SPINLOCK
+	.kick_cpu = paravirt_nop,
+	.halt_cpu = paravirt_nop,
+	.lockstat = paravirt_nop,
+#else
 	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
 	.unlock_kick = paravirt_nop,
 #endif
+#endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
-- 
1.7.1

