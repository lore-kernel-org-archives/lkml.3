Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3B1W5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:57:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23793 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3B1W5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:57:09 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: hpa@zytor.com, bp@alien8.de
Cc: mingo@redhat.com, tglx@linutronix.de, konrad.wilk@oracle.com,
        rostedt@goodmis.org, gregkh@linuxfoundation.org,
        samu.kallio@aberdeencloud.com, kraman@redhat.com, jwboyer@redhat.com,
        xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
Date: Thu, 28 Feb 2013 17:55:49 -0500
Message-Id: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invoking arch_flush_lazy_mmu_mode() results in calls to
preempt_enable()/disable() which may have performance impact.

Since lazy MMU is not used on bare metal we can patch away
arch_flush_lazy_mmu_mode() so that it is never called in such
environment.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/include/asm/paravirt.h       |  5 ++++-
 arch/x86/include/asm/paravirt_types.h |  2 ++
 arch/x86/kernel/paravirt.c            | 25 +++++++++++++------------
 arch/x86/lguest/boot.c                |  1 +
 arch/x86/xen/mmu.c                    |  1 +
 5 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5edd174..7361e47 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -703,7 +703,10 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	PVOP_VCALL0(pv_mmu_ops.lazy_mode.leave);
 }
 
-void arch_flush_lazy_mmu_mode(void);
+static inline void arch_flush_lazy_mmu_mode(void)
+{
+	PVOP_VCALL0(pv_mmu_ops.lazy_mode.flush);
+}
 
 static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 				phys_addr_t phys, pgprot_t flags)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 142236e..b3b0ec1 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -91,6 +91,7 @@ struct pv_lazy_ops {
 	/* Set deferred update mode, used for batching operations. */
 	void (*enter)(void);
 	void (*leave)(void);
+	void (*flush)(void);
 };
 
 struct pv_time_ops {
@@ -679,6 +680,7 @@ void paravirt_end_context_switch(struct task_struct *next);
 
 void paravirt_enter_lazy_mmu(void);
 void paravirt_leave_lazy_mmu(void);
+void paravirt_flush_lazy_mmu(void);
 
 void _paravirt_nop(void);
 u32 _paravirt_ident_32(u32);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 17fff18..8bfb335 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -263,6 +263,18 @@ void paravirt_leave_lazy_mmu(void)
 	leave_lazy(PARAVIRT_LAZY_MMU);
 }
 
+void paravirt_flush_lazy_mmu(void)
+{
+	preempt_disable();
+
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
+		arch_leave_lazy_mmu_mode();
+		arch_enter_lazy_mmu_mode();
+	}
+
+	preempt_enable();
+}
+
 void paravirt_start_context_switch(struct task_struct *prev)
 {
 	BUG_ON(preemptible());
@@ -292,18 +304,6 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return this_cpu_read(paravirt_lazy_mode);
 }
 
-void arch_flush_lazy_mmu_mode(void)
-{
-	preempt_disable();
-
-	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
-		arch_leave_lazy_mmu_mode();
-		arch_enter_lazy_mmu_mode();
-	}
-
-	preempt_enable();
-}
-
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
@@ -475,6 +475,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.lazy_mode = {
 		.enter = paravirt_nop,
 		.leave = paravirt_nop,
+		.flush = paravirt_nop,
 	},
 
 	.set_fixmap = native_set_fixmap,
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 1cbd89c..7114c63 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1334,6 +1334,7 @@ __init void lguest_init(void)
 	pv_mmu_ops.read_cr3 = lguest_read_cr3;
 	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
 	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mmu_mode;
+	pv_mmu_ops.lazy_mode.flush = paravirt_flush_lazy_mmu;
 	pv_mmu_ops.pte_update = lguest_pte_update;
 	pv_mmu_ops.pte_update_defer = lguest_pte_update;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e8e3493..f4f4105 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2197,6 +2197,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_mmu,
 		.leave = xen_leave_lazy_mmu,
+		.flush = paravirt_flush_lazy_mmu,
 	},
 
 	.set_fixmap = xen_set_fixmap,
-- 
1.8.1.2

