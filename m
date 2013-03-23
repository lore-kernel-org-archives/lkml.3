Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423174Ab3CWB2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:28:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:62847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549Ab3CWBZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455608"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, jeremy@goop.org
Subject: [PATCH 11/29] x86, paravirt: Add support for arch_spin_unlock_flags/irq
Date: Fri, 22 Mar 2013 18:25:05 -0700
Message-Id: <1364001923-10796-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for arch_spin_unlock_flags/irq

Only done for the paravirt case, non paravirt just uses the wrappers
in the upper level code.

Cc: jeremy@goop.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/paravirt.h       |   13 +++++++++++++
 arch/x86/include/asm/paravirt_types.h |    3 +++
 arch/x86/kernel/paravirt-spinlocks.c  |   16 ++++++++++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5edd174..3d5a0b1 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -745,6 +745,19 @@ static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
 	PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
 }
 
+static __always_inline void arch_spin_unlock_flags(struct arch_spinlock *lock,
+						   unsigned long flags)
+{
+	PVOP_VCALL2(pv_lock_ops.spin_unlock_flags, lock, flags);
+}
+
+static __always_inline void arch_spin_unlock_irq(struct arch_spinlock *lock)
+{
+	PVOP_VCALL1(pv_lock_ops.spin_unlock_irq, lock);
+}
+
+#define ARCH_HAS_SPIN_UNLOCK_IRQ 1
+
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 142236e..b428393 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -333,6 +333,9 @@ struct pv_lock_ops {
 	void (*spin_lock_flags)(struct arch_spinlock *lock, unsigned long flags);
 	int (*spin_trylock)(struct arch_spinlock *lock);
 	void (*spin_unlock)(struct arch_spinlock *lock);
+	void (*spin_unlock_flags)(struct arch_spinlock *lock,
+				  unsigned long flags);
+	void (*spin_unlock_irq)(struct arch_spinlock *lock);
 };
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 676b8c7..c41fc8c 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -13,6 +13,20 @@ default_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 	arch_spin_lock(lock);
 }
 
+static void
+default_spin_unlock_flags(arch_spinlock_t *lock, unsigned long flags)
+{
+	arch_spin_unlock(lock);
+	local_irq_restore(flags);
+}
+
+static inline void
+default_spin_unlock_irq(arch_spinlock_t *lock)
+{
+	arch_spin_unlock(lock);
+	local_irq_enable();
+}
+
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
 	.spin_is_locked = __ticket_spin_is_locked,
@@ -22,6 +36,8 @@ struct pv_lock_ops pv_lock_ops = {
 	.spin_lock_flags = default_spin_lock_flags,
 	.spin_trylock = __ticket_spin_trylock,
 	.spin_unlock = __ticket_spin_unlock,
+	.spin_unlock_irq = default_spin_unlock_flags,
+	.spin_unlock_flags = default_spin_unlock_irq,
 #endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
-- 
1.7.7.6

