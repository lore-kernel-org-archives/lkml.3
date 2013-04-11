Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab3DKAbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:31:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36479 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934913Ab3DKAbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:31:32 -0400
Date: Wed, 10 Apr 2013 17:30:32 -0700
From: tip-bot for Boris Ostrovsky <tipbot@zytor.com>
Message-ID: <tip-511ba86e1d386f671084b5d0e6f110bb30b8eeb2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, jwboyer@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, jwboyer@redhat.com,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1364045796-10720-2-git-send-email-konrad.wilk@oracle.com>
References: <1364045796-10720-2-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm: Patch out arch_flush_lazy_mmu_mode()
  when running on bare metal
Git-Commit-ID: 511ba86e1d386f671084b5d0e6f110bb30b8eeb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 17:30:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  511ba86e1d386f671084b5d0e6f110bb30b8eeb2
Gitweb:     http://git.kernel.org/tip/511ba86e1d386f671084b5d0e6f110bb30b8eeb2
Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
AuthorDate: Sat, 23 Mar 2013 09:36:36 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 10 Apr 2013 11:25:10 -0700

x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal

Invoking arch_flush_lazy_mmu_mode() results in calls to
preempt_enable()/disable() which may have performance impact.

Since lazy MMU is not used on bare metal we can patch away
arch_flush_lazy_mmu_mode() so that it is never called in such
environment.

[ hpa: the previous patch "Fix vmalloc_fault oops during lazy MMU
  updates" may cause a minor performance regression on
  bare metal.  This patch resolves that performance regression.  It is
  somewhat unclear to me if this is a good -stable candidate. ]

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/1364045796-10720-2-git-send-email-konrad.wilk@oracle.com
Tested-by: Josh Boyer <jwboyer@redhat.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> SEE NOTE ABOVE
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
index 6afbb2c..2f5d687 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2196,6 +2196,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_mmu,
 		.leave = xen_leave_lazy_mmu,
+		.flush = paravirt_flush_lazy_mmu,
 	},
 
 	.set_fixmap = xen_set_fixmap,
