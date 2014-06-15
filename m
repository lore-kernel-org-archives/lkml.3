Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaFONNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:13:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaFONMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:12:08 -0400
Message-Id: <20140615130154.400698797@chello.nl>
User-Agent: quilt/0.61-1
Date: Sun, 15 Jun 2014 14:47:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/11] qspinlock, kvm: Add paravirt support
References: <20140615124657.264658593@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-qspinlock-kvm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/kvm.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/Kconfig.locks  |    2 -
 2 files changed, 59 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/kvm.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kvm.c
+++ linux-2.6/arch/x86/kernel/kvm.c
@@ -569,6 +569,7 @@ static void kvm_kick_cpu(int cpu)
 	kvm_hypercall2(KVM_HC_KICK_CPU, flags, apicid);
 }
 
+#ifndef CONFIG_QUEUE_SPINLOCK
 enum kvm_contention_stat {
 	TAKEN_SLOW,
 	TAKEN_SLOW_PICKUP,
@@ -796,6 +797,51 @@ static void kvm_unlock_kick(struct arch_
 		}
 	}
 }
+#else /* QUEUE_SPINLOCK */
+
+#include <asm-generic/qspinlock.h>
+
+PV_CALLEE_SAVE_REGS_THUNK(__pv_init_node);
+PV_CALLEE_SAVE_REGS_THUNK(__pv_link_and_wait_node);
+PV_CALLEE_SAVE_REGS_THUNK(__pv_kick_node);
+
+PV_CALLEE_SAVE_REGS_THUNK(__pv_wait_head);
+PV_CALLEE_SAVE_REGS_THUNK(__pv_queue_unlock);
+
+void kvm_wait(int *ptr, int val)
+{
+	unsigned long flags;
+
+	if (in_nmi())
+		return;
+
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+
+	/*
+	 * check again make sure it didn't become free while
+	 * we weren't looking.
+	 */
+	if (ACCESS_ONCE(*ptr) != val)
+		goto out;
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
+	local_irq_restore(flags);
+}
+#endif /* QUEUE_SPINLOCK */
 
 /*
  * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
@@ -808,8 +854,20 @@ void __init kvm_spinlock_init(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return;
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+	pv_lock_ops.init_node = PV_CALLEE_SAVE(__pv_init_node);
+	pv_lock_ops.link_and_wait_node = PV_CALLEE_SAVE(__pv_link_and_wait_node);
+	pv_lock_ops.kick_node = PV_CALLEE_SAVE(__pv_kick_node);
+
+	pv_lock_ops.wait_head = PV_CALLEE_SAVE(__pv_wait_head);
+	pv_lock_ops.queue_unlock = PV_CALLEE_SAVE(__pv_queue_unlock);
+
+	pv_lock_ops.wait = kvm_wait;
+	pv_lock_ops.kick = kvm_kick_cpu;
+#else
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
 	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+#endif
 }
 
 static __init int kvm_spinlock_init_jump(void)
Index: linux-2.6/kernel/Kconfig.locks
===================================================================
--- linux-2.6.orig/kernel/Kconfig.locks
+++ linux-2.6/kernel/Kconfig.locks
@@ -229,7 +229,7 @@ config ARCH_USE_QUEUE_SPINLOCK
 
 config QUEUE_SPINLOCK
 	def_bool y if ARCH_USE_QUEUE_SPINLOCK
-	depends on SMP && !PARAVIRT_SPINLOCKS
+	depends on SMP && !(PARAVIRT_SPINLOCKS && XEN)
 
 config ARCH_USE_QUEUE_RWLOCK
 	bool


