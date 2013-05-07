Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab3EGE16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:27:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab3EGE0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:26:00 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PCQpanxj7wIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jYcHjeBbu4AA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=0AWPF2qeU-xyIF9p1esA:9 a=QJx6o7id4AAA:10 a=7DSvI1NPTFQA:10 a=jEp0ucaQiEUA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035850.774067031@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [059/126] x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare
 metal
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0059-x86-mm-Patch-out-arch_flush_lazy_mmu_mode-when-runni.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

[ Upstream commit 511ba86e1d386f671084b5d0e6f110bb30b8eeb2 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/paravirt.h       |    5 ++++-
 arch/x86/include/asm/paravirt_types.h |    2 ++
 arch/x86/kernel/paravirt.c            |   25 +++++++++++++------------
 arch/x86/lguest/boot.c                |    1 +
 arch/x86/xen/mmu.c                    |    1 +
 5 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a0facf3..97da2bb 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -705,7 +705,10 @@ static inline void arch_leave_lazy_mmu_mode(void)
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
index 642d880..53272bd 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1333,6 +1333,7 @@ __init void lguest_init(void)
 	pv_mmu_ops.read_cr3 = lguest_read_cr3;
 	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
 	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mmu_mode;
+	pv_mmu_ops.lazy_mode.flush = paravirt_flush_lazy_mmu;
 	pv_mmu_ops.pte_update = lguest_pte_update;
 	pv_mmu_ops.pte_update_defer = lguest_pte_update;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dde1a3f..d396521 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2079,6 +2079,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_mmu,
 		.leave = xen_leave_lazy_mmu,
+		.flush = paravirt_flush_lazy_mmu,
 	},
 
 	.set_fixmap = xen_set_fixmap,
-- 
1.7.10.4


